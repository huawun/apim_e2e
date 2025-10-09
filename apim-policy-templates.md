
# Azure API Management Policy Templates

Complete collection of reusable policy templates for advanced API management with versioning, rate limiting, and subscription tiers.

---

## Table of Contents

1. [Rate Limiting Policies](#rate-limiting-policies)
2. [Quota Management Policies](#quota-management-policies)
3. [Tiered Access Control](#tiered-access-control)
4. [Version Routing Policies](#version-routing-policies)
5. [Response Caching Policies](#response-caching-policies)
6. [Authentication & Authorization](#authentication--authorization)
7. [Error Handling & Responses](#error-handling--responses)
8. [Monitoring & Logging](#monitoring--logging)

---

## 1. Rate Limiting Policies

### Basic Rate Limiting

**Description:** Simple rate limiting for all requests

```xml
<policies>
    <inbound>
        <base />
        <!-- Limit to 100 calls per minute -->
        <rate-limit calls="100" renewal-period="60" />
    </inbound>
</policies>
```

### Per-Subscription Rate Limiting

**Description:** Track rate limits per subscription key

```xml
<policies>
    <inbound>
        <base />
        <!-- Rate limit per subscription -->
        <rate-limit-by-key 
            calls="100" 
            renewal-period="60" 
            counter-key="@(context.Subscription?.Id ?? "anonymous")" />
    </inbound>
</policies>
```

### Advanced Rate Limiting with Response Filtering

**Description:** Only count successful responses toward rate limit

```xml
<policies>
    <inbound>
        <base />
        <!-- Only count 2xx responses -->
        <rate-limit-by-key 
            calls="100" 
            renewal-period="60" 
            counter-key="@(context.Subscription.Id)" 
            increment-condition="@(context.Response.StatusCode >= 200 && context.Response.StatusCode < 300)" />
    </inbound>
</policies>
```

### Burst Protection Rate Limiting

**Description:** Allow short bursts but limit sustained load

```xml
<policies>
    <inbound>
        <base />
        <!-- Burst: 50 calls in 10 seconds -->
        <rate-limit-by-key 
            calls="50" 
            renewal-period="10" 
            counter-key="@(context.Subscription.Id + "-burst")" />
        
        <!-- Sustained: 100 calls per minute -->
        <rate-limit-by-key 
            calls="100" 
            renewal-period="60" 
            counter-key="@(context.Subscription.Id + "-sustained")" />
    </inbound>
</policies>
```

---

## 2. Quota Management Policies

### Daily Quota

**Description:** Limit total API calls per day

```xml
<policies>
    <inbound>
        <base />
        <!-- 50,000 calls per day -->
        <quota calls="50000" renewal-period="86400" />
    </inbound>
</policies>
```

### Monthly Quota with Bandwidth Limiting

**Description:** Limit both calls and bandwidth usage

```xml
<policies>
    <inbound>
        <base />
        <!-- 500,000 calls and 10GB per month -->
        <quota 
            calls="500000" 
            bandwidth="10485760" 
            renewal-period="2592000" />
    </inbound>
</policies>
```

### Per-Subscription Quota

**Description:** Track quotas independently per subscription

```xml
<policies>
    <inbound>
        <base />
        <!-- Quota per subscription key -->
        <quota-by-key 
            calls="50000" 
            renewal-period="86400" 
            counter-key="@(context.Subscription.Id)" />
    </inbound>
</policies>
```

### Quota with Grace Period

**Description:** Allow small overage with warning headers

```xml
<policies>
    <inbound>
        <base />
        <quota-by-key 
            calls="50000" 
            renewal-period="86400" 
            counter-key="@(context.Subscription.Id)" />
    </inbound>
    <outbound>
        <base />
        <!-- Add quota headers -->
        <set-header name="X-Quota-Limit" exists-action="override">
            <value>50000</value>
        </set-header>
        <set-header name="X-Quota-Remaining" exists-action="override">
            <value>@{
                var remaining = 50000 - context.Variables.GetValueOrDefault<long>("quota-counter", 0);
                return remaining.ToString();
            }</value>
        </set-header>
        <!-- Warning when 90% used -->
        <choose>
            <when condition="@(context.Variables.GetValueOrDefault<long>("quota-counter", 0) >= 45000)">
                <set-header name="X-Quota-Warning" exists-action="override">
                    <value>Quota nearly exhausted. Upgrade for higher limits.</value>
                </set-header>
            </when>
        </choose>
    </outbound>
</policies>
```

---

## 3. Tiered Access Control

### Complete Tier-Based Policy

**Description:** Comprehensive policy supporting all subscription tiers

```xml
<policies>
    <inbound>
        <base />
        
        <!-- Validate subscription key -->
        <validate-jwt 
            header-name="Authorization" 
            failed-validation-httpcode="401" 
            failed-validation-error-message="Unauthorized. Valid JWT required.">
            <openid-config url="https://login.microsoftonline.com/{tenant}/.well-known/openid-configuration" />
        </validate-jwt>
        
        <!-- Tier-based rate limiting and quotas -->
        <choose>
            <!-- FREE TIER -->
            <when condition="@(context.Product?.Id == "free-tier")">
                <rate-limit-by-key 
                    calls="10" 
                    renewal-period="60" 
                    counter-key="@(context.Subscription.Id)" />
                <quota-by-key 
                    calls="1000" 
                    renewal-period="86400" 
                    counter-key="@(context.Subscription.Id)" />
                <!-- Restrict to public APIs only -->
                <choose>
                    <when condition="@(context.Api.Path.Contains("/internal/"))">
                        <return-response>
                            <set-status code="403" reason="Forbidden" />
                            <set-body>@{
                                return new JObject(
                                    new JProperty("error", "Free tier cannot access internal APIs. Upgrade to Basic or higher.")
                                ).ToString();
                            }</set-body>
                        </return-response>
                    </when>
                </choose>
            </when>
            
            <!-- BASIC TIER -->
            <when condition="@(context.Product?.Id == "basic-tier")">
                <!-- 100 calls per minute + burst -->
                <rate-limit-by-key 
                    calls="200" 
                    renewal-period="10" 
                    counter-key="@(context.Subscription.Id + "-burst")" />
                <rate-limit-by-key 
                    calls="100" 
                    renewal-period="60" 
                    counter-key="@(context.Subscription.Id)" />
                <quota-by-key 
                    calls="50000" 
                    renewal-period="86400" 
                    counter-key="@(context.Subscription.Id)" />
            </when>
            
            <!-- STANDARD TIER -->
            <when condition="@(context.Product?.Id == "standard-tier")">
                <!-- 500 calls per minute + burst -->
                <rate-limit-by-key 
                    calls="1500" 
                    renewal-period="30" 
                    counter-key="@(context.Subscription.Id + "-burst")" />
                <rate-limit-by-key 
                    calls="500" 
                    renewal-period="60" 
                    counter-key="@(context.Subscription.Id)" />
                <quota-by-key 
                    calls="500000" 
                    renewal-period="86400" 
                    counter-key="@(context.Subscription.Id)" />
            </when>
            
            <!-- PREMIUM TIER -->
            <when condition="@(context.Product?.Id == "premium-tier")">
                <!-- 2000 calls per minute + large burst -->
                <rate-limit-by-key 
                    calls="10000" 
                    renewal-period="60" 
                    counter-key="@(context.Subscription.Id + "-burst")" />
                <rate-limit-by-key 
                    calls="2000" 
                    renewal-period="60" 
                    counter-key="@(context.Subscription.Id)" />
                <quota-by-key 
                    calls="5000000" 
                    renewal-period="86400" 
                    counter-key="@(context.Subscription.Id)" />
            </when>
            
            <!-- ENTERPRISE TIER -->
            <when condition="@(context.Product?.Id == "enterprise-tier")">
                <!-- Custom limits - very high -->
                <rate-limit-by-key 
                    calls="10000" 
                    renewal-period="60" 
                    counter-key="@(context.Subscription.Id)" />
                <!-- No daily quota or very high quota -->
            </when>
            
            <!-- DEFAULT (No valid product) -->
            <otherwise>
                <return-response>
                    <set-status code="403" reason="Forbidden" />
                    <set-body>@{
                        return new JObject(
                            new JProperty("error", "No valid subscription. Please subscribe to a product tier.")
                        ).ToString();
                    }</set-body>
                </return-response>
            </otherwise>
        </choose>
    </inbound>
    
    <outbound>
        <base />
        <!-- Add rate limit headers -->
        <set-header name="X-RateLimit-Tier" exists-action="override">
            <value>@(context.Product?.Id ?? "none")</value>
        </set-header>
    </outbound>
</policies>
```

### Tier Feature Access Control

**Description:** Control feature access based on subscription tier

```xml
<policies>
    <inbound>
        <base />
        
        <!-- Premium features only -->
        <choose>
            <when condition="@(context.Request.Url.Path.Contains("/premium-features/"))">
                <choose>
                    <when condition="@(context.Product?.Id == "premium-tier" || context.Product?.Id == "enterprise-tier")">
                        <!-- Allow access -->
                    </when>
                    <otherwise>
                        <return-response>
                            <set-status code="402" reason="Payment Required" />
                            <set-body>@{
                                return new JObject(
                                    new JProperty("error", "Premium feature access requires Premium or Enterprise tier"),
                                    new JProperty("upgrade_url", "https://developer.company.com/upgrade")
                                ).ToString();
                            }</set-body>
                        </return-response>
                    </otherwise>
                </choose>
            </when>
        </choose>
        
        <!-- Beta features access -->
        <choose>
            <when condition="@(context.Request.Url.Path.Contains("/beta/"))">
                <choose>
                    <when condition="@(context.Product?.Id == "premium-tier" || context.Product?.Id == "enterprise-tier")">
                        <set-header name="X-Beta-Access" exists-action="override">
                            <value>granted</value>
                        </set-header>
                    </when>
                    <otherwise>
                        <return-response>
                            <set-status code="403" reason="Forbidden" />
                            <set-body>Beta features require Premium tier or higher</set-body>
                        </return-response>
                    </otherwise>
                </choose>
            </when>
        </choose>
    </inbound>
</policies>
```

---

## 4. Version Routing Policies

### URL Path Version Routing

**Description:** Route requests based on URL path version

```xml
<policies>
    <inbound>
        <base />
        
        <!-- Extract version from URL path -->
        <set-variable name="api-version" value="@{
            var path = context.Request.Url.Path;
            if (path.Contains("/v1/")) return "v1";
            if (path.Contains("/v2/")) return "v2";
            if (path.Contains("/v3/")) return "v3";
            return "v1"; // default to v1
        }" />
        
        <!-- Route to appropriate backend -->
        <choose>
            <when condition="@(context.Variables.GetValueOrDefault<string>("api-version") == "v1")">
                <set-backend-service base-url="https://api-v1.backend.com" />
            </when>
            <when condition="@(context.Variables.GetValueOrDefault<string>("api-version") == "v2")">
                <set-backend-service base-url="https://api-v2.backend.com" />
            </when>
            <when condition="@(context.Variables.GetValueOrDefault<string>("api-version") == "v3")">
                <set-backend-service base-url="https://api-v3.backend.com" />
            </when>
        </choose>
        
        <!-- Rewrite path to remove version -->
        <rewrite-uri template="@{
            var path = context.Request.Url.Path;
            return path.Replace("/v1/", "/").Replace("/v2/", "/").Replace("/v3/", "/");
        }" />
    </inbound>
    
    <outbound>
        <base />
        <!-- Add version headers -->
        <set-header name="Api-Version" exists-action="override">
            <value>@(context.Variables.GetValueOrDefault<string>("api-version", "v1"))</value>
        </set-header>
        <set-header name="Api-Supported-Versions" exists-action="override">
            <value>v1, v2, v3</value>
        </set-header>
    </outbound>
</policies>
```

### Header-Based Version Routing

**Description:** Route based on Api-Version header

```xml
<policies>
    <inbound>
        <base />
        
        <!-- Get version from header or default to latest -->
        <set-variable name="api-version" value="@{
            return context.Request.Headers.GetValueOrDefault("Api-Version", "2024-01-15");
        }" />
        
        <!-- Route based on version date -->
        <choose>
            <when condition="@{
                var version = context.Variables.GetValueOrDefault<string>("api-version");
                return version.StartsWith("2024-");
            }">
                <set-backend-service base-url="https://api-2024.backend.com" />
            </when>
            <when condition="@{
                var version = context.Variables.GetValueOrDefault<string>("api-version");
                return version.StartsWith("2023-");
            }">
                <set-backend-service base-url="https://api-2023.backend.com" />
                <!-- Add deprecation warning -->
                <set-header name="Api-Deprecated" exists-action="override">
                    <value>true</value>
                </set-header>
                <set-header name="Api-Sunset-Date" exists-action="override">
                    <value>2025-12-31</value>
                </set-header>
            </when>
            <otherwise>
                <!-- Unsupported version -->
                <return-response>
                    <set-status code="400" reason="Bad Request" />
                    <set-body>@{
                        return new JObject(
                            new JProperty("error", "Unsupported API version"),
                            new JProperty("supported_versions", new JArray("2023-*", "2024-*"))
                        ).ToString();
                    }</set-body>
                </return-response>
            </otherwise>
        </choose>
    </inbound>
    
    <outbound>
        <base />
        <set-header name="Api-Version" exists-action="override">
            <value>@(context.Variables.GetValueOrDefault<string>("api-version"))</value>
        </set-header>
    </outbound>
</policies>
```

### Query String Version Routing

**Description:** Support version via query parameter

```xml
<policies>
    <inbound>
        <base />
        
        <!-- Check query string for version -->
        <set-variable name="api-version" value="@{
            return context.Request.Url.Query.GetValueOrDefault("api-version", "v2");
        }" />
        
        <!-- Route appropriately -->
        <choose>
            <when condition="@(context.Variables.GetValueOrDefault<string>("api-version") == "v1")">
                <set-backend-service base-url="https://api-v1.backend.com" />
            </when>
            <when condition="@(context.Variables.GetValueOrDefault<string>("api-version") == "v2")">
                <set-backend-service base-url="https://api-v2.backend.com" />
            </when>
        </choose>
        
        <!-- Remove version from query string before forwarding -->
        <set-query-parameter name="api-version" exists-action="delete" />
    </inbound>
</policies>
```

---

## 5. Response Caching Policies

### Basic Response Caching

**Description:** Cache responses for 5 minutes

```xml
<policies>
    <inbound>
        <base />
        <!-- Cache GET requests for 5 minutes -->
        <cache-lookup vary-by-developer="false" vary-by-developer-groups="false" />
    </inbound>
    
    <outbound>
        <base />
        <cache-store duration="300" />
    </outbound>
</policies>
```

### Tier-Based Caching

**Description:** Different cache durations per tier

```xml
<policies>
    <inbound>
        <base />
        <cache-lookup vary-by-developer="true" vary-by-developer-groups="false" />
    </inbound>
    
    <outbound>
        <base />
        <!-- Cache based on product tier -->
        <choose>
            <when condition="@(context.Product?.Id == "free-tier")">
                <!-- No caching for free tier -->
            </when>
            <when condition="@(context.Product?.Id == "basic-tier")">
                <!-- 5 minutes cache -->
                <cache-store duration="300" />
            </when>
            <when condition="@(context.Product?.Id == "standard-tier")">
                <!-- 15 minutes cache -->
                <cache-store duration="900" />
            </when>
            <when condition="@(context.Product?.Id == "premium-tier" || context.Product?.Id == "enterprise-tier")">
                <!-- 1 hour cache -->
                <cache-store duration="3600" />
            </when>
        </choose>
    </outbound>
</policies>
```

### Advanced Caching with Vary Headers

**Description:** Cache based on multiple factors

```xml
<policies>
    <inbound>
        <base />
        <!-- Cache varies by subscription and query parameters -->
        <cache-lookup 
            vary-by-developer="true" 
            vary-by-developer-groups="false"
            vary-by-query-parameter="page,limit,filter" />
    </inbound>
    
    <outbound>
        <base />
        <!-- Only cache successful responses -->
        <choose>
            <when condition="@(context.Response.StatusCode == 200)">
                <cache-store 
                    duration="600" 
                    caching-mode="public" />
                <!-- Add cache headers -->
                <set-header name="Cache-Control" exists-action="override">
                    <value>public, max-age=600</value>
                </set-header>
                <set-header name="X-Cache" exists-action="override">
                    <value>@(context.Variables.GetValueOrDefault<bool>("cache-hit", false) ? "HIT" : "MISS")</value>
                </set-header>
            </when>
        </choose>
    </outbound>
</policies>
```

---

## 6. Authentication & Authorization

### JWT Validation with Entra ID

**Description:** Validate Azure AD JWT tokens

```xml
<policies>
    <inbound>
        <base />
        <!-- Validate JWT token -->
        <validate-jwt 
            header-name="Authorization" 
            failed-validation-httpcode="401" 
            failed-validation-error-message="Unauthorized access">
            <openid-config url="https://login.microsoftonline.com/{tenant-id}/.well-known/openid-configuration" />
            <audiences>
                <audience>{your-app-client-id}</audience>
            </audiences>
            <issuers>
                <issuer>https://sts.windows.net/{tenant-id}/</issuer>
            </issuers>
            <required-claims>
                <claim name="roles" match="any">
                    <value>API.Read</value>
                    <value>API.Write</value>
                </claim>
            </required-claims>
        </validate-jwt>
    </inbound>
</policies>
```

### Combined Subscription Key and JWT

**Description:** Require both subscription key and valid JWT

```xml
<policies>
    <inbound>
        <base />
        
        <!-- Check subscription key -->
        <check-header name="Ocp-Apim-Subscription-Key" failed-check-httpcode="401" failed-check-error-message="Missing subscription key" />
        
        <!-- Validate JWT -->
        <validate-jwt 
            header-name="Authorization" 
            failed-validation-httpcode="401">
            <openid-config url="https://login.microsoftonline.com/{tenant-id}/.well-known/openid-configuration" />
            <audiences>
                <audience>{your-app-client-id}</audience>
            </audiences>
        </validate-jwt>
        
        <!-- Extract user info -->
        <set-variable name="user-id" value="@(context.Request.Headers.GetValueOrDefault("Authorization","").AsJwt()?.Subject)" />
    </inbound>
</policies>
```

### Role-Based Access Control

**Description:** Control access based on user roles

```xml
<policies>
    <inbound>
        <base />
        
        <validate-jwt header-name="Authorization" failed-validation-httpcode="401">
            <openid-config url="https://login.microsoftonline.com/{tenant-id}/.well-known/openid-configuration" />
        </validate-jwt>
        
        <!-- Check for admin role on write operations -->
        <choose>
            <when condition="@(context.Request.Method != "GET")">
                <validate-jwt header-name="Authorization" failed-validation-httpcode="403" failed-validation-error-message="Insufficient permissions">
                    <openid-config url="https://login.microsoftonline.com/{tenant-id}/.well-known/openid-configuration" />
                    <required-claims>
                        <claim name="roles" match="any">
                            <value>API.Admin</value>
                            <value>API.Write</value>
                        </claim>
                    </required-claims>
                </validate-jwt>
            </when>
        </choose>
    </inbound>
</policies>
```

---

## 7. Error Handling & Responses

### Custom Error Responses

**Description:** Provide consistent error responses

```xml
<policies>
    <on-error>
        <base />
        
        <!-- Handle rate limit exceeded -->
        <choose>
            <when condition="@(context.LastError.Reason == "RateLimitExceeded")">
                <return-response>
                    <set-status code="429" reason="Too Many Requests" />
                    <set-header name="Retry-After" exists-action="override">
                        <value>60</value>
                    </set-header>
                    <set-header name="Content-Type" exists-action="override">
                        <value>application/json</value>
                    </set-header>
                    <set-body>@{
                        return new JObject(
                            new JProperty("error", new JObject(
                                new JProperty("code", "RateLimitExceeded"),
                                new JProperty("message", "Rate limit exceeded. Please wait before making another request."),
                                new JProperty("retry_after_seconds", 60),
                                new JProperty("tier", context.Product?.Id),
                                new JProperty("upgrade_url", "https://developer.company.com/upgrade")
                            ))
                        ).ToString();
                    }</set-body>
                </return-response>
            </when>
            
            <!-- Handle quota exceeded -->
            <when condition="@(context.LastError.Reason == "QuotaExceeded")">
                <return-response>
                    <set-status code="429" reason="Quota Exceeded" />
                    <set-header name="Content-Type" exists-action="override">
                        <value>application/json</value>
                    </set-header>
                    <set-body>@{
                        return new JObject(
                            new JProperty("error", new JObject(
                                new JProperty("code", "QuotaExceeded"),
                                new JProperty("message", "Your quota has been exceeded. Upgrade your plan for higher limits."),
                                new JProperty("tier", context.Product?.Id),
                                new JProperty("reset_date", DateTime.UtcNow.AddDays(1).ToString("yyyy-MM-ddTHH:mm:ssZ")),
                                new JProperty("upgrade_url", "https://developer.company.com/upgrade")
                            ))
                        ).ToString();
                    }</set-body>
                </return-response>
            </when>
            
            <!-- Handle authentication errors -->
            <when condition="@(context.LastError.Reason == "Unauthorized")">
                <return-response>
                    <set-status code="401" reason="Unauthorized" />
                    <set-header name="WWW-Authenticate" exists-action="override">
                        <value>Bearer</value>
                    </set-header>
                    <set-body>@{
                        return new JObject(
                            new JProperty("error", new JObject(
                                new JProperty("code", "Unauthorized"),
                                new JProperty("message", "Authentication required. Please provide valid credentials.")
                            ))
                        ).ToString();
                    }</set-body>
                </return-response>
            </when>
            
            <!-- Default error handler -->
            <otherwise>
                <return-response>
                    <set-status code="500" reason="Internal Server Error" />
                    <set-body>@{
                        return new JObject(
                            new JProperty("error", new JObject(
                                new JProperty("code", "InternalError"),
                                new JProperty("message", "An unexpected error occurred. Please try again later."),
                                new JProperty("trace_id", context.RequestId)
                            ))
                        ).ToString();
                    }</set-body>
                </return-response>
            </otherwise>
        </choose>
    </on-error>
</policies>
```

---

## 8. Monitoring & Logging

### Comprehensive Logging Policy

**Description:** Log all request/response details for analytics

```xml
<policies>
    <inbound>
        <base />
        
        <!-- Log request start -->
        <trace source="api-gateway">
            <message>@{
                return new JObject(
                    new JProperty("event", "request_received"),
                    new JProperty("timestamp", DateTime.UtcNow),
                    new JProperty("request_id", context.RequestId),
                    new JProperty("subscription_id", context.Subscription?.Id),
                    new JProperty("product_tier", context.Product?.Id),
                    new JProperty("method", context.Request.Method),
                    new JProperty("url", context.Request.Url.ToString()),
                    new JProperty("user_agent", context.Request.Headers.GetValueOrDefault("User-Agent", "unknown")),
                    new JProperty("client_ip", context.Request.IpAddress)
                ).ToString();
            }</message>
            <metadata name="event-type" value="request" />
        </trace>
        
        <!-- Set start time -->
        <set-variable name="request-start-time" value="@(DateTime.UtcNow)" />
    </inbound>
    
    <outbound>
        <base />
        
        <!-- Calculate duration -->
        <set-variable name="request-duration" value="@{
            var start = context.Variables.GetValueOrDefault<DateTime>("request-start-time");
            return (DateTime.UtcNow - start).TotalMilliseconds;
        }" />
        
        <!-- Log response -->
        <trace source="api-gateway">
            <message>@{
                return new JObject(
                    new JProperty("event", "response_sent"),
                    new JProperty("timestamp", DateTime.UtcNow),
                    new JProperty("request_id", context.RequestId),
                    new JProperty("subscription_id", context.Subscription?.Id),
                    new JProperty("product_tier", context.Product?.Id),
                    new JProperty("status_code", context.Response.StatusCode),
                    new JProperty("duration_ms", context.Variables.GetValueOrDefault<double>("request-duration")),
                    new JProperty("cache_hit", context.Variables.GetValueOrDefault<bool>("cache-hit", false)),
                    new JProperty("backend_service", context.Variables.GetValueOrDefault<string>("backend-url", "unknown"))
                ).ToString();
            }</message>
            <metadata name="event-type" value="response" />
        </trace>
        
        <!-- Add tracing headers -->
        <set-header name="X-Request-Id" exists-action="override">
            <value>@(context.RequestId)</value>
        </set-header>
        <set-header name="X-Response-Time" exists-action="override">
            <value>@(context.Variables.GetValueOrDefault<double>("request-duration").ToString())ms</value>
        </set-header>
    </outbound>
</policies>
```

### Application Insights Integration

**Description:** Send custom metrics to Application Insights

```xml
<policies>
    <inbound>
        <base />
        <set-variable name="request-start-time" value="@(DateTime.UtcNow)" />
    </inbound>
    
    <outbound>
        <base />
        
        <!-- Send custom event to Application Insights -->
        <log-to-eventhub logger-id="application-insights-logger">
            @{
                var duration = (DateTime.UtcNow - context.Variables.GetValueOrDefault<DateTime>("request-start-time")).TotalMilliseconds;
                
                return new JObject(
                    new JProperty("event_name", "api_request"),
                    new JProperty("timestamp", DateTime.UtcNow),
                    new JProperty("properties", new JObject(
                        new JProperty("subscription_id", context.Subscription?.Id),
                        new JProperty("product_tier", context.Product?.Id),
                        new JProperty("api_name", context.Api.Name),
                        new JProperty("operation_name", context.Operation.Name),
                        new JProperty("method", context.Request.Method),
                        new JProperty("status_code", context.Response.StatusCode),
                        new JProperty("client_ip", context.Request.IpAddress)
                    )),
                    new JProperty("metrics",
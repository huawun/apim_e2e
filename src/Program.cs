using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Identity.Web;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;

var builder = WebApplication.CreateBuilder(args);

// Add Azure AD authentication
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddMicrosoftIdentityWebApi(builder.Configuration.GetSection("AzureAd"));

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add Key Vault client
var keyVaultUrl = builder.Configuration["KEY_VAULT_URL"];
if (!string.IsNullOrEmpty(keyVaultUrl))
{
    builder.Services.AddSingleton(new SecretClient(new Uri(keyVaultUrl), new DefaultAzureCredential()));
}

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();

// Health check endpoint
app.MapGet("/health", () => Results.Ok(new { status = "healthy", timestamp = DateTime.UtcNow }));

// Protected API endpoint
app.MapGet("/api/user", async (HttpContext context, SecretClient? secretClient) =>
{
    var user = context.User;
    var result = new
    {
        authenticated = user.Identity?.IsAuthenticated ?? false,
        name = user.Identity?.Name,
        claims = user.Claims.Select(c => new { c.Type, c.Value }).ToList(),
        timestamp = DateTime.UtcNow
    };
    
    return Results.Ok(result);
}).RequireAuthorization();

app.MapControllers();

app.Run();
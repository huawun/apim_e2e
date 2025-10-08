FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["apim-e2e-app.csproj", "."]
RUN dotnet restore "apim-e2e-app.csproj"
COPY . .
WORKDIR "/src"
RUN dotnet build "apim-e2e-app.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "apim-e2e-app.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "apim-e2e-app.dll"]
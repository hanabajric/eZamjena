FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5238
ENV ASPNETCORE_URLS=http://+:5238

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . .
COPY .env /app/

FROM build AS publish
RUN dotnet publish "eZamjena/eZamjena.csproj" -c Release -o /app
# Adjust the path to correctly locate the setup.sql file
RUN mkdir -p /app/Script && cp /src/eZamjena/Script/script_new.sql /app/Script/

FROM base AS final
WORKDIR /app
COPY --from=publish /app .

ENTRYPOINT ["dotnet", "eZamjena.dll"]

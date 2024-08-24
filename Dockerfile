# Koristimo .NET 6.0 runtime za pokretanje aplikacije
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5238
ENV ASPNETCORE_URLS=http://+:5238

# Koristimo .NET 6.0 SDK za izgradnju aplikacije
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Kopiramo sve fajlove iz solucije
COPY . .

# Vršimo izgradnju i objavljivanje glavnog projekta (eZamjena.csproj)
FROM build AS publish
RUN dotnet publish "eZamjena/eZamjena.csproj" -c Release -o /app

# Konačni sloj koji pokreće aplikaciju
FROM base AS final
WORKDIR /app
COPY --from=publish /app .

# Ulazna tačka za pokretanje .NET aplikacije
ENTRYPOINT ["dotnet", "eZamjena.dll"]

# See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Kopiramo .csproj fajlove i vršimo restore da bismo skinuli dependencije
COPY ["eZamjena/eZamjena.csproj", "eZamjena/"]
COPY ["eZamjena.Model/eZamjena.Model.csproj", "eZamjena.Model/"]
COPY ["eZamjena.Services/eZamjena.Services.csproj", "eZamjena.Services/"]

# Postavljamo radni direktorijum na eZamjena
WORKDIR /src/eZamjena
RUN dotnet restore "./eZamjena.csproj"

# Kopiramo sve ostale fajlove i vršimo build
COPY . .
RUN dotnet build "eZamjena.csproj" -c Release -o /app/build_output

FROM build AS publish
RUN dotnet publish "eZamjena.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "eZamjena.dll"]

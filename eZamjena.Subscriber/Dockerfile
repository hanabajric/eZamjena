FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

# Install curl for debugging
RUN apt-get update && apt-get install -y curl

# Expose SMTP port for sending emails
EXPOSE 587

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["eZamjena.Subscriber/eZamjena.Subscriber.csproj", "eZamjena.Subscriber/"]
COPY ["eZamjena/eZamjena.csproj", "eZamjena/"]
COPY ["eZamjena.Model/eZamjena.Model.csproj", "eZamjena.Model/"]
COPY ["eZamjena.Services/eZamjena.Services.csproj", "eZamjena.Services/"]
RUN dotnet restore "eZamjena.Subscriber/eZamjena.Subscriber.csproj"
COPY . .
WORKDIR "/src/eZamjena.Subscriber"
RUN dotnet build "eZamjena.Subscriber.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "eZamjena.Subscriber.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Kopiraj Templates direktorijum iz eZamjena.Services u /app/Templates unutar kontejnera
COPY ./eZamjena.Subscriber/Templates /app/Templates

ENTRYPOINT ["dotnet", "eZamjena.Subscriber.dll"]
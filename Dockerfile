# Koristimo osnovni image za .NET SDK
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Postavljanje radnog direktorijuma
WORKDIR /src

# Kopiramo .csproj fajlove i vršimo restore da bismo skinuli dependencije
COPY ["eZamjena/eZamjena.csproj", "eZamjena/"]
COPY ["eZamjena.Model/eZamjena.Model.csproj", "eZamjena.Model/"]
COPY ["eZamjena.Services/eZamjena.Services.csproj", "eZamjena.Services/"]

# Vršimo restore dependencija
RUN dotnet restore "eZamjena/eZamjena.csproj"

# Kopiramo sve ostale fajlove, uključujući slike
COPY . .

# Provera da li su slike kopirane na pravo mesto
RUN if [ -f "/src/eZamjena.Services/Image/4289718-200.png" ]; then echo "Slika 4289718-200.png pronađena"; else echo "Slika 4289718-200.png nije pronađena"; fi
RUN if [ -f "/src/eZamjena.Services/Image/default-image-300x169.png" ]; then echo "Slika default-image-300x169.png pronađena"; else echo "Slika default-image-300x169.png nije pronađena"; fi
RUN if [ -f "/src/eZamjena.Services/Image/generic-user-icon-10.jpg" ]; then echo "Slika generic-user-icon-10.jpg pronađena"; else echo "Slika generic-user-icon-10.jpg nije pronađena"; fi


# Vršimo build
WORKDIR /src/eZamjena
RUN dotnet build "eZamjena.csproj" -c Release -o /app/build_output

# Publikovanje projekta
RUN dotnet publish "eZamjena.csproj" -c Release -o /app/publish

# Konačni sloj koji pokreće aplikaciju
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Ulazna tačka za pokretanje .NET aplikacije
ENTRYPOINT ["dotnet", "eZamjena.dll"]

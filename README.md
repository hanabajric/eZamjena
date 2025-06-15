# eRazmjena - R2 seminarski rad

Aplikacija eZamjena omogućava korisnicima da razmjenjuju proizvode koje više ne koriste i pronalaze druge artikle u sličnom cjenovnom rangu. Korisnici također imaju opciju kupovine proizvoda ukoliko ne žele razmjenu. Aplikacija se sastoji od desktop i mobilnog dijela. Admini koriste desktop aplikaciju za upravljanje korisnicima, proizvodima i izvještajima, dok korisnici putem mobilne aplikacije mogu dodavati, uređivati i pregledavati proizvode, slati i primati zahtjeve za razmjenu ili kupovinu.

## Application Access Credentials

### Desktop Application

**Admin Credentials:**  
Username: admin  
Password: admin12345

### Mobile Application

#### User 1 Credentials:
- Username: hana123
- Password: hana12345

#### User 2 Credentials:
- Username: ana123
- Password: ana12345

#### User 3 Credentials:
- Username: proba
- Password: proba12345


## Pokretanje aplikacija

#### Nakon kloniranja repozitorija sa lokacije: https://github.com//hanabajric/eZamjena.git navigirati kroz komandnu liniju do istog, te pokrenuti dokerizovani API i  DB upotrebom sljedeće naredbe

docker-compose up --build

#### Dohvaćanje dependencyija za mobilnu i desktop flutter aplikacijz:

flutter pub get

#### Pokretanje mobilne aplikacije:

flutter run

#### Preporuceno pokretanje desktop aplikacije : 

flutter run -d windows




## Build artefakti  
- fit-build-2025-06-15.zip.001  
  • split arhiva (≤ 90 MB) – izdvojiti 7-Zip-om, šifra “fit”


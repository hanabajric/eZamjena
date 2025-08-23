class ApiException implements Exception {
  final int? statusCode;
  final String? serverMessage;
  final String userMessage;
  ApiException(
      {this.statusCode, this.serverMessage, required this.userMessage});
  @override
  String toString() => 'ApiException($statusCode): $serverMessage';
}

class NetworkException implements Exception {
  final String userMessage;
  NetworkException(this.userMessage);
}

String friendlyMessage({int? status, String? serverMessage, String? path}) {
  switch (status) {
    case 400:
      return 'Neispravan zahtjev. Provjerite unesene podatke.';
    case 401:
      return 'Prijava nije uspjela. Provjerite e-mail i lozinku.';
    case 403:
      return 'Nemate dozvolu za ovu radnju.';
    case 404:
      return 'Traženi resurs nije pronađen.';
    case 409:
      return 'Sukob podataka. Pokušajte osvježiti stranicu.';
    case 422:
      return serverMessage?.isNotEmpty == true
          ? serverMessage!
          : 'Neki podaci nisu ispravni. Provjerite označena polja.';
    case 500:
      return 'Došlo je do greške na serveru. Pokušajte kasnije.';
    default:
      return 'Nešto je pošlo po zlu. Pokušajte ponovo.';
  }
}

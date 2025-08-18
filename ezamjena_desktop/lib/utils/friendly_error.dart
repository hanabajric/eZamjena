class FriendlyError implements Exception {
  final String title;
  final String message;
  FriendlyError(this.title, this.message);
  @override
  String toString() => '$title: $message';
}

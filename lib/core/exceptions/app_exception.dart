class AppException implements Exception {
  const AppException({
    required this.message,
    required this.title,
    this.stackTrace,
  });

  final String message;
  final String title;
  final Object? stackTrace;

  @override
  String toString() => 'AppException(message: $message, title: $title)';
}

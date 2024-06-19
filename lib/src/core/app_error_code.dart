class AppErrorCode {
  static const int jsonDecodeError = 353071860;
}
class FileNotFoundException implements Exception {
  @override
  String toString() => 'Không tìm thấy file!';
}

class SystemOutOfMemoryToSaveFileException implements Exception {}

class PermissionDeniedException implements Exception {
  final String message;

  PermissionDeniedException(this.message);

  @override
  String toString() => "Permission denied: $message";
}
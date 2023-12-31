class NotSupportedAuthException implements Exception {
  @override
  String toString() {

    return 'NotSupportedAuthException: This auth type is not supported';
  }
}
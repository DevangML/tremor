final class SecureVault(final String _apiKey) {
  String get maskedKey =>
      _apiKey.length > 4 ? '${_apiKey.substring(0, 4)}****' : '****';
}

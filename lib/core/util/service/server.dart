class Server {
  static const String _baseUrl = 'https://your-supabase-url.supabase.co';
  static const String _apiKey = 'your-supabase-anon-key';
  
  String productApi(String endpoint) {
    return '$_baseUrl/rest/v1/$endpoint';
  }
  
  String authApi(String endpoint) {
    return '$_baseUrl/auth/v1/$endpoint';
  }
  
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'apikey': _apiKey,
  };
}

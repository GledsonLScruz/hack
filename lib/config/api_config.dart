/// API Configuration
/// Update the baseUrl with your actual API endpoint
class ApiConfig {
  // TODO: Replace with your actual API base URL
  static const String baseUrl = 'https://your-api-endpoint.com';
  
  // API Endpoints
  static const String registerEndpoint = '/api/v1/users/register';
  static const String loginEndpoint = '/api/v1/users/login';
  
  // Full URLs
  static String get registerUrl => '$baseUrl$registerEndpoint';
  static String get loginUrl => '$baseUrl$loginEndpoint';
  
  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // OAuth2 grant types
  static const String grantTypePassword = 'password';
}


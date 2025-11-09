/// API Configuration
/// Update the baseUrl with your actual API endpoint
class ApiConfig {
  // TODO: Replace with your actual API base URL
  static const String baseUrl = 'http://46.62.237.170:8000';

  // API Endpoints
  static const String registerEndpoint = '/api/v1/users/register';
  static const String loginEndpoint = '/api/v1/users/login';
  static const String userMeEndpoint = '/api/v1/users/me';
  static const String roadmapEndpoint = '/api/v1/roadmap/generate';
  static const String mentorsEndpoint = '/api/v1/match/mentors';
  static const String mentorshipRequestEndpoint = '/api/v1/mentorship-requests';

  // Full URLs
  static String get registerUrl => '$baseUrl$registerEndpoint';
  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get userMeUrl => '$baseUrl$userMeEndpoint';
  static String get roadmapUrl => '$baseUrl$roadmapEndpoint';
  static String get mentorsUrl => '$baseUrl$mentorsEndpoint';
  static String get mentorshipRequestUrl => '$baseUrl$mentorshipRequestEndpoint';

  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // OAuth2 grant types
  static const String grantTypePassword = 'password';
}

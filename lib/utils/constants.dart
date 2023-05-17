class ApiConstants {
  static String baseUrl = 'http://192.168.1.71:8000/';
  static String loginEndpoint = 'api/auth/login/';
  static String registerEndpoint = 'api/auth/register/';
  static String profileEndpoint = "api/student-profile/";
}

String titleCase(String input) {
  if (input.isEmpty) {
    return input;
  }

  List<String> words = input.toLowerCase().split(' ');

  for (int i = 0; i < words.length; i++) {
    words[i] = words[i][0].toUpperCase() + words[i].substring(1);
  }

  return words.join(' ');
}

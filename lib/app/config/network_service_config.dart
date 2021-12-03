class NetworkServiceConfig {
   final String baseUrl = 'http://localhost:3000/v1';
}

class AuthConfig extends NetworkServiceConfig {
  final String clientId = "e8e64417-0fd4-4998-8f5c-7d48ae4dc0dc";
  final String signUp = '/signup';
  final String login = '/oauth/token';
}

class UserConfig extends NetworkServiceConfig {
  final String update = '/profiles';

  String findUser(String userId) => '/profiles/$userId';
}

class VideoConfig extends NetworkServiceConfig {
  final String fetchVideos = '/feed';
  final String searchVideos = '/search';
  final String modifyVideo = '/videos';

  String likeVideo(String id) => '/videos/$id/reactions/likes';
  String viewVideo(String id) => '/videos/$id/views';

  String fetchUserVideos(String id) => '/profiles/$id/videos';
  String fetchUserLikedVideos(String id) => '/profiles/$id/reactions';
}

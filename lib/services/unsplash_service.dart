import 'package:unsplash_client/unsplash_client.dart';

class UnsplashService {
  static final UnsplashClient _unsplashClient = UnsplashClient(
    settings: const ClientSettings(
      credentials: AppCredentials(
          accessKey: 'bAyEp3MzdUxYvwYg_GBYIp9T_La9GLPx-dg0_cBCC8w',
          secretKey: "ZKEwVjctNJ95ypwsi59xOirhfGE_Gqaw9dc-CDhjobI"),
    ),
  );

  static Future<List<Photo>> getRandomPhoto(int count) async {
    try {
      final photos =
          await _unsplashClient.photos.random(count: count).goAndGet();

      return photos;
    } catch (e) {
      print(e);

      return [];
    }
  }

  static Future<List<Photo>> searchPhoto(String query) async {
    final photos = await _unsplashClient.search.photos(query).goAndGet();
    return photos.results.toList();
  }
}

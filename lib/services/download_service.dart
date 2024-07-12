import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> downloadImage(String url, String fileName) async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  http.Response response = await http.get(Uri.parse(url));

  final result = await ImageGallerySaver.saveImage(response.bodyBytes);
  if (result['isSuccess']) {
    return true;
  } else {
    return false;
  }
}

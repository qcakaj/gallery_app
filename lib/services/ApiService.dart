
import 'package:http/http.dart' as http;
import 'package:news_app/constants/strings.dart';
import 'package:news_app/models/photo.dart';

class ApiService {
  Future<List<Photo>> getPhotos() async {
    var client = http.Client();
    var photos;
    try {
      var response = await client.get(Uri.parse(Strings.API_URL));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        // var jsonMap = json.decode(jsonString);
        photos = photoFromJson(jsonString);
      }
    } catch (Exception) {
      return photos;
    }
    return photos;
  }
}

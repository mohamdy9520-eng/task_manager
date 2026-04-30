import 'dart:convert';
import 'package:http/http.dart' as http;
import '../indicator/photo.dart';

Future<List<Photo>> fetchPhotos() async {
  final response = await http.get(
    Uri.parse("https://picsum.photos/v2/list"),
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);

    return data.map((e) => Photo.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load photos");
  }
}


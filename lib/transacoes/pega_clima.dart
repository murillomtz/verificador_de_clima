import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<Map> pegaClima(String appId, String cidade) async {
  //http://api.openweathermap.org/data/2.5/weather?q=salvador&appid=ff38d6ed505acc0b54cf1bf742b4818b&units=metric
  String apiUrl =
      'http://api.openweathermap.org/data/2.5/weather?q=$cidade&appid=${appId}&units=metric';

  http.Response response = await http.get(apiUrl);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception("Falhou!");
  }
}

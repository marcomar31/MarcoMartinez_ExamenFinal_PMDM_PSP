import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpAdmin {
  HttpAdmin();

  Future<String> pedirActividadRandom() async {
    var url = Uri.https('www.boredapi.com', '/api/activity/');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      String actividad = jsonResponse['activity'];
      return actividad;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return '';
    }
  }
}

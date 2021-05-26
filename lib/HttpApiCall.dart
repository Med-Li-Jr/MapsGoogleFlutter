
import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpApiCall {
    static final String apiDataUrl = "192.168.1.2";

    Future getApiData() async {
    print("wait--------------------------------------------------------------------------");

    print("wait555--------------------------------------------------------------------------");
    final response = await http.get(Uri.http(apiDataUrl, "/api/data"));

    print("done--------------------------------------------------------------------------");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load record');
    }
  }
}
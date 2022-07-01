import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

const String domain = "https://localhost:7190";
// const String domain = "http://10.0.2.2:7182";
final client = http.Client();

getHttp(String uri) async {
  try {
    var url = Uri.parse(domain + uri);

    final response = await client.get(url);

    if (response.statusCode == 400) {
      return response.body;
    }

    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      return result;
    } else {
      debugPrint(response.body);
    }
  } catch (e) {
    return e.toString();
  }
}

// post api
postHttp(String uri, Map data) async {
  try {
    var url = Uri.parse(domain + uri);

    final response = await client.post(url,
        headers: {"Content-Type": "application/json"}, body: json.encode(data));

    if (response.statusCode == 400) {
      return response.body;
    }

    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      return result;
    } else {
      debugPrint(response.body);
    }
  } catch (e) {
    return e.toString();
  }
}

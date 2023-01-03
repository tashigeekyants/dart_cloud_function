import 'dart:convert';

import 'package:functions_framework/functions_framework.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';

@CloudFunction()
Future<Response> function(Request request) async {
  try {
    var headers = {
      "Authorization": "Bearer SG.YOUR_API_KEY_HERE",
      "Content-Type": "application/json"
    };
    var body = {
      "personalizations": [
        {
          "to": [
            {"email": "test@geekyants.com"}
          ]
        }
      ],
      "from": {"email": "send-grid-register-email"},
      "subject": "Hello World email",
      "content": [
        {"type": "text/plain", "value": "Hello world body"}
      ]
    };
    var response = await http.post(
      Uri.parse("https://api.sendgrid.com/v3/mail/send"),
      headers: headers,
      body: json.encode(body),
    );
    if ([200, 201, 202, 204].contains(response.statusCode)) {
      return Response.ok(response.body);
    } else {
      return Response.internalServerError(body: response.body);
    }
  } catch (e) {
    return Response.internalServerError(
      body: e.toString(),
    );
  }
}

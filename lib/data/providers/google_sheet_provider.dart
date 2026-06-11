import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleSheetProvider {

  static const String apiUrl =
      "https://script.google.com/macros/s/AKfycbxfJ_2lAuNG-mfn4XUomyydNrQ2N_X3Mns_izo0mZS5BwSPshLNJarglSo4TrixQWA/exec";

  Future<bool> saveSensorData({
    required double temperature,
    required double humidity,
    required int battery,
    required bool status,
  }) async {

    try {

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "temperature": temperature,
          "humidity": humidity,
          "battery": battery,
          "status": status,
        }),
      );


      print("STATUS = ${response.statusCode}");
      print("BODY = ${response.body}");


      return response.statusCode == 200;

    } catch (e) {

      print("GoogleSheet Error: $e");

      return false;
    }
  }
  Future<List<dynamic>> getHistory() async {

    final response =
    await http.get(Uri.parse(apiUrl));

    return jsonDecode(response.body);
  }
}
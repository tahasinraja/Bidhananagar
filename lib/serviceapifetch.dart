import 'dart:convert';
import 'package:bidhannagarpoliceapp/modelfetch.dart';
import 'package:http/http.dart' as http;


class ApiService {
  static Future<List<NoticeModel>> fetchNotices() async {
    final response = await http.get(
      Uri.parse("https://bnpcdeveloper.co.in/bnpolice/app/notice_fetch.php"),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 'success') {
        List data = jsonData['data'];
        return data.map((e) => NoticeModel.fromJson(e)).toList();
      } else {
        throw Exception("Failed: ${jsonData['message']}");
      }
    } else {
      throw Exception("Failed to load notices");
    }
  }
}

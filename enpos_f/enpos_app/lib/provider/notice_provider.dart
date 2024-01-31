import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/notice.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NoticeProvider with ChangeNotifier {
  final List<Notice> _noticeList = List.empty(growable: true);
  static const storage = FlutterSecureStorage();


  List<Notice> getNoticeList(sDate, eDate) {
    _fetchNotice(sDate, eDate);
    return _noticeList;
  }

  void _fetchNotice(sDate, eDate) async {
    await dotenv.load(fileName: '.env');
    var token = await storage.read(key: 'authToken');

    final response = await http.get(
                                    Uri.parse(
                                        '${dotenv.env['BASEURL']}/notice/list?startDate=$sDate&endDate=$eDate'),
                                    headers: {"Access-Control-Allow-Origin": "*",'Authorization': 'Bearer $token'});
    print('공지사항 조회 결과:' +  '${dotenv.env['BASEURL']}/notice/list?startDate=$sDate&endDate=$eDate');
    _noticeList.clear();

    if ( response.statusCode == 200) {
      print('공지사항 리스트:' + response.body);
      final List<Notice> result = jsonDecode(utf8.decode(response.bodyBytes)) //jsonDecode(response.body)
          .map<Notice>((json) => Notice.fromJson(json))
          .toList();
      _noticeList.addAll(result);
      notifyListeners();
    }
  }
}

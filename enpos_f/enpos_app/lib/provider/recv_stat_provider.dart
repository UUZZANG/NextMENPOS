import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/recv_stat.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RecvStatProvider with ChangeNotifier {
  final List<RecvStat> _recvStatList = List.empty(growable: true);
  static const storage = FlutterSecureStorage();


  List<RecvStat> getRecvStatList(sDate, eDate) {
    _fetchRecvStat(sDate, eDate);
    return _recvStatList;
  }

  void _fetchRecvStat(sDate, eDate) async {
    await dotenv.load(fileName: '.env');
    var token = await storage.read(key: 'authToken');

    final response = await http.get(
                                    Uri.parse(
                                        '${dotenv.env['BASEURL']}/notice/list?startDate=$sDate&endDate=$eDate'),
                                    headers: {"Access-Control-Allow-Origin": "*",'Authorization': 'Bearer $token'});
    print('공지사항 조회 결과:' +  '${dotenv.env['BASEURL']}/notice/list?startDate=$sDate&endDate=$eDate');
    _recvStatList.clear();

    if ( response.statusCode == 200) {
      print('공지사항 리스트:' + response.body);
      final List<RecvStat> result = jsonDecode(utf8.decode(response.bodyBytes)) //jsonDecode(response.body)
          .map<RecvStat>((json) => RecvStat.fromJson(json))
          .toList();
      _recvStatList.addAll(result);
      notifyListeners();
    }
  }
}

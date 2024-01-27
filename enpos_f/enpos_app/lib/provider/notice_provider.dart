import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/notice.dart';


        
         
class NoticeProvider with ChangeNotifier {

	final List<Notice> _noticeList = List.empty(growable: true);

	List<Notice> getNoticeList() {
		_fetchNotice();
		return _noticeList;
	}


	void _fetchNotice() async {
		final response = await http
			.get(Uri.parse('http://localhost:8080/getKibomsNotice'));

		final List<Notice> result = jsonDecode(utf8.decode(response.bodyBytes)) //jsonDecode(response.body)
			.map<Notice>((json) => Notice.fromJson(json))
			.toList();

		_noticeList.clear();
		_noticeList.addAll(result);
		notifyListeners();
	}



}

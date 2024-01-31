import "package:enpos_app/provider/notice_provider.dart";
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import "package:provider/provider.dart";

import "../model/notice.dart";

ScrollController scrollController = ScrollController();

class NoticeView extends StatefulWidget {
  const NoticeView({super.key});

  @override
  State<NoticeView> createState() => _NoticeViewState();
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100,
        //width: 100,
        child: Center(child: Text(text, overflow: TextOverflow.ellipsis)),
      ),
    );
  }
}

class _NoticeViewState extends State<NoticeView> {
  final _searchDates = ['1개월', '2개월', '3개월', '사용자설정'];
  String _searchDate= '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _searchDate =  '2개월';
    });
  }

  late List<Notice> noticeList;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading : false,
            flexibleSpace:
                  /*********** 검색 날짜 지정 ***********/
                  DropdownButton (
                      menuMaxHeight : 100.0,
                      value: _searchDate,
                      items: _searchDates
                          .map((e) => DropdownMenuItem(
                        value: e, // 선택 시 onChanged 를 통해 반환할 value
                        child: Text(e),
                      ))
                          .toList(),
                      onChanged: (value) { // items 의 DropdownMenuItem 의 value 반환
                        setState(() {
                          _searchDate = value!;
                        });
                      }),
              centerTitle: true,
              elevation: 0.0,

        ),

      body:
          Consumer<NoticeProvider>(
              builder: (context, provider, child) {
                noticeList = provider.getNoticeList('20230101','20240130');
                return ListView.builder(
                    itemCount: noticeList.length,
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          _showdialog(context, "${noticeList[index].title}",
                              "${noticeList[index].content}");
                        },
                        child: ListTile(
                          title: Card(
                              child: Text("${noticeList[index].title}",
                                  style: const TextStyle(fontSize: 18),
                                  overflow: TextOverflow.ellipsis)),
                          // trailing: Icon(Icons.more_vert),
                          // isThreeLine: true,
                          subtitle: ItemWidget(text: "${noticeList[index].content}"),
                          //SizedBox(
                          //height: 100,
                          //child:
                          // Column(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [

                          // Row(children: [
                          // SizedBox(
                          //   height: 70,
                          //   width: 400,
                          //   child: Center(
                          //       child: Text("${noticeList[index].content}",
                          //           overflow: TextOverflow.ellipsis)),
                          //)
                          //     ]
                          // ),
                          // Row(children: [
                          //   ItemWidget(
                          //       text: "test"),
                          //           //DateFormat("yyyy년 MM월 dd일").format(DateTime.fromMillisecondsSinceEpoch(noticeList[index].title))),
                          //   const Spacer(),
                          //   ItemWidget(
                          //       text: "${noticeList[index].title}")
                          // ])
                          //],
                        ),
                      );
                    }
                );
              })



    );
}

  Future<dynamic> _showdialog(
      BuildContext context, String title, String content) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content),
          // Row(
          //     children: [
          //       Text(content),
          //       //Spacer(),
          //       //Text( "Update : ${DateFormat("yyyy년 MM월 dd일").format(DateTime.fromMillisecondsSinceEpoch(updateDate as int))}" ),
          //      // ItemWidget(text: "${noticeList[index].updateUserId}")
          //     ]
          //   )
        ),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.of(context).pop(), child: const Text('닫기')),
        ],
      ),
    );
  }
}

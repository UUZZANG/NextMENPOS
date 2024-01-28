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
        height: 20,
        //width: 100,
        child: Center(child: Text(text, overflow: TextOverflow.ellipsis)),
      ),
    );
  }
}

class _NoticeViewState extends State<NoticeView> {
  late List<Notice> noticeList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NoticeProvider>(
        builder: (context, provider, child) {
          noticeList = provider.getNoticeList();
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
                    subtitle: SizedBox(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //ItemWidget(text: "${noticeList[index].content}"),
                          Row(children: [
                            SizedBox(
                              height: 70,
                              width: 400,
                              child: Center(
                                  child: Text("${noticeList[index].content}",
                                      overflow: TextOverflow.ellipsis)),
                            )
                          ]),
                          Row(children: [
                            ItemWidget(
                                text:
                                    DateFormat("yyyy년 MM월 dd일").format(DateTime.fromMillisecondsSinceEpoch(noticeList[index].updateDate))),
                            const Spacer(),
                            ItemWidget(
                                text: "${noticeList[index].updateUserId}")
                          ])
                        ],
                      ),
                    )),
              );
            },
          );
        },
      ),
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

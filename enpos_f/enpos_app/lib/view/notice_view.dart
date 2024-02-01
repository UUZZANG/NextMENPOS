import "package:enpos_app/provider/notice_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
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
      color : Colors.white,
      shape :RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),

      child: SizedBox(
        height: 100,
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
                          _showdialog(context, noticeList[index]);
                        },
                        child: ListTile(
                          title: Card(
                              child: Text("${noticeList[index].title}",
                                  style: const TextStyle(fontSize: 18),
                                  overflow: TextOverflow.ellipsis)),
                          // trailing: Icon(Icons.more_vert),
                          // isThreeLine: true,
                          subtitle: ItemWidget(text: "${noticeList[index].content}"),

                        ),
                      );
                    }
                );
              })



    );
}
  /**********************************************************************
            공지사항 상세 팝업
            1. 제목
            2. 내용
            3. 작성자 작성일자
            4. 첨부파일
   **********************************************************************/

  Future<dynamic> _showdialog( BuildContext context, Notice notice) {
      return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("${notice.title}"),
          content:
          Container(
              color: Colors.transparent,
              child:
                  Column(
                    children: [
                              Flexible(
                                flex : 1,
                                fit : FlexFit.loose,
                                child:
                                SizedBox(
                                    height: 400,
                                    child: SingleChildScrollView(
                                        child: HtmlWidget("${notice.content}")
                                    )
                                ),
                              ),
                              Text("${notice.name}"),
                              Text("${notice.registerDate}"),
                              const Divider(color: Colors.black12, thickness: 1.0),
                              Text("${notice.fileTag}")
                          ],
                  )

          ),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(), child: const Text('닫기')),
          ],
        ),
      );
  }
}

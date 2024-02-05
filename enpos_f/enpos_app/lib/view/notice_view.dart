import "package:enpos_app/provider/notice_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
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
      elevation: 0.0,


      child: SizedBox(
        height: 100,
        child: Center(child: Text(text, overflow: TextOverflow.ellipsis
                                      ,style: TextStyle(fontFamily: 'RKM KR Light', fontWeight: FontWeight.w300))),
      ),
    );
  }
}

class _NoticeViewState extends State<NoticeView> {
  final _searchDates = ['1개월', '2개월', '3개월', '사용자설정'];
  String _searchDate= '';
  String _rkm_startDate = '';
  String _rkm_endDate = '';


  @override
  void initState() {
    super.initState();
    setState(() {
      _searchDate =  '2개월';
      _rkm_startDate =  '${DateFormat('yyyyMMdd').format(DateTime.now().subtract(const Duration(days: 60)))}';
      _rkm_endDate =  '${DateFormat('yyyyMMdd').format(DateTime.now())}';
    });
  }

  late List<Notice> noticeList =[];
  int _listCnt = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       //bottomNavigationBar : Text ('건수: ' + _listCnt.toString()),
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
                        if ( value == '1개월') { // '2개월', '3개월', '사용자설정'
                           setState(() {
                             _searchDate = value!;
                             _rkm_startDate =  '${DateFormat('yyyyMMdd').format(DateTime.now().subtract(const Duration(days: 30)))}';
                             _rkm_endDate =  '${DateFormat('yyyyMMdd').format(DateTime.now())}';
                             _listCnt = noticeList.length;
                           });
                        } else if( value == '2개월'){
                          setState(() {
                            _searchDate = value!;
                            _rkm_startDate =  '${DateFormat('yyyyMMdd').format(DateTime.now().subtract(const Duration(days: 60)))}';
                            _rkm_endDate =  '${DateFormat('yyyyMMdd').format(DateTime.now())}';
                            _listCnt = noticeList.length;
                          });
                        } else if( value == '3개월') {
                          setState(() {
                            _searchDate = value!;
                            _rkm_startDate =  '${DateFormat('yyyyMMdd').format(DateTime.now().subtract(const Duration(days: 90)))}';
                            _rkm_endDate =  '${DateFormat('yyyyMMdd').format(DateTime.now())}';
                            _listCnt = noticeList.length;
                          });
                        } else if( value == '사용자설정'){
                            showDatePickerPop().then((value) =>
                                setState(() {
                                  print ('시작 날짜' + value[0].toString() + '끝 날짜' + value[1].toString());
                                  _rkm_startDate = value[0].toString();
                                  _rkm_endDate =value[1].toString();
                                  _listCnt = noticeList.length;
                                }),
                            );
                        }

                      }),
              centerTitle: true,
              elevation: 0.0,
        ),

      body:
          Consumer <NoticeProvider>(
              builder: (context, provider, child) {
                noticeList = provider.getNoticeList('${_rkm_startDate}','${_rkm_endDate}');
                return

                  Column(
                      children: [
                          Expanded(  child:
                                    ListView.builder(
                                    itemCount: noticeList.length,
                                        controller: scrollController,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              _showdialog(context, noticeList[index]);
                                            },
                                            child: ListTile(
                                              title: Card(
                                                  color: Colors.amberAccent,
                                                  shape :RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(0)),
                                                  child: Text("${noticeList[index].title}",
                                                      style: const TextStyle(fontSize: 16),
                                                      overflow: TextOverflow.ellipsis)),
                                              // trailing: Icon(Icons.more_vert),
                                              // isThreeLine: true,
                                              subtitle: ItemWidget(text: "${noticeList[index].content}"),

                                            ),
                                          );
                                        }
                                    ),
                          ),
                        Text ('건수: ' + noticeList.length.toString()),
                      ]
                  );
              })
    );
  }


  /**********************************************************************
      DatePicker 팝업
   **********************************************************************/
  Future  showDatePickerPop() {
    String _selectedDate = '';
    String _dateCount = '';
    List<String> _range = [];
    String _rangeCount = '';

    void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      /// The argument value will return the changed date as [DateTime] when the
      /// widget [SfDateRangeSelectionMode] set as single.
      ///
      /// The argument value will return the changed dates as [List<DateTime>]
      /// when the widget [SfDateRangeSelectionMode] set as multiple.
      ///
      /// The argument value will return the changed range as [PickerDateRange]
      /// when the widget [SfDateRangeSelectionMode] set as range.
      ///
      /// The argument value will return the changed ranges as
      /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
      /// multi range.
      // PickerDateRange#7d999(startDate: 2024-02-11 00:00:00.000, endDate: 2024-02-13 00:00:00.000)
      setState(() {
        if (args.value is PickerDateRange) {
          // _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
          // // ignore: lines_longer_than_80_chars
          //     ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
          //enpos API  파라미터 날짜 형식 yyyymmdd
          _range.add('${DateFormat('yyyyMMdd').format(args.value.startDate)}');
          _range.add('${DateFormat('yyyyMMdd').format(args.value.endDate ?? args.value.startDate)}');
        } else if (args.value is DateTime) {
          _selectedDate = args.value.toString();
        } else if (args.value is List<DateTime>) {
          _dateCount = args.value.length.toString();
        } else {
          _rangeCount = args.value.length.toString();
        }
      });
    }

    return
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          actions: [
            ElevatedButton(
                onPressed: () =>  Navigator.pop(context, _range),       // 선택된 Range 넘겨주기
                child: const Text('선택')),
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(), child: const Text('닫기')),
          ],
          content:
          Stack(
              children: <Widget>[
                // Positioned(
                //   left: 0,
                //   right: 0,
                //   top: 0,
                //   height: 80,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     mainAxisSize: MainAxisSize.min,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: <Widget>[
                //       Text('Selected date: $_selectedDate'),
                //       Text('Selected date count: $_dateCount'),
                //       Text('Selected range: $_range'),
                //       Text('Selected ranges count: $_rangeCount')
                //     ],
                //   ),
                // ),
                Positioned(
                  left: 0,
                  top: 80,
                  right: 0,
                  bottom: 0,
                  child: SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange: PickerDateRange(
                        DateTime.now().subtract(const Duration(days: 4)),
                        DateTime.now().add(const Duration(days: 3))),
                  ),
                )
              ]
          ),
        ),

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

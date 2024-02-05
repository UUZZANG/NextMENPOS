import 'package:confirm_dialog/confirm_dialog.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

ScrollController scrollController = ScrollController();

class CenterStorckView extends StatefulWidget {
  const CenterStorckView({super.key});

  @override
  State<CenterStorckView> createState() => _CenterStorckViewState();
}


/*
  `     # [센터입고] 기존 API 연결 정보
        1. 스캔된 번호에 대한 정보 가져오는 API
          참고 front js : pages > goods-recv > goods-recv.ts
          참고 호출 js  : src> providers > goods-recv-data.ts
                         this.http.get(this.commData.getBaseURL() + '/gr/item?companyId=' + this.commData.getUserInfo().companyId + '&huNo=' + huNo)

        2. 입고 내역 저장 Post API

 */


class _CenterStorckViewState extends State<CenterStorckView> {
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();

  //임시로 2개 보이기
  final List<TextEditingController> _qtyController = [
    TextEditingController(text: "1"),
    TextEditingController(text: "1")
  ];

  var huCodes = ["88999000R", "88999000V"];
  var items = [
    {
      'addqty': '1',
      'companyId': 'conpany222',
      'huNo': '88999000V',
    },
    {
      'addqty': '1',
      'companyId': 'conpany11',
      // private String asnNo;
      // private String asnLine;
      // private String purchaseNo;
      // private String purchaseLine;
      // private String plant;
      // private String sapOrderNo;
      // private String sapOrderLine;
      // private String asnPartNo;
      // private String partsHname;
      // private Long purchaseQty;
      // private String purchaseDate;
      // private Long purchasePrice;
      // private Long asnQty;
      // private String asnDate;
      // private Long grQty;
      'huNo': '88999000R',
      // private String location;
      // private String purchasePartNo;
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: items.length,
          controller: scrollController,
          itemBuilder: (context, index) {
            return ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), //모서리
                  side: const BorderSide(
                      color: Color.fromARGB(255, 158, 158, 158))),
              trailing: OverflowBar(children: [
                OutlinedButton(
                  onPressed: () {
                    if (items[index]['addqty'] == "1") {
                      print('최소 수량입니다.');
                    } else {
                      items[index]['addqty'] =
                          (int.parse(items[index]['addqty']!) - 1).toString();
                      _qtyController[index].text = items[index]['addqty']!;
                      setState(() {});
                    }
                  },
                  child: const Icon(
                    Icons.remove,
                    color: Color.fromARGB(255, 132, 115, 227),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: Flexible(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                      ],
                      textAlign: TextAlign.center,
                      onChanged: (text) {
                        items[index]['addqty'] = text;
                        _qtyController[index].text = text;
                        setState(() {});
                        print(items[index]['addqty']);
                      },
                      controller: _qtyController[index],
                      // decoration: InputDecoration(
                      // 	//hintText: '텍스트를 입력해주세요',
                      // 	border: OutlineInputBorder(), //외곽선
                      // ),
                    ),
                  ), //TextField 크기
                ),
                OutlinedButton(
                  onPressed: () {
                    items[index]['addqty'] =
                        (int.parse(items[index]['addqty']!) + 1).toString();
                    _qtyController[index].text = items[index]['addqty']!;
                    setState(() {});
                  },
                  child: const Icon(
                    Icons.add_circle_outline_rounded,
                    color: Color.fromARGB(255, 132, 115, 227),
                  ),
                ),
                const Spacer(
                  flex: 100,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // 선택된 항목 리스트에서 삭제 후 state 변경
                    if (await confirm(
                      context,
                      title: const Text('삭제'),
                      content: Text("${items[index]['huNo']}를 삭제 하시겠습니까?"),
                    )) {
                      // items 와 _qtyController[]에서 삭제
                      items.removeAt(index);
                      _qtyController.removeAt(index);
                      setState(() {});
                      return print('deleted');
                    }
                    return print('cancel');
                  },
                  child: const Icon(
                    Icons.delete_rounded,
                    color: Color.fromARGB(255, 247, 30, 30),
                  ),
                ),
              ]),

              //HU 코드
              title: Text("${items[index]['huNo']}",
                  style: const TextStyle(fontSize: 18),
                  overflow: TextOverflow.ellipsis),
              //HU 코드에 해당하는 품목 디테일
              subtitle: SizedBox(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      SizedBox(
                        height: 70,
                        child: Text("$index : ${items[index]['companyId']}",
                            style: const TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ]),
                    // Row(
                    // 	children: [
                    // 		ItemWidget(text: "${DateFormat("yyyy년 MM월 dd일").format(DateTime.fromMillisecondsSinceEpoch(noticeList[index].updateDate))}" ),
                    // 		Spacer(),
                    // 		ItemWidget(text: "${noticeList[index].updateUserId}")
                    // 	]
                    // )
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: ElevatedButton(
          onPressed: () {
            _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                context: context,
                onCode: (code) {
                  setState(() {
                    items.add({
                      'huNo': code!,
                      'addqty': '0',
                      'companyId': 'conpany11',
                    });
                    _qtyController.add(TextEditingController(text: "0"));
                    // 선택된 huNo면 return
                    // 아니면 추가후 state 변경
                  });
                });
          },
          child: const Text("SCAN")),
    );
  }
}

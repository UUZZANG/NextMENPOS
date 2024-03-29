import 'package:enpos_app/provider/album_provider.dart';
import 'package:enpos_app/provider/notice_provider.dart';
import 'package:enpos_app/provider/recv_stat_provider.dart';
import 'package:enpos_app/view/album_view.dart';
import 'package:enpos_app/view/center_stock.dart';
import 'package:enpos_app/view/cust_recv.dart';
import 'package:enpos_app/view/recv_status.dart';
import 'package:enpos_app/view/notice_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';



class MenuLayout extends StatefulWidget {
  String id;
  MenuLayout({super.key, required this.id});

  @override
  State<MenuLayout> createState() => _MenuLayoutState(id: id);
}


class _MenuLayoutState extends State<MenuLayout> {
  final storage = const FlutterSecureStorage();
  String id;
  _MenuLayoutState({required this.id});


  @override
  void initState() {
    //super.initState();
    getInfo();
  }


  getInfo() async {
    id = (await storage.read(key: 'id'))!;
  }


  String menuText = "Mobile ENPOS";

  dynamic widgetForBody = ChangeNotifierProvider<NoticeProvider>(
        create: (context) => NoticeProvider(),
        child: const NoticeView(),
        );



  @override
  Widget build(BuildContext context) {
    return
        // DefaultTabController(
        //   length: 3,
        //   child:

        Scaffold(
            appBar: AppBar(
              title: Text(
                menuText,
                style: const TextStyle(
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              centerTitle: true,
              elevation: 0.0,
              // bottom: TabBar(
              //   isScrollable: false,
              //   unselectedLabelColor: Colors.white.withOpacity(0.2),
              //   tabs: const [
              //     Tab(
              //       icon: Icon(Icons.shopping_cart),
              //       text: '쇼핑하기',
              //     ),
              //     Tab(
              //       icon: Icon(Icons.search),
              //       text: '검색',
              //     ),
              //     Tab(
              //       icon: Icon(Icons.account_circle),
              //       text: '내 정보',
              //     ),
              //   ],
              // ),
              actions: [
                IconButton(
                  onPressed: () {
                    // 자동로그인 'Y'면 pw 저장 , 아이디 저장여부 'Y' id 저장

                    storage.deleteAll();
                    Navigator.popUntil(context, ModalRoute.withName("/"));
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ), // Drawer() 위젯의 경우 기본적으로 Scaffold() 위젯 내에 존재한다.
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    currentAccountPicture: const CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/gall01.jpg'),
                    ),
                    accountName: Text(
                      id,
                      style: const TextStyle(
                        letterSpacing: 1.0,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    accountEmail: const Text(
                      '5yattree@email.com',
                      style: TextStyle(
                        letterSpacing: 0.7,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onDetailsPressed: () {
                      print('Arrow will rotate after clicking');
                    },
                    decoration: BoxDecoration(
                      color: Colors.teal[300],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                      ),
                    ),
                    // otherAccountsPictures: [
                    //   CircleAvatar(
                    //     backgroundColor: Colors.white,
                    //     backgroundImage: AssetImage('images/5yattree_2.jpeg'),
                    //   ),
                    // ],
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Colors.grey[850],
                    ),
                    title: const Text('공지사항'),
                    onTap:  () {
                        setState(() {
                            menuText = "공지사항";
                            widgetForBody =  ChangeNotifierProvider<NoticeProvider>(
                                               create: (context) => NoticeProvider(),
                                               child: const NoticeView(),
                                             );
                            Navigator.of(context).pop();
                        });
                      },
                  ),
                  /*********** 센터입고 메뉴  ***********/
                  ListTile(
                    leading: Icon(
                      Icons.add_box,
                      color: Colors.grey[850],
                    ),
                    title: const Text('센터입고'),
                    onTap: () {
                      setState(() {
                        menuText = "센터입고";
                        widgetForBody = const CenterStorckView();
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                  /*********** 거래처입고 메뉴  ***********/
                  ListTile(
                    leading: Icon(
                      Icons.add_business,
                      color: Colors.grey[850],
                    ),
                    title: const Text('거래처입고'),
                    onTap:
                        () {
                          setState(() {
                            menuText = "거래처입고";
                            widgetForBody =ChangeNotifierProvider<NoticeProvider>(
                              create: (context) => NoticeProvider(),
                              child: const NoticeView(),
                            );
                            Navigator.of(context).pop();
                          });
                    },
                  ),
                  /*********** 입고현황 메뉴  ***********/
                  ListTile(
                    leading: Icon(
                      Icons.stacked_bar_chart,
                      color: Colors.grey[850],
                    ),
                    title: const Text('입고현황'),
                    onTap: () {
                      setState(() {
                        menuText = "입고현황";
                        widgetForBody = ChangeNotifierProvider<RecvStatProvider>(
                          create: (context) => RecvStatProvider(),
                          child: const RecvStatView(),
                        );
                        Navigator.of(context).pop();
                      });
                    },
                    //trailing: Icon(Icons.add),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.question_answer,
                      color: Colors.grey[850],
                    ),
                    title: const Text('판매출하'),
                    onTap: () {
                      print('Q&A is clicked');
                    },
                    trailing: const Icon(Icons.add),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.question_answer,
                      color: Colors.grey[850],
                    ),
                    title: const Text('판매출하현황'),
                    onTap: () {
                      print('Q&A is clicked');
                    },
                    trailing: const Icon(Icons.add),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.question_answer,
                      color: Colors.grey[850],
                    ),
                    title: const Text('재고수정'),
                    onTap: () {
                      print('Q&A is clicked');
                    },
                    trailing: const Icon(Icons.add),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.question_answer,
                      color: Colors.grey[850],
                    ),
                    title: const Text('재고수량조정'),
                    onTap: () {
                      print('Q&A is clicked');
                    },
                    trailing: const Icon(Icons.add),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.question_answer,
                      color: Colors.grey[850],
                    ),
                    title: const Text('타대리점 재고조회'),
                    onTap: () {
                      print('Q&A is clicked');
                    },
                    trailing: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            body: widgetForBody
            // TabBarView(
            //   children: [
            //     Container(
            //       color: Colors.green[200],
            //     ),
            //     Container(
            //       color: Colors.green[300],
            //     ),
            //     Container(
            //       color: Colors.green[400],
            //     ),
            //   ],
            // ),
            );
    // );
  }
}

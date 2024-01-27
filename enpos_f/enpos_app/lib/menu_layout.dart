import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'package:enpos_app/provider/notice_provider.dart';
import 'package:enpos_app/view/notice_view.dart';  
import 'package:enpos_app/provider/album_provider.dart';
import 'package:enpos_app/view/album_view.dart';  

import 'package:enpos_app/view/center_stock.dart';  

class MenuLayout extends StatefulWidget {
  String id;
  MenuLayout({required this.id});
	//const MenuLayout({Key? key}) ;

  @override
  State<MenuLayout> createState() => _MenuLayoutState(id:id);
}


class _MenuLayoutState extends State<MenuLayout> {

  final storage =  FlutterSecureStorage();   
  String id;
  _MenuLayoutState({required this.id});

 @override
  void initState() {
    //super.initState();
    getInfo();    
  }

  getInfo() async {
    id = (await storage.read(key: 'id'))!;
    setState(() {

    });
  }
  // 메뉴 클릭시 바뀌어지는 Body용 위젯
  String menuText = "Mobile ENPOS";
  Widget widgetForBody =  ChangeNotifierProvider<NoticeProvider>(
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
            style: TextStyle(
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
                   '$id', 
                  style: TextStyle(
                    letterSpacing: 1.0,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
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
                  borderRadius: BorderRadius.only(
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
                title: Text('공지사항'),
                onTap: () {
                  setState((){
                    menuText = "공지사항";
                    widgetForBody = ChangeNotifierProvider<NoticeProvider>(
                                      create: (context) => NoticeProvider(),
                                      child: const NoticeView(),				
                                    );
                    Navigator.of(context).pop();
                  });
                },
                //trailing: Icon(Icons.add),
              ),
              ListTile(
                leading: Icon(
                  Icons.add_box,                  
                  color: Colors.grey[850],
                ),
                title: Text('센터입고'),
                onTap: () {
                  setState((){
                    menuText = "센터입고";
                    widgetForBody = const CenterStorckView();                                   
                    Navigator.of(context).pop();
                  });
                },
                //trailing: Icon(Icons.add),
              ),
              ListTile(
                leading: Icon(
                  Icons.add_business,
                  color: Colors.grey[850],
                ),
                title: Text('거래처입고'),
                onTap: () {
                  print('Q&A is clicked');
                },
                //trailing: Icon(Icons.add),
              ),
              ListTile(
                leading: Icon(
                  Icons.stacked_bar_chart,
                  color: Colors.grey[850],
                ),
                title: Text('입고현황'),
                onTap: () {
                  setState((){
                    menuText = "입고현황";
                    widgetForBody =  ChangeNotifierProvider<AlbumProvider>(
                                        create: (context) => AlbumProvider(),
                                        child: const AlbumView(),				
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
                title: Text('판매출하'),
                onTap: () {
                  print('Q&A is clicked');
                },
                trailing: Icon(Icons.add),
              ),
              ListTile(
                leading: Icon(
                  Icons.question_answer,
                  color: Colors.grey[850],
                ),
                title: Text('판매출하현황'),
                onTap: () {
                  print('Q&A is clicked');
                },
                trailing: Icon(Icons.add),
              ),
               ListTile(
                leading: Icon(
                  Icons.question_answer,
                  color: Colors.grey[850],
                ),
                title: Text('재고수정'),
                onTap: () {
                  print('Q&A is clicked');
                },
                trailing: Icon(Icons.add),
              ),
               ListTile(
                leading: Icon(
                  Icons.question_answer,
                  color: Colors.grey[850],
                ),
                title: Text('재고수량조정'),
                onTap: () {
                  print('Q&A is clicked');
                },
                trailing: Icon(Icons.add),
              ),
               ListTile(
                leading: Icon(
                  Icons.question_answer,
                  color: Colors.grey[850],
                ),
                title: Text('타대리점 재고조회'),
                onTap: () {
                  print('Q&A is clicked');
                },
                trailing: Icon(Icons.add),
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


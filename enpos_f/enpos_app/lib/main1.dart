// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'package:enpos_app/menu_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

void main() async {
  await dotenv.load(fileName: '.env');
  print(dotenv.env['BASEURL']);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  // TextField(
  // controller: idController,
  // decoration: InputDecoration(labelText: "id"),
  // ),
  // TextField(
  //   controller: passController,
  //   decoration: InputDecoration(labelText: "password"),
  // ),

  static const storage = FlutterSecureStorage();
  dynamic userInfo = '';

  @override
  void initState() {
    super.initState();
    // Frame을 다 불러온뒤 callback 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    userInfo = await storage.read(key: "id") ?? '';

    setState(() {
      print('State Changed');
    });
    if (userInfo != null) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MenuLayout(id: userInfo)));
    } else {
      print('login required!');
    }
  }

  // Login Action
  loginAction(accountName, password) async {
    print('id :' + accountName);

    Map params = {'userId': '$accountName', 'password': '$password'};

    // 프록시 거치는 로그인은 앱에서만 가능한 듯
    // 웹 서비스는 CORS 설정 , 토큰으로 보안 해야 함
    final res = await http.get(Uri.parse(
        'https://corsproxy.github.io/${dotenv.env['BASEURL']}/auth/login'));
    //{"pin":"RSMEDUCO","emailid":"jump502@samsung.com","name":"부품대리점","phone1":"043-000-0000","phone2":null,"useflag":"Y","usertype":"V","wgid":4,"companyId":"RSMEDUCO"}
    // final List<Notice> result = jsonDecode(utf8.decode(response.bodyBytes)) //jsonDecode(response.body)
    // 	.map<Notice>((json) => Notice.fromJson(json))
    // 	.toList();
    if (res.statusCode == 200) {
      print('접속 성공!' + res.body);
      // final jsonBody = json.decode(res.data['pin'].toString());
      // var val = jsonEncode(Login('$accountName', '$password', '$jsonBody'));
      await storage.write(key: "id", value: res.statusCode.toString());
      return true;
      //return true;
    } else {
      print('error');
      await storage.write(key: "id", value: "RSMEDUCO");
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (await loginAction(
                      usernameController.text, passwordController.text) ==
                  true) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MenuLayout(id: userInfo)));
              } else {
                print('로그인 실패');
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
// class MyScreen extends StatefulWidget {
//   const MyScreen({Key? key}) : super(key: key);

//   @override
//   State<MyScreen> createState() => _MyScreenState();
// }

// class _MyScreenState extends State<MyScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Appbar icon Menu',
//             style: TextStyle(
//               letterSpacing: 2.0,
//               fontWeight: FontWeight.normal,
//             ),
//           ),
//           centerTitle: true,
//           elevation: 0.0,
//           bottom: TabBar(
//             isScrollable: false,
//             unselectedLabelColor: Colors.white.withOpacity(0.2),
//             tabs: const [
//               Tab(
//                 icon: Icon(Icons.shopping_cart),
//                 text: '쇼핑하기',
//               ),
//               Tab(
//                 icon: Icon(Icons.search),
//                 text: '검색',
//               ),
//               Tab(
//                 icon: Icon(Icons.account_circle),
//                 text: '내 정보',
//               ),
//             ],
//           ),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 print('Add icon was clicked');
//               },
//               icon: const Icon(Icons.add),
//             ),
//           ],
//         ), // Drawer() 위젯의 경우 기본적으로 Scaffold() 위젯 내에 존재한다.
//         drawer: Drawer(
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: [
//               UserAccountsDrawerHeader(
//                 currentAccountPicture: CircleAvatar(
//                   backgroundColor: Colors.white,
//                   backgroundImage: AssetImage('images/5yattree.jpeg'),
//                 ),
//                 accountName: Text(
//                   '5yattree',
//                   style: TextStyle(
//                     letterSpacing: 1.0,
//                     fontSize: 25,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 accountEmail: Text(
//                   '5yattree@email.com',
//                   style: TextStyle(
//                     letterSpacing: 0.7,
//                     fontSize: 15,
//                     fontWeight: FontWeight.normal,
//                   ),
//                 ),
//                 onDetailsPressed: () {
//                   print('Arrow will rotate after clicking');
//                 },
//                 decoration: BoxDecoration(
//                   color: Colors.teal[300],
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(40.0),
//                     bottomRight: Radius.circular(40.0),
//                   ),
//                 ),
//                 otherAccountsPictures: [
//                   CircleAvatar(
//                     backgroundColor: Colors.white,
//                     backgroundImage: AssetImage('images/5yattree_2.jpeg'),
//                   ),
//                 ],
//               ),
//               ListTile(
//                 leading: Icon(
//                   Icons.home,
//                   color: Colors.grey[850],
//                 ),
//                 title: Text('Home'),
//                 onTap: () {
//                   print('Home is clicked');
//                 },
//                 trailing: Icon(Icons.add),
//               ),
//               ListTile(
//                 leading: Icon(
//                   Icons.settings,
//                   color: Colors.grey[850],
//                 ),
//                 title: Text('Setting'),
//                 onTap: () {
//                   print('Setting is clicked');
//                 },
//                 trailing: Icon(Icons.add),
//               ),
//               ListTile(
//                 leading: Icon(
//                   Icons.question_answer,
//                   color: Colors.grey[850],
//                 ),
//                 title: Text('Q&A'),
//                 onTap: () {
//                   print('Q&A is clicked');
//                 },
//                 trailing: Icon(Icons.add),
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             Container(
//               color: Colors.green[200],
//             ),
//             Container(
//               color: Colors.green[300],
//             ),
//             Container(
//               color: Colors.green[400],
//             ),
//           ],
//         ),
//       ),
//     );

//   }
//}

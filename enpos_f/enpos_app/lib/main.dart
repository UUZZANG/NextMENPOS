import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_proxy/http_proxy.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:enpos_app/menu_layout.dart';  

void main() async{
    await dotenv.load(fileName: '.env');
  	//APP에서 PROXY 거쳐서 접속함 명시
    WidgetsFlutterBinding.ensureInitialized();
    HttpProxy httpProxy = await HttpProxy.createHttpProxy();
    HttpOverrides.global=httpProxy;
  	runApp(const MyApp());
}


class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		return const MaterialApp(
      debugShowCheckedModeBanner: false,
			home: MainPage(),
		);
	}
}





class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

	var usernameController 	= TextEditingController(); 
	var passwordController 	= TextEditingController(); 
  bool _saveId 			      = true;
	bool _autoLogin 		    = true;
	static final storage 	  =  FlutterSecureStorage();
  Map<String, dynamic>  userInfo 		    = {};
  dynamic storedId = null;
  // 최초 로딩시 수행
	@override
	void initState() {
		super.initState();
		// Frame을 다 불러온뒤 callback 실행
		WidgetsBinding.instance.addPostFrameCallback((_) {
		_checkLogin();
		});
	}

  // 로그인 정보 있는지 확인 후 없으면 로그인 아니면 홈으로 이동
  _checkLogin() async {
      dynamic storedId = await storage.read(key: "id")?? '';
      setState( () { });
      if (storedId != null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MenuLayout(id: storedId)));
      } else {
        print('login required!');
      }
  }

  // Login Action
  loginAction(accountName, password) async {

		//Map params = { 'userId' : '$accountName', 'password' : '$password'};
    //Map params = { 'userId' : 'RSMEDUCO', 'password' : '1234'};

		final res = await http
			.post(Uri.parse('${dotenv.env['BASEURL']}/auth/login'), body:jsonEncode({ 'userId' : '$accountName', 'password' : '$password'}), headers: {"Access-Control-Allow-Origin": "*", 'Content-Type': 'application/json'});
      // {"isFailed":false,"authToken":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJSU00iLCJpYXQiOjE3MDU5OTE1MzJ9.7q9L7rozgh_CPdq5ijqI1X8aIxfiqvg3tNc31XmtXsk","message":"로그인 되었습니다."}


		if (res.statusCode == 200) {
			 print('접속 성공!'+ res.body);
       // 로그인 결과 이상이 없는 경우 사용자 정보를 서버로 부터 가져옴

       final res1  = await http
           .get(Uri.parse('${dotenv.env['BASEURL']}/auth/userinfo?userId=$accountName'), headers: {"Access-Control-Allow-Origin": "*"});
       if (res1.statusCode == 200) {
         // {"pin":"RSMEDUCO","emailid":"jump502@samsung.com","name":"부품대리점","phone1":"043-000-0000","phone2":null,"useflag":"Y","usertype":"V","wgid":4,"companyId":"RSMEDUCO"}
         print('사용자 정보 성공!' + jsonDecode(res1.body)['pin'] );
         String jsonData = res1.body;
         var myJson = jsonDecode(jsonData)['pin'];
         await storage.write(
             key		: "id",
             value	: myJson
         );
         return true;
       }

	 	 } else {
	 	 	  print('접속 실패');
		 	  return false;
	 	 }
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
		debugShowCheckedModeBanner: false,  
      	theme: ThemeData(fontFamily: 'RKM KR'),
      	themeMode: ThemeMode.system,
      	home: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
				child: Column(
						mainAxisSize: MainAxisSize.min,
						mainAxisAlignment: MainAxisAlignment.start,
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [

							const SizedBox(height: 60),       


							/**********************************************************************
															Mobile ENPOS
							**********************************************************************/
							const SizedBox(                   
								width: double.infinity,
								child: Text(
									'Mobile ENPOS',
									textAlign: TextAlign.center,                 
									style: TextStyle(
										color: Color(0xFF4F5670),
										fontSize: 40,       
										fontFamily: 'RKM R',                     
										fontWeight: FontWeight.w500,
										height: 0.04,
										letterSpacing: -1.20,
									),
								),
							),
								

							/**********************************************************************
															Carousel
							**********************************************************************/
							MainCarouselSlider(),	            





							/**********************************************************************
															ID 
							**********************************************************************/
							SizedBox(                         
								width:  double.infinity,
								height: 60,
								child:  Scaffold ( body: 
													TextField(
														controller: usernameController,
														decoration: const InputDecoration(
															labelText: '아이디를 입력하세요',
														),
													) ,
													) ,       
							),
					
							/**********************************************************************
															PASSWORD 
							**********************************************************************/
							SizedBox(                         
								width:  double.infinity,
								height: 60,
								child:  Scaffold ( body: 
													TextField(
														controller:	passwordController ,
														decoration: const InputDecoration(
															labelText: '패스워드를 입력하세요',
														),
													) ,
												) ,       
							),
								
							const SizedBox(height: 10),
							/**********************************************************************
															ID 저장하기 
							**********************************************************************/
											
							Container(
								width: double.infinity,
								child: Row(
									mainAxisSize: MainAxisSize.min,
									mainAxisAlignment: MainAxisAlignment.start,
									crossAxisAlignment: CrossAxisAlignment.center,
									children: [										
                      Card (    
                        elevation: 0,                                                        
                        child:  Switch (
                              value: _saveId,
                              onChanged: (value) {
                              setState(() {
                                _saveId = value;
                              });
                              },
                          ),                                                                                                
                        ),
                      const Text(
                        'ID 저장하기',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: -0.28,
                        ),
                      ),
                  ],
								),
							),



							const SizedBox(height: 10),

							/**********************************************************************
															자동 로그인 
							**********************************************************************/
											
							Container (    
								width: double.infinity,
								child: Row(
									mainAxisSize: MainAxisSize.min,
									mainAxisAlignment: MainAxisAlignment.start,
									crossAxisAlignment: CrossAxisAlignment.center,
									children: [
                      /***********   Switch  ***********/
                      Card (   
                        elevation: 0,                              
                        child: Switch (
                              value: _autoLogin,
                              onChanged: (value) {
                              setState(() {
                                _autoLogin = value;
                              });
                              },
                          ),                                                                                                                  
                      ),
										  /*********** TEXT : 자동 로그인 ***********/
                      const Text(
                        '자동 로그인',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: -0.28,
                        ),
                      ),
									],
								),
							),

							const SizedBox(height: 20),

							/**********************************************************************
															로그인 BUTTON
							**********************************************************************/

            Center(               
                      child: OutlinedButton(     
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(style:BorderStyle.none),
                          ),                                   
                              onPressed: () async {
                              if (await loginAction(usernameController.text, passwordController.text) ==
                                true) {	                
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MenuLayout(id : storedId)));
                              } else {
                                print('로그인 실패');
                              }
                              },
                              child: Container(
                                        width: 260,
                                        height: 47,
                                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                                        decoration: ShapeDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment(0.97, 0.23),
                                                end: Alignment(-0.97, -0.23),
                                                colors: [Color(0xFF7F859C), Color(0xFF59627F)],
                                            ),
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(width: 1, color: Color(0xFF79819C)),
                                                borderRadius: BorderRadius.circular(32),
                                            ),
                                            shadows: [
                                                BoxShadow(
                                                    color: Color(0x4C666E89),
                                                    blurRadius: 24,
                                                    offset: Offset(8, 8),
                                                    spreadRadius: 0,
                                                ),BoxShadow(
                                                    color: Color(0x26666E89),
                                                    blurRadius: 16,
                                                    offset: Offset(-8, 8),
                                                    spreadRadius: 0,
                                                )
                                            ],
                                        ),
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                                Expanded(
                                                    child: Container(
                                                        height: 17,
                                                        child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                                Text(
                                                                    'LOG-IN',
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 14,
                                                                        fontFamily: 'Inter',
                                                                        fontWeight: FontWeight.w500,
                                                                        height: 0,
                                                                        letterSpacing: -0.28,
                                                                    ),
                                                                ),
                                                            ],
                                                        ),
                                                    ),
                                                ),
                                            ],
                                        ),
                                    )

                        ),
            ),
              
                 
							

				
					]),
			)			//HOME>> CHILD
      
  
    );
  }


}


class MainCarouselSlider extends StatelessWidget {
  
  const MainCarouselSlider({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      child:  Container(
                              width: double.infinity,
                              //height: 630,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                              child:CarouselSlider(
                                              // Set carousel controller
                                              // carouselController: carouselController,
                                              items: [1, 2, 3, 4, 5].map((i) {
                                                return Builder(
                                                  builder: (BuildContext context) {
                                                    return Container(
                                                        width: MediaQuery.of(context).size.width,
                                                        margin: const EdgeInsets.symmetric(horizontal: 0.0),
                                                        //decoration: const BoxDecoration(color: Colors.amber),
                                                        child: Center(
                                                          child: Image(image: AssetImage('assets/gall01.jpg'))                      
                                                       
                                                        ));
                                                  },
                                                );
                                              }).toList(),
                                              options: CarouselOptions(

                                                // Set the height of each carousel item
                                                height: 250,

                                                // Set the size of each carousel item
                                                // if height is not specified
                                                aspectRatio: 16 / 9,

                                                // Set how much space current item widget
                                                // will occupy from current page view
                                                viewportFraction: 0.8,

                                                // Set the initial page
                                                initialPage: 0,

                                                // Set carousel to repeat when reaching the end
                                                enableInfiniteScroll: true,

                                                // Set carousel to scroll in opposite direction
                                                reverse: false,

                                                // Set carousel to display next page automatically
                                                autoPlay: true,

                                                // Set the duration of which carousel slider will wait
                                                // in current page utill it moves on to the next
                                                autoPlayInterval: const Duration(seconds: 3),

                                                // Set the duration of carousel slider
                                                // scrolling to the next page
                                                autoPlayAnimationDuration: const Duration(milliseconds: 800),

                                                // Set the carousel slider animation
                                                autoPlayCurve: Curves.fastOutSlowIn,

                                                // Set the current page to be displayed
                                                // bigger than previous or next page
                                                enlargeCenterPage: true,

                                                // Do actions for each page change
                                                onPageChanged: (index, reason) {},

                                                // Set the scroll direction
                                                scrollDirection: Axis.horizontal,
                                              ),
                                            ),                                      
                          ),
      );
   
  }
}




import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterappsky/find/find_page.dart';
import 'package:flutterappsky/main_index_provider.dart';
import 'package:flutterappsky/utils/Constants.dart';
import 'package:flutterappsky/utils/SPUtils.dart';
import 'package:provider/provider.dart';

import 'home/home_page.dart';
import 'me/me_page.dart';
Future getImei() async{
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if(Platform.isIOS){
    //ios相关代码
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    print('Running on ${iosInfo.identifierForVendor}');
  }else if(Platform.isAndroid){
    //android相关代码
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.androidId}');  // e.g. "Moto G (4)"
    SPUtils.setString(Constants.IMEI, androidInfo.androidId);
  }
}

void main() {
  SPUtils.getInstance();
  getImei();
  runApp(
    //MultiProvider全局监听多种状态
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainIndexProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'MissPStime'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //底部导航对应的widget
  List <Widget> _bodys=[HomePage(),FindPage(),MePage()];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: true);
    return Scaffold(
      //导航栏
      appBar: AppBar(
        title: Text(widget.title),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.apps,
                color: Colors.white,
              ),
              //打开抽屉菜单
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.message,
              color: Colors.white,
            ),
          ),
        ],
      ),
      //抽屉菜单
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.blue),
              height: 200.h,
              child: Center(
                child: Text("drawer head"),
              ),
            ),
            ListTile(
              //设置内容边距，默认是 16，但我们在这里设置为 0
              contentPadding:
                  EdgeInsets.only(left: 10.w, top: 0, right: 10.w, bottom: 0),
              //前置图片
              leading: IconButton(
                icon: Icon(
                  Icons.phone,
                ),
              ),
              title: Text("title"),
              //副标题
              subtitle: Text("subtitle"),
              //dense，使字体更小
              dense: false,
              //后置图片
              trailing: Icon(
                Icons.arrow_forward_ios,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
              onLongPress: (){
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              //设置内容边距，默认是 16，但我们在这里设置为 0
              contentPadding:
              EdgeInsets.only(left: 10.w, top: 0, right: 10.w, bottom: 0),
              //前置图片
              leading: IconButton(
                icon: Icon(
                  Icons.phone,
                ),
              ),
              title: Text("title"),
              //副标题
              subtitle: Text("subtitle"),
              //dense，使字体更小
              dense: false,
              //后置图片
              trailing: Icon(
                Icons.arrow_forward_ios,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
              onLongPress: (){
                Navigator.of(context).pop();
              },
              enabled: false,
            ),
            ListTile(
              //选中，内容会变成主题色
              selected: true,
              //设置内容边距，默认是 16，但我们在这里设置为 0
              contentPadding:
              EdgeInsets.only(left: 10.w, top: 0, right: 10.w, bottom: 0),
              //前置图片
              leading: IconButton(
                icon: Icon(
                  Icons.phone,
                ),
              ),
              title: Text("title"),
              //副标题
              subtitle: Text("subtitle"),
              //dense，使字体更小
              dense: false,
              //后置图片
              trailing: Icon(
                Icons.arrow_forward_ios,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
              onLongPress: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      //底部导航
      bottomNavigationBar: BottomNavigationBar(
        //底部导航配置
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home),title: Text("Home")),
          BottomNavigationBarItem(icon: Icon(Icons.find_in_page),title: Text("Find")),
          BottomNavigationBarItem(icon: Icon(Icons.account_box),title: Text("Me")),
        ],
        //当前选中的index
        currentIndex: context.watch<MainIndexProvider>().getIndex(),
        //点击事件
        onTap: (int index){
           context.read<MainIndexProvider>().setIndex(index);
        },
        //选中的颜色，默认为主题色
        fixedColor: Colors.blue,
        //底部导航栏的颜色
        backgroundColor: Colors.white,
      ),

      body: _bodys[context.watch<MainIndexProvider>().getIndex()],
     // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
/*
* 管理状态，下发事件，更新状态
* */
class MainIndexProvider with ChangeNotifier {
  //1.定义状态
  int _index=1;

  //2.提供获取状态的method
  int getIndex(){
    return _index;
  }

  //3.提供更新状态的method,并通知状态改变
  void setIndex(int index){
    _index=index;
    notifyListeners();
  }

  //4.在主页使用provider全局监听管理状态

  //5.使用provider提供的状态
  //context.watch<MainIndexProvider>().getIndex()   watch会重新构建widget
  //context.read<MainIndexProvider>().setInder()   read不会重新构建widget

}
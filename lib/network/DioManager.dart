import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:flutterappsky/Config.dart';
import 'package:flutterappsky/utils/Constants.dart';
import 'package:flutterappsky/utils/SPUtils.dart';

import 'ResultCode.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
/*
 * 网络请求管理类
 */
class DioManager {

  //写一个单例
  //在 Dart 里，带下划线开头的变量是私有变量
  static DioManager _instance;


  static DioManager getInstance() {
    if (_instance == null) {
      _instance = DioManager();
    }
    return _instance;
  }
  Dio dio = new Dio();
  DioManager() {
    // Set default configs
    dio.options.headers = {
      "token":SPUtils.getString(Constants.TOKEN),
      "imei": SPUtils.getString(Constants.IMEI),
//      "signMsg":'_token',
    };
    dio.options.baseUrl = Config.baseUrl;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;

    dio.interceptors.add(LogInterceptor(responseBody: Config.isDebug)); //是否开启请求日志
  }

  //get请求
  get(String url, Map params,Function successCallBack,Function errorCallBack) async {
    _requstHttp(url, successCallBack, 'get', params, errorCallBack);
  }

  //post请求
  post(String url, params,Function successCallBack,Function errorCallBack) async {
    _requstHttp(url, successCallBack, "post", params, errorCallBack);
  }

  _requstHttp(String url, Function successCallBack,
      [String method, Map params, Function errorCallBack]) async {
    Response response;
    params["channelId"]="3";
    params["mobileType"]="2";
    params["versionNumber"]=Config.VERSION_NUMBER;
    //进行排序加密
    var signMsg = getSignMsg(params, SPUtils.getString(Constants.TOKEN));
    dio.options.headers["signMsg"]=signMsg;
    try {
      if (method == 'get') {
        if (params != null && params.length>0) {
          response = await dio.get(url, queryParameters: params);
        } else {
          response = await dio.get(url);
        }
      } else if (method == 'post') {
        if (params != null && params.length>0) {
          response = await dio.post(url, data: params);
        } else {
          response = await dio.post(url);
        }
      }
    }on DioError catch(error) {
      // 请求错误处理
      Response errorResponse;
      if (error.response != null) {
        errorResponse = error.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      // 请求超时
      if (error.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = ResultCode.CONNECT_TIMEOUT;
      }
      // 一般服务器错误
      else if (error.type == DioErrorType.RECEIVE_TIMEOUT) {
        errorResponse.statusCode = ResultCode.RECEIVE_TIMEOUT;
      }

      // debug模式才打印
      if (Config.isDebug) {
        print('请求异常: ' + error.toString());
        print('请求异常url: ' + url);
        print('请求头: ' + dio.options.headers.toString());
        print('method: ' + dio.options.method);
      }
      _error(errorCallBack, error.message);
      return '';
    }
    // debug模式打印相关数据
    if (Config.isDebug) {
      print('请求url: ' + url);
      print('请求头: ' + dio.options.headers.toString());
      if (params != null) {
        print('请求参数: ' + params.toString());
      }
      if (response != null) {
        print('返回参数: ' + response.toString());
      }
    }
    String dataStr = json.encode(response.data);
    Map<String, dynamic> dataMap = json.decode(dataStr);
    if (dataMap == null || dataMap['state'] == 0) {
      _error(errorCallBack, '错误码：' + dataMap['errorCode'].toString() + '，' + response.data.toString());
    }else if (successCallBack != null) {
      successCallBack(dataMap);
    }
  }
  _error(Function errorCallBack, String error) {
    if (errorCallBack != null) {
      errorCallBack(error);
    }
  }

  String getSignMsg(Map map, String token) {
    var sortedKeys = map.keys.toList()..sort();
    Map newMap = new Map();
    for (int i = 0; i < sortedKeys.length; i++) {
      newMap[sortedKeys[i]] = map[sortedKeys[i]];
    }

    StringBuffer sb = new StringBuffer();
    newMap.forEach((k, v) {
      sb.write(k + '=' + v + '|');
    });
    String data = sb.toString().substring(0, sb.toString().length - 1);
    String signMsg = generateMd5(
        Config.app_key +
            token +
            data);
    return signMsg;
  }

// md5 加密
  String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    String mmdd = hex.encode(digest.bytes);
    return mmdd;
  }
}
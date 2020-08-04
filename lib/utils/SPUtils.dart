import 'package:shared_preferences/shared_preferences.dart';

class SPUtils {
  static SharedPreferences _spUtils;

  static Future<SharedPreferences> getInstance() async {
    if (_spUtils == null) {
      _spUtils = await SharedPreferences.getInstance();
    }
    return _spUtils;
  }


  static setString(String key,String value){
    _spUtils.setString(key, value);
  }

  static getString(String key){
   String value = _spUtils.getString(key);
   return value;
  }
}

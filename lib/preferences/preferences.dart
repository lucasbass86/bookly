import 'package:bookly/utils/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String _license = '';
  static String get license => _prefs.getString('license') ?? _license;
  static set license(String value) {
    _license = value;
    _prefs.setString('license', value);
  }

  static String _email = '';
  static String get email => _prefs.getString('email') ?? _email;
  static set email(String value) {
    _email = value;
    _prefs.setString('email', value);
  }

  static String _userId = '';
  static String get userId => _prefs.getString('userId') ?? _userId;
  static set userId(String value) {
    _userId = value;
    _prefs.setString('userId', value);
  }

  static BookOrder _bookOrder = BookOrder.title;
  static BookOrder get bookOrder {
    String? order = _prefs.getString('bookOrder');
    if (order != null) {
      return BookOrder.values.byName(order);
    } else {
      return _bookOrder;
    }
  }

  static set bookOrder(BookOrder value) {
    _bookOrder = value;
    _prefs.setString('bookOrder', _bookOrder.name);
  }

  static BookSort _bookSort = BookSort.asc;
  static BookSort get bookSort {
    String? order = _prefs.getString('bookSort');
    if (order != null) {
      return BookSort.values.byName(order);
    } else {
      return _bookSort;
    }
  }

  static set bookSort(BookSort value) {
    _bookSort = value;
    _prefs.setString('bookSort', _bookSort.name);
  }
}

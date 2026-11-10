import 'package:bookly/utils/enums.dart';
import 'package:flutter/widgets.dart';

class MainProvider with ChangeNotifier {
  BookState _state = BookState.all;
  BookState get state => _state;
  set state(BookState value) {
    _state = value;
    notifyListeners();
  }

  BookCategory _category = BookCategory.all;
  BookCategory get category => _category;
  set category(BookCategory value) {
    _category = value;
    notifyListeners();
  }
}

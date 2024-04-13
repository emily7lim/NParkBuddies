import 'package:flutter/foundation.dart';

class UserData extends ChangeNotifier {
  String _username = '';
  String _email = '';

  String get username => _username;
  String get email => _email;

  set username(String username) {
    _username = username;
    notifyListeners();  // Notify all listening widgets to rebuild
  }

  set email(String email){
    _email = email;
    notifyListeners();
  }
}

//everytime you need the data, just call this, and store into a string: Provider.of<UserData>(context, listen:false).username;
//everytime you want to set the username, call this : Provider.of<UserData>(context, listen: false).username = username;

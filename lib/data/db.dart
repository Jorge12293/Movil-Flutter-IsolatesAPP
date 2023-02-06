import 'package:appisolates/data/user.dart';

class DB {
  List<User> users = [];
  int get count =>users.length;
  
  User create(){
    return User(DateTime.now().toString(),18);
  }

  void add(User user){
    users.add(user);
  }
}
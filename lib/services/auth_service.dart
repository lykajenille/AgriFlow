import '../models/user.dart';

class AuthService {

  List<User> users = [

    User("admin","admin123","admin"),
    User("farmer","1234","farmer"),

  ];

  User? login(String username,String password){

    for(User user in users){
      if(user.username == username && user.password == password){
        return user;
      }
    }

    return null;
  }

}
class User {

  String username;
  String password;
  String role;

  User(this.username, this.password, this.role);

  bool isAdmin(){
    return role == "admin";
  }

}
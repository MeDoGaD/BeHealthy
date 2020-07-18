class Account{
  String username;
  String password;
  int age;
  double current;
  double estimated;
  int id;

  Account(this.username,this.password,this.age,this.current,this.estimated,this.id);

Account.map(dynamic obj){
this.id=obj['id'];
this.username=obj['username'];
this.password=obj['password'];
this.age=obj['age'];
this.current=obj['current'];
this.estimated=obj['estimated'];
}

int get _id =>id;
String get _username =>username;
String get _password =>password;
int get _age => age;
double get _current =>current;
double get _estimated => estimated;

Map<String ,dynamic>toMap(){
var map =new Map<String,dynamic>();
map['id']=_id;
map['username']=_username;
map['password']=_password;
map['age']=_age;
map['current']=_current;
map['estimated']=_estimated;

return map;
}

Account.fromMap(Map<String,dynamic>map){
this.id=map['id'];
this.username=map['username'];
this.password=map['password'];
this.age=map['age'];
this.current=map['current'];
this.estimated=map['estimated'];
}

}
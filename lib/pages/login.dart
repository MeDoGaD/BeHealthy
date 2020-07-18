import 'package:flutter/material.dart';
import 'package:behealthy/pages/register.dart';
import 'package:behealthy/Model/accounts_db.dart';
import 'package:behealthy/Model/accounts.dart';
import 'package:behealthy/pages/calorieshistoty.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';

List accs;
int index;
 checkAccount()async{
  var db = new AccountsHelper();
   accs=await db.getAccounts();
}
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  var mymap = {};
  var title = '';
  var body = {};
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();

  final UserController = TextEditingController();
  final PassController = TextEditingController();
var db = AccountsHelper();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);

    firebaseMessaging.configure(
        onLaunch: (Map<String , dynamic> msg){
          print("onLaunch called ${(msg)}");
        },
        onResume: (Map<String , dynamic> msg){
          print("onResume called ${(msg)}");
        },
        onMessage:  (Map<String , dynamic> msg){
          print("onResume called ${(msg)}");
          mymap = msg;
          showNotification(msg);
        }
    );


    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));

    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('onIosSettingsRegistered');
    });

  }


  showNotification(Map<String, dynamic> msg) async {
    var android = new AndroidNotificationDetails(
        "1", "channelName", "channelDescription");
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, ios);
    msg.forEach((k, v) {
      title = k;
      body = v;
      setState(() {});
    });
    await flutterLocalNotificationsPlugin.show(1, "${body.keys}", "${body.values}", platform);
  }

  @override
  Widget build(BuildContext context) {
    checkAccount();
    double scwidth = MediaQuery
        .of(context)
        .size
        .width;
    double scheight = MediaQuery
        .of(context)
        .size
        .height;
    @override
    void initState() {
      super.initState();
      db = AccountsHelper();
      setState(() {
        checkAccount();
      });
    }


    return  Scaffold(
        appBar: AppBar(title: Text('Login'),backgroundColor: Colors.deepPurple,),
        body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(controller: UserController,decoration: InputDecoration(hintText:'Username',icon: Icon(Icons.perm_identity)),),
            SizedBox(height: scheight*1/40,),
            TextField(controller: PassController,obscureText: true,decoration: InputDecoration(hintText:'Password',icon: Icon(Icons.lock)),),
            SizedBox(height: scheight*1/35,),
            Container(width: scwidth*2/5,
              child: RaisedButton(color: Colors.white,
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.deepPurple, fontSize: 20),
                  ),
                  onPressed: (){
                    HapticFeedback.vibrate();
                    setState(() {
                      checkAccount();
                    });
                    int check=0;
                    for(int i=0;i<accs.length;i++)
                    {
                      if(Account.fromMap(accs[i]).username==UserController.text&&Account.fromMap(accs[i]).password==PassController.text)
                      {
                        index=i;
                        check=1;
                        break;
                      }
                    }
                    String msg;
                    if(check==1)
                        msg='Login successfully :)';
                    else
                      msg='Login failed :(';

                          showDialog(context: context,builder: (BuildContext context){
                            return AlertDialog(title: Text('Confirmation',style: TextStyle(color: Colors.deepPurple),),content: Text('$msg'),
                            actions: <Widget>[
                               FlatButton(child: Text('Ok',style: TextStyle(color: Colors.deepPurple),),onPressed: (){
                                 if(check==1){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DetailedCalories(Account.fromMap(accs[index]))));
                                 }
                                 else
                                 Navigator.of(context).pop();
                            }),
                            ],);
                          });
                     setState(() {

                     });
                  },
                  shape: new RoundedRectangleBorder(side: BorderSide(color: Colors.black,width:1 ),
                      borderRadius: new BorderRadius.circular(40.0))),
            ),
            Container(width: scwidth*4/7,
              child: RaisedButton(color: Colors.white,
                  child: Text(
                    'Create new account',
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  ),

                  onPressed: (){
                    HapticFeedback.vibrate();
                    Navigator.of(context).push(MaterialPageRoute(builder:(context)=>new Register()));
                  },
                  shape: new RoundedRectangleBorder(side: BorderSide(color: Colors.black,width:1 ),
                      borderRadius: new BorderRadius.circular(40.0))),
            ),
          ],
        ),),

    );
  }
}
import 'package:flutter/material.dart';
import 'package:behealthy/Model/accounts.dart';
import 'package:behealthy/Model/accounts_db.dart';
import 'package:behealthy/pages/login.dart';
import 'calorieshistoty.dart';
import 'dart:async';
import 'package:flutter/services.dart';

List accs;
int index;
getAccount(String name)async{
  var db = new AccountsHelper();
  accs=await db.getAccounts();
  for(int i=0;i<accs.length;i++)
  {
    if(Account.fromMap(accs[i]).username==name)
    {
      index=i;
      break;
    }
  }
}




class Register extends StatefulWidget{
  @override
  _RegisterState createState()=>_RegisterState();
}
class _RegisterState extends State<Register>
{

  void showBottomSheet(){
    double scheight = MediaQuery
        .of(context)
        .size
        .height;
    double scwidth = MediaQuery
        .of(context)
        .size
        .width;
    showModalBottomSheet(context: context, builder: (BuildContext context){
      return new Container(height:scheight*1/6,
        padding: EdgeInsets.only(top:scheight*1/100,left: scwidth*1/25),
        child:Column(children: <Widget>[
          Text('Congratulations',style: TextStyle(color: Colors.deepPurple,fontSize:22 ),),
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
              Text('You have registered successfully :) '),SizedBox(width:scwidth*1/25,),
              FlatButton(child: Text('Ok',style: TextStyle(color: Colors.deepPurple),),onPressed: (){
               setState(() {
                 getAccount(UserController.text);
               });
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DetailedCalories(Account.fromMap(accs[index]))));},)
            ],),
          ),
        ],)
      );
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }
  var db =new AccountsHelper();
  
  final UserController = TextEditingController();
  final PassController = TextEditingController();
  final AgeController = TextEditingController();
  final currController = TextEditingController();
  final estiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<bool>_onBackButton(){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          Login()), (Route<dynamic> route) => false);
    }
    double scwidth = MediaQuery
        .of(context)
        .size
        .width;
    double scheight = MediaQuery
        .of(context)
        .size
        .height;
    return WillPopScope(onWillPop: _onBackButton,
      child: Scaffold(resizeToAvoidBottomPadding: true,
        appBar: AppBar(title: Text('Create new account'),backgroundColor: Colors.deepPurple,),
        body:Padding(
          padding: EdgeInsets.only(top:scheight*1/12 ),
          child: Column(children: <Widget>[
              TextField(controller: UserController,decoration: InputDecoration(hintText:'Username',icon: Icon(Icons.perm_identity)),),
              SizedBox(height: scheight*1/35,),
              TextField(controller:PassController,obscureText: true,decoration: InputDecoration(hintText:'Password',icon: Icon(Icons.lock)),),
              SizedBox(height: scheight*1/35,),
              TextField(controller:AgeController,keyboardType: TextInputType.number,decoration: InputDecoration(hintText:'Age',icon: Icon(Icons.directions_walk)),),
              SizedBox(height: scheight*1/35,),
              TextField(controller: currController,keyboardType: TextInputType.number,decoration: InputDecoration(hintText:'Current weight',icon: Icon(Icons.line_weight)),),
              SizedBox(height: scheight*1/35,),
              TextField(controller: estiController,keyboardType: TextInputType.number,decoration: InputDecoration(hintText:'Estimated weight',icon: Icon(Icons.line_weight)),),
              SizedBox(height: scheight*1/20,),
              Container(width: scwidth*1/3,
                child: RaisedButton(color: Colors.deepPurple,
                  child: Text(
                    'Create',
                    style: TextStyle(color: Colors.greenAccent, fontSize: 22),
                  ),
                  onPressed: ()async{
                    HapticFeedback.vibrate();
                    int nextID=await db.getCount();
                  print(double.tryParse(currController.text));
                  try {
                    int savednum = await db.saveAccount(new Account(
                        UserController.text, PassController.text,
                        int.parse(AgeController.text),
                        double.parse(currController.text),
                        double.parse(estiController.text), nextID + 1));
                  }
                  catch(e) {
                    showDialog(context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(title: Text('Registered failed :( ',
                            style: TextStyle(color: Colors.deepPurple),),
                            content: Text('The username isn'+"'"+'t available'),
                            actions: <Widget>[
                              FlatButton(child: Text('Ok',
                                style: TextStyle(
                                    color: Colors.deepPurple),),
                                  onPressed: () {
                                    HapticFeedback.vibrate();
                                    Navigator.of(context).pop();
                                  }),
                            ],);
                        });
                    return;
                  }

                  setState(() {
                    getAccount(UserController.text);
                  });
                   showBottomSheet();
                  },
                  shape: new RoundedRectangleBorder(side: BorderSide(color: Colors.black,width:1),
                      borderRadius: new BorderRadius.circular(40.0))),
              ),

          ],),
        ),

      ),
    );
  }
}
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:behealthy/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:behealthy/pages/submitfoods.dart';
import 'package:behealthy/Model/accounts.dart';
import 'package:behealthy/Model/calories_db.dart';
import 'package:behealthy/Model/calories.dart';

List submissions;
int len=0;

double calculateWeight(int len,double curr,double esti)
{
  double burnedCalories = 1850.0;
  double cal_kg = 1596.0;
  double weight = esti - curr;
  int length=0;
  if(len==0)
    length=180;
  else if (len==1)
    length=90;
  else
    length=30;
  
  if(esti>=curr)
    {

      double totaldiff=burnedCalories*length;
      double total=((weight*cal_kg)+totaldiff)/length;
      return  total.roundToDouble();
    }
  else
    {
      double percent= weight.abs()/length;
      double total=(1-percent)*cal_kg;
      return  total.roundToDouble();
    }
  
}
String todaydate = DateTime.now().day.toString()+"/"+DateTime.now().month.toString()+"/"+DateTime.now().year.toString();

 getSubmissions(int id)async{
  var db=CaloriesHelper();
  submissions=await db.getSubmissions(id);
  len=submissions.length;
}



double totalCalories = 0;

class DetailedCalories extends StatefulWidget {
  Account acc;
  DetailedCalories(this.acc);
  @override
  _detailsState createState() => _detailsState(acc);
}

class _detailsState extends State<DetailedCalories> {
var CaloriesController = TextEditingController();

@override
void initState() {
  super.initState();
  db = CaloriesHelper();

  setState(() {
    getSubmissions(acc.id);
  });
}

  void showBottomSheet(Account acc){
    double scheight = MediaQuery
        .of(context)
        .size
        .height;
    double scwidth = MediaQuery
        .of(context)
        .size
        .width;
    showModalBottomSheet(context: context, builder: (BuildContext context){
      return new Container(height:scheight*3/13,
          padding: EdgeInsets.only(top:scheight*1/40),
          child:Column(children: <Widget>[
            Text('Select a choice',style: TextStyle(fontSize: 22,color: Colors.deepPurple),),
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[

                Container(width:scwidth*0.51 ,child: TextField(controller: CaloriesController,decoration: InputDecoration(hintText:'Enter calories manually ..  '),keyboardType:TextInputType.number,)),
                IconButton(icon:Icon(Icons.date_range,color: Colors.deepPurple,),onPressed: (){
                  HapticFeedback.vibrate();
                  showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2200)).then((val){setState(() {
                    todaydate=val.day.toString()+"/"+val.month.toString()+"/"+val.year.toString();});
                  setState(() {});
                  });
                },),
                Container(width:scwidth*0.23,
                  child: RaisedButton(child: Text('Submit',style: TextStyle(color: Colors.deepPurple),),onPressed: ()async{
                    totalCalories=double.parse(CaloriesController.text);

                    if(totalCalories!=0) {
                      int found = 0;
                      for (int i = 0; i < submissions.length; i++) {
                        if (Calories
                            .fromMap(submissions[i])
                            .date == todaydate) {
                          found = 1;
                          await db.updateSubmission(new Calories(
                              acc.id, todaydate, totalCalories + Calories
                              .fromMap(submissions[i])
                              .calories));
                          break;
                        }
                      }
                      if (found == 0) {
                        await db.saveSubmission(
                            new Calories(acc.id, todaydate, totalCalories));
                      }

                      double Upweight = (1.0 * (totalCalories - 1850)) /
                          1596;
                      await db.updateWeight(Account(
                          acc.username, acc.password, acc.age,
                          acc.current + Upweight, acc.estimated, acc.id));
                      HapticFeedback.vibrate();
                      Timer(Duration(milliseconds: 120), () {
                        HapticFeedback.vibrate();
                      });

                      showDialog(context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(title: Text('Submitted :)',
                              style: TextStyle(color: Colors.deepPurple),),
                              content: Text('Your history is updated'),
                              actions: <Widget>[
                                FlatButton(child: Text('Ok',
                                  style: TextStyle(
                                      color: Colors.deepPurple),),
                                    onPressed: () {
                                      HapticFeedback.vibrate();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                          DetailedCalories(acc)), (Route<dynamic> route) => false);                                    }),
                              ],);
                          });
                      totalCalories = 0.0;
                    }
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DetailedCalories(Account.fromMap(accs[index]))));
                  },
                    shape: new RoundedRectangleBorder(side: BorderSide(color: Colors.deepPurple,width:1)),
                  ),
                ),
              ],),
            ),
            Padding(
              padding: const EdgeInsets.only(top :7),
              child: RaisedButton(color: Colors.deepPurple,
                  child: Text(
                    'Select Foods',
                    style: TextStyle(color: Colors.greenAccent, fontSize: 22),
                  ),
                  onPressed: ()async{

                  HapticFeedback.vibrate();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) =>
                          SubmitFoods(acc)), (
                      Route<dynamic> route) => false);
                   // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SubmitFoods(Account.fromMap(accs[index]))));

                  },
                  shape: new RoundedRectangleBorder(side: BorderSide(color: Colors.black,width:1),
                      borderRadius: new BorderRadius.circular(40.0))),
            ),

          ],)
      );
    });
  }


  var db=CaloriesHelper();
  Account acc;
  _detailsState(this.acc);
  @override
  Widget build(BuildContext context) {
    void start(con){
      getSubmissions(acc.id);
      setState(() {});
    }

    WidgetsBinding.instance
        .addPostFrameCallback((_) => start(context));

    bool canVibrate = false;
    //setState(() {});
    double scwidth = MediaQuery
        .of(context)
        .size
        .width;
    double scheight = MediaQuery
        .of(context)
        .size
        .height;

    Future<bool>_onBackButton(){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          Login()), (Route<dynamic> route) => false);
    }
    return WillPopScope(onWillPop: _onBackButton,
      child: Scaffold(appBar: AppBar(title: Text('Calories History'),backgroundColor: Colors.deepPurple,actions: <Widget>[
        IconButton(icon: Icon(Icons.refresh),onPressed: (){
          HapticFeedback.vibrate();
          Timer(Duration(milliseconds: 120), () {
            HapticFeedback.vibrate();
          });
          setState(() {});
        },)
      ],),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: <Widget>[
            Column(children: <Widget>[
              Text('Expected weight',style: TextStyle(color: Colors.deepPurple),),
              Text(acc.current.toStringAsFixed(3)),
            ],),
            Column(children: <Widget>[
              Text('Estimated weight',style: TextStyle(color: Colors.deepPurple),),
              Text(acc.estimated.toStringAsFixed(3)),
            ],)
          ],),
        ),
        Text('For 6 months => '+calculateWeight(0, acc.current, acc.estimated).toStringAsFixed(3) +' Cal/Day',style: TextStyle(color: Colors.deepPurple),),
        Text('For 3 months => '+calculateWeight(1, acc.current, acc.estimated).toStringAsFixed(3) +' Cal/Day',style: TextStyle(color: Colors.deepPurple),),
        Text('For month => '+ calculateWeight(2, acc.current, acc.estimated).toStringAsFixed(3) +' Cal/Day',style: TextStyle(color: Colors.deepPurple),),
         SizedBox(height:scheight*1/30 ,),
        Text('Your history',style: TextStyle(color: Colors.deepPurple,fontSize: 20),),
      len!=0?
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(color: Colors.deepPurple[300],width: scwidth*4/6,height: scheight*1/2,
            child:ListView.builder(itemCount:submissions.length,itemBuilder:(context,index){
            return Padding(
              padding: const EdgeInsets.only(top:4 ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: <Widget>[
                  Text("Date : "+Calories.fromMap(submissions[index]).date+" >> ",style: TextStyle(color: Colors.white,fontSize: 16),),
                  Text(Calories.fromMap(submissions[index]).calories.toStringAsFixed(2)+"  Cal",style: TextStyle(color: Colors.white,fontSize: 16),),
                ],),
            );
          } ),),
        ):
          Center(child: Text('No data found'),),

        RaisedButton(color: Colors.white,
            child: Text(
              'Submit foods',
              style: TextStyle(color: Colors.green, fontSize: 18),
            ),

            onPressed: (){
          HapticFeedback.vibrate();
            showBottomSheet(acc);
            //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>new SubmitFoods (acc)));
            } ,
            shape: new RoundedRectangleBorder(side: BorderSide(color: Colors.black,width:1 ),
                borderRadius: new BorderRadius.circular(40.0))),
        Align(alignment: Alignment.bottomCenter,child: Text('Your expected weight will be updated after restarting the app',style: TextStyle(color: Colors.grey,fontSize:11 ),),),
      ],),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:behealthy/pages/calorieshistoty.dart';
import 'package:behealthy/pages/Category.dart';
import 'package:behealthy/Model/accounts.dart';
import 'package:behealthy/Model/calories.dart';
import 'package:behealthy/Model/calories_db.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:collection';


List vegephotos = [
  "assets/tmatm.jpg",
  "assets/gzr.jpg",
  "assets/khyar.jpg",
  "assets/bazngan.jpg",
  "assets/btats.jpg",
  "assets/krmb.jpg",
  "assets/arnabeet.jpg",
  "assets/flfl.jpg"
];

List fruphotos = [
  "assets/apple.jpg",
  "assets/orange.jpg",
  "assets/anb.jpg",
  "assets/batee5.jpg",
  "assets/banana.jpg",
  "assets/mango.jpg",
  "assets/kywy.jpg",
  "assets/frawla.jpg"
];

List toaphotos = [
  "assets/sory.jpg",
  "assets/sobr.jpg",
  "assets/abyd.jpg",
  "assets/sodany.jpg",
  "assets/kago.jpg",
  "assets/loz.jpg",
  "assets/zbyb.jpg",
  "assets/fosdoq.jpg"
];




List vegefoodscalories = [20, 31, 27, 100, 130, 150, 115, 36];
List frufoodscalories = [81,62,53,30,105,68,86,54];
List toafoodscalories = [575,535.8,539.2,572.4,553,571.4,299,562.1];


List vegefoods = [
  "Tomato",
  "Carrot",
  "Cucumber",
  "Aubergine",
  "Botatos",
  "Cramp",
  "Cauliflower",
  "pepper"
];
List frufoods = [
  "Apple",
  "Orange",
  "Grape",
  "Watermilon",
  "Banana",
  "Mango",
  "kiwi",
  "Strawberry"
];

List toafoods = [
  "Sunflower pulp",
  "Yellow seed",
  "White seed",
  "Peanut",
  "Cashew",
  "almonds",
  "raisin",
  "Pistachio"
];

int type=0;
List submissions;
final categories =<Category>[
  Category(id: 0,title:'Vegetables',icon: Icons.fastfood),
  Category(id: 1,title:'Fruits',icon: Icons.fastfood),
  Category(id: 2,title:'Toasters',icon: Icons.fastfood),
];

getSubmissions(int id)async{
  final db=CaloriesHelper();
  submissions=await db.getSubmissions(id);
}

Queue undo = new Queue();
class SubmitFoods extends StatefulWidget {
  Account acc;
  SubmitFoods(this.acc);
  @override
  _SubmitFoodsState createState() => _SubmitFoodsState(acc);
}
double totalCalories = 0;
String todaydate = DateTime.now().day.toString()+"/"+DateTime.now().month.toString()+"/"+DateTime.now().year.toString();

class _SubmitFoodsState extends State<SubmitFoods> {

  @override
  void initState() {
    super.initState();
    db = CaloriesHelper();

    setState(() {
      getSubmissions(acc.id);
    });
  }
  var db=CaloriesHelper();
  Account acc;
  _SubmitFoodsState(this.acc);
  @override
  Widget build(BuildContext context) {
    double scwidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;

    Future<bool>_onBackButton(){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          DetailedCalories(acc)), (Route<dynamic> route) => false);
    }


    return WillPopScope(onWillPop: _onBackButton,
      child: Scaffold(
          backgroundColor: Colors.teal,
          appBar: AppBar(
            title: Text('Submit foods'),
            backgroundColor: Colors.deepPurple,actions: <Widget>[
            IconButton(icon: Icon(Icons.undo),onPressed: (){
              HapticFeedback.vibrate();
              totalCalories-=undo.removeLast();
              setState(() {});
            },),
            IconButton(icon:Icon(Icons.date_range),onPressed: (){
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
            PopupMenuButton(itemBuilder: (context){
              return categories.map((Category){
                return PopupMenuItem(
                  value: Category,
                  child: Text(Category.title),
                );
              }).toList();
            },onSelected: (Category c){
              HapticFeedback.vibrate();
              setState(() { type=c.id;});
            }
              ,),
          ],
          ),
          body: Column(
            children: <Widget>[
              Container(color: Colors.teal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(children: <Widget>[
                        Text('Total Calories : '+totalCalories.toStringAsFixed(3),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                      ],),
                      Column(children: <Widget>[
                        Text('Date : $todaydate',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                      ],),
                      FloatingActionButton(backgroundColor: Colors.white70,
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.deepPurple,fontSize: 14),
                        ),
                        onPressed: ()async{
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
                                            DetailedCalories(acc)), (Route<dynamic> route) => false);
                                        }),
                                  ],);
                              });
                          totalCalories = 0.0;
                        }
                        },
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisSpacing: scwidth / 100,
                  mainAxisSpacing: scheight / 150,
                  crossAxisCount: 2,
                  children: List.generate(
                    vegefoods.length,
                    (index) {
                      return Container(
                        color: Colors.white,
                        height: scheight / 5,
                        width: scwidth *0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: scwidth * 0.33,
                              height: scheight * 0.12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(type==0?vegephotos[index]:type==1?fruphotos[index]:toaphotos[index]))),
                            ),
                            ListTile(
                              title: Text(type==0?vegefoods[index]:type==1?frufoods[index]:toafoods[index]),
                              subtitle: Text(
                                 type==0?vegefoodscalories[index].toString()+ " Cal/100g":type==1?frufoodscalories[index].toString()+ " Cal/100g":toafoodscalories[index].toString() + " Cal/100g",),
                              trailing: IconButton(icon:Icon(Icons.add_shopping_cart),
                                color: Colors.green,onPressed: (){
                                  HapticFeedback.vibrate();
                                  undo.addLast(type==0?vegefoodscalories[index]:type==1?frufoodscalories[index]:toafoodscalories[index]);
                                  totalCalories+= type==0?vegefoodscalories[index]:type==1?frufoodscalories[index]:toafoodscalories[index];
                                  setState(() {});

                                },
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

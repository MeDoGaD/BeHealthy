import 'package:flutter/material.dart';
import 'package:behealthy/pages/login.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    double scwidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;
    return Scaffold(backgroundColor: Colors.white,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(height:scheight*1/3 ,width: scwidth*1/3,
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/second.jpg'),fit: BoxFit.fill),shape: BoxShape.circle,),
            ),
             Container(height: scheight*1/20,child:  Row(mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Image.asset('assets/bee.jpg'),
                 Text(' Healthy',style: TextStyle(color: Colors.redAccent,fontSize: 32,fontWeight: FontWeight.bold),),
               ],
             ),),

            SizedBox(height: scheight*1/20,),

            Container(width: scwidth*2/5,
              child: RaisedButton(color: Colors.white,
                  child: Text(
                    'Start',
                    style: TextStyle(color: Colors.greenAccent, fontSize: 22),
                  ),

                  onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder:(context)=>new Login())),
                  shape: new RoundedRectangleBorder(side: BorderSide(color: Colors.black,width:1 ),
                      borderRadius: new BorderRadius.circular(40.0))),
            ),
          ],
        ),
      ),
    );
  }}
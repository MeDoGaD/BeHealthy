class Calories{
  int id;
  String date;
  double calories;

  Calories(this.id,this.date,this.calories);

  int get _id => id;
  String get _date => date;
  double get _calories => calories;

  Calories.map(dynamic obj)
  {
    this.id=obj['id'];
    this.date=obj['date'];
    this.calories=obj['calories'];
  }

  Map<String,dynamic>toMap(){
    var map =new Map<String,dynamic>();
    map['id']=_id;
    map['date']=_date;
    map['calories']=_calories;

    return map;
  }

  Calories.fromMap(Map<String,dynamic>map){
    this.id=map['id'];
    this.date=map['date'];
    this.calories=map['calories'];
  }
}
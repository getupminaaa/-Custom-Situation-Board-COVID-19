import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BackgroundImage()
    );
  }
}
class BackgroundImage extends StatefulWidget{
  @override
  _BackgroundImageState createState() => _BackgroundImageState();
}

class _BackgroundImageState extends State<BackgroundImage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        child: CardLayout(),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/img/background.jpg"),
              fit: BoxFit.cover
            )
        ) ,
      ),
    );
  }
}
class CardLayout extends StatelessWidget{
  CardLayout({Key key}) :
      super(key : key);
  @override
  Widget build(BuildContext context){
    return Center(
      child: Card(
        child: InkWell(
          child: Container(
            width: 400,
            height: 250,
            child: Text('카드'),
          ),
        ),
      ),
    );
  }
 }
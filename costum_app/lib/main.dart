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
        home: BackgroundImage());
  }
}

class BackgroundImage extends StatefulWidget {
  @override
  _BackgroundImageState createState() => _BackgroundImageState();
}

class _BackgroundImageState extends State<BackgroundImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListViewLayout(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("lib/img/background.jpg"),
                fit: BoxFit.cover)),
      ),
    );
  }
}

class CardLayout extends StatelessWidget {
  CardLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Color(0x59474646),
        child: InkWell(
          child: Container(
            width: 400,
            height: 250,
          ),
        ),
      ),
    );
  }
}

class ListViewLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          Container(
            child: Center(
              child: CardLayout(),
            ),
          ),
          Container(
            child: Center(
              child: CardLayout(),
            ),
          ),
        ],
      ),
    );
  }
}

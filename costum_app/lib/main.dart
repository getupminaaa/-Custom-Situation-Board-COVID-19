import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
                fit: BoxFit.cover)
        ),
      ),
    );
  }
}

Widget cardLayout(){
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

class ListViewLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          Container(
            child: Center(
              child: Card(
                color: Color(0x59474646),
                child: InkWell(
                  child: Container(
                    width: 400,
                    height: 250,
                  child: WebView(
              initialUrl: 'https://injejuweb.herokuapp.com/map/maskstore/?lat=33.486282&lng=126.469532&level=3',
              javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
          ),
        ),
      ),
          ),
          Container(
            child: Center(
              child: cardLayout(),
            )
          ),
          RaisedButton(
            child: Text('Setting'),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.blue,
            padding: const EdgeInsets.all(5),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Performance())
              );
            },
          ),
        ],
      ),
    );
  }
}

class Performance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text('Go to Main'),
        ),
      ),
    );
  }
}
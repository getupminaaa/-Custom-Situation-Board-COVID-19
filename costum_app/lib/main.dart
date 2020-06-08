import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("lib/img/background.jpg"), fit: BoxFit.cover),
          ),
          child: ListViewLayout(),
        ),
      ),
    );
  }
}

Widget maskMap() {
  return Container(
    child: Center(
      child: Card(
        color: Color(0x59474646),
        child: InkWell(
          child: Container(
            width: 400,
            height: 250,
            child: WebView(
              initialUrl:
              'https://injejuweb.herokuapp.com/map/maskstore/?lat=33.486282&lng=126.469532&level=3',
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
        ),
      ),
    ),
  );
}

class ListViewLayoutState extends State<ListViewLayout> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 50),
          itemCount: 1,
          //item count에 기능 배열의 인덱스 .length가 들어가야함
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Card(
                      color: Color(0x59474646),
                      child: InkWell(
                        child: Container(
                          child: Text(index.toString()),
                          width: 390,
                          height: 250,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: maskMap(),
                    ),
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
          },
          separatorBuilder: (BuildContext context, int index) =>
          const Divider()),
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



class ListViewLayout extends StatefulWidget {
  @override
  ListViewLayoutState createState() => ListViewLayoutState();
}

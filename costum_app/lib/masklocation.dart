import 'package:costumapp/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

// Masklocation을 호출하면 카드를 보내준다아~
class Masklocation extends StatefulWidget {
  final CustomFunction func;

  Masklocation({this.func});

  @override
  _Masklocation createState() => _Masklocation(func: func);
}

class _Masklocation extends State<Masklocation> {
  Future<Position> getLoc;
  final CustomFunction func;

  _Masklocation({this.func});

  @override
  void initState() {
    getLoc = _setCurrentLocation();
    super.initState();
  }

  var currentlat;
  var currentlong;

  Future<Position> _setCurrentLocation() async {
    var Location = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return Location;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        key: ValueKey(func.funcName),
        width: 400,
        height: 350,
        child: FutureBuilder(
            future: getLoc,
            builder: (context, data) {
              if (data.hasData) {
                currentlat = data.data.latitude;
                currentlong = data.data.longitude;

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: Card(
                      color: Color(0x59474646),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                func.funcName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                              RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                                  color: Color(0xBF9EBBE8),
                                  child: Text("Go"),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SecondRoute(
                                              func.reqUrl, data.data)),
                                    );
                                  })
                            ],
                          ),
                          Container(
                            width: 390,
                            height: 260,
                            child: WebView(
                              //initialUrl:'https://injejuweb.herokuapp.com/map/maskstore/?lat=${currentlat}&lng=${currentlong}&level=3',
                              initialUrl:
                                  "${func.reqUrl}/?lat=${currentlat}&lng=${currentlong}&level=3",
                              javascriptMode: JavascriptMode.unrestricted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  child: Center(
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Text(
                            func.funcName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Container(
                            width: 390,
                            height: 260,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  String _url;
  Position _position;

  SecondRoute(String url, Position position) {
    _url = url;
    _position = position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF344176),
        title: Text(
          "",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: WebView(
        initialUrl:
            '${_url}/?lat=${_position.latitude}&lng=${_position.longitude}&level=3',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

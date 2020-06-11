import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
// Masklocation을 호출하면 카드를 보내준다아~
class Masklocation extends StatefulWidget{
  @override
  _Masklocation createState() => _Masklocation();
}

class _Masklocation extends State<Masklocation> {
  Future<Position> getLoc;

@override
void initState() {
getLoc = _setCurrentLocation();
super.initState();
}
var currentlat;
var currentlong;

Future<Position> _setCurrentLocation() async {
var Location = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high,);
return Location;
}

@override
Widget build(BuildContext context){
  return Center(
    child: Container(
      width: 400,
      height: 300,
      child: FutureBuilder(
        future: getLoc,
        builder: (context, data){
          if (data.hasData){
            currentlat=data.data.latitude;
            currentlong=data.data.longitude;
            return Container(
              child: Center(
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Text('공적마스크 판매처', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Container(
                        width: 390,
                        height: 260,
                        child: WebView(
                          initialUrl:'https://injejuweb.herokuapp.com/map/maskstore/?lat=${currentlat}&lng=${currentlong}&level=3',
                          javascriptMode: JavascriptMode.unrestricted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          else {
            return Container(
              child: Center(
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Text('공적마스크 판매처', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
        }
      ),
    ),
  );
}
}


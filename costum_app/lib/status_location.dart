import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:costumapp/setting.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class localStatus extends StatefulWidget {
  final CustomFunction func;

  localStatus({this.func});

  @override
  _localStatus createState() => _localStatus(func: func);
}

class _localStatus extends State<localStatus> {
  var getPost;

  final CustomFunction func;

  _localStatus({this.func});

  @override
  void initState() {
    getPost = fetchPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: getPost,
          builder: (context, data) {
            if (data.hasData) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  width: 390,
                  height: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0x59474646),
                  ),
                  child: Column(
                    children: <Widget>[
                      Text('${data.data.city} 현황 정보',
                          style: TextStyle(color: Colors.white,
                              fontSize: 25, fontWeight: FontWeight.bold )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                height: 130,
                                width: 110,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color(0XFF9EC2F8)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text('확진자',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    Text('${data.data.confirm}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                height: 130,
                                width: 110,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color(0xFFC2EAA7)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text('격리해제',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    Text('${data.data.isolation}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                height: 130,
                                width: 110,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color(0xFFEE8787)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text('사망자',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    Text('${data.data.dead}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('기준일시: ${data.data.date}', 
                        style: TextStyle(
                          fontSize:15,
                          color: Colors.white,),),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                width: 390,
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0x59474646),
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }
}

class Post {
  final String city;
  final int confirm;
  final int isolation;
  final int dead;
  final String date;

  Post({this.city, this.confirm, this.isolation, this.dead, this.date});

  // factory 생성자. Post 타입의 인스턴스를 반환
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        city: json['시도명'],
        confirm: json['확진'],
        isolation: json['격리해제'],
        dead: json['사망'],
        date: json['기준일시']
    );
  }
}

Future<Position> _setCurrentLocation() async {
  var Location = await Geolocator().getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  return Location;
}

// Futures: Dart의 핵심 클래스로서, async 동작은 가지는 작업을 처리하게 위해 사용
// Future 객체는 일정 소요시간 이후에 값이나 에러를 반환한다.
Future<Post> fetchPost() async {
  final getLoc = await _setCurrentLocation();
  // 해당 URL의 데이터를 수신.
  // await 처리: 응답 메시지가 도착하거나 타임아웃이 발생할 때까지 대기
  final response = await http.get(
      'http://injejuweb.herokuapp.com/info/sido/?lat=${getLoc.latitude}&lng=${getLoc.longitude}');

  // 응답의 상태코드가 200인 경우. 정상적으로 응답메시지를 수신한 경우
  if (response.statusCode == 200) {
    // 수신 메시지의 body부분을 JSON 객체로 디코딩한후 Post.fromJson 메소드를 통해 다시 파싱함
    print(json.decode(utf8.decode(response.bodyBytes)));
    return Post.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  }
  // 서버로부터 정상응답을 받지 못한 경우. 어떤  에러가 발생한 경우
  else {
    // 에러 발생
    throw Exception('Failed to load post');
  }
}

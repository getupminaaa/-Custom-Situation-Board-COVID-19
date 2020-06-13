import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class localStatus extends StatefulWidget{

  @override
  _localStatus createState()=>_localStatus();
}

class _localStatus extends State<localStatus>{
  var getPost;

  @override
  void initState() {
    getPost = fetchPost();
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return Container(
      child: FutureBuilder(
        future: getPost,
        builder: (context, data){
          if (data.hasData){
            return Text('도시:${data.data.city}, 확진자:${data.data.confirm} ,격리해제:${data.data.isolation} , 사망자:${data.data.dead}');
          }
          else {
            return Container(
              child: Center(
                  child: CircularProgressIndicator(),
              ),
            );
          } 
        }
      ),
    );
  }
}



class Post {
  final String city;
  final int confirm;
  final int isolation;
  final int dead;

  Post({this.city, this.confirm, this.isolation, this.dead});

  // factory 생성자. Post 타입의 인스턴스를 반환
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        city: json['시도명'],
        confirm: json['확진'],
        isolation : json['격리해제'],
        dead: json['사망']);
  }
}

Future<Position> _setCurrentLocation() async {
var Location = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high,);
return Location;
}

// Futures: Dart의 핵심 클래스로서, async 동작은 가지는 작업을 처리하게 위해 사용
// Future 객체는 일정 소요시간 이후에 값이나 에러를 반환한다.
Future<Post> fetchPost() async {
  final getLoc = await _setCurrentLocation();
  // 해당 URL의 데이터를 수신.
  // await 처리: 응답 메시지가 도착하거나 타임아웃이 발생할 때까지 대기
  final response =
      await http.get('http://injejuweb.herokuapp.com/info/sido/?lat=${getLoc.latitude}&lng=${getLoc.longitude}');

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
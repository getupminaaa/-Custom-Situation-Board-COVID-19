import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:costumapp/setting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:costumapp/masklocation.dart';
import 'package:costumapp/status_location.dart';

void main() => runApp(MyApp());

final _fm = FunctionManager();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
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
              // image: DecorationImage(
              //     image: AssetImage("lib/img/background.jpg"), fit: BoxFit.cover),
              ),
          child: ListViewLayout(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _updateResult(context);
          },
          child: Icon(Icons.settings),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  _updateResult(BuildContext context) async {
    // Navigator.push는 Future를 반환합니다. Future는 선택 창에서 
    // Navigator.pop이 호출된 이후 완료될 것입니다.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Performance()),
    );
    mListViewState.mSetFunc(result);
  }
}

// 단추만 어떵 해겨ㅕㄹ하면 되는디! 쉽지않아 지금 돌려보면 알겠지만 context의 문제
Widget emptyCard(CustomFunction func) {
  print(func.viewType);
  //var childwidget;
  switch (func.viewType) {
    case "WebView":
      return Masklocation(func:func);
      break;
    //TODO: HOW?
    case "ListView":
      return localStatus(func: func);
      break;
    default: 
      return Container(key: ValueKey(func.funcName) );
  }
}
//TODO:Fix
_ListViewLayoutState mListViewState;

class ListViewLayout extends StatefulWidget {
  @override
  _ListViewLayoutState createState() =>
      mListViewState = new _ListViewLayoutState();
}

class _ListViewLayoutState extends State<ListViewLayout> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: UniqueKey(),
      future: _fm._readFile,
      builder: (context, snap) {
        if (snap.hasData) {
          _fm.usingFunctions = snap.data;
          return ListView.builder(
            itemCount: _fm.usingFunctions.length,
            itemBuilder: (context, index) {
              return emptyCard(_fm.usingFunctions[index]);
            },
          );
        }
        else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
    // return ListView.builder(
    //   itemCount: _fm.usingFunctions.length,
    //   itemBuilder: (context, index) {
    //     return emptyCard(_fm.usingFunctions[index]);
    //   },
    // );
  }

  void mSetFunc(List<CustomFunction> funcs) {
    setState(() {
      _fm.usingFunctions = funcs;
    });
  }
}

class FunctionManager {
  static final FunctionManager _instance = FunctionManager._internal();

  // static FunctionManager get instance =>
  //   (_instance != null) ? _instance : _instance =
  List<CustomFunction> usingFunctions;
  static String path;

  factory FunctionManager() {
    return _instance;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  List<CustomFunction> parseCustomFunctions(String response) {
    final parsed = json.decode(response).cast<Map<String, dynamic>>();

    return parsed.map<CustomFunction>((json) => CustomFunction.fromJson(json)).toList();
  }

  Future<List<CustomFunction>> get _readFile async {
    path = await _localPath;
    var file = new File('$path/statusData.json');
    if (!file.existsSync()) {
      file.createSync();
    }

    Future<String> data =  file.readAsString();

    return parseCustomFunctions(await data);
  }

  FunctionManager._internal() {
    //클래스가 최초 생성될때 1회 발생
    //초기화 코드
    //usingFunctions = getfromdevice
    //var lineNumber = 1;

    usingFunctions = List<CustomFunction>();
  }

  void write() {
    var file = new File('$path/statusData.json');
    file.writeAsStringSync(jsonEncode(_instance.usingFunctions));
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:costumapp/setting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Performance()));
          },
          child: Icon(Icons.settings),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}

// 단추만 어떵 해겨ㅕㄹ하면 되는디! 쉽지않아 지금 돌려보면 알겠지만 context의 문제
Widget emptyCard(CustomFunction lists) {
  return Container(
    key: ValueKey(lists.funcName),
    child: Center(
      child: Card(
        color: Color(0x59474646),
        child: InkWell(
          child: Container(
            width: 400,
            height: 250,
          ),
        ),
      ),
    ),
  );
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

//TODO:Fix
_ListViewLayoutState mListViewState;

class ListViewLayout extends StatefulWidget {
  @override
  _ListViewLayoutState createState() =>
      mListViewState = new _ListViewLayoutState();
}

class _ListViewLayoutState extends State<ListViewLayout> {
  //List<CustomFunction> Listss = [];


  @override
  Widget build(BuildContext context) {
    //return emptyCard(Listss[index]);

    return FutureBuilder(
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
    return ListView.builder(
      itemCount: _fm.usingFunctions.length,
      itemBuilder: (context, index) {
        return emptyCard(_fm.usingFunctions[index]);
      },
    );

    // return ReorderableListView(
    //   onReorder: (int oldindex, int newindex) {
    //     setState(() {
    //       var tempfuncs = FunctionManager._instance.usingFunctions[oldindex];
    //       FunctionManager._instance.usingFunctions.add(tempfuncs);
    //     });
    //   },
    //   children: List.generate(Listss.length, (index){return emptyCard(Listss[index]);}),
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
//    file.writeAsStringSync("[]");

    Future<String> data =  file.readAsString();

    return parseCustomFunctions(await data);
  }

  FunctionManager._internal() {
    //클래스가 최초 생성될때 1회 발생
    //초기화 코드
    //usingFunctions = getfromdevice
    var lineNumber = 1;

    usingFunctions = List<CustomFunction>();
//    usingFunctions = [
//      CustomFunction("MaskMap"),
//      CustomFunction("ReliefHospitals"),
//      CustomFunction("SidoInfos"),
//    ];
  }

  void write() {
    var file = new File('$path/statusData.json');
    file.writeAsStringSync(jsonEncode(_instance.usingFunctions));
  }
}

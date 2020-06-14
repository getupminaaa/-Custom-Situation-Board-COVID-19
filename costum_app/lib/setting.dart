import 'package:costumapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

final _fm = FunctionManager();

class Performance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Setting"),
        ),
        body: Container(
          decoration: BoxDecoration(
            // image: DecorationImage(
            //     image: AssetImage("lib/img/background.jpg"), fit: BoxFit.cover),
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: 400,
                height: 270,
                padding: const EdgeInsets.all(6),
                child: Card(
                  color: Color(0x59474646),
                  child: UsableListView(),
                ),
              ),
              Container(
                width: 400,
                height: 270,
                padding: const EdgeInsets.all(6),
                child: FutureBuilder<List<CustomFunction>>(
                  future: fetchFuncs(),
                  builder: (context, data){
                    if (data.hasError) print(data.error);
                    return data.hasData ? 
                      Card(
                        color: Color(0x59474646),
                        child: UnusableListView(funcs: data.data),
                      ):
                      Container(
                        child: Center(
                            child: CircularProgressIndicator(),
                        ),
                      );
                  } 
                ), 
              ),
              Container(
                width: 70,
                height: 30,
                child: RaisedButton(
                  padding: const EdgeInsets.all(5),
                  onPressed: () {
                    Navigator.pop(context,uListViewState.usableListTiles);
                  },
                  child: Text('Go'),
                ),
              )
            ],
          ),
        ));
  }
}

//unsuableList와 usableList가 필요 unsuable에서 usable로 해당 데이터가 삽입되어야함
// 삽입될때 인덱스는 어떻게? for문으로 위치를 찾아줘야하나?
// 삭제또한 마찬가지
// usable은 reorderable이어야함
// 이 모든게 성공하면 globalkey로 앞 화면에 적용하고
// 앞화면의 데이터를 주거나 연결해줘야할 듯
// class CustomFunction {
//   String funcName;

// //  String elements;

//   CustomFunction(String _funcName) {
//     funcName = _funcName;
//     //other elements initialize
//   }

//   factory CustomFunction.fromJson(Map<String, dynamic> json) {
//     return CustomFunction(json['funcName'] as String);
//   }

//   Map<String, dynamic> toJson() =>
//       {
//         'funcName': funcName
//       };
// }

class CustomFunction {
  final String funcName;
  final String viewType;
  final String requirements;
  final String reqUrl;
  //other elements
  CustomFunction({this.funcName, this.viewType, this.requirements, this.reqUrl});

  factory CustomFunction.fromJson(Map<String, dynamic> json){
    return CustomFunction(
      funcName: json['funcName'] as String, 
      viewType: json['ViewType'] as String,
      requirements: json['requirements'] as String,
      reqUrl: json['reqUrl'] as String,
      );
  }
  Map<String, dynamic> toJson() =>
  {
    'funcName': funcName,
    'ViewType': viewType,
    'requirements': requirements,
    'reqUrl': reqUrl,
  };  
}


List<CustomFunction> parseFuncs(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<CustomFunction>((json) => CustomFunction.fromJson(json)).toList();
}

Future<List<CustomFunction>> fetchFuncs() async {
  final response =
      await http.get('http://injejuweb.herokuapp.com/info/apps/');

  return parseFuncs(utf8.decode(response.bodyBytes));
}


_UnusableListViewState unListViewState;
_UsableListViewState uListViewState;

class UnusableListView extends StatefulWidget {
  final List<CustomFunction> funcs;
  
  @override
  _UnusableListViewState createState() =>
      unListViewState = new _UnusableListViewState();

  UnusableListView({this.funcs});
}

class _UnusableListViewState extends State<UnusableListView> {
  List<CustomFunction> unusableListTiles;

  // @override
  // bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: Need fix
    super.initState();
    unusableListTiles = List<CustomFunction>();
    SetFunc(widget.funcs);

    // unusableListTiles = [
    //   CustomFunction("MaskMap"),
    //   CustomFunction("test 2"),
    //   CustomFunction("test 3"),
    // ];

    // String usingName, unusableName;
    // _fm.usingFunctions.forEach((element) {
    //   for (int i = 0; i < unusableListTiles.length; i++) {
    //     if (element.funcName == unusableListTiles[i].funcName) {
    //       unusableListTiles.removeAt(i);
    //       break;
    //     }
    //   }
    // });
  }
  void SetFunc(List<CustomFunction> funcs) {
    setState(() {
      //unusableListTiles = funcs;
      var ishaving = false;
      for(CustomFunction f in funcs){
        for(CustomFunction f2 in _fm.usingFunctions){
          if(f.funcName == f2.funcName) ishaving = true;
        }
        print(f.funcName);
        if(!ishaving){
          unusableListTiles.add(new CustomFunction(funcName: f.funcName, viewType: f.viewType , requirements: f.requirements , reqUrl: f.reqUrl ));
        }
        ishaving = false;
      }
    });
  }


  void AddFunc(CustomFunction funcs) {
    setState(() {
      unusableListTiles.add(funcs);
      _fm.write();
    });
  }

  void RemoveFunc(CustomFunction funcs) {
    setState(() {
      unusableListTiles.remove(funcs);
      _fm.write();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: unusableListTiles.length,
      itemBuilder: (context, index) {
        return UnusableListTile(unusableListTiles[index]);
      },
    );
  }


  Widget UnusableListTile(CustomFunction customFunction) {
    return ListTile(
        key: ValueKey(customFunction.funcName),
        title: Text(
          customFunction.funcName,
          style: TextStyle(color: Colors.white),
        ),
        trailing: IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.blue,
            ),
            onPressed: () {
              var selectedTiles = unusableListTiles
                  .firstWhere((x) => x.funcName == customFunction.funcName);
              uListViewState.AddFunc(selectedTiles);
              //mListViewState.mAddFunc(selectedTiles); //TODO:Fix
              RemoveFunc(selectedTiles);
            }));
  }
}

//usableListView
class UsableListView extends StatefulWidget {
  @override
  _UsableListViewState createState() =>
      uListViewState = new _UsableListViewState();
}

class _UsableListViewState extends State<UsableListView> {
  List<CustomFunction> usableListTiles;

  ScrollController _scrollController;
  double offset = 0.0;

  // @override
  // bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    usableListTiles = _fm.usingFunctions;
    _scrollController = ScrollController() //keepScrollOffset: false removed
      ..addListener(() {
        setState(() {
          offset = _scrollController.offset;
          // force a refresh so the app bar can be updated
        });
      });
  }

  void AddFunc(CustomFunction funcs) {
    setState(() {
      usableListTiles.add(funcs);
      _fm.write();
    });
  }

  void RemoveFunc(CustomFunction funcs) {
    setState(() {
      usableListTiles.remove(funcs);
      _fm.write();
    });
  }

  @override
  Widget build(BuildContext context) {
    //return ROListView();
    return Theme(
      data: ThemeData(
        canvasColor: Color(0x59474646),
      ),
      child: ReorderableListView(
          onReorder: (int oldindex, int newindex) {
            setState(() {
              if (oldindex < newindex) {
                // removing the item at oldIndex will shorten the list by 1.
                newindex -= 1;
              }
              final CustomFunction function = usableListTiles.removeAt(oldindex);
              usableListTiles.insert(newindex, function);
            });
          },
          scrollController: uListViewState._scrollController,
          scrollDirection: Axis.vertical,
          children: List.generate(
            usableListTiles.length,
                (index) {
              return UsableListTile(usableListTiles[index]);
            },
          )),
    );
  }

  Widget UsableListTile(CustomFunction customFunction) {
    return ListTile(
        key: ValueKey(customFunction.funcName),
        title: Text(
          customFunction.funcName,
          style: TextStyle(color: Colors.white),
        ),
        trailing: IconButton(
            icon: Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
            ),
            onPressed: () {
              var selectedTiles = usableListTiles
                  .firstWhere((x) => x.funcName == customFunction.funcName);
              unListViewState.AddFunc(selectedTiles);
              RemoveFunc(selectedTiles);
            }));
  }
}
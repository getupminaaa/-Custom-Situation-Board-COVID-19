import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

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
            image: DecorationImage(
                image: AssetImage("lib/img/background.jpg"), fit: BoxFit.cover),
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

_ListViewLayoutState mListViewState;

class ListViewLayout extends StatefulWidget {
  @override
  _ListViewLayoutState createState() =>
      mListViewState = new _ListViewLayoutState();
}

class _ListViewLayoutState extends State<ListViewLayout> {
  List<CustomFunction> Listss = [];

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      onReorder: (int oldindex, int newindex) {
        setState(() {
          var tempfuncs = Listss[oldindex];
          Listss.add(tempfuncs);
        });
      },
      children: List.generate(Listss.length, (index){return emptyCard(Listss[index]);}),
    );
  }

  void mAddFunc(CustomFunction selectedTiles) {
    setState(() {
      Listss.add(selectedTiles);
    });
  }
}

class Performance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Setting"),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("lib/img/background.jpg"), fit: BoxFit.cover),
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
                child: Card(
                  color: Color(0x59474646),
                  child: UnusableListView(),
                ),
              ),
              Container(
                width: 70,
                height: 30,
                child: RaisedButton(
                  padding: const EdgeInsets.all(5),
                  onPressed: () {
                    Navigator.pop(context);
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
class CustomFunction {
  String funcName;

  CustomFunction(String _funcName) {
    funcName = _funcName;
  }
}

_UnusableListViewState unListViewState;
_UsableListViewState uListViewState;

String unusableItem = "집갈래";

//listview builder로 생성 list.length만큼
class UnusableListView extends StatefulWidget {
  @override
  _UnusableListViewState createState() =>
      unListViewState = new _UnusableListViewState();
}

class _UnusableListViewState extends State<UnusableListView> {
  List<CustomFunction> unusableListTiles = [
    CustomFunction("MaskMap"),
    CustomFunction("ReliefHospitals"),
    CustomFunction("SidoInfos"),
  ];

  void AddFunc(CustomFunction funcs) {
    setState(() {
      unusableListTiles.add(funcs);
    });
  }

  void RemoveFunc(CustomFunction funcs) {
    setState(() {
      unusableListTiles.remove(funcs);
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
              mListViewState.mAddFunc(selectedTiles);
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
  List<CustomFunction> usableListTiles = [];

  ScrollController _scrollController;
  double offset = 0.0;

  @override
  void initState() {
    super.initState();
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
    });
  }

  void RemoveFunc(CustomFunction funcs) {
    setState(() {
      usableListTiles.remove(funcs);
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
              print(oldindex);
              print(newindex);
              var tempfunc = usableListTiles[oldindex];
              print(usableListTiles[oldindex]);
              usableListTiles.removeAt(oldindex);
              usableListTiles.insert(newindex, tempfunc);
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

    // return ListView.builder(
    //   itemCount: usableListTiles.length,
    //   itemBuilder: (context, index) {
    //     return UsableListTile(usableListTiles[index]);
    //   },
    // );
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

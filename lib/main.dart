import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart Counter',
      theme: ThemeData(
        primaryColor: Color(0xFF2ECC71),
        backgroundColor: Color(0xFF2C3E50),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Dart Counter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Theme.of(context).backgroundColor,
          child: Center(
              child: SizedBox(
            height: 70,
            width: 200,
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Text(
                  "Nuova Partita",
                  style: TextStyle(fontSize: 25),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPlayers()),
                  );
                }),
          )),
        ));
  }
}

class AddPlayers extends StatefulWidget {
  AddPlayers({Key key}) : super(key: key);

  @override
  _AddPlayersState createState() => _AddPlayersState();
}

class _AddPlayersState extends State<AddPlayers> {
  List<String> names = new List<String>();
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  addPlayer(String name) {
    setState(() {
      names.add(name);
    });
  }

  removePlayer(int index) {
    setState(() {
      names.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Aggiungi i giocatori"),
      ),
      body: ListView.builder(
          itemCount: names.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      names[index],
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  IconButton(
                    iconSize: 40,
                    icon: Icon(Icons.remove_circle),
                    color: Theme.of(context).primaryColor,
                    onPressed: () => {removePlayer(index)},
                  )
                ],
              ),
            );
          }),
      bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: "add",
                  child: Icon(Icons.add),
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () => {
                    showDialog(
                        context: context,
                        child: new AlertDialog(
                          content: new Row(
                            children: <Widget>[
                              new Expanded(
                                child: new TextField(
                                  controller: myController,
                                  cursorColor: Theme.of(context).primaryColor,
                                  autofocus: true,
                                  decoration: new InputDecoration(
                                      labelText: 'Nome giocatore'),
                                ),
                              )
                            ],
                          ),
                          actions: <Widget>[
                            new FlatButton(
                                child: const Text(
                                  'Cancella',
                                  style: TextStyle(color: Color(0xFF2ECC71)),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            new FlatButton(
                                child: const Text('Aggiungi',
                                    style: TextStyle(color: Color(0xFF2ECC71))),
                                onPressed: () {
                                  addPlayer(myController.text);
                                  myController.text = "";
                                  Navigator.pop(context);
                                })
                          ],
                        ))
                  },
                ),
                FloatingActionButton(
                  heroTag: "next",
                  child: Icon(Icons.arrow_forward_ios),
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Board(
                            names: names,
                          ),
                        ))
                  },
                ),
              ],
            ),
          )),
    );
  }
}

class Board extends StatefulWidget {
  Board({Key key, this.names}) : super(key: key);
  final List<String> names;

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final myController = TextEditingController();
  List<int> values;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    values = new List<int>.filled(widget.names.length, 301);
  }

  void addScore(value) {
    setState(() {
      if ((values[counter % values.length] - int.parse(value)) >= 0) {
        values[counter % values.length] -= int.parse(myController.text);
      }
      counter++;
    });
  }

  Table createTable() {
    List<TableRow> rows = new List<TableRow>();
    for (var i = 0; i < widget.names.length; i++) {
      rows.add(TableRow(children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              widget.names[i],
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TableCell(
            child: Text(
              this.values[i].toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        )
      ]));
    }

    Table res = new Table(
        border: TableBorder(
          bottom: BorderSide(color: Colors.white),
        ),
        children: rows);

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Aggiungi i giocatori"),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: <Widget>[
            createTable(),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Text(
                "Tocca a ${widget.names[this.counter % widget.names.length]}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            SizedBox(
              width: 200,
              height: 60,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Aggiungi punteggio",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () => {
                  showDialog(
                      context: context,
                      child: new AlertDialog(
                        content: new Row(
                          children: <Widget>[
                            new Expanded(
                              child: new TextField(
                                controller: myController,
                                cursorColor: Theme.of(context).primaryColor,
                                autofocus: true,
                                keyboardType: TextInputType.number,
                                decoration:
                                    new InputDecoration(labelText: 'Punteggio'),
                              ),
                            )
                          ],
                        ),
                        actions: <Widget>[
                          new FlatButton(
                              child: const Text(
                                'Cancella',
                                style: TextStyle(color: Color(0xFF2ECC71)),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          new FlatButton(
                              child: const Text('Aggiungi',
                                  style: TextStyle(color: Color(0xFF2ECC71))),
                              onPressed: () {
                                addScore(myController.text);
                                myController.text = "";
                                Navigator.pop(context);
                              })
                        ],
                      ))
                },
              ),
            )
          ],
        ));
  }
}

import 'package:flutter/material.dart';

import 'parser.dart';

void main() => runApp(new MyApp());

const appName = 'Flutter Calculator';

var digits = <String>['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
var operators = <String>['+', '-', '*', '/'];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appName,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.tealAccent,
      ),
      home: new Main(),
    );
  }
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Display(),
          new Keyboard(),
        ],
      ),
    );
  }
}

var _displayState = new DisplayState();

class Display extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _displayState;
  }
}

class DisplayState extends State<Display> {
  var _expression = '';
  var _resultDisplayed = false;

  @override
  Widget build(BuildContext context) {
    return new Expanded(
        flex: 2,
        child: new Container(
          color: Theme
              .of(context)
              .primaryColor,
          child: new Center(
            child: new Text(
              _expression,
              textAlign: TextAlign.end,
              style: new TextStyle(
                fontSize: 40.0,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}

bool _addKey(String key) {
  var _expr = _displayState._expression;
  var _result = false;
  if (_displayState._resultDisplayed) _expr = '';

  if (operators.contains(key)) {
    // Handle as an operator
    if (_expr.length > 0 && operators.contains(_expr[_expr.length - 1])) {
      _expr = _expr.substring(0, _expr.length - 1);
    }
    _expr += key;
  } else if (digits.contains(key)) {
    // Handle as an operand
    _expr += key;
  } else if (key == 'C') {
    // Delete last character
    if (_expr.length > 0) {
      _expr = _expr.substring(0, _expr.length - 1);
    }
  } else if (key == '=') {
    try {
      var parser = const Parser();
      _expr += ' = ' + parser.parseExpression(_expr).toString();
      _result = true;
    } on Error {
      return false;
    }
  }
  // ignore: invalid_use_of_protected_member
  _displayState.setState(() {
    _displayState._expression = _expr;
    _displayState._resultDisplayed = _result;
  });
  return true;
}

class Keyboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Expanded(
        flex: 4,
        child: new Center(
            child:
            new AspectRatio(
              aspectRatio: 1.0, // To center the GridView
              child: new GridView.count(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                children: <String>[
                  // @formatter:off
              '7', '8', '9', '/',
              '4', '5', '6', '*',
              '1', '2', '3', '-',
              'C', '0', '=', '+',
              // @formatter:on
                ].map((key) {
                  return new GridTile(
                    child: new KeyboardKey(key),
                  );
                }).toList(),
              ),
            )
        ));
  }
}

class KeyboardKey extends StatelessWidget {
  KeyboardKey(this._keyValue);

  final _keyValue;

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      child: new Text(
        _keyValue,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 26.0,
          color: Colors.black,
        ),
      ),
      color: Theme
          .of(context)
          .scaffoldBackgroundColor,
      onPressed: () {
        var success = _addKey(_keyValue);
        if (!success) {
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text('Error'),
          ));
        }
      },
    );
  }
}

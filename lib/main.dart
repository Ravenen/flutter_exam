import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ///list of cells state
  ///2 - filled primary cell
  ///1 - filled secondary cell
  ///0 - empty cell
  ///-1 - secondary tapped
  List<int> _cells = List.generate(15, (_) => 0);

  void _resetGrid() {
    setState(() {
      _cells = List.filled(15, 0);
      _cells[7] = 2;
    });
  }

  bool get _isGridFilled {
    return _cells.every((e) => e != 0);
  }

  bool get _isDuplicationProceed {
    final randInt = Random().nextInt(4);
    return randInt == 0;
  }

  void _applyAction(int buttonIndex) {
    if (_isGridFilled) {
      if (_cells[buttonIndex] == 1) {
        setState(() {
          _cells[buttonIndex] = -1;
        });
      } else if (_cells[buttonIndex] == 2) {
        _resetGrid();
      }
    } else if (_cells[buttonIndex] != 0) {
      _moveButton(buttonIndex);

      if (_isDuplicationProceed) {
        _duplicateButton();
      }
    }
  }

  void _moveButton(int buttonIndex) {
    final emptyCellIndexes = _cells
        .mapIndexed((i, cell) => MapEntry(i, cell))
        .where((entry) => entry.value == 0)
        .map((entry) => entry.key)
        .toList();
    final randomEmptyCell = (emptyCellIndexes..shuffle()).first;
    setState(() {
      _cells[randomEmptyCell] = _cells[buttonIndex];
      _cells[buttonIndex] = 0;
    });
  }

  void _duplicateButton() {
    final emptyCellIndexes = _cells
        .mapIndexed((i, cell) => MapEntry(i, cell))
        .where((entry) => entry.value == 0)
        .map((entry) => entry.key)
        .toList();
    final randomEmptyCell = (emptyCellIndexes..shuffle()).first;
    setState(() {
      _cells[randomEmptyCell] = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    _cells[7] = 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: const Text('Варіант 3'),
      ),
      body: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        children: _cells
            .mapIndexed((i, cell) => Cell(
                  cellState: cell,
                  onClick: () {
                    _applyAction(i);
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Cell extends StatelessWidget {
  const Cell({Key? key, required this.onClick, required this.cellState})
      : super(key: key);

  final void Function() onClick;
  final int cellState;

  Color get color {
    switch (cellState) {
      case -1:
        return Colors.grey;
      case 0:
        return Colors.white;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          onClick();
        },
        child: Container(
          color: color,
        ),
      ),
    );
  }
}

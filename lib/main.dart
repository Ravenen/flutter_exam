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

enum CellState {
  empty,
  primary,
  secondary,
  disabled
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
  List<CellState> _cells = List.generate(15, (_) => CellState.empty);

  void _resetGrid() {
    setState(() {
      _cells = List.filled(15, CellState.empty);
      _cells[7] = CellState.primary;
    });
  }

  bool get _isGridFilled {
    return _cells.every((e) => e != CellState.empty);
  }

  bool get _isDuplicationProceed {
    final randInt = Random().nextInt(4);
    return randInt == 0;
  }

  void _applyAction(int buttonIndex) {
    if (_isGridFilled) {
      if (_cells[buttonIndex] == CellState.secondary) {
        setState(() {
          _cells[buttonIndex] = CellState.disabled;
        });
      } else if (_cells[buttonIndex] == CellState.primary) {
        _resetGrid();
      }
    } else if (_cells[buttonIndex] != CellState.empty) {
      _moveButton(buttonIndex);

      if (_isDuplicationProceed) {
        _duplicateButton();
      }
    }
  }

  void _moveButton(int buttonIndex) {
    final emptyCellIndexes = _cells
        .mapIndexed((i, cell) => MapEntry(i, cell))
        .where((entry) => entry.value == CellState.empty)
        .map((entry) => entry.key)
        .toList();
    final randomEmptyCell = (emptyCellIndexes..shuffle()).first;
    setState(() {
      _cells[randomEmptyCell] = _cells[buttonIndex];
      _cells[buttonIndex] = CellState.empty;
    });
  }

  void _duplicateButton() {
    final emptyCellIndexes = _cells
        .mapIndexed((i, cell) => MapEntry(i, cell))
        .where((entry) => entry.value == CellState.empty)
        .map((entry) => entry.key)
        .toList();
    final randomEmptyCell = (emptyCellIndexes..shuffle()).first;
    setState(() {
      _cells[randomEmptyCell] = CellState.secondary;
    });
  }

  @override
  void initState() {
    super.initState();
    _cells[7] = CellState.primary;
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
  final CellState cellState;

  Color get color {
    switch (cellState) {
      case CellState.disabled:
        return Colors.grey;
      case CellState.empty:
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

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
  final List<int> _cells = List.generate(15, (_) => 0);

  void _applyActionIfFull(int buttonIndex) {}

  void _applyAction(int buttonIndex) {
    _moveButton(buttonIndex);

    final randInt = Random().nextInt(4);
    if (randInt == 0) {
      _duplicateButton();
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
                  isPrimary: cell,
                  onClick: () {
                    _applyAction(i);
                  },
                  isFieldFilles: _cells.every((e) => e != 0),
                ))
            .toList(),
      ),
    );
  }
}

class Cell extends StatelessWidget {
  const Cell({
    Key? key,
    required this.onClick,
    required this.isPrimary,
    required this.isFieldFilled,
  }) : super(key: key);

  final void Function() onClick;
  final int isPrimary;
  final bool isFieldFilled;

  Color get color {
    if (isPrimary == 0) {
      return Colors.white;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => {
          if (isFieldFilled) {onClick()} else {
            if (isPrimary == 1) {
            }
          }
        },
        child: Container(
          color: color,
        ),
      ),
    );
  }
}

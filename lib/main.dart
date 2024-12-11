import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo da Velha',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TicTacToePage(),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  @override
  _TicTacToePageState createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  List<String> board = List.filled(9, "");
  String currentPlayer = "X";
  String winner = "";
  bool isComputer = false;

  void resetGame() {
    setState(() {
      board = List.filled(9, "");
      currentPlayer = "X";
      winner = "";
    });
  }

  void handleTap(int index) {
    if (board[index] == "" && winner == "") {
      setState(() {
        board[index] = currentPlayer;
        if (checkWinner()) {
          winner = currentPlayer;
        } else {
          currentPlayer = currentPlayer == "X" ? "O" : "X";
          if (isComputer && currentPlayer == "O") {
            computerMove();
          }
        }
      });
    }
  }

  void computerMove() {
    Future.delayed(Duration(milliseconds: 500), () {
      int index = findBestMove();
      if (index != -1 && winner == "") {
        setState(() {
          board[index] = "O";
          if (checkWinner()) {
            winner = "O";
          } else {
            currentPlayer = "X";
          }
        });
      }
    });
  }

  int findBestMove() {
    // Escolhe uma posição aleatória vazia
    List<int> availableMoves = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == "") {
        availableMoves.add(i);
      }
    }
    if (availableMoves.isNotEmpty) {
      return availableMoves[Random().nextInt(availableMoves.length)];
    }
    return -1;
  }

  bool checkWinner() {
    // Condições de vitória
    List<List<int>> winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var condition in winConditions) {
      if (board[condition[0]] == currentPlayer &&
          board[condition[1]] == currentPlayer &&
          board[condition[2]] == currentPlayer) {
        return true;
      }
    }
    return false;
  }

  Widget buildTile(int index) {
    return GestureDetector(
      onTap: () => handleTap(index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
        ),
        child: Center(
          child: Text(
            board[index],
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text('Jogo da Velha'),
        backgroundColor: Colors.blue.shade200,
        actions: [
          Switch(
            value: isComputer,
            onChanged: (value) {
              setState(() {
                isComputer = value;
                resetGame();
              });
            },
            activeColor: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              isComputer ? "Computador" : "Humano",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return buildTile(index);
                },
              ),
            ),
            SizedBox(height: 20),
            if (winner != "")
              Text(
                'Vencedor: $winner',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            if (winner == "" && !board.contains(""))
              Text(
                'Empate!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetGame,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.blue.shade300,
              ),
              child: Text(
                'Reiniciar',
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

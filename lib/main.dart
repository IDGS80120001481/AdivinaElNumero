import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Color.fromARGB(255, 114, 207, 253), // Color del AppBar
        ),
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int randomNumber = Random().nextInt(100) + 1;
  int attempts = 10;
  int minRange = 1;
  int maxRange = 100;
  String helperText = "1";
  String counterText = "100";
  TextEditingController _controller = TextEditingController();

  void _restartGame() {
    setState(() {
      randomNumber = Random().nextInt(100) + 1;
      attempts = 10;
      minRange = 1;
      maxRange = 100;
      helperText = " 1";
      counterText = "100";
      _controller.clear();
    });
  }

  void _checkNumber(int guessedNumber) {
    setState(() {
      attempts--;
      if (guessedNumber == randomNumber) {
        _showAlertDialog("¡Ganaste!", "El número adivinado es : $randomNumber");
        return;
      } else if (guessedNumber < randomNumber) {
        minRange = guessedNumber + 1;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("El número es demasiado bajo. Introduce uno más alto."),
          ),
        );
      } else {
        maxRange = guessedNumber - 1;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("El número es demasiado alto. Introduce uno más bajo."),
          ),
        );
      }

      if (attempts == 0) {
        _showAlertDialog("¡Perdiste!", "El número era $randomNumber.");
      } else {
        helperText = "$minRange";
        counterText = "$maxRange";
      }
    });
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text("Jugar de nuevo"),
              onPressed: () {
                Navigator.of(context).pop();
                _restartGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _submitNumber() {
    int guessedNumber = int.tryParse(_controller.text) ?? 0;
    if (guessedNumber >= minRange && guessedNumber <= maxRange) {
      _checkNumber(guessedNumber);
      _controller.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Por favor, introduce un número válido entre $minRange y $maxRange"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Adivina el número",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Intentos restantes: ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "$attempts",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                onSubmitted: (String value) {
                  _submitNumber();
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(139, 152, 226, 0.6),
                  prefixIcon: Icon(Icons.numbers),
                  helperText: helperText,
                  counterText: counterText,
                  border: OutlineInputBorder(),
                  labelText: "Número",
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
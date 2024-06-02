import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const GuessingGameApp());
}

class GuessingGameApp extends StatelessWidget {
  const GuessingGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 114, 207, 253), // Color del AppBar
        ),
      ),
      home: const GuessingGameScreen(),
    );
  }
}

class GuessingGameScreen extends StatefulWidget {
  const GuessingGameScreen({super.key});

  @override
  _GuessingGameScreenState createState() => _GuessingGameScreenState();
}

class _GuessingGameScreenState extends State<GuessingGameScreen> {
  int targetNumber = Random().nextInt(100) + 1;
  int remainingAttempts = 10;
  int lowerBound = 1;
  int upperBound = 100;
  String minHint = "1";
  String maxHint = "100";
  final TextEditingController _numberController = TextEditingController();

  void _resetGame() {
    setState(() {
      targetNumber = Random().nextInt(100) + 1;
      remainingAttempts = 10;
      lowerBound = 1;
      upperBound = 100;
      minHint = "1";
      maxHint = "100";
      _numberController.clear();
    });
  }

  void _validateGuess(int guessedNumber) {
    setState(() {
      remainingAttempts--;
      if (guessedNumber == targetNumber) {
        _showDialog("¡Ganaste!", "El número correcto es: $targetNumber");
      } else {
        if (guessedNumber < targetNumber) {
          lowerBound = guessedNumber + 1;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("El número es demasiado bajo. Prueba uno más alto."),
            ),
          );
        } else {
          upperBound = guessedNumber - 1;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("El número es demasiado alto. Prueba uno más bajo."),
            ),
          );
        }

        if (remainingAttempts == 0) {
          _showDialog("¡Perdiste!", "El número correcto era $targetNumber.");
        } else {
          minHint = "$lowerBound";
          maxHint = "$upperBound";
        }
      }
    });
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text("Jugar de nuevo"),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _submitGuess() {
    int guessedNumber = int.tryParse(_numberController.text) ?? 0;
    if (guessedNumber >= lowerBound && guessedNumber <= upperBound) {
      _validateGuess(guessedNumber);
      _numberController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Introduce un número válido entre $lowerBound y $upperBound."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
                  const Text(
                    "Intentos restantes: ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "$remainingAttempts",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                onSubmitted: (String value) {
                  _submitGuess();
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromRGBO(139, 152, 226, 0.6),
                  prefixIcon: const Icon(Icons.numbers),
                  helperText: minHint,
                  counterText: maxHint,
                  border: const OutlineInputBorder(),
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
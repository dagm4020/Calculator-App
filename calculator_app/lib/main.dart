import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String displayValue = '0';
  int? firstNumber;
  String? operation;
  bool operationPressed = false;
  bool showClrText = false;

  void _onNumberPressed(String number) {
    if (displayValue.length >= 12) {
      _showLimitExceededError();
      return;                             //checking which error message to show 
    }
    else if(displayValue=='Infinity') {
      return;
    }

    setState(() {
      if (operationPressed) {
        displayValue = number;
        operationPressed = false;
      } else if (displayValue == '0') {
        displayValue = number;
      } else {
        displayValue += number;
      }

      showClrText = false;
    });
  }

  void _showLimitExceededError() {
    setState(() {
      displayValue = 'INPUT LIMIT EXCEEDED';
      showClrText = true;
    });
  }
  //resets the display, opreation, pressed flag, and first value entered if any
  void _clearDisplay() {
    setState(() {
      displayValue = '0';
      firstNumber = null;
      operation = null;
      operationPressed = false;
      showClrText = false;
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (displayValue.length > 1) {
        displayValue = displayValue.substring(0, displayValue.length - 1);
      } else {
        displayValue = '0';
      }
    });
  }

  void _onOperationPressed(String op) {
    setState(() {
      if (firstNumber != null && operation != null && !operationPressed) {
        _evaluate();
      }
      firstNumber = int.tryParse(
          displayValue); // makes sure this displays an integer as per instruction to keep it separate from grad students
      operation = op;
      operationPressed = true;
    });
  }

  void _evaluate() {
    if (firstNumber != null && operation != null) {
      int secondNumber = int.tryParse(displayValue) ?? 0;
      int result;

      switch (operation) {
        case '+':
          result = firstNumber! + secondNumber;
          break;
        case '-':
          result = firstNumber! - secondNumber;
          break;
        case '×':
          result = firstNumber! * secondNumber;
          break;
        case '÷':
          if (secondNumber == 0) {
            setState(() {
              displayValue = 'Infinity';
              showClrText = true;
            });
            return;
          } else {
            result = firstNumber! ~/ secondNumber;
          }
          break;
        default:
          return;
      }

      setState(() {
        displayValue = result.toString();
        firstNumber = null;
        operation = null;
        showClrText = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 93.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black54,
                          offset: Offset(4, 4),
                          blurRadius: 10),
                    ],
                  ),
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      displayValue,
                      style: TextStyle(
                        fontSize: displayValue == 'INPUT LIMIT EXCEEDED'
                            ? 28
                            : 48, //error message when user enters 12 digits, setting limitation for a basic calculator and to avoid overflow issues
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (showClrText)
                  const Positioned(
                    right: 10,
                    bottom: 5,
                    child: Text(
                      'CLR',
                      style:  TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 50),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: GridView.count(
                      padding: const EdgeInsets.all(16.0),
                      crossAxisCount: 3,
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 15.0,
                      children: [
                        _buildNumberButton('7'),
                        _buildNumberButton('8'),
                        _buildNumberButton('9'),
                        _buildNumberButton('4'),
                        _buildNumberButton('5'),
                        _buildNumberButton('6'),
                        _buildNumberButton('1'),
                        _buildNumberButton('2'),
                        _buildNumberButton('3'),
                        _buildClearButton(),
                        _buildNumberButton('0'),
                        _buildDeleteButton(),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildOperationButton('+'),
                      const SizedBox(height: 15),
                      _buildOperationButton('-'),
                      const SizedBox(height: 15),
                      _buildOperationButton('×'),
                      const SizedBox(height: 15),
                      _buildOperationButton('÷'),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 60,
                        child: Center(
                          child: _buildEqualsButton(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return _buildTranslucentButton(
      onPressed: () => _onNumberPressed(number),
      child: Text(
        number,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      color: Colors.blueAccent.withOpacity(0.7),
    );
  }


  Widget _buildClearButton() {
    return _buildTranslucentButton(
      onPressed: _clearDisplay,
      child: const Text(
        'CLR',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      color: Colors.redAccent.withOpacity(0.7),
    );
  }

  Widget _buildDeleteButton() {
    return _buildTranslucentButton(
      onPressed: _onDeletePressed,
      child: const Icon(Icons.backspace, size: 32, color: Colors.white),
      color: Colors.grey.withOpacity(0.7),
    );
  }

  Widget _buildOperationButton(String operation) {
    return _buildTranslucentButton(
      onPressed: () => _onOperationPressed(operation),
      child: Text(
        operation,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      color: Colors.orangeAccent.withOpacity(0.7),
    );
  }

  Widget _buildEqualsButton() {
    return _buildTranslucentButton(
      onPressed: _evaluate, //provides answer
      child: const Text(
        '=',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      color: Colors.greenAccent.withOpacity(0.7),
    );
  }

  Widget _buildTranslucentButton({
    required VoidCallback onPressed,
    required Widget child,
    Color? color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.white.withOpacity(0.5),
        padding: const EdgeInsets.all(20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: child,
    );
  }
}

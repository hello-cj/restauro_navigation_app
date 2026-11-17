import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController firstController = TextEditingController();
  final TextEditingController secondController = TextEditingController();

  String result = '0';
  String? errorText;

  void calculate(String op) {
    final a = double.tryParse(firstController.text.trim());
    final b = double.tryParse(secondController.text.trim());

    if (a == null || b == null) {
      setState(() {
        errorText = 'Enter two valid numbers.';
        result = '0';
      });
      return;
    }

    double answer;
    switch (op) {
      case '+':
        answer = a + b;
        break;
      case '-':
        answer = a - b;
        break;
      case '×':
        answer = a * b;
        break;
      default:
        if (b == 0) {
          setState(() {
            errorText = 'Cannot divide by zero.';
            result = '0';
          });
          return;
        }
        answer = a / b;
    }

    setState(() {
      errorText = null;
      result = answer == answer.truncateToDouble()
          ? answer.toInt().toString()
          : answer.toString();
    });
  }

  void clear() {
    firstController.clear();
    secondController.clear();
    setState(() {
      result = '0';
      errorText = null;
    });
  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: firstController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            decoration: const InputDecoration(
              labelText: 'First number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: secondController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Second number',
              border: OutlineInputBorder(),
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 12),
            Text(
              errorText!,
              style: const TextStyle(color: Colors.red),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final op in ['+', '-', '×', '÷'])
                ElevatedButton(
                  onPressed: () => calculate(op),
                  child: Text(op, style: const TextStyle(fontSize: 20)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: clear,
            child: const Text('Clear'),
          ),
          const SizedBox(height: 24),
          const Text('Result', textAlign: TextAlign.center),
          Text(
            result,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

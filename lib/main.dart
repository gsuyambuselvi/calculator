import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C1C1E),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  double _operand1 = 0;
  String _operator = '';
  bool _waitingForOperand2 = false;

  void _onDigit(String digit) {
    setState(() {
      if (_waitingForOperand2) {
        _display = digit;
        _waitingForOperand2 = false;
      } else {
        _display = _display == '0' ? digit : _display + digit;
      }
    });
  }

  void _onDecimal() {
    setState(() {
      if (_waitingForOperand2) {
        _display = '0.';
        _waitingForOperand2 = false;
        return;
      }
      if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _onOperator(String op) {
    setState(() {
      _operand1 = double.parse(_display);
      _operator = op;
      _waitingForOperand2 = true;
    });
  }

  void _onEquals() {
    if (_operator.isEmpty) return;
    final double operand2 = double.parse(_display);
    double result = 0;
    switch (_operator) {
      case '+':
        result = _operand1 + operand2;
        break;
      case '-':
        result = _operand1 - operand2;
        break;
      case '×':
        result = _operand1 * operand2;
        break;
      case '÷':
        result = operand2 != 0 ? _operand1 / operand2 : double.nan;
        break;
    }
    setState(() {
      _display = result.isNaN
          ? 'Error'
          : result == result.truncateToDouble()
              ? result.toInt().toString()
              : result.toString();
      _operator = '';
      _waitingForOperand2 = false;
    });
  }

  void _onClear() {
    setState(() {
      _display = '0';
      _operand1 = 0;
      _operator = '';
      _waitingForOperand2 = false;
    });
  }

  void _onToggleSign() {
    setState(() {
      if (_display != '0' && _display != 'Error') {
        _display = _display.startsWith('-')
            ? _display.substring(1)
            : '-$_display';
      }
    });
  }

  void _onPercent() {
    setState(() {
      final value = double.tryParse(_display);
      if (value != null) {
        final result = value / 100;
        _display = result == result.truncateToDouble()
            ? result.toInt().toString()
            : result.toString();
      }
    });
  }

  Widget _buildButton(String label, {Color? bg, Color? fg, int flex = 1}) {
    final isZero = label == '0';
    return Expanded(
      flex: isZero ? 2 : flex,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ElevatedButton(
          onPressed: () => _handleButton(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: bg ?? const Color(0xFF3A3A3C),
            foregroundColor: fg ?? Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isZero ? 40 : 100),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Align(
            alignment: isZero ? Alignment.centerLeft : Alignment.center,
            child: Padding(
              padding: isZero
                  ? const EdgeInsets.only(left: 28)
                  : EdgeInsets.zero,
              child: Text(
                label,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleButton(String label) {
    switch (label) {
      case 'AC':
        _onClear();
        break;
      case '+/-':
        _onToggleSign();
        break;
      case '%':
        _onPercent();
        break;
      case '.':
        _onDecimal();
        break;
      case '=':
        _onEquals();
        break;
      case '+':
      case '-':
      case '×':
      case '÷':
        _onOperator(label);
        break;
      default:
        _onDigit(label);
    }
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF9F0A);
    const darkGray = Color(0xFF636366);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Display
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _display,
                      style: const TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Buttons
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  Row(children: [
                    _buildButton('AC', bg: darkGray, fg: Colors.black),
                    _buildButton('+/-', bg: darkGray, fg: Colors.black),
                    _buildButton('%', bg: darkGray, fg: Colors.black),
                    _buildButton('÷', bg: orange),
                  ]),
                  Row(children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('×', bg: orange),
                  ]),
                  Row(children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('-', bg: orange),
                  ]),
                  Row(children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('+', bg: orange),
                  ]),
                  Row(children: [
                    _buildButton('0'),
                    _buildButton('.'),
                    _buildButton('=', bg: orange),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

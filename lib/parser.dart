import 'dart:collection';

var digits = <String>['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
var operators = <String>['+', '-', '*', '/'];

class Parser {
  const Parser();

  num _eval(num op1, num op2, String op) {
    switch (op) {
      case '+':
        return op1 + op2;
      case '-':
        return op1 - op2;
      case '*':
        return op1 * op2;
      case '/':
        return op1 / op2;
      default:
        return 0;
    }
  }

  int _getPriority(String op) {
    switch (op) {
      case '+':
      case '-':
        return 0;
      case '*':
      case '/':
        return 1;
      default:
        return -1;
    }
  }

  bool _isOperator(String op) {
    return operators.contains(op);
  }

  bool _isDigit(String op) {
    return digits.contains(op);
  }

  num parseExpression(String expr) {
    Queue<String> operators = new ListQueue<String>();
    Queue<num> operands = new ListQueue<num>();

    // True if the last character was a digit
    // to accept numbers with more digits
    bool lastDig = true;

    // INIT
    operands.addLast(0);

    expr.split('').forEach((String c) {
      if (_isDigit(c)) {
        if (lastDig) {
          num last = operands.removeLast();
          operands.addLast(last * 10 + int.parse(c));
        } else
          operands.addLast(int.parse(c));
      } else if (_isOperator(c)) {
        if (!lastDig) throw new ArgumentError('Illegal expression');

        if (operators.isEmpty)
          operators.addLast(c);
        else {
          while (operators.isNotEmpty &&
              operands.isNotEmpty &&
              _getPriority(c) <= _getPriority(operators.last)) {
            num op1 = operands.removeLast();
            num op2 = operands.removeLast();
            String op = operators.removeLast();

            // op1 and op2 in reverse order!
            num res = _eval(op2, op1, op);
            operands.addLast(res);
          }
          operators.addLast(c);
        }
      }
      lastDig = _isDigit(c);
    });

    while (operators.isNotEmpty) {
      num op1 = operands.removeLast();
      num op2 = operands.removeLast();
      String op = operators.removeLast();

      // op1 and op2 in reverse order!
      num res = _eval(op2, op1, op);
      operands.addLast(res);
    }

    return operands.removeLast();
  }
}

import 'dart:collection';

class Parser {
  const Parser();

  num _eval(num op1, num op2, int op) {
    switch (new String.fromCharCode(op)) {
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

  int _getPriority(num op) {
    switch (new String.fromCharCode(op)) {
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

  bool _isOperator(num op) {
    switch (new String.fromCharCode(op)) {
      case '+':
      case '-':
      case '*':
      case '/':
        return true;
      default:
        return false;
    }
  }

  bool _isDigit(int op) {
    return op >= '0'.codeUnitAt(0) && op <= '9'.codeUnitAt(0);
  }

  num parseExpression(String expr) {
    Queue<int> operators = new ListQueue<int>();
    Queue<num> operands = new ListQueue<num>();

    // True if the last character was a digit
    // to accept numbers with more digits
    bool lastDig = true;

    // INIT
    operands.addLast(0);

    expr.runes.forEach((int c) {
      if (_isDigit(c)) {
        if (lastDig) {
          num last = operands.removeLast();
          operands.addLast(last * 10 + (c - '0'.codeUnitAt(0)));
        } else
          operands.addLast(c - '0'.codeUnitAt(0));
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
            int op = operators.removeLast();

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
      int op = operators.removeLast();

      num res = _eval(op2, op1, op);
      operands.addLast(res);
    }

    return operands.removeLast();
  }
}

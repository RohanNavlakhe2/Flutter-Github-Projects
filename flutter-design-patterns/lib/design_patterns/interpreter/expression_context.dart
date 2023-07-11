class ExpressionContext {
  final List<String> _solutionSteps = List<String>();

  List<String> getSolutionSteps() {
    return _solutionSteps;
  }

  void addSolutionStep(String operatorSymbol, int left, int right, int result) {
    var solutionStep =
        '${_solutionSteps.length + 1}) $left $operatorSymbol $right = $result';

    _solutionSteps.add(solutionStep);
  }
}

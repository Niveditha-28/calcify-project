// area_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/area_model.dart';
import 'package:math_expressions/math_expressions.dart';

class AreaViewModel extends ChangeNotifier {
  List<AreaModel> formulas = [];
  bool isLoading = true;

  String? selectedShapeId;
  AreaModel? selectedFormula;
  Map<String, double> userInputs = {};
  Map<String, TextEditingController> controllers = {};
  String? result;

  Future<void> loadFormulas() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/area_formulas'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        formulas = (jsonData['formulas'] as List)
            .map((f) => AreaModel.fromJson(f))
            .toList();
      }
    } catch (e) {
      print("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void selectShape(String id) {
    selectedShapeId = id;
    selectedFormula = formulas.firstWhere((f) => f.id == id);
    userInputs.clear();
    result = null;

    controllers.forEach((_, controller) => controller.clear());
    controllers.clear();
    selectedFormula!.variables.forEach((key, _) {
      controllers[key] = TextEditingController();
    });

    notifyListeners();
  }

  void setVariableValue(String key) {
  final controller = controllers[key];
  if (controller != null) {
    final value = double.tryParse(controller.text);
    if (value != null) {
      userInputs[key] = value;
    }
  }
}

  void calculateArea() {
    print("Reached Calculate Area");
    if (selectedFormula == null) return;
    final expr = selectedFormula!.mainExpression;
    

    try {
      final parser = ShuntingYardParser();
      Expression parsed = parser.parse(expr);

      ContextModel cm = ContextModel();

      // Bind user inputs first
      userInputs.forEach((k, v) {
        cm.bindVariable(Variable(k), Number(v));
      });

      // Then evaluate helper expressions
      selectedFormula!.helperExpressions.forEach((k, v) {
        final hExpr = parser.parse(v);
        final hValue = hExpr.evaluate(EvaluationType.REAL, cm);
        cm.bindVariable(Variable(k), Number(hValue));
      });

      double eval = parsed.evaluate(EvaluationType.REAL, cm);
      result = eval.toStringAsFixed(2);
    } catch (e) {
      result = "Error in formula";
    }
    print("Calculate Area Finished");
    notifyListeners();
  }
}

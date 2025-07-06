import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/bmi_model.dart'; // adjust path as needed
import 'package:math_expressions/math_expressions.dart';

class BmiViewModel extends ChangeNotifier {
  List<BmiModel> bmiModels = [];
  BmiModel? selectedModel;
  Map<String, TextEditingController> controllers = {};
  String? result;
  String? category;
  String? tip;

  bool isLoading = true;

  Future<void> loadBmiData() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/bmi_data'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        selectedModel = BmiModel.fromJson(jsonData['bmi'][0]);
        _initializeControllers(); // Initialize the input controllers

        if (bmiModels.isNotEmpty) {
          selectedModel = bmiModels[0];
          _initializeControllers();
        }
      } else {
        print('Failed to load BMI data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading BMI data: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  void _initializeControllers() {
    controllers.clear();
    if (selectedModel != null) {
      for (var variable in selectedModel!.variables) {
        controllers[variable.name] = TextEditingController();
      }
    }
  }

  void calculateBmi() {
    if (selectedModel == null) return;

    String formula = selectedModel!.formula;
    final parser = ShuntingYardParser();
    Expression expression = parser.parse(formula);
    ContextModel cm = ContextModel();

    for (var variable in selectedModel!.variables) {
      final controller = controllers[variable.name];
      if (controller == null || controller.text.trim().isEmpty) {
        result = "Missing input";
        notifyListeners();
        return;
      }

      double? value = double.tryParse(controller.text);
      if (value == null) {
        result = "Invalid input";
        notifyListeners();
        return;
      }

      cm.bindVariable(Variable(variable.name), Number(value));
    }

    try {
      double eval = expression.evaluate(EvaluationType.REAL, cm);
      result = eval.toStringAsFixed(2);
      _evaluateCategory(eval);
    } catch (e) {
      result = "Error in formula";
    }

    notifyListeners();
  }

  void _evaluateCategory(double bmiValue) {
    if (selectedModel == null) return;

    final categories = selectedModel!.bmiCategories;
    for (var cat in categories) {
      if (bmiValue >= cat.min && bmiValue <= cat.max) {
        category = cat.category;
        tip = cat.tip;
        return;
      }
    }

    category = "Unknown";
    tip = "";
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}

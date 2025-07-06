class BmiModel {
  final String name;
  final List<BmiCategory> bmiCategories;
  final double min;
  final String unit;
  final List<BmiVariable> variables;
  final String formula;
  final String id;

  BmiModel({
    required this.name,
    required this.bmiCategories,
    required this.min,
    required this.unit,
    required this.variables,
    required this.formula,
    required this.id,
  });

  factory BmiModel.fromJson(Map<String, dynamic> json) {
    return BmiModel(
      name: json['name'],
      bmiCategories: (json['bmi_categories'] as List)
          .map((cat) => BmiCategory.fromJson(cat))
          .toList(),
      min: json['min'].toDouble(),
      unit: json['unit'],
      variables: (json['variables'] as List)
          .map((v) => BmiVariable.fromJson(v))
          .toList(),
      formula: json['formula'],
      id: json['id'],
    );
  }
}

class BmiCategory {
  final String category;
  final double min;
  final double max;
  final String tip;

  BmiCategory({
    required this.category,
    required this.min,
    required this.max,
    required this.tip,
  });

  factory BmiCategory.fromJson(Map<String, dynamic> json) {
    return BmiCategory(
      category: json['category'],
      min: json['min'].toDouble(),
      max: json['max'].toDouble(),
      tip: json['tip'],
    );
  }
}

class BmiVariable {
  final String name;
  final String label;
  final String unit;

  BmiVariable({
    required this.name,
    required this.label,
    required this.unit,
  });

  factory BmiVariable.fromJson(Map<String, dynamic> json) {
    return BmiVariable(
      name: json['name'],
      label: json['label'],
      unit: json['unit'],
    );
  }
}

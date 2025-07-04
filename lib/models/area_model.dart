class AreaModel {
  final String id;
  final String shape;
  final String description;
  final String mainExpression;
  final String? sampleImage;
  final String units;
  final Map<String, dynamic> helperExpressions;
  final Map<String, dynamic> variables;

  AreaModel({
    required this.id,
    required this.shape,
    required this.description,
    required this.mainExpression,
    this.sampleImage,
    required this.units,
    required this.helperExpressions,
    required this.variables,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id'] ?? '',
      shape: json['shape'] ?? '',
      description: json['description'] ?? '',
      mainExpression: json['main_expression'] ?? '',
      sampleImage: json['sample-image'],
      units: json['units'] ?? '',
      helperExpressions: Map<String, dynamic>.from(json['helper_expressions'] ?? {}),
      variables: Map<String, dynamic>.from(json['variables'] ?? {}),
    );
  }
}

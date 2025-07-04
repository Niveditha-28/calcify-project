class VolumeModel {
  final String id;
  final String shape;
  final String description;
  final String formula;
  final String? sampleImage;
  final String units;
  final Map<String, dynamic> variables;

  VolumeModel({
    required this.id,
    required this.shape,
    required this.description,
    this.sampleImage,
    required this.units,
    required this.formula,
    required this.variables,
  });

  factory VolumeModel.fromJson(Map<String, dynamic> json) {
    return VolumeModel(
      id: json['id'] ?? '',
      shape: json['shape'] ?? '',
      description: json['description'] ?? '',
      formula: json['formula'] ?? '',
      sampleImage: json['sample-image'],
      units: json['units'] ?? '',
      variables: Map<String, dynamic>.from(json['variables'] ?? {}),
    );
  }
}

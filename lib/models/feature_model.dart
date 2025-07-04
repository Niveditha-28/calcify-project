class FeatureModel {
  final String feature_name;
  final String navigation;
  final String icon;
  final String description;
  

  FeatureModel({
    required this.feature_name,
    required this.navigation,
    required this.icon,
    required this.description
  });

  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    print("Entering fromJson");
    return FeatureModel(
      feature_name: json['feature_name'] ?? 'Unknown',
      navigation: json['navigation'] ?? '',
      icon: json['icon'] ?? '',
      description: json['description'] ?? ''
    );
  }
}

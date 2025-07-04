import 'package:flutter/material.dart';
import '../models/feature_model.dart';
import '../services/api_service.dart';

class HomeViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<FeatureModel> _features = [];
  List<FeatureModel> get features => _features;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> loadFeatures() async {
    try {
      print("Calling API...");
      _features = await _apiService.fetchFeatures();
      print("Features loaded: ${_features.length}");
    } catch (e) {
      print("Error loading features: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
      print("Done loading. Notifying listeners...");
    }
  }
}

import 'package:flutter/material.dart';
import '../models/feature_model.dart';
import '../views/calculate_area_page.dart'; // ✅ Adjust path if needed
import '../views/calculate_volume_page.dart'; // Adjust path if necessary


class FeatureCard extends StatelessWidget {
  final FeatureModel feature;

  const FeatureCard({Key? key, required this.feature}) : super(key: key);

  @override
  
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (feature.navigation == "Calculate Area") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CalculateAreaPage()),
          );
        } else if (feature.navigation == "Calculate Volume") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CalculateVolumePage()),
          );
        }
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                feature.icon,
                height: 48,
                width: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              feature.feature_name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
  

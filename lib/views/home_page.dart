import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // for Consumer and ChangeNotifier
import '../viewmodels/home_viewmodel.dart'; // update this to your actual path
import '../widgets/feature_card.dart'; // only if you're using a separate file



class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return ChangeNotifierProvider(
    create: (_) => HomeViewModel()..loadFeatures(), // okay to call here
    child: Scaffold(
      appBar: AppBar(title: Text("Calcify Features")),
      body: Consumer<HomeViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (vm.features.isEmpty) {
            return Center(child: Text("No features found"));
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // To avoid scroll conflict with parent
              crossAxisCount: 2, // Two icons per row
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2, // Adjust for shape
              children: vm.features.map((feature) {
                return FeatureCard(feature: feature);
              }).toList(),
            ),
          );

        },
      ),
    ),
  );
  }
}
           

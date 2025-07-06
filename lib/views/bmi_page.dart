import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/bmi_viewmodel.dart';

class BmiPage extends StatelessWidget {
  const BmiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BmiViewModel()..loadBmiData(),
      child:  Scaffold(
        appBar: AppBar(title: Text("BMI Calculator")),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: BmiContent(),
        ),
      ),
    );
  }
}

class BmiContent extends StatelessWidget {
  BmiContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BmiViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.selectedModel == null) {
          return const Center(child: Text("No BMI model found."));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vm.selectedModel!.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...vm.selectedModel!.variables.map((variable) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    controller: vm.controllers[variable.name],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: variable.label,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: vm.calculateBmi,
                  child: const Text("Calculate BMI"),
                ),
              ),
              const SizedBox(height: 24),
              if (vm.result != null)
                Text("BMI: ${vm.result}", style: const TextStyle(fontSize: 18)),
              if (vm.category != null)
                Text("Category: ${vm.category}", style: const TextStyle(fontSize: 18)),
              if (vm.tip != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text("Tip: ${vm.tip}", style: const TextStyle(fontSize: 16)),
                ),
            ],
          ),
        );
      },
    );
  }
}

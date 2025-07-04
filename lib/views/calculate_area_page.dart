import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/area_viewmodel.dart';

class CalculateAreaPage extends StatelessWidget {
  const CalculateAreaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AreaViewModel()..loadFormulas(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Calculate Area')),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: AreaContent(),
        ),
      ),
    );
  }
}

class AreaContent extends StatefulWidget {
  const AreaContent({super.key});

  @override
  State<AreaContent> createState() => _AreaContentState();
}

class _AreaContentState extends State<AreaContent> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AreaViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select Shape:", style: TextStyle(fontSize: 16)),
              DropdownButton<String>(
                isExpanded: true,
                value: vm.selectedShapeId,
                hint: const Text("Choose a shape"),
                items: vm.formulas.map((f) {
                  return DropdownMenuItem(
                    value: f.id,
                    child: Text(f.shape),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    vm.selectShape(value);
                    setState(() {}); // Refresh UI
                  }
                },
              ),
              const SizedBox(height: 16),
              if (vm.selectedFormula != null) ...[
                if (vm.selectedFormula!.sampleImage != null)
                  Image.network(vm.selectedFormula!.sampleImage!, height: 150),
                const SizedBox(height: 8),
                Text(vm.selectedFormula!.description,
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 12),
                Text("Formula: ${vm.selectedFormula!.mainExpression}"),
                const SizedBox(height: 16),
                ...vm.selectedFormula!.variables.entries.map((entry) {
                  final key = entry.key;
                  final label = entry.value['label'];
                  final unit = entry.value['unit'];
                  final controller = vm.controllers[key];

                  return TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: "$label ($unit)",
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) {
                      vm.setVariableValue(key);
                    },
                  );
                }).toList(),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    for (var key in vm.selectedFormula!.variables.keys) {
                      vm.setVariableValue(key);
                    }
                    vm.calculateArea();
                  },
                  child: const Text("Calculate Area"),
                ),
                const SizedBox(height: 16),
                if (vm.result != null)
                  Text("Result: ${vm.result} ${vm.selectedFormula!.units}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
              ]
            ],
          ),
        );
      },
    );
  }
} 

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/volume_viewmodel.dart';

class CalculateVolumePage extends StatelessWidget {
  const CalculateVolumePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VolumeViewModel()..loadFormulas(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Calculate volume')),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: VolumeContent(),
        ),
      ),
    );
  }
}

class VolumeContent extends StatefulWidget {
  const VolumeContent({super.key});

  @override
  State<VolumeContent> createState() => _VolumeContentState();
}

class _VolumeContentState extends State<VolumeContent> {
  @override
  Widget build(BuildContext context) {
    return Consumer<VolumeViewModel>(
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
                Text("Formula: ${vm.selectedFormula!.formula}"),
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
                    vm.calculateVolume();
                  },
                  child: const Text("Calculate Volume"),
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

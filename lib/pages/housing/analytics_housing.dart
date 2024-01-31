import 'package:flutter/material.dart';
import 'package:propsync_system/models/housing_model.dart';

class AnalyticsHousingPage extends StatelessWidget {
  final Housing logement;
  const AnalyticsHousingPage({super.key, required this.logement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Analyse du logement"),
      ),
      body: Center(
        child: Text("Analyse du logement ${logement.name}")
      ),
    );
  }

}
import 'package:flutter/material.dart';
import 'package:propsync_system/models/housing_model.dart';

class TenantHousingPage extends StatelessWidget {
  final Housing logement;
  const TenantHousingPage({super.key, required this.logement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Locataire du logement"),
      ),
      body: Center(
        child: Text("Locataire du logement ${logement.name}")
      ),
    );
  }

}
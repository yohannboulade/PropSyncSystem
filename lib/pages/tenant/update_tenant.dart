import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:propsync_system/const.dart';
import 'package:propsync_system/models/member_model.dart';
import 'package:propsync_system/models/tenant_model.dart';
import 'package:propsync_system/widgets/column_spacing.dart';
import 'package:propsync_system/widgets/text_field_style.dart';
import 'package:propsync_system/services/firestore.dart';
import 'package:propsync_system/services/keys.dart';

import '../../models/finance_model.dart';
import '../../models/housing_model.dart';

class UpdateTenantPage extends StatefulWidget {
  final Member member;
  final Tenant tenant;

  const UpdateTenantPage({Key? key, required this.tenant, required this.member}) : super(key: key);

  @override
  UpdateState createState() => UpdateState();
}

class UpdateState extends State<UpdateTenantPage> {
  late List<String> typeOptions;
  late String typeController;
  late List<String> civilitiesOptions;
  late String civilitiesController;
  late TextEditingController housingController;
  late Map<String, String> housingOptions;
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  Future<void> _getHousingOptions(String? selectedValue) async {
    try {
      QuerySnapshot housingSnapshot = await FirestoreService().housingForUser(widget.member.id).first;
      List<Housing> housingList = housingSnapshot.docs
          .map((doc) => Housing(
        reference: doc.reference,
        id: doc.id,
        map: doc.data() as Map<String, dynamic>,
      ))
          .toList();

      Map<String, String> options = {};

      options['NA'] = "Finance non associée";
      for (int i = 0; i < housingList.length; i++) {
        options[housingList[i].id] = housingList[i].name;
      }

      if (mounted) {
        setState(() {
          housingOptions = options;
          if (selectedValue != null && options.containsKey(selectedValue)) {
            // Si selectedValue n'est pas null et existe dans options, l'utiliser
            housingController.text = selectedValue;
          } else {
            // Sinon, utiliser 'NA' par défaut
            housingController.text = 'NA';
          }
        });
      }
    } catch (e) {
      // Gérer les erreurs si nécessaire
      print("Error loading housing data: $e");
    }
  }


  @override
  void initState() {
    super.initState();
    typeOptions = ['Actif', 'Achive'];
    typeController = widget.tenant.tenantType;
    civilitiesOptions = Const.civilities;
    civilitiesController = widget.tenant.tenantCivilite;
    nameController = TextEditingController(text: widget.tenant.tenantName);
    surnameController = TextEditingController(text: widget.tenant.tenantSurname);
    housingController = TextEditingController(text: widget.tenant.tenantHousing);
    emailController = TextEditingController(text: widget.tenant.tenantMail);
    phoneController = TextEditingController(text: widget.tenant.tenantPhone);

    _getHousingOptions(housingController.text); // Appel de la fonction pour obtenir la liste des logements
  }

  @override
  void dispose() {
    //typeController.dispose();
    //civilitiesController.dispose();
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    housingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Modifier le locataires"),
        actions: [
          ElevatedButton(
            onPressed: () {
              _onValidate();
              Navigator.pop(context);
            },
            child: const Text("Valider"),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            children: [
              Card(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        value: typeController,
                        onChanged: (String? newValue) {
                          setState(() {
                            typeController = newValue!;
                          });
                        },
                        items: typeOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const ColumnSpacing(),
                      DropdownButton<String>(
                        value: housingController.text,
                        onChanged: (String? newValue) {
                          if (newValue != null && housingOptions.containsKey(newValue)) {
                            setState(() {
                              housingController.text = newValue;
                            });
                          }
                        },
                        items: _getHousingDropdownItems(), // Utilisez la fonction pour obtenir les éléments de la liste des logements
                      ),
                      const ColumnSpacing(),
                      DropdownButton<String>(
                        value: civilitiesController,
                        onChanged: (String? newValue) {
                          setState(() {
                            civilitiesController = newValue!;
                          });
                        },
                        items: civilitiesOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const ColumnSpacing(),
                      TextField(
                        controller: nameController,
                        decoration: const TextFieldStyle(hint: "Nom"),
                      ),
                      const ColumnSpacing(),
                      TextField(
                        controller: surnameController,
                        decoration: const TextFieldStyle(hint: "Prénom"),
                      ),
                      const ColumnSpacing(),
                      TextField(
                        controller: emailController,
                        decoration: const TextFieldStyle(hint: "Mail"),
                      ),
                      const ColumnSpacing(),
                      TextField(
                        controller: phoneController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const TextFieldStyle(hint: "Téléphone"),
                      ),
                      const ColumnSpacing(),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Êtes-vous sûr de vouloir supprimer la transaction"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              FirestoreService().deleteTenant(memberId: widget.member.id,tenantId: widget.tenant.id).then((value) => Navigator.pop(context));
                            },
                            child: const Text("OUI"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("NON"),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  "Supprimer la transaction",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getHousingDropdownItems() {
    return housingOptions.keys.map<DropdownMenuItem<String>>((String key) {
      return DropdownMenuItem<String>(
        value: key,
        child: Text(housingOptions[key]!),
      );
    }).toList();
  }

  _onValidate() {
    FocusScope.of(context).requestFocus(FocusNode());
    Map<String, dynamic> map = {};
    final tenant = widget.tenant;

    if (nameController.text.isNotEmpty &&
        nameController.text != tenant.tenantName) {
      map[tenantNameKey] = nameController.text;
    }
    if (surnameController.text.isNotEmpty &&
        surnameController.text != tenant.tenantSurname) {
      map[tenantSurnameKey] = surnameController.text;
    }
    if (emailController.text.isNotEmpty &&
        emailController.text != tenant.tenantMail) {
      map[tenantMailKey] = emailController.text;
    }
    if (phoneController.text.isNotEmpty &&
        phoneController.text != tenant.tenantPhone) {
      map[tenantPhoneKey] = phoneController.text;
    }
    map[tenantTypeKey] = typeController;
    map[tenantHousingKey] = housingController.text;
    map[tenantCiviliteKey] = civilitiesController;

    try {
      FirestoreService().updateTenant(memberId: widget.member.id,tenantId: tenant.id, data: map);
      print('ok');
    } catch (e) {
      // Gérer les erreurs si nécessaire
      print("Error loading housing data: $e");
    }
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:propsync_system/const.dart';
import 'package:propsync_system/models/member_model.dart';
import 'package:propsync_system/widgets/column_spacing.dart';
import 'package:propsync_system/widgets/text_field_style.dart';
import 'package:propsync_system/services/firestore.dart';
import 'package:propsync_system/services/keys.dart';

import '../../models/finance_model.dart';
import '../../models/housing_model.dart';

class UpdateFinancePage extends StatefulWidget {
  final Member member;
  final Finance finance;

  const UpdateFinancePage({Key? key, required this.finance, required this.member}) : super(key: key);

  @override
  UpdateState createState() => UpdateState();
}

class UpdateState extends State<UpdateFinancePage> {
  late List<String> typeOptions;
  late String typeController;
  late TextEditingController labelController;
  late TextEditingController amountController;
  late TextEditingController housingController;
  late Map<String, String> housingOptions;

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
    typeOptions = Const.balance;
    typeController = widget.finance.financeType;
    labelController = TextEditingController(text: widget.finance.financeLabel);
    amountController = TextEditingController(text: widget.finance.financeAmount);
    housingController = TextEditingController(text: widget.finance.financeHousing);

    _getHousingOptions(housingController.text); // Appel de la fonction pour obtenir la liste des logements
  }

  @override
  void dispose() {
    labelController.dispose();
    amountController.dispose();
    housingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Modifier le logement"),
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
                color: Colors.grey.shade200,
                child: Container(
                  margin: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
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
                      DropdownButtonFormField<String>(
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
                      TextField(
                        controller: labelController,
                        decoration: const TextFieldStyle(hint: "Libellé"),
                      ),
                      const ColumnSpacing(),
                      TextField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const TextFieldStyle(hint: "Montant"),
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
                              FirestoreService().deleteFinance(memberId: widget.member.id,financeId: widget.finance.id).then((value) => Navigator.pop(context));
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
    final finance = widget.finance;

    if (labelController.text.isNotEmpty &&
        labelController.text != finance.financeLabel) {
      map[financeLabelKey] = labelController.text;
    }
    if (amountController.text.isNotEmpty &&
        amountController.text != finance.financeAmount) {
      map[financeAmountKey] = amountController.text;
    }
    map[financeTypeKey] = typeController;
    map[financeHousingKey] = housingController.text;

    try {
      FirestoreService().updateFinance(memberId: widget.member.id,financeId: finance.id, data: map);
      print('ok');
    } catch (e) {
      // Gérer les erreurs si nécessaire
      print("Error loading housing data: $e");
    }
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:propsync_system/const.dart';
import '../../models/member_model.dart';
import '../../models/housing_model.dart';
import '../../services/firestore.dart';
import '../../services/keys.dart';
import '../../widgets/column_spacing.dart';
import '../../widgets/text_field_style.dart';


class AddFinanceForm extends StatefulWidget {
  final Member member;
  const AddFinanceForm({Key? key, required this.member}) : super(key: key);
  @override
  AddFinanceFormState createState() => AddFinanceFormState();
}

class AddFinanceFormState extends State<AddFinanceForm> {
  late List<String> typeOptions;
  late String typeController;
  late Map<String, String> housingOptions = {"NA":"Finance non associer"};
  late String housingController = '';

  late TextEditingController referenceController;
  late TextEditingController montantController;

  Future<void> initData() async {
    try {
      QuerySnapshot housingSnapshot =
      await FirestoreService().housingForUser(widget.member.id).first;

      List<Housing> housing = housingSnapshot.docs
          .map((doc) => Housing(
        reference: doc.reference,
        id: doc.id,
        map: doc.data() as Map<String, dynamic>,
      ))
          .toList();

      Map<String, String> options = {};

      options['NA'] = "Finance non associer";
      for (int i = 0; i < housing.length; i++) {
        options[housing[i].id] = housing[i].name;
      }

      if (mounted) {
        setState(() {
          housingOptions = options;
          if (options.isNotEmpty) {
            housingController = options.keys.first;
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
    typeController = Const.balance[0];

    referenceController = TextEditingController();
    montantController = TextEditingController();

    initData();
  }

  @override
  void dispose() {
    referenceController.dispose();
    montantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Ajouter une finance"),
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
          padding: const EdgeInsets.all(16.0),
          height: screenHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              DropdownButtonFormField<String>(
                value: housingOptions.containsKey(housingController) ? housingController : null,
                onChanged: (String? newValue) {
                  if (newValue != null && housingOptions.containsKey(newValue)) {
                    setState(() {
                      housingController = newValue;
                    });
                  }
                },
                items: housingOptions.keys.map<DropdownMenuItem<String>>((String key) {
                  return DropdownMenuItem<String>(
                    value: key,
                    child: Text(housingOptions[key]!),
                  );
                }).toList(),
              ),
              const ColumnSpacing(),
              TextField(
                controller: referenceController,
                decoration: const TextFieldStyle(hint: "Référence du flux"),
              ),
              const ColumnSpacing(),
              TextField(
                controller: montantController,
                decoration: const TextFieldStyle(hint: "Montant"),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _onValidate() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final member = widget.member;
    final Map<String, dynamic> data = {
      financeMemberKey: member.id,
      financeHousingKey: housingController,
      financeTypeKey: typeController,
      financeLabelKey: referenceController.text,
      financeAmountKey: montantController.text,
    };
    try {
      var result = await FirestoreService().addFinance(memberId: member.id, data: data);
      // Opération réussie, vous pouvez traiter 'result' ici
      return "Firestore operation successful: $result";
    } catch (e) {
      if (e is FirebaseException) {
        // Gérer les erreurs spécifiques à Firestore
        return "Firestore error code: ${e.code}";
      } else {
        // Gérer d'autres types d'erreurs
        return "An unexpected error occurred: $e";
      }
    }
  }
}
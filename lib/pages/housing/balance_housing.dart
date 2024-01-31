import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:propsync_system/models/housing_model.dart';
import 'package:propsync_system/models/member_model.dart';

import '../../models/finance_model.dart';
import '../../services/firestore.dart';
import '../../widgets/empty.dart';
import '../finance/update_finance.dart';

class BalanceHousingPage extends StatelessWidget {
  final Housing logement;
  final Member member;
  const BalanceHousingPage({super.key, required this.member, required this.logement});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Balance du logement"),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _addProfit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Couleur de fond du bouton
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.attach_money),
                      SizedBox(width: 5), // Espacement entre l'icône et le texte
                      Text('Gain'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _addExpense,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Couleur de fond du bouton
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.money_off),
                      SizedBox(width: 5), // Espacement entre l'icône et le texte
                      Text('Dépense'),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirestoreService().financeForUserAndHousing(member.id, logement.id),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final doc = data.docs;
                  return ListView.builder(
                    itemCount: doc.length,
                    itemBuilder: (context, index) {
                      final d = doc[index];
                      final finance = Finance(
                        reference: d.reference,
                        id: d.id,
                        map: d.data() as Map<String, dynamic>,
                      );
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Type de finance : ${finance.financeType}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${finance.financeLabel} : ${finance.financeAmount}€',
                                    style: finance.financeType == "Gain"
                                        ? const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)
                                        : const TextStyle(fontWeight: FontWeight.normal, color: Colors.red),
                                  ),
                                ],
                              )
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit_note),
                            onPressed: () {
                              final page = UpdateFinancePage(finance: finance, member: member,);
                              final route = MaterialPageRoute(builder: ((context) => page));
                              Navigator.of(context).push(route);
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const EmptyBody();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
// Fonction pour ajouter un gain (profit)
  _addProfit() {
    // Logique pour ajouter un gain (profit)
  }

// Fonction pour ajouter une dépense
  _addExpense() {
    // Logique pour ajouter une dépense
  }

}
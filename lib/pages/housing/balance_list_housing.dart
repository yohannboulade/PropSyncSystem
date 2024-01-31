import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:propsync_system/pages/finance/update_finance.dart';

import '../../models/finance_model.dart';
import '../../models/member_model.dart';
import '../../models/housing_model.dart';
import '../../services/firestore.dart';
import '../../widgets/empty.dart';

class BalanceList extends StatelessWidget {
  final Housing logement;
  final Member member;
  const BalanceList({Key? key, required this.member, required this.logement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().financeForUser(member.id),
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
    );
  }
}
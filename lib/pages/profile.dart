import 'package:flutter/material.dart';
import 'package:propsync_system/models/member_model.dart';
import 'package:propsync_system/pages/update_profile.dart';
import 'package:propsync_system/services/authrntification.dart';
import 'package:propsync_system/widgets/avatar.dart';
import 'package:propsync_system/widgets/camera_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:propsync_system/services/firestore.dart';

import '../services/keys.dart';

class ProfilePage extends StatelessWidget {
  final Member member;
  const ProfilePage({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().postForUser(member.id),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          final data = snapshot.data;
          final docs = data?.docs;
          final length = docs?.length ?? 0;
          final isMe = AuthService().isMe(member.id);
          const indexToAdd = 1;
          return ListView.builder(
            itemCount: length + indexToAdd,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  //Image
                                  Container(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    child: (member.coverPicture.isEmpty)
                                    ? const Center()
                                    : Image.network(
                                      member.coverPicture,
                                      fit: BoxFit.cover
                                    ),
                                  ),
                                  //Button
                                  (isMe)
                                      ? CameraButton(type: coverPictureKey, id: member.id)
                                      : const Center()
                                ],
                              ),
                              const SizedBox(height: 25)
                            ],
                          ),
                          Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              //ImageCirculaire
                              Avatar(
                                  radius: 75,
                                  url: member.profilePicture
                              ),
                              //Button
                              (isMe)
                                ? CameraButton(type: profilePictureKey, id: member.id)
                                  : const Center()
                            ],
                          )
                        ],
                      ),
                      Text(
                        member.fullName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(member.description),
                      const Divider(),
                      (isMe)
                      ? OutlinedButton(
                          onPressed: () {
                            final page = UpdateProfilePage(member: member);
                            final route = MaterialPageRoute(builder: ((context) => page));
                            Navigator.of(context).push(route);
                          },
                          child: const Text("Modifier le profil")
                      )
                          : const SizedBox(height: 0,)
                      
                      
                    ],
                  );
                }
                return null;
              }
          );
        }
    );
  }
}

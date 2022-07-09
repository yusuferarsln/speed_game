import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speed_game/home.dart';

class LobbiesPage extends StatefulWidget {
  LobbiesPage({Key? key}) : super(key: key);

  @override
  State<LobbiesPage> createState() => _LobbiesPageState();
}

class _LobbiesPageState extends State<LobbiesPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String player2 = "";
  CollectionReference lobbiesRef =
      FirebaseFirestore.instance.collection('Lobbies');

  void createLobby(String player2) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection("Lobbies").doc(auth.currentUser!.uid).set({
      'player1': auth.currentUser!.email,
      'player2': player2,
      'player1ready': false,
      'player2ready': false
    });
  }

  void joinLobby(String lobyID) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore
        .collection("Lobbies")
        .doc(lobyID)
        .update({'player2': auth.currentUser!.email});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    createLobby(player2);
                    Get.to(HomePage(), arguments: auth.currentUser!.uid);
                  },
                  child: Text('Lobi Oluştur')),
              StreamBuilder(
                  stream: lobbiesRef.snapshots(),
                  builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                    if (asyncSnapshot.hasData == false) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      List<DocumentSnapshot> list = asyncSnapshot.data.docs;
                      return list.isEmpty == false
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: ((context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      joinLobby(list[index].id);
                                      Get.to(HomePage(),
                                          arguments: list[index].id);
                                    });
                                  },
                                  child: Container(
                                      color: Colors.red,
                                      height: 100,
                                      width: 200,
                                      child: Text(
                                          'Lobi 1' + '   ' + list[index].id)),
                                );
                              }),
                              itemCount: list.length,
                            )
                          : Text('There is no lobby to play');
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

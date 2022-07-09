import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:speed_game/lobbies.dart';
import 'package:speed_game/providers.dart';

class HomePage extends StatefulWidget {
  final String? lobyId;
  HomePage({Key? key, this.lobyId}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool ready = false;
  bool isGameStarted = false;

  @override
  Widget build(BuildContext context) {
    var data = Get.arguments;
    DocumentReference newPlayer =
        FirebaseFirestore.instance.collection('Lobbies').doc(data);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    void deleteRoom() async {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      await _firestore
          .collection("Lobbies")
          .doc(auth.currentUser!.uid)
          .delete();
    }

    void leaveRoom() async {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      await _firestore.collection("Lobbies").doc(data).update({'player2': ''});
    }

    void readyPlayer1(bool Ready) async {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      Ready == true
          ? await _firestore
              .collection("Lobbies")
              .doc(data)
              .update({'player1ready': true})
          : await _firestore
              .collection("Lobbies")
              .doc(data)
              .update({'player1ready': false});
    }

    void readyPlayer2(bool Ready) async {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      Ready == true
          ? await _firestore
              .collection("Lobbies")
              .doc(data)
              .update({'player2ready': true})
          : await _firestore
              .collection("Lobbies")
              .doc(data)
              .update({'player2ready': false});
    }

    return Material(
      child: SafeArea(
          child: Consumer(
        builder: ((BuildContext context, WidgetRef ref, child) {
          final viewModel = ref.watch(getCards);
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width * 0.9,
                height: height * 0.1,
                color: Colors.green,
                child: StreamBuilder<DocumentSnapshot>(
                    stream: newPlayer.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> asyncSnapshot) {
                      if (asyncSnapshot.hasData == false) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return Center(
                            child: asyncSnapshot.data!['player2'] == ''
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Waiting for Oponnent'),
                                      CircularProgressIndicator(),
                                    ],
                                  )
                                : asyncSnapshot.data!['player2'] ==
                                        asyncSnapshot.data!['player1']
                                    ? Text('Error Please Delete Room')
                                    : Text(asyncSnapshot.data!['player2']));
                      }
                    }),
              ),
              data == auth.currentUser!.uid
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          deleteRoom();

                          Get.to(LobbiesPage());
                          viewModel.deleteList();
                        });
                      },
                      child: Text('Delete Room'))
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          leaveRoom();

                          viewModel.dispose();

                          Get.to(LobbiesPage());
                          viewModel.deleteList();
                        });
                      },
                      child: Text('Leave Room')),
              data == auth.currentUser!.uid
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          readyPlayer1(ready);
                          ready = !ready;
                        });
                      },
                      child: ready == true
                          ? Text(
                              'Ready',
                              style: TextStyle(color: Colors.amber),
                            )
                          : Text(
                              'Ready',
                              style: TextStyle(color: Colors.red),
                            ))
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          readyPlayer2(ready);
                          ready = !ready;
                        });
                      },
                      child: ready == true
                          ? Text(
                              'Ready',
                              style: TextStyle(color: Colors.amber),
                            )
                          : Text(
                              'Ready',
                              style: TextStyle(color: Colors.red),
                            )),
              StreamBuilder<DocumentSnapshot>(
                  stream: newPlayer.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> asyncSnapshot) {
                    if (asyncSnapshot.hasData == false) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return Text(asyncSnapshot.data!['player2']);
                    }
                  }),
              StreamBuilder<DocumentSnapshot>(
                  stream: newPlayer.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> asyncSnapshot) {
                    if (asyncSnapshot.hasData == false) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (asyncSnapshot.data!['player2ready'] &&
                          asyncSnapshot.data!['player1ready'] == true) {
                        viewModel.getDeckId();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  viewModel.getData();
                                });
                              },
                              child: Container(
                                color: Colors.green,
                                height: 100,
                                width: 100,
                                child: Text('Draw a Card'),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Text('Players Not Ready');
                      }
                    }
                  }),
              viewModel.listCardModel!.isEmpty == true
                  ? SizedBox.shrink()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        return Column(
                          children: [
                            Text(viewModel.listCardModel![index]!.suit
                                .toString()),
                            Container(
                              height: height * 0.1,
                              width: width * 0.1,
                              child: Image.network(viewModel
                                  .listCardModel![index]!.images!.png
                                  .toString()),
                            ),
                            Text(viewModel.listCardModel![index]!.value
                                .toString()),
                            Text(viewModel.remaining.toString()),
                          ],
                        );
                      }),
                      itemCount: viewModel.listCardModel!.length,
                    ),
              Container(
                width: width * 0.9,
                height: height * 0.1,
                color: Colors.green,
                child: StreamBuilder<DocumentSnapshot>(
                    stream: newPlayer.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> asyncSnapshot) {
                      if (asyncSnapshot.hasData == false) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return Center(
                            child: Text(asyncSnapshot.data!['player1']));
                      }
                    }),
              ),
            ],
          );
        }),
        child: Container(
          child: Text('sa'),
        ),
      )),
    );
  }
}

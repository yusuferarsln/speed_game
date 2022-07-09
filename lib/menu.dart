import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speed_game/auth/auth_services.dart';
import 'package:speed_game/home.dart';
import 'package:speed_game/lobbies.dart';
import 'package:speed_game/providers.dart';

class Menu extends StatefulWidget {
  Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Column(
        children: [
          Expanded(
              flex: 4,
              child: Container(
                color: Colors.green,
                child: Center(
                  child: Consumer(
                    builder: (BuildContext context, WidgetRef ref, child) {
                      final viewModel = ref.watch(getCards);

                      return ElevatedButton(
                          onPressed: () {
                            // viewModel.getDeckId();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LobbiesPage()),
                            );
                          },
                          child: Text('Start Game'));
                    },
                  ),
                ),
              )),
          Expanded(
              flex: 2,
              child: Container(
                color: Colors.greenAccent,
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      AuthController.instance.logOut();
                    },
                    child: Text('Logout'),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

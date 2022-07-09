import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:speed_game/cardmodel.dart';
import 'package:speed_game/draw_card_model.dart';
import 'package:speed_game/service.dart';

class CardApi extends ChangeNotifier {
  List<DrawCardModelCards?>? listCardModel = [];
  String? deck_id;
  int? remaining;
  void getDeckId() {
    Service.fetch().then((value) {
      if (value != null) {
        deck_id = value.deckId.toString();
        notifyListeners();
      }
    });
  }

  void getData() {
    Service.drawCard(deck_id.toString()).then((value) {
      if (value != null) {
        listCardModel = value.cards;
        remaining = value.remaining;

        notifyListeners();
      }
    });
  }

  void deleteList() {
    listCardModel!.clear();
    notifyListeners();
  }
}

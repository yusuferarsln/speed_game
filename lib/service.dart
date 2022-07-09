import 'dart:convert';

import 'package:speed_game/cardmodel.dart';
import 'package:http/http.dart' as http;
import 'package:speed_game/draw_card_model.dart';

class Service {
  static Future<CardModel?> fetch() async {
    var url = Uri.parse(
        "https://www.deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1");

    var response;
    try {
      response = await http.get(url);
      if (response.statusCode == 200) {
        return CardModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<DrawCardModel?> drawCard(String deck_id) async {
    var url = Uri.parse(
        "https://www.deckofcardsapi.com/api/deck/$deck_id/draw/?count=2");

    var response;
    try {
      response = await http.get(url);
      if (response.statusCode == 200) {
        return DrawCardModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}

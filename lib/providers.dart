import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speed_game/getdata.dart';

final getCards = ChangeNotifierProvider((ref) {
  return CardApi();
});

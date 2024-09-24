import 'package:flutter/material.dart';
import '../models/twat.dart';
import '../widgets/twat_list.dart';

class HomeScreen extends StatelessWidget {
  final List<Twat> twats;
  final Function(String, String?) onNewTwat;
  final Function(String, String) onTwatAction;
  final Future<void> Function() onRefresh;

  const HomeScreen({
    super.key,
    required this.twats,
    required this.onNewTwat,
    required this.onTwatAction,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return TwatList(
        twats: twats, onTwatAction: onTwatAction, onRefresh: onRefresh);
  }
}

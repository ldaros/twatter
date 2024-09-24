import 'package:flutter/material.dart';
import '../models/twat.dart';
import 'twat_card.dart';

class TwatList extends StatelessWidget {
  final List<Twat> twats;
  final Function(String, String) onTwatAction;
  final Future<void> Function() onRefresh;

  const TwatList({
    super.key,
    required this.twats,
    required this.onTwatAction,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (twats.isEmpty) {
      return const Center(
        child: Text(
          'No tweets available.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Center(
        child: SizedBox(
          width: 600, // Set the desired width here
          child: ListView.builder(
            itemCount: twats.length,
            itemBuilder: (context, index) {
              return TwatCard(twat: twats[index], onTwatAction: onTwatAction);
            },
          ),
        ),
      ),
    );
  }
}
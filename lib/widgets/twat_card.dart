import 'package:app2/widgets/full_screen_image.dart';
import 'package:flutter/material.dart';
import '../models/twat.dart';

class TwatCard extends StatelessWidget {
  final Twat twat;
  final Function(String, String) onTwatAction;

  const TwatCard({
    super.key,
    required this.twat,
    required this.onTwatAction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (twat.retweetedFrom != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.repeat, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Retwated by ${twat.username}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            if (twat.replyToHandle != null)
              Text(
                'Replying to ${twat.replyToHandle}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(twat.avatarUrl),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        twat.username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(twat.handle,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              twat.content,
              style: const TextStyle(fontSize: 16.0),
            ),
            if (twat.imageUrl != null) ...[
              const SizedBox(height: 8.0),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          FullScreenImage(imageUrl: twat.imageUrl!),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    twat.imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8.0),
            Text(
              _formatTimestamp(twat.timestamp),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  icon: Icons.reply,
                  count: null,
                  onPressed: () => onTwatAction(twat.id, 'reply'),
                ),
                _buildActionButton(
                  icon: Icons.repeat,
                  count: twat.retwats,
                  onPressed: () => onTwatAction(twat.id, 'retwat'),
                ),
                _buildActionButton(
                  icon: Icons.favorite_border,
                  count: twat.likes,
                  onPressed: () => onTwatAction(twat.id, 'like'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required int? count,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 16),
            if (count != null) ...[
              const SizedBox(width: 4),
              Text(count.toString()),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}

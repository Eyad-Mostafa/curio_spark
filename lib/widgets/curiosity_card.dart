import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../model/curiosity.dart';
import '../constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CuriosityCard extends StatelessWidget {
  final Curiosity curiosity;
  final Function(Curiosity) onCuriosityTapped;
  final Function(Curiosity) onDismissed;

  const CuriosityCard({
    Key? key,
    required this.curiosity,
    required this.onCuriosityTapped,
    required this.onDismissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.redAccent,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        onDismissed(curiosity);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          onTap: () => onCuriosityTapped(curiosity),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          tileColor: Colors.transparent,
          title: Text(
            curiosity.content ?? '',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 15,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  curiosity.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_outline,
                  color: theme.iconTheme.color,
                ),
                const SizedBox(width: 10),
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: theme.iconTheme.color?.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: IconButton(
                    iconSize: 16,
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {
                      Share.share(curiosity.content ?? '');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../model/curiosity.dart';
import '../constants/colors.dart';

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
    return Dismissible(
      key: UniqueKey(), // use Key('someUniqueString') or UniqueKey() safely
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        color: const Color.fromARGB(255, 121, 79, 76),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        // You handle deletion or callback here
        onDismissed(curiosity);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: ListTile(
          onTap: () {
            onCuriosityTapped(curiosity);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          tileColor: Colors.white,
          title: Text(
            curiosity.content ?? '',
            style: TextStyle(
              fontSize: 16,
              color: tdBlack,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                curiosity.isFavorite ? Icons.favorite : Icons.favorite_outline,
                color: const Color.fromARGB(255, 50, 49, 51),
              ),
              const SizedBox(width: 10),
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 53, 50, 50),
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
    );
  }
}

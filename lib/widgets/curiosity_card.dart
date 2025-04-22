import 'package:flutter/material.dart';
import '../model/curiosity.dart';
import '../constants/colors.dart';

class CuriosityCard extends StatelessWidget {
  final Curiosity curiosity;
  final Function(Curiosity) onCuriosityTapped;
  final Function(String) onDeleteCuriosity;

  const CuriosityCard({
    Key? key,
    required this.curiosity,
    required this.onCuriosityTapped,
    required this.onDeleteCuriosity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          onCuriosityTapped(curiosity);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        title: Text(
          curiosity.content ?? '',
          style: const TextStyle(
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
                color: Colors.white,
                iconSize: 16,
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Optional: implement Share.share(curiosity.content ?? '');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

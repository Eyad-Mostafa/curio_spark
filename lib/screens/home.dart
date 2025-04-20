import 'package:flutter/material.dart';
import 'package:curio_spark/screens/fav.dart';
import 'package:curio_spark/screens/sett.dart';
import '../model/curiosity.dart';
import '../constants/colors.dart';
import '../widgets/curiosity_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Curiosity> curiosities = Curiosity.sampleData();
  List<Curiosity> filteredCuriosities = [];

  @override
  void initState() {
    filteredCuriosities = curiosities;
    super.initState();
  }

  void _handleFavoriteToggle(Curiosity curiosity) {
    setState(() {
      curiosity.isFavorite = !curiosity.isFavorite;
    });
  }

  void _deleteCuriosityById(String id) {
    setState(() {
      curiosities.removeWhere((item) => item.id == id);
      filteredCuriosities.removeWhere((item) => item.id == id);
    });
  }

  void _runFilter(String enteredKeyword) {
    List<Curiosity> results = [];

    if (enteredKeyword.isEmpty) {
      results = curiosities;
    } else {
      results = curiosities.where((item) {
        return item.content!
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase());
      }).toList();
    }

    setState(() {
      filteredCuriosities = results;
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.menu, color: tdBlack, size: 30),
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/icon/icon.png'),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: _runFilter,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(Icons.search, color: tdBlack, size: 20),
          prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 50, bottom: 20),
                        child: const Text(
                          'Today\'s Curiosities',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          for (Curiosity curiosity
                              in filteredCuriosities.reversed)
                            CuriosityCard(
                              curiosity: curiosity,
                              onCuriosityTapped: _handleFavoriteToggle,
                              onDeleteCuriosity: _deleteCuriosityById,
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const sett()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    minimumSize: const Size(60, 60),
                    elevation: 5,
                  ),
                  child:
                      const Icon(Icons.settings, color: Colors.black, size: 30),
                ),
                ElevatedButton(
                  onPressed: () {}, // Current screen
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tdBlue,
                    minimumSize: const Size(60, 60),
                    elevation: 10,
                  ),
                  child: const Icon(Icons.home, color: Colors.white, size: 30),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const fav()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    minimumSize: const Size(60, 60),
                    elevation: 5,
                  ),
                  child: const Icon(Icons.favorite,
                      color: Color.fromARGB(255, 121, 118, 118), size: 30),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

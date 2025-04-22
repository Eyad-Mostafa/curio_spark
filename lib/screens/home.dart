import 'package:flutter/material.dart';
import 'package:curio_spark/services/hive/curiosity_hive_service.dart';
import '../model/curiosity.dart';
import '../constants/colors.dart';
import '../widgets/curiosity_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Curiosity> curiosities = [];
  List<Curiosity> filteredCuriosities = [];

  @override
  void initState() {
    super.initState();
    _loadCuriositiesFromHive();
  }

  void _loadCuriositiesFromHive() {
    final loaded = CuriosityHiveService.getAll();
    setState(() {
      curiosities = loaded;
      filteredCuriosities = loaded;
    });
  }

  void _handleFavoriteToggle(Curiosity curiosity) {
    setState(() {
      CuriosityHiveService.toggleFavorite(curiosity.id);
    });
  }

  void _deleteCuriosityById(String id) {
    // CuriosityHiveService.deleteCuriosity(id);
    setState(() {
      curiosities.removeWhere((item) => item.id == id);
      filteredCuriosities.removeWhere((item) => item.id == id);
    });
  }

  void _runFilter(String enteredKeyword) {
    List<Curiosity> results;
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
                          'Your Curiosities',
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
          Positioned(
            bottom: 18,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: tdBGColor,
              onPressed: () {
                // Define FAB action here
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:curio_spark/constants/colors.dart';
import 'package:curio_spark/model/curiosity.dart';
import 'package:curio_spark/services/hive/curiosity_hive_service.dart';
import 'package:curio_spark/widgets/curiosity_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Curiosity> filteredCuriosities = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_runFilter);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _runFilter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredCuriosities = query.isEmpty
          ? CuriosityHiveService.getAll()
          : CuriosityHiveService.getAll()
              .where((item) => item.content!.toLowerCase().contains(query))
              .toList();
    });
  }

  void _handleFavoriteToggle(Curiosity curiosity) {
    CuriosityHiveService.toggleFavorite(curiosity.id);
  }

  void _showAddCuriosityDialog(BuildContext context) {
    final contentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Curiosity'),
        content: TextField(
          controller: contentController,
          decoration: const InputDecoration(hintText: "Enter your curiosity"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (contentController.text.isNotEmpty) {
                final newCuriosity = Curiosity(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  content: contentController.text,
                  isFavorite: false,
                );
                CuriosityHiveService.addCuriosity(newCuriosity);
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
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
        controller: _searchController,
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
      body: StreamBuilder<List<Curiosity>>(
        stream: CuriosityHiveService.curiositiesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final curiosities = snapshot.data!;
            if (_searchController.text.isNotEmpty) {
              filteredCuriosities = curiosities
                  .where((item) => item.content!
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()))
                  .toList();
            } else {
              filteredCuriosities = curiosities;
            }

            return Stack(
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
                                for (Curiosity curiosity in filteredCuriosities.reversed)
                                  CuriosityCard(
                                    curiosity: curiosity,
                                    onCuriosityTapped: _handleFavoriteToggle,
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
                    onPressed: () => _showAddCuriosityDialog(context),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
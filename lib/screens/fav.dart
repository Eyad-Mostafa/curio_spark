import 'package:curio_spark/model/curiosity.dart';
import 'package:curio_spark/services/hive/curiosity_hive_service.dart';
import 'package:flutter/material.dart';
import '../widgets/curiosity_card.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
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
    setState(() {});
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/icon/better.png'),
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
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _searchController,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          prefixIcon: Icon(Icons.search, color: Theme.of(context).iconTheme.color, size: 20),
          prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: StreamBuilder<List<Curiosity>>(
        stream: CuriosityHiveService.curiositiesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final filtered = snapshot.data!
              .where((c) => c.isFavorite)
              .where((c) =>
                  _searchController.text.isEmpty ||
                  (c.content?.toLowerCase().contains(
                            _searchController.text.toLowerCase(),
                          ) ??
                      false))
              .toList();

          if (filtered.isEmpty) {
            final isEmptySearch = _searchController.text.isEmpty;
            return Column(
              children: [
                searchBox(),
                Expanded(
                  child: Center(
                    child: Text(
                      isEmptySearch
                          ? 'No favorites yet'
                          : 'No matching favorites',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            );
          }

          return Stack(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    searchBox(),
                    Expanded(
                      child: ListView(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 50, bottom: 20),
                            child: const Text(
                              'Favorites',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              for (Curiosity curiosity in filtered.reversed)
                                CuriosityCard(
                                  curiosity: curiosity,
                                  onCuriosityTapped: (curio) =>
                                      CuriosityHiveService.toggleFavorite(
                                          curio.id),
                                  onDismissed: (Curiosity) =>
                                    CuriosityHiveService.deleteCuriosity(Curiosity.id),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

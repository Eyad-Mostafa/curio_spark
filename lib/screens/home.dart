import 'package:curio_spark/constants/colors.dart';
import 'package:curio_spark/model/curiosity.dart';
import 'package:curio_spark/services/hive/curiosity_hive_service.dart';
import 'package:curio_spark/widgets/curiosity_card.dart';
import 'package:flutter/material.dart';
import 'package:curio_spark/services/gemini_service.dart';
import 'package:curio_spark/widgets/speech_input.dart';
import 'package:hive_flutter/hive_flutter.dart'; // for Hive.box()

final speechInputKey = GlobalKey<SpeechInputState>();

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
    // 1) Initialize the Hive service so the stream emits its first value
    CuriosityHiveService.init();
    // 2) Seed the filtered list with whatever is already in the box
    filteredCuriosities = CuriosityHiveService.getAll();
    // 3) Listen to search field changes
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
      final all = CuriosityHiveService.getAll();
      filteredCuriosities = query.isEmpty
          ? all
          : all.where((c) => c.content!.toLowerCase().contains(query)).toList();
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: contentController,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(hintText: "Enter your curiosity"),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            SpeechInput(
              key: speechInputKey,
              onResult: (text) {
                contentController.text = text;
                contentController.selection = TextSelection.fromPosition(
                  TextPosition(offset: text.length),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              speechInputKey.currentState?.stopListening();
              Navigator.pop(context);
            },
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
                speechInputKey.currentState?.stopListening();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Curiosity added!")),
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
          ElevatedButton(
            onPressed: () async {
              // Fetch the box and pass it to your generator
              final box = Hive.box<Curiosity>('curiosities');
              final success = await CuriosityGeneratorService
                  .generateAndSaveUniqueCuriosity(box);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? "✅ New curiosity added!"
                        : "⚠️ Could not fetch a new curiosity.",
                  ),
                ),
              );
            },
            child: const Text("Get AI Curiosity"),
          ),
        ],
      ),
    );
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
          prefixIcon: Icon(Icons.search,
              color: Theme.of(context).iconTheme.color, size: 20),
          prefixIconConstraints:
              const BoxConstraints(maxHeight: 20, minWidth: 25),
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
          if (snapshot.hasData) {
            final curiosities = snapshot.data!;
            // Always update filteredCuriosities if search is empty
            if (_searchController.text.isEmpty) {
              filteredCuriosities = curiosities.toList();
            }
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 15),
                  child: Column(
                    children: [
                      searchBox(),
                      Expanded(
                        child: ListView(
                          children: [
                            const SizedBox(height: 50),
                            const Text(
                              'Your Curiosities',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            for (var c in filteredCuriosities.reversed)
                              CuriosityCard(
                                curiosity: c,
                                onCuriosityTapped: _handleFavoriteToggle,
                                onDismissed: (_) =>
                                    CuriosityHiveService.deleteCuriosity(c.id),
                              ),
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

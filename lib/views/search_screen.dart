import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restau/models/firestore_service.dart';
import 'package:restau/models/restaurant.dart';
import 'package:restau/widgets/restaurant_card/restaurant_list.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final searchQuery = _searchController.text;
      // Perform search logic here
      print('Search query: $searchQuery');
    });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          print('onStatus: $val');
          if (val == 'notListening') {
            setState(() => _isListening = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Center(
                  child: Text(
                    'Stopped listening',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                backgroundColor: Color(0xE6FFEEAD),
              ),
            );
          }
        },
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _searchController.text = val.recognizedWords;
            _onSearchChanged();
          }),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text(
                'Listening...',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            backgroundColor: Color(0xE6FFEEAD),
          ),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stopped listening')),
      );
    }
  }

  // Function to cast restaurant data to List<Restaurant>
  List<Restaurant> castToRestaurantList(
      List<Map<String, dynamic>> snapshotData) {
    return snapshotData.map((restaurantData) {
      return Restaurant(
        averageRating: restaurantData['averageRating'],
        categories: List<String>.from(restaurantData['categories']),
        imageUrl: restaurantData['imageUrl'],
        latitude: restaurantData['latitude'],
        longitude: restaurantData['longitude'],
        name: restaurantData['name'],
        openingDate: restaurantData['openingDate'],
        placeName: restaurantData['placeName'],
        schedule:
            Map<String, Map<String, dynamic>>.from(restaurantData['schedule']),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          firestoreService.getAllRestaurants(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          } else {
            final restaurants = snapshot.data![0] as List<Map<String, dynamic>>;
            final registeredRestaurants = castToRestaurantList(restaurants);
            return Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (text) => _onSearchChanged(),
                  decoration: InputDecoration(
                    labelText: 'Search for restaurants',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 15, 14, 14)),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                      onPressed: _listen,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: RestaurantList(restaurants: registeredRestaurants),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

import 'dart:async';
import 'package:restau/models/restaurant.dart';
import 'package:restau/models/restaurant_repository.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';

class SearchViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final RestaurantRepository restaurantRepository = RestaurantRepository();
  Timer? _debounce;
  bool _isListening = false;
  late stt.SpeechToText _speech;
  List<Restaurant> _filteredRestaurants = [];
  List<Restaurant> _allRestaurants = [];
  String searchQuery = '';
  List<Restaurant> get filteredRestaurants => _filteredRestaurants;
  bool get isListening => _isListening;
  List<Restaurant> _lastSearchResults = [];
  String get lastSearchQuery => searchQuery;

  bool _showRecentSearches = false;

  bool get showRecentSearches => _showRecentSearches;

  SearchViewModel() {
    _speech = stt.SpeechToText();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    List<Restaurant> restaurants =
        await restaurantRepository.getAllRestaurants();
    _allRestaurants = restaurants;
    notifyListeners();
  }

  void onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchQuery = searchController.text;
      _filterRestaurants();
    });
  }

  void onSearchSubmitted(String value) {
    searchQuery = value;
    _filterRestaurants();

    notifyListeners();
  }

  void _filterRestaurants() {
    if (searchQuery.isEmpty) {
      _filteredRestaurants = _lastSearchResults;
      _showRecentSearches = true;
    } else {
      _filteredRestaurants = _allRestaurants.where((restaurant) {
        final nameMatches = restaurant.name
            .toLowerCase()
            .contains(searchQuery.toLowerCase().trim());
        final categoryMatches = restaurant.categories.any((category) =>
            category.toLowerCase().contains(searchQuery.toLowerCase().trim()));
        return nameMatches || categoryMatches;
      }).toList();
      _lastSearchResults = _filteredRestaurants;
    }

    notifyListeners();
  }

  List<Restaurant> getLastSearchResults() {
    return _lastSearchResults;
  }

  void clearLastSearchResults() {
    _lastSearchResults = [];
    _showRecentSearches = false;
    notifyListeners();
  }

  void listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
          onStatus: (val) {
            if (val == 'notListening') {
              _isListening = false;
              notifyListeners();
            }
          },
          onError: (val) => print('onError: $val'));

      if (available) {
        _isListening = true;
        _speech.listen(
          onResult: (val) {
            searchController.text = val.recognizedWords;
            onSearchChanged();
          },
        );
        notifyListeners();
      }
    } else {
      _isListening = false;
      _speech.stop();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }
}

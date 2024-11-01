import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restau/search/search_viewmodel.dart';
import 'package:restau/widgets/restaurant_card/restaurant_list.dart';
import 'package:restau/widgets/search_bar.dart' as custom;

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchViewModel(),
      child: Scaffold(
        body: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final viewModel = Provider.of<SearchViewModel>(context);
                return custom.SearchBar(
                  controller: viewModel.searchController,
                  onChanged: (text) => viewModel.onSearchChanged(),
                  onSubmitted: viewModel.onSearchSubmitted,
                  isListening: viewModel.isListening,
                  onMicPressed: viewModel.listen,
                );
              },
            ),
            const SizedBox(height: 10),
            // Mostrar el label 'Recents' si hay búsquedas recientes
            Consumer<SearchViewModel>(
              builder: (context, viewModel, child) {
                return Visibility(
                  visible: viewModel.showRecentSearches,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Recents',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: const Color(0xFFD9534F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            viewModel.clearLastSearchResults();
                          },
                          child: const Text(
                            'Clear Recents',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: Consumer<SearchViewModel>(
                builder: (context, viewModel, child) {
                  return RestaurantList(
                    restaurants: viewModel.filteredRestaurants,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

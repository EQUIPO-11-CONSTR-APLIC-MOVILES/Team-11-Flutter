import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restau/models/menu_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MenuItemsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<MenuItem>> fetchMenuItems() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('menu_items').get();
      List<MenuItem> menuItems = snapshot.docs.map((doc) {
        return MenuItem(
          description: doc['description'],
          imageUrl: doc['imageUrl'],
          name: doc['name'],
          price: doc['price'],
          restaurantId: doc['restaurantId'],
        );
      }).toList();
      await _saveToCache(menuItems);
      return menuItems;
    } catch (e) {
      throw Exception('Error fetching menu items: $e');
    }
  }

  Future<List<MenuItem>> fetchMenuItemsByRestaurantId(
      String restaurantId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('menu_items')
          .where('restaurantId', isEqualTo: restaurantId)
          .get();
      List<MenuItem> menuItems = snapshot.docs.map((doc) {
        return MenuItem(
          description: doc['description'],
          imageUrl: doc['imageUrl'],
          name: doc['name'],
          price: doc['price'],
          restaurantId: doc['restaurantId'],
        );
      }).toList();
      await _saveToCache(menuItems, restaurantId);
      return menuItems;
    } catch (e) {
      throw Exception(
          'Error fetching menu items for restaurant $restaurantId: $e');
    }
  }

  Future<void> _saveToCache(List<MenuItem> menuItems,
      [String? restaurantId]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key =
        restaurantId != null ? 'menu_items_$restaurantId' : 'menu_items';
    String jsonData =
        jsonEncode(menuItems.map((item) => item.toJson()).toList());
    await prefs.setString(key, jsonData);
  }

  Future<List<MenuItem>> getCachedMenuItems(String restaurantId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = 'menu_items_$restaurantId';
    String? jsonData = prefs.getString(key);
    if (jsonData != null) {
      List<dynamic> data = jsonDecode(jsonData);
      return data.map((item) => MenuItem.fromJson(item)).toList();
    }
    return [];
  }
}

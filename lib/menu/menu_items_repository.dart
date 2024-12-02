import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restau/models/menu_item.dart';

class MenuItemsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<MenuItem>> fetchMenuItems() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('menu_items').get();
      return snapshot.docs.map((doc) {
        return MenuItem(
          description: doc['description'],
          imageUrl: doc['imageUrl'],
          name: doc['name'],
          price: doc['price'],
          restaurantId: doc['restaurantId'],
        );
      }).toList();
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
      return snapshot.docs.map((doc) {
        return MenuItem(
          description: doc['description'],
          imageUrl: doc['imageUrl'],
          name: doc['name'],
          price: doc['price'],
          restaurantId: doc['restaurantId'],
        );
      }).toList();
    } catch (e) {
      throw Exception(
          'Error fetching menu items for restaurant $restaurantId: $e');
    }
  }
}

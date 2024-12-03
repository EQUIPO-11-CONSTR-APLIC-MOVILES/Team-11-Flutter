class MenuItem {
  final String description;
  final String imageUrl;
  final String name;
  final int price;
  final String restaurantId;

  MenuItem({
    required this.description,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.restaurantId,
  });

  // Convert a MenuItem into a Map. The keys must correspond to the names of the
  // fields in the Firestore document.
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
      'restaurantId': restaurantId,
    };
  }

  // Create a MenuItem from a Map. The keys must correspond to the names of the
  // fields in the Firestore document.
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      description: json['description'],
      imageUrl: json['imageUrl'],
      name: json['name'],
      price: json['price'],
      restaurantId: json['restaurantId'],
    );
  }
}

class MenuItem {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  // Convert from Firestore document
  factory MenuItem.fromFirestore(Map<String, dynamic> data, String documentId) {
    return MenuItem(
      id: documentId,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
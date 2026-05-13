import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item.dart';

class FirestoreService {
  final CollectionReference _menuCollection =
  FirebaseFirestore.instance.collection('menu');
  final CollectionReference _ordersCollection =
  FirebaseFirestore.instance.collection('orders');

  Stream<List<MenuItem>> getMenuItems() {
    return _menuCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return MenuItem.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> placeOrder(List<MenuItem> cartItems, String userId) async {
    final orderItems = cartItems.map((item) => {
      'id': item.id,
      'name': item.name,
      'price': item.price,
    }).toList();

    final total = cartItems.fold(0.0, (sum, item) => sum + item.price);

    await _ordersCollection.add({
      'items': orderItems,
      'total': total,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'pending',
    });
  }
}
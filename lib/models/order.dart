import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final List<Map<String, dynamic>> items; // list of {name, price, quantity?}
  final double total;
  final DateTime timestamp;
  final String status;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.timestamp,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'items': items,
      'total': total,
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status,
    };
  }

  factory Order.fromMap(String id, Map<String, dynamic> data) {
    return Order(
      id: id,
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
      total: (data['total'] ?? 0.0).toDouble(),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      status: data['status'] ?? 'pending',
    );
  }
}
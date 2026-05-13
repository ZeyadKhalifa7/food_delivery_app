import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/cart_service.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final firestoreService = FirestoreService();
    final authService = Provider.of<AuthService>(context);
    final userId = authService.currentUserId;

    // Group items by ID to show quantity
    final Map<String, int> quantityMap = {};
    for (var item in cartService.items) {
      quantityMap[item.id] = (quantityMap[item.id] ?? 0) + 1;
    }
    final uniqueItems = quantityMap.keys.map((id) {
      return cartService.items.firstWhere((item) => item.id == id);
    }).toList();

    Future<void> placeOrder() async {
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to place order')),
        );
        return;
      }
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      try {
        await firestoreService.placeOrder(cartService.items, userId);
        cartService.clearCart();
        if (context.mounted) {
          Navigator.pop(context); // close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order placed!'), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Order Failed'),
              content: Text('Error: $e\n\nCheck Firestore rules and connectivity.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        print('Order error: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: cartService.items.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: uniqueItems.length,
              itemBuilder: (context, index) {
                final item = uniqueItems[index];
                final quantity = quantityMap[item.id]!;
                return CartItemTile(
                  item: item,
                  quantity: quantity,
                  onRemove: () => cartService.removeOne(item),
                  onAdd: () => cartService.addItem(item),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(
                      NumberFormat.currency(locale: 'en_US', symbol: '\$').format(cartService.totalPrice),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFF6B35)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: placeOrder,
                    child: const Text('Place Order'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
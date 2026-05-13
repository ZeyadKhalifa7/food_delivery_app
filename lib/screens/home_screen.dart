import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../services/cart_service.dart';
import '../models/menu_item.dart';
import '../widgets/food_card_grid.dart';
import '../screens/item_detail_screen.dart';
import '../main.dart'; // for mainWrapperKey

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('What would you like?'),
        actions: [
          Consumer<CartService>(
            builder: (context, cart, _) => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    // Switch to cart tab using the global key
                    mainWrapperKey.currentState?.setIndex(1);
                  },
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6B35),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        cart.itemCount.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<MenuItem>>(
        stream: firestoreService.getMenuItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data;
          if (items == null || items.isEmpty) {
            return const Center(child: Text('No items yet.'));
          }
          return Padding(
            padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return FoodCardGrid(
                  item: items[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ItemDetailScreen(item: items[index]),
                      ),
                    );
                  },
                  onAddToCart: () {
                    Provider.of<CartService>(context, listen: false).addItem(items[index]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${items[index].name} added to cart'),
                        backgroundColor: const Color(0xFFFF6B35),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
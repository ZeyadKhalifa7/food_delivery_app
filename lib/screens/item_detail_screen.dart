import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/menu_item.dart';
import '../services/cart_service.dart';

class ItemDetailScreen extends StatelessWidget {
  final MenuItem item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: null, // no title, avoid overlap
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Hero image
          Hero(
            tag: item.id,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              child: item.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: item.imageUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(height: 300, color: Colors.grey.shade200),
                errorWidget: (_, __, ___) => Container(
                  height: 300,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.fastfood, size: 80),
                ),
              )
                  : Container(
                height: 300,
                color: Colors.grey.shade200,
                child: const Icon(Icons.fastfood, size: 80),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 24, color: Color(0xFFFF6B35), fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.description.isNotEmpty ? item.description : 'Delicious meal prepared with fresh ingredients.',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<CartService>(context, listen: false).addItem(item);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to cart'),
                            backgroundColor: Color(0xFFFF6B35),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('Add to Cart', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
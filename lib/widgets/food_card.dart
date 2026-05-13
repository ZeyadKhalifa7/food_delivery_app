import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/menu_item.dart';

class FoodCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onAddToCart;

  const FoodCard({super.key, required this.item, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Column(
          children: [
            // Image section with placeholder
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: item.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: item.imageUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 140,
                  color: Colors.grey.shade200,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 140,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                ),
              )
                  : Container(
                height: 140,
                color: Colors.grey.shade200,
                child: const Icon(Icons.fastfood, size: 50, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description.isNotEmpty
                              ? item.description
                              : 'Delicious meal',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onAddToCart,
                    icon: const Icon(Icons.add_shopping_cart, size: 28),
                    color: const Color(0xFFFF6B35),
                    splashRadius: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }
}
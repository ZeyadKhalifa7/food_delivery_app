import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/menu_item.dart';

class CartItemTile extends StatelessWidget {
  final MenuItem item;
  final int quantity;
  final VoidCallback onRemove;
  final VoidCallback onAdd;

  const CartItemTile({
    super.key,
    required this.item,
    required this.quantity,
    required this.onRemove,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image section (now uses real image if available)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: item.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.fastfood, color: Colors.grey),
                  ),
                )
                    : Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.fastfood, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(color: Color(0xFFFF6B35)),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: onRemove,
                    color: Colors.grey.shade700,
                  ),
                  Text(
                    quantity.toString(),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: onAdd,
                    color: const Color(0xFFFF6B35),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
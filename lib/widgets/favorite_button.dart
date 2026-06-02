import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // return IconButton(
    //   onPressed: onTap,
    //   icon: Icon(
    //     isFavorite ? Icons.favorite : Icons.favorite_border,
    //     color: isFavorite
    //         ? const Color.fromARGB(255, 204, 36, 36)
    //         : Colors.grey,
    //   ),
    // );
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFavorite
                ? const Color.fromARGB(255, 3, 3, 3).withAlpha(12)
                : Colors.grey.withAlpha(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AnimatedScale(
            scale: isFavorite ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 250),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              size: 24,
              color: isFavorite ? const Color.fromARGB(255, 0, 0, 0) : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}

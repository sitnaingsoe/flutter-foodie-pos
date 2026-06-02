import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/providers/category_provider.dart';
import 'package:test_1/providers/product_provider.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryProvider.categories.length,
        itemBuilder: (context, index) {
          final category = categoryProvider.categories[index];

          final isSelected = categoryProvider.selectedCategory == category.slug;

          return GestureDetector(
            onTap: () {
              context.read<ProductProvider>().setCategory(category.slug);
              context.read<CategoryProvider>().selectCategory(category.slug);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1C1C1C)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1C1C1C)
                      : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: Text(
                  category.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

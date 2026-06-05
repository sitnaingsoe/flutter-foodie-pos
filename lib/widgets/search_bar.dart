import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/providers/product_provider.dart';

class ProductSearchBar extends StatefulWidget {
  final TextEditingController controller;
  const ProductSearchBar({super.key, required this.controller});

  @override
  State<ProductSearchBar> createState() => _ProductSearchBarState();
}

class _ProductSearchBarState extends State<ProductSearchBar> {
  final FocusNode _focusNode = FocusNode();

  late ProductProvider _productProvider;

  @override
  void initState() {
    super.initState();

    _productProvider = context.read<ProductProvider>();

    widget.controller.addListener(() {
      setState(() {}); // Refresh clear button visibility
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = context.watch<ProductProvider>().isSearching;

    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      onChanged: (value) {
        _productProvider.searchProducts(value);
      },
      decoration: InputDecoration(
        hintText: "Search products with name...",
        prefixIcon: const Icon(Icons.search),

        suffixIcon: isSearching
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : (widget.controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        widget.controller.clear();
                        _focusNode.unfocus();
                        _productProvider.clearSearch();
                      },
                    )
                  : null),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

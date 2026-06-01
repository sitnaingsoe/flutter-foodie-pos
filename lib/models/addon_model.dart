class AddonCategory {
  final String title;
  final bool isRequired;
  final List<AddonItem> items;

  AddonCategory({
    required this.title,
    required this.isRequired,
    required this.items,
  });
}

class AddonItem {
  final String name;
  final double price;

  bool selected;

  AddonItem({required this.name, required this.price, this.selected = false});
}

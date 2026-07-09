import 'package:flutter/material.dart';

const Color _teal = Color(0xFF15919B);
const Color _orange = Color(0xFFF7941D);

// NOTE: UI matches Figma design with static placeholder data.
// Replace the lists below with data fetched from Firestore
// (categories/products collections) in the Backend Integration step.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  int _selectedNav = 0;

  final List<String> _tabs = [
    'Recommend',
    'Cell Phone',
    'Car Products',
    'Department Store',
    'Computer',
  ];

  // 4 x 2 category grid, matching the Figma layout.
  final List<Map<String, dynamic>> _categories = [
    {'image': 'assets/Product_Icon.png', 'icon': Icons.spa_outlined, 'label': 'Beauty'},
    {'image': 'assets/image_6.png', 'icon': Icons.local_cafe_outlined, 'label': 'Coffee'},
    {'image': 'assets/image_7.png', 'icon': null, 'label': 'Fashion'},
    {'image': 'assets/image 7 (2).png', 'icon': null, 'label': 'Home'},
    {'image': 'assets/image_8.png', 'icon': null, 'label': 'Shirt'},
    {'image': 'assets/image 7 (1).png', 'icon': null, 'label': 'Women Bag'},
    {'image': 'assets/image 7 (2).png', 'icon': Icons.hiking_outlined, 'label': 'Shoes'},
    {'image': 'assets/image 7 (1).png', 'icon': Icons.watch_outlined, 'label': 'Watches'},
  ];

  // TODO: Replace with Firestore product documents
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Multi Kit',
      'price': '\$500',
      'rating': 4.5,
      'reviews': 88,
      'image': 'assets/Product_Icon.png',
    },
    {
      'name': 'Lipstick',
      'price': '\$400',
      'rating': 4.5,
      'reviews': 98,
      'image': 'assets/image_5.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Top bar
            Row(
              children: [
                const Icon(Icons.menu, color: Colors.black87),
                const Spacer(),
                Image.asset('assets/logo.png', height: 28),
                const Spacer(),
                const Icon(Icons.search, color: Colors.black87),
                const SizedBox(width: 16),
                // FIX: design shows a scan/frame icon here, not a cart icon.
                const Icon(Icons.crop_free, color: Colors.black87),
              ],
            ),
            const SizedBox(height: 20),

            // Greeting
            Text(
              'Hi, Andrea',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            const Text(
              'What are you looking for today?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Promo banner (single exported image from Figma)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/Group_1171274903.png',
                width: double.infinity,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(4, (i) {
                  final active = i == 0;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active ? _orange : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),

            // Category tabs
            SizedBox(
              height: 30,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 20),
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedTab;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTab = index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _tabs[index],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.black87 : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (isSelected)
                          Container(height: 2, width: 20, color: _teal),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Category grid — 4 columns x 2 rows, matching Figma
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: _teal.withOpacity(0.08),
                      child: cat['image'] != null
                          ? ClipOval(
                              child: Image.asset(
                                cat['image'] as String,
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(cat['icon'] as IconData, color: _teal),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat['label'] as String,
                      style: const TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Product grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, index) {
                return _ProductCard(product: _products[index]);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNav,
        onTap: (i) => setState(() => _selectedNav = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _orange,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Message'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.asset(
                  product['image'] as String,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.favorite_border, size: 18, color: Colors.grey.shade400),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] as String,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),

                // FIX: price + Add button in the same row, space-between,
                // matching the Figma layout (this row was missing before).
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product['price'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _teal,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 13, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 13, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(
                      '${product['rating']} (${product['reviews']} Reviews)',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
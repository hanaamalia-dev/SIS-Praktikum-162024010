import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/drink.dart';
import 'cart_page.dart';
import 'home_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // state tab yang aktif
  int _selectedIndex = 0;

  // state global keranjang
  final List<CartItem> _cartItems = [];

  // data minuman statis (pengganti database)
  final List<Drink> _drinkList = const [
    Drink(id: 'd1', name: 'Espresso', price: 18000, imageUrl: 'assets/espresso.png'),
    Drink(id: 'd2', name: 'Americano', price: 20000, imageUrl: 'assets/americano.png'),
    Drink(id: 'd3', name: 'Matcha Latte', price: 25000, imageUrl: 'assets/matcha_latte.png'),
    Drink(id: 'd4', name: 'Chocolate Frappe', price: 28000, imageUrl: 'assets/chocolate_frappe.png'),
  ];

  void _addToCart(Drink drink, int quantity) {
    final index = _cartItems.indexWhere((item) => item.drink.id == drink.id);
    setState(() {
      if (index != -1) {
        // sudah ada di keranjang, tambahkan jumlahnya
        _cartItems[index].quantity += quantity;
      } else {
        // belum ada, tambahkan sebagai item baru
        _cartItems.add(CartItem(drink: drink, quantity: quantity));
      }
    });
  }

  void _removeFromCart(String drinkId) {
    setState(() {
      _cartItems.removeWhere((item) => item.drink.id == drinkId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(drinkList: _drinkList, onAddToCart: _addToCart),
      CartPage(cartItems: _cartItems, onRemoveFromCart: _removeFromCart),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_selectedIndex == 0 ? 'Warung IS - Menu' : 'Keranjang Anda'),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_cafe),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('${_cartItems.length}'),
              isLabelVisible: _cartItems.isNotEmpty,
              child: Icon(Icons.shopping_cart),
            ),
            label: 'Keranjang',
          ),
        ],
      ),
    );
  }
}
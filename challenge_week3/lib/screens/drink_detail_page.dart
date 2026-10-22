import 'package:flutter/material.dart';
import '../models/drink.dart';

class DrinkDetailPage extends StatefulWidget {
  final Drink drink;
  final void Function(Drink, int) onAddToCart;

  const DrinkDetailPage({
    super.key,
    required this.drink,
    required this.onAddToCart,
  });

  @override
  _DrinkDetailPageState createState() => _DrinkDetailPageState();
}

class _DrinkDetailPageState extends State<DrinkDetailPage> {
  int _quantity = 1;

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _showAddedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Berhasil Ditambahkan'),
          content: Text(
              'Anda telah menambahkan ${widget.drink.name} ($_quantity) ke keranjang.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.drink.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      widget.drink.imageUrl,
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.local_cafe, size: 60, color: Colors.brown),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.drink.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Harga: Rp ${widget.drink.price}',
                      style: TextStyle(color: Colors.green[700]),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text('Jumlah:', style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _decrement,
                  icon: Icon(Icons.remove_circle, color: Colors.red, size: 32),
                ),
                Text(
                  '$_quantity',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: _increment,
                  icon: Icon(Icons.add_circle, color: Colors.green, size: 32),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.onAddToCart(widget.drink, _quantity);
                _showAddedDialog();
              },
              child: Text('Tambah ke Keranjang'),
            ),
          ],
        ),
      ),
    );
  }
}
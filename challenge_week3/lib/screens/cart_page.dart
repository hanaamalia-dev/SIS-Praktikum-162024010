import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final void Function(String) onRemoveFromCart;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onRemoveFromCart,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // key untuk mengontrol form, dan controller untuk menyimpan input
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _mejaController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _mejaController.dispose();
    super.dispose();
  }

  int get _totalPrice {
    return widget.cartItems.fold(
      0,
      (sum, item) => sum + (item.drink.price * item.quantity),
    );
  }

  void _checkout() {
    // dialog hanya muncul kalau semua validator mengembalikan null
    if (_formKey.currentState!.validate()) {
      _showCheckoutDialog();
    }
  }

  void _showCheckoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Checkout Berhasil'),
          content: Text(
              'Terima kasih, ${_namaController.text.trim()}. Pesanan untuk Meja ${_mejaController.text.trim()} berhasil dengan total belanja: Rp $_totalPrice'),
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
    // keranjang kosong: form tidak ditampilkan
    if (widget.cartItems.isEmpty) {
      return Center(
        child: Text(
          'Keranjang Anda kosong.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // daftar item di keranjang
          ...widget.cartItems.map((item) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  item.drink.imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.local_cafe, size: 40),
                ),
              ),
              title: Text(item.drink.name),
              subtitle: Text('${item.quantity} x Rp ${item.drink.price}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Rp ${item.drink.price * item.quantity}'),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => widget.onRemoveFromCart(item.drink.id),
                  ),
                ],
              ),
            );
          }),

          // form data pemesan + total + tombol checkout
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Nama Pemesan
                  TextFormField(
                    controller: _namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama Pemesan',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama Pemesan tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Nomor Meja
                  TextFormField(
                    controller: _mejaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Nomor Meja',
                      hintText: 'contoh: 5',
                      prefixIcon: Icon(Icons.table_restaurant),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nomor Meja tidak boleh kosong';
                      }
                      final meja = int.tryParse(value.trim());
                      if (meja == null) {
                        return 'Nomor Meja harus berupa angka';
                      }
                      if (meja < 1 || meja > 20) {
                        return 'Nomor Meja harus antara 1-20';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total:', style: TextStyle(fontSize: 16)),
                      Text(
                        'Rp $_totalPrice',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _checkout,
                      child: Text('Checkout'),
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
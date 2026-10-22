import 'package:flutter/material.dart';
import '../models/drink.dart';
import 'drink_detail_page.dart';

class HomePage extends StatefulWidget {
  final List<Drink> drinkList;
  final void Function(Drink, int) onAddToCart;

  const HomePage({
    super.key,
    required this.drinkList,
    required this.onAddToCart,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    final filteredDrinks = widget.drinkList
        .where((drink) => drink.name.toLowerCase().contains(searchText))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              labelText: 'Cari Minuman',
            ),
            onChanged: (value) {
              setState(() {
                searchText = value.toLowerCase();
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: filteredDrinks.length,
            itemBuilder: (context, index) {
              final drink = filteredDrinks[index];
              return Container(
                padding: EdgeInsets.all(4.0),
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      drink.imageUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.local_cafe, size: 40),
                    ),
                  ),
                  title: Text(
                    drink.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Rp ${drink.price}',
                    style: TextStyle(color: Colors.green[700]),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DrinkDetailPage(
                                drink: drink,
                                onAddToCart: widget.onAddToCart,
                              ),
                            ),
                          );
                        },
                        child: Text('Detail'),
                      ),
                      SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: () {
                          // pesan cepat: tambah 1 ke keranjang
                          widget.onAddToCart(drink, 1);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${drink.name} telah ditambahkan ke keranjang.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text('Pesan'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
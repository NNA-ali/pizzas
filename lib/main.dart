// ignore_for_file: library_private_types_in_public_api

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pizzas/pizza.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PizzaListPage(),
    );
  }
}

class PizzaListPage extends StatefulWidget {
  const PizzaListPage({super.key});

  @override
  
  _PizzaListPageState createState() => _PizzaListPageState();
}

class _PizzaListPageState extends State<PizzaListPage> {
  late Future<List<Pizza>> _pizzasFuture;

  @override
  void initState() {
    super.initState();
    _pizzasFuture = _getPizzasFromAPI();
  }

 Future<List<Pizza>> _getPizzasFromAPI() async {
  try {
    final Response response =
        await Dio().get("https://pizzas.shrp.dev/items/pizzas");

    if (response.statusCode == 200 && response.data != null) {
      final List<Pizza> pizzas = (response.data["data"] as List)
          .map((pizzaJson) => Pizza.fromJson(pizzaJson))
          .toList();

      return pizzas;
    } else {
      throw Exception("API response is null or invalid");
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    throw Exception("Can't get pizzas from API");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pizzas"),
      ),
      body: FutureBuilder<List<Pizza>>(
        future: _pizzasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            if (kDebugMode) {
              print(snapshot.error);
            }
            return const Center(child: Text("Error"));
          } else {
            final List<Pizza> pizzas = snapshot.data!;

            return ListView.builder(
              itemCount: pizzas.length,
              itemBuilder: (BuildContext context, int index) {
                final Pizza pizza = pizzas[index];

                return ListTile(
                  leading: Image.network("https://pizzas.shrp.dev/assets/${pizza.image}"),
                  title: Text(pizza.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PizzaDetailPage(pizza: pizza),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class PizzaDetailPage extends StatelessWidget {
  final Pizza pizza;

  const PizzaDetailPage({super.key, required this.pizza});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pizza.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${pizza.name}'),
            Text('Price: \$${pizza.price.toStringAsFixed(2)}'),
            Text('Ingredients: ${pizza.ingredients.join(", ")}'),
            Image.network("https://pizzas.shrp.dev/assets/${pizza.image}")
            
          ],
        ),
      ),
    );
  }
}

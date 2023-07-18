import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_shopping_list/models/grocery_item.dart";
import "package:flutter_shopping_list/screens/newitem.dart";
//import "package:flutter_shopping_list/models/grocery_item.dart";
import "package:http/http.dart" as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<GroceryItem> groceryItems = [];

  void _loaditems() async {
    final url = Uri.https(
        'flutter-prep-sxjal-default-rtdb.firebaseio.com', 'shopping-list.json');

    final response = await http.get(url);
    print(response);
    print(response.body);

    final Listdata = json.decode(response.body);
  }

  void _addItem() async {
    await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (context) {
        return const NewItem();
      }),
    );
    _loaditems();
  }

  @override
  void initState() {
    super.initState();
    _loaditems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addItem,
          ),
        ],
      ),
      body: groceryItems.isEmpty
          ? Center(
              child: Text(
                "Try adding new items!",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 20,
                    ),
              ),
            )
          : Center(
              child: ListView.builder(
              itemBuilder: (context, index) {
                return Dismissible(
                  onDismissed: (direction) {
                    // ignore: list_remove_unrelated_type
                    groceryItems.remove(groceryItems[index]);
                  },
                  key: ValueKey(groceryItems[index].id),
                  child: ListTile(
                    leading: Container(
                      color: groceryItems[index].category.color,
                      width: 25,
                      height: 25,
                    ),
                    title: Text(
                      groceryItems[index].name,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
                    ),
                    trailing: Text(
                      groceryItems[index].quantity.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
              itemCount: groceryItems.length,
            )),
    );
  }
}

import "package:flutter/material.dart";
import "package:flutter_shopping_list/data/dummy_items.dart";
import "package:flutter_shopping_list/screens/newitem.dart";
//import "package:flutter_shopping_list/models/grocery_item.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return const NewItem();
                }),
              );
            },
          ),
        ],
      ),
      body: Center(
          child: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
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
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          );
        },
        itemCount: groceryItems.length,
      )),
    );
  }
}

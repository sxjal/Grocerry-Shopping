import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter_shopping_list/data/categories.dart";
import "package:flutter_shopping_list/models/grocery_item.dart";
import "package:flutter_shopping_list/screens/newitem.dart";
import "package:http/http.dart" as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isloading = true;
  List<GroceryItem> groceryItems = [];
  String? error;
  void _loaditems() async {
    final url = Uri.https(
        'flutter-prep-sxjal-default-rtdb.firebaseio.com', 'shopping-list.json');

    final response = await http.get(url);

    if (response.statusCode >= 400) {
      setState(() {
        error = "Something is not right, Please try again later!";
      });
      return;
    }

    final Map<String, dynamic> Listdata = json.decode(response.body);
    final List<GroceryItem> parsedata = [];

    for (final item in Listdata.entries) {
      final localcategory = categories.entries
          .firstWhere(
              (element) => element.value.title == item.value['category'])
          .value;
      parsedata.add(GroceryItem(
        id: item.key,
        name: item.value['name'],
        quantity: item.value['quantity'],
        category: localcategory,
      ));
    }
    setState(() {
      _isloading = false;
      groceryItems = parsedata;
    });
  }

  void _addItem() async {
    final response = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (context) {
        return const NewItem();
      }),
    );
    // _loaditems();
    //fetching data from the newitem screen if the data is sent to the backend
    //successfully in order to remove extra get request
    if (response == null) {
      return;
    } else {
      setState(() {
        groceryItems.add(response);
      });
    }
  }

  void _removeitem(GroceryItem item) async {
    final index = groceryItems.indexOf(item);
    setState(() {
      groceryItems.remove(item);
    });

    final url = Uri.https('flutter-prep-sxjal-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        groceryItems.insert(index, item);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loaditems();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainchild = Center(
      child: Text(
        "Try adding new items!",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: 20,
            ),
      ),
    );

    if (_isloading) {
      mainchild = const Center(
        child: CircularProgressIndicator(
            // value: 2,
            ),
      );
    }

    if (error != null) {
      mainchild = Center(
        child: Text(
          error!,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontSize: 18, fontWeight: FontWeight.normal),
          textAlign: TextAlign.center,
        ),
      );
    }

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
          ? mainchild
          : Center(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Dismissible(
                    onDismissed: (direction) {
                      // ignore: list_remove_unrelated_type
                      _removeitem(groceryItems[index]);
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
                        style:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(),
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
              ),
            ),
    );
  }
}

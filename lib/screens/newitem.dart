import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_shopping_list/data/categories.dart";
import "package:flutter_shopping_list/models/category.dart";
import "package:flutter_shopping_list/models/grocery_item.dart";
import "package:http/http.dart" as http;

class NewItem extends StatefulWidget {
  const NewItem({Key? key}) : super(key: key);

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  var _itemadded = false;
  final _formKey = GlobalKey<FormState>();
  var _enteredItem;
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables];

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _itemadded = true;
      });

      final url = Uri.https('flutter-prep-sxjal-default-rtdb.firebaseio.com',
          'shopping-list.json');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'name': _enteredItem,
            'quantity': _enteredQuantity,
            'category': _selectedCategory!.title,
          },
        ),
      );

      //when we add await, dart automatically adds the then method internally and we get
      //access to the reponse method.
      //we could use this .then((value) => );
      //  Navigator.of(context).pop(

      //everythingworked  response.statusCode == 200 || 201
      //error 404, something went wrong
      print("response $response");
      print("body returns ${response.body}");
      print("response int returns ${response.statusCode}");

      //checking if the widget is still a part of the screen
      //if not then we just return else we will execute pop method
      if (!context.mounted) {
        return;
      }
      final responseid = json.decode(response.body);

      // we will be not using a get request again to list the items as it is not required all over agian and again
      //hence we will just wait for the item to be sent to the backend and then we will pop the item along with
      //sending the data to the previous screen
      Navigator.of(context).pop(GroceryItem(
          id: responseid['name'],
          name: _enteredItem,
          quantity: _enteredQuantity,
          category: _selectedCategory!));
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Item"),
      ),
      body: Stack(
        children: [
          _itemadded
              ? const Center(child: CircularProgressIndicator())
              : Container(), //; ,
          Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    maxLength: 50,
                    decoration: const InputDecoration(
                      labelText: "Item Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length == 1 ||
                          value.trim().length > 50) {
                        return 'Must be between 1 and 50 characters';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _enteredItem = newValue,
                  ),
                  const SizedBox(width: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          //maxLength: 3,
                          initialValue: _enteredQuantity.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Quantity",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.tryParse(value) == null ||
                                int.tryParse(value)! <= 0) {
                              return 'Must be a valid positive number';
                            }
                            return null;
                          },
                          onSaved: ((newValue) =>
                              _enteredQuantity = int.tryParse(newValue!)!),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField(
                          value: _selectedCategory,
                          borderRadius: BorderRadius.circular(4),
                          items: [
                            for (final category in categories.entries)
                              DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      color: category.value.color,
                                      width: 12,
                                      height: 12,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(category.value.title),
                                  ],
                                ),
                              ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _itemadded
                            ? null
                            : () {
                                _formKey.currentState!.reset();
                              },
                        child: const Text("Reset"),
                      ),
                      // const Spacer(),
                      ElevatedButton(
                        onPressed: _saveItem,
                        child: const Text("Add Item"),
                      ),
                    ],
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

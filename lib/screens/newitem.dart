import "package:flutter/material.dart";

class NewItem extends StatefulWidget {
  const NewItem({Key? key}) : super(key: key);

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
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
                  return 'Please enter a valid item name';
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hospital/loginsignup.dart';
import 'package:http/http.dart' as http;
class SecondScreen extends StatefulWidget {
  final String? token;
  const SecondScreen({super.key,required this.token});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  late List<Map<String, dynamic>> dataList= [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('https://apitest.smartsoft-bd.com/api/admin/blog-news'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);

        // Access the list of blogs under "data" -> "blogs" -> "data"
        final List<dynamic> blogData = decodedData['data']['blogs']['data'];

        setState(() {
          dataList = blogData.cast<Map<String, dynamic>>().toList();
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> deleteItem(int index) async {

    // Example: Extracting the ID from the 'id' field
    int itemId = dataList[index]['id'];

    try {
      final response = await http.delete(
        Uri.parse('https://apitest.smartsoft-bd.com/api/admin/blog-news/delete/$itemId'),
        headers: {'Authorization': 'Bearer ${widget.token}'},
      );

      if (response.statusCode == 200) {
        // If the deletion is successful, remove the item from the local list
        setState(() {
          dataList.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item deleted successfully')),
        );
      } else {
        print('Failed to delete item. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // var listt;
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
        backgroundColor: Colors.deepPurpleAccent,
        toolbarHeight: 100,
      ),
      body: dataList != null
          ? ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final item = dataList[index];
          return Card(
            child: ListTile(
              title: Text(item['title'] ?? 'No title'),
              subtitle: Text(item['sub_title'] ?? 'No content'),
              leading:    Text('Update: ${item['updated_by'] ?? 'No update'}'),
              //leading: Text(item['category_id']?.toString() ?? 'No content'),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Description: ${item['description'] ?? 'No content'}'),
                  Text('Slug: ${item['slug'] ?? 'No slug'}'),
                  Text('Date: ${item['date'] ?? 'No Date'}'),
                  // Text('Update: ${item['updated_by'] ?? 'No update'}'),
                ],
              ),
              onTap: () {
                // Show a confirmation dialog before deleting
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete Item'),
                    content: Text('Are you sure you want to delete this item?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Close the dialog
                          Navigator.pop(context);
                          // Call the delete function
                          deleteItem(index);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),

      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //        Text(
      //          'Token:',
      //          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //        ),
      //        SizedBox(height: 10),
      //        Text(
      //          widget.token ?? 'No token available',
      //          style: TextStyle(fontSize: 16),
      //        ),
      //     ],
      //   ),
      // ),

    );
  }
}

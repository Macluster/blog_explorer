import 'dart:convert';
import 'dart:io';

import 'package:blog_explorer/Bloc/FavCubit.dart';
import 'package:blog_explorer/Models/BlogModel.dart';
import 'package:blog_explorer/Utils/NetworkConnection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Backend {
  Future<List<BlogModel>> fetchBlogs(BuildContext context) async {
    List<BlogModel> dataList = [];
    List data = [];

    const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    const String adminSecret =
        '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

    // TO check if the device is connected to internet
    if (await checkInternetConnectivity()) {
      try {
        final response = await http.get(Uri.parse(url), headers: {
          'x-hasura-admin-secret': adminSecret,
        });

        if (response.statusCode == 200) {
          // Request successful, handle the response data here
          //    print('Response data: ${response.body}');
          var res = jsonDecode(response.body);
          print('Response data: ${response.body}');
          data = res["blogs"];

          var cacheBox = await Hive.openBox('blogs');
          cacheBox.put("cache", data);
        } else {
          // Request failed

          ShowDialog(context, "Server error",
              "Server is unavailable now please try after some time");
          print('Request failed with status code: ${response.statusCode}');
          print('Response data: ${response.body}');
        }
      } catch (e) {
        ShowDialog(context, "Error", "An errors occurred during the request");
        // Handle any errors that occurred during the request
        print('Error: $e');
      }
      dataList.addAll(changetoListOfBlogModel(data));
      return dataList;
    } else {
      //If the device is not connected to internet

      ShowDialog(
          context, "No Internet", "Connect to internet to see new contents");
      var box = await Hive.openBox('blogs');

      var list = box.get("cache");
      data.addAll(list);
      dataList.addAll(changetoListOfBlogModel(data));
      return dataList;
    }
  }



  //Get blogs which are added to favorites
  Future<List<BlogModel>> getFavorites(BuildContext context, List state) async {
    var blogdata = await fetchBlogs(context);

    List<BlogModel> favList = [];

    blogdata.forEach((element) => {
          if (state.contains(element.id)) {favList.add(element)}
        });

    return favList;
  }
}


//To change the api request to Datatype(List<BlogModel>) which we used to output the data
List<BlogModel> changetoListOfBlogModel(List data) {
  List<BlogModel> dataList = [];
  data.forEach((element) {
    dataList
        .add(BlogModel(element['id'], element['image_url'], element['title']));
  });

  return dataList;
}


//Used to save images for caching purpose
Future<void> downloadAndSaveImage(String imageUrl, String name) async {
  // Send an HTTP GET request to fetch the image.
  final response = await http.get(Uri.parse(imageUrl));

  if (response.statusCode == 200) {
    // Get the app's local directory for storing files.
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = directory.path + '/$name.png';

    // Write the downloaded image to a file.
    final File file = File(imagePath);
    await file.writeAsBytes(response.bodyBytes);

    print('Image downloaded and saved to: $imagePath');
  } else {
    throw Exception('Failed to load image');
  }
}

void ShowDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Return an AlertDialog widget
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          // Define dialog actions
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Close"),
          ),
        ],
      );
    },
  );
}

import 'dart:io';

import 'package:blog_explorer/Models/BlogModel.dart';
import 'package:blog_explorer/Utils/NetworkConnection.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DetailedBlogView extends StatefulWidget {
  BlogModel model;
  DetailedBlogView(this.model);
  @override
  State<DetailedBlogView> createState() => _DetailedBlogViewState();
}

class _DetailedBlogViewState extends State<DetailedBlogView> {
  bool isThereInternet = false;
  File image = File("");
  void init() async {
    if (await checkInternetConnectivity() == true) {
      setState(() {
        isThereInternet = true;
      });
    } else {
      // used to take image from cache if the internet is not there
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = directory.path + '/${widget.model.id}.png';
      setState(() {
        image = File(imagePath);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  widget.model.title,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: isThereInternet == true
                        ? Image.network(
                            widget.model.imageUrl,
                            fit: BoxFit.cover,
                          )
                        : image.existsSync()
                            ? Image.file(image, fit: BoxFit.cover)
                            : Text("loading"),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  loremdata,
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const loremdata =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultrices diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi. Proin porttitor, orci nec nonummy molestie, enim est eleifend mi, non fermentum diam nisl sit amet erat. Duis semper. Duis arcu massa, scelerisque vitae, consequat in, pretium a, enim. Pellentesque congue. Ut in risus volutpat libero pharetra tempor. Cras vestibulum bibendum augue. Praesent egestas leo in pede. Praesent blandit odio eu enim. Pellentesque sed dui ut augue blandit sodales. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aliquam nibh. Mauris ac mauris sed pede pellentesque fermentum. Maecenas adipiscing ante non diam sodales hendrerit.";

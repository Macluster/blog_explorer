import 'dart:io';

import 'package:blog_explorer/Backend/Backend.dart';
import 'package:blog_explorer/Bloc/FavCubit.dart';
import 'package:blog_explorer/Models/BlogModel.dart';
import 'package:blog_explorer/Pages/DetailedBlogView.dart';
import 'package:blog_explorer/Utils/NetworkConnection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class BlogItemCard extends StatefulWidget {
  BlogModel model;
  bool isFav = false;

  BlogItemCard(this.model, this.isFav);

  @override
  State<BlogItemCard> createState() => _BlogItemCardState();
}

class _BlogItemCardState extends State<BlogItemCard> {
  bool isfav = false;
  File image = File("");
  bool isThereInternet = false;

  addToFav() async {
    //adding fav blog to the current bloc state
    context.read<FavCubit>().addItem(widget.model.id);

    //retrieving favorite blogs from hive database
    var box = await Hive.openBox('blogs');
    var list = box.get("fav") as List;
    list.add(widget.model.id);

    box.put("fav", list);
  }

  removeFromFav() async {
    //Removing fav blog to the current bloc state
    context.read<FavCubit>().removeitem(widget.model.id);

    //retrieving favorite blogs from hive database
    var box = await Hive.openBox('blogs');
    var list = box.get("fav") as List;

    list.remove(widget.model.id);
    print(list);
    box.put("fav", list);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isfav = widget.isFav;
    setState(() {});

    init();
  }

  void init() async {
    if (await checkInternetConnectivity() == true) {
      downloadAndSaveImage(widget.model.imageUrl, widget.model.id);

      setState(() {
        isThereInternet = true;
      });
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = directory.path + '/${widget.model.id}.png';

      // Write the downloaded image to a file.

      setState(() {
        image = File(imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailedBlogView(widget.model)));
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey, spreadRadius: 2, blurRadius: 2)
              ]),
          width: 200,
          height: 200,
          child: Stack(children: [
            Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                height: 200,
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
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 10),
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.2)),
                        width: 250,
                        child: Text(
                          widget.model.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 17),
                        )),
                    GestureDetector(
                      onTap: () {
                        if (isfav) {
                          isfav = false;
                          removeFromFav();
                        } else {
                          isfav = true;
                          addToFav();
                        }
                        setState(() {});
                      },
                      child: Icon(
                        Icons.favorite,
                        color: isfav == true ? Colors.red : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

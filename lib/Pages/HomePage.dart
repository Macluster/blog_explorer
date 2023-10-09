import 'package:blog_explorer/Backend/Backend.dart';
import 'package:blog_explorer/Bloc/FavCubit.dart';
import 'package:blog_explorer/Components/BlogItemCard.dart';
import 'package:blog_explorer/Models/BlogModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  // this function is used for fetching the blogs we added to favorites
  void init() async {
    var box = await Hive.openBox('blogs');
    var list = box.get("fav") as List;
    context.read<FavCubit>().init(list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 700,
                  child: BlocBuilder<FavCubit, List>(
                    builder: (context, state) {
                      return FutureBuilder(
                          future: Backend().fetchBlogs(context),
                          builder:
                              (context, AsyncSnapshot<List<BlogModel>> snap) {
                            if (snap.hasData) {
                              return ListView.builder(
                                  itemCount: snap.data!.length,
                                  itemBuilder: (context, index) {
                                    var key = snap.data![index].id;
                                    var isfav = false;
                                    if (state.contains(key)) {
                                      isfav = true;
                                    }
                                    return BlogItemCard(
                                        snap.data![index], isfav);
                                  });
                            } else {
                              return const Text("Loding");
                            }
                          });
                    },
                  ))
            ],
          ),
        ),
      ),
    ));
  }
}

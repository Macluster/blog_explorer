import 'package:blog_explorer/Backend/Backend.dart';
import 'package:blog_explorer/Bloc/FavCubit.dart';
import 'package:blog_explorer/Components/BlogItemCard.dart';
import 'package:blog_explorer/Models/BlogModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritPage extends StatefulWidget {
  @override
  State<FavoritPage> createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    height: 700,
                    child: BlocBuilder<FavCubit, List>(
                      builder: (context, state) {
                        return FutureBuilder(
                            future: Backend().getFavorites(context, state),
                            builder:
                                (context, AsyncSnapshot<List<BlogModel>> snap) {
                              if (snap.hasData) {
                                return ListView.builder(
                                    itemCount: snap.data!.length,
                                    itemBuilder: (context, index) {
                                      return BlogItemCard(
                                          snap.data![index], true);
                                    });
                              } else {
                                return const Text("Loding");
                              }
                            });
                      },
                    ))
              ],
            ),
          )),
    );
  }
}

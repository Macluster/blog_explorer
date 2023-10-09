import 'package:bloc/bloc.dart';
import 'package:blog_explorer/Backend/Backend.dart';
import 'package:blog_explorer/Bloc/BlocObserver.dart';
import 'package:blog_explorer/Bloc/FavCubit.dart';
import 'package:blog_explorer/Components/BlogItemCard.dart';
import 'package:blog_explorer/Models/BlogModel.dart';
import 'package:blog_explorer/Pages/FavoritePage.dart';
import 'package:blog_explorer/Pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  Bloc.observer = const CounterObserver();
  await Hive.initFlutter();

  var box = await Hive.openBox('blogs');
  if (!box.containsKey("fav")) {
    box.put("fav", []);
  }
  if (!box.containsKey("cache")) {
    box.put("cache", []);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (BuildContext context) => FavCubit(),
            ),
            BlocProvider(
              create: (BuildContext context) => TitleCubit(),
            )
          ],
          child: const MyHomePage(title: 'Flutter Demo Home Page'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _pages = [
    HomePage(),
    FavoritPage()
  ];

  var title="Blogs and Articles";
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if(index==0)
    {
      title="Blogs and Articles";
    }
    else
    {
      title="Favorites";
    }
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  Text(title),
          actions: [Icon(Icons.search)],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, // Current selected tab index
          onTap: _onItemTapped, // Function to handle tab selection
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Fav',
            ),
          
          ],
        ),
        body: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.all(10),
            child:_pages[_selectedIndex]
          ),
        ));
  }
}

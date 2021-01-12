import 'package:flutter/material.dart';
import 'package:giphy_search_example/src/blocs/search_bloc.dart';
import 'package:giphy_search_example/src/data/giphy_repository.dart';
import 'package:giphy_search_example/src/screens/home_screen.dart';
import 'package:provider/provider.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SearchBloc>(
          create: (_) => SearchBloc(GiphyRepository()),
          dispose: (_, bloc) => bloc.dispose(),
        ),
      ],
      child: MaterialApp(
        title: 'Giphy Search',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

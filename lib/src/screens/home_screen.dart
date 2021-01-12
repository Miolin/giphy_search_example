import 'package:flutter/material.dart';
import 'package:giphy_search_example/src/blocs/search_bloc.dart';
import 'package:giphy_search_example/src/models/gif_info.dart';
import 'package:giphy_search_example/src/widgets/gif_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

const _emptyBorder = UnderlineInputBorder(
  borderSide: BorderSide(
    width: 0,
    color: Colors.transparent,
  ),
);

class _HomeScreenState extends State<HomeScreen> {
  final _searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchBloc>(
      builder: (context, bloc, _) {
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: _searchTextController,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: Theme.of(context).accentTextTheme.headline6.copyWith(
                      color: Colors.white54,
                    ),
                suffix: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    bloc.search(_searchTextController.text);
                  },
                ),
                border: _emptyBorder,
                enabledBorder: _emptyBorder,
                focusedBorder: _emptyBorder,
              ),
              style: Theme.of(context).accentTextTheme.headline6,
              textInputAction: TextInputAction.search,
              onSubmitted: (searchText) {
                bloc.search(searchText);
              },
            ),
          ),
          body: StreamBuilder<SearchState>(
              stream: bloc.searchState,
              initialData: SearchState.loaded,
              builder: (context, snapshot) {
                Widget widget;
                switch (snapshot.data) {
                  case SearchState.loaded:
                  case SearchState.loadingMore:
                    widget = _buildGifList(context, bloc, snapshot.data);
                    break;
                  case SearchState.failed:
                    widget = Center(
                      child: Text(
                        'Failed',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    );
                    break;
                  case SearchState.loading:
                    widget = Center(child: CircularProgressIndicator());
                    break;
                }

                return widget;
              }),
        );
      },
    );
  }

  Widget _buildGifList(
      BuildContext context, SearchBloc bloc, SearchState state) {
    return StreamBuilder<List<GifInfo>>(
      stream: bloc.results,
      initialData: [],
      builder: (context, snapshot) {
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent) {
              bloc.loadMore();
              return true;
            }
            return false;
          },
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if (state == SearchState.loadingMore &&
                  index == snapshot.data.length) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return GifCard(gifInfo: snapshot.data[index]);
            },
            itemCount: state == SearchState.loadingMore
                ? snapshot.data.length + 1
                : snapshot.data.length,
          ),
        );
      },
    );
  }
}

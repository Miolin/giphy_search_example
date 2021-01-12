import 'package:giphy_search_example/src/data/giphy_repository.dart';
import 'package:giphy_search_example/src/models/gif_info.dart';
import 'package:rxdart/rxdart.dart';

const _searchLimit = 50;

class SearchBloc {
  final GiphyRepository _repository;

  final BehaviorSubject<SearchState> _searchState = BehaviorSubject();

  Stream<SearchState> get searchState => _searchState.stream;

  final BehaviorSubject<List<GifInfo>> _results = BehaviorSubject();

  Stream<List<GifInfo>> get results => _results.stream;

  SearchBloc(this._repository);

  var _currentOffset = 0;
  var _prevSearchText = '';
  var _totalCount = 0;

  void search(String text) async {
    if (text.isEmpty) {
      _currentOffset = 0;
      _results.add([]);
      _prevSearchText = '';
      _searchState.add(SearchState.loaded);
      return;
    }

    if (text == _prevSearchText) return;

    _searchState.add(SearchState.loading);
    try {
      final result = await _repository.searchGif(text, _searchLimit, 0);
      _totalCount = result.pagination.totalCount;
      _currentOffset = _searchLimit;
      _prevSearchText = text;
      _results.add(result.data);
      _searchState.add(SearchState.loaded);
    } catch (e) {
      print(e);
      _currentOffset = 0;
      _results.add([]);
      _searchState.add(SearchState.failed);
    }
  }

  void loadMore() {
    if (_searchState.value == SearchState.loadingMore ||
        _searchState.value == SearchState.loading) return;
    if (_currentOffset > _totalCount) return;
    if (_prevSearchText.isEmpty) return;

    _searchState.add(SearchState.loadingMore);

    _startLoadingMore();
  }

  void _startLoadingMore() async {
    if (_results.isClosed && _searchState.value != SearchState.loadingMore)
      return;

    try {
      final result = await _repository.searchGif(
          _prevSearchText, _searchLimit, _currentOffset);
      _currentOffset += _searchLimit;
      final loadedGifs = _results.value;
      loadedGifs.addAll(result.data);
      _results.add(loadedGifs);
      _searchState.add(SearchState.loaded);
    } catch (e) {
      print(e);
      _startLoadingMore();
    }
  }

  void dispose() {
    _searchState.close();
    _results.close();
  }
}

enum SearchState {
  loaded,
  failed,
  loading,
  loadingMore,
}

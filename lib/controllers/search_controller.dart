import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/song.dart';
import 'package:flutter_application_1/services/api_service.dart';

class SearchController extends ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  
  bool _isSearching = false;
  bool get isSearching => _isSearching;
  
  List<Song> _searchResults = [];
  List<Song> get searchResults => _searchResults;
  
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  late ApiService _apiService;
  
  // Set API service
  void setApiService(ApiService apiService) {
    _apiService = apiService;
  }
  
  // Update search query
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
    
    if (query.isNotEmpty) {
      _isSearching = true;
      _performSearch();
    } else {
      _isSearching = false;
      _searchResults = [];
      notifyListeners();
    }
  }
  
  // Clear search
  void clearSearch() {
    textController.clear();
    _searchQuery = '';
    _isSearching = false;
    _searchResults = [];
    notifyListeners();
  }
  
  // Perform search
  Future<void> _performSearch() async {
    if (_searchQuery.isEmpty) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final results = await _apiService.searchSongs(_searchQuery);
      _searchResults = results;
    } catch (e) {
      print('Error searching songs: $e');
      _searchResults = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/book_model.dart';
import '../data/data_manager.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController searchController = TextEditingController();
  List<Book> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _handleSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://www.googleapis.com/books/v1/volumes?q=${Uri.encodeComponent(query)}&maxResults=20&key=AIzaSyCd2HyJkpHgyfu7jdYPzBvGFVJqLNg-89I',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List items = data['items'] ?? [];

        setState(() {
          _searchResults = items.map((item) => Book.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _searchResults = [];
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to load books'),
              backgroundColor: Color(0xFFEF5350),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Network error. Please try again.'),
            backgroundColor: Color(0xFFEF5350),
          ),
        );
      }
    }
  }

  // ✅ BOOK ADD KARNE KA METHOD
  void _addBookToLibrary(Book book, String listType) {
    try {
      final dataManager = Provider.of<DataManager>(context, listen: false);

      // Debug: Check if provider is available
      print("📚 Adding book: ${book.title}");

      // Check if book already exists
      final existingBook = dataManager.getBookById(book.id);

      if (existingBook != null) {
        // Book already exists, update it
        print("🔄 Updating existing book: ${book.title}");
        switch (listType) {
          case 'read':
            existingBook.isRead = true;
            existingBook.isToRead = false;
            break;
          case 'toread':
            existingBook.isToRead = true;
            existingBook.isRead = false;
            break;
          case 'favorite':
            existingBook.isFavorite = !existingBook.isFavorite;
            break;
        }
        dataManager.updateBook(existingBook);
      } else {
        // New book, create with proper status
        print("🆕 Adding new book: ${book.title}");
        final newBook = Book(
          id: book.id,
          title: book.title,
          author: book.author,
          thumbnail: book.thumbnail,
          isRead: listType == 'read',
          isToRead: listType == 'toread',
          isFavorite: listType == 'favorite',
        );
        dataManager.addBook(newBook);
      }

      // Success message
      String message = '';
      switch (listType) {
        case 'read':
          message = '📖 "${book.title}" marked as read!';
          break;
        case 'toread':
          message = '➕ "${book.title}" added to your library!';
          break;
        case 'favorite':
          message = '❤️ "${book.title}" added to favorites!';
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Debug print
      print("✅ Book added/updated: ${book.title}");
      dataManager.printAllBooks();
    } catch (e) {
      print("❌ Error adding book: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding book: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 167, 247),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Search Books 🔍',
              style: TextStyle(
                fontSize: 30,
                color: Color.fromARGB(255, 80, 21, 90),
              ),
            ),
            // SEARCH BAR
            _buildSearchBar(),

            // RESULTS LIST
            _buildResultsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: TextField(
            controller: searchController,
            onSubmitted: (query) {
              _handleSearch(query);
            },
            decoration: InputDecoration(
              hintText: 'Search book',
              hintStyle: TextStyle(color: Color(0xFF9575CD)),
              prefixIcon: Icon(Icons.search, color: Color(0xFF9575CD)),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Color(0xFF9575CD)),
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          _searchResults = [];
                          _hasSearched = false;
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
            ),
            style: const TextStyle(color: Color(0xFF4A148C)),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptystate() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.import_contacts, size: 100, color: Colors.purple),
            SizedBox(height: 30),
            Text(
              "Search for your next book!",
              style: TextStyle(color: Colors.blueGrey, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    return Expanded(
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9575CD)),
              ),
            )
          : _searchResults.isEmpty && _hasSearched
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.deepPurple.withOpacity(0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No books found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.deepPurple.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            )
          : _searchResults.isEmpty
          ? _buildEmptystate()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return _buildBookCard(_searchResults[index]);
              },
            ),
    );
  }

  Widget _buildBookCard(Book book) {
    final String? thumb = book.thumbnail;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shadowColor: Colors.deepPurple.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: thumb != null
                  ? Image.network(
                      thumb,
                      width: 60,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
            const SizedBox(width: 12),

            // Book info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A148C),
                    ),
                  ),
                  if (book.author != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      book.author!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9575CD),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),

                  // ✅ QUICK ACTION BUTTONS
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _addBookToLibrary(book, 'toread');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          textStyle: TextStyle(fontSize: 12),
                        ),
                        child: Text(
                          'Add to Library',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          _addBookToLibrary(book, 'read');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          textStyle: TextStyle(fontSize: 12),
                        ),
                        child: Text(
                          'Mark Read',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Menu button
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Color(0xFF6A1B9A)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) {
                _handleMenuAction(value, book);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'read',
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFF66BB6A),
                      ),
                      SizedBox(width: 8),
                      Text('Mark as Read'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'toread',
                  child: Row(
                    children: [
                      Icon(
                        Icons.bookmark_add_outlined,
                        color: Color(0xFF42A5F5),
                      ),
                      SizedBox(width: 8),
                      Text('Add to To-Read'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'favorite',
                  child: Row(
                    children: [
                      Icon(Icons.favorite_border, color: Color(0xFFE91E63)),
                      SizedBox(width: 8),
                      Text('Add to Favorites'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ MENU ACTION HANDLER
  void _handleMenuAction(String action, Book book) {
    _addBookToLibrary(book, action);
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 90,
      color: Colors.grey[200],
      child: Icon(Icons.book, color: Colors.grey[400]),
    );
  }
}

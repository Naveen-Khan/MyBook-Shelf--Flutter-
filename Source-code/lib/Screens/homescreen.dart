import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../data/data_manager.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 167, 247),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'My Book Shelf 📚',
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 80, 21, 90),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              // WELCOME MESSAGE
              _buildWelcomeCard(),
              SizedBox(height: 20),

              // COMPLETE BOOKS SECTION
              _buildSectionHeader('All Books in Your Library 📚'),
              SizedBox(height: 10),
              _buildCompleteBooksSection(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ SECTION HEADER
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          color: Color.fromARGB(255, 80, 21, 90),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: const Color.fromARGB(240, 255, 255, 255),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.auto_stories, size: 50, color: Colors.purple),
            SizedBox(height: 10),
            Text(
              'Welcome to Your Book Shelf!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 80, 21, 90),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'All your books are displayed below',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ COMPLETE BOOKS SECTION (LONG CARDS)
  Widget _buildCompleteBooksSection() {
    return Consumer<DataManager>(
      builder: (context, dataManager, child) {
        final allBooks = dataManager.allBooks;

        if (allBooks.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: allBooks.length,
          itemBuilder: (context, index) {
            return _buildLongBookCard(allBooks[index]);
          },
        );
      },
    );
  }

  // ✅ LONG BOOK CARD (Movie-style)
  Widget _buildLongBookCard(Book book) {
    final String? thumb = book.thumbnail;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 6,
        shadowColor: Colors.deepPurple.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Image (Left side)
              Container(
                width: 80,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: thumb != null
                      ? Image.network(
                          thumb,
                          width: 80,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildLongPlaceholder(),
                        )
                      : _buildLongPlaceholder(),
                ),
              ),

              SizedBox(width: 16),

              // Book Details (Right side)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title and Author
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A148C),
                          ),
                        ),
                        SizedBox(height: 6),
                        if (book.author != null)
                          Text(
                            'by ${book.author!}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF9575CD),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 12),

                    // Status and Actions
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status chips
                        Wrap(
                          spacing: 8,
                          children: [
                            if (book.isRead)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 14,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Read',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (book.isToRead)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.bookmark,
                                      size: 14,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'To Read',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (book.isFavorite)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      size: 14,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Favorite',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),

                        SizedBox(height: 12),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _toggleReadStatus(context, book);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: book.isRead
                                      ? Colors.green
                                      : Colors.purple,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      book.isRead ? Icons.check : Icons.book,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      book.isRead ? 'Mark Unread' : 'Mark Read',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                _toggleFavoriteStatus(context, book);
                              },
                              icon: Icon(
                                book.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: book.isFavorite
                                    ? Colors.red
                                    : Colors.grey,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ TOGGLE READ STATUS
  void _toggleReadStatus(BuildContext context, Book book) {
    final dataManager = Provider.of<DataManager>(context, listen: false);

    if (book.isRead) {
      // Mark as unread
      book.isRead = false;
      book.isToRead = true;
    } else {
      // Mark as read
      book.isRead = true;
      book.isToRead = false;
    }

    dataManager.updateBook(book);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          book.isRead
              ? '📖 "${book.title}" marked as read!'
              : '📚 "${book.title}" marked as unread!',
        ),
        backgroundColor: book.isRead ? Colors.green : Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ✅ TOGGLE FAVORITE STATUS
  void _toggleFavoriteStatus(BuildContext context, Book book) {
    final dataManager = Provider.of<DataManager>(context, listen: false);

    book.isFavorite = !book.isFavorite;
    dataManager.updateBook(book);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          book.isFavorite
              ? '❤️ "${book.title}" added to favorites!'
              : '💔 "${book.title}" removed from favorites!',
        ),
        backgroundColor: book.isFavorite ? Colors.red : Colors.grey,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ✅ EMPTY STATE
  Widget _buildEmptyState() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1BEE7), width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_outlined, size: 64, color: Color(0xFFB39DDB)),
            SizedBox(height: 16),
            Text(
              'No books in your library!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Search for books and add them to your collection',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF9575CD)),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ PLACEHOLDER WIDGET
  Widget _buildLongPlaceholder() {
    return Container(
      width: 80,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFE1BEE7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.book, size: 36, color: Color(0xFF9575CD)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:debook/API/api_service.dart';
import 'package:debook/models/book.dart';
import '../home/components/trending_book.dart';
import '../home/pages/search_page.dart';
import '/../themes.dart';

class HomePage extends StatefulWidget {
  static const nameRoute = '/homePage';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  List<Book> _bookLists = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String username = '';
  String avatarPath = 'assets/images/profile-pic.png'; // Default avatar path

  final List<String> _categories = [
    'All Books',
    'Comic',
    'Novel',
    'Manga',
    'Fantasy',
    'Horror',
    'Drama',
  ];

  int _indexYangDipilih = 0;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
    _loadUsername();
    _loadAvatar();
  }

  Future<void> _fetchBooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Book> books;
      if (_indexYangDipilih == 0) {
        books = await _apiService.fetchBooks();
      } else {
        books = await _apiService.fetchBooksByCategory(_categories[_indexYangDipilih]);
      }
      setState(() {
        _bookLists = books;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Unknown User';
    });
  }

  Future<void> _loadAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      avatarPath = prefs.getString('avatarPath') ?? 'assets/images/profile-pic.png';
    });
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(query: query),
        ),
      );
    }
  }

  Widget header() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(avatarPath), // Use the dynamic avatarPath here
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello $username',
                style: semiBoldText16,
              ),
              Text(
                'Good Morning',
                style: regularText14.copyWith(color: greyColor),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget searchField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Find Your Favorite Book',
          hintStyle: mediumText12.copyWith(color: greyColor),
          fillColor: greyColorSearchField,
          filled: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          isCollapsed: true,
          contentPadding: const EdgeInsets.all(18),
          suffixIcon: InkWell(
            onTap: _onSearch,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: greenColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Icon(
                Icons.search_rounded,
                color: whiteColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget categories(int pilih) {
    return InkWell(
      onTap: () {
        setState(() {
          _indexYangDipilih = pilih;
        });
        _fetchBooks();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 30, right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: _indexYangDipilih == pilih ? greenColor : transParentColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          _categories[pilih],
          style: semiBoldText14.copyWith(
              color: _indexYangDipilih == pilih ? whiteColor : greyColor),
        ),
      ),
    );
  }

  Widget listCategories() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 30),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories
            .asMap()
            .entries
            .map((MapEntry map) => categories(map.key))
            .toList(),
      ),
    );
  }

  Widget trendingBookGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : TrendingBooksGrid(
                books: _bookLists,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header(),
                const SizedBox(height: 30),
                searchField(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Text(
              'Welcome To DeBooK',
              style: semiBoldText20.copyWith(color: blackColor),
            ),
          ),
          listCategories(),
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 30),
            child: Text(
              'Trending Now',
              style: semiBoldText16.copyWith(color: blackColor),
            ),
          ),
          trendingBookGrid(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

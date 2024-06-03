import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:debook/themes.dart';
import '/../controller/session_manager.dart';
import '../home/pages/login_page.dart';
import '/../database/db_helper_login.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String username = '';
  String avatarPath = 'assets/images/profile-pic.png'; // Default avatar path
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadUsers();
    _loadAvatar();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Unknown User';
    });
  }

  Future<void> _loadUsers() async {
    List<Map<String, dynamic>> users = await dbHelper.getUsers();
    setState(() {
      _users = users;
    });
  }

  Future<void> _loadAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      avatarPath = prefs.getString('avatarPath') ?? 'assets/images/profile-pic.png';
    });
  }

  Future<void> _saveAvatar(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      avatarPath = path;
    });
    await prefs.setString('avatarPath', path);
  }

  Future<void> _deleteUser(int id) async {
    await dbHelper.deleteUser(id);
    _loadUsers(); // Refresh the user list
  }

  Future<bool> _showConfirmationDialog(
      BuildContext context, String username) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete the user "$username"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _showEncryptedPasswordDialog(
      BuildContext context, String username, String encryptedPassword) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Username: $username'),
              const SizedBox(height: 10),
              Text('Password: $encryptedPassword'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAvatarSelectionDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Avatar'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              children: List.generate(6, (index) {
                String avatar = 'assets/avatar/avatar${index + 1}.jpeg';
                return GestureDetector(
                  onTap: () {
                    _saveAvatar(avatar);
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    avatar,
                    width: 60,
                    height: 60,
                  ),
                );
              }),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    SessionManager sessionManager = SessionManager();
    await sessionManager.endService();

    // Navigate to LoginPage and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: semiBoldText20.copyWith(color: whiteColor),
        ),
        backgroundColor: greenColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(avatarPath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    username,
                    style: semiBoldText20,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _showAvatarSelectionDialog(context);
                    },
                    child: Text('Ganti Avatar'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Email',
              style: semiBoldText16.copyWith(color: greyColor),
            ),
            const SizedBox(height: 5),
            Text(
              username,
              style: regularText16,
            ),
            Divider(height: 30, color: greyColor),
            Text(
              'Phone',
              style: semiBoldText16.copyWith(color: greyColor),
            ),
            const SizedBox(height: 5),
            Text(
              '+1 234 567 890',
              style: regularText16,
            ),
            Divider(height: 30, color: greyColor),
            Text(
              'Address',
              style: semiBoldText16.copyWith(color: greyColor),
            ),
            const SizedBox(height: 5),
            Text(
              '123 Main Street, Hometown, Country',
              style: regularText16,
            ),
            Divider(height: 30, color: greyColor),
            Text(
              'Bio',
              style: semiBoldText16.copyWith(color: greyColor),
            ),
            const SizedBox(height: 5),
            Text(
              'Book lover, avid reader, and aspiring author.',
              style: regularText16,
            ),
            const SizedBox(height: 20),
            Text(
              'Registered Users',
              style: semiBoldText16,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _users.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            _users[index]['username'],
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            _showEncryptedPasswordDialog(
                                context,
                                _users[index]['username'],
                                _users[index]['password']);
                          },
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              bool confirmed = await _showConfirmationDialog(
                                  context, _users[index]['username']);
                              if (confirmed) {
                                _deleteUser(_users[index]['id']);
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessgoal/components/drawer.dart';
import 'package:fitnessgoal/screens/profile_page.dart';
import 'package:fitnessgoal/screens/add_goal.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


class HomePage extends StatefulWidget {
  final String userName;
  final Function()? onProfile;
  final void Function()? onSignOut;

  const HomePage({
    Key? key,
    required this.userName,
    required this.onProfile,
    required this.onSignOut,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference goalsCollection =
      FirebaseFirestore.instance.collection('goals');
  final CollectionReference favoritesCollection =
      FirebaseFirestore.instance.collection('favorites');
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool _isSearching = false;

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    if (widget.onSignOut != null) {
      widget.onSignOut!();
    }
  }

  void goToProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  Future<void> toggleFavorite(String goalId, bool isFavorite) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    if (isFavorite) {
      await favoritesCollection.doc('$userId-$goalId').delete();
    } else {
      await favoritesCollection.doc('$userId-$goalId').set({
        'userId': userId,
        'goalId': goalId,
      });
    }
  }

  Future<bool> isGoalFavorite(String goalId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var favoriteDoc = await favoritesCollection.doc('$userId-$goalId').get();
    return favoriteDoc.exists;
  }

  Future<void> _refreshGoals() async {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = "";
                  _searchController.clear();
                }
              });
            },
          ),
        ],
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search goals...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              )
            : Text('Home'),
      ),
      drawer: DrawerPage(
        onProfile: goToProfilePage,
        onSignOut: signUserOut,
      ),
      bottomNavigationBar: GNav(tabs: [
        GButton(icon: Icons.home, text: 'Home'),
        GButton(icon: Icons.analytics, text: 'Analytics'),
        GButton(icon: Icons.person_3_rounded, text: 'Profile'),
        GButton(icon: Icons.favorite, text: 'Favorites'),
      ]),
      body: RefreshIndicator(
        onRefresh: _refreshGoals,
        child: StreamBuilder(
          stream: goalsCollection
              .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No data found'),
              );
            }

            var goals = snapshot.data!.docs.where((document) {
              var data = document.data() as Map<String, dynamic>;
              String title = data['title']?.toLowerCase() ?? '';
              String description = data['description']?.toLowerCase() ?? '';
              return title.contains(_searchQuery) || description.contains(_searchQuery);
            }).toList();

            return ListView(
              children: goals.map((document) {
                var data = document.data() as Map<String, dynamic>;
                String goalId = document.id;

                return FutureBuilder<bool>(
                  future: isGoalFavorite(goalId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return SizedBox(); // Return an empty widget instead of "Loading..."
                    }

                    bool isFavorite = snapshot.data!;
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Card(
                          child: ListTile(
                            leading: IconButton(
                              icon: isFavorite
                                  ? Icon(Icons.favorite, color: Colors.red)
                                  : Icon(Icons.favorite_border, color: Colors.grey),
                              onPressed: () async {
                                await toggleFavorite(goalId, isFavorite);
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                              },
                            ),
                            title: Text(data['title'] ?? 'No Title'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data['description'] ?? 'No Description'),
                                Text("Type: ${data['type'] ?? 'No Type'}"),
                                Text("Date: ${data['date'] ?? 'No Date'}"),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => AddGoalPage(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[900],
      ),
    );
  }
}

import 'package:blog_minimal/screens/blog_overview_page.dart';
import 'package:blog_minimal/screens/create_post.dart';
import 'package:blog_minimal/screens/signup.dart';
import 'package:blog_minimal/widgets/post_cell_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// class Post {
//   final String title;
//   final String image;
//   final String author;
//   final String date;

//   Post({this.title, this.image, this.author, this.date});
// }

class HomePage extends StatelessWidget {
  final _user = FirebaseAuth.instance.currentUser;
  // final data = [
  //   Post(
  //     image: 'assets/images/ikigai.jpg',
  //     title: 'Finding your ikigai in your middle age',
  //     author: 'John Johny',
  //     date: '25 Mar 2020',
  //   ),
  //   Post(
  //     image: 'assets/images/leader.jpg',
  //     title: 'How to Lead Before You Are in Charge',
  //     author: 'John Johny',
  //     date: '24 Mar 2020',
  //   ),
  //   Post(
  //     image: 'assets/images/minimal.jpg',
  //     title: 'How Minimalism Brought Me',
  //     author: 'John Johny',
  //     date: '15 Mar 2020',
  //   ),
  //   Post(
  //     image: 'assets/images/colors.jpg',
  //     title: 'The Most Important Color In UI Design',
  //     author: 'John Johny',
  //     date: '11 Mar 2020',
  //   ),
  //   Post(
  //     image: 'assets/images/leader.jpg',
  //     title: 'How to Lead Before You Are in Charge',
  //     author: 'John Johny',
  //     date: '24 Mar 2020',
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    print(_user.email);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Revamph Prompt',
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          InkWell(
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 0,
                    child: CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.red,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFFFD810),
        elevation: 0,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreatePost()));
        },
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for articles, author, and tags',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your feed',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    //retreving from firestore
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('blogs')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final List<DocumentSnapshot> data =
                                snapshot.data.docs;
                            return ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: data.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: PostCellWidget(
                                      title: data[index]['title'],
                                      image: data[index]['imageUrl'],
                                      author: data[index]['publisher'],
                                      date: data[index]['date'],
                                      onClick: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) => BlogOverview(
                                            title: data[index]['title'],
                                            imageUrl: data[index]['imageUrl'],
                                            author: data[index]['publisher'],
                                            date: data[index]['date'],
                                            content: data[index]['content'],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => Divider(),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

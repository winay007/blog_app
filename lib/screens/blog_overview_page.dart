import 'package:flutter/material.dart';

class BlogOverview extends StatelessWidget {
  const BlogOverview(
      {Key key,
      this.title,
      this.author,
      this.date,
      this.content,
      this.imageUrl})
      : super(key: key);

  final title;
  final author;
  final date;
  final content;
  final imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          backgroundColor: Colors.grey[100],
          elevation: 0,
          iconTheme: IconThemeData(
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //title
            Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 8,
                    color: Colors.yellow[600],
                  ),
                ),
              ),
              margin: EdgeInsets.fromLTRB(40, 0, 50, 16),
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              width: double.infinity,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //author and publishment date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomContainer(
                  text: 'By ' + author,
                ),
                CustomContainer(
                  text: date,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                content,
                style: TextStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    Key key,
    this.text,
  }) : super(key: key);
  final text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 10, 12),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}

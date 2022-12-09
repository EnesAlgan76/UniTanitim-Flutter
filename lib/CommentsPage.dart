import 'package:comment_box/comment/comment.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:uni_tanitim/models/Comments.dart';

import 'FirebaseOperations.dart';

class CommentsPage extends StatefulWidget {

  late String placeId;
  CommentsPage({required this.placeId});

  var currentTime = DateFormat('dd-MM-yyyy').format(DateTime.now());


  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();


  FirebaseOperations firestore = FirebaseOperations();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        title: Text("Yorumlar"),
      ),
      body: Container(
        child: CommentBox(

          child: FutureBuilder(
            future: firestore.getComments(placeId: widget.placeId),
            builder: (context,AsyncSnapshot snapshot){
              if(snapshot.hasData){
                return ListView(
                  children: [
                    for(var i in snapshot.data)
                      CommentWidget(comment: i["comment"], title: i["title"], date: i["date"],),
                  ],
                );
              }
              else{
                return Center(child: Text("ERROR"),);
              }
            },
          ),
          labelText: 'Yorum yaz...',
          errorText: 'Comment cannot be blank',
          withBorder: false,
          sendButtonMethod: () {
            if (formKey.currentState!.validate()) {
              print(commentController.text);
              setState(() {
                Comment comment = Comment(comment: commentController.text, title: "deneme", date: widget.currentTime, likes: 0, placeId: widget.placeId);
                firestore.addComments(comment: comment);
              });
              commentController.clear();
              FocusScope.of(context).unfocus();
            } else {
              print("Not validated");
            }
          },
          formKey: formKey,
          commentController: commentController,
          backgroundColor: Colors.deepPurpleAccent,
          textColor: Colors.white,
          sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
        ),
      ),
    );
  }
}

class CommentWidget extends StatefulWidget {

  late String comment;
  late String title;
  late String date;
  late int likes;

  CommentWidget({required this.comment,required this.title, required this.date});

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {

  int likess= 0;
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: Card(

          elevation: 3,
          shadowColor: Colors.grey,
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.deepPurpleAccent,),
            title: Text(widget.title),
            subtitle: Text(widget.comment),
            trailing: FittedBox(
              child: Column(
                children: [
                  Text(widget.date),
                  Wrap(
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        child:LikeButton(
                          isLiked: isLiked,
                          likeCount: likess,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
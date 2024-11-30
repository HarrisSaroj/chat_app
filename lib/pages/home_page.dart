import 'package:chat_app/components/my_drawer.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

import '../components/user_tile.dart';
import 'chat_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        title: const Text(
          'Home',
          textAlign: TextAlign.center,
        ),
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  //build the list of user except for the current logged in user
  Widget _buildUserList(){
    return StreamBuilder(
        stream: _chatService.getUserStream(),
        builder: (context, snapshot){
          //error
          if(snapshot.hasError){
            return const Text('Error');
          }

          //loading
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Text('Loading...');
          }

          //return listview
          return ListView(
            children: snapshot.data!
                .map<Widget>((userData) => _buildUserListItem(userData, context))
                .toList(),);
        }
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context){
    //display all user except current user
    if(userData["email"] != _authService.getCurrentUser()){
      return UserTile(
        text: userData["email"],
        onTap: () {
          //tapped on user to go to chat page
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverEmail: userData["email"],
                  receiverID: userData["uid"],
                ),
              )
          );
        },
      );
    }else{
      return Container();
    }
  }
}

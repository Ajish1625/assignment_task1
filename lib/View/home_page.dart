import 'dart:ffi';

import 'package:asignment_task/Model/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Model/model.dart';
import '../Model/toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override


  int _currentIndex = 0;

  final List<Widget> _tabs = [
    HomeTab(),
    ProfileTab(),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // title: const Text("HomePage"),
        ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),



        body:_tabs[_currentIndex]
    );
  }

}






class HomeTab extends StatelessWidget {


  Stream<List<UserModel>> _readData(){
    final userCollection = FirebaseFirestore.instance.collection("users");

    return userCollection.snapshots().map((qureySnapshot)
    => qureySnapshot.docs.map((e)
    => UserModel.fromSnapshot(e),).toList());
  }

  void _createData(UserModel userModel) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    String id = userCollection.doc().id;

    final newUser = UserModel(
      username: userModel.username,
      age: userModel.age,
      adress: userModel.adress,
      id: id,
    ).toJson();

    userCollection.doc(id).set(newUser);
  }

  void _updateData(UserModel userModel) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    final newData = UserModel(
      username: userModel.username,
      id: userModel.id,
      adress: userModel.adress,
      age: userModel.age,
    ).toJson();

    userCollection.doc(userModel.id).update(newData);

  }

  void _deleteData(String id) {
    final userCollection = FirebaseFirestore.instance.collection("users");

    userCollection.doc(id).delete();

  }




  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              _createData(UserModel(
                username: "Henry",
                age: 21,
                adress: "London",
              ));
            },
            child: Container(
              height: 45,
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20)),
              child: const Center(
                child: Text(
                  "Create Data",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          StreamBuilder<List<UserModel>>(
              stream: _readData(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: Text('Add new data'));
                } if(snapshot.data!.isEmpty){
                  return const Center(child:Text("No Data Yet"));
                }
                final users = snapshot.data;
                return Padding(padding: EdgeInsets.all(8),
                  child: Column(
                      children: users!.map((user) {
                        return ListTile(
                          leading: GestureDetector(
                            onTap: (){
                              _deleteData(user.id!);
                            },
                            child: const Icon(Icons.delete),
                          ),
                          trailing: GestureDetector(
                            onTap: (){
                              _updateData(
                                  UserModel(
                                    id: user.id,
                                    username: "John Wick",
                                    adress: "Pakistan",)
                              );
                            },
                            child: const Icon(Icons.update),
                          ),
                          title: Text(user.username!),
                          subtitle: Text(user.adress!),
                        );
                      }).toList()
                  ),);
              }
          ),





        ],
      ));

  }
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [

          CustomWidget(
            icon: Icons.arrow_forward_ios,
            name: 'Edit Profile',
          ),

          const SizedBox(height: 20),

          CustomWidget(
            icon: Icons.arrow_forward_ios,
            name: 'Notification',
          ),

          const SizedBox(height: 20),

          CustomWidget(
            icon: Icons.arrow_forward_ios,
            name: 'Language',
          ),

          const SizedBox(height: 20),

          CustomWidget(
            icon: Icons.arrow_forward_ios,
            name: 'Privacy policy ',
          ),


          const SizedBox(height: 20),

          CustomWidget(
            icon: Icons.arrow_forward_ios,
            name: 'Help Center',
          ),

          const SizedBox(height: 20),

          CustomWidget(
            icon: Icons.arrow_forward_ios,
            name: 'Invite Friends',
          ),




          const SizedBox(height: 150),

          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, "/login");
              showToast(message: "Successfully signed out");
            },
            child: Container(
              height: 45,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20)),
              child: const Center(
                child: Text(
                  "Sign out",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
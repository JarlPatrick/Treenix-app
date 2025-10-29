import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final GoogleSignInAccount user;
  const Home({
    super.key,
    required this.user,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = "";
  String userId = "";
  String email = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loaring();
  }

  Future<void> _handleSignOut() async {
    // Disconnect instead of just signing out, to reset the example state as
    // much as possible.
    await GoogleSignIn.instance.disconnect();
  }

  void loaring() async {
    if (widget.user.authentication.idToken == null) {
      return;
    }
    String idToken = widget.user.authentication.idToken!;
    final response = await http.post(
      Uri.parse(
          'https://6iks67rav1.execute-api.eu-north-1.amazonaws.com/default/google-test'),
      headers: {'Authorization': 'Bearer $idToken'},
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    setState(() {
      name = data["name"];
      userId = data["userId"];
      email = data["email"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Treenix')),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name),
            Text(email),
            Text(userId),
            ElevatedButton(
                onPressed: _handleSignOut, child: const Text('SIGN OUT')),
          ],
        ),
      ),
    );
  }
}

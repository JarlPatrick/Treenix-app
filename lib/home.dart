import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
          'https://6iks67rav1.execute-api.eu-north-1.amazonaws.com/default/user-get-profile'),
      headers: {'Authorization': 'Bearer $idToken'},
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    setState(() {
      name = data["name"];
      userId = data["userId"];
      email = data["email"];
    });
  }

  Future<void> _authenticate() async {
    final String CLIENTID = '111297'; // Replace with your client ID
    // Generate Strava OAuth URL
    final String redirectUri = 'https://treenix.ee/';

    String state = jsonEncode({"userId": userId});
    // final String redirectUri = 'treenix://auth/strava';
    final authUrl = Uri.parse('https://www.strava.com/oauth/mobile/authorize?'
        'client_id=$CLIENTID&response_type=code&redirect_uri=$redirectUri&approval_prompt=auto&scope=read,activity:read_all&state=$state');

    // Open the URL in the browser
    await launchUrl(authUrl);
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
            ElevatedButton(
                onPressed: _authenticate, child: const Text('Strava connect')),
          ],
        ),
      ),
    );
  }
}

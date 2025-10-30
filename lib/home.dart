import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:home_widget/home_widget.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'j-index.dart';
import 'widget_streak.dart';

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
  List<Map<String, dynamic>> activities = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading();
    getActivities();
  }

  Future<void> _handleSignOut() async {
    // Disconnect instead of just signing out, to reset the example state as
    // much as possible.
    await GoogleSignIn.instance.disconnect();
  }

  void loading() async {
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

  void getActivities() async {
    if (widget.user.authentication.idToken == null) {
      return;
    }
    String idToken = widget.user.authentication.idToken!;
    final response = await http.post(
      Uri.parse(
          'https://6iks67rav1.execute-api.eu-north-1.amazonaws.com/default/request-all-athletes-activities'),
      headers: {'googletoken': idToken},
    );
    final _activities = jsonDecode(response.body);
    activities = [];
    for (var activity in _activities) {
      activities.add(activity);
    }
    setState(() {});
  }

  Future<void> _authenticate() async {
    final String CLIENTID = '111297';
    final String redirectUri = 'https://treenix.ee/';
    String idToken = widget.user.authentication.idToken!;
    final authUrl = Uri.parse('https://www.strava.com/oauth/mobile/authorize?'
        'client_id=$CLIENTID&response_type=code&redirect_uri=$redirectUri&approval_prompt=auto&scope=read,activity:read_all&state=$idToken');
    await launchUrl(authUrl);
  }

  @override
  Widget build(BuildContext context) {
    // print(activities.first);
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
            if (activities.length > 0) ...[
              SizedBox(height: 20),
              TreenixStreak(
                allActivities: activities,
              ),
              SizedBox(height: 20),
              JarlsNumber(
                allActivities: activities,
                // viewStateCallback: changeViewState,
                year: 2025,
              ),
            ] else ...[
              ElevatedButton(
                  onPressed: _authenticate,
                  child: const Text('Strava connect')),
            ],
            Spacer(),
            ElevatedButton(
              onPressed: _handleSignOut,
              child: const Text('SIGN OUT'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

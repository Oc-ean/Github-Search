import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:github_search_app/pages/error.data.dart';
import 'package:github_search_app/utils/loading.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final dynamic user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState(user);
}

class _ProfilePageState extends State<ProfilePage> {
  final String user;
  _ProfilePageState(this.user);
  dynamic data, repo;

  Future<void> makeRequest(users) async {
    String url = 'https://api.github.com/users/$users';
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    setState(() {
      data = jsonDecode(response.body);
    });
    print('data => $data');
  }

  Future<void> repoRequest(users) async {
    String url = 'https://api.github.com/users/$users/repos';
    var response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
    setState(() {
      repo = jsonDecode(response.body);
    });
    print('repo => $repo');
    print('repo length => ${repo.length}');
  }

  @override
  void initState() {
    makeRequest(user);
    repoRequest(user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Loading();
    }
    if (data['message'].toString().compareTo('Not Found') == 0 &&
        data != null) {
      return const ErrorPage();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      AntDesign.github,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: repo == null ? 0 : repo.length + 1,
              itemBuilder: (BuildContext context, i) {
                if (i == 0) {
                  return _myDetails();
                }
                i -= 1;
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Octicons.repo,
                              color: Colors.white,
                              size: 45,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                repo[i]['name'].toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                repo[i]['full_name'].toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white24,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          FontAwesome5Solid.circle,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          repo[i]['language'].toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }

  Widget _myDetails() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Stack(
                    children: [
                      ClipOval(
                        child: Container(
                          color: Colors.white10,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height / 8,
                            width: MediaQuery.of(context).size.height / 8,
                            child: Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: MediaQuery.of(context).size.height / 10,
                            ),
                          ),
                        ),
                      ),
                      ClipOval(
                        child: Image.network(
                          data['avatar_url'],
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height / 8,
                          width: MediaQuery.of(context).size.height / 8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        data['name'].toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.height / 28),
                      ),
                      subtitle: Text(
                        data['login'].toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.height / 37),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            data['bio'] == null
                ? const Center()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white12,
                      ),
                      width: MediaQuery.of(context).size.width - 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          data['bio'].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  data['blog'].toString().compareTo('') == 0
                      ? const Center()
                      : Row(
                          children: [
                            const Icon(
                              Icons.link,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              data['blog'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                  data['company'] == null
                      ? Container()
                      : Row(
                          children: [
                            const Icon(
                              Icons.people,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              data['company'],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            )
                          ],
                        ),
                  data['email'] == null
                      ? Container()
                      : Row(
                          children: [
                            const Icon(
                              Icons.mail,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              data['email'].toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            )
                          ],
                        ),
                  data['location'] == null
                      ? Container()
                      : Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              data['location'].toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            )
                          ],
                        ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              data['public_repos'].toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            const Text(
                              "Repositories",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                          child: VerticalDivider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              data['followers'].toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            const Text(
                              "Followers",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                          child: VerticalDivider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              data['following'].toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            const Text(
                              "Following",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

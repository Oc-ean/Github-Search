import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_search_app/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 80),
                child: Image.asset(
                  'images/GitHub.jpg',
                  scale: 1.2,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              '\tGitHub',
              style: TextStyle(
                  color: Colors.white, fontSize: 31, fontFamily: 'OpenSans'),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: 260,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white30),
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'GitHub Username',
                  hintStyle: TextStyle(
                    color: Colors.white30,
                  ),
                  contentPadding: EdgeInsets.only(left: 20),
                ),
                controller: _controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  print(_controller.text);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProfilePage(user: _controller.text)));
                }
              },
              child: Container(
                height: 50,
                width: 260,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.indigo),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      CupertinoIcons.search,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Search',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

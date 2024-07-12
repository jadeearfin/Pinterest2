import 'package:Pinterest/services/unsplash_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Pinterest/screen/main_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 3,
              children: List.generate(9, (index) {
                return Container(
                  child: FutureBuilder(
                    future: UnsplashService.getRandomPhoto(1),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.hasData) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  snapshot.data?.first.urls.thumb.toString() ??
                                      ""), // Replace with your API response
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text('No data'),
                        );
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Pinterest',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                autocorrect: false,
                controller: textController,
                decoration: InputDecoration(
                  labelText: 'Email address',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (textController.text.isEmpty) {
                    return;
                  }
                  if (textController.text != "abc@gmail.com") {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("email salah"),
                      backgroundColor: Colors.redAccent,
                    ));
                    return;
                  }
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Trigger the authentication flow
                  final GoogleSignInAccount? googleUser =
                      await GoogleSignIn().signIn();

                  if (googleUser == null) {
                    // The user canceled the sign-in
                    return;
                  }

                  // Obtain the auth details from the request
                  final GoogleSignInAuthentication googleAuth =
                      await googleUser.authentication;

                  if (googleAuth.accessToken == null &&
                      googleAuth.idToken == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Authentication failed"),
                      backgroundColor: Colors.redAccent,
                    ));
                    return;
                  }

                  // Create a new credential
                  final credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth.accessToken,
                    idToken: googleAuth.idToken,
                  );

                  // Once signed in, return the UserCredential
                  await FirebaseAuth.instance.signInWithCredential(credential);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                    (route) => false,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Error: $e"),
                    backgroundColor: Colors.redAccent,
                  ));
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/archive/c/c1/20221203181232%21Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png',
                    height: 24.0,
                    width: 24.0,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Continue with Google',
                    style: TextStyle(color: Colors.black),
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

import 'package:flutter/material.dart';

import 'components.dart';
import 'confirmdeleteaccount.dart';

class FirstDeleteAccount extends StatefulWidget {
  const FirstDeleteAccount({Key? key}) : super(key: key);

  @override
  State<FirstDeleteAccount> createState() => _FirstDeleteAccountState();
}

class _FirstDeleteAccountState extends State<FirstDeleteAccount> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Delete Account',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontFamily: Theme.of(context).textTheme.titleLarge!.fontFamily,
            ),
          ),
          centerTitle: true,
          elevation: 1.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              MyCustomBackIcon.iconData,
              color: Colors.black,
            ),
            onPressed: () {
              // Add any function to navigate to the previous screen here
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Are you sure you want to delete your account?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontFamily:
                            Theme.of(context).textTheme.titleLarge!.fontFamily,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'The action cannot be undone',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color.fromARGB(255, 168, 168, 168),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: Colors.grey[400],
                          size: 50,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Your public will be\npermanently removed.',
                            style: TextStyle(
                              fontSize: 22,
                              height: 1.5,
                              color: Color.fromARGB(255, 168, 168, 168),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.grey[400],
                          size: 50,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'All workout data and\nhistory will no longer be\naccessible.',
                            style: TextStyle(
                              fontSize: 22,
                              height: 1.5,
                              color: Color.fromARGB(255, 168, 168, 168),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.sync_disabled,
                          color: Colors.grey[400],
                          size: 50,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'All earned badges and\nachievements will be lost.',
                            style: TextStyle(
                              fontSize: 22,
                              height: 1.5,
                              color: Color.fromARGB(255, 168, 168, 168),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.42,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.grey[200]!,
                              ),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.42,
                          child: ElevatedButton(
                            onPressed: () {
                              navigateTo(
                                  context: context,
                                  widget: const ConfirmDeleteAccount());
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 253, 0, 0),
                              ),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Delete Account',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyCustomBackIcon {
  static IconData iconData = Icons.arrow_back_ios;
}

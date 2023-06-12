import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../calendar/calendar_screen.dart';
import '../model/Subject.dart';
import '../authentication/auth.dart';
import '../notifications/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' show NotificationResponse;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Subject> subjects = [
    Subject('Napredno Programiranje', "Feb 27, 2023 9:00 AM"),
    Subject('Operativni Sistemi', "Feb 28, 2023 10:00 AM"),
    Subject('Kompjuterski Mrezhi I Bezbednost', "Mar 10, 2023 11:00 AM"),
    Subject('Mobilni Informaciski Sistemi', "Mar 11, 2023 12:00 AM"),
    Subject('Internet Programiranje', "May 18, 2023 12:00 PM")
  ];

  final AuthService _authService = AuthService();
  User? _user;
  late final NotificationService notificationService;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
    notificationService = NotificationService();
    notificationService.initialize();
  }

  void _openCalendar() {
    Navigator.push(
      context,
        MaterialPageRoute(
        builder: (context) => CalendarScreen(subjects: subjects))
    );
  }

  void _checkCurrentUser() async {
    final User? user = await _authService.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  void _addSubject() {
    if (_user != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final TextEditingController nameController = TextEditingController();
          final TextEditingController dateController = TextEditingController();
          return AlertDialog(
            title: Text('Add Subject'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Subject Name',
                  ),
                ),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Date and Time',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final String name = nameController.text;
                  final String date = dateController.text;
                  setState(() {
                    subjects.add(Subject(name, date));
                  });
                  Navigator.of(context).pop();
                  final DateTime subjectDate = DateFormat("MMM d, y h:mm a").parse(date);
                  final int secondsUntilNotification = subjectDate.difference(DateTime.now()).inSeconds;

                   notificationService.showScheduledNotification(
                    id: subjects.length, // Use a unique ID for each notification
                    title: 'Subject Reminder',
                    body: name,
                    seconds: secondsUntilNotification,
                  );
                },
                child: Text('Add'),
              ),
            ],
          );
        },
      );
    } else {
      _showSignInPrompt();
    }
  }

  // Show sign-in prompt
  void _showSignInPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController emailController = TextEditingController();
        final TextEditingController passwordController = TextEditingController();
        String? errorText;

        void signInWithEmailAndPassword() async {
          final String email = emailController.text.trim();
          final String password = passwordController.text;
          _user = await _authService.signInWithEmailAndPassword(email, password) ;
          Navigator.of(context).pop();
        }

        return AlertDialog(
          title: Text('Sign In'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: errorText,
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: errorText,
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: signInWithEmailAndPassword,
              child: Text('Sign In'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exams'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addSubject,
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _openCalendar,
          ),
          if (_user == null )
          ElevatedButton(
            onPressed: _showSignInPrompt,
            child: Icon(Icons.login)
          ),
          if (_user != null )
            ElevatedButton(
               onPressed: () {
                 _authService.signOut;
                 setState(() {
                   _user = null;
                 });
               },
                child: Icon(Icons.logout)
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (BuildContext context, int index) {
                final subject = subjects[index];
                final DateTime subjectDate =
                DateFormat("MMM d, y h:mm a").parse(subject.date);
                final String formattedDate =
                DateFormat.yMMMd().add_jm().format(subjectDate);
                return Card(
                  child: ListTile(
                    title: Text(
                      subject.subjectName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

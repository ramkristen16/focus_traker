import 'package:flutter/material.dart';
import 'package:focutraker/ViewModel/FocusTrakerViewModel.dart';
import 'package:provider/provider.dart';

import 'View/FocusTrakerView.dart';



void main() {
  runApp(const FocusTracker());
}

class FocusTracker extends StatelessWidget {
  const FocusTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FocusTrakerViewModel(), // notre ViewModel
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Focus Tracker',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: FocusTraker(), // la View
      ),
    );
  }
}

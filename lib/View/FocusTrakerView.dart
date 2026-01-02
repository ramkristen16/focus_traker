/*
========================================
VOTRE MISSION 🎯
========================================
Refactoriser en MVVM :
   - Model (Session, MentalState, Scores)
   - ViewModel (gestion du timer, logiques)
   - View (Widgets)
*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:focutraker/ViewModel/FocusTrakerViewModel.dart';
import 'package:provider/provider.dart';

class FocusTraker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FocusTrakerViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Focus Tracker"),
        backgroundColor: viewModel.moodColor,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),

            Text("Session Time:${viewModel.session.seconds} s", style: TextStyle(fontSize: 22)),

            SizedBox(height: 10),

            Text(
              "Focus Points: ${viewModel.score.focusPoints} s",
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            Text(
              "Distraction Points: ${viewModel.score.distractionPoints} s",
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),

            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: viewModel.moodColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    "Current Mental State",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    viewModel.mentalState.currentMood,
                    style: TextStyle(fontSize: 26, color : viewModel.moodColor),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: viewModel.startSession,
                    child: Text("START")),
                ElevatedButton(
                    onPressed: viewModel.stopSession,
                    child: Text("STOP")),
                ElevatedButton(
                  onPressed: viewModel.resetAll,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text("RESET"),
                ),
              ],
            ),
            SizedBox(height: 40),
            if (viewModel.shoWarning)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Warning: Mental drift detected!",
                  style: TextStyle(color: Colors.purple, fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
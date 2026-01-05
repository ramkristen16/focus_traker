/*
========================================
VOTRE MISSION 🎯
========================================
Refactoriser en MVVM :
   - Model (Session, MentalState, Scores)
   - ViewModel (gestion du timer, logiques)
   - View (Widgets)
*/

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
        centerTitle: true,
        backgroundColor: viewModel.moodColor,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Affichage du temps principal
            Text(
              viewModel.formattedTime,
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: (viewModel.session.isCountdown && viewModel.session.seconds < 10 && viewModel.session.seconds > 0)
                    ? Colors.red
                    : Colors.black,
              ),
            ),

            SizedBox(height: 15),

            // Scores Focus et Distraction
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text("Focus", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    Text("${viewModel.score.focusPoints}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(width: 50),
                Column(
                  children: [
                    Text("Distraction", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    Text("${viewModel.score.distractionPoints}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20),

            // État mental actuel
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: viewModel.moodColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: viewModel.moodColor.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  Text("Mental State", style: TextStyle(color: Colors.grey[700])),
                  SizedBox(height: 5),
                  Text(
                    viewModel.mentalState.currentMood.toUpperCase(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: viewModel.moodColor),
                  ),
                ],
              ),
            ),

            Spacer(),

            // Sélection de la durée (grisé si session en cours)
            IgnorePointer(
              ignoring: viewModel.session.isRunningSession,
              child: Opacity(
                opacity: viewModel.session.isRunningSession ? 0.4 : 1.0,
                child: Column(
                  children: [
                    Text("Set Duration:", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),

                    // Boutons de durée rapide
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () => viewModel.setTargetDuration(10),
                          child: Text("10m"),
                        ),
                        SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () => viewModel.setTargetDuration(30),
                          child: Text("30m"),
                        ),
                        SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () => viewModel.setTargetDuration(60),
                          child: Text("60m"),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    // Bouton durée personnalisée
                    ElevatedButton.icon(
                      icon: Icon(Icons.edit, size: 16),
                      label: Text("Custom"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white),
                      onPressed: () => _showCustomTimeDialog(context, viewModel),
                    ),

                    // Bouton reset vers mode infini
                    SizedBox(
                      height: 40,
                      child: viewModel.session.isCountdown
                          ? TextButton(
                        onPressed: () => viewModel.setCustomDuration(0, 0, 0),
                        child: Text("Reset to Infinite Mode"),
                      )
                          : null,
                    ),
                  ],
                ),
              ),
            ),

            Spacer(),

            // Warning (position fixe, ne bouge pas les autres éléments)
            SizedBox(
              height: 50,
              child: viewModel.shoWarning
                  ? Text(
                "Warning: Mental drift detected!",
                style: TextStyle(color: Colors.purple, fontSize: 18, fontWeight: FontWeight.bold),
              )
                  : null,
            ),

            // Boutons de contrôle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: viewModel.session.isRunningSession ? null : viewModel.startSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  ),
                  child: Text("START"),
                ),
                ElevatedButton(
                  onPressed: viewModel.session.isRunningSession ? viewModel.stopSession : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  ),
                  child: Text("STOP"),
                ),
                ElevatedButton(
                  onPressed: viewModel.resetAll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  ),
                  child: Text("RESET"),
                ),
              ],
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Dialog pour saisir une durée personnalisée HH:MM:SS
  void _showCustomTimeDialog(BuildContext context, FocusTrakerViewModel viewModel) {
    TextEditingController hoursController = TextEditingController(text: "00");
    TextEditingController minutesController = TextEditingController(text: "00");
    TextEditingController secondsController = TextEditingController(text: "00");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Set Custom Time", textAlign: TextAlign.center),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Heures
            SizedBox(
              width: 50,
              child: TextField(
                controller: hoursController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(labelText: "H", border: OutlineInputBorder()),
              ),
            ),
            Text(" : ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            // Minutes
            SizedBox(
              width: 50,
              child: TextField(
                controller: minutesController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(labelText: "M", border: OutlineInputBorder()),
              ),
            ),
            Text(" : ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            // Secondes
            SizedBox(
              width: 50,
              child: TextField(
                controller: secondsController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(labelText: "S", border: OutlineInputBorder()),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              int hours = int.tryParse(hoursController.text) ?? 0;
              int minutes = int.tryParse(minutesController.text) ?? 0;
              int seconds = int.tryParse(secondsController.text) ?? 0;

              viewModel.setCustomDuration(hours, minutes, seconds);
              Navigator.pop(ctx);
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
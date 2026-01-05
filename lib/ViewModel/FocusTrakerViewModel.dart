import 'dart:async';
import 'package:flutter/material.dart';
import 'package:focutraker/Model/mood.dart';
import 'package:focutraker/Model/score.dart';
import 'package:focutraker/Model/session.dart';


class FocusTrakerViewModel extends ChangeNotifier {
  Session _session = Session(seconds: 0, targetSeconds: 0, isCountdown: false);
  Score _score = Score(focusPoints: 0, distractionPoints: 0);
  MentalState _mentalState = MentalState.neutral();

  Timer? timer;

  Session get session => _session;
  Score get score => _score;
  MentalState get mentalState => _mentalState;

  // Formatage HH:MM:SS
  String get formattedTime {
    int totalSeconds = _session.seconds;
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}";;
  }

  // Configuration du Compte à Rebours (HH, MM, SS)
  void setCustomDuration(int h, int m, int s) {
    if (_session.isRunningSession) return;

    int totalSeconds = (h * 3600) + (m * 60) + s;

    if (totalSeconds > 0) {
      // Mode Décompte
      _session = _session.copyWith(
          seconds: totalSeconds,
          targetSeconds: totalSeconds,
          isCountdown: true
      );
    } else {
      // Mode Chrono Infini
      _session = _session.copyWith(
          seconds: 0,
          targetSeconds: 0,
          isCountdown: false
      );
    }

    _resetScoresOnly();
    notifyListeners();
  }

  // Raccourci pour les boutons rapides (minutes seulement)
  void setTargetDuration(int minutes) {
    setCustomDuration(0, minutes, 0);
  }

  void startSession() {
    if (_session.isRunningSession) return;
    // Empêcher de démarrer si le compte à rebours est fini (à 0)
    if (_session.isCountdown && _session.seconds <= 0) return;

    _session = _session.copyWith(isRunningSession: true);
    notifyListeners();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateEverySeconds();
    });
  }

  void stopSession() {
    timer?.cancel();
    _session = _session.copyWith(isRunningSession: false);
    notifyListeners();
  }

  void resetAll() {
    stopSession();
    _session = Session(seconds: 0, targetSeconds: 0, isCountdown: false);
    _score = Score(focusPoints: 0, distractionPoints: 0);
    _mentalState = MentalState.neutral();
    notifyListeners();
  }

  void _resetScoresOnly() {
    _score = Score(focusPoints: 0, distractionPoints: 0);
    _mentalState = MentalState.neutral();
  }

  void _updateEverySeconds() {
    // Logique Chrono vs Décompte
    if (_session.isCountdown) {
      if (_session.seconds > 0) {
        _session = _session.copyWith(seconds: _session.seconds - 1);
      } else {
        stopSession();
        _session = _session.copyWith(seconds: 0);
      }
    } else {
      _session = _session.copyWith(seconds: _session.seconds + 1);
    }

    // Calcul des points (basé sur l'activité qui tourne)
    if (_session.isRunningSession) {
      // Pour les calculs de points, on a besoin d'un compteur qui monte tout le temps
      // Si countdown: (TempsTotal - TempsRestant), Sinon: TempsActuel
      int timeActive = _session.isCountdown
          ? (_session.targetSeconds - _session.seconds)
          : _session.seconds;

      if (timeActive > 0) {
        if (timeActive % 5 == 0) {
          _score = _score.copyWith(focusPoints: _score.focusPoints + 2);
        }
        if (timeActive % 7 == 0) {
          _score = _score.copyWith(distractionPoints: _score.distractionPoints + 1);
        }
      }
      _updateMentalState();
      notifyListeners();
    }
  }

  void _updateMentalState() {
    if (_score.focusPoints - _score.distractionPoints > 20) {
      _mentalState = MentalState.ultrafocus();
    } else if (_score.distractionPoints > _score.focusPoints) {
      _mentalState = MentalState.distracted();
    } else {
      _mentalState = MentalState.neutral();
    }
  }

  Color get moodColor {
    if (_mentalState.currentMood == "Ultra focus") return Colors.green;
    if (_mentalState.currentMood == "Distracted") return Colors.red;
    return Colors.orange;
  }

  bool get shoWarning => _session.seconds > 0 && _session.seconds % 13 == 0;
}
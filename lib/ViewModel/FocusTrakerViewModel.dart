import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focutraker/Model/mood.dart';
import 'package:focutraker/Model/score.dart';
import 'package:focutraker/Model/session.dart';

class FocusTrakerViewModel extends ChangeNotifier{
  Session _session = Session(seconds: 0);
  Score _score = Score(focusPoints: 0, distractionPoints: 0);
  MentalState _mentalState = MentalState.neutral();

  Timer? timer;

  Session get session => _session;
  Score get score => _score;
  MentalState get mentalState => _mentalState;

  void startSession(){
    if(_session.isRunningSession) return;
    _session = _session.copyWith(isRunningSession: true);
    notifyListeners();

    timer = Timer.periodic(const Duration( seconds: 1),(_){
      _updateEverySeconds();
    });


  }
  void stopSession(){
    timer?.cancel();
    _session = _session.copyWith(isRunningSession: false);
    notifyListeners();
  }
  void resetAll(){
    stopSession();
    _session = Session(seconds: 0);
    _score = Score(focusPoints: 0, distractionPoints:0);
    _mentalState = MentalState.neutral();
    notifyListeners();
    
  }
  void _updateEverySeconds(){
      _session = _session.copyWith(seconds: _session.seconds + 1);

      if (_session.seconds % 5 == 0) {
        _score = _score.copyWith(
            focusPoints: _score.focusPoints + 2
        );
      }

       if (_session.seconds % 7 == 0){
         _score = _score.copyWith(
           distractionPoints: _score.distractionPoints + 1
         );
       }
       _updateMentalState();
       notifyListeners();
      }

      void _updateMentalState(){
        if(_score.focusPoints - _score.distractionPoints > 20){
          _mentalState = MentalState.ultrafocus();
        }
        else if (_score.distractionPoints > _score.focusPoints){
          _mentalState = MentalState.distracted();
        }
        else {
         _mentalState = MentalState.neutral();
        }

      }
      Color get moodColor{
        if(_mentalState.currentMood =="Ultra focus") return Colors.green;
        if(_mentalState.currentMood =="Distracted") return Colors.red;
        return Colors.orange;
      }
      bool get shoWarning => _session.seconds > 0 && _session.seconds % 13 == 0;
  }

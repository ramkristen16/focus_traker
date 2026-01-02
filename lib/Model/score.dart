class Score {
  int focusPoints;
  int distractionPoints;
  Score ({required this.focusPoints, required this.distractionPoints});

  Score copyWith({int? focusPoints, int? distractionPoints}){
    return Score(focusPoints: focusPoints ?? this.focusPoints,
                  distractionPoints: distractionPoints ?? this.distractionPoints);

  }


}
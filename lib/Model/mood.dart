class MentalState{
  String currentMood;
  MentalState ({required this.currentMood});

  factory MentalState.neutral(){
    return MentalState(currentMood: "Neutral");
  }
  factory MentalState.distracted(){
    return MentalState(currentMood:"Distracted");
  }
  factory MentalState.ultrafocus(){
    return MentalState(currentMood: "Ultra focus");
  }

}
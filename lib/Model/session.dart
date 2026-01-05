class Session {
  int seconds;        // Temps affiché actuel
  int targetSeconds;  // Durée initiale totale (pour la barre de progression si on veut plus tard)
  bool isRunningSession;
  bool isCountdown;   // NOUVEAU : true = compte à rebours, false = chrono normal

  Session({
    required this.seconds,
    this.targetSeconds = 0,
    this.isRunningSession = false,
    this.isCountdown = false, // Par défaut c'est un chrono normal
  });

  Session copyWith({
    int? seconds,
    int? targetSeconds,
    bool? isRunningSession,
    bool? isCountdown
  }) {
    return Session(
      seconds: seconds ?? this.seconds,
      targetSeconds: targetSeconds ?? this.targetSeconds,
      isRunningSession: isRunningSession ?? this.isRunningSession,
      isCountdown: isCountdown ?? this.isCountdown,
    );
  }
}
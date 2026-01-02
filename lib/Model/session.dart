class Session {
  int seconds ;
  bool isRunningSession;

  Session({required this.seconds , this.isRunningSession = false});

  Session copyWith({int? seconds, bool? isRunningSession}){
    return Session(seconds: seconds ?? this.seconds,
                    isRunningSession: isRunningSession ?? this.isRunningSession);
  }

}


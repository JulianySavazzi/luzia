class Call {
  String callerId;
  String receiverId;
  String channelId;
  bool hasDialled;

  Call({
    this.callerId,
    this.receiverId,
    this.channelId,
    this.hasDialled,
  });

  //to Map
  Map<String, dynamic> toMap(Call call) {
    Map<String, dynamic> callMap = Map();
    callMap["caller_id"] = call.callerId;
    callMap["receiver_id"] = call.receiverId;
    callMap["channel_id"] = call.channelId;
    callMap["has_dialled"] = call.hasDialled;
  }

  //from Map
  Call.fromMap(Map callMap) {
    this.callerId = callMap["caller_id"];
    this.receiverId = callMap["receiver_id"];
    this.channelId = callMap["channel_id"];
    this.hasDialled = callMap["has_dialled"];
  }
}

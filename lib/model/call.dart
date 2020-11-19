class Call {
  String callerId;
  String callerName;
  String receiverId;
  String receiverName;
  String channelId;
  bool hasDialled;
  bool accepted;
  bool rejected;


  Call({
    this.callerId,
    this.callerName,
    this.receiverId,
    this.receiverName,
    this.channelId,
    this.hasDialled,
    this.accepted,
    this.rejected,
  });

  //to Map
  Map<String, dynamic> toMap(Call call) {
    Map<String, dynamic> callMap = Map();
    callMap["caller_id"] = call.callerId;
    callMap["caller_name"] = call.callerName;
    callMap["receiver_id"] = call.receiverId;
    callMap["receiver_name"] = call.receiverName;
    callMap["channel_id"] = call.channelId;
    callMap["has_dialled"] = call.hasDialled;
    callMap["accepted"] = call.accepted;
    callMap["rejected"] = call.rejected;
    return callMap;
  }

  //from Map
  Call.fromMap(Map callMap) {
    this.callerId = callMap["caller_id"];
    this.callerName = callMap["caller_name"];
    this.receiverId = callMap["receiver_id"];
    this.receiverName = callMap["receiver_name"];
    this.channelId = callMap["channel_id"];
    this.hasDialled = callMap["has_dialled"];
    this.hasDialled = callMap["accepted"];
    this.hasDialled = callMap["rejected"];
  }
}

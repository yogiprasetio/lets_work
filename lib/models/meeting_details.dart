class MeetingDetail {
  String? id;
  String? hostId;
  String? hostName;

  MeetingDetail({this.hostId, this.hostName, this.id});

  factory MeetingDetail.fromJson(dynamic json) {
    return MeetingDetail(
      id: json["id"],
      hostId: json["hostId"],
      hostName: json["hostName"],
    );
  }
}

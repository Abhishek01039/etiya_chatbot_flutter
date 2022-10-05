class MessageData {
  MessageData({
    this.title,
    this.payload,
    this.feedbackExist,
    this.rate,
    this.comment,
    this.sessionId,
  });

  String? title;
  String? payload;
  bool? feedbackExist;
  String? rate;
  String? comment;
  int? sessionId;

  factory MessageData.fromJson(Map<String, dynamic> json) => MessageData(
        title: json["title"] as String?,
        payload: json["payload"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "payload": payload,
        "feedbackExist": feedbackExist,
        "rate": rate,
        "comment": comment,
        "sessionId": sessionId,
      };
}

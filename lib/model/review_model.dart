class CommentModel {
  String? commentId;
  String commentedUserId;
  String postOwnnerId;
  String postId;
  String comment;
  String date;
  String time;

  CommentModel(
      {required this.date,
      this.commentId,
      required this.commentedUserId,
      required this.postId,
      required this.comment,
      required this.time,
      required this.postOwnnerId});

  Map<String, dynamic> toJson(id) => {
        "commentId": id,
        "commentedUserId":commentedUserId,
        "postOwnnerId": postOwnnerId,
        "postId": postId,
        "comment": comment,
        "date": date,
        "time": time
      };

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
        date: json["date"],
        commentId: json["commentId"],
        commentedUserId:json["commentedUserId"],
        postId: json["postId"],
        comment: json["comment"],
        time: json["time"],
        postOwnnerId: json["postOwnnerId"]);
  }
}

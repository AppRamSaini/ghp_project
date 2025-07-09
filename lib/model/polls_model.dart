import 'dart:convert';

PollsModel pollsModelFromJson(String str) =>
    PollsModel.fromJson(json.decode(str));

String pollsModelToJson(PollsModel data) => json.encode(data.toJson());

class PollsModel {
  bool status;
  String message;
  List<POllList> data;

  PollsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PollsModel.fromJson(Map<String, dynamic> json) => PollsModel(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] != null
            ? List<POllList>.from(json["data"].map((x) => POllList.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class POllList {
  int id;
  String title;
  List<Option> options;
  DateTime endDate;
  bool hasVoted;
  bool isExpired;
  String endMsg;

  POllList({
    required this.id,
    required this.title,
    required this.options,
    required this.endDate,
    required this.hasVoted,
    required this.isExpired,
    required this.endMsg,
  });

  factory POllList.fromJson(Map<String, dynamic> json) => POllList(
        id: json["id"] ?? 0,
        title: json["title"] ?? "",
        options: json["options"] != null
            ? List<Option>.from(json["options"].map((x) => Option.fromJson(x)))
            : [],
        endDate: json["end_date"] != null
            ? DateTime.parse(json["end_date"])
            : DateTime.now(),
        hasVoted: json["has_voted"] ?? false,
        isExpired: json["is_expired"] ?? false,
        endMsg: json["end_msg"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "has_voted": hasVoted,
        "is_expired": isExpired,
        "end_msg": endMsg,
      };
}

class Option {
  int id;
  int pollId;
  String optionText;
  int votesCount;

  Option({
    required this.id,
    required this.pollId,
    required this.optionText,
    required this.votesCount,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json["id"] ?? 0,
        pollId: json["poll_id"] ?? 0,
        optionText: json["option_text"] ?? "",
        votesCount: json["votes_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "poll_id": pollId,
        "option_text": optionText,
        "votes_count": votesCount,
      };
}

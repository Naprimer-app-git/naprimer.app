import 'package:naprimer_app_v2/domain/video/abstract_video_item.dart';

//todo discuss what fields are required

class VideoItem implements AbstractVideoItem {
  VideoItem({
    required this.id,
    required this.authorId,
    this.authorAvatar,
    this.authorNickname,
    required this.authorName,
    this.access,
    required this.uploadState,
    required this.title,
    this.description,
    required this.stream,
    this.imagePreview,
    this.animatedPreview,
    this.createdAt,
    this.modifiedAt,
    this.releasedAt,
    this.accessUpdAt,
    this.userReactions = const [],
    required this.interactions,
    this.commentsCount = 0,
    this.upload,
  });

  String id;
  String authorId;
  String? authorAvatar;
  String? authorNickname;
  String authorName;
  String? access;
  String uploadState;
  String title;
  String? description;
  String stream;
  String? imagePreview;
  String? animatedPreview;
  DateTime? createdAt;
  DateTime? modifiedAt;
  DateTime? releasedAt;
  DateTime? accessUpdAt;
  List<dynamic> userReactions;
  _Interactions interactions = _Interactions();
  int commentsCount;
  Upload? upload;


  factory VideoItem.fromJson(Map<String, dynamic> json, String baseUrl) =>
      VideoItem(
          id: json["id"],
          authorId: json["author_id"],
          authorAvatar: json["author_avatar"] ?? "",
          authorNickname: json["author_nickname"],
          authorName: json["author_name"],
          access: json["access"],
          uploadState: json["upload_state"],
          upload: json["upload"] == null ? null : Upload.fromJson(json["upload"]),
          title: json["title"],
          description: json["description"],
          stream: json["stream"],
          imagePreview: json["image_preview"],
          animatedPreview: json["animated_preview"],
          createdAt: DateTime.parse(json["created_at"]),
          modifiedAt: DateTime.parse(json["modified_at"]),
          releasedAt: DateTime.parse(json["released_at"]),
          accessUpdAt: DateTime.parse(json["access_upd_at"]),
          userReactions: json["user_reactions"] == null ? [] :
          List<dynamic>.from(json["user_reactions"].map((x)=>x)),
  interactions
      :json["interactions"]==null?_Interactions()
      : _Interactions.fromJson(json["interactions"]),commentsCount:json["comments_count"],);

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "author_id": authorId,
        "author_avatar": authorAvatar,
        "author_nickname": authorNickname,
        "author_name": authorName,
        "access": access,
        "upload_state": uploadState,
        "upload": upload == null ? null : upload?.toJson(),
        "title": title,
        "description": description,
        "stream": stream,
        "image_preview": imagePreview,
        "animated_preview": animatedPreview,
        "created_at": createdAt?.toIso8601String(),
        "modified_at": modifiedAt?.toIso8601String(),
        "released_at": releasedAt?.toIso8601String(),
        "access_upd_at": accessUpdAt?.toIso8601String(),
        "user_reactions": List<dynamic>.from(userReactions.map((x) => x)),
        "interactions": interactions.toJson(),
        "comments_count": commentsCount,
      };


  @override
  bool operator ==(other) =>
      identical(this, other) ||
          other is VideoItem &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

}

class _Interactions {
  _Interactions({
    this.viewsCount = 0,
    this.likesCount = 0,
  });

  int viewsCount;
  int likesCount;

  factory _Interactions.fromJson(Map<String, dynamic> json) =>
      _Interactions(
        viewsCount: json["views_count"],
        likesCount: json["likes_count"],
      );

  Map<String, dynamic> toJson() =>
      {
        "views_count": viewsCount,
        "likes_count": likesCount,
      };
}

class Upload {
  Upload({
    this.error,
    this.state,
    this.url,
  });

  String? error;
  String? state;
  String? url;

  factory Upload.fromJson(Map<String, dynamic> json) => Upload(
    error: json["error"] == null ? null : json["error"],
    state: json["state"] == null ? null : json["state"],
    url: json["url"] == null ? null : json["url"],
  );

  Map<String, dynamic> toJson() => {
    "error": error == null ? null : error,
    "state": state == null ? null : state,
    "url": url == null ? null : url,
  };
}


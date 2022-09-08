import 'package:swifty_chat_data/swifty_chat_data.dart';

class MessageResponse {
  MessageResponse(
      {this.id,
      this.sessionId,
      this.type,
      this.text,
      this.rawMessage,
      this.direction,
      // this.session,
      this.ts,
      this.userId,
      this.user,
      this.thank});

  String? id;
  String? sessionId;
  String? type;
  String? text;
  String? thank;
  RawMessage? rawMessage;

  // Session? session;
  String? direction;
  DateTime? ts;
  String? userId;
  EtiyaChatUser? user;

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      MessageResponse(
        id: json["id"] as String?,
        sessionId: json["sessionId"] as String?,
        // session: json["session"] == null ? null : Session.fromJson(json["session"]),
        type: json["type"] as String?,
        text: json["text"] as String?,
        thank: json["thank"] as String?,
        rawMessage: json["rawMessage"] == null
            ? null
            : RawMessage.fromJson(
                json["rawMessage"] as Map<String, dynamic>,
              ),
        direction: json["direction"] as String?,
        ts: json["ts"] == null ? null : DateTime.parse(json["ts"] as String),
        userId: json["userId"] as String?,
        user: json["user"] == null
            ? null
            : EtiyaChatUser.fromJson(json["user"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sessionId": sessionId,
        "type": type,
        "text": text,
        "rawMessage": rawMessage?.toJson(),
        "direction": direction,
        "ts": ts?.toIso8601String(),
        "userId": userId,
        "user": user?.toJson(),
      };

  bool get hasQuickReply {
    final qrCount = rawMessage?.data?.payload?.quickReplies?.length ?? 0;
    return type == 'text' && qrCount != 0;
  }

  bool get hasImage {
    // final mimeType = rawMessage?.data?.payload?.mime;
    return type == 'file'; // && mimeType.contains("image")
  }
}

class RawMessage {
  RawMessage({
    this.to,
    this.data,
    this.type,
    this.channel,
    this.carrier,
  });

  String? to;
  Data? data;
  String? type;
  String? channel;
  String? carrier;

  factory RawMessage.fromJson(Map<String, dynamic> json) => RawMessage(
        to: json["to"] as String?,
        data: json["data"] == null
            ? null
            : Data.fromJson(json["data"] as Map<String, dynamic>),
        type: json["type"] as String?,
        channel: json["channel"] as String?,
        carrier: json["__carrier"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "to": to,
        "data": data?.toJson(),
        "type": type,
        "channel": channel,
        "__carrier": carrier,
      };
}

class Data {
  Data({
    this.text,
    this.extras,
    this.payload,
  });

  String? text;
  Extras? extras;
  Payload? payload;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        text: json["text"] as String?,
        extras: json["extras"] == null
            ? null
            : Extras.fromJson(json["extras"] as Map<String, dynamic>),
        payload: json["payload"] == null
            ? null
            : Payload.fromJson(json["payload"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "extras": extras?.toJson(),
        "payload": payload?.toJson(),
      };
}

class Extras {
  Extras({
    this.language,
    this.sourceID,
    this.threadID,
    this.categoryIDS,
    this.inReplyToID,
    this.firstInThread,
    this.inReplyToAuthorID,
  });

  String? language;
  String? sourceID;
  String? threadID;
  List<String>? categoryIDS;
  String? inReplyToID;
  bool? firstInThread;
  String? inReplyToAuthorID;

  factory Extras.fromJson(Map<String, dynamic> json) => Extras(
        language: json["language"] as String?,
        sourceID: json["source_id"] as String?,
        threadID: json["thread_id"] as String?,
        categoryIDS: json["category_ids"] as List<String>?,
        inReplyToID: json["in_reply_to_id"] as String?,
        firstInThread: json["first_in_thread"] as bool?,
        inReplyToAuthorID: json["in_reply_to_author_id"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "language": language,
        "source_id": sourceID,
        "thread_id": threadID,
        "category_ids": categoryIDS,
        "in_reply_to_id": inReplyToID,
        "first_in_thread": firstInThread,
        "in_reply_to_author_id": inReplyToAuthorID
      };
}

// MARK: - Element 👍🏻
class Element {
  Element({this.title, this.buttons, this.picture, this.subtitle});

  String? title;
  List<CarouselButton>? buttons;
  String? picture;
  String? subtitle;

  factory Element.fromJson(Map<String, dynamic> json) => Element(
        title: json["title"] as String?,
        buttons: json["buttons"] == null
            ? null
            : List<CarouselButton>.from(
                json["buttons"].map(
                  (x) => CarouselButton.fromJson(x as Map<String, dynamic>),
                ) as Iterable,
              ),
        picture: json["picture"] as String?,
        subtitle: json["subtitle"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "buttons": buttons,
        "picture": picture,
        "subtitle": subtitle,
      };

  @override
  toString() => toJson().toString();
}

class Emojis {
  String? title;
  String? value;
  Emojis({
    this.title,
    this.value,
  });

  factory Emojis.fromJson(Map<String, dynamic> json) => Emojis(
        title: json["title"] as String?,
        value: json["value"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
      };
}

// MARK: - CarouselButton 👍🏻
class CarouselButton {
  CarouselButton({
    this.url,
    this.title,
    this.payload,
    this.value,
  });

  String? url;
  String? title;
  String? payload;
  String? value;

  factory CarouselButton.fromJson(Map<String, dynamic> json) => CarouselButton(
        url: json["url"] as String?,
        title: json["title"] as String?,
        payload: json["payload"] as String?,
        value: json["value"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "title": title,
        "payload": payload,
        "value": value,
      };
}

// MARK: - QuickReply 👍🏻
class QuickReply {
  QuickReply({this.title, this.payload});

  String? title;
  String? payload;

  factory QuickReply.fromJson(Map<String, dynamic> json) => QuickReply(
        title: json["title"] as String?,
        payload: json["payload"] as String?,
      );

  Map<String, dynamic> toJson() => {"title": title, "payload": payload};
}

class Payload {
  Payload({
    this.typing,
    this.markdown,
    this.conversationId,
    this.quickReplies,
    this.elements,
    this.emojiText,
    this.mime,
    this.url,
    this.text,
    this.thank,
    this.title,
  });

  int? typing;
  bool? markdown;
  String? conversationId;
  List<QuickReply>? quickReplies;
  List<Element>? elements;
  List<Emojis>? emojiText;
  String? mime;
  String? url;
  String? text;
  String? thank;
  String? title;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        typing: json["typing"] as int?,
        markdown: json["markdown"] as bool?,
        conversationId: json["conversationId"] as String?,
        quickReplies: json["quick_replies"] == null
            ? null
            : List<QuickReply>.from(
                json["quick_replies"].map(
                  (x) => QuickReply.fromJson(x as Map<String, dynamic>),
                ) as Iterable,
              ),
        elements: json["elements"] == null
            ? null
            : List<Element>.from(
                json["elements"].map(
                  (x) => Element.fromJson(x as Map<String, dynamic>),
                ) as Iterable,
              ),
        emojiText: json["emojiText"] == null
            ? null
            : List<Emojis>.from(
                json["emojiText"].map(
                  (x) => Emojis.fromJson(x as Map<String, dynamic>),
                ) as Iterable,
              ),
        mime: json["mime"] as String?,
        url: json["url"] as String?,
        text: json["text"] as String?,
        thank: json["thank"] as String?,
        title: json["title"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "typing": typing,
        "markdown": markdown,
        "conversationId": conversationId,
        "quick_replies": quickReplies,
        "elements": elements,
        "emojiText": emojiText,
        "mime": mime,
        "url": url,
        "text": text,
        "thank": thank,
        "title": title,
      };
}

class EtiyaChatUser extends ChatUser {
  EtiyaChatUser({
    this.fullName,
    this.isOnline,
    this.id,
    this.userId,
    this.platform,
    this.gender,
    this.pictureUrl,
    this.firstName,
    this.lastName,
    this.locale,
    this.createdOn,
    this.userType,
    this.platformId,
  }) : super(userName: fullName ?? "", avatar: null);

  String? fullName;
  bool? isOnline;
  String? id;
  String? userId;
  String? platform;
  String? gender;
  String? pictureUrl;
  String? firstName;
  String? lastName;
  String? locale;
  DateTime? createdOn;
  String? userType;
  String? platformId;

  @override
  String get userName => fullName ?? 'userName';

  Uri? get avatarURL {
    return null;
  }

  factory EtiyaChatUser.fromJson(Map<String, dynamic> json) => EtiyaChatUser(
        fullName: json["fullName"] as String?,
        isOnline: json["isOnline"] as bool?,
        id: json["id"] as String?,
        userId: json["userId"] as String?,
        platform: json["platform"] as String?,
        gender: json["gender"] as String?,
        pictureUrl: json["pictureUrl"] as String?,
        firstName: json["firstName"] as String?,
        lastName: json["lastName"] as String?,
        locale: json["locale"] as String?,
        createdOn: (json["createdOn"] as String?) == null
            ? null
            : DateTime.parse(json["createdOn"] as String),
        userType: json["userType"] as String?,
        platformId: json["platformId"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "isOnline": isOnline,
        "id": id,
        "userId": userId,
        "platform": platform,
        "gender": gender,
        "pictureUrl": pictureUrl,
        "firstName": firstName,
        "lastName": lastName,
        "locale": locale,
        "createdOn": createdOn?.toIso8601String(),
        "userType": userType,
        "platformId": platformId,
      };
}

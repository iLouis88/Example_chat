enum Type { text, image, gif }

class MessageModel {
  MessageModel({
    required this.toId,
    required this.msg,
    required this.read,
    required this.type,
    required this.fromId,
    required this.sent,
  });

  final String toId;
  final String msg;
  final String read;
  final String fromId;
  final String sent;
  final Type type;

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final toId = json['toId'];
    final msg = json['msg'];
    final read = json['read'];
    final type =
        json['type'].toString() == Type.image.name ? Type.image : Type.text;
    final fromId = json['fromId'];
    final sent = json['sent'];

    return MessageModel(
        toId: toId,
        msg: msg,
        read: read,
        type: type,
        fromId: fromId,
        sent: sent);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['msg'] = msg;
    data['read'] = read;
    data['type'] = type.name;
    data['fromId'] = fromId;
    data['sent'] = sent;
    return data;
  }
}

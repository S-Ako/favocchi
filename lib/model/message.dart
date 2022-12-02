class MessageModel {
  String message;
  String description;
  String sysMessage;
  bool sysErr;

  MessageModel({
    required this.message,
    this.description = '',
    this.sysMessage = '',
    this.sysErr = false,
  });
}

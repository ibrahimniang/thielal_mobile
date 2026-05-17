class MessageModel {
  final int idMessage;
  final int conversationId;
  final int expediteurId;
  final String contenu;
  final DateTime dateEnvoi;
  final bool lu;

  MessageModel({
    required this.idMessage,
    required this.conversationId,
    required this.expediteurId,
    required this.contenu,
    required this.dateEnvoi,
    required this.lu,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      idMessage: json['id_message'],
      conversationId: json['conversation_id'],
      expediteurId: json['expediteur_id'],
      contenu: json['contenu'],
      dateEnvoi: DateTime.parse(json['date_envoi']),
      lu: json['lu'] ?? false,
    );
  }
}
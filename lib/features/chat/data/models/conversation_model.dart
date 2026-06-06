class ConversationModel {
  final int idConversation;
  final int utilisateur1Id;
  final int utilisateur2Id;
  final String? dernierMessage;
  final DateTime? dateDernierMessage;
  final int? demandeId;

  ConversationModel({
    required this.idConversation,
    required this.utilisateur1Id,
    required this.utilisateur2Id,
    this.dernierMessage,
    this.dateDernierMessage,
     this.demandeId,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      idConversation: json['id_conversation'],
      utilisateur1Id: json['utilisateur1_id'],
      utilisateur2Id: json['utilisateur2_id'],
      dernierMessage: json['dernier_message'],
      dateDernierMessage: json['date_dernier_message'] != null
          ? DateTime.parse(json['date_dernier_message'])
          : null,
      demandeId: json['demande_id'],
    );
  }
}
class VertexModel {
  String eType;
  bool directed;
  String fromId;
  String fromType;
  String toId;
  String toType;
  Map attributes;
  bool isExpanded;

  VertexModel({
    required this.eType,
    required this.directed,
    required this.fromId,
    required this.fromType,
    required this.toId,
    required this.toType,
    required this.attributes,
    this.isExpanded = false,
  });

  factory VertexModel.fromJson(Map<String, dynamic> json) {
    return VertexModel(
      eType: json['e_type'],
      directed: json['directed'],
      fromId: json['from_id'],
      fromType: json['from_type'],
      toId: json['to_id'],
      toType: json['to_type'],
      attributes: json['attributes'],
    );
  }
}

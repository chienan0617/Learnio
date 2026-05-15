
class AiModel {
  final String gateway;
  final String id;
  final String name;
  final String desc;
  final bool enable;

  AiModel({
    required this.gateway,
    required this.id,
    required this.name,
    required this.desc,
    required this.enable,
  });

  factory AiModel.fromJson(Map<String, dynamic> json) {
    return AiModel(
      gateway: json['gate_way'] ?? '',
      id: json['id'] ?? json['name'] ?? '',
      name: json['name'] ?? '',
      desc: json['desc'] ?? '',
      enable: json['enable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gate_way': gateway,
      'id': id,
      'name': name,
      'desc': desc,
      'enable': enable,
    };
  }
}

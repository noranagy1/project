class DeviceCommand {
  final String id;
  final String command;
  final String status;
  final DateTime createdAt;

  DeviceCommand({
    required this.id,
    required this.command,
    required this.status,
    required this.createdAt,
  });

  factory DeviceCommand.fromJson(Map<String, dynamic> json) {
    return DeviceCommand(
      id: json['_id'] ?? '',
      command: json['command'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'command': command,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

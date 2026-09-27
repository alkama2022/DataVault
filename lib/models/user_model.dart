/// Application user model.
class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final double walletBalance;
  final double earnings;
  final String currentPlan;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.walletBalance = 0,
    this.earnings = 0,
    this.currentPlan = 'Free Plan',
    required this.createdAt,
  });

  UserModel copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    double? walletBalance,
    double? earnings,
    String? currentPlan,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      walletBalance: walletBalance ?? this.walletBalance,
      earnings: earnings ?? this.earnings,
      currentPlan: currentPlan ?? this.currentPlan,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'walletBalance': walletBalance,
        'earnings': earnings,
        'currentPlan': currentPlan,
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        email: json['email'] as String,
        phoneNumber: json['phoneNumber'] as String? ?? '',
        walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0,
        earnings: (json['earnings'] as num?)?.toDouble() ?? 0,
        currentPlan: json['currentPlan'] as String? ?? 'Free Plan',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );
}

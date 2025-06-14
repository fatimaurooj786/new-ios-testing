class DashboardData {
  final int beneficiaries;

  DashboardData({required this.beneficiaries});

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      beneficiaries: json['message']['beneficiaries'],
    );
  }
}

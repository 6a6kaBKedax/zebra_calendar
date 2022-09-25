class DayModel {
  final DateTime dayData;
  final bool? available;
  final Function(DateTime)? onTap;

  DayModel({
    required this.dayData,
    this.available,
    this.onTap,
  });
}

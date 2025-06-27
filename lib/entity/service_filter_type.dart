class ServiceFilterType {
  final String? img;
  final String label;
  final dynamic value;

  const ServiceFilterType({required this.label, required this.value, this.img});

  factory ServiceFilterType.fromJson(Map<String, dynamic> json) => ServiceFilterType(
    img: json['img'],
    value: json['serviceSubcategoryId'],
    label: json['serviceSubcategoryName'],
  );
}

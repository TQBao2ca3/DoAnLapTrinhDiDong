class Address {
  final String name;
  final String phone;
  final String address;
  bool isDefault;
  final String addressType;

  Address({
    required this.name,
    required this.phone,
    required this.address,
    this.isDefault = false,
    this.addressType = 'Nhà Riêng',
  });

  Address copyWith({
    String? name,
    String? phone,
    String? address,
    bool? isDefault,
    String? addressType,
  }) {
    return Address(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isDefault: isDefault ?? this.isDefault,
      addressType: addressType ?? this.addressType,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:phoneshop/models/Address.dart';
import 'package:phoneshop/pages/AddNewAddressPage%20.dart';

class AddressListPage extends StatefulWidget {
  final List<Address> addresses;
  final Address? selectedAddress;

  const AddressListPage({
    Key? key,
    required this.addresses,
    this.selectedAddress,
  }) : super(key: key);

  @override
  _AddressListPageState createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  late List<Address> addresses;
  Address? selectedAddress;

  @override
  void initState() {
    super.initState();
    addresses = List.from(widget.addresses);
    selectedAddress = widget.selectedAddress;
  }

  void _addNewAddress() async {
    final result = await Navigator.push<Address>(
      // Chỉ định kiểu rõ ràng
      context,
      MaterialPageRoute(builder: (context) => const AddNewAddressPage()),
    );

    if (result != null) {
      setState(() {
        if (result.isDefault) {
          // Bỏ mặc định của các địa chỉ khác
          for (var address in addresses) {
            address.isDefault = false;
          }
        }
        addresses.add(result);
        selectedAddress = result;
      });
      Navigator.pop(context, result); // Trả về đối tượng Address
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn địa chỉ nhận hàng'),
      ),
      body: ListView.builder(
        itemCount: addresses.length + 1,
        itemBuilder: (context, index) {
          if (index == addresses.length) {
            return TextButton(
              onPressed: _addNewAddress,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Thêm Địa Chỉ Mới',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          }

          final address = addresses[index];
          final isSelected = address == selectedAddress;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Radio<Address>(
                          value: address,
                          groupValue: selectedAddress,
                          onChanged: (Address? value) {
                            if (value != null) {
                              setState(() {
                                selectedAddress = value;
                              });
                              Navigator.pop(context, value);
                            }
                          },
                          activeColor: Colors.red,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                children: [
                                  Text(
                                    address.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    address.phone,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                address.address,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Implement edit address
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Sửa',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    if (address.isDefault)
                      Padding(
                        padding: const EdgeInsets.only(left: 48, top: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "Mặc định",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

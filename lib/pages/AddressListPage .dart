
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
    final result = await Navigator.push<Address>( // Chỉ định kiểu rõ ràng
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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

          return ListTile(
            leading: Radio<Address>(
              value: address,
              groupValue: selectedAddress,
              onChanged: (Address? value) {
                if (value != null) {
                  setState(() {
                    selectedAddress = value;
                  });
                  Navigator.pop(context, value); // Trả về đối tượng Address đã chọn
                }
              },
              activeColor: Colors.red,
            ),
            title: Row(
              children: [
                Text(
                  address.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Text(address.phone),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(address.address),
                if (address.isDefault)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
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
              ],
            ),
            trailing: TextButton(
              onPressed: () {
                // TODO: Implement edit address
              },
              child: const Text(
                'Sửa',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }
}
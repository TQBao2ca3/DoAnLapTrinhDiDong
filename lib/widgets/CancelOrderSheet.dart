import 'package:flutter/material.dart';

class CancelOrderSheet extends StatefulWidget {
  const CancelOrderSheet({Key? key}) : super(key: key);

  @override
  State<CancelOrderSheet> createState() => _CancelOrderSheetState();
}

class _CancelOrderSheetState extends State<CancelOrderSheet> {
  String? selectedReason;

  final List<String> cancelReasons = [
    'Tôi muốn cập nhật địa chỉ/sdt nhận hàng.',
    'Tôi muốn thêm/thay đổi Mã giảm giá',
    'Tôi muốn thay đổi sản phẩm (kích thước, màu sắc, số lượng...)',
    'Thủ tục thanh toán rắc rối',
    'Tôi tìm thấy chỗ mua khác tốt hơn (Rẻ hơn, uy tín hơn, giao nhanh hơn...)',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header với background màu xanh
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lý Do Hủy',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Info message với màu nền nhạt
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.blue[900], fontSize: 14),
                      children: const [
                        TextSpan(
                          text: 'Bạn có biết? ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'Bạn có thể cập nhật thông tin nhận hàng cho đơn hàng (1 lần duy nhất)\n',
                        ),
                        TextSpan(
                          text: 'Nếu bạn xác nhận hủy, toàn bộ đơn hàng sẽ được hủy.\n',
                        ),
                        TextSpan(
                          text: 'Chọn lý do hủy phù hợp nhất với bạn nhé!',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Radio buttons với màu accent xanh
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: cancelReasons.map((reason) {
                  return RadioListTile<String>(
                    title: Text(
                      reason,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                    value: reason,
                    groupValue: selectedReason,
                    activeColor: Colors.blue[600],
                    onChanged: (value) {
                      setState(() {
                        selectedReason = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),

          // Confirm button với gradient xanh
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + MediaQuery.of(context).padding.bottom),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedReason != null
                    ? () {
                  Navigator.pop(context, selectedReason);
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  disabledBackgroundColor: Colors.grey[200],
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Xác nhận',
                  style: TextStyle(
                    color: selectedReason != null ? Colors.white : Colors.grey[500],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
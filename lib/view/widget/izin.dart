import 'package:attendance_project/api/izin_service.dart'; // ganti sesuai path kamu
import 'package:attendance_project/utils/app_color.dart';
import 'package:flutter/material.dart';

class IzinPage extends StatefulWidget {
  const IzinPage({Key? key}) : super(key: key);

  @override
  State<IzinPage> createState() => _IzinPageState();
}

class _IzinPageState extends State<IzinPage> {
  final _formKey = GlobalKey<FormState>();
  final _alasanController = TextEditingController();
  DateTime? _selectedDate;
  String? _tipeIzin;
  bool _isLoading = false;

  final List<Map<String, String>> _tipeIzinOptions = [
    {'value': 'sakit', 'label': 'Izin Sakit'},
    {'value': 'keperluan_pribadi', 'label': 'Izin Keperluan Pribadi'},
    {'value': 'dinas', 'label': 'Izin Dinas'},
    {'value': 'keluarga', 'label': 'Izin Urusan Keluarga'},
    {'value': 'lainnya', 'label': 'Lainnya'},
  ];

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submitIzin() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _tipeIzin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lengkapi tanggal & tipe izin"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final izin = await IzinService.izinAbsen(
        date: _selectedDate!.toIso8601String().split("T")[0],
        alasanIzin: _alasanController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(izin.message ?? "Izin berhasil dikirim"),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _selectedDate = null;
        _tipeIzin = null;
        _alasanController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _alasanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AttendanceColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(35),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF67548e),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit_document, color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Permohonan Izin",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Sistem Absensi Digital",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Dropdown
              DropdownButtonFormField<String>(
                value: _tipeIzin,
                decoration: InputDecoration(
                  labelText: "Tipe Izin",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: _tipeIzinOptions
                    .map(
                      (opt) => DropdownMenuItem(
                        value: opt['value'],
                        child: Text(opt['label']!),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _tipeIzin = val),
                validator: (val) =>
                    val == null ? "Tipe izin harus dipilih" : null,
              ),
              const SizedBox(height: 20),

              // Date Picker
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Tanggal",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF67548e),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _selectedDate == null
                            ? "Pilih tanggal izin"
                            : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                        style: TextStyle(
                          color: _selectedDate == null
                              ? Colors.grey
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Alasan
              TextFormField(
                controller: _alasanController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Alasan Izin",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Alasan wajib diisi" : null,
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitIzin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF67548e),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "SUBMIT PERMOHONAN",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Trainer Dashboard',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: currentMode,
          home: const TrainerDashboard(),
        );
      },
    );
  }
}

class TrainerDashboard extends StatelessWidget {
  const TrainerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trainer Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (pickedDate != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Selected date: ${pickedDate.toLocal()}"),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No new notifications")),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              MyApp.themeNotifier.value =
              MyApp.themeNotifier.value == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Good Morning, Ayush!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            _buildCard(
              title: "Today's Bookings",
              content: "9:00 AM - John Doe\n10:30 AM - Jane Smith",
            ),
            const SizedBox(height: 16),

            _buildCard(
              title: "Earnings This Week",
              content: "\$420",
            ),
            const SizedBox(height: 16),

            _buildCard(
              title: "Upcoming Slot",
              content: "Today at 3:00 PM",
            ),
            const SizedBox(height: 16),

            _buildCard(
              title: "Profile Status",
              content: "✅ Verified",
            ),
            const SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddSlotScreen()),
                  );
                },
                child: const Text("Add New Slot"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildCard({required String title, required String content}) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
      ),
    );
  }
}

class AddSlotScreen extends StatefulWidget {
  const AddSlotScreen({super.key});

  @override
  State<AddSlotScreen> createState() => _AddSlotScreenState();
}

class _AddSlotScreenState extends State<AddSlotScreen> {
  final TextEditingController nameController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _pickTime() async {
    TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _saveSlot() {
    final name = nameController.text;
    if (name.isEmpty || selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields")),
      );
      return;
    }

    final fullDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Slot saved: $name at $fullDateTime")),
    );

    Navigator.pop(context); // Close screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Slot")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Name"),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "Enter name"),
            ),
            const SizedBox(height: 16),

            const Text("Date"),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(selectedDate == null
                  ? "Pick a date"
                  : "${selectedDate!.toLocal()}".split(" ")[0]),
              onPressed: _pickDate,
            ),
            const SizedBox(height: 16),

            const Text("Time"),
            ElevatedButton.icon(
              icon: const Icon(Icons.access_time),
              label: Text(selectedTime == null
                  ? "Pick a time"
                  : selectedTime!.format(context)),
              onPressed: _pickTime,
            ),
            const Spacer(),

            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Save Slot"),
                onPressed: _saveSlot,
              ),
            )
          ],
        ),
      ),
    );
  }
}

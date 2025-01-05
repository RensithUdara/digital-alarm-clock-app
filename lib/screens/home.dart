import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'custom_time_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentTime = "09:42";
  List<String> _alarms = ["09:42", "10:00", "12:30"]; // Example alarms

  void _addAlarm(String time) {
    setState(() {
      _alarms.add(time);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffa8c889),
      body: Column(
        children: [
          _buildClockContainer(),
          _buildDayRow(),
          _buildAlarmList(),
        ],
      ),
      persistentFooterButtons: [_buildFooterButtons()],
    );
  }

  Widget _buildClockContainer() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * 0.6,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(55),
            topRight: Radius.circular(55),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              children: [
                SizedBox(height: 60),
                Text(
                  "09:42",
                  style: TextStyle(
                    fontSize: 150,
                    color: Color(0xffa8c889),
                    height: 0,
                  ),
                ),
                Text(
                  "THE NEXT ALARM CLOCK IN 19 MIN",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xff69745F),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: CustomPaint(
                painter: ProgressPainter(5),
                size: const Size(double.infinity, 150),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
          .map((day) => Text(
                day,
                style: TextStyle(
                  fontSize: 22,
                  color: DateTime.now().weekday ==
                          ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'].indexOf(day) + 1
                      ? Colors.black
                      : const Color(0xff59644c),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildAlarmList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _alarms.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: DottedBorder(
                color: Colors.grey,
                strokeWidth: 2,
                dashPattern: const [5, 5],
                borderType: BorderType.RRect,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: 350,
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            _alarms[index],
                            style: const TextStyle(fontSize: 60),
                          ),
                          IconButton(
                            icon: const Icon(Icons.play_arrow, size: 70),
                            onPressed: () {
                              // Add functionality to play/pause alarm
                            },
                          ),
                        ],
                      ),
                      const Text(
                        "VATINOFE KIND OF BLUE",
                        style: TextStyle(fontSize: 24, color: Color(0xff69745f)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFooterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {
            // Add calendar functionality
          },
          icon: const Icon(
            Icons.calendar_month,
            color: Color(0xffa8c889),
          ),
          style: IconButton.styleFrom(
            backgroundColor: Colors.black,
            fixedSize: const Size(60, 60),
          ),
        ),
        SizedBox(
          width: 250,
          child: FloatingActionButton.extended(
            onPressed: () {
              // Add functionality to show current time
            },
            label: Text(
              _currentTime,
              style: const TextStyle(fontSize: 24),
            ),
            shape: const StadiumBorder(),
            backgroundColor: Colors.black,
            foregroundColor: const Color(0xffa8c889),
          ),
        ),
        IconButton(
          onPressed: () async {
            final selectedTime = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CustomTimePicker(),
              ),
            );
            if (selectedTime != null) {
              _addAlarm(selectedTime);
            }
          },
          icon: const Icon(
            Icons.add,
            color: Color(0xffa8c889),
          ),
          style: IconButton.styleFrom(
            backgroundColor: Colors.black,
            fixedSize: const Size(60, 60),
          ),
        ),
      ],
    );
  }
}

class ProgressPainter extends CustomPainter {
  final int totalBars = 40;
  final int currentProgress;

  ProgressPainter(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double barSpacing = size.width / totalBars;

    for (int i = 0; i < totalBars; i++) {
      paint.color = i < currentProgress ? const Color(0xff333333) : const Color(0xffa8c889);
      canvas.drawLine(Offset(i * barSpacing, size.height), Offset(i * barSpacing, 0), paint);
      if (i % 5 == 0 && i != currentProgress) {
        paint
          ..style = PaintingStyle.fill
          ..color = const Color(0xffa8c889);
        canvas.drawCircle(Offset(i * barSpacing, -30), 3, paint);
        paint.style = PaintingStyle.stroke;
      }
      paint.color = Colors.red;
      canvas.drawLine(
        Offset(currentProgress * barSpacing, size.height),
        Offset(currentProgress * barSpacing, 0),
        paint..strokeWidth = 3,
      );

      paint
        ..style = PaintingStyle.fill
        ..color = Colors.red;

      final path = Path();
      final arrowX = currentProgress * barSpacing;
      path.moveTo(arrowX, -20);
      path.lineTo(arrowX - 10, -40);
      path.lineTo(arrowX + 10, -40);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
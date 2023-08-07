import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'BuildCompleted.dart';

class StatusOrder extends StatefulWidget {
  const StatusOrder({super.key});

  @override
  State<StatusOrder> createState() => _StatusOrderState();
}

class _StatusOrderState extends State<StatusOrder> {
  int currentStep = 0;
  bool isCompleted = false;

  List<Step> getSteps() => [
        Step(
          title: Text('test2'),
          content: Container(),
        ),
        Step(
          title: Text('test2'),
          content: Container(),
        ),
        Step(
          title: Text('test2'),
          content: Container(),
        ),
        Step(
          title: Text('test2'),
          content: Container(),
        ),
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Text(
          "Cart",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700]),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back, color: Colors.grey[700]),
        ),
      ),
      body: isCompleted
          ? BuildCompleted()
          : Theme(
              data: Theme.of(context).copyWith(
                  colorScheme:
                      ColorScheme.light(primary: Colors.deepOrangeAccent)),
              child: Stepper(
                steps: getSteps(),
                type: StepperType.vertical,
                currentStep: currentStep,
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  return Container();
                },
              ),
            ),
    );
  }
}

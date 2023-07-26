import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:petsecom/widgets/BuildCompleted.dart';
import 'package:petsecom/widgets/CartItem.dart';
import 'package:petsecom/widgets/list_toko.dart';

import '../input_widgets.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({super.key});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  int currentStep = 0;
  bool isCompleted = false;

  final fullname = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final postalcode = TextEditingController();

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text('test1'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5),
              Text(
                'Here to Get',
                style: GoogleFonts.roboto(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Welcomed!',
                style: GoogleFonts.roboto(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              InputWidget(
                labelText: 'Full Name',
                isObscureText: false,
                controller: fullname,
              ),
              SizedBox(height: 10),
              InputWidget(
                labelText: 'No Phone',
                isObscureText: false,
                controller: phone,
              ),
              SizedBox(height: 10),
              InputWidget(
                labelText: 'Addres',
                isObscureText: false,
                controller: address,
              ),
              SizedBox(height: 10),
              InputWidget(
                labelText: 'Postal code',
                isObscureText: false,
                controller: postalcode,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
        Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: Text('test2'),
          content: Container(),
        ),
        Step(
          isActive: currentStep >= 2,
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
                type: StepperType.horizontal,
                currentStep: currentStep,
                onStepContinue: () {
                  final isLastStep = currentStep == getSteps().length - 1;
                  if (isLastStep) {
                    setState(() => isCompleted = true);
                  } else {
                    setState(() => currentStep += 1);
                  }
                },
                onStepTapped: (step) => setState(() => step),
                onStepCancel: currentStep == 0
                    ? null
                    : () => setState(() => currentStep -= 1),
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  return Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (currentStep != 0)
                            ElevatedButton(
                              onPressed: details.onStepCancel,
                              child: Text('Back'),
                            ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              child: Text('Next'),
                              onPressed: details.onStepContinue,
                            ),
                          )
                        ]),
                  );
                },
              ),
            ),
    );
  }
}

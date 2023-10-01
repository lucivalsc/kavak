import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:verzel_app/app/common/styles/app_styles.dart';

class TextDate extends StatelessWidget {
  final AppStyles appStyles;
  final TextEditingController data;
  final String labeltext;
  const TextDate({
    Key? key,
    required this.appStyles,
    required this.data,
    required this.labeltext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: TextField(
        controller: data,
        readOnly: true,
        decoration: InputDecoration(
          labelText: labeltext,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onTap: () => showDatePicker(
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: appStyles.primaryColor, // header background color
                  onPrimary: Colors.white, // header text color
                  onSurface: appStyles.primaryColor, // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: appStyles.primaryColor, // button text color
                  ),
                ),
              ),
              child: child!,
            );
          },
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(3999),
        ).then(
          (DateTime? value) {
            if (value != null) {
              final String date = DateFormat('dd/MM/yyyy').format(value);
              data.text = date;
            }
          },
        ),
      ),
    );
  }
}

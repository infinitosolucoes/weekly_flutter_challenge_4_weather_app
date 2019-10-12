import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../styleguide.dart';
import '../providers/reminder_provider.dart';

class ReminderDialog extends StatefulWidget {
  final List<String> reminders;
  final Function addReminder;
  final Function setReminder;

  @override
  ReminderDialog(
    this.reminders,
    this.addReminder,
    this.setReminder,
  );

  @override
  _ReminderDialogState createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> {
  int currentReminder;
  TextEditingController _newReminderController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _changeSelectedReminder(widget.reminders.length);
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        titlePadding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Cancel",
              style: dialogTextStyle,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(
              "Set Reminder",
              style: dialogTextStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              if (currentReminder == widget.reminders.length &&
                  _newReminderController.text.length > 0) {
                widget.addReminder(_newReminderController.text);
                Navigator.of(context).pop();
              } else if (currentReminder >= 0 &&
                  currentReminder < widget.reminders.length) {
                widget.setReminder(currentReminder);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
        title: Container(
          height: 50,
          width: MediaQuery.of(context).size.width * .8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            color: parisColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 5.0,
            ),
            child: Row(
              children: <Widget>[
                Text(
                 DateFormat('EEEEE', 'en_US').format(new DateTime.now()),
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                 DateFormat('d/M', 'en_US').format(new DateTime.now()),
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                Image(
                  width: 30,
                  image: AssetImage("assets/icons/rainy_white.png"),
                )
              ],
            ),
          ),
        ),
        content: ConstrainedBox(
          constraints: new BoxConstraints(
            maxHeight: 300,
          ),
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                for (var i = 0; i < widget.reminders.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 10.0,
                      top: 5.0,
                      bottom: 5.0,
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(widget.reminders[i],
                            style: TextStyle(fontSize: 20)),
                        Spacer(),
                        Radio(
                          value: i,
                          groupValue: currentReminder,
                          onChanged: (int i) => _changeSelectedReminder(i),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 10.0,
                    top: 5.0,
                    bottom: 5.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          controller: _newReminderController,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: 20,
                            ),
                            hintText: "Add Something...",
                          ),
                        ),
                      ),
                      Radio(
                        value: widget.reminders.length,
                        groupValue: currentReminder,
                        onChanged: (_) =>
                            _changeSelectedReminder(widget.reminders.length),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  _changeSelectedReminder(newReminder) {
    setState(() {
      currentReminder = newReminder;
    });
    print(currentReminder);
  }
}

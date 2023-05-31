import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futebol_app/hive/settings.dart';
import 'package:futebol_app/screens/home/home.dart';
import 'package:hive/hive.dart';

import 'package:futebol_app/components/custom_suffix_icon.dart';
import 'package:futebol_app/components/form_error.dart';

import 'package:futebol_app/utils/theme.dart';
import 'package:futebol_app/utils/toast.dart';
import 'package:futebol_app/utils/keyboard.dart';
import 'package:futebol_app/utils/errors.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final TextEditingController _durationTextFormController = TextEditingController();
  final TextEditingController _timesTextFormController = TextEditingController();
  final TextEditingController _teamATextFormController = TextEditingController();
  final TextEditingController _teamBTextFormController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late Box settingsBox;

  Map settings = {
    'teamA': 'Time A',
    'teamB': 'Time B',
    'duration': '0:00:15.000000',
    'times': 2,
  };

  final List<String> errors = [];

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void save() async {
    try {
      settingsBox = Hive.box<Settings>(settingsBoxName);
      settingsBox.put(
        'settings',
        Settings(
          duration: settings['duration'],
          times: settings['times'],
        )
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
        return const HomeScreen();
      }));
    } catch (err) {
      toast(
        message: 'Erro ao salvar as configurações. Tente novamente.',
        type: 'error'
      );
    }
  }
  
  void getSavedSettings() {
    settingsBox = Hive.box<Settings>(settingsBoxName);
    Settings? saved = settingsBox.get('settings');

    setState(() {
      settings['duration'] = saved?.duration ?? '0:00:15.000000';
      settings['times'] = saved?.times ?? 2;
    });

    _timesTextFormController.text = settings['times'].toString();
    _teamATextFormController.text = settings['teamA'];
    _teamBTextFormController.text = settings['teamB'];
    _durationTextFormController.text = formatDuration(getDurationFromStr(settings['duration']));
  }

  Duration getDurationFromStr(String str) {
    List<String> parts = str.split(':');

    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    double seconds = double.parse(parts[2]);

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds.toInt(),
      milliseconds: ((seconds % 1) * 1000).toInt(),
    );
  }

  String formatDuration(Duration? duration) {
    if (duration == null) return '';

    if (duration.inSeconds < 60) {
      return '${duration.inSeconds} seg';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes} min';
    } else if (duration.inHours < 24) {
      return '${duration.inHours} h';
    } else {
      return '${duration.inDays} dias';
    }
  }


  @override
  void initState() {
    super.initState();
    getSavedSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: buildTeamAFormField(),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: buildTeamBFormField(),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: buildDurationFormField(),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: buildTimesFormField(),
          ),
          FormError(errors: errors),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              var isValid = _formKey.currentState?.validate();

              if (isValid == true) {
                _formKey.currentState?.save();
                KeyboardUtil.hideKeyboard(context);
                save();
              }
            },
            child: const Text('Iniciar'),
          ),
          const SizedBox(height: 80.0),
        ],
      ),
    );
  }

  GestureDetector buildDurationFormField() {
    return GestureDetector(
      onTap: () async {
        Duration duration = getDurationFromStr(settings['duration']);
        
        var resultingDuration = await showDurationPicker(
          context: context,
          initialTime: duration,
          baseUnit: BaseUnit.second
        );
        setState(() {
          settings['duration'] = resultingDuration.toString();
        });
        
        _durationTextFormController.text = formatDuration(resultingDuration);
      },
      child: TextFormField(
        controller: _durationTextFormController,
        enabled: false,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: durationNullError);
          }
        },
        validator: (value) {
          if (value == null) {
            addError(error: durationNullError);
          }
        },
        decoration: CustomStyle.textFieldStyle(
          labelTextStr: 'Duração',
          icon: const CustomIcon(
            icon: FontAwesomeIcons.stopwatch,
            color: appInputTextColor
          )
        ),
        style: TextStyle(
          fontSize: 14.0.sp,
        ),
      )
    );
  }

  TextFormField buildTimesFormField() {
    return TextFormField(
      controller: _timesTextFormController,
      onSaved: (value) {
        setState(() {
          settings['times'] = value;
        });
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: durationNullError);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: durationNullError);
        }
      },
      decoration: CustomStyle.textFieldStyle(
        labelTextStr: 'Tempos',
        icon: const CustomIcon(
          icon: FontAwesomeIcons.rotate,
          color: appInputTextColor
        ),
      ),
      style: TextStyle(
        fontSize: 14.0.sp,
      ),
    );
  }

  TextFormField buildTeamAFormField() {
    return TextFormField(
      controller: _teamATextFormController,
      onSaved: (value) {
        setState(() {
          settings['teamA'] = value;
        });
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: teamNullError + ' A');
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: teamNullError + ' A');
        }
      },
      decoration: CustomStyle.textFieldStyle(
        labelTextStr: 'Time A',
      ),
      style: TextStyle(
        fontSize: 14.0.sp,
      ),
    );
  }

  TextFormField buildTeamBFormField() {
    return TextFormField(
      controller: _teamBTextFormController,
      onSaved: (value) {
        setState(() {
          settings['teamB'] = value;
        });
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: teamNullError + ' B');
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          addError(error: teamNullError + ' B');
        }
      },
      decoration: CustomStyle.textFieldStyle(
        labelTextStr: 'Time B',
      ),
      style: TextStyle(
        fontSize: 14.0.sp,
      ),
    );
  }
}
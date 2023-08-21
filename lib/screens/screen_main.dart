import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../provider/participants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final formKey = GlobalKey<FormState>();
  late Participants _participants;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _participants = Provider.of<Participants>(context);
    return Scaffold(
        appBar: AppBar(title: const Text('SuRT Demo')),
        body: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: mediaQuery.size.height * 0.05),
              ),
              SizedBox(
                width: mediaQuery.size.width * 0.8,
                child: Form(
                  key: formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: mediaQuery.size.width * 0.7,
                            child: renderTextFormFielder(
                                label: '이름',
                                onSaved: (val) {
                                  _participants.changeName(val);
                                },
                                validator: (val) {
                                  if (val.length < 1) {
                                    return '값을 입력해주세요';
                                  }
                                  return null;
                                }),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: mediaQuery.size.width * 0.7,
                              child: renderTextFormFielder(
                                  label: '출생년도',
                                  keyboardType: TextInputType.number,
                                  onSaved: (val) {
                                    _participants
                                        .changeBornYear(int.parse(val));
                                  },
                                  validator: (val) {
                                    if (val.length < 1) {
                                      return '값을 입력해주세요';
                                    }
                                    if (int.tryParse(val) == null) {
                                      Fluttertoast.showToast(
                                          msg: '숫자를 입력해주세요',
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM);
                                      return '숫자를 입력해주세요';
                                    }
                                    return null;
                                  }),
                            ),
                            SizedBox(
                              width: mediaQuery.size.width * 0.1,
                              child: const Text(
                                '년',
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: mediaQuery.size.width * 0.7,
                              child: renderTextFormFielder(
                                  label: '운전경력',
                                  keyboardType: TextInputType.number,
                                  onSaved: (val) {
                                    _participants.changeDriveEx(int.parse(val));
                                  },
                                  validator: (val) {
                                    if (val.length < 1) {
                                      return '값을 입력해주세요';
                                    }
                                    if (int.tryParse(val) == null) {
                                      Fluttertoast.showToast(
                                          msg: '숫자를 입력해주세요',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM);
                                      return '숫자를 입력해주세요';
                                    }
                                    return null;
                                  }),
                            ),
                            SizedBox(
                              width: mediaQuery.size.width * 0.1,
                              child: const Text(
                                '년',
                              ),
                            )
                          ],
                        ),
                        renderSubmitButton(),
                      ]),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/database');
                    },
                    child: const Text("Database"),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  renderSubmitButton() {
    return ElevatedButton(
      onPressed: (() {
        if (formKey.currentState!.validate()) {
          _participants.setId();
          formKey.currentState!.save();
          Navigator.pushNamed(context, '/loading');
        }
      }),
      child: const Text('확인'),
    );
  }

  renderTextFormFielder({
    required String label,
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        TextFormField(
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: keyboardType,
        ),
        Container(
          height: 10,
        )
      ],
    );
  }
}

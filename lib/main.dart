import 'package:flutter/material.dart';
import 'package:reactive_form_consumer_touched_bug/login_model_form.dart';

import 'app_reactive_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LoginModelFormBuilder(builder: (context, model, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    AppReactiveTextField(
                      formControl: model.emailControl,
                      label: 'Email Address',
                      hintText: 'sample.@mail.com',
                    ),
                    const SizedBox(height: 15),
                    AppReactiveTextField(
                      formControl: model.passwordControl,
                      label: 'Password',
                      hintText: 'Enter password',
                    ),
                    const SizedBox(height: 20),
                    ReactiveLoginModelFormConsumer(
                      builder: (_, formModel, __) {
                        return ElevatedButton(
                          onPressed: !formModel.form.valid
                              ? () {
                                  model.submit(
                                    onValid: (data) {
                                      print(data.email);
                                      print(data.password);
                                    },
                                    onNotValid: () => print('not valid'),
                                  );
                                }
                              : null,
                          child: Text('Log in'),
                        );
                      },
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnbloc/bloc/auth_bloc.dart';
import 'package:learnbloc/bloc/checkauth_bloc.dart';
import 'package:learnbloc/bloc/todos_bloc.dart';

void main() => runApp(
      MultiBlocProvider(providers: [
        BlocProvider(lazy: true, create: (_) => TokenBloc()),
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => TodosBloc())
      ], child: const MaterialApp(home: Loading())),
    );

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const BoardingScreen()));
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({Key? key}) : super(key: key);

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TokenBloc>().add(CheckTokenBeforeGo());
    context.read<TodosBloc>().add(TodosInit());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
        BlocBuilder<TokenBloc, CheckTokenState>(builder: (context, state) {
      if (state is TokenIsAvailable) {
        return SingleChildScrollView(
          child: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              BlocBuilder<TodosBloc, TodosState>(builder: (context, state) {
                if (state is TodoLoading) {
                  return const CircularProgressIndicator();
                } else if (state is TodoLoaded) {
                  return ListView.builder(
                      itemCount: state.data.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: ((context, index) {
                        return Text(state.data[index]["title"]);
                      }));
                } else {
                  return SizedBox();
                }
              }),
              ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogout());
                  },
                  child: const Text("Logout"))
            ],
          )),
        );
      } else {
        return const SafeArea(child: LoginScreen());
      }
    }));
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Column(children: [
        TextField(
          controller: email,
          decoration: const InputDecoration(labelText: "Email"),
        ),
        TextField(
          controller: password,
          decoration: const InputDecoration(labelText: "Password"),
        ),
        ElevatedButton(
          child: const Text("Login"),
          onPressed: () {
            print("FF");
            context
                .read<AuthBloc>()
                .add(AuthLogin(email: "d@d.com", password: "1234"));
          },
        )
      ]),
    );
  }
}

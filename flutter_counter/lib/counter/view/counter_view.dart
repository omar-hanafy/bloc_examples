import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_counter/counter/cubit/counter_cubit.dart';
import 'package:flutter_counter/counter/cubit/user_cubit.dart';
import 'package:flutter_counter/counter/user_model.dart';

class CounterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (_) => UserCubit(UserModel("omar", "12", "male")),
      child: Scaffold(
        floatingActionButton: BlocBuilder<CounterCubit, int>(builder: (context, number) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  context.read<CounterCubit>().encr();
                  context
                      .read<UserCubit>()
                      .newUser(UserModel("omar$number", "12", "male"));
                },
                key: const Key('counterView_increment_floatingActionButton'),
                child: const Icon(Icons.add),
              ),
              FloatingActionButton(
                onPressed: () {
                  context.read<CounterCubit>().decr();
                  context
                      .read<UserCubit>()
                      .newUser(UserModel("omar$number", "12", "male"));
                },
                key: const Key('counterView_decrement_floatingActionButton'),
                child: const Icon(Icons.remove),
              ),
            ],
          );
        }),
        appBar: AppBar(
          title: Text("Counter App"),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BlocBuilder<UserCubit, UserModel>(
              builder: (context, user) {
                return Column(
                  children: [
                    Text(user.name),
                    Text(user.age),
                    Text(user.sex),
                  ],
                );
              },
            ),
            Center(
              child: BlocBuilder<CounterCubit, int>(
                builder: (context, number) {
                  return Text("you pressed the button $number times",
                      style: textTheme.headline2);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

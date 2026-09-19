import 'package:flutter/material.dart';
import 'package:maple_tales_task/bloc/nav_cubit/nav_cubit.dart';
import 'package:maple_tales_task/screens/groups_screen.dart';
import 'package:maple_tales_task/screens/students_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/mode_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var defaultModel = modes[0];

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              height: 25,
              width: 25,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.school,
                size: 18,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            Text(
              'Maple Tales Schule',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        centerTitle: false,
      ),
      drawer: mediaQuery.size.width < 977
          ? Drawer(
              child: BlocBuilder<NavCubit, int>(
                builder: (context, activeIndex) {
                  return buildDrawer(activeIndex);
                },
              ),
            )
          : null,
      body: BlocBuilder<NavCubit, int>(
        builder: (context, activeIndex) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              mediaQuery.size.width > 977
                  ? Expanded(flex: 2, child: buildDrawer(activeIndex))
                  : const VerticalDivider(width: 1, thickness: 1),
              Expanded(
                flex: 8,
                child: BlocSelector<NavCubit, int, int>(
                  selector: (state) => state,
                  builder: (context, activeIndex) {
                    return IndexedStack(
                      index: activeIndex,
                      children: const [GroupsScreen(), StudentsScreen()],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildDrawer(int activeIndex) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                "4A (25/26)",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 24),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Select a default mode for the class',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 0.5,
              ),
            ),
            child: DropdownButton<ModeModel>(
              value: defaultModel,
              underline: const SizedBox(),
              elevation: 5,
              dropdownColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              borderRadius: BorderRadius.circular(8),
              items: modes
                  .map(
                    (m) => DropdownMenuItem(
                      value: m,
                      child: Text(
                        m.name,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (mode) {
                if (mode != null) setState(() => defaultModel = mode);
              },
            ),
          ),
          SizedBox(height: 24),
          FilledButton.icon(
            icon: Icon(
              Icons.group,
              color: activeIndex == 0
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: activeIndex == 0
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
            ),
            label: Text(
              'Groups',
              style: TextStyle(
                color: activeIndex == 0
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onPressed: () => context.read<NavCubit>().switchScreen(0),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: Icon(
              Icons.list,
              color: activeIndex == 1
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: activeIndex == 1
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
            ),
            label: Text(
              'Students',
              style: TextStyle(
                color: activeIndex == 1
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            iconAlignment: IconAlignment.start,
            onPressed: () => context.read<NavCubit>().switchScreen(1),
          ),
        ],
      ),
    );
  }
}

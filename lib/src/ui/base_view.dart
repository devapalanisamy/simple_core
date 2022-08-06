import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/src/di_container.dart';

class BaseView<T extends StateNotifier<S>, S> extends StatefulWidget {
  const BaseView({
    Key? key,
    required this.setupViewModel,
    required this.builder,
    this.dispose,
  }) : super(key: key);

  final Widget Function(BuildContext context, T viewmodel, S state) builder;
  final Function(T) setupViewModel;
  final Function(T)? dispose;

  @override
  _BaseViewState<T, S> createState() => _BaseViewState<T, S>();
}

class _BaseViewState<T extends StateNotifier<S>, S> extends State<BaseView<T, S>> {
  late T _viewModel;
  late AutoDisposeStateNotifierProvider<T, S> _myNotifierProvider;

  @override
  void initState() {
    _viewModel = diContainer<T>();
    widget.setupViewModel(_viewModel);
    _myNotifierProvider = StateNotifierProvider.autoDispose<T, S>((AutoDisposeStateNotifierProviderRef ref) {
      return _viewModel;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      key: const Key('BaseView_Consumer'),
      builder: (
        BuildContext context,
        WidgetRef widgetRef,
        Widget? child,
      ) {
        final S state = widgetRef.watch<S>(_myNotifierProvider);
        final T viewmodel = widgetRef.watch(_myNotifierProvider.notifier);
        return widget.builder(context, viewmodel, state);
      },
    );
  }

  @override
  void dispose() {
    widget.dispose?.call(_viewModel);
    super.dispose();
  }
}

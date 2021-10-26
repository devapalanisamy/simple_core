import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_core/src/di_container.dart';

class BaseView<T extends StateNotifier<S>, S> extends StatefulWidget {
  const BaseView({
    Key? key,
    required this.setupViewModel,
    required this.builder,
  }) : super(key: key);

  final Widget Function(BuildContext context, T viewmodel, S state) builder;
  final Function(T) setupViewModel;

  @override
  _BaseViewState<T, S> createState() => _BaseViewState<T, S>();
}

class _BaseViewState<T extends StateNotifier<S>, S>
    extends State<BaseView<T, S>> {
  late T _viewModel;
  late AutoDisposeStateNotifierProvider<T, S> _myNotifierProvider;

  @override
  void initState() {
    _viewModel = diContainer<T>();
    widget.setupViewModel(_viewModel);
    _myNotifierProvider = StateNotifierProvider.autoDispose<T, S>(
        (AutoDisposeProviderReference ref) {
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
        T Function<T>(ProviderBase<Object?, T>) watch,
        Widget? child,
      ) {
        final S state = watch<S>(_myNotifierProvider);
        final T viewmodel = watch(_myNotifierProvider.notifier);
        return widget.builder(context, viewmodel, state);
      },
    );
  }
}

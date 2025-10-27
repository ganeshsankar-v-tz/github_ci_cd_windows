import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShortCutWidget extends StatefulWidget {
  final Widget child;
  final bool loadingStatus;
  final bool autofocus;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final AppBar? appBar;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final Widget? endDrawer;
  final Key? scaffoldKey;

  const ShortCutWidget({
    super.key,
    this.appBar,
    this.shortcuts,
    required this.loadingStatus,
    this.backgroundColor,
    required this.child,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.autofocus = true,
    this.endDrawer,
    this.scaffoldKey,
  });

  @override
  State<ShortCutWidget> createState() => _CoreWidgetState();
}

class _CoreWidgetState extends State<ShortCutWidget> {
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: widget.shortcuts ?? {},
      child: Scaffold(
        key: widget.scaffoldKey,
        backgroundColor: widget.backgroundColor ?? Colors.white,
        appBar: widget.appBar,
        endDrawer: widget.endDrawer,
        floatingActionButton: widget.floatingActionButton,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(child: widget.child),
            if (widget.loadingStatus)
              const Opacity(
                opacity: 0.50,
                child: ModalBarrier(dismissible: false, color: Colors.white),
              ),
            if (widget.loadingStatus)
              const Center(
                child: SizedBox(
                  width: 41.0,
                  height: 41.0,
                  child: CupertinoActivityIndicator(
                    radius: 18.0,
                    color: Colors.blue,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class GetBackIntent extends Intent {
  const GetBackIntent();
}

class AddNewIntent extends Intent {
  const AddNewIntent();
}

class SaveIntent extends Intent {
  const SaveIntent();
}

class DetailsIntent extends Intent {
  const DetailsIntent();
}

class PrintIntent extends Intent {
  const PrintIntent();
}

class FilterIntent extends Intent {
  const FilterIntent();
}

class RemoveIntent extends Intent {
  const RemoveIntent();
}

class EditIntent extends Intent {
  const EditIntent();
}

/// Weaving
class RecordIntent extends Intent {
  const RecordIntent();
}

class LoomFocusIntent extends Intent {
  const LoomFocusIntent();
}

class FinishIntent extends Intent {
  const FinishIntent();
}

class NewRecordIntent extends Intent {
  const NewRecordIntent();
}

class WeftBalanceIntent extends Intent {
  const WeftBalanceIntent();
}

class OverAllWeftBalanceIntent extends Intent {
  const OverAllWeftBalanceIntent();
}

class NewIntent extends Intent {
  const NewIntent();
}

class CompletedIntent extends Intent {
  const CompletedIntent();
}

class RunningIntent extends Intent {
  const RunningIntent();
}

class NavigateIntent extends Intent {
  const NavigateIntent();
}

class NavigateAnotherPageIntent extends Intent {
  const NavigateAnotherPageIntent();
}

class BankInfoIntent extends Intent {
  const BankInfoIntent();
}

class WeaverFocusIntent extends Intent {
  const WeaverFocusIntent();
}

class ListIntent extends Intent {
  const ListIntent();
}

class SetCounterAction extends Action<Intent> {
  SetCounterAction({required this.perform});

  final void Function() perform;

  @override
  Object? invoke(Intent intent) {
    debugPrint('Updated counter');
    perform();
    return null;
  }
}

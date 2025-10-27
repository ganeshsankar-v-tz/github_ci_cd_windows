import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoreWidget extends StatefulWidget {
  final Widget child;
  final bool loadingStatus;
  final bool autofocus;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final AppBar? appBar;
  final Map<ShortcutActivator, VoidCallback>? bindings;
  final Widget? endDrawer;
  final Key? scaffoldKey;

  const CoreWidget({
    super.key,
    this.appBar,
    this.bindings,
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
  State<CoreWidget> createState() => _CoreWidgetState();
}

class _CoreWidgetState extends State<CoreWidget> {
  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: widget.bindings ?? {},
      child: Focus(
        autofocus: widget.autofocus,
        child: Scaffold(
          key: widget.scaffoldKey,
          endDrawer: widget.endDrawer,
          backgroundColor: widget.backgroundColor ?? Colors.white,
          appBar: widget.appBar,
          floatingActionButton: widget.floatingActionButton,
          body: Stack(
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
      ),
    );
  }
}

import 'package:devlog_microblog_client/services/localstorage.dart';
import 'package:devlog_microblog_client/widgets/misc.dart';
import 'package:devlog_microblog_client/widgets/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsData = useProvider(settingsProvider);
    Widget result;
    settingsData.when(
      data: (settings) {
        if (!settings.isConfigured()) {
          Future.delayed(Duration.zero, () => _askForSettingsDialog(context));
        }
        result = Scaffold(
          resizeToAvoidBottomInset: true,
          floatingActionButton: FloatingActionButton(
            tooltip: 'Create new post',
            child: Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed('/post/new'),
          ),
          appBar: AppBar(
            title: Text('Devlog Microblog Client'),
            leading: ServerStatusIcon(),
            actions: [
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () => Navigator.of(context).pushNamed('/settings'),
              ),
            ],
          ),
          body: MicroblogEntryList(),
        );
      },
      loading: () => result = Center(
        child: CircularProgressIndicator(),
      ),
      error: (err, stack) => result = Center(
        child: Text(err),
      ),
    );
    return result;
  }

  Future<void> _askForSettingsDialog(BuildContext ctx) async {
    var valueSelected = await showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text('Application not configured'),
        content: Text(
          'Application is not configured yet, do you want to open settings page?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    );
    if (valueSelected != null && valueSelected) {
      Navigator.of(ctx).pushNamed('/settings');
    }
  }
}

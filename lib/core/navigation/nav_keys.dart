import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show ScaffoldMessengerState;

/// Global keys for context-free navigation and messaging, kept in a
/// dependency-free leaf so low-level code can reach them without importing the
/// router or the DI layer.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:emergency_response/screens/home/home_screen.dart';
import 'package:emergency_response/screens/incident_reporting/incident_reporting_screen.dart';
import 'package:emergency_response/screens/incident_list/incident_list_screen.dart';
import 'package:emergency_response/screens/incident_details/incident_details_screen.dart';
import 'package:emergency_response/screens/admin_dashboard/admin_dashboard_screen.dart';
import 'package:emergency_response/screens/search_filter/search_filter_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => _slide(state, const HomeScreen()),
    ),
    GoRoute(
      path: '/report',
      pageBuilder: (context, state) => _slide(state, const IncidentReportingScreen()),
    ),
    GoRoute(
      path: '/incidents',
      pageBuilder: (context, state) => _slide(state, const IncidentListScreen()),
    ),
    GoRoute(
      path: '/incidents/:id',
      pageBuilder: (context, state) {
        final id = state.pathParameters['id']!;
        return _slide(state, IncidentDetailsScreen(incidentId: id));
      },
    ),
    GoRoute(
      path: '/dashboard',
      pageBuilder: (context, state) => _slide(state, const AdminDashboardScreen()),
    ),
    GoRoute(
      path: '/search',
      pageBuilder: (context, state) => _slide(state, const SearchFilterScreen()),
    ),
  ],
);

CustomTransitionPage<void> _slide(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: child,
      );
    },
  );
}

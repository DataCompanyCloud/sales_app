import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/schedule/presentation/views/agenda_page.dart';

enum AgendaRouter {
  agenda
}

final agendaRoutes = GoRoute(
  path: '/schedule',
  name: AgendaRouter.agenda.name,
  builder: (context, state) {
    return AgendaPage(title: "Agenda");
  }
  /*
  pageBuilder: (context, state) {
    final ref = ProviderScope.containerOf(context);
    final currentIndex = 4;
    final previousIndex = ref.read(previousTabIndexProvider);

    final beginOffSet = previousIndex > currentIndex
      ? Offset(-1, 0)
      : Offset(1, 0);

    return CustomTransitionPage(
      key: state.pageKey,
      child: AgendaPage(title: "Agenda"),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        final tween = Tween(begin: beginOffSet, end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 600),
    );
  },
  */
);
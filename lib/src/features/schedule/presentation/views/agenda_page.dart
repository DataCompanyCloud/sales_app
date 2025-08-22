import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';
import 'package:sales_app/src/features/schedule/presentation/controllers/agenda_providers.dart';

/// =========================
/// Providers
/// =========================

final typeCalendarProvider = StateProvider<bool>((ref) {
  return false;
});


/// Mês/ano base atualmente exibido (fixado no dia 1).
final currentMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});

/// Conjunto de dias marcados (apenas a parte de data).
class MarkedDates extends Notifier<Set<DateTime>> {
  @override
  Set<DateTime> build() => <DateTime>{};

  void toggle(DateTime date) {
    final d = _asDateOnly(date);
    final next = {...state};
    final exists = next.any((x) => _isSameDay(x, d));
    if (exists) {
      next.removeWhere((x) => _isSameDay(x, d));
    } else {
      next.add(d);
    }
    state = next;
  }

  void remove(DateTime date) {
    final d = _asDateOnly(date);
    final next = {...state}..removeWhere((x) => _isSameDay(x, d));
    state = next;
  }

  void clearAll() => state = {};
}

final markedDatesProvider = NotifierProvider<MarkedDates, Set<DateTime>>(
      () => MarkedDates(),
);

/// =========================
/// Utils de data
/// =========================
DateTime _startOfMonth(DateTime d) => DateTime(d.year, d.month, 1);
int _daysInMonth(DateTime d) => DateTime(d.year, d.month + 1, 0).day;

DateTime _gridStart(DateTime monthAnchor) {
  // Semana começando na segunda-feira (weekday: 1=Mon..7=Sun).
  final first = _startOfMonth(monthAnchor);
  final mondayIndex = first.weekday - 1; // 0..6 (0=Mon)
  return first.subtract(Duration(days: mondayIndex));
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

DateTime _asDateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

const _ptMonths = [
  'janeiro','fevereiro','março','abril','maio','junho',
  'julho','agosto','setembro','outubro','novembro','dezembro'
];
const _ptWeekdaysShort = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D']; // seg..dom

/// =========================
/// Página
/// =========================
class SchedulePage extends ConsumerWidget {
  const SchedulePage({super.key});

  void _prevMonth(WidgetRef ref) {
    final anchor = ref.read(currentMonthProvider);
    ref.read(currentMonthProvider.notifier).state =
        DateTime(anchor.year, anchor.month - 1, 1);
  }

  void _nextMonth(WidgetRef ref) {
    final anchor = ref.read(currentMonthProvider);
    ref.read(currentMonthProvider.notifier).state =
        DateTime(anchor.year, anchor.month + 1, 1);
  }

  void _goToday(WidgetRef ref) {
    final now = DateTime.now();
    ref.read(currentMonthProvider.notifier).state =
        DateTime(now.year, now.month, 1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typeCalendar = ref.watch(typeCalendarProvider);
    final currentIndex = ref.watch(agendaIndexProvider);
    final scheme = Theme.of(context).colorScheme;

    final anchor = ref.watch(currentMonthProvider);
    final marked = ref.watch(markedDatesProvider);

    final gridStart = _gridStart(anchor);
    final days = List<DateTime>.generate(42, (i) => gridStart.add(Duration(days: i)));
    final today = DateTime.now();

    final weeks = ["DOM", "SEG", "TER", "QUA", "QUI", "SEX", "SAB"];

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${_ptMonths[anchor.month - 1]} de ${anchor.year}'.toUpperCase()),
        actions: [
          TextButton(onPressed: () => _goToday(ref), child: const Text('Hoje')),
          IconButton(
            onPressed: () {
              ref.read(typeCalendarProvider.notifier).state = !typeCalendar;
            },
            icon: Icon(
              typeCalendar
                ? Icons.list
                : Icons.calendar_month,
              size: 22
            ),
          ),
        ],
      ),
      body: typeCalendar
        ? Column(
            children: [
              // Navegação
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Row(
                  children: [
                    FilledButton.tonal(onPressed: () => _prevMonth(ref), child: const Text('Mês anterior')),
                    const Spacer(),
                    FilledButton.tonal(onPressed: () => _nextMonth(ref), child: const Text('Próximo mês')),
                  ],
                ),
              ),

              // Cabeçalho seg..dom
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: List.generate(7, (i) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          _ptWeekdaysShort[i],
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 8),

              // Grade
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisExtent: 56,
                    ),
                    itemCount: days.length,
                    itemBuilder: (context, index) {
                      final date = days[index];
                      final inCurrentMonth = date.month == anchor.month;
                      final isToday = _isSameDay(date, today);
                      final isMarked = marked.any((m) => _isSameDay(m, date));

                      final baseTextStyle = Theme.of(context).textTheme.bodyMedium!;
                      final textStyle = baseTextStyle.copyWith(
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                        color: isMarked
                            ? scheme.onPrimary
                            : (inCurrentMonth
                            ? scheme.onSurface
                            : scheme.onSurface.withOpacity(0.35)),
                      );

                      final bg = isMarked
                          ? scheme.primary
                          : (isToday
                          ? scheme.primary.withOpacity(0.20)
                          : Colors.transparent);

                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => ref.read(markedDatesProvider.notifier).toggle(date),
                          child: Container(
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isToday
                                    ? scheme.primary.withOpacity(0.4)
                                    : scheme.outlineVariant,
                              ),
                            ),
                            child: Center(
                              child: Text('${date.day}', style: textStyle),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Lista de dias marcados
              if (marked.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (marked.toList()..sort())
                        .map((d) => _ChipDate(
                      date: d,
                      onDelete: () => ref.read(markedDatesProvider.notifier).remove(d),
                    ))
                        .toList(),
                  ),
                ),
            ],
          )
        : SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  width: double.infinity,
                  height: 72,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: 7, // garanta que weeks.length >= 7
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final d = DateTime.now().add(Duration(days: index));
                      return Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: index == 1
                            ? scheme.surface
                            : scheme.onPrimary,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                weeks[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.w800
                                ),
                              ),
                              Text(
                                '${d.day}',
                                style: TextStyle(
                                  color: scheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(
                height: 12,
              ),
              Text(
                "Visitas hoje",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Column(
                children: weeks.map((w) {
                  final faker = Faker();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: scheme.onPrimary ,
                        borderRadius: BorderRadius.circular(18)
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                     faker.randomGenerator.boolean()
                                      ? Icons.person
                                      : Icons.apartment
                                    ),
                                    SizedBox(width: 12,),
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            faker.company.name(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text( faker.randomGenerator.integer(100, min: 1).toString().padLeft(5, "0") )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8,),
                                Text(faker.address.city()),
                                Text("${faker.address.state()} ${faker.address.state()}"),
                              ],
                            ),
                          ),
                          SizedBox(width: 12,),
                          Icon(
                            Icons.keyboard_arrow_right
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: currentIndex),
    );
  }
}

class _ChipDate extends StatelessWidget {
  final DateTime date;
  final VoidCallback onDelete;
  const _ChipDate({required this.date, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final txt =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    return Material(
      shape: StadiumBorder(side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(txt, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(width: 6),
          InkWell(onTap: onDelete, child: const Padding(padding: EdgeInsets.all(2), child: Icon(Icons.close, size: 14))),
        ]),
      ),
    );
  }
}

import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:reports_doing_app/core/constants/constants.dart';
import 'package:reports_doing_app/core/services/global_widgets/loader.dart';
import 'package:reports_doing_app/core/services/utils/global_dialogs.dart';
import 'package:reports_doing_app/features/employees/domin_layer/entityes/user_entity.dart';
import 'package:reports_doing_app/features/reports/domin_layer/entityes/report_entity.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/cubit/get_reports_month/get_reports_month_cubit.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/pages/add_report_page.dart';
import 'package:reports_doing_app/features/reports/presentation_layer/pages/archive_report_page.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  final UserEntity userEntity;
  const HomePage({super.key, required this.userEntity});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime _focusedDay;
  late DateTime? _selectedDay;

  late final DateTime _firstdDay = (widget.userEntity.createdAt).toDate();

  late final DateTime _lastDay =
      DateTime.now().add(const Duration(days: 10000));
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  Map<DateTime, List<Report>> _events = {};

  List<Report> _selectedEvents = [];
  bool isLoading = false;
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _events = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    loadData();
    _selectedEvents = _getReportsForTheDay(_selectedDay!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadData() {
    BlocProvider.of<GetReportsMonthCubit>(context)
        .getCurrentMonthReports(DateTime.now());
  }

//----------------------------
  List<Report> _getReportsForTheDay(DateTime? day) {
    if (day != null) {
      if (_events[day] != null) {}
      return _events[day] ?? [];
    } else {
      return [];
    }
  }

//------------------------------
  List<Report> _getEventsForRange(DateTime start, DateTime end) {
    List<Report> rangeEvents = [];
    var startDate = DateTime.utc(start.year, start.month, start.day);
    var endDate = DateTime.utc(end.year, end.month, end.day);
    if (startDate.isBefore(endDate)) {
      for (var i = startDate;
          i.isBefore(endDate);
          i = i.add(const Duration(days: 1))) {
        var list = _getReportsForTheDay(i);
        rangeEvents.addAll(list);
      }
    } else if (startDate.isAfter(endDate)) {
      for (var i = startDate;
          i.isAfter(endDate);
          i = i.subtract(const Duration(days: 1))) {
        var list = _getReportsForTheDay(i);

        rangeEvents.addAll(list);
      }
    }
    return rangeEvents;
  }

//-------------------------------------
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    try {
      isLoading = true;
      if (!isSameDay(_selectedDay, selectedDay)) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          _rangeStart = null;
          _rangeEnd = null;
          _rangeSelectionMode = RangeSelectionMode.toggledOff;
        });
        _selectedEvents = _getReportsForTheDay(_selectedDay);
      }
    } catch (e) {
      rethrow;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

//-----------------------------
  void _onRangeSelected(
      DateTime? start, DateTime? end, DateTime focusedDay) async {
    try {
      setState(() {
        isLoading = true;
        _selectedDay = null;
        _focusedDay = focusedDay;
        _rangeStart = start;
        _rangeEnd = end;
        _rangeSelectionMode = RangeSelectionMode.toggledOn;
      });
      if (start != null && end != null) {
        _selectedEvents = _getEventsForRange(start, end);
      } else if (start != null) {
        _selectedEvents = _getReportsForTheDay(start);
      } else if (end != null) {
        _selectedEvents = _getReportsForTheDay(end);
      }
    } catch (e) {
      rethrow;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

//_______________________________
  @override
  Widget build(BuildContext context) {
    var today = DateTime.utc(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var thisDay = DateTime.utc(
        _selectedDay?.year ?? _focusedDay.year,
        _selectedDay?.month ?? _focusedDay.month,
        _selectedDay?.day ?? _focusedDay.day);
    bool todayIsHolidy = false;
    String tody = DateFormat.EEEE().format(DateTime.now());
    if (tody == 'Friday' || tody == 'Saturday') {
      todayIsHolidy = true;
    } else {
      todayIsHolidy = false;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Dialy Reports',
          style: TextStyle(color: Color(0xFF02023E)),
        ),
        centerTitle: true,
        elevation: 2.0,
        leading: InkWell(
          onTap: () {},
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height *
                  (35 / MediaQuery.of(context).size.height),
              width: MediaQuery.of(context).size.height *
                  (40 / MediaQuery.of(context).size.height),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: dartBlue),
              child: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: _firstdDay,
            lastDay: _lastDay,
            eventLoader: _getReportsForTheDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              BlocProvider.of<GetReportsMonthCubit>(context)
                  .getCurrentMonthReports(_focusedDay);
            },
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            rangeSelectionMode: _rangeSelectionMode,
            startingDayOfWeek: StartingDayOfWeek.saturday,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            weekendDays: const [DateTime.saturday, DateTime.friday],
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
            ),
            headerStyle: HeaderStyle(
                headerMargin: const EdgeInsets.only(bottom: 10),
                formatButtonDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0)),
                formatButtonTextStyle: const TextStyle(color: Colors.black),
                formatButtonShowsNext: false),
            calendarStyle: CalendarStyle(
              weekendTextStyle: const TextStyle(color: Colors.red),
              todayDecoration: const BoxDecoration(
                color: Color(0xFFF09E54),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: dartBlue,
                shape: BoxShape.circle,
              ),
              holidayDecoration: const BoxDecoration(color: Colors.pink),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          isLoading
              ? SizedBox(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: dartBlue,
                    ),
                  ),
                )
              : BlocConsumer<GetReportsMonthCubit, ReportState>(
                  builder: (context, reportState) {
                  if (reportState is LoadingState) {
                    return const LoadingCircularProgressWidget();
                  } else if (reportState is SuccessGetState) {
                    return StreamBuilder(
                        stream: reportState.allReports,
                        builder: (context, snapshot) {
                          Map<DateTime, List<Report>> cachedData = {};
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return SizedBox(
                                height: 200,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: dartBlue,
                                  ),
                                ),
                              );

                            case ConnectionState.active:
                              if (snapshot.hasData) {
                                if (snapshot.data!.isNotEmpty) {
                                  bool loading = true;
                                  try {
                                    loading = true;
                                    for (int i = 0;
                                        i < snapshot.data!.length;
                                        i++) {
                                      var date = DateTime.utc(
                                          snapshot.data![i].date.year,
                                          snapshot.data![i].date.month,
                                          snapshot.data![i].date.day);

                                      if (cachedData[date] == null) {
                                        cachedData[date] = [];
                                        cachedData[date] = [snapshot.data![i]];
                                      } else {
                                        cachedData[date]!
                                            .add(snapshot.data![i]);
                                      }
                                    }
                                    _events = cachedData;
                                    if (_selectedDay != null) {
                                      var selectedDayUtc = DateTime.utc(
                                          _selectedDay!.year,
                                          _selectedDay!.month,
                                          _selectedDay!.day);

                                      _selectedEvents =
                                          _getReportsForTheDay(selectedDayUtc);
                                    }
                                  } catch (e) {
                                    rethrow;
                                  } finally {
                                    loading = false;
                                  }
                                  if (loading == true) {
                                    return SizedBox(
                                      height: 200,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: dartBlue,
                                        ),
                                      ),
                                    );
                                  } else {
                                    if (_selectedEvents.isEmpty) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            decoration: const BoxDecoration(),
                                            child: Image.asset(
                                              'assets/lotti/Screenshot_4.png',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Text(
                                                  'No reports in this day. !',
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Expanded(
                                          child: ListView.builder(
                                              itemCount: _selectedEvents.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 4.0),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0)),
                                                  child: ListTile(
                                                    onTap: () {
                                                      if (thisDay != today) {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    ArchiveReport(
                                                                      reportId:
                                                                          _selectedEvents[index]
                                                                              .reportId,
                                                                    )));
                                                      } else {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    AddReportGame(
                                                                      focusedDay:
                                                                          _selectedDay ??
                                                                              _focusedDay,
                                                                      reportId:
                                                                          _selectedEvents[index]
                                                                              .reportId,
                                                                    )));
                                                      }
                                                    },
                                                    title: Text(
                                                        "${_selectedEvents[index].dayName}  ${_selectedEvents[index].year} - ${_selectedEvents[index].month} - ${_selectedEvents[index].day} report"),
                                                  ),
                                                );
                                              }));
                                    }
                                  }
                                } else if (snapshot.data!.isEmpty) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(),
                                        child: Image.asset(
                                          'assets/lotti/Screenshot_4.png',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'No reports in this day. !',
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              } else if (snapshot.hasError ||
                                  snapshot.data == null) {
                                return const Center(
                                  child: Text(
                                    'An error happenend',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }
                              break;
                            default:
                              return const Center(
                                  child: Text(
                                      "not have data ,,, please wait ..."));
                          }
                          return const Center(
                              child: Text("not have data ,,, please wait ..."));
                        });
                  } else if (reportState is FailureGetState) {
                    return const Center(child: Text("Error ................."));
                  } else if (reportState is InitialState) {
                    return const Center(
                        child: Text("not have data ,,, please wait ..."));
                  }
                  return const Center(
                      child: Text("not have data ,,, please wait ..."));
                }, listener: ((context, reportState) {
                  if (reportState is FailureGetState) {
                    return GlobalDialogs.showErrorDialog(
                        error: reportState.errorMsg, context: context);
                  }
                })),
        ],
      ),
      floatingActionButton: today == thisDay
          ? todayIsHolidy
              ? const FloatingActionButton(
                  onPressed: null,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.face_outlined),
                )
              : FloatingActionButton(
                  focusColor: Colors.white,
                  backgroundColor: const Color(0xFF1F4069),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => AddReportGame(
                              focusedDay: today,
                              reportId: null,
                            )));
                  },
                  child: const Icon(Icons.add),
                )
          : null,
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/event/event_cubit.dart';
import 'package:ghp_society_management/view/resident/event/event_detail_screen.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool searchBarOpen = false;
  final TextEditingController textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late EventCubit _eventCubit;

  @override
  void initState() {
    _eventCubit = EventCubit()..fetchEvents();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent < 300) {
      _eventCubit.loadMoreEvents();
    }
  }

  Future onRefresh() async {
    _eventCubit.fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventCubit, EventState>(
      listener: (context, state) {
        if (state is EventLogout) {
          sessionExpiredDialog(context);
        }
      },
      child: Scaffold(

        appBar: customAppbar(context: context, title: 'Events', textController: textController,searchBarOpen: searchBarOpen,onExpansionComplete: () {
          setState(() {
            searchBarOpen = true;
          });
        },
          onCollapseComplete: () {
            setState(() {
              searchBarOpen = false;
              _eventCubit.fetchEvents();
              textController.clear();
            });
          },
          onPressButton: (isSearchBarOpens) {
            setState(() {
              searchBarOpen = true;
            });
          },
          onChanged: (value) {
            _eventCubit.searchEvent(value);
          },),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: BlocBuilder<EventCubit, EventState>(
            bloc: _eventCubit,
            builder: (context, state) {
              if (state is EventLoading &&
                  _eventCubit.eventsListing.isEmpty) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
              if (state is EventFailed) {
                return Center(
                    child: Text(state.errorMsg,
                        style: const TextStyle(
                            color: Colors.deepPurpleAccent)));
              }
              if (state is EventInternetError) {
                return Center(
                    child: Text(state.errorMsg.toString(),
                        style: const TextStyle(color: Colors.red)));
              }

              if (_eventCubit.eventsListing.isEmpty) {
                return const Center(
                    child: Text('Events Not Found!',
                        style: TextStyle(
                            color: Colors.deepPurpleAccent)));
              }

              // **Fix applied here**
              var eventsList = _eventCubit.eventsListing;
              if (state is EventSearchedLoaded) {
                eventsList = state.event;
              }

              if (eventsList.isEmpty) {
                return const Center(
                    child: Text('Events Not Found!',
                        style: TextStyle(
                            color: Colors.deepPurpleAccent)));
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: eventsList.length + 1,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: ((context, index) {
                  if (index == eventsList.length) {
                    return _eventCubit.state is EventLoadingMore?
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                                child: CircularProgressIndicator()))
                        : const SizedBox.shrink();
                  }

                  String formattedDate = DateFormat('dd MMM yyyy')
                      .format(eventsList[index].date);

                  // Get the time from your model
                  String timeString =
                      eventsList[index].time; // e.g., "18:46:00"

                  // Parse the time string into a DateTime object
                  DateTime parsedTime =
                      DateFormat("HH:mm:ss").parse(timeString);

                  // Format the DateTime object to 12-hour format with AM/PM
                  String formattedTime = DateFormat.jm().format(
                      parsedTime); // This will convert it to "6:46 PM"
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => EventDetailScreen(
                                subTitle: eventsList[index].subTitle,
                                title: eventsList[index].title,
                                description:
                                    eventsList[index].description,
                                date: formattedDate,
                                time: formattedTime,
                                image: eventsList[index].image,
                              )));
                    },
                    child: Card(color: AppTheme.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            child: CachedNetworkImage(
                              imageUrl: eventsList[index].image,
                              height: 175.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, progress) => Center(
                                      child: Image.asset(
                                          height: 175.h,
                                          width: double.infinity,
                                          'assets/images/default.jpg',
                                          fit: BoxFit.cover)),
                              errorWidget: (context, url, error) =>
                                  Container(
                                height: 175.h,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey[600],
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.1),
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight:
                                        Radius.circular(10))),
                            child: ListTile(
                              dense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 8),
                              title: Text(eventsList[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight:
                                              FontWeight.w600))),
                              subtitle: Row(children: [
                                Text("$formattedDate $formattedTime",
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color:
                                                AppTheme.primaryColor,
                                            fontSize: 12,
                                            fontWeight:
                                                FontWeight.w600)))
                              ]),
                              trailing: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(1000.r),
                                    color: AppTheme.primaryColor
                                        .withOpacity(0.5)),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.navigate_next,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}

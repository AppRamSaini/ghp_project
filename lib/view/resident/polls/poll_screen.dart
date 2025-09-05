import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/polls_controller/create_polls/create_polls_cubit.dart';
import 'package:ghp_society_management/controller/polls_controller/get_polls/get_polls_cubit.dart';
import 'package:ghp_society_management/model/polls_model.dart';
import 'package:ghp_society_management/view/resident/polls/custom_flutter_widget.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PollScreen extends StatefulWidget {
  const PollScreen({super.key});

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  late GetPollsCubit _getPollsCubit;

  @override
  void initState() {
    super.initState();
    _getPollsCubit = GetPollsCubit()..fetchGetPolls(context);
  }

  BuildContext? dialogueContext;

  Future refreshPage() async {
    _getPollsCubit.fetchGetPolls(context);
  }

  pollExpire(String formattedString) {
    // Current date & time
    DateTime now = DateTime.now();

// Poll end date (from API)
    DateTime pollEndDate = DateTime.parse(formattedString);

// ✅ अगर expiry date आज की है तो रात 11:59 PM सेट करें
    DateTime finalEndDate;
    if (pollEndDate.year == now.year &&
        pollEndDate.month == now.month &&
        pollEndDate.day == now.day) {
      finalEndDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    } else {
      finalEndDate = pollEndDate;
    }
// ✅ चेक करें expire हुआ या नहीं
    bool isExpired = now.isAfter(finalEndDate);

// // ✅ अगर expire नहीं है तो रिवर्स टाइमर के लिए duration निकालें
//     Duration remaining = finalEndDate.difference(now);
//     String timerText = "${remaining.inHours.toString().padLeft(2, '0')}:"
//         "${(remaining.inMinutes % 60).toString().padLeft(2, '0')}:"
//         "${(remaining.inSeconds % 60).toString().padLeft(2, '0')}";
// Example Output
    print("Is Expired: $isExpired");
    // print("Time Left: $timerText");

    return isExpired;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePollsCubit, CreatePollsState>(
      listener: (context, state) async {
        if (state is CreatePollsLoading) {
          showLoadingDialog(context, (ctx) {
            dialogueContext = ctx;
          });
        } else if (state is CreatePollsLoaded) {
          snackBar(context, 'Polls vote added successfully', Icons.done,
              AppTheme.guestColor);
          Navigator.of(dialogueContext!).pop();
          _getPollsCubit.fetchGetPolls(context);
        } else if (state is CreatePollsFailed) {
          snackBar(context, 'Failed to add vote polls', Icons.warning,
              AppTheme.redColor);

          Navigator.of(dialogueContext!).pop();
        } else if (state is CreatePollsInternetError) {
          snackBar(context, 'Internet connection failed', Icons.wifi_off,
              AppTheme.redColor);

          Navigator.of(dialogueContext!).pop();
        } else if (state is CreatePollsLogout) {
          Navigator.of(dialogueContext!).pop();
          sessionExpiredDialog(context);
        }
      },
      child: Scaffold(
        appBar: appbarWidget(title: 'Polls'),
        body: RefreshIndicator(
          onRefresh: refreshPage,
          child: BlocBuilder<GetPollsCubit, GetPollsState>(
            bloc: _getPollsCubit,
            builder: (context, state) {
              if (state is GetPollsLoading) {
                return notificationShimmerLoading();
              } else if (state is GetPollsLoaded) {
                List<POllList> pollsList = state.pollsList;

                if (pollsList.isEmpty) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Center(
                        child: Text(
                          'Polls not found!',
                          style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: pollsList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    String expireDate = DateFormat('dd-MMMM-yyyy').format(
                        DateTime.parse(pollsList[index].endDate.toString()));

                    bool isExpired =
                        pollExpire(pollsList[index].endDate.toString());

                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pollsList[index].endMsg.toString(),
                                style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Center(
                                child: isExpired
                                    ? Text(
                                        'Poll has expired',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : CustomFlutterPolls(
                                        pollOptionsWidth:
                                            MediaQuery.sizeOf(context).width *
                                                0.85,
                                        pollOptionsHeight:
                                            MediaQuery.sizeOf(context).height *
                                                0.06,
                                        userVotedOptionId: pollsList[index]
                                            .options
                                            .first
                                            .id
                                            .toString(),
                                        pollTitle: Text(
                                          pollsList[index].title.toString(),
                                          style: GoogleFonts.aBeeZee(
                                            textStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        pollId: pollsList[index].id.toString(),
                                        hasVoted: pollsList[index].hasVoted,
                                        onVoted: (PollOption pollOption,
                                            int newTotalVotes) async {
                                          context
                                              .read<CreatePollsCubit>()
                                              .giveTheVoteAPI(
                                                pollId: pollsList[index]
                                                    .id
                                                    .toString(),
                                                optionId:
                                                    pollOption.id.toString(),
                                              );
                                          return true;
                                        },
                                        metaWidget: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(
                                            'Expire at : $expireDate',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        pollOptions: pollsList[index]
                                            .options
                                            .map((option) {
                                          return PollOption(
                                            id: option.id.toString(),
                                            title: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      option.optionText
                                                          .toString(),
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        color:
                                                            option.votesCount >
                                                                    0
                                                                ? Colors.white
                                                                : Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "${option.votesCount} Votes",
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            votes: option.votesCount.toInt(),
                                          );
                                        }).toList(),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        pollsList[index].hasVoted
                            ? Padding(
                                padding: const EdgeInsets.all(20),
                                child: Icon(Icons.check_circle,
                                    color: Colors.green))
                            : SizedBox()
                      ],
                    );
                  },
                );
              } else if (state is GetPollsFailed) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: Text(
                        state.errorMsg.toString(),
                        style: const TextStyle(color: Colors.deepPurpleAccent),
                      ),
                    ),
                  ),
                );
              } else if (state is GetPollsInternetError) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: const Center(
                      child: Text(
                        'Internet connection error',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

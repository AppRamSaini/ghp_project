
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CustomFlutterPolls extends HookWidget {
  const CustomFlutterPolls({
    super.key,
    required this.pollId,
    this.hasVoted = false,
    this.userVotedOptionId,
    required this.onVoted,
    this.loadingWidget,
    required this.pollTitle,
    this.heightBetweenTitleAndOptions = 10,
    required this.pollOptions,
    this.heightBetweenOptions,
    this.votesText = 'Votes',
    this.votesTextStyle,
    this.metaWidget,
    this.createdBy,
    this.userToVote,
    this.pollStartDate,
    this.pollEnded = false,
    this.pollOptionsHeight = 36,
    this.pollOptionsWidth,
    this.pollOptionsBorderRadius,
    this.pollOptionsFillColor,
    this.pollOptionsSplashColor = Colors.grey,
    this.pollOptionsBorder,
    this.votedPollOptionsBorder,
    this.votedPollOptionsRadius,
    this.votedBackgroundColor = const Color(0xffEEF0EB),
    this.votedProgressColor = const Color(0xff84D2F6),
    this.leadingVotedProgessColor = const Color(0xff0496FF),
    this.voteInProgressColor = const Color(0xffEEF0EB),
    this.votedCheckmark,
    this.votedPercentageTextStyle,
    this.votedAnimationDuration = 1000,
  }) : _isloading = false;

  final String? pollId;
  final bool hasVoted;
  final bool _isloading;
  final String? userVotedOptionId;
  final Future<bool> Function(PollOption pollOption, int newTotalVotes) onVoted;
  final Widget pollTitle;
final List<PollOption> pollOptions;
  final double? heightBetweenTitleAndOptions;
  final double? heightBetweenOptions;
  final String? votesText;
  final TextStyle? votesTextStyle;
  final Widget? metaWidget;
  final String? createdBy;
  final String? userToVote;
  final DateTime? pollStartDate;
  final bool pollEnded;
  final double? pollOptionsHeight;
  final double? pollOptionsWidth;
  final BorderRadius? pollOptionsBorderRadius;
  final BoxBorder? pollOptionsBorder;
  final BoxBorder? votedPollOptionsBorder;
  final Color? pollOptionsFillColor;
  final Color? pollOptionsSplashColor;
  final Radius? votedPollOptionsRadius;
  final Color? votedBackgroundColor;
  final Color? votedProgressColor;
  final Color? leadingVotedProgessColor;
  final Color? voteInProgressColor;
  final Widget? votedCheckmark;
  final TextStyle? votedPercentageTextStyle;
  final int votedAnimationDuration;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    final hasPollEnded = useState(pollEnded);
    final userHasVoted = useState(hasVoted);
    final isLoading = useState(_isloading);
    final votedOption = useState<PollOption?>(hasVoted == false
        ? null
        : pollOptions
        .where(
          (pollOption) => pollOption.id == userVotedOptionId,
    )
        .toList()
        .first);

    final totalVotes = useState<int>(pollOptions.fold(
      0,
          (acc, option) => acc + option.votes,
    ));

    totalVotes.value = totalVotes.value;

    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      key: ValueKey(pollId),
      children: [
        pollTitle,
        SizedBox(height: heightBetweenTitleAndOptions),
        if (pollOptions.length < 2)
          throw ('>>>Flutter Polls: Poll must have at least 2 options.<<<')
        else
          ...pollOptions.map(
                (pollOption) {
              if (hasVoted && userVotedOptionId == null) {
                throw ('>>>Flutter Polls: User has voted but [userVotedOptionId] is null.<<<');
              } else {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: userHasVoted.value || hasPollEnded.value
                      ? Container(
                    key: UniqueKey(),
                    margin: EdgeInsets.only(
                      bottom: heightBetweenOptions ?? 8
                    ),
                    decoration: votedPollOptionsBorder != null
                        ? BoxDecoration(
                      border: votedPollOptionsBorder,
                      borderRadius: BorderRadius.all(
                        votedPollOptionsRadius ??
                            const Radius.circular(8)
                      )
                    )
                        : null,
                    child: LinearPercentIndicator(
                      width: pollOptionsWidth,
                      lineHeight: pollOptionsHeight!,
                      barRadius: votedPollOptionsRadius ??
                          const Radius.circular(8),
                      padding: EdgeInsets.zero,
                      percent: totalVotes.value == 0
                          ? 0
                          : pollOption.votes / totalVotes.value,
                      animation: true,
                      animationDuration: votedAnimationDuration,
                      backgroundColor: votedBackgroundColor,
                      progressColor:
                      votedOption.value?.id == pollOption.id
                          ? leadingVotedProgessColor
                          : votedProgressColor,
                      center:

                      // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                          pollOption.title,


                          // if (votedOption.value != null &&
                          //     votedOption.value?.id == pollOption.id)
                          //   votedCheckmark ??
                          //       const Icon(
                          //         Icons.check_circle_outline_rounded,
                          //         color: Colors.black,
                          //         size: 16,
                          //       ),
                          // const Spacer(),
                          // Text(
                          //   totalVotes.value == 0
                          //       ? "0 $votesText"
                          //       : '${(pollOption.votes / totalVotes.value * 100).toStringAsFixed(1)}%',
                          //   style: votedPercentageTextStyle,
                          // ),
                      //   ],
                      // ),
                    ),
                  )
                      : Container(
                    key: UniqueKey(),
                    margin: EdgeInsets.only(
                      bottom: heightBetweenOptions ?? 8
                    ),
                    child: InkWell(
                      onTap: () async {
                        // Disables clicking while loading
                        if (isLoading.value) return;
                        votedOption.value = pollOption;
                        isLoading.value = true;
                        bool success = await onVoted(
                          votedOption.value!,
                          totalVotes.value,
                        );
                        isLoading.value = false;
                        if (success) {
                          pollOption.votes++;
                          totalVotes.value++;
                          userHasVoted.value = true;
                        }
                      },
                      splashColor: pollOptionsSplashColor,
                      borderRadius: pollOptionsBorderRadius ??
                          BorderRadius.circular(
                            8,
                          ),
                      child: Container(
                        height: pollOptionsHeight,
                        width: pollOptionsWidth,
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: votedOption.value?.id == pollOption.id
                              ? voteInProgressColor
                              : pollOptionsFillColor,
                          border: pollOptionsBorder ??
                              Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                          borderRadius: pollOptionsBorderRadius ??
                              BorderRadius.circular(
                                8,
                              ),
                        ),
                        child: Center(
                          child: isLoading.value &&
                              pollOption.id == votedOption.value!.id
                              ? loadingWidget ??
                              const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : pollOption.title,
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              '${totalVotes.value} $votesText',
              style: votesTextStyle ??
                  const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                  ),
            ),
            Expanded(
              child: metaWidget ?? Container(),
            ),
          ],
        ),
      ],
    );
  }
}

class PollOption {
  PollOption({
    this.id,
    required this.title,
    required this.votes,
  });

  final String? id;
  final Widget title;
  int votes;
}

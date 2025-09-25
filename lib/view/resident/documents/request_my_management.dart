import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/controller/documents/incoming_documents/incoming_documents_cubit.dart';
import 'package:ghp_society_management/view/resident/documents/upload_document_screen.dart';
import 'package:intl/intl.dart';

class IncomingDocumentsScreen extends StatefulWidget {
  const IncomingDocumentsScreen({super.key});

  @override
  State<IncomingDocumentsScreen> createState() =>
      _IncomingDocumentsScreenState();
}

class _IncomingDocumentsScreenState extends State<IncomingDocumentsScreen> {
  List<String> filterList = ["All", "Pending", "Sent"];
  List<String> filterTypes = ["all", "pending", "received"];

  int selectedFilter = 0;

  // late IncomingDocumentsCubit incomingDocumentsCubit;

  bool searchBarOpen = false;
  final TextEditingController textController = TextEditingController();

  initCubit() {
    // incomingDocumentsCubit = IncomingDocumentsCubit();
    context
        .read<IncomingDocumentsCubit>()
        .fetchIncomingDocuments(filter: filterTypes[selectedFilter].toString());
    // incomingDocumentsCubit.fetchIncomingDocuments(
    //     filter: filterTypes[selectedFilter]);
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initCubit();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<IncomingDocumentsCubit>().loadMoreDocuments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(title: 'Request By Management'),
      body: SafeArea(
        child: BlocListener<UploadDocumentCubit, UploadDocumentState>(
          listener: (context, state) async {
            if (state is UploadDocumentSuccessfully) {
              context.read<IncomingDocumentsCubit>().fetchIncomingDocuments(
                  filter: filterTypes[selectedFilter].toString());
            }
          },
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                selectedFilter = 0;
              });
              context.read<IncomingDocumentsCubit>().fetchIncomingDocuments(
                  filter: filterTypes[selectedFilter].toString());
            },
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          itemCount: filterList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFilter = index;
                                  context
                                      .read<IncomingDocumentsCubit>()
                                      .fetchIncomingDocuments(
                                          filter:
                                              filterTypes[index].toString());
                                  // incomingDocumentsCubit.fetchIncomingDocuments(
                                  //     filter: filterTypes[index].toString());
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.all(5.w),
                                decoration: BoxDecoration(
                                  color: selectedFilter == index
                                      ? AppTheme.primaryColor
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: selectedFilter == index
                                          ? AppTheme.primaryColor
                                          : Colors.grey),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Center(
                                      child: Text(
                                    filterList[index],
                                    style: GoogleFonts.poppins(
                                      color: selectedFilter == index
                                          ? Colors.white
                                          : Colors.black54,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: BlocBuilder<IncomingDocumentsCubit,
                          IncomingDocumentsState>(
                        // bloc: incomingDocumentsCubit,
                        builder: (context, state) {
                          if (state is IncomingDocumentsLoading) {
                            return notificationShimmerLoading();
                          } else if (state is IncomingDocumentsFailed) {
                            return Center(
                                child: Text(state.errorMsg.toString(),
                                    style: const TextStyle(
                                        color: Colors.deepPurpleAccent)));
                          } else if (state is IncomingDocumentsInternetError) {
                            return Center(
                                child: Text(state.errorMsg.toString(),
                                    style: const TextStyle(
                                        color: Colors.deepPurpleAccent)));
                          } else if (state is IncomingDocumentsLoaded) {
                            var documentsList = state.incomingDocuments;

                            if (documentsList.isEmpty) {
                              return emptyDataWidget(
                                  "No incoming documents found");
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              controller: _scrollController,
                              itemCount: documentsList.length + 1,
                              itemBuilder: (context, index) {
                                if (index == documentsList.length) {
                                  return state is IncomingDocumentsLoadingMore
                                      ? const Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()))
                                      : const SizedBox.shrink();
                                }

                                status() {
                                  return Text(
                                    documentsList[index].status == 'requested'
                                        ? "pending"
                                        : documentsList[index]
                                            .status
                                            .toString(),
                                    style: TextStyle(
                                        color: documentsList[index].status ==
                                                'uploaded'
                                            ? Colors.blue
                                            : Colors.red),
                                  );
                                }

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.grey[300]!),
                                      borderRadius:
                                          BorderRadius.circular(10.r)),
                                  child: ListTile(
                                    onTap: () {
                                      // if (documentsList[index].status ==
                                      //     'requested') {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  UploadDocumentScreen(
                                                      incomingRequestData:
                                                          documentsList[
                                                              index])));
                                      // } else {
                                      //   snackBar(
                                      //       context,
                                      //       'This Document AlReady Uploaded!',
                                      //       Icons.info_outline,
                                      //       AppTheme.redColor);
                                      // }
                                    },
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    leading: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(ImageAssets.settingLogo,
                                              height: 50,
                                              color:
                                                  documentsList[index].status ==
                                                          'requested'
                                                      ? Colors.deepPurpleAccent
                                                      : Colors.blue)
                                        ]),
                                    title: Text(
                                      documentsList[index].subject!.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Doc Type: ${documentsList[index].documentType}",
                                          style: GoogleFonts.poppins(
                                            color: Colors.black45,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Date: ${DateFormat('d MMM, yyyy').format(documentsList[index].createdAt!)}",
                                              style: GoogleFonts.poppins(
                                                color: Colors.black45,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            status()
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: CircleAvatar(
                                      backgroundColor: Colors.deepPurpleAccent
                                          .withOpacity(0.1),
                                      child: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 20,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return notificationShimmerLoading();
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

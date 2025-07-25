import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/controller/documents/delete_request/delete_request_cubit.dart';
import 'package:ghp_society_management/controller/documents/outgoing_documents/outgoing_documents_cubit.dart';
import 'package:ghp_society_management/controller/documents/send_request/send_request_docs_cubit.dart';
import 'package:ghp_society_management/controller/download_file/download_document_cubit.dart';
import 'package:ghp_society_management/model/outgoing_document_model.dart';
import 'package:ghp_society_management/view/resident/documents/send_request_documents_screen.dart';
import 'package:ghp_society_management/view/resident/documents/view_docs_details.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:intl/intl.dart';

class OutgoingDocumentsScreen extends StatefulWidget {
  const OutgoingDocumentsScreen({super.key});

  @override
  State<OutgoingDocumentsScreen> createState() =>
      _OutgoingDocumentsScreenState();
}

class _OutgoingDocumentsScreenState extends State<OutgoingDocumentsScreen> {
  List<String> filterList = ["All", "Pending", "Receive"];
  List<String> filterTypes = ["all", "pending", "received"];

  int? selectedFilter = 0;
  late OutgoingDocumentsCubit outgoingDocumentsCubit;

  bool searchBarOpen = false;
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    initCubit();
    super.initState();
  }

  initCubit() {
    outgoingDocumentsCubit = OutgoingDocumentsCubit();
    outgoingDocumentsCubit.getOutgoingDocumentsAPI('all');
    context.read<DocumentElementsCubit>().fetchDocumentElement();
  }

  late BuildContext dialogueContext;

  Future<void> fetchData() async {
    setState(() => selectedFilter = 0);
    await outgoingDocumentsCubit.getOutgoingDocumentsAPI('all');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.primaryColor,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (builder) => const SendDocumentsRequestScree()));
          },
          child: const Icon(Icons.add, color: Colors.white)),
      appBar: customAppbar(
        context: context,
        title: 'Request by me',
        textController: textController,
        searchBarOpen: searchBarOpen,
        onExpansionComplete: () {
          setState(() {
            searchBarOpen = true;
          });
        },
        onCollapseComplete: () async {
          setState(() {
            searchBarOpen = false;
          });
          fetchData();
        },
        onPressButton: (isSearchBarOpens) {
          setState(() {
            searchBarOpen = true;
          });
        },
        onChanged: (value) {
          outgoingDocumentsCubit.searchOutgoingDocuments(value);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: MultiBlocListener(
          listeners: [
            BlocListener<SendDocsRequestCubit, SendDocsRequestState>(
                listener: (context, state) async {
              if (state is SendDocsRequestSuccessfully) {
                fetchData();
              }
            }),
            BlocListener<DownloadDocumentCubit, DownloadDocumentState>(
              listener: (context, state) {
                if (state is DownloadDocumentLoading) {
                  showLoadingDialog(context, (ctx) {
                    dialogueContext = ctx;
                  });
                } else if (state is DownloadDocumentSuccess) {
                  Navigator.of(context).pop();
                  snackBar(context, state.successMsg.toString(), Icons.done,
                      Colors.green);
                } else if (state is DownloadDocumentFailed) {
                  Navigator.of(context).pop();
                  snackBar(context, state.errorMsg.toString(), Icons.warning,
                      Colors.red);
                } else if (state is DownloadDocumentTimeout) {
                  Navigator.of(context).pop();
                  snackBar(context, state.errorMsg.toString(), Icons.warning,
                      Colors.red);
                } else if (state is DownloadDocumentInternetError) {
                  Navigator.of(context).pop();
                  snackBar(context, state.errorMsg.toString(), Icons.wifi,
                      Colors.red);
                }
              },
            ),
            BlocListener<DeleteRequestCubit, DeleteRequestState>(
                listener: (context, state) async {
              if (state is DeleteRequestLoading) {
                showLoadingDialog(context, (ctx) {
                  dialogueContext = ctx;
                });
              } else if (state is DeleteRequestSuccessfully) {
                snackBar(context, state.successMsg.toString(), Icons.done,
                    AppTheme.guestColor);
                fetchData();
                Navigator.of(dialogueContext).pop();
              } else if (state is DeleteRequestFailed) {
                snackBar(context, state.errorMsg.toString(), Icons.warning,
                    AppTheme.redColor);
                Navigator.of(dialogueContext).pop();
              } else if (state is DeleteRequestInternetError) {
                snackBar(context, state.errorMsg.toString(), Icons.wifi_off,
                    AppTheme.redColor);
                Navigator.of(dialogueContext).pop();
              } else if (state is DeleteRequestLogout) {
                Navigator.of(dialogueContext).pop();
                sessionExpiredDialog(context);
              }
            })
          ],
          child: Column(
            children: [
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: filterList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFilter = index;
                            outgoingDocumentsCubit.getOutgoingDocumentsAPI(
                                filterTypes[index].toString());
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
                            padding: EdgeInsets.only(left: 20.0.w, right: 20.w),
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
                child:
                    BlocBuilder<OutgoingDocumentsCubit, OutgoingDocumentsState>(
                  bloc: outgoingDocumentsCubit,
                  builder: (context, state) {
                    if (state is OutgoingDocumentsSearchLoaded) {
                      List<RequestData> documentsList = state.searchList;
                      if (documentsList.isEmpty) {
                        return const Center(
                            child: Text("Documents not found!",
                                style:
                                    TextStyle(color: Colors.deepPurpleAccent)));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: documentsList.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              // leading: Image.asset(ImageAssets.settingLogo,
                              //     height: 30),
                              title: Text(
                                  documentsList[index].subject.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Doc Type: ${documentsList[index].documentType ?? ''}",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black45,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400)),
                                    Text(
                                        "Date: ${DateFormat('d MMM, yyyy').format(documentsList[index].createdAt!)}",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black45,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400))
                                  ]),
                              trailing: CircleAvatar(
                                backgroundColor:
                                    Colors.deepPurpleAccent.withOpacity(0.1),
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
                    } else if (state is OutgoingDocumentsLoaded) {
                      List<RequestData> documentsList = state.outgoingDocuments;
                      if (documentsList.isEmpty) {
                        return emptyDataWidget("Documents not found!");
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: documentsList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(10.r)),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(ImageAssets.settingLogo,
                                        height: 50,
                                        color: documentsList[index].status ==
                                                'requested'
                                            ? Colors.deepPurpleAccent
                                            : Colors.blue)
                                  ]),
                              title: Text(
                                documentsList[index].subject.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Doc Type: ${documentsList[index].documentType ?? ''}",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black45,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "Date: ${DateFormat('d MMM, yyyy').format(documentsList[index].createdAt!)}",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black45,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: CircleAvatar(
                                backgroundColor:
                                    Colors.deepPurpleAccent.withOpacity(0.1),
                                child: popMenus(
                                  requestData: documentsList[index],
                                  context: context,
                                  options:
                                      documentsList[index].status == 'requested'
                                          ? optionsList
                                          : optionsList2,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is OutgoingDocumentsLoading) {
                      return notificationShimmerLoading();
                    } else if (state is OutgoingDocumentsFailed) {
                      return emptyDataWidget(state.errorMsg.toString());
                    } else if (state is OutgoingDocumentsInternetError) {
                      return Padding(
                          padding: const EdgeInsets.all(25),
                          child: Center(
                              child: Text(state.errorMsg.toString(),
                                  style: const TextStyle(color: Colors.red))));
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> optionsList = [
  {"icon": Icons.delete, "menu": "Remove", "menu_id": 1}
];

List<Map<String, dynamic>> optionsList2 = [
  {"icon": Icons.visibility, "menu": "View", "menu_id": 1},
  {"icon": Icons.download_rounded, "menu": "Download", "menu_id": 2},
];

Widget popMenus(
    {required List<Map<String, dynamic>> options,
    required BuildContext context,
    required RequestData requestData}) {
  return PopupMenuButton(
    elevation: 10,
    padding: EdgeInsets.zero,
    color: Colors.white,
    surfaceTintColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    icon: const Icon(Icons.more_horiz_rounded,
        color: Colors.deepPurpleAccent, size: 18.0),
    offset: const Offset(0, 50),
    itemBuilder: (BuildContext bc) {
      return options
          .map(
            (selectedOption) => PopupMenuItem(
              height: 40,
              padding: EdgeInsets.zero,
              value: selectedOption,
              child: Padding(
                padding: EdgeInsets.only(left: 10.w, right: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      Icon(selectedOption['icon']),
                      const SizedBox(width: 10),
                      Text(selectedOption['menu'] ?? "",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400))
                    ]),
                  ],
                ),
              ),
            ),
          )
          .toList();
    },
    onSelected: (value) async {
      if (value['menu_id'] == 1) {
        if (requestData.status == 'requested') {
          visitorsDeletePermissionDialog(context, () {
            Navigator.pop(context);
            context
                .read<DeleteRequestCubit>()
                .deleteRequestAPI(requestData.id.toString());
          });
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      ViewDocsDetails(fileUrls: requestData.files!)));
        }
      } else {
        context
            .read<DownloadDocumentCubit>()
            .downloadDocument(requestData.files!);
      }
    },
  );
}

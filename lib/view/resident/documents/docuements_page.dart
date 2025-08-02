import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/controller/documents/delete_request/delete_request_cubit.dart';
import 'package:ghp_society_management/controller/documents/documents_count/document_count_cubit.dart';
import 'package:ghp_society_management/controller/documents/send_request/send_request_docs_cubit.dart';
import 'package:ghp_society_management/main.dart';
import 'package:ghp_society_management/view/resident/documents/request_by_me.dart';
import 'package:ghp_society_management/view/resident/documents/request_my_management.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  @override
  void initState() {
    super.initState();
    onFetchData();
  }

  Future onFetchData() async {
    context.read<DocumentCountCubit>().documentCountType();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteRequestCubit, DeleteRequestState>(
          listener: (context, state) async {
            if (state is DeleteRequestSuccessfully) {
              onFetchData();
            }
          },
        ),
        BlocListener<UploadDocumentCubit, UploadDocumentState>(
          listener: (context, state) async {
            if (state is UploadDocumentSuccessfully) {
              onFetchData();
            }
          },
        ),
        BlocListener<SendDocsRequestCubit, SendDocsRequestState>(
          listener: (context, state) async {
            if (state is SendDocsRequestSuccessfully) {
              onFetchData();
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: appbarWidget(title: 'Documents'),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: onFetchData,
            child: BlocBuilder<DocumentCountCubit, DocumentCountState>(
              builder: (context, state) {
                if (state is DocumentCountLoaded) {
                  return SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDocumentTile(
                            title: "Request By Management",
                            count: state.incomingRequestCount,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const IncomingDocumentsScreen()),
                              );
                            },
                          ),
                          _buildDocumentTile(
                            title: "Request By Me",
                            count: state.outGoingRequestCount,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const OutgoingDocumentsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is DocumentCountLoading) {
                  return dashboardSimmerLoading(context);
                } else if (state is DocumentCountFailed) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Text(
                        state.errorMsg,
                        style: TextStyle(
                            color: state is DocumentCountInternetError
                                ? Colors.red
                                : Colors.deepPurpleAccent),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else if (state is DocumentCountInternetError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Text(
                        state.errorMsg,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentTile(
      {required String title,
      required int count,
      required VoidCallback onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                    margin: EdgeInsets.only(bottom: 5),
                    height: size.height * 0.15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppTheme.color6,
                        border: Border.all(color: AppTheme.color6, width: 2)),
                    child: Image.asset(ImageAssets.notice1)),
                count > 0
                    ? Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                            shape: const CircleBorder(),
                            color: AppTheme.primaryColor),
                        child: Center(
                          child: Text(
                            count.toString(),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                    color: AppTheme.backgroundColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        )

        // Container(
        //   margin: const EdgeInsets.symmetric(vertical: 8),
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     border: Border.all(color: Colors.grey[300]!),
        //     borderRadius: BorderRadius.circular(10.r),
        //   ),
        //   child: ListTile(
        //     contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        //     title: Text(
        //       title,
        //       style: GoogleFonts.poppins(
        //         color: Colors.black,
        //         fontSize: 14,
        //         fontWeight: FontWeight.w500,
        //       ),
        //     ),
        //     trailing: Row(
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Container(
        //           width: 30.w,
        //           decoration: ShapeDecoration(
        //             shape: const CircleBorder(),
        //             color: AppTheme.primaryColor
        //           ),
        //           child: Center(
        //             child: Text(
        //               count.toString(),
        //               style: GoogleFonts.poppins(
        //                 color: Colors.white,
        //                 fontSize: 14.sp,
        //                 fontWeight: FontWeight.w500,
        //               ),
        //             ),
        //           ),
        //         ),
        //         Icon(
        //           Icons.navigate_next,
        //           color: AppTheme.primaryColor,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}

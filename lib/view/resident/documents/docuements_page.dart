import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/documents/documents_count/document_count_cubit.dart';
import 'package:ghp_society_management/controller/documents/send_request/send_request_docs_cubit.dart';
import 'package:ghp_society_management/firebase_services.dart';
import 'package:ghp_society_management/view/resident/documents/request_by_me.dart';
import 'package:ghp_society_management/view/resident/documents/request_my_management.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});
  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  late DocumentCountCubit documentCountCubit;

  @override
  void initState() {
    super.initState();
    documentCountCubit = DocumentCountCubit()..documentCountType();
    // Future.delayed(const Duration(seconds: 2), () {
    //   DialogService().startDialogCheck(navigatorKey.currentContext!);
    // });
  }

  @override
  Widget build(BuildContext context) {
    documentCountCubit.documentCountType();

    return MultiBlocListener(
      listeners: [
        BlocListener<UploadDocumentCubit, UploadDocumentState>(
          listener: (context, state) async {
            if (state is UploadDocumentSuccessfully) {
              documentCountCubit.documentCountType();
            }
          },
        ),
        BlocListener<SendDocsRequestCubit, SendDocsRequestState>(
          listener: (context, state) async {
            if (state is SendDocsRequestSuccessfully) {
              documentCountCubit.documentCountType();
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
            title: Text('Documents',
                style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600)))),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              documentCountCubit.documentCountType();
            },
            child: BlocBuilder<DocumentCountCubit, DocumentCountState>(
              bloc: documentCountCubit,
              builder: (context, state) {
                if (state is DocumentCountLoaded) {
                  return ListView(
                    padding: const EdgeInsets.all(10),
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
                  );
                } else if (state is DocumentCountLoading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                  );
                } else if (state is DocumentCountFailed) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Text(
                        state.errorMsg,
                        style: TextStyle(
                          color: state is DocumentCountInternetError
                              ? Colors.red
                              : Colors.deepPurpleAccent,
                        ),
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
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30.w,
                decoration: ShapeDecoration(
                  shape: const CircleBorder(),
                  color: AppTheme.primaryColor,
                ),
                child: Center(
                  child: Text(
                    count.toString(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.navigate_next,
                color: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

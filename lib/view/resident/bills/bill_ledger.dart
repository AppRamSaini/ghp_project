import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/controller/ledger_bill/ledger_cubit.dart';
import 'package:intl/intl.dart';

class LedgerBill extends StatefulWidget {
  const LedgerBill({super.key});

  @override
  State<LedgerBill> createState() => _LedgerBillState();
}

class _LedgerBillState extends State<LedgerBill> {
  final ScrollController _scrollController = ScrollController();
  late LedgerBillCubit _ledgerBillCubit;

  @override
  void initState() {
    super.initState();
    _ledgerBillCubit = LedgerBillCubit()..fetchLedgerBillDataApi();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 300) {
      _ledgerBillCubit.loadMoreBillLedgerData();
    }
  }

  Future onRefresh() async {
    _ledgerBillCubit.fetchLedgerBillDataApi();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(title: 'Bill Ledgers'),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: BlocBuilder<LedgerBillCubit, LedgerBillState>(
          bloc: _ledgerBillCubit,
          builder: (context, state) {
            if (state is LedgerBillLoading) {
              return notificationShimmerLoading();
            }

            if (state is LedgerBillFailed) {
              return emptyDataWidget(state.errorMsg);
            }

            if (state is LedgerBillEmpty) {
              return emptyDataWidget("No ledger found");
            }
            if (state is LedgerBillInternetError) {
              return Center(
                  child: Text(state.errorMsg.toString(),
                      style: const TextStyle(color: Colors.red)));
            }

            var ledgerList = _ledgerBillCubit.ledgerBillDataList;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: ledgerList.length + 1,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index == ledgerList.length) {
                      return _ledgerBillCubit.state is LedgerBillLoadingMore
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()))
                          : const SizedBox.shrink();
                    }

                    String formattedDate = DateFormat('dd MMM yyyy hh:mm a')
                        .format(ledgerList[index].createdAt!);

                    var ledger = ledgerList[index];

                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        border: TableBorder.all(
                            color: Colors.grey[400]!, width: 0.5),
                        children: [
                          customTableData(
                              key: "Transaction Date", value: formattedDate),
                          customTableData(
                              key: "Member Name",
                              value: ledger.member!.name ?? ''),
                          customTableData(
                              key: "Bill ID",
                              value: ledger.source!.id.toString() ?? ''),
                          customTableData(
                              key: "Payment Mode",
                              value: ledger.paymentMode ?? '--'),
                          customTableData(
                              key: "Collector Name",
                              value: ledger.collector != null
                                  ? ledger.collector!.name ?? '--'
                                  : '--'),
                          customTableData(
                              key: "Debit", value: ledger.debit ?? '--'),
                          customTableData(
                              key: "Credit", value: ledger.credit ?? '--'),
                          customTableData(
                              key: "Balance", value: ledger.balance ?? '--'),
                          customTableData(
                              key: "Status",
                              value: ledger.transactionType == 'credit'
                                  ? 'Success'
                                  : '--'),
                        ],
                      ),
                    );
                  },
                ),
                Padding(
                  padding: globalBottomPadding(context),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(color: AppTheme.greyColor),
                    child: BalanceWidget(
                        balance:
                            double.parse(ledgerList.first.balance.toString())),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  TableRow customTableData({String? key, String? value}) => TableRow(children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Text(key.toString(),
                style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600))),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Text(value.toString(),
                style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500))),
      ]);
}

class BalanceWidget extends StatelessWidget {
  final double balance;

  const BalanceWidget({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    String balanceText = "";
    String label = "";

    if (balance > 0) {
      balanceText = balance.toStringAsFixed(2);
      label = "Outstanding";
    } else if (balance < 0) {
      balanceText = balance.toStringAsFixed(2);
      label = "Advance";
    } else {
      balanceText = "0.00";
      label = "Clear";
    }

    return Text(
      "$balanceText ($label)",
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}

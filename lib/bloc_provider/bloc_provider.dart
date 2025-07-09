import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/daliy_helps_member/daily_help_listing/daily_help_cubit.dart';
import 'package:ghp_society_management/controller/daliy_helps_member/daily_helps_checkouts_History_details/daily_help_checkouts_history_cubit.dart';
import 'package:ghp_society_management/controller/documents/delete_request/delete_request_cubit.dart';
import 'package:ghp_society_management/controller/documents/documents_count/document_count_cubit.dart';
import 'package:ghp_society_management/controller/documents/fetch_documents/fetch_documents_cubit.dart';
import 'package:ghp_society_management/controller/documents/incoming_documents/incoming_documents_cubit.dart';
import 'package:ghp_society_management/controller/documents/outgoing_documents/outgoing_documents_cubit.dart';
import 'package:ghp_society_management/controller/documents/send_request/send_request_docs_cubit.dart';
import 'package:ghp_society_management/controller/download_file/download_document_cubit.dart';
import 'package:ghp_society_management/controller/members/search_member/search_member_cubit.dart';
import 'package:ghp_society_management/controller/notification/notification_listing/notification_list_cubit.dart';
import 'package:ghp_society_management/controller/parcel/checkout_parcel/checkout_parcel_cubit.dart';
import 'package:ghp_society_management/controller/parcel/create_parcel/create_parcel_cubit.dart';
import 'package:ghp_society_management/controller/parcel/delete_parcel/delete_parcel_cubit.dart';
import 'package:ghp_society_management/controller/parcel/deliver_parcel/deliver_parcel_cubit.dart';
import 'package:ghp_society_management/controller/parcel/parcel_complaint/parcel_complaint_cubit.dart';
import 'package:ghp_society_management/controller/parcel/parcel_details/parcel_details_cubit.dart';
import 'package:ghp_society_management/controller/parcel/parcel_element/parcel_element_cubit.dart';
import 'package:ghp_society_management/controller/parcel/parcel_listing/parcel_listing_cubit.dart';
import 'package:ghp_society_management/controller/parcel/parcel_pending_counts/parcel_counts_cubit.dart';
import 'package:ghp_society_management/controller/parcel/receive_parcel/receive_parcel_cubit.dart';
import 'package:ghp_society_management/controller/refer_property/create_refer_property/create_refer_property_cubit.dart';
import 'package:ghp_society_management/controller/refer_property/delete_refer_property/delete_refer_property_cubit.dart';
import 'package:ghp_society_management/controller/refer_property/get_refer_property/get_refer_property_cubit.dart';
import 'package:ghp_society_management/controller/refer_property/refer_property_element/refer_property_element_cubit.dart';
import 'package:ghp_society_management/controller/refer_property/update_refer_property/update_refer_property_cubit.dart';
import 'package:ghp_society_management/controller/rent_or_sell_property/delete_property/delete_property_cubit.dart';
import 'package:ghp_society_management/controller/resident_checkout_log/resident_check-in/resident_check_in_cubit.dart';
import 'package:ghp_society_management/controller/resident_checkout_log/resident_check-out/resident_checkout_cubit.dart';
import 'package:ghp_society_management/controller/resident_checkout_log/resident_checkouts/staff_side_checkouts_history_cubit.dart';
import 'package:ghp_society_management/controller/resident_checkout_log/resident_checkouts_history_details/resident_checkouts_details_cubit.dart';
import 'package:ghp_society_management/controller/sos_management/sos_acknowledge/sos_acknowledged_cubit.dart';
import 'package:ghp_society_management/controller/sos_management/sos_category/sos_category_cubit.dart';
import 'package:ghp_society_management/controller/sos_management/sos_element/sos_element_cubit.dart';
import 'package:ghp_society_management/controller/sos_management/submit_sos/submit_sos_cubit.dart';
import 'package:ghp_society_management/controller/visitors/chek_in_check_out/check_in/check_in_cubit.dart';
import 'package:ghp_society_management/controller/visitors/chek_in_check_out/check_out/check_out_cubit.dart';
import 'package:ghp_society_management/controller/visitors/chek_in_check_out/visitors_scan/scan_visitors_cubit.dart';
import 'package:ghp_society_management/controller/visitors/delete_visitors/delete_visitor_cubit.dart';
import 'package:ghp_society_management/controller/visitors/incoming_request/incoming_request_cubit.dart';
import 'package:ghp_society_management/controller/visitors/visitor_request/accept_request/accept_request_cubit.dart';
import 'package:ghp_society_management/controller/visitors/visitor_request/not_responding/not_responde_cubit.dart';
import 'package:ghp_society_management/controller/visitors/visitor_request/resend_request/resend_request_cubit.dart';
import 'package:ghp_society_management/controller/visitors/visitors_feedback/visitors_feedback_cubit.dart';

import '../controller/sos_management/sos_cancel/sos_cancel_cubit.dart';
import '../controller/sos_management/sos_history/sos_history_cubit.dart';

class BlocProviders {
  static final List<BlocProvider> providers = [
    BlocProvider<SelectSocietyCubit>(
        create: (context) => SelectSocietyCubit()..fetchSocietyList()),
    BlocProvider<SendOtpCubit>(create: (context) => SendOtpCubit()),
    BlocProvider<VerifyOtpCubit>(create: (context) => VerifyOtpCubit()),
    BlocProvider<LogoutCubit>(create: (context) => LogoutCubit()),
    BlocProvider<UserProfileCubit>(create: (context) => UserProfileCubit()),
    BlocProvider<EditProfileCubit>(create: (context) => EditProfileCubit()),
    BlocProvider<NoticeModelCubit>(create: (context) => NoticeModelCubit()),
    BlocProvider<NoticeDetailCubit>(create: (context) => NoticeDetailCubit()),
    BlocProvider<EventCubit>(create: (context) => EventCubit()),
    BlocProvider<DownloadDocumentCubit>(
        create: (context) => DownloadDocumentCubit()),
    BlocProvider<CreateVisitorsCubit>(
        create: (context) => CreateVisitorsCubit()),
    BlocProvider<VisitorsElementCubit>(
        create: (context) => VisitorsElementCubit()),
    BlocProvider<DocumentElementsCubit>(
        create: (context) => DocumentElementsCubit()),
    // BlocProvider<ViewVisitorsCubit>(create: (context) => ViewVisitorsCubit()),
    BlocProvider<UploadDocumentCubit>(
        create: (context) => UploadDocumentCubit()),
    BlocProvider<FetchDocumentsCubit>(
        create: (context) => FetchDocumentsCubit()),
    BlocProvider<ReferPropertyElementCubit>(
        create: (context) => ReferPropertyElementCubit()),
    BlocProvider<MyBillsCubit>(create: (context) => MyBillsCubit()),
    BlocProvider<BillDetailsCubit>(create: (context) => BillDetailsCubit()),
    BlocProvider<CreateReferPropertyCubit>(
        create: (context) => CreateReferPropertyCubit()),
    BlocProvider<GetReferPropertyCubit>(
        create: (context) => GetReferPropertyCubit()),
    BlocProvider<BuyRentPropertyCubit>(
        create: (context) => BuyRentPropertyCubit()),
    BlocProvider<PropertyDetailsCubit>(
        create: (context) => PropertyDetailsCubit()),
    BlocProvider<PropertyElementCubit>(
        create: (context) => PropertyElementCubit()),
    BlocProvider<CreateRentPropertyCubit>(
        create: (context) => CreateRentPropertyCubit()),
    BlocProvider<SosCategoryCubit>(create: (context) => SosCategoryCubit()),
    BlocProvider<SosElementCubit>(create: (context) => SosElementCubit()),
    BlocProvider<SocietyContactsCubit>(
        create: (context) => SocietyContactsCubit()),
    BlocProvider<SubmitSosCubit>(create: (context) => SubmitSosCubit()),
    BlocProvider<MembersCubit>(create: (context) => MembersCubit()),
    BlocProvider<CreateSellPropertyCubit>(
        create: (context) => CreateSellPropertyCubit()),
    BlocProvider<UpdateSellPropertyCubit>(
        create: (context) => UpdateSellPropertyCubit()),
    BlocProvider<UpdateRentPropertyCubit>(
        create: (context) => UpdateRentPropertyCubit()),
    BlocProvider<MembersElementCubit>(
        create: (context) => MembersElementCubit()),
    BlocProvider<GetPollsCubit>(create: (context) => GetPollsCubit()),
    BlocProvider<CreatePollsCubit>(create: (context) => CreatePollsCubit()),
    BlocProvider<ServiceCategoriesCubit>(
        create: (context) => ServiceCategoriesCubit()),
    BlocProvider<ServiceProvidersCubit>(
        create: (context) => ServiceProvidersCubit()),
    BlocProvider<RequestCallBackCubit>(
        create: (context) => RequestCallBackCubit()),
    BlocProvider<ComplaintsCubit>(create: (context) => ComplaintsCubit()),
    BlocProvider<CancelComplaintsCubit>(
        create: (context) => CancelComplaintsCubit()),
    BlocProvider<CreateComplaintsCubit>(
        create: (context) => CreateComplaintsCubit()),
    BlocProvider<GroupCubit>(create: (context) => GroupCubit()),
    BlocProvider<GetStaffCubit>(create: (context) => GetStaffCubit()),
    BlocProvider<SlidersCubit>(create: (context) => SlidersCubit()),
    BlocProvider<TermsConditionsCubit>(
        create: (context) => TermsConditionsCubit()),
    BlocProvider<PrivacyPolicyCubit>(create: (context) => PrivacyPolicyCubit()),
    BlocProvider<ServiceRequestHistoryCubit>(
        create: (context) => ServiceRequestHistoryCubit()),
    BlocProvider<GetNotificationSettingsCubit>(
        create: (context) => GetNotificationSettingsCubit()),
    BlocProvider<UpdateNotificationSettingsCubit>(
        create: (context) => UpdateNotificationSettingsCubit()),
    BlocProvider<PaymentServiceCubit>(
        create: (context) => PaymentServiceCubit()),
    BlocProvider<StartServiceCubit>(create: (context) => StartServiceCubit()),
    BlocProvider<DoneServiceCubit>(create: (context) => DoneServiceCubit()),
    BlocProvider<ContactCubit>(create: (context) => ContactCubit()),
    BlocProvider<ServiceRequestCubit>(
        create: (context) => ServiceRequestCubit()),
    BlocProvider<VisitorsListingCubit>(
        create: (context) => VisitorsListingCubit()),
    BlocProvider<VisitorsDetailsCubit>(
        create: (context) => VisitorsDetailsCubit()),
    BlocProvider<UpdateVisitorsStatusCubit>(
        create: (context) => UpdateVisitorsStatusCubit()),
    BlocProvider<CheckInCubit>(create: (context) => CheckInCubit()),
    BlocProvider<CheckOutCubit>(create: (context) => CheckOutCubit()),
    BlocProvider<VisitorsFeedBackCubit>(
        create: (context) => VisitorsFeedBackCubit()),
    BlocProvider<DeleteVisitorCubit>(create: (context) => DeleteVisitorCubit()),
    BlocProvider<DocumentCountCubit>(create: (context) => DocumentCountCubit()),
    BlocProvider<IncomingDocumentsCubit>(
        create: (context) => IncomingDocumentsCubit()),
    BlocProvider<SendDocsRequestCubit>(
        create: (context) => SendDocsRequestCubit()),
    BlocProvider<OutgoingDocumentsCubit>(
        create: (context) => OutgoingDocumentsCubit()),
    BlocProvider<DeleteRequestCubit>(create: (context) => DeleteRequestCubit()),
    BlocProvider<AcceptRequestCubit>(create: (context) => AcceptRequestCubit()),
    BlocProvider<NotRespondingCubit>(create: (context) => NotRespondingCubit()),
    BlocProvider<ResendRequestCubit>(create: (context) => ResendRequestCubit()),
    BlocProvider<NotificationListingCubit>(
        create: (context) => NotificationListingCubit()),
    BlocProvider<ParcelManagementCubit>(
        create: (context) => ParcelManagementCubit()),
    BlocProvider<ParcelDeletetCubit>(create: (context) => ParcelDeletetCubit()),
    BlocProvider<ParcelComplaintCubit>(
        create: (context) => ParcelComplaintCubit()),
    BlocProvider<ParcelDetailsCubit>(create: (context) => ParcelDetailsCubit()),
    BlocProvider<DeliverParcelCubit>(create: (context) => DeliverParcelCubit()),
    BlocProvider<ParcelCheckoutCubit>(
        create: (context) => ParcelCheckoutCubit()),
    BlocProvider<ReceiveParcelCubit>(create: (context) => ReceiveParcelCubit()),
    BlocProvider<ParcelListingCubit>(create: (context) => ParcelListingCubit()),
    BlocProvider<ParcelElementsCubit>(
        create: (context) => ParcelElementsCubit()),
    BlocProvider<ScanVisitorsCubit>(create: (context) => ScanVisitorsCubit()),
    BlocProvider<IncomingRequestCubit>(
        create: (context) => IncomingRequestCubit()),
    BlocProvider<SearchMemberCubit>(create: (context) => SearchMemberCubit()),
    BlocProvider<DeleteReferPropertyCubit>(
        create: (context) => DeleteReferPropertyCubit()),
    BlocProvider<UpdateReferPropertyCubit>(
        create: (context) => UpdateReferPropertyCubit()),
    BlocProvider<DeletePropertyCubit>(
        create: (context) => DeletePropertyCubit()),
    BlocProvider<ParcelCountsCubit>(create: (context) => ParcelCountsCubit()),
    BlocProvider<SosHistoryCubit>(create: (context) => SosHistoryCubit()),
    BlocProvider<AcknowledgedCubit>(create: (context) => AcknowledgedCubit()),
    BlocProvider<SosCancelCubit>(create: (context) => SosCancelCubit()),
    BlocProvider<ResidentCheckInCubit>(
        create: (context) => ResidentCheckInCubit()),
    BlocProvider<ResidentCheckOutCubit>(
        create: (context) => ResidentCheckOutCubit()),
    BlocProvider<StaffSideResidentCheckoutsHistoryCubit>(
        create: (context) => StaffSideResidentCheckoutsHistoryCubit()),
    BlocProvider<ResidentCheckoutsHistoryDetailsCubit>(
        create: (context) => ResidentCheckoutsHistoryDetailsCubit()),
    BlocProvider<DailyHelpListingCubit>(
        create: (context) => DailyHelpListingCubit()),
    BlocProvider<DailyHelpHistoryDetailsCubit>(
        create: (context) => DailyHelpHistoryDetailsCubit()),
  ];
}

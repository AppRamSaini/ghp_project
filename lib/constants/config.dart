class Config {
  static const String baseURL =
      // 'https://dev-society.ghpjaipur.com/api/user/v1/'; // dev url
      'https://society.ghpjaipur.com/api/user/v1/'; // production url
// 'https://ghp-society.laraveldevelopmentcompany.com/api/user/v1/'; // old url
}

/// new code
class Routes {
  static const String society = '${Config.baseURL}societies';
  static const String sendOtp = 'otp';
  static const String verifyOtp = 'otp-verify';
  static const String logout = 'logout';
  static const String userProfile = 'profile';
  static const String editProfile = 'profile-update';
  static const String notice = 'notice/all';
  static const String noticeDetail = 'notice/details/';
  static const String event = 'event/all';
  static const String visitorsElement = 'visitor/elements';
  static const String createVisitors = 'visitor/create';
  static const String viewVisitors = 'visitor/all';
  static const String documentElement = 'document/elements';
  static const String createDocuments = 'document/upload-document';
  static const String fetchDocuments = 'document/all';
  static const String referPropertyElements = 'refer-property/elements';
  static const String sosCategory = 'sos/categories';
  static const String sosElement = 'sos/elements';
  static const String societyContacts = 'society/contacts';
  static const String submitSos = 'property/sos/send';

  static String members(String bloc, String floor, String type) =>
      'society/members?search=&block_name=$bloc&floor_number=$floor&type=$type';
  static const String membersElements = 'society/elements';
  static const String serviceCategories = 'service-provider/categories';
  static const String requestCallBack = 'service-provider/callback-request';
  static const String serviceHistory = 'service/requests-history';
  static const String serviceRequest = 'service/requests';
  static const String contact = 'support/contact';
  static const String startService = 'service/start';
  static const String doneService = 'service/mark-as-done';
  static const String serviceProviders =
      'service-provider/all?service_category_id=';
  static const String staff = "staff/all";

  static String getMyBills(String propertyID, String billType) =>
      'bill/all/$propertyID?bill_type=$billType&page=';
  static String getBillDetails = 'bill/details/';
  static const String createReferProperty = 'refer-property/create';
  static const String referPropertyList = 'refer-property/all';
  static const String deleteReferProperty = 'refer-property/delete/';
  static const String updateReferProperty = 'refer-property/update/';

  static String rentOrSellProperty(String propertyId, String type) =>
      'trade/societylisting/all/$propertyId?type=$type&page=';

  static String myListingProperty(String propertyId, String type) =>
      'trade/mylisting/all/$propertyId?type=$type&page=';

  static String propertyDetails = 'trade/details/';
  static String propertyElement = 'trade/elements';
  static String createRentProperty = 'trade/rent/create';
  static String createSellProperty = 'trade/sell/create';
  static String updateSellProperty = 'trade/sell/update/';
  static String updateRentProperty = 'trade/rent/update/';
  static String deleteRentSellProperty = 'trade/rent-sell/delete/';
  static String getAllPolls = 'poll/all';
  static String createPolls = 'poll/vote/';

  static fetchComplaints(String propertyId) =>
      'complaint/all/$propertyId?page=';
  static String fetchComplaintsService = 'complaint/elements';
  static String cancelComplaints = 'complaint/status/cancel';
  static String createComplaints = 'complaint/create';
  static String getSliders = 'sliders';
  static String termsOfConditions = 'terms-of-use';
  static String privacyPolicy = '${Config.baseURL}privacy-policy';
  static String privacyPolicyPage = '${Config.baseURL}privacy-policy-page';
  static String getNotificationSettings = 'settings/notifications';
  static String updateNotificationSettings = 'settings/notification';

  static String visitorsListing(
          String propertyID, String search, String toDate, String fromDate) =>
      'visitor/all/$propertyID?search=$search&from_date=$fromDate&to_date=$toDate&filter_type=';

  static String visitorsListingForStaff(
          String search, String toDate, String fromDate) =>
      'visitor/all?search=$search&from_date=$fromDate&to_date=$toDate&filter_type=';
  static String visitorsDetails = 'visitor/details/';
  static String blockUnBlockVisitors = 'visitor/status/';
  static String checkIn = 'visitor/check-in';
  static String checkOut = 'visitor/check-out';
  static String visitorsFeedback = 'visitor/give-feedback';
  static String deleteVisitor = 'visitor/delete-visitor/';
  static String incomingRequestResponse = 'visitor/visitor-incoming-response';
  static String incomingVisitorRequest =
      'visitor/visitor-incoming-requests-list';
  static String documentsCounts = 'property/document/requests-count';
  static String getIncomingDocuments =
      'property/document/incoming-requests?filter_type=';
  static String getOutgoingDocuments =
      'property/document/outgoing-requests?filter_type=';
  static String sendRequest = 'property/document/send-request';
  static String deleteRequest = 'document/delete/';
  static String downloadDocuments = '/document/files/';
  static String resendVisitorsRequest = 'visitor/visitor-incoming-request';
  static String residenceNotResponding = 'visitor/resident-not-responding';
  static String getAllNotification = 'notification/list';
  static String createParcel = 'parcel/create';

  static getAllParcel(String propertyId) =>
      'parcel/all/$propertyId?filter_type=';
  static String deleteParcel = 'parcel/delete-parcel/';
  static String parcelComplaint = 'parcel/create-complaint';
  static String parcelDetails = 'parcel/details/';
  static String parcelCheckout = 'parcel/check-out';
  static String deliverParcel = 'parcel/parcel-delivered';
  static String receiveParcel = 'parcel/parcel-received';
  static String parcelElement = 'parcel/elements';
  static String parcelCounts = 'parcel/pending-count';
  static String readNotifications = 'notification/mark-as-read';
  static String searchMember = 'society/society-members?search=';
  static String sosHistory = 'sos/all';
  static String sosAcknowledge = 'sos/acknowledge';
  static String sosCancel = 'sos/cancel';
  static String residentCheckIn = 'resident/checkin';
  static String residentCheckOut = 'resident/checkout';
  static String residentCheckoutsHistory = 'resident/all-checkin-log';
  static String residentCheckoutsHistoryDetails = 'resident/checkin-details';

  static String dailyHelpsMembers(String propertyId) =>
      'society/members/$propertyId?type=daily_help';
  static String dailyHelpsStaffSide = 'society/members?type=daily_help';
  static String dailyHelpsMembersDetails =
      'resident/daily-help-checkin-details/';
  static String billPayment = 'bill/payment-details';

  ///<<<----------------NEW MODULE------------------>>>///
  static String propertyListing = '${Config.baseURL}properties/list';
  static String ledgerBill =
      '${Config.baseURL}member/ledger/830?from_date=2025-08-01&to_date=2025-08-31';
}

var data = {
  "status": true,
  "message": "Form dropdowns retrieved successfully",
  "data": {
    "visitor_types": [
      {"type": "Relatives"},
      {"type": "Guest"},
      {"type": "Friend"},
      {"type": "Delivery Person - Food (Zomato, Swiggy)"},
      {"type": "Delivery Person - Grocery (Blinkit, BigBasket)"},
      {"type": "Courier / Parcel Delivery"},
      {"type": "Cab / Auto Driver (Ola, Uber, Rapido)"},
      {"type": "Service Provider - Plumber, Electrician etc.."},
      {"type": "Medical Staff - Doctor, Nurse, Caretaker"},
      {"type": "Government Official / Inspector"},
      {"type": "Society Staff / Management"},
      {"type": "Household Worker"}
    ],
    "visiting_frequencies": [
      {"frequency": "One-Time / Single Visit"},
      {"frequency": "Daily"},
      {"frequency": "Weekly"},
      {"frequency": "Bi-Weekly"},
      {"frequency": "Monthly"},
      {"frequency": "Quarterly (3 Months)"},
      {"frequency": "Yearly"},
      {"frequency": "Frequently"},
      {"frequency": "Occasionally"},
      {"frequency": "Emergency Visit"},
      {"frequency": "Custom"}
    ],
    "visitor_validity": [
      {"type": "1 Hour"},
      {"type": "3 Hours"},
      {"type": "6 Hours"},
      {"type": "12 Hours"},
      {"type": "24 Hours"},
      {"type": "48 Hours (2 Days)"},
      {"type": "7 Days"},
      {"type": "15 Days"},
      {"type": "30 Days"},
      {"type": "90 Days (3 Months)"},
      {"type": "180 Days (6 Months)"},
      {"type": "365 Days (1 Year)"},
      {"type": "Custom"}
    ],
    "visitor_reasons": [
      {
        "reason":
            "Personal Visit - Meeting relatives, friends or family members"
      },
      {
        "reason":
            "Family Gathering - Attending a function, festival or celebration at home"
      },
      {
        "reason":
            "Delivery - Food delivery, courier service, grocery or parcel drop"
      },
      {
        "reason":
            "Maintenance / Repair - Electrician, plumber, carpenter, AC repair etc."
      },
      {
        "reason":
            "Official Work - Business meeting, documentation, or society-related task"
      },
      {
        "reason":
            "Bill / Rent Collection - Utility bills, rent collection or EMI pickup"
      },
      {
        "reason":
            "Health / Medical - Doctor visit, nurse, medical check-up or medicine delivery"
      },
      {
        "reason": "Domestic Help - House help, cook, maid or babysitter arrival"
      },
      {
        "reason":
            "Child Related - Pick-up or drop for school, tuition, hobby classes"
      },
      {
        "reason":
            "Festival / Occasion - Attending Diwali, Holi, birthday or anniversary party"
      },
      {
        "reason":
            "Society Staff - Security, management or committee members meeting"
      },
      {
        "reason":
            "Official Authority - Police, government officer, or inspection visit"
      },
      {
        "reason":
            "Other Services - Beautician, tutor, yoga trainer, personal coach etc."
      },
      {
        "reason":
            "Guest / Friend Stay - Visitors coming for overnight or short stay"
      },
      {"reason": "Emergency Help - Ambulance, urgent medical support"},
      {"reason": "Shopping Delivery - Furniture, electronics, heavy goods"},
      {"reason": "Society Meeting - RWA/committee meeting attendance"},
      {"reason": "Driver Pickup / Drop - Car driver reporting for duty"},
      {"reason": "Event Participation - Marriage, party, cultural event"},
      {"reason": "Other - Any reason not listed above"}
    ]
  }
};

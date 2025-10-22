class BookingUrlService {
  // Private constructor to prevent instantiation
  BookingUrlService._();

  static String getFlightsUrl() =>
      "https://my.trip.com/flights?locale=en_my&curr=myr&allianceid=14900&sid=1621410&ppcid=ckid-3738486021_adid-562837443537_akid-kwd-18709060_adgid-131652448924&utm_source=google&utm_medium=cpc&utm_campaign=15311336622&gad_source=1&gad_campaignid=15311336622&gbraid=0AAAAABn2eFKKhm02i9QdER66e23rJMtc2&gclid=CjwKCAjw3tzHBhBREiwAlMJoUq7jr7rE5d-hVJFdVHq2bESjhzBib7VYJ_BvhsMct21VuYUHehW-7BoCOrMQAvD_BwE";
  static String getStaysUrl() => "https://www.booking.com";
  static String getCarRentalUrl() =>
      "https://my.trip.com/carhire/?serverRoute=1&pcountryid=2&locale=en_my&curr=MYR&channelid=238827&allianceid=14900&sid=118264056&ppcid=ckid-28731987777_adid-720418491534_akid-kwd-125505158_adgid-165329482490&utm_source=google&utm_medium=cpc&utm_campaign=21888635894&gad_source=1&gad_campaignid=21888635894&gbraid=0AAAAABn2eFJCIO2YiLoSLlm8_19lCS7A-&gclid=CjwKCAjw3tzHBhBREiwAlMJoUnyalSAekX4h4bOBQfAuq8n1PxxfAsuJ_Q7QTh2g2c6iIWGJQET8pBoCzxwQAvD_BwE";
  static String getTicketsUrl() => "https://www.klook.com";

  // Optional: use a map for easier lookup
  static Map<String, String> urls = {
    "Flights": getFlightsUrl(),
    "Stays": getStaysUrl(),
    "Car Rental": getCarRentalUrl(),
    "Tickets": getTicketsUrl(),
  };

  static String getUrlByLabel(String label) => urls[label] ?? "";
}

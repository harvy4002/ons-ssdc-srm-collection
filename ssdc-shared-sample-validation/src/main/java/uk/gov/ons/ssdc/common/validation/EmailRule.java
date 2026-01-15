package uk.gov.ons.ssdc.common.validation;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.net.IDN;
import java.util.Optional;
import java.util.regex.Pattern;

/*
The validation code is from
https://github.com/alphagov/notifications-utils/blob/7d48b8f825fafb0db0bad106ccccdd1f889cf657/notifications_utils/recipients.py#L634

This is to align our code with the gov notify service as best as possible.

The code has been manually converted from Python to Java.  The related test email addresses are based on their email address
tests too.

Their comment:
   almost exactly the same as by https://github.com/wtforms/wtforms/blob/master/wtforms/validators.py,
   with minor tweaks for SES compatibility - to avoid complications we are a lot stricter with the local part
   than neccessary - we don't allow any double quotes or semicolons to prevent SES Technical Failures


*/
@JsonAutoDetect(fieldVisibility = JsonAutoDetect.Visibility.ANY)
public class EmailRule implements Rule {

  /* Regexes from
   https://github.com/alphagov/notifications-utils/blob/7d48b8f825fafb0db0bad106ccccdd1f889cf657/notifications_utils/__init__.py#L11
  */
  private static final String EMAIL_REGEX = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~\\-]+@([^.@][^@\\s]+)$";
  private static final String TOP_LEVEL_DOMAIN_REGEX = "^([a-z]{2,63}|xn--([a-z0-9]+-)*[a-z0-9]+)$";
  private static final String HOSTNAME_PART_REGEX = "^(xn|[a-z0-9]+)(-?-[a-z0-9]+)*$";

  private static final int MAX_EMAIL_LENGTH = 320;
  public static final int MAX_HOSTNAME_LENGTH = 253;
  public static final int MAX_PART_LENGTH = 63;

  private static final Pattern emailPattern = Pattern.compile(EMAIL_REGEX);
  private static final Pattern hostNamePartPattern =
      Pattern.compile(HOSTNAME_PART_REGEX, Pattern.CASE_INSENSITIVE);
  private static final Pattern topLevelDomainPattern =
      Pattern.compile(TOP_LEVEL_DOMAIN_REGEX, Pattern.CASE_INSENSITIVE);

  private final boolean mandatory;

  @JsonCreator
  public EmailRule(@JsonProperty(value = "mandatory") boolean mandatory) {
    this.mandatory = mandatory;
  }

  @Override
  public Optional<String> checkValidity(String email) {

    if (!this.mandatory && email.isEmpty()) {
      return Optional.empty();
    }

    Optional<String> errorsOpt = checkBasicRegexLengthAndPeriods(email);
    if (errorsOpt.isPresent()) {
      return errorsOpt;
    }

    // Now split on @, check it's 2 long
    String[] emailSplit = email.split("@");
    if (emailSplit.length != 2) {
      return Optional.of(
          "Expected splitting email on @ to equal 2, instead equalled: " + emailSplit.length);
    }

    String hostName = emailSplit[1];
    Optional<String> hostnameInAsciiOptional = internationalizedDomainName(hostName);
    if (hostnameInAsciiOptional.isEmpty()) {
      return Optional.of("Non-ASCII character found in email's host name: " + hostName);
    }
    hostName = hostnameInAsciiOptional.get();

    // split the hostName which is everything after the @
    String[] parts = hostName.split("\\.");

    if (hostName.length() > MAX_HOSTNAME_LENGTH) {
      return Optional.of("Email hostname longer than: " + MAX_HOSTNAME_LENGTH);
    }

    return checkPartsOfHostName(parts);
  }

  /*
   idna = "Internationalized domain name" - this encode/decode cycle converts unicode into its accurate ascii
  representation as the web uses. '例え.テスト'.encode('idna') == b'xn--r8jz45g.xn--zckzah'
    */
  private Optional<String> internationalizedDomainName(String data) {
    try {
      return Optional.of(IDN.toASCII(data));
    } catch (IllegalArgumentException ex) {
      return Optional.empty();
    }
  }

  private Optional<String> checkBasicRegexLengthAndPeriods(String data) {
    if (!emailPattern.matcher(data).matches()) {
      return Optional.of("Email didn't match regex");
    }

    if (data.length() > MAX_EMAIL_LENGTH) {
      return Optional.of("Email longer than: " + MAX_EMAIL_LENGTH);
    }

    if (data.contains("..")) {
      return Optional.of("Email contains consecutive periods");
    }

    return Optional.empty();
  }

  private Optional<String> checkPartsOfHostName(String[] parts) {
    if (parts.length < 2) {
      return Optional.of("Email hostname parts less than 2");
    }

    // loop over each part of the hostname checking it's length, and regex
    for (String part : parts) {
      if (part == null) {
        return Optional.of("part of hostname null");
      }

      if (part.length() > MAX_PART_LENGTH) {
        return Optional.of("Email part longer than: " + MAX_PART_LENGTH);
      }

      if (!hostNamePartPattern.matcher(part).matches()) {
        return Optional.of("part of hostname does not match REGEX");
      }
    }

    return checkTopLevelDomain(parts);
  }

  private Optional<String> checkTopLevelDomain(String[] parts) {
    // Top Level Domain, or the last part of an emailAddress
    String topLevelDomain = parts[parts.length - 1];

    if (!topLevelDomainPattern.matcher(topLevelDomain).matches()) {
      return Optional.of("Email didn't match regex");
    }

    return Optional.empty();
  }
}

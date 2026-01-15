package uk.gov.ons.ssdc.common.validation;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.stream.Stream;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

class EmailRuleTest {

  EmailRule emailRule = new EmailRule(false);
  EmailRule mandatoryEmailRule = new EmailRule(true);

  /* correct and incorrect email addresses from:
  https://github.com/alphagov/notifications-utils/blob/7d48b8f825fafb0db0bad106ccccdd1f889cf657/tests/test_recipient_validation.py#L101
   */

  private static Stream<Arguments> validEmailProvider() {
    return Stream.of(
            "email@domain.com",
            "email@domain.COM",
            "firstname.lastname@domain.com",
            "firstname.o\'lastname@domain.com",
            "email@subdomain.domain.com",
            "firstname+lastname@domain.com",
            "1234567890@domain.com",
            "email@domain-one.com",
            "_______@domain.com",
            "email@domain.name",
            "email@domain.superlongtld",
            "email@domain.co.jp",
            "firstname-lastname@domain.com",
            "info@german-financial-services.vermögensberatung",
            "info@german-financial-services.reallylongarbitrarytldthatiswaytoohugejustincase",
            "japanese-info@例え.テスト",
            "email@double--hyphen.com")
        .map(Arguments::of);
  }

  private static Stream<Arguments> invalidEmailProvider() {
    return Stream.of(
            "email@123.123.123.123",
            "email@[123.123.123.123]",
            "plainaddress",
            "@no-local-part.com",
            "Outlook Contact <outlook-contact@domain.com>",
            "no-at.domain.com",
            "no-tld@domain",
            ";beginning-semicolon@domain.co.uk",
            "middle-semicolon@domain.co;uk",
            "trailing-semicolon@domain.com;",
            "\"email+leading-quotes@domain.com",
            "email+middle\"-quotes@domain.com",
            "\"quoted-local-part\"@domain.com",
            "\"quoted@domain.com\"",
            "lots-of-dots@domain..gov..uk",
            "two-dots..in-local@domain.com",
            "multiple@domains@domain.com",
            "spaces in local@domain.com",
            "spaces-in-domain@dom ain.com",
            "underscores-in-domain@dom_ain.com",
            "pipe-in-domain@example.com|gov.uk",
            "comma,in-local@gov.uk",
            "comma-in-domain@domain,gov.uk",
            "pound-sign-in-local£@domain.com",
            "local-with-’-apostrophe@domain.com",
            "local-with-”-quotes@domain.com",
            "domain-starts-with-a-dot@.domain.com",
            "brackets(in)local@domain.com",
            "incorrect-punycode@xn---something.com",
            " nonascii@example.com ",
            "nonascii@example.com",
            "\u00F6nonascii@mail.com")
        .map(Arguments::of);
  };

  @ParameterizedTest
  @MethodSource("validEmailProvider")
  void testValidateEmailAddressValid(String emailAddress) {
    assertThat(emailRule.checkValidity(emailAddress)).isEmpty();
  }

  @ParameterizedTest
  @MethodSource("invalidEmailProvider")
  void testValidateEmailAddressInvalid(String emailAddress) {
    assertThat(emailRule.checkValidity(emailAddress)).isNotEmpty();
  }

  @Test
  void testValidateEmailAddressEmptyValid() {
    assertThat(emailRule.checkValidity("")).isEmpty();
  }

  @ParameterizedTest
  @MethodSource("validEmailProvider")
  void testValidateEmailAddressMandatoryValid(String emailAddress) {
    assertThat(mandatoryEmailRule.checkValidity(emailAddress)).isEmpty();
  }

  @ParameterizedTest
  @MethodSource("invalidEmailProvider")
  void testValidateEmailAddressesMandatoryInvalid(String emailAddress) {
    assertThat(mandatoryEmailRule.checkValidity(emailAddress)).isNotEmpty();
  }

  @Test
  void testValidateEmailAddressMandatoryEmptyInvalid() {
    assertThat(mandatoryEmailRule.checkValidity("")).isNotEmpty();
  }

  // separate java test for this as different test/formatting syntax from Python
  @Test
  void testLongEmailAddress() {
    String tooLongEmail = "email-too-long-" + "a".repeat(320) + "@example.com";
    assertThat(emailRule.checkValidity(tooLongEmail)).isNotEmpty();
  }
}

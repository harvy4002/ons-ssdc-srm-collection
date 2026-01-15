package uk.gov.ons.ssdc.common.validation;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.Optional;
import org.junit.jupiter.api.Test;

class RegexRuleTest {
  private static final String TEST_REGEX_UK_MOBILE_NUMBER = "^07[0-9]{9}$";
  private static final String TEST_REGEX_UK_MOBILE_NUMBER_ERROR = "Not a valid UK mobile number";

  @Test
  void checkValidityValidPhoneNumber() {
    RegexRule underTest =
        new RegexRule(TEST_REGEX_UK_MOBILE_NUMBER, TEST_REGEX_UK_MOBILE_NUMBER_ERROR);

    Optional<String> actualResult = underTest.checkValidity("07123456789");
    assertThat(actualResult).isNotPresent();
  }

  @Test
  void checkValidityInvalidPhoneNumberNonNumeric() {
    RegexRule underTest =
        new RegexRule(TEST_REGEX_UK_MOBILE_NUMBER, TEST_REGEX_UK_MOBILE_NUMBER_ERROR);

    Optional<String> actualResult = underTest.checkValidity("07123456xxx");
    assertThat(actualResult).isPresent().contains(TEST_REGEX_UK_MOBILE_NUMBER_ERROR);
  }

  @Test
  void checkValidityInvalidPhoneNumberTooShort() {
    RegexRule underTest =
        new RegexRule(TEST_REGEX_UK_MOBILE_NUMBER, TEST_REGEX_UK_MOBILE_NUMBER_ERROR);

    Optional<String> actualResult = underTest.checkValidity("0712345");
    assertThat(actualResult).isPresent().contains(TEST_REGEX_UK_MOBILE_NUMBER_ERROR);
  }

  @Test
  void checkValidityInvalidPhoneNumberTooLong() {
    RegexRule underTest =
        new RegexRule(TEST_REGEX_UK_MOBILE_NUMBER, TEST_REGEX_UK_MOBILE_NUMBER_ERROR);

    Optional<String> actualResult = underTest.checkValidity("07123456789123456789");
    assertThat(actualResult).isPresent().contains(TEST_REGEX_UK_MOBILE_NUMBER_ERROR);
  }
}

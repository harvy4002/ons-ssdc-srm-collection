package uk.gov.ons.ssdc.common.validation;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.Optional;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

public class ISODateTimeRuleTest {

  @ParameterizedTest
  @ValueSource(strings = {"2021-10-09T15:45:33.123Z", "2021-10-09T12:00+00"})
  void checkValidityValid(String dateTime) {
    ISODateTimeRule underTest = new ISODateTimeRule();
    Optional<String> validity = underTest.checkValidity(dateTime);
    assertThat(validity.isPresent()).isFalse();
  }

  @Test
  void checkValidityInvalid() {
    ISODateTimeRule underTest = new ISODateTimeRule();
    Optional<String> validity = underTest.checkValidity("66-66-6666:66:66:66.666Z");
    assertThat(validity.isPresent()).isTrue();
    assertThat(validity.get()).isEqualTo("Not a valid ISO date time");
  }
}

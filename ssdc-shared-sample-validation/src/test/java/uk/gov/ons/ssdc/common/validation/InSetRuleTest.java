package uk.gov.ons.ssdc.common.validation;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.*;

import java.util.Optional;
import org.junit.jupiter.api.Test;

class InSetRuleTest {

  @Test
  void checkValidityValid() {
    InSetRule underTest = new InSetRule(new String[] {"foo", "bar"});
    Optional<String> validity = underTest.checkValidity("foo");
    assertThat(validity).isNotPresent();
  }

  @Test
  void checkValidityInvalid() {
    InSetRule underTest = new InSetRule(new String[] {"foo", "bar"});
    Optional<String> validity = underTest.checkValidity("baz");
    assertThat(validity).isPresent();
    assertThat(validity.get()).startsWith("Not in set of");
  }
}

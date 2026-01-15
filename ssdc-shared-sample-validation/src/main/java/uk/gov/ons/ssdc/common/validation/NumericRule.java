package uk.gov.ons.ssdc.common.validation;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import java.util.Optional;

@JsonAutoDetect(fieldVisibility = JsonAutoDetect.Visibility.ANY)
public class NumericRule implements Rule {
  @Override
  public Optional<String> checkValidity(String data) {
    if (data.matches("\\d*")) {
      return Optional.empty();
    }

    return Optional.of("Contains non digit characters");
  }
}

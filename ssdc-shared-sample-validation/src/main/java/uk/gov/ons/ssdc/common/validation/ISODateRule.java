package uk.gov.ons.ssdc.common.validation;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import java.time.LocalDate;
import java.util.Optional;

@JsonAutoDetect(fieldVisibility = JsonAutoDetect.Visibility.ANY)
public class ISODateRule implements Rule {

  @Override
  public Optional<String> checkValidity(String data) {
    try {
      LocalDate.parse(data);
      return Optional.empty();
    } catch (Exception e) {
      return Optional.of("Not a valid ISO date");
    }
  }
}

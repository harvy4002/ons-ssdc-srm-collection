package uk.gov.ons.ssdc.common.validation;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.Optional;
import org.springframework.util.StringUtils;

public class RegexRule implements Rule {
  private final String expression;
  private final String userFriendlyError;

  @JsonCreator
  public RegexRule(
      @JsonProperty("expression") String expression,
      @JsonProperty("userFriendlyError") String userFriendlyError) {
    this.expression = expression;
    this.userFriendlyError = userFriendlyError;
  }

  @Override
  public Optional<String> checkValidity(String data) {
    if (!data.matches(expression)) {
      if (StringUtils.hasText(userFriendlyError)) {
        return Optional.of(userFriendlyError);
      } else {
        return Optional.of("Value does not match regex expression: " + expression);
      }
    }

    return Optional.empty();
  }

  public String getExpression() {
    return expression;
  }

  public String getUserFriendlyError() {
    return userFriendlyError;
  }
}

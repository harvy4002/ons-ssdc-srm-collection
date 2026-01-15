package uk.gov.ons.ssdc.common.validation;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import java.io.Serializable;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class ColumnValidator implements Serializable {

  private final String columnName;

  private final boolean sensitive;

  @JsonTypeInfo(
      use = JsonTypeInfo.Id.CLASS,
      include = JsonTypeInfo.As.PROPERTY,
      property = "className")
  private Rule[] rules;

  @JsonCreator
  public ColumnValidator(
      @JsonProperty("columnName") String columnName,
      @JsonProperty("sensitive") boolean sensitive,
      @JsonProperty("rules") Rule[] rules) {
    this.columnName = columnName;
    this.sensitive = sensitive;
    this.rules = rules.clone();
  }

  public Optional<String> validateRow(Map<String, String> rowData) {
    return validateData(rowData.get(columnName), false);
  }

  public Optional<String> validateRow(
      Map<String, String> rowData, boolean excludeDataFromReturnedErrorMsgs) {
    return validateData(rowData.get(columnName), excludeDataFromReturnedErrorMsgs);
  }

  public Optional<String> validateData(
      String dataToValidate, boolean excludeDataFromReturnedErrorMsgs) {
    List<String> validationErrors = new LinkedList<>();

    for (Rule rule : rules) {
      Optional<String> validationError = rule.checkValidity(dataToValidate);
      if (validationError.isPresent()) {
        if (excludeDataFromReturnedErrorMsgs) {
          validationErrors.add(
              "Column '"
                  + columnName
                  + "' Failed validation for Rule '"
                  + rule.getClass().getSimpleName()
                  + "' validation error: "
                  + validationError.get());
        } else {
          validationErrors.add(
              "Column '"
                  + columnName
                  + "' value '"
                  + dataToValidate
                  + "' validation error: "
                  + validationError.get());
        }
      }
    }

    if (!validationErrors.isEmpty()) {
      return Optional.of(String.join(", ", validationErrors));
    }

    return Optional.empty();
  }

  public String getColumnName() {
    return columnName;
  }

  public boolean isSensitive() {
    return sensitive;
  }

  public Rule[] getRules() {
    return rules.clone();
  }
}

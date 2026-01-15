package src.main.java.uk.gov.ons.ssdc.common.model.entity;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;

@Getter
public class EqLaunchSettings {

  private final String sampleField;
  private final String launchDataFieldName;
  private final boolean mandatory;

  @JsonCreator
  public EqLaunchSettings(
      @JsonProperty("sampleField") String sampleField,
      @JsonProperty("launchDataFieldName") String launchDataFieldName,
      @JsonProperty("mandatory") boolean mandatory) {
    this.sampleField = sampleField;
    this.launchDataFieldName = launchDataFieldName;
    this.mandatory = mandatory;
  }
}

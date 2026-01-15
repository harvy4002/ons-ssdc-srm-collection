package uk.gov.ons.ssdc.common.model.entity;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.io.Serializable;
import lombok.Getter;
import src.main.java.uk.gov.ons.ssdc.common.model.entity.EqLaunchSettings;

@Getter
public class CollectionInstrumentSelectionRule implements Serializable {
  private final int priority;
  private final String spelExpression;
  private final String collectionInstrumentUrl;
  private final EqLaunchSettings[] eqLaunchSettings;

  @JsonCreator
  public CollectionInstrumentSelectionRule(
      @JsonProperty("priority") int priority,
      @JsonProperty("spelExpression") String spelExpression,
      @JsonProperty("collectionInstrumentUrl") String collectionInstrumentUrl,
      @JsonProperty("eqLaunchSettings") EqLaunchSettings[] eqLaunchSettings) {
    this.priority = priority;
    this.spelExpression = spelExpression;
    this.collectionInstrumentUrl = collectionInstrumentUrl;

    if (eqLaunchSettings != null) {
      this.eqLaunchSettings = eqLaunchSettings.clone();
    } else {
      this.eqLaunchSettings = new EqLaunchSettings[0];
    }
  }
}

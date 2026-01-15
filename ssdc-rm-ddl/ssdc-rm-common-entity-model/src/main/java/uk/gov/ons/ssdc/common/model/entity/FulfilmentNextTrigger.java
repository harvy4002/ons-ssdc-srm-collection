package uk.gov.ons.ssdc.common.model.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;
import java.util.UUID;
import lombok.Data;
import org.hibernate.annotations.DynamicUpdate;

@Entity
@Data
@DynamicUpdate
public class FulfilmentNextTrigger {
  @Id private UUID id;

  @Column(nullable = false, columnDefinition = "timestamp with time zone")
  private OffsetDateTime triggerDateTime;
}

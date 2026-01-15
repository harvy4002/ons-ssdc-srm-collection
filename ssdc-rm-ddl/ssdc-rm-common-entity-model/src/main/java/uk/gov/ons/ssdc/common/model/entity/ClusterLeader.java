package uk.gov.ons.ssdc.common.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import java.time.OffsetDateTime;
import java.util.UUID;
import lombok.Data;
import org.hibernate.annotations.DynamicUpdate;

@Data
@Entity
@DynamicUpdate
public class ClusterLeader {
  @Id private UUID id;

  @Column(nullable = false)
  private String hostName;

  @Column(nullable = false, columnDefinition = "timestamp with time zone")
  private OffsetDateTime hostLastSeenAliveAt;
}

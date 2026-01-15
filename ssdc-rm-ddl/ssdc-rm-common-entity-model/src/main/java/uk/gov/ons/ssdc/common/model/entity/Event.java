package uk.gov.ons.ssdc.common.model.entity;

import io.hypersistence.utils.hibernate.type.json.JsonBinaryType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import java.time.OffsetDateTime;
import java.util.UUID;
import lombok.Data;
import lombok.ToString;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Type;

// The bidirectional relationships with other entities can cause stack overflows with the default
// toString
@ToString(onlyExplicitlyIncluded = true)
@Data
@Entity
@DynamicUpdate
public class Event {
  @Id private UUID id;

  @ManyToOne private UacQidLink uacQidLink;

  @ManyToOne private Case caze;

  @Column(nullable = false, columnDefinition = "timestamp with time zone")
  private OffsetDateTime dateTime;

  @Column(nullable = false)
  private String description;

  @Column(nullable = false, columnDefinition = "timestamp with time zone")
  private OffsetDateTime processedAt;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private EventType type;

  @Column(nullable = false)
  private String channel;

  @Column(nullable = false)
  private String source;

  @Column(nullable = false)
  private UUID messageId;

  @Column(nullable = false)
  private UUID correlationId;

  @Type(JsonBinaryType.class)
  @Column(columnDefinition = "jsonb")
  private String payload;

  @Column(nullable = false, columnDefinition = "Timestamp with time zone")
  private OffsetDateTime messageTimestamp;

  @Column private String createdBy;
}

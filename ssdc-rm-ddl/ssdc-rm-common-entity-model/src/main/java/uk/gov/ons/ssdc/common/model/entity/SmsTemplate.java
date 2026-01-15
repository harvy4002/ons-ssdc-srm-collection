package uk.gov.ons.ssdc.common.model.entity;

import io.hypersistence.utils.hibernate.type.json.JsonBinaryType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import java.util.UUID;
import lombok.Data;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Type;

@Data
@Entity
@DynamicUpdate
public class SmsTemplate {
  @Id private String packCode;

  @Type(JsonBinaryType.class)
  @Column(columnDefinition = "jsonb", nullable = false)
  private String[] template;

  @Column(nullable = false)
  private UUID notifyTemplateId;

  @Column(nullable = false)
  private String description;

  @Column(nullable = false)
  private String notifyServiceRef;

  @Type(JsonBinaryType.class)
  @Column(columnDefinition = "jsonb")
  private Object metadata;
}

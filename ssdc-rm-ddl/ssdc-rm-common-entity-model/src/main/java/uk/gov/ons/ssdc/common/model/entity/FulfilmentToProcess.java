package uk.gov.ons.ssdc.common.model.entity;

import io.hypersistence.utils.hibernate.type.json.JsonBinaryType;
import jakarta.persistence.*;
import java.util.Map;
import java.util.UUID;
import lombok.Data;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Type;

@Entity
@DynamicUpdate
@Data
public class FulfilmentToProcess {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private long id;

  @ManyToOne(optional = false)
  private ExportFileTemplate exportFileTemplate;

  @ManyToOne(optional = false)
  private Case caze;

  @Column private Integer batchQuantity;

  @Column private UUID batchId;

  @Column(nullable = false)
  private UUID correlationId;

  @Column(nullable = false, unique = true)
  private UUID messageId;

  @Column private String originatingUser;

  @Type(JsonBinaryType.class)
  @Column(columnDefinition = "jsonb")
  private Object uacMetadata;

  @Type(JsonBinaryType.class)
  @Column(columnDefinition = "jsonb")
  private Map<String, String> personalisation;
}

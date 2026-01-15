package uk.gov.ons.ssdc.common.model.entity;

import io.hypersistence.utils.hibernate.type.json.JsonBinaryType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;
import lombok.Data;
import lombok.ToString;
import org.hibernate.annotations.*;

@ToString(onlyExplicitlyIncluded = true) // Bidirectional relationship causes IDE stackoverflow
@Data
@Entity
@DynamicUpdate
@Table(
    name = "uac_qid_link",
    indexes = {
      @Index(name = "qid_idx", columnList = "qid"),
      @Index(name = "uac_qid_caseid_idx", columnList = "caze_id")
    })
public class UacQidLink {
  @Id private UUID id;

  @Column(
      nullable = false,
      name = "qid", // "name" annotation required for index on column to work
      unique = true)
  private String qid;

  @Column(nullable = false)
  private String uac;

  @ManyToOne(optional = false)
  private Case caze;

  @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT false")
  private boolean receiptReceived;

  @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT false")
  private boolean eqLaunched;

  @OneToMany(mappedBy = "uacQidLink")
  private List<Event> events;

  @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT true")
  private boolean active = true;

  @Column(columnDefinition = "timestamp with time zone")
  @CreationTimestamp
  private OffsetDateTime createdAt;

  @Column(columnDefinition = "timestamp with time zone")
  @UpdateTimestamp
  private OffsetDateTime lastUpdatedAt;

  @Type(JsonBinaryType.class)
  @Column(columnDefinition = "jsonb")
  private Object metadata;

  @Column(nullable = false)
  private String collectionInstrumentUrl;

  @Column(nullable = false)
  private String uacHash;
}

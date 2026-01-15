package uk.gov.ons.ssdc.common.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import java.util.UUID;
import lombok.Data;
import org.hibernate.annotations.DynamicUpdate;

@Data
@Entity
@DynamicUpdate
public class ExportFileRow {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private long id;

  @Column(nullable = false, length = 5000)
  private String row;

  @Column(nullable = false)
  private UUID batchId;

  @Column(nullable = false)
  private int batchQuantity;

  @Column(nullable = false)
  private String exportFileDestination;

  @Column(nullable = false)
  private String packCode;
}

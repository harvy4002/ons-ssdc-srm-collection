package uk.gov.ons.ssdc.common.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.UUID;
import lombok.Data;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.UpdateTimestamp;

@Data
@Entity
@DynamicUpdate
public class Job {
  @Id private UUID id;

  @ManyToOne(optional = false)
  private CollectionExercise collectionExercise;

  @Column(columnDefinition = "timestamp with time zone")
  @CreationTimestamp
  private OffsetDateTime createdAt;

  @Column(nullable = false)
  private String createdBy;

  @Column(columnDefinition = "timestamp with time zone")
  @UpdateTimestamp
  private OffsetDateTime lastUpdatedAt;

  @Column(nullable = false)
  private String fileName;

  @Column(nullable = false)
  private UUID fileId;

  @Column(nullable = false)
  private int fileRowCount;

  @Column(nullable = false)
  private int errorRowCount;

  @Column(nullable = false)
  private int stagingRowNumber;

  @Column(nullable = false)
  private int validatingRowNumber;

  @Column(nullable = false)
  private int processingRowNumber;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private JobStatus jobStatus;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private JobType jobType;

  @OneToMany(mappedBy = "job")
  private List<JobRow> jobRows;

  @Column private String processedBy;

  @Column(columnDefinition = "timestamp with time zone")
  private OffsetDateTime processedAt;

  @Column private String cancelledBy;

  @Column(columnDefinition = "timestamp with time zone")
  private OffsetDateTime cancelledAt;

  @Column private String fatalErrorDescription;
}

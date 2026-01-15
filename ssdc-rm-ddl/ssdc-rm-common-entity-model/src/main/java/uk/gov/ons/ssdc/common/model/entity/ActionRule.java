package uk.gov.ons.ssdc.common.model.entity;

import io.hypersistence.utils.hibernate.type.json.JsonBinaryType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.ManyToOne;
import java.time.OffsetDateTime;
import java.util.UUID;
import lombok.Data;
import lombok.ToString;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.annotations.Type;
import org.hibernate.type.SqlTypes;

@ToString(onlyExplicitlyIncluded = true) // Bidirectional relationship causes IDE stackoverflow
@Data
@Entity
@DynamicUpdate
public class ActionRule {

  @Id private UUID id;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private ActionRuleStatus actionRuleStatus;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private ActionRuleType type;

  @Column(length = 50)
  private String description;

  @Column(nullable = false, columnDefinition = "timestamp with time zone")
  private OffsetDateTime triggerDateTime;

  @Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT false")
  private boolean hasTriggered;

  @Lob
  @JdbcTypeCode(SqlTypes.VARBINARY)
  @Column
  private byte[] classifiers;

  @ManyToOne private ExportFileTemplate exportFileTemplate;

  @ManyToOne private SmsTemplate smsTemplate;

  @ManyToOne private EmailTemplate emailTemplate;

  @Column(nullable = false)
  private String createdBy;

  @Column private String phoneNumberColumn;

  @Column private String emailColumn;

  @ManyToOne(optional = false)
  private CollectionExercise collectionExercise;

  @Type(JsonBinaryType.class)
  @Column(columnDefinition = "jsonb")
  private Object uacMetadata;

  @Column private Integer selectedCaseCount;

  public void setClassifiers(String classifierClauseStr) {
    if (classifierClauseStr == null) {
      classifiers = null;
    } else {
      classifiers = classifierClauseStr.getBytes();
    }
  }

  public String getClassifiers() {
    if (classifiers == null) {
      return null;
    }

    return new String(classifiers);
  }
}

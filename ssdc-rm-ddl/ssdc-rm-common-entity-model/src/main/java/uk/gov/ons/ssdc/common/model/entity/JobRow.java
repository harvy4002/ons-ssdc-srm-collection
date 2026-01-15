package uk.gov.ons.ssdc.common.model.entity;

import io.hypersistence.utils.hibernate.type.json.JsonBinaryType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import jakarta.persistence.ManyToOne;
import java.util.Map;
import java.util.UUID;
import lombok.Data;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.annotations.Type;
import org.hibernate.type.SqlTypes;

@Data
@Entity
@DynamicUpdate
public class JobRow {
  @Id private UUID id;

  @ManyToOne(optional = false)
  private Job job;

  @Type(JsonBinaryType.class)
  @Column(columnDefinition = "jsonb")
  private Map<String, String> rowData;

  @Column(nullable = false)
  private byte[] originalRowData;

  @Column(nullable = false)
  private int originalRowLineNumber;

  @Enumerated(EnumType.STRING)
  @Column(nullable = false)
  private JobRowStatus jobRowStatus;

  @Lob
  @JdbcTypeCode(SqlTypes.VARBINARY)
  @Column
  private byte[] validationErrorDescriptions;

  public void setValidationErrorDescriptions(String validationErrorDescriptionsStr) {
    if (validationErrorDescriptionsStr == null) {
      validationErrorDescriptions = null;
    } else {
      validationErrorDescriptions = validationErrorDescriptionsStr.getBytes();
    }
  }

  public String getValidationErrorDescriptions() {
    if (validationErrorDescriptions == null) {
      return null;
    }

    return new String(validationErrorDescriptions);
  }

  public String[] getOriginalRowData() {
    return new String(this.originalRowData).split(",");
  }

  public void setOriginalRowData(String[] originalRowDataStr) {
    String ord = String.join(",", originalRowDataStr);
    originalRowData = ord.getBytes();
  }
}

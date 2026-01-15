package uk.gov.ons.ssdc.common.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;
import java.util.UUID;
import lombok.Data;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

@Data
@Entity
@DynamicUpdate
public class MessageToSend {
  @Id private UUID id;

  @Column(nullable = false)
  private String destinationTopic;

  @Lob
  @JdbcTypeCode(SqlTypes.VARBINARY)
  @Column(nullable = false)
  private byte[] messageBody;

  public void setMessageBody(String messageBodyStr) {
    if (messageBodyStr == null) {
      messageBody = null;
    } else {
      messageBody = messageBodyStr.getBytes();
    }
  }

  public String getMessageBody() {
    if (messageBody == null) {
      return null;
    }

    return new String(messageBody);
  }
}

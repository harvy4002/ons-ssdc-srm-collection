package uk.gov.ons.ssdc.common.model.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import java.util.UUID;
import lombok.Data;
import org.hibernate.annotations.DynamicUpdate;

@Data
@Entity
@DynamicUpdate
public class ActionRuleSurveySmsTemplate {
  @Id private UUID id;

  @ManyToOne(optional = false)
  private Survey survey;

  @ManyToOne(optional = false)
  private SmsTemplate smsTemplate;
}

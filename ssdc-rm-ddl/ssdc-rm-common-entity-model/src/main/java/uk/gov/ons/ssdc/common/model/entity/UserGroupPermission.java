package uk.gov.ons.ssdc.common.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import java.util.UUID;
import lombok.Data;
import lombok.ToString;
import org.hibernate.annotations.DynamicUpdate;

@ToString(onlyExplicitlyIncluded = true) // Bidirectional relationship causes IDE stackoverflow
@Entity
@DynamicUpdate
@Data
public class UserGroupPermission {
  @Id private UUID id;

  @ManyToOne(optional = false)
  private UserGroup group;

  @ManyToOne private Survey survey;

  @Enumerated(EnumType.STRING)
  @Column
  private UserGroupAuthorisedActivityType authorisedActivity;
}

package uk.gov.ons.ssdc.common.model.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import java.util.UUID;
import lombok.Data;
import lombok.ToString;

@ToString(onlyExplicitlyIncluded = true) // Bidirectional relationship causes IDE stackoverflow
@Entity
@Data
public class UserGroupAdmin {
  @Id private UUID id;

  @ManyToOne(optional = false)
  private User user;

  @ManyToOne(optional = false)
  private UserGroup group;
}

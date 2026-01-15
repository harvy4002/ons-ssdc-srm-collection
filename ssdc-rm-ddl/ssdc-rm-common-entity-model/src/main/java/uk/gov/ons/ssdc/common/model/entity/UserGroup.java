package uk.gov.ons.ssdc.common.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import java.util.List;
import java.util.UUID;
import lombok.Data;
import lombok.ToString;
import org.hibernate.annotations.DynamicUpdate;

@ToString(onlyExplicitlyIncluded = true) // Bidirectional relationship causes IDE stackoverflow
@Entity
@DynamicUpdate
@Data
public class UserGroup {
  @Id private UUID id;

  @Column private String description;

  @Column(nullable = false, unique = true)
  private String name;

  @OneToMany(mappedBy = "group")
  private List<UserGroupMember> members;

  @OneToMany(mappedBy = "group")
  private List<UserGroupAdmin> admins;

  @OneToMany(mappedBy = "group")
  private List<UserGroupPermission> permissions;
}

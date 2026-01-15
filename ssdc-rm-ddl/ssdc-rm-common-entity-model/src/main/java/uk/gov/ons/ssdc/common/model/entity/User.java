package uk.gov.ons.ssdc.common.model.entity;

import jakarta.persistence.*;
import java.util.List;
import java.util.UUID;
import lombok.Data;
import lombok.ToString;
import org.hibernate.annotations.DynamicUpdate;

@ToString(onlyExplicitlyIncluded = true) // Bidirectional relationship causes IDE stackoverflow
@Entity
@DynamicUpdate
@Data
@Table(
    name = "users",
    indexes = {@Index(name = "users_email_idx", columnList = "email", unique = true)})
public class User {
  @Id private UUID id;

  @Column(nullable = false)
  private String email;

  @OneToMany(mappedBy = "user")
  private List<UserGroupMember> memberOf;

  @OneToMany(mappedBy = "user")
  private List<UserGroupAdmin> adminOf;
}

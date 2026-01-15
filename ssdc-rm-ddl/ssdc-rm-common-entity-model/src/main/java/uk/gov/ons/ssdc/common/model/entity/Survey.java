package uk.gov.ons.ssdc.common.model.entity;

import io.hypersistence.utils.hibernate.type.json.JsonBinaryType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import java.util.List;
import java.util.UUID;
import lombok.Data;
import lombok.ToString;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Type;
import uk.gov.ons.ssdc.common.validation.ColumnValidator;

@ToString(onlyExplicitlyIncluded = true) // Bidirectional relationship causes IDE stackoverflow
@Data
@Entity
@DynamicUpdate
public class Survey {
  @Id private UUID id;

  @Column(nullable = false)
  private String name;

  @Type(JsonBinaryType.class)
  @Column(nullable = false, columnDefinition = "jsonb")
  private ColumnValidator[] sampleValidationRules;

  @Column(nullable = false)
  private String sampleDefinitionUrl;

  @Type(JsonBinaryType.class)
  @Column(columnDefinition = "jsonb")
  private Object metadata;

  @Column(nullable = false)
  private boolean sampleWithHeaderRow;

  @Column(nullable = false, length = 1)
  private char sampleSeparator;

  @Column(nullable = true, length = 25)
  private String sampleValidationName;

  @Column(nullable = true, length = 10)
  private String surveyAbbreviation;

  @OneToMany(mappedBy = "survey")
  private List<CollectionExercise> collectionExercises;

  @OneToMany(mappedBy = "survey")
  private List<ActionRuleSurveyExportFileTemplate> actionRuleExportFileTemplates;

  @OneToMany(mappedBy = "survey")
  private List<ActionRuleSurveySmsTemplate> actionRuleSmsTemplates;

  @OneToMany(mappedBy = "survey")
  private List<ActionRuleSurveySmsTemplate> actionRuleEmailTemplates;

  @OneToMany(mappedBy = "survey")
  private List<FulfilmentSurveyExportFileTemplate> fulfilmentExportFileTemplates;

  @OneToMany(mappedBy = "survey")
  private List<FulfilmentSurveySmsTemplate> smsTemplates;

  @OneToMany(mappedBy = "survey")
  private List<FulfilmentSurveyEmailTemplate> emailTemplates;
}

package uk.gov.ons.ssdc.common.validation;

import static org.assertj.core.api.Assertions.assertThat;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.FileInputStream;
import org.junit.jupiter.api.Test;

class ReadValidationConfigTest {
  ObjectMapper objectMapper = new ObjectMapper();

  @Test
  void testCanReadValidationJson() throws Exception {
    try (FileInputStream fis =
        new FileInputStream("src/test/resources/example-validator-config.json")) {
      ColumnValidator[] columnValidators = objectMapper.readValue(fis, ColumnValidator[].class);

      assertThat(columnValidators.length).isPositive();
    }
  }
}

package TestRunner;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class TestRunner {

    // ✅ Runs ALL features together
    @Test
    public void testAll() {
        Results results = Runner.builder()
                .path("classpath:feature")
                .outputCucumberJson(true)
                .outputHtmlReport(true)
                .parallel(1);
        assertEquals(0, results.getFailCount(),
                results.getErrorMessages());
    }

    // ✅ Runs Surcharge.feature only
    @Test
    public void testSurcharge() {
        Results results = Runner.builder()
                .path("classpath:feature/Surcharge.feature")
                .outputCucumberJson(true)
                .outputHtmlReport(true)
                .parallel(1);
        assertEquals(0, results.getFailCount(),
                results.getErrorMessages());
    }

    // ✅ Runs TsysSurcharge.feature only
    @Test
    public void testTsysSurcharge() {
        Results results = Runner.builder()
                .path("classpath:feature/TsysSurcharge.feature")
                .outputCucumberJson(true)
                .outputHtmlReport(true)
                .parallel(1);
        assertEquals(0, results.getFailCount(),
                results.getErrorMessages());
    }

    // ✅ Runs traditional.feature only
    @Test
    public void testTraditional() {
        Results results = Runner.builder()
                .path("classpath:feature/traditional.feature")
                .outputCucumberJson(true)
                .outputHtmlReport(true)
                .parallel(1);
        assertEquals(0, results.getFailCount(),
                results.getErrorMessages());
    }

    // ✅ Runs Tsystraditional.feature only
    @Test
    public void testTsysTraditional() {
        Results results = Runner.builder()
                .path("classpath:feature/Tsystraditional.feature")
                .outputCucumberJson(true)
                .outputHtmlReport(true)
                .parallel(1);
        assertEquals(0, results.getFailCount(),
                results.getErrorMessages());
            }
    
    public void testtest() {
    	Results results = Runner.builder()
    			.path("classpath:feature/test.feature")
    			.outputCucumberJson(true)
    			.outputHtmlReport(true)
    			.parallel(1);
    	    	assertEquals(0, results.getFailCount(),
                results.getErrorMessages());
    }
}

package TestRunner;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.apache.commons.io.FileUtils.listFiles;

import java.text.SimpleDateFormat;
import java.util.Date;

public class runnerTest {
	
	/**+
	 * Author: Binodini Sahoo
	 * Description: Merchant API Automation
	 * Created Date: 06-Mar-2026
	 */

    /**
     * ✅ SINGLE ENTRY POINT — runs ALL features together.
     *    Produces one karate-summary.html + one Cucumber HTML report + one PDF report.
     */
	
    @Test
    public void testAll() {
        Results results = Runner.builder()
                .path("classpath:feature")          // scans ALL .feature files under /feature
                .outputCucumberJson(true)           // needed for masterthought report
                .outputHtmlReport(true)             // produces karate-summary.html
                .parallel(4);                       // run features in parallel (tune as needed)

        // ✅ Generate a single consolidated Masterthought HTML report
        generateReport(results.getReportDir());

        // ✅ Generate PDF from the HTML report
        generatePdfReport();

        assertEquals(0, results.getFailCount(),
                results.getErrorMessages());
    }

    /**
     * Builds one combined HTML report from all cucumber JSON files
     * generated under target/karate-reports/.
     *
     * Output: target/cucumber-html-reports/overview-features.html
     */
    private void generateReport(String reportDir) {
        Collection<File> jsonFiles = listFiles(
                new File(reportDir),
                new String[]{"json"},
                true
        );

        List<String> jsonPaths = new ArrayList<>();
        for (File file : jsonFiles) {
            jsonPaths.add(file.getAbsolutePath());
        }

        // Project name shown in the report header
        Configuration config = new Configuration(
                new File("target"),
                "Karate API Tests"
        );

        // Optional: add build metadata visible in the report
        config.addClassifications("Environment", "UAT");
        config.addClassifications("Browser",     "N/A");
        config.addClassifications("Platform",    System.getProperty("os.name"));
        config.addClassifications("Executed",    java.time.LocalDateTime.now().toString());

        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();

        System.out.println("\n✅ Combined report generated at: "
                + "target/cucumber-html-reports/overview-features.html\n");
    }

    /**
     * Converts the Cucumber HTML overview report to a PDF using wkhtmltopdf.
     *
     * Prerequisites:
     *   - Windows : download installer from https://wkhtmltopdf.org/downloads.html
     *   - Mac     : brew install wkhtmltopdf
     *   - Linux   : sudo apt-get install wkhtmltopdf
     *
     * Output: target/cucumber-html-reports/cucumber-report.pdf
     */
    private void generatePdfReport() {
    	String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
    	
        String htmlReportPath = new File("target/cucumber-html-reports/overview-features.html")
                .getAbsolutePath();
        String pdfOutputPath  = new File("target/cucumber-html-reports/cucumber-report.pdf")
                .getAbsolutePath();

        // ── Detect OS to find correct wkhtmltopdf binary ──────────────────────
        String os = System.getProperty("os.name").toLowerCase();
        String wkhtmltopdf;

        if (os.contains("win")) {
            // Default Windows install path — adjust if installed elsewhere
            wkhtmltopdf = "C:\\Program Files\\wkhtmltopdf\\bin\\wkhtmltopdf.exe";
        } else if (os.contains("mac")) {
            wkhtmltopdf = "/usr/local/bin/wkhtmltopdf";
        } else {
            // Linux
            wkhtmltopdf = "/usr/bin/wkhtmltopdf";
        }

        // ── Check if wkhtmltopdf is installed ─────────────────────────────────
        File wkBinary = new File(wkhtmltopdf);
        if (!wkBinary.exists()) {
            System.out.println("\n⚠️  wkhtmltopdf not found at: " + wkhtmltopdf);
            System.out.println("   PDF generation skipped.");
            System.out.println("   Install it from: https://wkhtmltopdf.org/downloads.html");
            System.out.println("   Then re-run the tests to generate the PDF.\n");
            return;
        }

        // ── Build the wkhtmltopdf command ──────────────────────────────────────
        ProcessBuilder pb = new ProcessBuilder(
                wkhtmltopdf,
                "--enable-local-file-access",   // allow local HTML/CSS/JS assets
                "--print-media-type",           // use print CSS media styles
                "--page-size",   "A4",          // A4 page size
                "--orientation", "Landscape",   // landscape fits wide tables better
                "--margin-top",    "10mm",
                "--margin-bottom", "10mm",
                "--margin-left",   "10mm",
                "--margin-right",  "10mm",
                "--zoom", "0.85",               // scale down slightly to fit content
                "--javascript-delay", "3000",   // wait 3s for JS charts to render
                "--no-stop-slow-scripts",       // don't abort on slow JS
                htmlReportPath,
                pdfOutputPath
        );

        pb.redirectErrorStream(true);           // merge stderr into stdout
        pb.inheritIO();                         // stream output to console

        try {
            System.out.println("\n⏳ Generating PDF report...");
            Process process = pb.start();
            int exitCode = process.waitFor();

            if (exitCode == 0) {
                System.out.println("\n✅ PDF report generated at: "
                        + pdfOutputPath + "\n");
            } else {
                System.out.println("\n❌ PDF generation failed with exit code: "
                        + exitCode + "\n");
            }
        } catch (IOException e) {
            System.out.println("\n❌ Failed to start wkhtmltopdf: " + e.getMessage());
            System.out.println("   Make sure wkhtmltopdf is installed and accessible.\n");
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            System.out.println("\n❌ PDF generation was interrupted: " + e.getMessage() + "\n");
        }
    }
    
   
}


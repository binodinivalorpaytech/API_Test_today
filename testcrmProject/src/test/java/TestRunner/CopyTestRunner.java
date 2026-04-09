package TestRunner;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;

import org.junit.jupiter.api.Test;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Properties;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.apache.commons.io.FileUtils.listFiles;

import java.text.SimpleDateFormat;
import java.util.Date;

public class CopyTestRunner {

    /**
     * Author: Binodini Sahoo
     * Description: Merchant API Automation
     * Created Date: 06-Mar-2026
     */

    // ── Email Configuration ────────────────────────────────────────────────────
    private static final String SMTP_HOST     = "smtp.gmail.com";       // Change for Outlook: smtp.office365.com
    private static final int    SMTP_PORT     = 587;                    // 465 for SSL, 587 for TLS
    private static final String SENDER_EMAIL  = "binodinivalorpaytech@gmail.com"; // ✏️ Replace with sender email
    private static final String SENDER_PASS   = "Lucky@1234";    // ✏️ Gmail App Password (not login password)
    private static final String RECEIVER_EMAIL = "binodinivalorpaytech@gmail.com"; // ✏️ Replace with recipient(s)
    // For multiple recipients, use comma-separated: "a@x.com,b@y.com"
    // ──────────────────────────────────────────────────────────────────────────

    /**
     * ✅ SINGLE ENTRY POINT — runs ALL features together.
     *    Produces one karate-summary.html + one Cucumber HTML report + one PDF report.
     */
    @Test
    public void testAll() {
        Results results = Runner.builder()
                .path("classpath:feature")
                .outputCucumberJson(true)
                .outputHtmlReport(true)
                .parallel(4);

        generateReport(results.getReportDir());

        String pdfPath = generatePdfReport();

        // ✅ Send PDF report via email (only if PDF was generated)
        if (pdfPath != null) {
            sendEmailWithAttachment(
                    pdfPath,
                    results.getScenariosTotal(),
                    results.getFailCount()
            );
        }

        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }

    /**
     * Builds one combined HTML report from all cucumber JSON files.
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

        Configuration config = new Configuration(new File("target"), "Karate API Tests");
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
     * Returns the PDF file path if successful, null otherwise.
     */
    private String generatePdfReport() {
        String timestamp    = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String htmlReportPath = new File("target/cucumber-html-reports/overview-features.html").getAbsolutePath();
        String pdfOutputPath  = new File("target/cucumber-html-reports/cucumber-report-" + timestamp + ".pdf").getAbsolutePath();

        String os = System.getProperty("os.name").toLowerCase();
        String wkhtmltopdf;

        if (os.contains("win")) {
            wkhtmltopdf = "C:\\Program Files\\wkhtmltopdf\\bin\\wkhtmltopdf.exe";
        } else if (os.contains("mac")) {
            wkhtmltopdf = "/usr/local/bin/wkhtmltopdf";
        } else {
            wkhtmltopdf = "/usr/bin/wkhtmltopdf";
        }

        File wkBinary = new File(wkhtmltopdf);
        if (!wkBinary.exists()) {
            System.out.println("\n⚠️  wkhtmltopdf not found at: " + wkhtmltopdf);
            System.out.println("   PDF generation skipped. Install from: https://wkhtmltopdf.org/downloads.html\n");
            return null;
        }

        ProcessBuilder pb = new ProcessBuilder(
                wkhtmltopdf,
                "--enable-local-file-access",
                "--print-media-type",
                "--page-size",        "A4",
                "--orientation",      "Landscape",
                "--margin-top",       "10mm",
                "--margin-bottom",    "10mm",
                "--margin-left",      "10mm",
                "--margin-right",     "10mm",
                "--zoom",             "0.85",
                "--javascript-delay", "3000",
                "--no-stop-slow-scripts",
                htmlReportPath,
                pdfOutputPath
        );
        pb.redirectErrorStream(true);
        pb.inheritIO();

        try {
            System.out.println("\n⏳ Generating PDF report...");
            int exitCode = pb.start().waitFor();

            if (exitCode == 0) {
                System.out.println("\n✅ PDF report generated at: " + pdfOutputPath + "\n");
                return pdfOutputPath;   // ← return path on success
            } else {
                System.out.println("\n❌ PDF generation failed with exit code: " + exitCode + "\n");
            }
        } catch (IOException e) {
            System.out.println("\n❌ Failed to start wkhtmltopdf: " + e.getMessage());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            System.out.println("\n❌ PDF generation interrupted: " + e.getMessage());
        }
        return null;
    }

    /**
     * Sends the PDF report as an email attachment via SMTP (TLS).
     *
     * @param pdfFilePath    Absolute path to the generated PDF
     * @param totalScenarios Total number of scenarios executed
     * @param failCount      Number of failed scenarios
     *
     * ── Gmail Setup ─────────────────────────────────────────────────────────
     *   1. Enable 2-Step Verification on your Google account.
     *   2. Go to: https://myaccount.google.com/apppasswords
     *   3. Generate an App Password for "Mail" → use it as SENDER_PASS above.
     *
     * ── Outlook/Office365 ───────────────────────────────────────────────────
     *   Change SMTP_HOST to smtp.office365.com and use your normal password
     *   or an app password if MFA is enabled.
     * ────────────────────────────────────────────────────────────────────────
     */
    private void sendEmailWithAttachment(String pdfFilePath, int totalScenarios, int failCount) {
        System.out.println("\n📧 Sending PDF report to: " + RECEIVER_EMAIL);

        // ── SMTP properties ────────────────────────────────────────────────
        Properties props = new Properties();
        props.put("mail.smtp.auth",            "true");
        props.put("mail.smtp.starttls.enable", "true");   // TLS
        props.put("mail.smtp.host",            SMTP_HOST);
        props.put("mail.smtp.port",            SMTP_PORT);
        props.put("mail.smtp.ssl.trust",       SMTP_HOST);

        // ── Authenticator ──────────────────────────────────────────────────
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASS);
            }
        });

        try {
            String timestamp  = new SimpleDateFormat("dd-MMM-yyyy HH:mm:ss").format(new Date());
            int    passCount  = totalScenarios - failCount;
            String statusLine = (failCount == 0)
                    ? "✅ ALL PASSED"
                    : "❌ " + failCount + " FAILED / " + passCount + " PASSED";

            // ── Build message ──────────────────────────────────────────────
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));

            // Support comma-separated recipients
            for (String addr : RECEIVER_EMAIL.split(",")) {
                message.addRecipient(Message.RecipientType.TO,
                        new InternetAddress(addr.trim()));
            }

            message.setSubject("Karate API Test Report — " + statusLine + " | " + timestamp);

            // ── HTML email body ────────────────────────────────────────────
            String htmlBody = "<html><body style='font-family:Arial,sans-serif;color:#333'>"
                    + "<h2 style='color:#2c3e50'>🧪 Karate API Automation Report</h2>"
                    + "<table border='1' cellpadding='8' cellspacing='0' "
                    + "style='border-collapse:collapse;width:400px'>"
                    + "<tr style='background:#f2f2f2'><td><b>Executed On</b></td><td>" + timestamp        + "</td></tr>"
                    + "<tr>                           <td><b>Environment</b></td><td>UAT</td></tr>"
                    + "<tr style='background:#f2f2f2'><td><b>Total Scenarios</b></td><td>" + totalScenarios + "</td></tr>"
                    + "<tr style='color:green'>        <td><b>Passed</b></td><td>" + passCount             + "</td></tr>"
                    + "<tr style='color:red'>          <td><b>Failed</b></td><td>" + failCount             + "</td></tr>"
                    + "<tr style='background:#f2f2f2'><td><b>Status</b></td><td><b>" + statusLine + "</b></td></tr>"
                    + "</table>"
                    + "<br><p>Please find the detailed test report attached as a PDF.</p>"
                    + "<p style='color:#888;font-size:12px'>— Karate Automation | Merchant API</p>"
                    + "</body></html>";

            // ── Multipart: body + attachment ───────────────────────────────
            MimeBodyPart bodyPart = new MimeBodyPart();
            bodyPart.setContent(htmlBody, "text/html; charset=utf-8");

            MimeBodyPart attachmentPart = new MimeBodyPart();
            attachmentPart.attachFile(new File(pdfFilePath));
            attachmentPart.setFileName("Karate-Test-Report-" +
                    new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".pdf");

            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(bodyPart);
            multipart.addBodyPart(attachmentPart);
            message.setContent(multipart);

            // ── Send ───────────────────────────────────────────────────────
            Transport.send(message);
            System.out.println("✅ Email sent successfully to: " + RECEIVER_EMAIL + "\n");

        } catch (MessagingException e) {
            System.out.println("❌ Failed to send email: " + e.getMessage());
            System.out.println("   Check SMTP credentials and network connectivity.\n");
        } catch (IOException e) {
            System.out.println("❌ Failed to attach PDF file: " + e.getMessage() + "\n");
        }
    }
}

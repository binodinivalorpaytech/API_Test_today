/**
 * Author: Binodini Sahoo
 * Description: Merchant API Automation
 * Created Date: 12-Mar-2026
 */
function fn() {

    var env = karate.env;
    karate.log('karate.env system property was:', env);

    if (!env) {
        env = 'dev';
    }

    karate.configure('logPrettyRequest', true);
    karate.configure('logPrettyResponse', true);
    karate.configure('connectTimeout', 90000);
    karate.configure('readTimeout', 360000);
    karate.configure('report', { showLog: true, showAllSteps: true });

    var config = {};
    var baseUrl;

    // ======================
    // Environment Switching
    // ======================

    if (env == 'uat') {

        baseUrl = 'https://vpuat.valorpaytech.com';

        config.dbConfig = {
            url: 'jdbc:mariadb://10.10.1.60:3306/uat_portal',
            username: 'automationtest',
            password: '0X4+0&5UyF£'
        };

    } else if (env == 'demo') {

        baseUrl = 'https://vpdemo.valorpaytech.com';

        config.dbConfig = {
            url: 'jdbc:mariadb://10.10.1.70:3306/demo_portal',
            username: 'automationtest',
            password: 'password'
        };

    } else {

        baseUrl = 'https://vpuat.valorpaytech.com';

        config.dbConfig = {
            url: 'jdbc:mariadb://10.10.1.60:3306/uat_portal',
            username: 'automationtest',
            password: '0X4+0&5UyF£'
        };
    }

    config.baseUrl = baseUrl;
    config.env = env;

    // ======================
    // Token Handling
    // ======================

    var csvData = karate.read('classpath:testData/login.csv');
    var credentials = csvData[0];

    var tokenArgs = {
        baseUrl: baseUrl,
        mailId: credentials.mailId,
        SubmailId: credentials.SubmailId,
        passCode: credentials.passCode
    };

    var token = karate.callSingle('classpath:source/token.feature', tokenArgs);

    config.accessToken = token.accessToken;

    karate.log('Access Token loaded into config:', config.accessToken);

    return config;
}
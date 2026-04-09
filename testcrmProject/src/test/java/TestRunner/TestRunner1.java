package TestRunner;


import com.intuit.karate.junit5.Karate;

class TestRunner1 {

    @Karate.Test
    Karate runDb() {
            	return Karate.run("classpath:feature/MerchantOperatorCreate.feature");
            	
}
}
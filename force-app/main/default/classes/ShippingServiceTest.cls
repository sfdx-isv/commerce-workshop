/**
* 1.0 ShippingServiceTest 
* Description: Test class for ShippingService.cls
*
* @author James Quinn
* @date 10/28/2022
*
*/
@IsTest
public with sharing class ShippingServiceTest {

    // Set up pre-requisite test data

        /**
    * Positive test for the calculateShippingPrice method
    * @author James Quinn
    * @date 10/28/2022
    * @params none
    * @return void
    */
    @IsTest
    public static void calculateShippingPrice() {

        //Run test
        Test.startTest();
        List<Decimal> results = ShippingService.calculateShippingPrice();
        Test.stopTest();

        // Verify results are as expected
        Assert.areEqual(5.62, results[0], 'ShippingService.calculateShippingPrice() did not return the expected value');
    }
}

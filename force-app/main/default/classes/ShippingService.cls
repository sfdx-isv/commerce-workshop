public with sharing class ShippingService {

    @InvocableMethod(label='Calculate Shipping Price' 
    description='Returns the amount the customer will be charged to ship this order delivery group.'
    iconName='slds:utility:transport_heavy_truck' 
    category='Commerce'
    )
    public static List<Decimal> calculateShippingPrice() {
        /*
        Since this is just a sample app, we are not doing an actual integration to an
        external shipping calculation service here. 

        A production-quality ISV app might take inputs such as a collection of the products,
        including their price, size, weight, current location, destination, shipping method,
        desired delivery date, etc. and call service to perform a calculation, returning the price.
        
        For simplicity, we will simply return a static value. See the comment below for how to
        set up an http POST call.
        */
        return new List<Decimal>{5.62};
    }

     /* A sample apex method that takes a url string as input and returns a response from a POST call
        // Pass in the endpoint to be used using the string url
  public String getPostCalloutResponseContents(String url) {

    // Instantiate a new Http object
    Http h = new Http();

    // Instantiate a new HTTP request
    // Specify request properties such as the endpoint, the POST method, etc. 
    HttpRequest req = new HttpRequest();
    req.setEndpoint(url);
    req.setMethod('POST');
    req.setHeader('Content-Type', 'application/json');
    req.setBody('{Your_JSON_Content}');

    // Send the request, and return a response
    HttpResponse res = h.send(req);
    return res.getBody();
  }
        */
}



# Workshop: Build an ISV app to extend Salesforce Order Management and B2B Commerce

In this workshop we will be developing and packaging a sample AppExchange ISV app that works with the Salesforce [B2B Commerce](https://help.salesforce.com/s/articleView?id=sf.comm_intro.htm&type=5) and [Order Management](https://help.salesforce.com/s/articleView?id=sf.om_order_management.htm&type=5) products, which are both part of the Salesforce core platform tech stack. For packaging, we will be using [Second-Generation Packaging](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_dev2gp.htm) (2GP).

## Big picture steps: 

1. Tooling Setup
2. Build our app in the Commerce org 
3. Pull the created metadata out of the Commerce org using VS Code
4. Package it
5. Demo: connect our package to your Partner Community publishing console, submit for Security Review and list it on the AppExchange

## Prerequisites

Here are the pre-requisites that workshop attendees should have installed on their computers:

* Java/JDK version [17](https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html), [11](https://www.oracle.com/uk/java/technologies/javase/jdk11-archive-downloads.html), or 8 (if you click these links, scroll down to the table on the site it opens)
    * [more detailed guidance if needed](https://trailhead.salesforce.com/content/learn/projects/find-and-fix-bugs-with-apex-replay-debugger/apex-replay-debugger-set-up-vscode)
* [Git](https://git-scm.com/downloads)
* [Salesforce CLI](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm)
* [VS Code](https://code.visualstudio.com/download)
* [Salesforce Extensions for VS Code](https://developer.salesforce.com/tools/vscode/en/vscode-desktop/install)

## Step-by-step walkthrough

*Use case*: The sample app we will be building is a Shipping Calculation app which B2B Commerce will use to calculate shipping costs in real-time once checkout begins, and Order Management will use for re-ship requests.
Note: We are keeping the app simple for the sake of this exercise. Realistically, an app may have more to it than this, such as integration with shipping logistics provider APIs, updates on shipping status, etc.

We will be connecting to *two orgs*: one to build our app inside of, and one to allow us to package the app and list it on AppExchange. We will refer to these as our *Commerce Org* and our *Dev Hub*, respectively. 

1. Tooling setup:
    1. First, we will *clone the Github repo* we’ve prepared for this workshop, in the interest of time we have partially built our ISV app in advance
        1. Go to the [commerce-workshop Github repo](https://github.com/sfdx-isv/commerce-workshop), click the green *Code* button, and *copy* the URL from there
            1. <img width="1016" alt="image (3)" src="https://user-images.githubusercontent.com/39100635/200142271-ee003440-c320-4411-b3c4-9ca7d0a01ec2.png">
        2. Now open *VS Code*. You may see either the “Get Started” screen in VS Code, or it may open the most recent directory you’ve been working in, it makes no difference for this exercise. 
        3. Go to *File* >> *Open Folder* >> *Desktop >> Open*. 
        4. <img width="684" alt="image (4)" src="https://user-images.githubusercontent.com/39100635/200142281-ed7be509-d026-4ab2-9a27-34bdb0adbefb.png">
        5. <img width="715" alt="image (5)" src="https://user-images.githubusercontent.com/39100635/200142289-a7921885-6544-4e7c-8161-95a69b400856.png">
        6. In the bottom toolbar on the left side, click near the *X* and *!* icons to bring up the embedded terminal, then click *TERMINAL*
        7. <img width="930" alt="image (6)" src="https://user-images.githubusercontent.com/39100635/200142923-d7be5ba9-c968-4213-9dcd-58623ebc24e3.png">
        8. type  `git clone ` and then paste the URL you copied from the Github repo
            1. `git clone https://github.com/sfdx-isv/commerce-workshop.git`
            2. Hit *Enter/Return* to run the command
        9. Your file directory on the left hand side of VS Code should now include *commerce-workshop* in the list of folders and files
        10. <img width="243" alt="image (7)" src="https://user-images.githubusercontent.com/39100635/200142932-7765214a-25eb-4afa-97d3-71a3a028c7e1.png">
        11. Now we need to open VS code in the context of that new folder. Repeat the steps to open a folder with VS Code:
            1. Go to *File* >> *Open Folder* >> *commerce-workshop>> Open*. 
            2. <img width="684" alt="image (8)" src="https://user-images.githubusercontent.com/39100635/200142946-a618c595-9f3f-4adb-898f-45d7d7f5936b.png">
            3. <img width="720" alt="image (9)" src="https://user-images.githubusercontent.com/39100635/200142949-e5fdeb93-ded9-4dc5-8d6a-2c26979fce40.png">
    2. Next, we will connect the Salesforce CLI to the *Dev Hub* org (so we can later package our app)
        1. In VS Code, click on *No Default Org Set* on the bottom toolbar, which will open the Command Palette
        2. In the Command Palette, click on *SFDX: Authorize a Dev Hub*
        3. <img width="1109" alt="image (3)" src="https://user-images.githubusercontent.com/39100635/200143047-0d78eb9a-e021-4125-91c1-4c7a571b8005.png">
        4. This will open a new tab in your browser with a Salesforce *login screen*
        5. <img width="411" alt="image (4)" src="https://user-images.githubusercontent.com/39100635/200143051-238b722b-910d-4f9e-81a1-dca2cc305230.png">
            1. Note: these instructions are written for a live workshop where I set up the orgs and everyone’s logins beforehand. If you are following along yourself, you can create your own [Dev Hub](https://developer.salesforce.com/docs/atlas.en-us.packagingGuide.meta/packagingGuide/sfdx_setup_enable_devhub.htm) and your own Commerce org (using either a [Trialforce Template and Environment Hub](https://salesforce.quip.com/q9RUACra2Jfa) or a [Demo org](https://partners.salesforce.com/pdx/s/learn/article/demo-station-for-partners-MCUTYORCVUVNCJTIVCKP6VHUKF3M?language=en_US) for the Commerce org) for free
        6. Log in with your username and password for this Dev Hub org: 
            1. Username: <<TheEmailYouRegisteredWith>>.commerce-workshop-dev-hub
            2. Password: (I will give this to you in the workshop)
        7. Click *Allow*, which authorizes the Salesforce CLI to connect to this Dev Hub org in the context of your user login
        8. <img width="426" alt="image (5)" src="https://user-images.githubusercontent.com/39100635/200143063-5e267760-854f-4167-bd3f-6b96faecfc7d.png">
        9. If it asks for your phone number, click *Remind Me Later*
        10. <img width="406" alt="image (6)" src="https://user-images.githubusercontent.com/39100635/200143068-1ab32db8-9879-4906-a78b-1f22a756ca72.png">
    3. Finally, connect the Salesforce CLI to your Commerce org (where we will build our app)
        1. In VS Code, once again click on *No Default Org Set* on the bottom toolbar, which will open the Command Palette
        2. This time in the Command Palette, click on *SFDX: Authorize an Org* (not a Dev Hub)
        3. <img width="1053" alt="image" src="https://user-images.githubusercontent.com/39100635/200143235-30e64831-1e9d-4905-99f0-4f04a9a534d7.png">
        4. This brings up a set of options, click *Production*
        5. <img width="552" alt="image (1)" src="https://user-images.githubusercontent.com/39100635/200143246-fedf9e94-a76b-4c46-929f-ca45580196e0.png">
        6. Next, for the org’s alias, type *commerce-workshop-develop* and hit *Enter/Return*
        7. <img width="633" alt="image (2)" src="https://user-images.githubusercontent.com/39100635/200143251-2f4e450c-2bf4-4926-b291-45409e8252e1.png">
        8. This will open a new tab in your browser with a Salesforce *login screen*
        9. <img width="411" alt="image (3)" src="https://user-images.githubusercontent.com/39100635/200143264-db69a3fc-2064-4d48-9985-15c60d3b6d83.png">
        10. Log in with your username and password for this org: 
            1. Username: <<TheEmailYouRegisteredWith>>.commerce-workshop-develop
            2. Password: (I will give this to you in the workshop)
        11. Click *Agree*, to authorize the Salesforce CLI to connect to this org 
        12. <img width="401" alt="image (4)" src="https://user-images.githubusercontent.com/39100635/200143273-5ad0febb-9493-4e2d-bae7-fce56dfe329e.png">
        13. Notice the bottom toolbar of VS Code no longer says “No Default Org Set”, it says *commerce-workshop-develop*, which is the alias we gave to the Commerce org. It also shows a *plug* icon to indicate that Salesforce CLI is connected to default org
        14. <img width="900" alt="image (5)" src="https://user-images.githubusercontent.com/39100635/200143286-65893bbf-4b72-425f-be39-974f70e5f3a1.png">
    4. Congrats! The Salesforce CLI is now connected to both orgs we need: the *Dev Hub* (to package our app later), and the *Commerce* org (where we will build our app now)
2. Build the app in the Commerce org
    1. Part 1: Push code into the Commerce Org
        1. In VS Code, we will now take two Apex classes, *ShippingService.cls* and *ShippingServiceTest.cls*, that we got from cloning the Github repo and push them into the Commerce org so we can use them in the app we’re going to develop
        2. In the left pane of VS Code you should see a file directory. If you don’t see this, click on the topmost icon in the left sidebar to open it.
        3. Click on the *force-app* folder
        4. <img width="261" alt="image" src="https://user-images.githubusercontent.com/39100635/200143818-0bc869a2-d8bd-46e9-b55e-f49f377eeab4.png">
        5. From there, *right-click* on the *classes* folder, which opens a pop-up menu
        6. Click on the *SFDX: Deploy Source to Org* option, near the bottom
        7. <img width="498" alt="image (1)" src="https://user-images.githubusercontent.com/39100635/200143824-6a26bebc-8b9d-4e4e-91f7-5511fde424d7.png">
        8. You should receive a success message pop-up window near the bottom right of your VS Code window
        9. <img width="1124" alt="image (2)" src="https://user-images.githubusercontent.com/39100635/200143825-5d7af84d-7d37-444a-b8a8-26726177694b.png">
        10. Now, toward the left side of the bottom toolbar, click on the below icon, which resembles a mini browser window. This opens the Commerce org in your browser. Notice you don’t have to log in again!
        11. <img width="189" alt="image (3)" src="https://user-images.githubusercontent.com/39100635/200143826-e9d2b3a7-ccd9-4e97-a8b2-7e205cfa0178.png">
    2. Part 2: Configure a Sample Order Management ISV App
        1. Overview: Since our use case is a Shipping Calculation ISV App, we will clone and modify one of Order Management’s out-of-the-box flows, a reshipment flow, to leverage our ISV app’s functionality
        3. In the Commerce org, click the *cog wheel* toward the top right of your screen and click *Setup*.
        4. <img width="930" alt="image" src="https://user-images.githubusercontent.com/39100635/200143863-5751a3e8-8eae-468b-8510-2460ee080ff5.png">
        5. Type “Flow” in the quick find search near the top left of the Setup menu, and click *Flows*. 
        6. <img width="348" alt="image (1)" src="https://user-images.githubusercontent.com/39100635/200143866-e4265715-59d6-4f96-94ce-bd82ea744b54.png">
        7. Find and *click on* the Flow named *Create Reship Order* to open it
        8. <img width="709" alt="image (2)" src="https://user-images.githubusercontent.com/39100635/200143875-a86d1f41-8803-4b2a-ab9d-b5abe4f2c6a5.png">
        9. Click *Save As*
        10. <img width="858" alt="image (3)" src="https://user-images.githubusercontent.com/39100635/200143877-1fc05234-79f2-44b1-b560-0fc4ee62ba9d.png">
        11. In the popup window, click *A New Flow*
        12. For Flow Label, type *Create Reship Order Clone*. The API name will be auto-populated to *Create_Reship_Order_Clone*
        13. Click *Save*
        14. <img width="636" alt="image (4)" src="https://user-images.githubusercontent.com/39100635/200143881-93a13257-6e99-4379-8987-5c00037654c1.png">
        15. Now in your newly cloned flow, *drag* the screen to the right on the flow canvas (the big area on the right side), and look for the blue Screen element titled *Location Selection*
        16. <img width="859" alt="image (5)" src="https://user-images.githubusercontent.com/39100635/200143887-e4f68c56-309d-400c-ad9f-4fceeb4612fc.png">
        17. From the *Flow Toolbox* (the panel on the left side of the screen), drag an *Action* element onto the canvas, to the *right* of the *Location Selection* element
        18. <img width="121" alt="image (6)" src="https://user-images.githubusercontent.com/39100635/200143897-97e02fb9-5a61-4680-ba4d-eaa54cf3ddf0.png">
        19. In the pop-up that opens, for the *Category* on the left side, click *Commerce*
        20. Then in the *Action* box on the right, select *Calculate Shipping Price*, which is an invocable Apex method in the Apex class we pushed into the org earlier. 
        21. Name the element *Calculate Shipping Price*.
        22. <img width="908" alt="image (7)" src="https://user-images.githubusercontent.com/39100635/200143944-66078de0-f835-4f62-8fde-ffa6cad7ddd6.png">
        23. For the Label, type *Calculate Shipping Price* and click *Done*
        24. <img width="755" alt="image" src="https://user-images.githubusercontent.com/39100635/200143990-ebf153a1-5691-4da6-a3b1-e5a615e3c0c0.png">
            1. The use case is a bit contrived- we are adding a shipping calculation to a re-ship request flow. Usually a re-ship request happens because a customer’s original shipment was lost or damaged and many companies will not charge any money to re-ship, to provide good customer service. This use case educational only, and is not business advice on whether to charge customers for shipping or not.
        25. So that we can easily see the results of this Apex action, drag a *Screen* element from the *Flow Toolbox* on the left into the canvas to the *right* of our new Apex action
        26. <img width="152" alt="image (1)" src="https://user-images.githubusercontent.com/39100635/200143999-fc43e7ae-7c16-4d39-9bf0-5b59ba4a0c03.png">
        27. First, give the Screen element a *label* on the right side of the pop-up: *Shipping Price Confirmation Screen*
        28. <img width="864" alt="image (2)" src="https://user-images.githubusercontent.com/39100635/200144002-3ecbbc41-679f-4d15-a605-6d9046e7cfa2.png">
        29. Then, from the left side of the pop-up, drag a *Display Text* component onto the screen in the center, and then *click on it*
        30. On the right side, give this Display Text an API name such as *ShippingConfirmation*
        31. Below that, paste the text: *The price to reship will be £{!Calculate_Shipping_Price}* or alternatively, type it and click the box that says *Insert a resource...* and type *calc* to locate the *variable* holding the output of our invocable apex and then click on it
        32. Click *Done* to save the screen
        33. <img width="947" alt="image (3)" src="https://user-images.githubusercontent.com/39100635/200144042-bfe31c07-a1e2-461e-b92d-90a93dc3fe01.png">
            1. This is an important concept to understand. If you use Apex inside of a Flow, the output of the Apex is automatically stored as a variable and can be referenced later, used in calculations, decisions, business logic, etc.
        34. Change the connections between the elements on the flow canvas:
            1. Click the connector between the *Location Selection* and *Set Stage To Part 4* elements and hit the *Delete* key
            2. <img width="328" alt="image (4)" src="https://user-images.githubusercontent.com/39100635/200144054-a0231e82-5b41-49cf-8deb-4e96c21972e4.png">
            3. Click the white dot at the bottom of the *Location Selection* element and drag it onto the *Calculate Shipping Price* element. 
            4. Do the same to connect *Calculate Shipping Price* to *Shipping Price Confirmation Screen*
            5. Lastly, connect *Shipping Price Confirmation Screen* to *Set Stage To Part 4*
            6. <img width="404" alt="image (5)" src="https://user-images.githubusercontent.com/39100635/200144061-1c4c85da-5f8c-4177-8ed5-0d491a61389d.png">
        35. *Save* the Flow and then click *Activate*
        36. <img width="412" alt="image (6)" src="https://user-images.githubusercontent.com/39100635/200144067-522813ef-2beb-4f10-a815-2c28b16de336.png">
        37. One last step to surface our new Flow! From Setup, start typing *Actions & Recommendations* in the quick search box in the top left and click on *Actions & Recommendations*
        38. On the row that says *Summer ’22 Flow Package*, click on the *dropdown arrow* on the far right, then click *Edit*
        39. <img width="1881" alt="image (7)" src="https://user-images.githubusercontent.com/39100635/200144074-572198e5-ebe0-436e-8fa7-f303d190aaa1.png">
        40. In the popup window, click *Next*, then *Next* again
        41. <img width="856" alt="image (8)" src="https://user-images.githubusercontent.com/39100635/200144078-0de84c1a-90cd-4d6b-81fa-2154ae748575.png">
        42. <img width="1146" alt="image (9)" src="https://user-images.githubusercontent.com/39100635/200144080-b4222f6e-73be-468d-9d2e-69577814051a.png">
        43. Now click the *Default* tab toward the top left
        44. In the *search* box that appears, search your new flow, *Create Reship Order Clone*, and *drag* it into the list on the right
        45. Click *Next* again
        46. <img width="1177" alt="image" src="https://user-images.githubusercontent.com/39100635/200144120-d14b9db4-1c74-4d32-a90d-c48c7df7ee3c.png">
        47. Again search your new flow, *Create Reship Order Clone*, and check the *checkbox* on the left of it
        48. <img width="1721" alt="image (1)" src="https://user-images.githubusercontent.com/39100635/200144122-cd9ad492-2fdd-4eff-a55a-8a908fcf2fd5.png">
        49. Click *Save*
        50. Now it is time to see your flow in action! From the App Launcher (the 9 dots in a square in the top left),  type and select *Order Management*
        51. Search *00001301* and click on the matching Order Summary Record
        52. You should see a screen like this: 
        53. <img width="1907" alt="image (2)" src="https://user-images.githubusercontent.com/39100635/200144132-475c2390-4ae8-419d-9160-b3617e09e2d3.png">
        54. Look for your *Create Reship Order Clone* flow in the *Actions & Recommendations* section. If you don’t see it, click on the blue *Add* button and then start typing *Create Reship Order Clone* and then click on it
        55. <img width="1398" alt="image (1)" src="https://user-images.githubusercontent.com/39100635/200145200-672e7964-111c-4e7b-8caa-a0548732e758.png">
        56. Work your way through the flow until you see our new the *screen* we added, which shows that our invocable apex method was successfully called by our flow and returned an amount for the shipping price
        57. <img width="850" alt="image (3)" src="https://user-images.githubusercontent.com/39100635/200144138-20774d15-65ba-4817-8d34-7011c735a8ab.png">
        58. We have successfully finished development on an ISV app for Salesforce Order Management!
        59. Next Steps on your own for further learning:
        60. The Commerce orgs (which you get to keep until they expire) have a more realistic sample implementation of our Shipping app in the Apex class B2BDeliverySample (go to Setup >> Apex Classes to find this in your org), feel free to save the code for reference.
    3. Part 3: Configure a Sample B2B Commerce ISV App
        1. In the org, click the *cog wheel* toward the top right of your screen and click *Setup*.
        2. <img width="930" alt="image" src="https://user-images.githubusercontent.com/39100635/200144305-b732136e-1485-4f3b-a375-c25c790c5aa2.png">
        3. Type “Flow” in the quick find search near the top left of the Setup menu, and click *Flows*. 
        4. <img width="348" alt="image (1)" src="https://user-images.githubusercontent.com/39100635/200144308-de13403e-3b9f-4bff-9487-36d5b9d5a175.png">
        5. Scroll to find and *click on* the checkout flow that is currently in use, *Checkout Flow Template* to open it
        6. <img width="871" alt="image (2)" src="https://user-images.githubusercontent.com/39100635/200144312-a8269692-fe01-4461-a713-26087e385df6.png">
        7. Click *Save As*
        8. <img width="673" alt="image (3)" src="https://user-images.githubusercontent.com/39100635/200144316-bb1159bc-ee3e-4037-adee-b2b03c6ba568.png">
        9. For Flow Label, type *Checkout Flow Template Clone*. The API name will be auto-populated to *Checkout_Flow_Template_Clone*.
        10. Click *Save*
        11. <img width="493" alt="image (4)" src="https://user-images.githubusercontent.com/39100635/200144324-9f907a62-5b09-4528-a3b9-88e7ac685a74.png">
        12. Now in your newly cloned flow, *drag* the screen downward on the flow canvas (the big area on the right side), and find the step that calculates *Shipping Cost*, and notice that it is a *subflow*
            1. *Subflows* are a way to modularize business logic, similar to helper or utility methods in code
            2. <img width="996" alt="image (5)" src="https://user-images.githubusercontent.com/39100635/200144337-66fc7e32-b4ef-4b5c-ab9b-6ac5aa2394aa.png">
        13. We will replace this step with a method from our *Apex class* that we deployed to this org earlier. To keep things simple, we will *not* use a subflow here.
            1. The use case is, we are swapping out the out-of-the box way that B2B Commerce calculates shipping costs, and replacing it with our Apex class that would normally call out to our off-platform, third party ISV app to perform complex shipping calculations based on inputs such as an array of items and their sizes, weights, quantities, shipping methods, distance needed to deliver, etc. For this workshop we are simply mocking the callout and returning a static currency amount. 
        14. From the *Flow Toolbox* panel on the left side, drag an *Action* element on to the canvas near the *Shipping Cost* subflow icon
        15. <img width="103" alt="image (6)" src="https://user-images.githubusercontent.com/39100635/200144348-c2a4d654-4617-40c4-8b43-82284bc77349.png">
        16. In the pop-up that opens, for the *Category* on the left side, click *Commerce*
        17. Then in the *Action* box on the right, select *Calculate Shipping Price*, which is an invocable Apex method in the Apex class we pushed into the org earlier.
        18. <img width="734" alt="image (7)" src="https://user-images.githubusercontent.com/39100635/200144358-a5dab5af-6459-45a1-b8bf-0935b5db0f2c.png">
        19. Name the element *Calculate Shipping Price* and click *Done*
        20. <img width="725" alt="image (8)" src="https://user-images.githubusercontent.com/39100635/200144361-8e6e622c-1106-4950-ba1c-21ea1e229911.png">
        21. Click on the *Shipping Cost* subflow element and hit the *Delete* key
        22. <img width="217" alt="image (9)" src="https://user-images.githubusercontent.com/39100635/200144369-7737248e-ae28-46cd-bd45-734eb34cc0a8.png">
        23. Notice the arrows that were connected to the *Shipping Cost* element disappear too
        24. We will need to re-create those arrows to connect our new *Calculate Shipping Price* element to the correct existing Flow elements to form a smooth end-to-end Flow
            1. Drag from the *white circle* at the bottom of the *Main Decision Hub* element onto the *Calculate Shipping Price* element and *release*
                1. If you need to, zoom out by clicking the “*-*” icon in the bottom left of the flow canvas
            2. <img width="92" alt="image (10)" src="https://user-images.githubusercontent.com/39100635/200144388-703cc5fa-1a84-49d7-9705-ca98932d0fc6.png">
            3. In the popup window that appears, make sure *Shipping Cost* is selected and click *Done*
            4. <img width="672" alt="image (11)" src="https://user-images.githubusercontent.com/39100635/200144391-0b632583-ae14-455d-a074-36fa3aa8b90d.png">
            5. Next, drag from the *white circle* at the bottom of the *Calculate Shipping Price* element onto the *Assignment Loop* element and *release*
            6. <img width="88" alt="image (12)" src="https://user-images.githubusercontent.com/39100635/200144397-74da06bf-63c2-4bb9-8a24-63e22d2a7f99.png">
            7. We are done with the Flow. Here is what it should look like:
            8. <img width="639" alt="image (13)" src="https://user-images.githubusercontent.com/39100635/200144404-9b5da7e7-5ee1-4acb-9e77-e1d56c0336a5.png">
        25. Again, this Apex would normally be used to call out to an ISV app. For demo purposes, we are returning a static value to mock this callout
            1. Let’s quickly look at the Apex. Notice the @invocableMethod decorator, which makes it available to use in Flow Builder
            2. <img width="395" alt="image" src="https://user-images.githubusercontent.com/39100635/200144480-5746492d-7337-46b6-8d27-8479aefd7e37.png">
        26. Click *Save* in the top right corner to save the Flow
        27. Click *Activate*
        28. <img width="412" alt="image (1)" src="https://user-images.githubusercontent.com/39100635/200144492-d367635b-7c16-45b7-a13b-201fce7ab9da.png">
        29. Go into Setup, type *All Sites* in the quick search, and click *All Sites*
        30. Click on *Builder* next to the *AlpineB2B* site
        31. <img width="450" alt="image (2)" src="https://user-images.githubusercontent.com/39100635/200144502-11d9a1f0-9f31-4655-848e-8c1d4c027e33.png">
        32. In Experience Builder, click *Home* in the top toolbar on the left, then click on *Checkout* 
        33. <img width="1476" alt="image (3)" src="https://user-images.githubusercontent.com/39100635/200144508-ba7f2cf7-62d0-467a-a36b-91f8a5619a4c.png">
        34. Click on the *Checkout Flow* component to bring up a floating panel on the right. In this panel, select your new Flow, *Checkout Flow Template Clone* so that it will run the newly cloned flow instead of the original checkout flow demoed earlier
        35. In the top right of Experience Builder, click *Publish*, the *Publish* again so that your changes can be seen in the Site
        36. <img width="1404" alt="image (4)" src="https://user-images.githubusercontent.com/39100635/200144518-83273f55-6641-4f32-a32a-0abdd82ea53f.png">
        37. <img width="624" alt="image (5)" src="https://user-images.githubusercontent.com/39100635/200144529-ee9ce7da-9f99-49bd-81e0-8f49404da76a.png">
        38. SKIP for workshop Try out the new checkout flow to show the difference
            1. On your tab that still has salesforce open (not the B2B Site), click the app launcher and type Contacts, and click *Contacts*
            2. <img width="170" alt="image (6)" src="https://user-images.githubusercontent.com/39100635/200144542-27402d12-6499-4120-a4be-29f9c480b702.png">
            3. Search for *Bonnie Buyer* and click into this record
            4. <img width="916" alt="image (7)" src="https://user-images.githubusercontent.com/39100635/200144548-aee00cb9-bba5-42c4-a62e-85c20c3e43bb.png">
            5. Click on the dropdown arrow in the actions area near the top right of the screen, and click on *Log in to Experience as User*
            6. <img width="1720" alt="image (8)" src="https://user-images.githubusercontent.com/39100635/200144557-284b340c-b0bd-427e-84dc-e59135df86a5.png">
                1. Note: if you don’t see this button appearing, click the cog wheel near the top right of the screen, click *Edit Page*, click the top right area with these action buttons, then click *Add Action* near the bottom right, add the *Log in to Experience as User* action to the list, and click *Done*. Click *Save* and then click *Activation* to make sure the page is assigned as the Org Default, then return to the page by clicking the left arrow in the top left of the edit screen
            7. Add one of the products to your cart, click the cart icon, and click *Checkout* to see our flow working
        39. The development work is complete!
3. Pull the created metadata out of the org using VS Code
    1. {self} Talk about packaging, summary of how to get from dev-complete to an AppExchange listing
    2. {self} Talk about how today we are working in a non-scratch org due to scratch org tooling for Commerce still being worked on. If we were using a scratch org, all of our changes to the org’s metadata would automatically be tracked, and we could just pull changes without having to remember every piece of metadata we created or changed
    3. To retrieve our B2B Commerce flow, paste the following command into VS Code’s embedded terminal:
        1. `sfdx force:source:retrieve -m Flow:Checkout_Flow_Template_Clone`
            1. You should receive a confirmation message:
            2. <img width="769" alt="image" src="https://user-images.githubusercontent.com/39100635/200145726-cf622a20-3075-474d-a89e-5246a5eb917f.png">
        2. To retrieve the Order Management flow, paste `sfdx force:source:retrieve -m Flow:Create_Reship_Order_Clone` into VS Code's embedded terminal
    4. All of the functionality that we developed inside the org, along with the pre-written code we got from Github initially, is now in our *local directory* which can be seen in VS Code’s left pane. Next step is to package it for distribution and sale
    5. We are going to skip a few steps of development lifecycle here. Here is an opinionated view of the steps we are skipping:
        1. Normally, we would deploy the metadata into a scratch org to test whether it can be deployed successfully and that it functions as expected inside a different org (Unit tests, QA, UAT, integration test, etc.)
        2. If the above tests are successful, we would stage & commit the changes to git and push to the developer’s personal branch on the Github repo
        3. We would open a Pull Request, which would trigger a CI/CD job which would run a static code analysis, deploy the metadata into a scratch org, run all apex (and any other types of) tests, and if everything passes, notify a dev lead to do a code review
        4. A Dev Lead merges the Pull Request into, for example, a release branch
        5. Then we are ready to package the app (or just create a new package version, if it is an existing packaged app)
4. Package your app
    1. We are going to go fast here. See this [terrific documentation](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_dev2gp_workflow.htm) for more context on each step we do here: 
    2. Paste and enter the following commands, in order:
        1. `sfdx force:package:create -n "Commerce Workshop App B2B" -r force-app -t Managed`
            1. Note: you will likely get the error “*The package name must be unique for the namespace*”. Modify the command above to add some characters to then end of the name so that your name is unique, and run it again. Use this new name in the below steps as well.
        2. `sfdx force:package:version:create —p "Commerce Workshop App B2Bv2" —w 10 -x -c -f config/project-scratch-def.json`
            1. We are once again skipping steps here - Normally we would install the package (before promoting it) into a scratch org to test that we can install/upgrade successfully, and that the functionality works as expected
        3. `sfdx force:package:version:promote -p "Commerce Workshop App B2B@0.1.0-1" -n`
5. Submit package for Security Review & List on AppExchange
    1. At this point we are ready to connect our package to our Partner Community login so that we can submit it for Security Review and list it live on the AppExchange
        1. We will just demo this, since we don’t want to actually list this sample app on AppExchange or dirty your data
    2. Some background: typically your company receives its *PBO* (*Partner Business Org*) when the first person from the company creates a login in the Partner Community as an ISV. 
        1. This person’s username and password to log in to the PBO and to the Partner Community are the same
        2. We strongly advise ISVs to use this *PBO* as their *Dev Hub*, which means it will own all 2GPs (second-generation packages)
    3. To connect your package to your Partner Community login:
        1. Log in to the [Partner Community](http://partners.salesforce.com/)
        2. <img width="868" alt="image (1)" src="https://user-images.githubusercontent.com/39100635/200146130-87ac2a98-6f45-42e3-b482-f0fd5a275bbd.png">
        3. <img width="430" alt="image (2)" src="https://user-images.githubusercontent.com/39100635/200146141-b2a38ebd-9d29-42f9-aef9-9a876d02d486.png">
        4. <img width="401" alt="image (3)" src="https://user-images.githubusercontent.com/39100635/200146151-8b3c7811-5016-4b06-be5a-68b8cbd36e0c.png">
        5. Click on the *Publishing* tab
        6. <img width="697" alt="image (4)" src="https://user-images.githubusercontent.com/39100635/200146166-630f7375-c463-44ef-98ca-6ed9f1688e05.png">
        7. then click on the *Organizations* subtab
        8. <img width="876" alt="image (5)" src="https://user-images.githubusercontent.com/39100635/200146172-bc12e5a5-38d2-408d-9394-08afc0e8209a.png">
        9. If you don’t see your Dev Hub org, click the *Connect Org* button and log in to it
        10. <img width="1075" alt="image (6)" src="https://user-images.githubusercontent.com/39100635/200146176-56e4132d-6c9f-4fa6-ba26-e2779534631b.png">
        11. Now go to the *Packages* subtab and you should see your package
        12. <img width="1127" alt="image (7)" src="https://user-images.githubusercontent.com/39100635/200146190-19a9c02c-6a35-4d38-b095-ea3ec8d99657.png">
    4. Notice there are options here to *Start Review* and *Create Listing*. These can be done in parallel. Security Review takes time, so in the meantime you can design and optimize how you want your future AppExchange Listing to look
        1. Security Review goes a lot smoother if you understand what best practices it will check for before you start developing a real ISV application
        2. Here is how to [prepare for](https://trailhead.salesforce.com/content/learn/modules/isv_security_review/isv_security_review_prepare?trail_id=isv_developer_beginner) and [submit for](https://trailhead.salesforce.com/content/learn/modules/isv_security_review/isv_security_review_submit?trail_id=isv_developer_beginner) Security Review, and a [requirements checklist](https://partners.salesforce.com/0693A000007QbpbQAC) to help you ace your review. Please read this carefully, as Security Review can cause major go-live delays if we have to have many cycles of submitting, rejection, and resubmitting
    5. Once you are notified that your app has passed Security Review, you can go to the *Listings* subtab and click the *Publish Listing* button to make your app live on the AppExchange for customers to find!
    6. <img width="822" alt="image (8)" src="https://user-images.githubusercontent.com/39100635/200146196-d102c252-6591-4fd0-9e49-7f7a1edddec6.png">
    7. Congratulations, your live AppExchange listing will now start [generating leads](https://developer.salesforce.com/docs/atlas.en-us.packagingGuide.meta/packagingGuide/appexchange_leads_intro.htm)!

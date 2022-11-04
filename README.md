


# Workshop: Build an ISV app to extend Salesforce Order Management and B2B Commerce

In this workshop we will be developing and packaging a sample AppExchange ISV app that works with the Salesforce [B2B Commerce](https://help.salesforce.com/s/articleView?id=sf.comm_intro.htm&type=5) and [Order Management](https://help.salesforce.com/s/articleView?id=sf.om_order_management.htm&type=5) products. For packaging, we will be using [Second-Generation Packaging](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_dev2gp.htm) (2GP).

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
            1. [Image: image.png]
        2. Now open *VS Code*. You may see either the “Get Started” screen in VS Code, or it may open the most recent directory you’ve been working in, it makes no difference for this exercise. 
        3. Go to *File* >> *Open Folder* >> *Desktop >> Open*. 
        4. [Image: image.png]
        5. [Image: image.png]
        6. In the bottom toolbar on the left side, click near the *X* and *!* icons to bring up the embedded terminal, then click *TERMINAL*
        7. [Image: image.png]
        8. type  `git clone ` and then paste the URL you copied from the Github repo
            1. `git clone https://github.com/sfdx-isv/commerce-workshop.git`
            2. Hit *Enter/Return* to run the command
        9. Your file directory on the left hand side of VS Code should now include *commerce-workshop* in the list of folders and files
        10. [Image: image.png]
        11. Now we need to open VS code in the context of that new folder. Repeat the steps to open a folder with VS Code:
            1. Go to *File* >> *Open Folder* >> *commerce-workshop>> Open*. 
            2. [Image: image.png]
            3. [Image: image.png]
    2. Next, we will connect the Salesforce CLI to the *Dev Hub* org (so we can later package our app)
        1. In VS Code, click on *No Default Org Set* on the bottom toolbar, which will open the Command Palette
        2. In the Command Palette, click on *SFDX: Authorize a Dev Hub*
        3. [Image: image.png]
        4. This will open a new tab in your browser with a Salesforce *login screen*
        5. [Image: image.png]
            1. Note: these instructions are written for a live workshop where I set up the orgs and everyone’s logins beforehand. If you are following along yourself, you can create your own [Dev Hub](https://developer.salesforce.com/docs/atlas.en-us.packagingGuide.meta/packagingGuide/sfdx_setup_enable_devhub.htm) and your own Commerce org (using either a [Trialforce Template and Environment Hub](https://salesforce.quip.com/q9RUACra2Jfa) or a [Demo org](https://partners.salesforce.com/pdx/s/learn/article/demo-station-for-partners-MCUTYORCVUVNCJTIVCKP6VHUKF3M?language=en_US) for the Commerce org) for free
        6. Log in with your username and password for this Dev Hub org: 
            1. Username: <<TheEmailYouRegisteredWith>>.commerce-workshop-dev-hub
            2. Password: (I will give this to you in the workshop)
        7. Click *Allow*, which authorizes the Salesforce CLI to connect to this Dev Hub org in the context of your user login
        8. [Image: image.png]
        9. If it asks for your phone number, click *Remind Me Later*
        10. [Image: image.png]
    3. Finally, connect the Salesforce CLI to your Commerce org (where we will build our app)
        1. In VS Code, once again click on *No Default Org Set* on the bottom toolbar, which will open the Command Palette
        2. This time in the Command Palette, click on *SFDX: Authorize an Org* (not a Dev Hub)
        3. [Image: image.png]
        4. This brings up a set of options, click *Production*
        5. [Image: image.png]
        6. Next, for the org’s alias, type *commerce-workshop-develop* and hit *Enter/Return*
        7. [Image: image.png]
        8. This will open a new tab in your browser with a Salesforce *login screen*
        9. [Image: image.png]
        10. Log in with your username and password for this org: 
            1. Username: <<TheEmailYouRegisteredWith>>.commerce-workshop-develop
            2. Password: (I will give this to you in the workshop)
        11. Click *Agree*, to authorize the Salesforce CLI to connect to this org 
        12. [Image: image.png]
        13. Notice the bottom toolbar of VS Code no longer says “No Default Org Set”, it says *commerce-workshop-develop*, which is the alias we gave to the Commerce org. It also shows a *plug* icon to indicate that Salesforce CLI is connected to default org
        14. [Image: image.png]
    4. Congrats! The Salesforce CLI is now connected to both orgs we need: the *Dev Hub* (to package our app later), and the *Commerce* org (where we will build our app now)
2. Build the app in the Commerce org
    1. Part 1: Push code into the Commerce Org
        1. In VS Code, we will now take two Apex classes, *ShippingService.cls* and *ShippingServiceTest.cls*, that we got from cloning the Github repo and push them into the Commerce org so we can use them in the app we’re going to develop
        2. In the left pane of VS Code you should see a file directory. If you don’t see this, click on the topmost icon in the left sidebar to open it.
        3. Click on the *force-app* folder
        4. [Image: image.png]
        5. From there, *right-click* on the *classes* folder, which opens a pop-up menu
        6. Click on the *SFDX: Deploy Source to Org* option, near the bottom
        7. [Image: image.png]
        8. You should receive a success message pop-up window near the bottom right of your VS Code window
        9. [Image: image.png]
        10. Now, toward the left side of the bottom toolbar, click on the below icon, which resembles a mini browser window. This opens the Commerce org in your browser. Notice you don’t have to log in again!
        11. [Image: image.png]
    2. Part 2: Configure a Sample Order Management ISV App
        1. Overview: Since our use case is a Shipping Calculation ISV App, we will clone and modify one of Order Management’s out-of-the-box flows, a reshipment flow, to leverage our ISV app’s functionality
        3. In the Commerce org, click the *cog wheel* toward the top right of your screen and click *Setup*.
        4. [Image: image.png]
        5. Type “Flow” in the quick find search near the top left of the Setup menu, and click *Flows*. 
        6. [Image: image.png]
        7. Find and *click on* the Flow named *Create Reship Order* to open it
        8. [Image: image.png]
        9. Click *Save As*
        10. [Image: image.png]
        11. In the popup window, click *A New Flow*
        12. For Flow Label, type *Create Reship Order Clone*. The API name will be auto-populated to *Create_Reship_Order_Clone*
        13. Click *Save*
        14. [Image: image.png]
        15. Now in your newly cloned flow, *drag* the screen to the right on the flow canvas (the big area on the right side), and look for the blue Screen element titled *Location Selection*
        16. [Image: image.png]
        17. From the *Flow Toolbox* (the panel on the left side of the screen), drag an *Action* element onto the canvas, to the *right* of the *Location Selection* element
        18. [Image: image.png]
        19. In the pop-up that opens, for the *Category* on the left side, click *Commerce*
        20. Then in the *Action* box on the right, select *Calculate Shipping Price*, which is an invocable Apex method in the Apex class we pushed into the org earlier. 
        21. Name the element *Calculate Shipping Price*.
        22. [Image: image.png]
        23. For the Label, type *Calculate Shipping Price* and click *Done*
        24. [Image: image.png]
            1. The use case is a bit contrived- we are adding a shipping calculation to a re-ship request flow. Usually a re-ship request happens because a customer’s original shipment was lost or damaged and many companies will not charge any money to re-ship, to provide good customer service. This use case educational only, and is not business advice on whether to charge customers for shipping or not.
        25. So that we can easily see the results of this Apex action, drag a *Screen* element from the *Flow Toolbox* on the left into the canvas to the *right* of our new Apex action
        26. [Image: image.png]
        27. First, give the Screen element a *label* on the right side of the pop-up: *Shipping Price Confirmation Screen*
        28. [Image: image.png]
        29. Then, from the left side of the pop-up, drag a *Display Text* component onto the screen in the center, and then *click on it*
        30. On the right side, give this Display Text an API name such as *ShippingConfirmation*
        31. Below that, paste the text: *The price to reship will be £{!Calculate_Shipping_Price}* or alternatively, type it and click the box that says *Insert a resource...* and type *calc* to locate the *variable* holding the output of our invocable apex and then click on it
        32. Click *Done* to save the screen
        33. [Image: image.png]
            1. This is an important concept to understand. If you use Apex inside of a Flow, the output of the Apex is automatically stored as a variable and can be referenced later, used in calculations, decisions, business logic, etc.
        34. Change the connections between the elements on the flow canvas:
            1. Click the connector between the *Location Selection* and *Set Stage To Part 4* elements and hit the *Delete* key
            2. [Image: image.png]
            3. Click the white dot at the bottom of the *Location Selection* element and drag it onto the *Calculate Shipping Price* element. 
            4. Do the same to connect *Calculate Shipping Price* to *Shipping Price Confirmation Screen*
            5. Lastly, connect *Shipping Price Confirmation Screen* to *Set Stage To Part 4*
            6. [Image: image.png]
        35. *Save* the Flow and then click *Activate*
        36. [Image: image.png]
        37. One last step to surface our new Flow! From Setup, start typing *Actions & Recommendations* in the quick search box in the top left and click on *Actions & Recommendations*
        38. On the row that says *Summer ’22 Flow Package*, click on the *dropdown arrow* on the far right, then click *Edit*
        39. [Image: image.png]
        40. In the popup window, click *Next*, then *Next* again
        41. [Image: image.png]
        42. [Image: image.png]
        43. Now click the *Default* tab toward the top left
        44. In the *search* box that appears, search your new flow, *Create Reship Order Clone*, and *drag* it into the list on the right
        45. Click *Next* again
        46. [Image: image.png]
        47. Again search your new flow, *Create Reship Order Clone*, and check the *checkbox* on the left of it
        48. [Image: image.png]
        49. Click *Save*
        50. Now it is time to see your flow in action! From the App Launcher (the 9 dots in a square in the top left),  type and select *Order Management*
        51. Search *00001301* and click on the matching Order Summary Record
        52. You should see a screen like this: 
        53. [Image: image.png]
        54. Look for your *Create Reship Order Clone* flow in the Actions & Recommendations section. If you don’t see it, click on the blue *Add* button and then start typing *Create Reship Order Clone* and then click on it
        55. Work your way through the flow until you see our new the *screen* we added, which shows that our invocable apex method was successfully called by our flow and returned an amount for the shipping price
        56. [Image: image.png]
        57. We have successfully finished development on an ISV app for Salesforce Order Management!
        58. Next Steps on your own for further learning:
        59. The Commerce orgs (which you get to keep until they expire) have a more realistic sample implementation of our Shipping app in the Apex class B2BDeliverySample (go to Setup >> Apex Classes to find this in your org), feel free to save the code for reference.
    3. Part 3: Configure a Sample B2B Commerce ISV App
        1. In the org, click the *cog wheel* toward the top right of your screen and click *Setup*.
        2. [Image: image.png]
        3. Type “Flow” in the quick find search near the top left of the Setup menu, and click *Flows*. 
        4. [Image: image.png]
        5. Scroll to find and *click on* the checkout flow that is currently in use, *Checkout Flow Template* to open it
        6. [Image: image.png]
        7. Click *Save As*
        8. [Image: image.png]
        9. For Flow Label, type *Checkout Flow Template Clone*. The API name will be auto-populated to *Checkout_Flow_Template_Clone*.
        10. Click *Save*
        11. [Image: image.png]
        12. Now in your newly cloned flow, *drag* the screen downward on the flow canvas (the big area on the right side), and find the step that calculates *Shipping Cost*, and notice that it is a *subflow*
            1. *Subflows* are a way to modularize business logic, similar to helper or utility methods in code
            2. [Image: image.png]
        13. We will replace this step with a method from our *Apex class* that we deployed to this org earlier. To keep things simple, we will *not* use a subflow here.
            1. The use case is, we are swapping out the out-of-the box way that B2B Commerce calculates shipping costs, and replacing it with our Apex class that would normally call out to our off-platform, third party ISV app to perform complex shipping calculations based on inputs such as an array of items and their sizes, weights, quantities, shipping methods, distance needed to deliver, etc. For this workshop we are simply mocking the callout and returning a static currency amount. 
        14. From the *Flow Toolbox* panel on the left side, drag an *Action* element on to the canvas near the *Shipping Cost* subflow icon
        15. [Image: image.png]
        16. In the pop-up that opens, for the *Category* on the left side, click *Commerce*
        17. Then in the *Action* box on the right, select *Calculate Shipping Price*, which is an invocable Apex method in the Apex class we pushed into the org earlier.
        18. [Image: image.png]
        19. Name the element *Calculate Shipping Price* and click *Done*
        20. [Image: image.png]
        21. Click on the *Shipping Cost* subflow element and hit the *Delete* key
        22. [Image: image.png]
        23. Notice the arrows that were connected to the *Shipping Cost* element disappear too
        24. We will need to re-create those arrows to connect our new *Calculate Shipping Price* element to the correct existing Flow elements to form a smooth end-to-end Flow
            1. Drag from the *white circle* at the bottom of the *Main Decision Hub* element onto the *Calculate Shipping Price* element and *release*
                1. If you need to, zoom out by clicking the “*-*” icon in the bottom left of the flow canvas
            2. [Image: image.png]
            3. In the popup window that appears, make sure *Shipping Cost* is selected and click *Done*
            4. [Image: image.png]
            5. Next, drag from the *white circle* at the bottom of the *Calculate Shipping Price* element onto the *Assignment Loop* element and *release*
            6. [Image: image.png]
            7. We are done with the Flow. Here is what it should look like:
            8. [Image: image.png]
        25. {self} Again, this Apex would normally be used to call out to an ISV app. For demo purposes, we are returning a static value to mock this callout
            1. Let’s quickly look at the Apex. Notice the @invocableMethod decorator, which makes it available to use in Flow Builder
            2. [Image: image.png]
        26. Click *Save* in the top right corner to save the Flow
        27. Click *Activate*
        28. [Image: image.png]
        29. Go into Setup, type *All Sites* in the quick search, and click *All Sites*
        30. Click on *Builder* next to the *AlpineB2B* site
        31. [Image: image.png]
        32. In Experience Builder, click *Home* in the top toolbar on the left, then click on *Checkout* 
        33. [Image: image.png]
        34. Click on the *Checkout Flow* component to bring up a floating panel on the right. In this panel, select your new Flow, *Checkout Flow Template Clone* so that it will run the newly cloned flow instead of the original checkout flow demoed earlier
        35. In the top right of Experience Builder, click *Publish*, the *Publish* again so that your changes can be seen in the Site
        36. [Image: image.png]
        37. [Image: image.png]
        38. SKIP for workshop Try out the new checkout flow to show the difference
            1. On your tab that still has salesforce open (not the B2B Site), click the app launcher and type Contacts, and click *Contacts*
            2. [Image: image.png]
            3. Search for *Bonnie Buyer* and click into this record
            4. [Image: image.png]
            5. Click on the dropdown arrow in the actions area near the top right of the screen, and click on *Log in to Experience as User*
            6. [Image: image.png]
                1. Note: if you don’t see this button appearing, click the cog wheel near the top right of the screen, click *Edit Page*, click the top right area with these action buttons, then click *Add Action* near the bottom right, add the *Log in to Experience as User* action to the list, and click *Done*. Click *Save* and then *Activation* to make sure the page is assigned as the Org Default, then return to the page by clicking the left arrow in the top left of the edit screen
            7. Add one of the products to your cart, click the cart icon, and click *Checkout* to see our flow working
        39. The development work is complete!
3. Pull the created metadata out of the org using VS Code
    1. {self} Talk about packaging, summary of how to get from dev-complete to an AppExchange listing
    2. {self} Talk about how today we are working in a non-scratch org due to scratch org tooling for Commerce still being worked on. If we were using a scratch org, all of our changes to the org’s metadata would automatically be tracked, and we could just pull changes without having to remember every piece of metadata we created or changed
    3. To retrieve our B2B Commerce flow, paste the following command into VS Code’s embedded terminal:
        1. `sfdx force:source:retrieve -m Flow:Checkout_Flow_Template_Clone`
            1. You should receive a confirmation message:
            2. [Image: image.png]
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
        2. [Image: image.png]
        3. [Image: image.png]
        4. [Image: image.png]
        5. Click on the *Publishing* tab
        6. [Image: image.png]
        7. then click on the *Organizations* subtab
        8. [Image: image.png]
        9. If you don’t see your Dev Hub org, click the *Connect Org* button and log in to it
        10. [Image: image.png]
        11. Now go to the *Packages* subtab and you should see your package
        12. [Image: image.png]
    4. Notice there are options here to *Start Review* and *Create Listing*. These can be done in parallel. Security Review takes time, so in the meantime you can design and optimize how you want your future AppExchange Listing to look
        1. Security Review goes a lot smoother if you understand what best practices it will check for before you start developing a real ISV application
        2. Here is how to [prepare for](https://trailhead.salesforce.com/content/learn/modules/isv_security_review/isv_security_review_prepare?trail_id=isv_developer_beginner) and [submit for](https://trailhead.salesforce.com/content/learn/modules/isv_security_review/isv_security_review_submit?trail_id=isv_developer_beginner) Security Review, and a [requirements checklist](https://partners.salesforce.com/0693A000007QbpbQAC) to help you ace your review. Please read this carefully, as Security Review can cause major go-live delays if we have to have many cycles of submitting, rejection, and resubmitting
    5. Once you are notified that your app has passed Security Review, you can go to the *Listings* subtab and click the *Publish Listing* button to make your app live on the AppExchange for customers to find!
    6. [Image: image.png]
    7. Congratulations, your live AppExchange listing will now start [generating leads](https://developer.salesforce.com/docs/atlas.en-us.packagingGuide.meta/packagingGuide/appexchange_leads_intro.htm)!



# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
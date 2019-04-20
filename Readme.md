# SmartShare Demo setup

**Test has been done on windows platform**
<br><br>

**Step 1: Installing & Running the Ethereum TestRPC**

The Ethereum TestRPC is a Node.js Ethereum client for the testing and developing smart contracts. Because it's based on Node.js, we need Node.js installed along with NPM (Node Package Manager) to install it.
Open up your command line or console and run the following 2 commands:

    node -v
    npm -v

If either of these commands go unrecognized, visit Nodejs.org and download the appropriate installer. Run it through all of the default options.
Once finished, close and reload your console and re-run the commands above. They should now provide you with version numbers.

Next, let's use NPM to install the Ethereumjs-testrpc:

    npm install -g ethereumjs-testrpc

Once finished, run the following command to start it:

    testrpc

`testrpc` is used to provide 10 different accounts and private keys, along with a local server at `localhost:8545`.
<br><br>

**Step 2: Clone the code from [SmartShare Github](https://github.com/qingqingkzhou/SmartShare.git) or get it from submitted folder `/SmartShare/`**
<br><br>

**Step 3: Open any internet browser (prefer google chrome) and go to [Remix online IDE](https://remix.ethereum.org/) to be able to load solidity files**

- On Remix online IDE, use the `folder` button to load the sol files from /SmartShare/sol/
<br>
![step3-1](/images/step3-1.png)
- Files should show under the `Browser` section
<br>
![step3-2](/images/step3-2.png)
<br><br>

**Step 4: Compile the solidity files**
- Choose version:0.5.0+commit.1d4f565a.Emscripten.clang: (choose the compiler version from the dropdown list)
- Click the `Start to compile`
- Make sure all the highlighted parts in the screenshot below are set correctly
- After successfully compiled, `SmartShare` should be displayed in a green block as shown below
<br>
![step4](/images/step4.png)
<br><br>

**Step 5: Run testrpc from any command line**
<br>
![step5](/images/step5.png)
<br><br>

**Step 6: Deploy and connect Remix smart contract with testrpc**
- go back to https://remix.ethereum.org/ and in the “Run” tab, select “Web3 Provider”
- Click “ok” if remix asks
- Make sure select “SmartShare”
- Click “Deploy” button to deploy the smart contract
<br>
![step6](/images/step6.png)
<br><br>

**Step 7: Copy the the SmartShare contract address into `index.html`**
- After deploying SmartShare, SmartShare should show in the screenshot below
- Click on the copy button as shown in the screenshot below to get the SmartShare’s contract address
<br>
![step7-1](/images/step7-1.png)
<br>
- Open index.html from the source code folder of SmartShare
- Go to `line 129` and replace the existing contract address with the new address
<br>
![step7-2](/images/step7-2.png)
<br>
- Save index.html
<br><br>

**Step 8: Create an owner account**
- Open `index.html` in Internet Explorer (Chrome does not work properly)
- Select `Item Owner` from dropdown list and then fill in the form
- Click `Add owner account`
<br>
![step8-1](/images/step8-1.png)
<br>
- Refresh the page and it should show 1 account has been registerd
<br>
![step8-2](/images/step8-2.png)
<br><br>

**Step 9: Add a loaner account**
- Select “Item Loaner” from dropdown list and then fill in the form
- Click “Add loaner account”
<br>
![step9-1](/images/step9-1.png)
<br>
- Refresh the page and show see 2 accounts have been registered
<br>
![step9-2](/images/step9-2.png)
<br>

**Step 10: Login as a loaner. Enter loaner username and click login**
<br>
![step10](/images/step10.png)
<br><br>

**Step 11: Searching for item**
- Enter the item and the maximum price that you can accept.
- If there is any matching item with acceptable price, it will be displayed.
<br>
![step11](/images/step11.png)
<br><br>

**Step 12: Create proposal**
- If there are items available, item will be displayed with its owner
- Enter the start and end day
- Click on Create Proposal button to generate a proposal
<br>
![step12-1](/images/step12-1.png)
<br>
- Proposal details will be shown as below with initial status “Pending for approval”
<br>
![step12-2](/images/step12-2.png)
<br><br>

**Step 13: Prove the proposal**
- Login using the item owner’s account
- Since there’s a “Pending for approval” proposal available for this owner, two buttons will show as below (`Approve Proposal` and `Reject Proposal`)
- Click the `Approve Proposal` to approve the proposal (Owner may also reject it if owner does not want to loan the property for this user for some reason)
<br>
![step13-1](/images/step13-1.png)
<br>
- Click `View Proposal` to check the new status of the proposal. `Approved - Inactive`
<br>
![step13-2](/images/step13-2.png)
<br><br>

**Step 14: Activate the proposal**
- The actual activation of the proposal should start from the `Start Day` of the contract. Howere, for testing purpose, a special button `Start` to trigger the start date.
<br>
![step14-1](/images/step14-1.png)
<br>
- Click `View Proposal` to check the new status of the proposal. `Approved - Active`
<br>
![step14-2](/images/step14-2.png)
<br>
![step14-3](/images/step14-3.png)
<br><br>

**Step 15: Get access code**
- Since the proposal is active now, an access code has been generated by SmartShare automatically
- Refresh the page and login as either owner or loaner in the proposal to be able to view the access code
- Any other user login will not be able to view the access code
<br>
![step15-1](/images/step15-1.png)
<br>
- If login as users that are not in the proposal, they will not be able to see the access code
<br>
![step15-2](/images/step15-2.png)
<br><br>

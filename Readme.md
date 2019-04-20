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
![step3-1](/images/step3-1.png)
- Files should show under the `Browser` section
![step3-2](/images/step3-2.png)
<br><br>

**Step 4: Compile the solidity files**
- Choose version:0.5.0+commit.1d4f565a.Emscripten.clang: (choose the compiler version from the dropdown list)
- Click the `Start to compile`
- Make sure all the highlighted parts in the screenshot below are set correctly
- After successfully compiled, `SmartShare` should be displayed in a green block as shown below
![step4](/images/step4.png)
<br><br>

**Step 5: Run testrpc from any command line**
![step5](/images/step5.png)
<br><br>

**Step 6: Deploy and connect Remix smart contract with testrpc**
- go back to https://remix.ethereum.org/ and in the “Run” tab, select “Web3 Provider”
- Click “ok” if remix asks
- Make sure select “SmartShare”
- Click “Deploy” button to deploy the smart contract
![step6](/images/step6.png)
<br><br>

**Step 7: Copy the the SmartShare contract address into `index.html`**
- After deploying SmartShare, SmartShare should show in the screenshot below
- Click on the copy button as shown in the screenshot below to get the SmartShare’s contract address
![step7-1](/images/step7-1.png)

- Open index.html from the source code folder of SmartShare
- Go to `line 129` and replace the existing contract address with the new address
![step7-2](/images/step7-2.png)
- Save index.html
<br><br>

**Step 8: Create an owner account**
- Open `index.html` in Internet Explorer (Chrome does not work properly)
- Select `Item Owner` from dropdown list and then fill in the form
- Click `Add owner account`
![step8-1](/images/step8-1.png)

- Refresh the page and it should show 1 account has been registerd
![step8-2](/images/step8-2.png)
<br><br>

**Step 9: Add a loaner account**
- Select “Item Loaner” from dropdown list and then fill in the form
- Click “Add loaner account”
![step9-1](/images/step9-1.png)
- Refresh the page and show see 2 accounts have been registered
![step9-2](/images/step9-2.png)

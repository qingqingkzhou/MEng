SmartShare
=======

## Overview

A Smart Contract based solution that connects real-world with blockchain world in sharing economy. 

**Problems with current shared economy**
1. Centralized online platform business model 
2. Rely on a third party for sharing goods or providing services
3. Limited transparency of transaction history
4. Goods and services have to be posted on different platforms
5. Require human to verify the transaction 

---

`SmartShare` is a Decentralized Autonomous Organization (DAO) framework written in Solidity to run on the Ethereum blockchain. It consists of several smart contracts to process, transform, synchronize critical data flow in a sharing economy environment. In this example, SmartShare is built on a concrete example of renting properties, which involves the concepts of digital lock and Internet of Things (IoT) into smart contract to facilitate an automatica decentralized sharing economy platform.

## Setup

**Standalone smart contract:**
- `SmartShare` solidity files can be run in [Remix Ethereum][ref1] by choosing "JavaScript VM" environment.
- Follow the steps in [Demo Setup](/DemoSetup.md)

**Run on server:**
If running with a server as front end, use `testrpc` (follow the steps [here][ref2]) along with following html files to display the transactions and contents of contracts:
- account.html: display all registered accounts as owner and loaner
- proposal.html: display a proposal being created by loaner with respect to a certain item and owner
- contract.html: display the final contract content after proposal being approved. The most important parts of this contract is an `Access Code`, which will be shared with the controler in the item side (for example, an IoT smart lock will receive this access code and invoke this code for the active period so that the loaner/customer will be able to use the same code to unlock the door)


### Reference
[Decentralized autonomous organization to automate governance - White Paper][ref]

[ref]: https://download.slock.it/public/DAO/WhitePaper.pdf
[ref1]: https://remix.ethereum.org
[ref2]: https://coursetro.com/posts/code/99/Interacting-with-a-Smart-Contract-through-Web3.js-(Tutorial)

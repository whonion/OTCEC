# OTCEC
Contract for P2P OTC onchain transactions
# Terms of Reference
<strong>The logic of a smart contract is quite simple:</strong>

1. The buyer or seller deploys a smart contract. (User A.)

2. The parties announce the tokens they plan to exchange through the smart contract.

The buyer adds to the storage of the smart contract (func OpenOTC):
<ul>
<li>Address of deposited asset(USDT,USDC,ETH)</li>
<li>Deposit amount</li>
<li>Deposit address</li>
<li>Seller's address</li>
<li>The address of the asset to be received from the Seller</li>
</ul>
3. Seller adds to the smart contract depository:
<ul>
<li>Token address of the asset being sent (UNI,1inch,PSP or other)</li>
<li>Deposit amount</li>
<li>Deposit address (wallet from which the deposit will be made)</li>
<li>Buyer address</li>
<li>Address of the asset that plans to sell from the Buyer</li>
</ul>
After adding the assets, if everything is correct, you need to call the function ExecP2P function on both sides

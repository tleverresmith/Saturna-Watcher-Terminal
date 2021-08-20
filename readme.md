# Saturna Price Watcher
This is a quick and dirty PowerShell script that will get you the value of your Saturna holdings and update every 5 minutes. It pulls the current value from the PancakeSwap public API, so it can only update as fast as that API polls.

The code is not very effecient or clean, this was initially thrown together for my PowerShell profile and has been adapted to a standalone script for sharing. It is bound to change over time.

## Usage
Start the script from a PowerShell terminal (no admin required) that has web access and give it your current Saturna holdings. It will then poll the PancakeSwap API for the current value and give you your bags value in USD.

Example
![User Input](https://github.com/tleverresmith/Saturna-Watcher-Terminal/blob/main/scr1.png?raw=true)
![Running](https://github.com/tleverresmith/Saturna-Watcher-Terminal/blob/main/scr2.png?raw=true)





### TO-DO
*These may not happen any time soon, I only work on this when the fancy strikes. Feel free to contribute code if you do one of these improvments or anything else cool!*
- Make it pull your Saturna holdings from a wallet address
- Display the value in a currency of your choice
- Give a simple price change indication 

# ChibiWallet - A Flutter Crypto Wallet for Ethereum

**ChibiWallet** is a mobile app built with **Flutter** that enables users to send and receive Ethereum (ETH) and ERC-20 tokens. It allows users to manage their Ethereum-based assets securely and efficiently, providing an intuitive user experience for crypto transactions.

## Features

- **Send Ethereum (ETH)**: Easily send ETH to other addresses on the Ethereum network.
- **Send ERC-20 Tokens**: Supports sending any Ethereum-based tokens that follow the ERC-20 standard.
- **Wallet Management**: Create and manage wallets securely with private key encryption.
- **Balance Viewing**: View both your ETH and ERC-20 token balances in real-time.
- **Backup & Recovery**: Securely back up your wallet and restore it using a mnemonic phrase or private key.
- **Transaction History**: View transaction history for ETH and ERC-20 token transfers.
- **Secure**: Uses best practices for private key management and transaction signing.

## Technologies Used

- **Flutter**: A cross-platform mobile development framework used for building the app.
- **Dart**: Programming language used for building the app’s logic and UI.
- **Web3**: Used for interacting with the Ethereum blockchain for transactions and querying balances.
- **Provider**: State management solution for handling app data and user interactions.
- **BIP32/BIP44**: Standard for generating hierarchical deterministic wallets.
- **Flutter Secure Storage**: For securely storing private keys and sensitive data.

## Requirements

Before you begin, make sure you have the following:

- **Flutter SDK**: You must have **Flutter 3.0** or later installed on your machine.
- **Ethereum Wallet**: You can use a wallet like **MetaMask** or any Ethereum wallet that allows you to export your private key or mnemonic phrase.
- **Internet Connection**: Required for sending transactions and fetching blockchain data.

## Installation

Follow these steps to run the **ChibiWallet** app locally:

### 1. Clone the repository:

```bash
git clone https://github.com/your-username/ChibiWallet.git
```
### 2. Navigate into the project directory:
```bash
cd ChibiWallet
```
### 3. Install the dependencies:
```bash
flutter pub get
```
### 4. Run the app on an emulator or physical device:
```bash
flutter run
```
Ensure your device/emulator is connected and set up properly before running the app.

## Usage
Once the app is installed, you can perform the following tasks:

### 1. Creating or Importing a Wallet
Launch the app and either create a new wallet or import an existing wallet using a private key or mnemonic phrase.
The wallet will be securely stored, and you can access it whenever you open the app.
### 2. Sending Ethereum or ERC-20 Tokens
Go to the Send screen, select whether you want to send ETH or an ERC-20 token, enter the recipient's address, amount, and confirm the transaction.
Ensure you have sufficient balance for the transaction, including gas fees for ETH transactions.
### 3. Viewing Your Balance
On the Home screen, you can view your current ETH balance and the balance of any supported ERC-20 tokens.
### 4. Backup & Restore Wallet
In the Settings menu, you can back up your wallet to a secure location using a mnemonic phrase or private key.
You can also restore your wallet by entering the backup phrase or key.

## Contributing
I welcome contributions to improve **ChibiWallet**. If you want to contribute, please follow these steps:

### 1. Fork the repository:
Go to the GitHub repository and click the **Fork** button.
### 2. Create a new branch:
After forking, create a new branch to work on your feature or bug fix.
```bash
git checkout -b feature-name
```
### 3. Make changes:
Make the necessary changes to the code and commit them.
```bash
git add .
git commit -m "Description of your changes"
```
### 4. Push to your fork:
```bash
git push origin feature-name
```
### 5. Create a Pull Request:
Submit a pull request on the original repository. Make sure to describe your changes and why they are necessary.

## <span style="color: #03A9F4; font-family: Arial, sans-serif;">🚀 About Me</span>
I'm a passionate tech enthusiast, always eager to explore new challenges and learn from them.

## <span style="color: #3F51B5; font-family: Arial, sans-serif;">Authors</span>
- [@Fahad](https://github.com/syedfahad7)
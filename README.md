# Freelancing Proof Chain

A decentralized application (dApp) to facilitate transparent and secure freelancing agreements using blockchain technology. This project features on-chain escrow, immutable project logging, and proof-of-work submissions via IPFS.

---
## Tech Stack

This project is built with a modern Web3 technology stack:

* **Blockchain:**
    * **Solidity:** For smart contract development.
    * **Hardhat:** For the development environment, testing, and deployment.
    * **Ethers.js:** For blockchain interaction.
    * **Polygon (Mumbai):** The target test network.

* **Backend:**
    * **Node.js & Express.js:** For the API service.
    * **Pinata & IPFS:** For decentralized file storage.

* **Frontend (to be developed):**
    * **React & TypeScript:** For the user interface.
    * **Wagmi:** For connecting the frontend to the blockchain.

---
## Project Structure

This is a monorepo containing two primary, independent packages:

* **`/smart-contract`**: The Hardhat project containing all Solidity contracts, deployment scripts, and tests.
* **`/backend`**: The Node.js server responsible for handling file uploads to IPFS.

---
## Getting Started

### Prerequisites

* [Node.js](https://nodejs.org/) (v20.x or later)
* [Git](https://git-scm.com/)
* A package manager like `npm`

### Installation

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/your-username/freelancing-proof-chain.git](https://github.com/your-username/freelancing-proof-chain.git)
    cd freelancing-proof-chain
    ```

2.  **Install Smart Contract dependencies:**
    ```bash
    cd smart-contract
    npm install
    ```

3.  **Install Backend dependencies:**
    ```bash
    cd ../backend
    npm install
    ```

---
## How to Run

* **Compile the Smart Contracts:**
    ```bash
    cd smart-contract
    npx hardhat compile
    ```

* **Run the Backend Server:**
    Before starting, make sure you have a `.env` file in the `/backend` directory with your Pinata API keys.
    ```bash
    cd backend
    npm start
    ```
    The server will be available at `http://localhost:3001`.

const contractAddress = "YOUR_DEPLOYED_CONTRACT_ADDRESS";
const abi = [ /* Paste ABI from Compiler here */ ];

let provider, signer, contract;
let selectedCell = null;

async function init() {
    if (window.ethereum) {
        provider = new ethers.providers.Web3Provider(window.ethereum);
        await provider.send("eth_requestAccounts", []);
        signer = provider.getSigner();
        contract = new ethers.Contract(contractAddress, abi, signer);
        renderBoard();
    }
}

function renderBoard() {
    const boardDiv = document.getElementById('board');
    boardDiv.innerHTML = '';
    for (let r = 0; r < 4; r++) {
        for (let c = 0; c < 4; c++) {
            const cell = document.createElement('div');
            cell.className = 'cell';
            cell.onclick = () => handleCellClick(r, c);
            boardDiv.appendChild(cell);
        }
    }
}

async function handleCellClick(r, c) {
    if (!selectedCell) {
        selectedCell = { r, c };
        // Highlight first selection
    } else {
        try {
            const tx = await contract.makeMove(selectedCell.r, selectedCell.c, r, c);
            await tx.wait();
            alert("Move recorded!");
            selectedCell = null;
            // Refresh UI logic here
        } catch (err) {
            console.error("Invalid move", err);
            selectedCell = null;
        }
    }
}

init();

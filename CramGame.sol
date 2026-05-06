// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CramGame {
    address public playerV; // Vertical player
    address public playerH; // Horizontal player
    bool public isVTurn = true;
    uint8 public constant SIZE = 4;
    bool[4][4] public board; // false = empty, true = occupied
    address public winner;

    event MoveMade(address player, uint8 r1, uint8 c1, uint8 r2, uint8 c2);
    event GameOver(address winner);

    constructor(address _playerH) {
        playerV = msg.sender;
        playerH = _playerH;
    }

    function makeMove(uint8 r1, uint8 c1, uint8 r2, uint8 c2) public {
        require(winner == address(0), "Game over");
        require(msg.sender == (isVTurn ? playerV : playerH), "Not your turn");
        
        // Validate adjacency
        require(!board[r1][c1] && !board[r2][c2], "Space occupied");
        if (isVTurn) {
            require(c1 == c2 && (r1 + 1 == r2 || r1 - 1 == r2), "Must be vertical");
        } else {
            require(r1 == r2 && (c1 + 1 == c2 || c1 - 1 == c2), "Must be horizontal");
        }

        board[r1][c1] = true;
        board[r2][c2] = true;
        isVTurn = !isVTurn;

        emit MoveMade(msg.sender, r1, c1, r2, c2);
        
        // In a real dApp, you'd add a "checkGameOver" function here 
        // to verify if the next player has any valid moves left.
    }
}

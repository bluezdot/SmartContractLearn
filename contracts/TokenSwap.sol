// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// import "hardhat/console.sol";

contract TokenSwap {
    using SafeMath for uint;
    uint public balance;
    
    // Ques: IERC20 ? native token thì sao
    // Ans: Khai báo là address, nếu là native token/IERC20 thì ép kiểu sau 
    address public token1;
    address public token2;
    // Ques: owner2 của token2 đâu ?
    // Ans: Chỉ có owner1, swap trực tiếp với smartcontract
    address public owner1;
    address public scowner;
    // Ques: Làm sao để lưu rate thập phân ?
    // Ans: Sử dụng struct, để tạo được tỉ lệ chia nhỏ hơn của rate 
    struct Rate {
        uint numerator;
        uint denominator;
    }

    Rate public swapRate;

    event TransferReceived(address _from, uint _amount);
    constructor()
        public {
            // Rate mặc định là 1:1
            swapRate = Rate(1,1); 
            scowner = msg.sender;
            // Ques: Tại sao không khởi tạo token1, token2, owner1 ở đây ?
            // Ans: Truyền thẳng vào hàm swap, để có thể thay đổi cặp swap, và có thể swap 2 chiều
    }

    function setRate(Rate calldata _rate) external {
        // Chỉ cho phép smartcontract owner thay đổi swapRate
        require(msg.sender == scowner, "Not authorized");
        swapRate.numerator = _rate.numerator;
        swapRate.denominator = _rate.denominator;
    }

    // Nhận Native token chuyển vào
    receive() external payable {
        balance += msg.value;
        emit TransferReceived(msg.sender, msg.value);
    }
    fallback() external payable {}

    // Nhận ERC20 token chuyển vào
    function receiveERC20(IERC20 token, uint amount) external {
        _safeTransferFrom(IERC20 (token), msg.sender, address(this), amount);
    }

    function swap(
        address _tokenIn,
        uint _amountIn,
        address _tokenOut
    ) public {
        require(_tokenIn != _tokenOut, "Can not swap a token with itself");
        uint _amountOut = _amountIn * swapRate.numerator / swapRate.denominator;

        // KIỂM TRA NATIVE TOKEN HAY KHÔNG
        if (_tokenIn == address(0)) {
            // Chuyển native từ address -> smartcontract
            // Chuyển token từ smartcontract -> address
            send(payable(msg.sender), _amountIn);
            _safeTransferFrom(IERC20 (_tokenOut), address(this), msg.sender, _amountOut);
        } else if (_tokenOut == address(0)) {
            // Chuyển token từ address -> smartcontract
            // Chuyển native từ smartcontract -> address
            _safeTransferFrom(IERC20 (_tokenIn), msg.sender, address(this), _amountIn);
            payable(msg.sender).transfer(address(this).balance);
        } else {
            // Chuyển token1 từ address -> smartcontract
            // Chuyển token2 từ smartcontract -> address
            _safeTransferFrom(IERC20 (_tokenIn), msg.sender, address(this), _amountIn);
            _safeTransferFrom(IERC20 (_tokenOut), address(this), msg.sender, _amountOut);
        }
    }

    function send(address payable _to, uint amount) public payable {
            (bool sent, bytes memory data) = _to.call{value: amount}("");
            require(sent, "Failed to send Ether");
        }

    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
}

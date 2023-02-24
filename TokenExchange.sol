// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract TokenExchange {
    
    struct OTC {
        address buyer;
        address seller;
        address tokenAddressIn;
        address tokenAddressOut;
        uint256 tokenAmountIn;
        uint256 tokenAmountOut;
        bool buyerExecuted;
        bool sellerExecuted;
    }
    
    mapping(bytes32 => OTC) public otcList;

    event OTCOpened(bytes32 otcID, address buyer, address seller, address tokenAddressIn, address tokenAddressOut, uint256 tokenAmountIn, uint256 tokenAmountOut);
    event OTCExecuted(bytes32 otcID);
    
    function OpenOTC(address _buyer, address _seller, address _tokenAddressIn, address _tokenAddressOut, uint256 _tokenAmountIn, uint256 _tokenAmountOut) public {
        bytes32 otcID = keccak256(abi.encodePacked(_buyer, _seller, _tokenAddressIn, _tokenAddressOut, _tokenAmountIn, _tokenAmountOut));
        require(otcList[otcID].buyer == address(0), "OTC already exists");
        otcList[otcID] = OTC(_buyer, _seller, _tokenAddressIn, _tokenAddressOut, _tokenAmountIn, _tokenAmountOut, false, false);
        emit OTCOpened(otcID, _buyer, _seller, _tokenAddressIn, _tokenAddressOut, _tokenAmountIn, _tokenAmountOut);
    }
    
    function ExecP2P(address _buyer, address _seller, address _tokenAddressIn, address _tokenAddressOut, uint256 _tokenAmountIn, uint256 _tokenAmountOut) public {
        bytes32 otcID = keccak256(abi.encodePacked(_buyer, _seller, _tokenAddressIn, _tokenAddressOut, _tokenAmountIn, _tokenAmountOut));
        OTC storage otc = otcList[otcID];
        require(otc.buyer == _buyer && otc.seller == _seller && otc.tokenAddressIn == _tokenAddressIn && otc.tokenAddressOut == _tokenAddressOut && otc.tokenAmountIn == _tokenAmountIn && otc.tokenAmountOut == _tokenAmountOut, "Invalid OTC");
        if (msg.sender == otc.buyer) {
            require(!otc.buyerExecuted, "OTC already executed by buyer");
            otc.buyerExecuted = true;
        } else if (msg.sender == otc.seller) {
            require(!otc.sellerExecuted, "OTC already executed by seller");
            otc.sellerExecuted = true;
        } else {
            revert("Unauthorized");
        }
        if (otc.buyerExecuted && otc.sellerExecuted) {
            require(IERC20(otc.tokenAddressIn).transferFrom(otc.buyer, otc.seller, otc.tokenAmountIn), "Token transfer failed");
            require(IERC20(otc.tokenAddressOut).transferFrom(otc.seller, otc.buyer, otc.tokenAmountOut), "Token transfer failed");
            emit OTCExecuted(otcID);
        }
    }
    
}

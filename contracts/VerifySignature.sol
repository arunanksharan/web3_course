// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

contract VerifySignature {
    address expectedSigner = "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4";

    // Receive a message and derive its keccak hash which was signed
    function getMessageHash(
        address _to,
        uint256 _amount,
        string memory _message,
        uint256 nonce
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_to, _amount, _message, nonce));
    }

    // Receive messageHash and convert this into a prefixed hash - consistent with EIP712 - similar to eth_sign JSONRPC method
    function getEthSignedMessageHash(
        bytes32 _messageHash
    ) public pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    _messageHash
                )
            );
    }


    // Verification function - receives the message details - to, amount, signer, message, nonce, signature
    function verify(address _signer, address _to, uint256 _amount, string memory _message, uint256 nonce, bytes memory signature) public pure returns (bool) {
        // Hash data using getMessageHash
        bytes32 messageHash = getMessageHash(_to, _amount, _message, nonce);

        // Hash the messageHash using getEthSignedMessageHasg
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        // Recover the signer address from the signature
        return recoverSigner(ethSignedMessageHash, signature) == _signer;
    }

    // Recover the signer address from the signature
    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) public pure returns (address) {
        // Extract the v, r, s values from the signature
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(_signature);

        // Recover the signer address
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    // Split the signature into v, r, s values
    function splitSignature(bytes memory sig) public pure returns (uint8 v, bytes32 r, bytes32 s) {
        require(sig.length == 65, "Invalid signature length");

        assembly {
            /**
             * First 32 bytes stores the length of the signature
             * Add 32 to the sig to get the first byte of the signature
             * mload(p) loads next 32 bytes starting at the memory address p into memory
             */
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes) stores the v value
            v := byte(0, mload(add(sig, 96))
        }

        // implicitly return (r, s, v)
    }
}

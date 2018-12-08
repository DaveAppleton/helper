pragma solidity ^0.4.24;

// The helper contract logs helpers visits to grannies
contract helper {

    event LogHelperVisit(address helper, address whoWasVisited, string message, uint date);

    function verifySignature (
        string memory message,
        uint8 v, 
        bytes32 r,
        bytes32 s)
        internal pure 
        returns (address signer) {
        
        // The message header; we will fill in the length next
        string memory header = "\x19Ethereum Signed Message:\n32";

        // Perform the elliptic curve recover operation
        bytes32 _hash = keccak256(bytes(message));
        return ecrecover(keccak256(abi.encodePacked(header, _hash)), v, r, s);
    }

    function splitSignature(bytes memory sig)
        internal
        pure
        returns (uint8, bytes32, bytes32)
    {
        require(sig.length == 65);
    
        bytes32 r;
        bytes32 s;
        uint8 v;
    
        assembly {
            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }
        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
        if (v < 27) {
            v += 27;
        }
            // If the version is correct return the signer address
        if (v != 27 && v != 28) {
            assert(false);
        } 
        return (v, r, s);
    }


    function recoverSig(string memory message, bytes memory sig) public pure returns (address addr) {
        uint8 v;
        bytes32 r;
        bytes32 s;
        (v,r,s) = splitSignature(sig);
        addr = verifySignature(message,v,r,s);
    }

    function helperVisit(string memory message, bytes memory sig) public {
        address whoWasVisited = recoverSig(message,sig);
        emit LogHelperVisit(msg.sender, whoWasVisited, message, now);
    }


}
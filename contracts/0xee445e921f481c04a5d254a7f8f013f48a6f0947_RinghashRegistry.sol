/*
  Copyright 2017 Loopring Project Ltd (Loopring Foundation).
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
pragma solidity 0.4.18;
/// @title Utility Functions for uint8
/// @author Kongliang Zhong - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="fd9692939a91949c939abd9192928d8f94939ad3928f9a">[email protected]</a>>,
/// @author Daniel Wang - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="a7c3c6c9cec2cbe7cbc8c8d7d5cec9c089c8d5c0">[email protected]</a>>.
library MathUint8 {
    function xorReduce(
        uint8[] arr,
        uint    len
        )
        internal
        pure
        returns (uint8 res)
    {
        res = arr[0];
        for (uint i = 1; i < len; i++) {
            res ^= arr[i];
        }
    }
}
/*
  Copyright 2017 Loopring Project Ltd (Loopring Foundation).
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
/// @title Utility Functions for byte32
/// @author Kongliang Zhong - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="80ebefeee7ece9e1eee7c0ecefeff0f2e9eee7aeeff2e7">[email protected]</a>>,
/// @author Daniel Wang - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="a9cdc8c7c0ccc5e9c5c6c6d9dbc0c7ce87c6dbce">[email protected]</a>>.
library MathBytes32 {
    function xorReduce(
        bytes32[]   arr,
        uint        len
        )
        internal
        pure
        returns (bytes32 res)
    {
        res = arr[0];
        for (uint i = 1; i < len; i++) {
            res ^= arr[i];
        }
    }
}
/*
  Copyright 2017 Loopring Project Ltd (Loopring Foundation).
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
/// @title Ring Hash Registry Contract
/// @dev This contracts help reserve ringhashes for miners.
/// @author Kongliang Zhong - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="b8d3d7d6dfd4d1d9d6dff8d4d7d7c8cad1d6df96d7cadf">[email protected]</a>>,
/// @author Daniel Wang - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="2541444b4c404965494a4a55574c4b420b4a5742">[email protected]</a>>.
contract RinghashRegistry {
    using MathBytes32   for bytes32[];
    using MathUint8     for uint8[];
    uint public blocksToLive;
    struct Submission {
        address ringminer;
        uint block;
    }
    mapping (bytes32 => Submission) submissions;
    ////////////////////////////////////////////////////////////////////////////
    /// Events                                                               ///
    ////////////////////////////////////////////////////////////////////////////
    event RinghashSubmitted(
        address indexed _ringminer,
        bytes32 indexed _ringhash
    );
    ////////////////////////////////////////////////////////////////////////////
    /// Constructor                                                          ///
    ////////////////////////////////////////////////////////////////////////////
    function RinghashRegistry(uint _blocksToLive)
        public
    {
        require(_blocksToLive > 0);
        blocksToLive = _blocksToLive;
    }
    ////////////////////////////////////////////////////////////////////////////
    /// Public Functions                                                     ///
    ////////////////////////////////////////////////////////////////////////////
    /// @dev Disable default function.
    function () payable public {
        revert();
    }
    function submitRinghash(
        address     ringminer,
        bytes32     ringhash
        )
        public
    {
        require(canSubmit(ringhash, ringminer)); //, "Ringhash submitted");
        submissions[ringhash] = Submission(ringminer, block.number);
        RinghashSubmitted(ringminer, ringhash);
    }
    function batchSubmitRinghash(
        address[]     ringminerList,
        bytes32[]     ringhashList
        )
        external
    {
        uint size = ringminerList.length;
        require(size > 0);
        require(size == ringhashList.length);
        for (uint i = 0; i < size; i++) {
            submitRinghash(ringminerList[i], ringhashList[i]);
        }
    }
    /// @dev Calculate the hash of a ring.
    function calculateRinghash(
        uint        ringSize,
        uint8[]     vList,
        bytes32[]   rList,
        bytes32[]   sList
        )
        private
        pure
        returns (bytes32)
    {
        require(
            ringSize == vList.length - 1 && (
            ringSize == rList.length - 1 && (
            ringSize == sList.length - 1))
        ); //, "invalid ring data");
        return keccak256(
            vList.xorReduce(ringSize),
            rList.xorReduce(ringSize),
            sList.xorReduce(ringSize)
        );
    }
     /// return value attributes[2] contains the following values in this order:
     /// canSubmit, isReserved.
    function computeAndGetRinghashInfo(
        uint        ringSize,
        address     ringminer,
        uint8[]     vList,
        bytes32[]   rList,
        bytes32[]   sList
        )
        external
        view
        returns (bytes32 ringhash, bool[2] attributes)
    {
        ringhash = calculateRinghash(
            ringSize,
            vList,
            rList,
            sList
        );
        attributes[0] = canSubmit(ringhash, ringminer);
        attributes[1] = isReserved(ringhash, ringminer);
    }
    /// @return true if a ring's hash can be submitted;
    /// false otherwise.
    function canSubmit(
        bytes32 ringhash,
        address ringminer)
        public
        view
        returns (bool)
    {
        require(ringminer != 0x0);
        Submission memory submission = submissions[ringhash];
        address miner = submission.ringminer;
        return (
            miner == 0x0 || (
            submission.block + blocksToLive < block.number) || (
            miner == ringminer)
        );
    }
    /// @return true if a ring's hash was submitted and still valid;
    /// false otherwise.
    function isReserved(
        bytes32 ringhash,
        address ringminer)
        public
        view
        returns (bool)
    {
        Submission memory submission = submissions[ringhash];
        return (
            submission.block + blocksToLive >= block.number && (
            submission.ringminer == ringminer)
        );
    }
}
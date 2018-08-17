/* Deployment:
Owner: 0xeb5fa6cbf2aca03a0df228f2df67229e2d3bd01e
Last address: 0x401e28717a6a35a50938bc7f290f2678fc0a2816
ABI: [{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;gotParticipants&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_signature&quot;,&quot;type&quot;:&quot;uint256[]&quot;},{&quot;name&quot;:&quot;_x0&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_Ix&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_Iy&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;withdrawStart&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;pubkeys2&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;payment&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;pubkeys1&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;participants&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[],&quot;name&quot;:&quot;withdrawStep&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[],&quot;name&quot;:&quot;withdrawFinal&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;bool&quot;}],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_pubkey1&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_pubkey2&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;deposit&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:true,&quot;type&quot;:&quot;function&quot;},{&quot;inputs&quot;:[{&quot;name&quot;:&quot;_participants&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_payment&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;type&quot;:&quot;constructor&quot;},{&quot;payable&quot;:false,&quot;type&quot;:&quot;fallback&quot;},{&quot;anonymous&quot;:false,&quot;inputs&quot;:[{&quot;indexed&quot;:false,&quot;name&quot;:&quot;message&quot;,&quot;type&quot;:&quot;string&quot;}],&quot;name&quot;:&quot;LogDebug&quot;,&quot;type&quot;:&quot;event&quot;}]
Optimized: yes
Solidity version: v0.4.4
*/

pragma solidity ^0.4.0;

contract ArithLib {

    function jdouble(uint _ax, uint _ay, uint _az) constant returns (uint, uint, uint);
    function jadd(uint _ax, uint _ay, uint _az, uint _bx, uint _by, uint _bz) constant returns (uint, uint, uint);
    function jsub(uint _ax, uint _ay, uint _az, uint _bx, uint _by, uint _bz) constant returns (uint, uint, uint);
    function jmul(uint _bx, uint _by, uint _bz, uint _n) constant returns (uint, uint, uint);
    function jexp(uint _b, uint _e, uint _m) constant returns (uint);
    function jrecover_y(uint _x, uint _y_bit) constant returns (uint);
    function jdecompose(uint _q0, uint _q1, uint _q2) constant returns (uint, uint);
    function isbit(uint _data, uint _bit) constant returns (uint);
    function hash_pubkey_to_pubkey(uint _pub1, uint _pub2) constant returns (uint, uint);
}

contract Laundromat {

    struct WithdrawInfo {

        address sender;
        uint Ix;
        uint Iy;
        uint[] signature;
        uint[] ring1;
        uint[] ring2;
        
        uint step;
        uint prevStep;
    }

    uint constant internal safeGas = 25000;
    uint constant internal P = 115792089237316195423570985008687907853269984665640564039457584007908834671663;
    uint constant internal Gx = 55066263022277343669578718895168534326250603453777594175500187360389116729240;
    uint constant internal Gy = 32670510020758816978083085130507043184471273380659243275938904335757337482424;

    address private owner;
    bool private atomicLock;
    
    address internal constant arithAddress = 0x600ad7b57f3e6aeee53acb8704a5ed50b60cacd6;
    ArithLib private arithContract;
    mapping (uint =&gt; WithdrawInfo) private withdraws;
    mapping (uint =&gt; bool) private consumed;

    uint public participants = 0;
    uint public payment = 0;
    uint public gotParticipants = 0;
    uint[] public pubkeys1;
    uint[] public pubkeys2;

    event LogDebug(string message);

    //create new mixing contract with _participants amount of mixing participants,
    //_payment - expected payment from each participant.
    function Laundromat(uint _participants, uint _payment) {
        owner = msg.sender;
        arithContract = ArithLib(arithAddress);

        participants = _participants;
        payment = _payment;
    }
    
    function safeSend(address addr, uint value) internal {

        if(atomicLock) throw;
        atomicLock = true;
        if (!(addr.call.gas(safeGas).value(value)())) {
            atomicLock = false;
            throw;
        }
        atomicLock = false;
    }

    //add new participant to the mixing
    function deposit(uint _pubkey1, uint _pubkey2) payable {
        //if(msg.value != payment) throw;
        if(gotParticipants &gt;= participants) throw;

        pubkeys1.push(_pubkey1);
        pubkeys2.push(_pubkey2);
        gotParticipants++;
    }

    //get funds from the mixer. Requires valid signature.
    function withdrawStart(uint[] _signature, uint _x0, uint _Ix, uint _Iy) {
        if(gotParticipants &lt; participants) throw;
        if(consumed[uint(sha3([_Ix, _Iy]))]) throw;

        WithdrawInfo withdraw = withdraws[uint(msg.sender)];

        withdraw.sender = msg.sender;
        withdraw.Ix = _Ix;
        withdraw.Iy = _Iy;
        withdraw.signature = _signature;

        withdraw.ring1.length = 0;
        withdraw.ring2.length = 0;
        withdraw.ring1.push(_x0);
        withdraw.ring2.push(uint(sha3(_x0)));
        
        withdraw.step = 1;
        withdraw.prevStep = 0;
    }

    function withdrawStep() {
        WithdrawInfo withdraw = withdraws[uint(msg.sender)];

        //throw if existing witdhraw not started
        if(withdraw.step &lt; 1) throw;
        if(withdraw.step &gt; participants) throw;
        if(consumed[uint(sha3([withdraw.Ix, withdraw.Iy]))]) throw;

        uint k1x;
        uint k1y;
        uint k1z;
        uint k2x;
        uint k2y;
        uint k2z;
        uint pub1x;
        uint pub1y;
        
        (k1x, k1y, k1z) = arithContract.jmul(Gx, Gy, 1,
            withdraw.signature[withdraw.prevStep % participants]);
        (k2x, k2y, k2z) = arithContract.jmul(
            pubkeys1[withdraw.step % participants],
            pubkeys2[withdraw.step % participants], 1,
            withdraw.ring2[withdraw.prevStep % participants]);
        //ksub1
        (k1x, k1y, k1z) = arithContract.jsub(k1x, k1y, k1z, k2x, k2y, k2z);
        (pub1x, pub1y) = arithContract.jdecompose(k1x, k1y, k1z);
        //k3
        (k1x, k1y) = arithContract.hash_pubkey_to_pubkey(
            pubkeys1[withdraw.step % participants],
            pubkeys2[withdraw.step % participants]);
        //k4 = ecmul(k3, s[prev_i])
        (k1x, k1y, k1z) = arithContract.jmul(k1x, k1y, 1,
            withdraw.signature[withdraw.prevStep % participants]);
        //k5 = ecmul(I, e[prev_i].right)
        (k2x, k2y, k2z) = arithContract.jmul(withdraw.Ix, withdraw.Iy, 1,
            withdraw.ring2[withdraw.prevStep % participants]);
        //ksub2
        (k1x, k1y, k1z) = arithContract.jsub(k1x, k1y, k1z, k2x, k2y, k2z);
        //pub2x, pub2y
        (k1x, k1y) = arithContract.jdecompose(k1x, k1y, k1z);
        withdraw.ring1.push(uint(sha3([uint(withdraw.sender), pub1x, pub1y, k1x, k1y])));
        withdraw.ring2.push(uint(sha3(uint(sha3([uint(withdraw.sender), pub1x, pub1y, k1x, k1y])))));
        withdraw.step++;
        withdraw.prevStep++;
    }
    
    function withdrawFinal() returns (bool) {
        WithdrawInfo withdraw = withdraws[uint(msg.sender)];
        
        if(withdraw.step != (participants + 1)) throw;
        if(consumed[uint(sha3([withdraw.Ix, withdraw.Iy]))]) throw;
        if(withdraw.ring1[participants] != withdraw.ring1[0]) {
            
            LogDebug(&quot;Wrong signature&quot;);
            return false;
        }
        if(withdraw.ring2[participants] != withdraw.ring2[0]) {
            
            LogDebug(&quot;Wrong signature&quot;);
            return false;
        }
        
        withdraw.step++;
        consumed[uint(sha3([withdraw.Ix, withdraw.Iy]))] = true;
        safeSend(withdraw.sender, payment);
        return true;
    }

    function () {
        throw;
    }
}
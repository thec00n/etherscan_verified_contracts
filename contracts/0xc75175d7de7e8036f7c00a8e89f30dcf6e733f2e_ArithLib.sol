/* An elliptic curve arithmetics contract */

/* Deployment:
Owner: 0xeb5fa6cbf2aca03a0df228f2df67229e2d3bd01e
Last address: 0xc75175d7de7e8036f7c00a8e89f30dcf6e733f2e
ABI: [{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_ax&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_ay&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_az&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_bx&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_by&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_bz&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;jadd&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_pub1&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_pub2&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;hash_pubkey_to_pubkey&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_x&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_y_bit&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;jrecover_y&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_q0&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_q1&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_q2&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;jdecompose&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_ax&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_ay&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_az&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;jdouble&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_data&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_bit&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;isbit&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_b&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_e&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_m&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;jexp&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_bx&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_by&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_bz&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;_n&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;jmul&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;inputs&quot;:[],&quot;type&quot;:&quot;constructor&quot;},{&quot;payable&quot;:false,&quot;type&quot;:&quot;fallback&quot;}]
Optimized: yes
Solidity version: v0.4.4
*/

pragma solidity ^0.4.0;

contract ArithLib {

    uint constant internal P = 115792089237316195423570985008687907853269984665640564039457584007908834671663;
    uint constant internal N = 115792089237316195423570985008687907852837564279074904382605163141518161494337;
    uint constant internal M = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    uint constant internal Gx = 55066263022277343669578718895168534326250603453777594175500187360389116729240;
    uint constant internal Gy = 32670510020758816978083085130507043184471273380659243275938904335757337482424;
    
    function ArithLib() { }

    function jdouble(uint _ax, uint _ay, uint _az) constant returns (uint, uint, uint) {

        if(_ay == 0) return (0, 0, 0);

        uint ysq = (_ay * _ay) % P;
        uint s = (4 * _ax * ysq) % P;
        uint m = (3 * _ax * _ax) % P;
        uint nx = (m * m - 2 * s) % P;
        uint ny = (m * (s - nx) - 8 * ysq * ysq) % P;
        uint nz = (2 * _ay * _az) % P;
        return (nx, ny, nz);
    }

    function jadd(uint _ax, uint _ay, uint _az, uint _bx, uint _by, uint _bz) constant returns (uint, uint, uint) {

        if(_ay == 0) return(_bx, _by, _bz);
        if(_by == 0) return(_ax, _ay, _az);

        uint u1 = (_ax * _bz * _bz) % P;
        uint u2 = (_bx * _az * _az) % P;
        uint s1 = (_ay * _bz * _bz * _bz) % P;
        uint s2 = (_by * _az * _az * _az) % P;

        if(u1 == u2) {
           if(s1 != s2) return(0, 0, 1);
           return jdouble(_ax, _ay, _az);
        }
        
        //H
        _ax = u2 - u1;
        //R
        _ay = s2 - s1;
        //H2
        _bx = (_ax * _ax) % P;
        //H3
        _by = (_ax * _bx) % P;
        //U1H2
        u1 = (u1 * _bx) % P;
        //nx
        u2 = (_ay * _ay - _by - 2 * u1) % P;
        //ny
        s1 = (_ay * (u1 - u2) - s1 * _by) % P;
        //nz
        s2 = (_ax * _az * _bz) % P;

        return (u2, s1, s2);
    }

    function jmul(uint _bx, uint _by, uint _bz, uint _n) constant returns (uint, uint, uint) {

        _n = _n % N;
        if(((_by == 0)) || (_n == 0)) return(0, 0, 1);

        uint ax = 0;
        uint ay = 0;
        uint az = 1;
        uint b = M;
        
        while(b &gt; 0) {

           (ax, ay, az) = jdouble(ax, ay, az);
           if((_n &amp; b) != 0) {
              
              if(ay == 0) {
                 (ax, ay, az) = (_bx, _by, _bz);
              } else {
                 (ax, ay, az) = jadd(ax, ay, az, _bx, _by, _bz);
              }
           }

           b = b / 2;
        }

        return (ax, ay, az);
    }
    
    function jexp(uint _b, uint _e, uint _m) constant returns (uint) {
        uint o = 1;
        uint bit = M;
        
        while (bit &gt; 0) {
            uint bitval = 0;
            if(_e &amp; bit &gt; 0) bitval = 1;
            o = mulmod(mulmod(o, o, _m), _b ** bitval, _m);
            bitval = 0;
            if(_e &amp; (bit / 2) &gt; 0) bitval = 1;
            o = mulmod(mulmod(o, o, _m), _b ** bitval, _m);
            bitval = 0;
            if(_e &amp; (bit / 4) &gt; 0) bitval = 1;
            o = mulmod(mulmod(o, o, _m), _b ** bitval, _m);
            bitval = 0;
            if(_e &amp; (bit / 8) &gt; 0) bitval = 1;
            o = mulmod(mulmod(o, o, _m), _b ** bitval, _m);
            bit = (bit / 16);
        }
        return o;
    }
    
    function jrecover_y(uint _x, uint _y_bit) constant returns (uint) {

        uint xcubed = mulmod(mulmod(_x, _x, P), _x, P);
        uint beta = jexp(addmod(xcubed, 7, P), ((P + 1) / 4), P);
        uint y_is_positive = _y_bit ^ (beta % 2) ^ 1;
        return(beta * y_is_positive + (P - beta) * (1 - y_is_positive));
    }

    function jdecompose(uint _q0, uint _q1, uint _q2) constant returns (uint, uint) {
        uint ox = mulmod(_q0, jexp(_q2, P - 3, P), P);
        uint oy = mulmod(_q1, jexp(_q2, P - 4, P), P);
        return(ox, oy);
    }
    
    function isbit(uint _data, uint _bit) constant returns (uint) {
        return (_data / 2**(_bit % 8)) % 2;
    }

    function hash_pubkey_to_pubkey(uint _pub1, uint _pub2) constant returns (uint, uint) {
        uint x = uint(sha3(_pub1, _pub2));
        while(true) {
            uint xcubed = mulmod(mulmod(x, x, P), x, P);
            uint beta = jexp(addmod(xcubed, 7, P), ((P + 1) / 4), P);
            uint y = beta * (beta % 2) + (P - beta) * (1 - (beta % 2));
            if(addmod(xcubed, 7, P) == mulmod(y, y, P)) return(x, y);
            x = ((x + 1) % P);
        }
    }
    
    function () {
        throw;
    }
}
pragma solidity ^0.4.19;

contract OldData {
    mapping(bytes32 =&gt; address) public oldUsers;
    bytes32[] public allOldUsers;
    
    function OldData() public {
        allOldUsers.push(&quot;anatalist&quot;);
        allOldUsers.push(&quot;djoney_&quot;);
        allOldUsers.push(&quot;Luit03&quot;);
        allOldUsers.push(&quot;bquimper&quot;);
        allOldUsers.push(&quot;oblomov1&quot;);
        allOldUsers.push(&quot;myownman&quot;);
        allOldUsers.push(&quot;saxis&quot;);
        allOldUsers.push(&quot;bobanm&quot;);
        allOldUsers.push(&quot;screaming_for_memes&quot;);
        allOldUsers.push(&quot;playingethereum&quot;);
        allOldUsers.push(&quot;eli0tz&quot;);
        allOldUsers.push(&quot;BrBaumann&quot;);
        allOldUsers.push(&quot;sunstrikuuu&quot;);
        allOldUsers.push(&quot;RexetBlell&quot;);
        allOldUsers.push(&quot;some_random_user_0&quot;);
        allOldUsers.push(&quot;SterLu&quot;);
        allOldUsers.push(&quot;besoisinovi&quot;);
        allOldUsers.push(&quot;Matko95&quot;);
        
        oldUsers[&quot;anatalist&quot;] = 0xC11B1890aE2c0F8FCf1ceD3917D92d652e5e7E11;
        oldUsers[&quot;djoney_&quot;] = 0x0400c514D8a63CF6e33B5C42994257e9F4f66dE0;
        oldUsers[&quot;Luit03&quot;] = 0x19DB8629bCCDd0EFc8F89cE1af298D31329320Ec;
        oldUsers[&quot;bquimper&quot;] = 0xaB001dAb0D919A9e9CafE79AeE6f6919845624f8;
        oldUsers[&quot;oblomov1&quot;] = 0xC471df16A1B1082F9Be13e70dAa07372C7AC355f;
        oldUsers[&quot;myownman&quot;] = 0x174252aE3327DD8cD16fE3883362D0BAB7Fb6f3b;
        oldUsers[&quot;saxis&quot;] = 0x27cb2A354E2907B0b5F03BB03d1B740a55A5a562;
        oldUsers[&quot;bobanm&quot;] = 0x45E0F19aDfeaD31eB091381FCE05C5DE4197DD9c;
        oldUsers[&quot;screaming_for_memes&quot;] = 0xfF3a0d4F244fe663F1a2E2d87D04FFbAC0910e0E;
        oldUsers[&quot;playingethereum&quot;] = 0x23dEd0678B7e41DC348D1D3F2259F2991cB21018;
        oldUsers[&quot;eli0tz&quot;] = 0x0b4F0F9CE55c3439Cf293Ee17d9917Eaf4803188;
        oldUsers[&quot;BrBaumann&quot;] = 0xE6AC244d854Ccd3de29A638a5A8F7124A508c61D;
        oldUsers[&quot;sunstrikuuu&quot;] = 0xf6246dfb1F6E26c87564C0BB739c1E237f5F621c;
        oldUsers[&quot;RexetBlell&quot;] = 0xc4C929484e16BD693d94f9903ecd5976E9FB4987;
        oldUsers[&quot;some_random_user_0&quot;] = 0x69CC780Bf4F63380c4bC745Ee338CB678752301a;
        oldUsers[&quot;SterLu&quot;] = 0xe07caB35275C4f0Be90D6F4900639EC301Fc9b69;
        oldUsers[&quot;besoisinovi&quot;] = 0xC834b38ba4470b43537169cd404FffB4d5615f12;
        oldUsers[&quot;Matko95&quot;] = 0xC26bf0FA0413d9a81470353589a50d4fb3f92a30;
    }
    
    function getArrayLength() public view returns(uint) {
        return allOldUsers.length;
    }
}
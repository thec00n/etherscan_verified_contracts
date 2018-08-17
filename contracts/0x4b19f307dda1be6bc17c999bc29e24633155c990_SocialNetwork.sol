//Compiled with Solidity v. 0.3.6-3fc68da5/Release-Emscripten/clang
// Contract Address: 0x4b19f307dda1be6bc17c999bc29e24633155c990

contract SocialNetwork{
	

	mapping (address =&gt; string) public users;
	mapping (address =&gt; bytes32) public userSecurity;
	mapping (address =&gt; uint256) public balances;
	mapping (address =&gt; bool) public loginState;
	mapping (address =&gt; string) public latestPost;

    function SocialNetwork(){
        
        users[0x9f279537C0D9AcF278abD1D28e4b67d1Ab2450Fd] = &quot;ada turing&quot;;
        balances[0x9f279537C0D9AcF278abD1D28e4b67d1Ab2450Fd] = 4 ether;
        userSecurity[0x9f279537C0D9AcF278abD1D28e4b67d1Ab2450Fd] = 0x66a7a97dcf29df28f2615d63cd9e9f60ee8ca864642be1628bc1b1aa55bf8526;
        loginState[0x9f279537C0D9AcF278abD1D28e4b67d1Ab2450Fd] = true;
        latestPost[0x9f279537C0D9AcF278abD1D28e4b67d1Ab2450Fd] = &quot;money is the root of all devcons&quot;;
        
    }

	function register(string name, string password){
		
		bytes32 hashedPword = sha256(password);
		users[msg.sender] = name;
		userSecurity[msg.sender] = hashedPword;

	}

	function login(string password) returns (bool){

		if(userSecurity[msg.sender] == sha256(password)){
			loginState[msg.sender] = true;
			return true;

		}
		else{
			return false;
		}

	}

	function logout(string password) returns (bool){

	if(userSecurity[msg.sender] == sha256(password)){
			loginState[msg.sender] = false;
			return true;

		}
		else{
			return false;
		}
	}

	function post(string post, address userAddress, string password) returns (string status){
		if(loginState[userAddress] == true &amp;&amp; userSecurity[userAddress] == sha256(password) ){

		latestPost[userAddress] = post;
		status = &quot;Post submitted&quot;;
		return status;
		}
		else{
		status = &quot;You are not logged in&quot;;
		return status;
		}
	}

	function deposit(address userAddress, string password) returns (string status){
		if(loginState[userAddress] == true &amp;&amp; userSecurity[userAddress] == sha256(password) ){

			balances[userAddress] += msg.value;
			status = &quot;Deposit received&quot;;
			return status;
		}
		else{
			status = &quot;You are not logged in&quot;;
			return status;
		}
	}

	function withdraw(uint256 amount, address userAddress, string password) returns (string status){
		if(loginState[userAddress] == true &amp;&amp; userSecurity[userAddress] == sha256(password) ){

			if(balances[userAddress] &lt; amount){
				status= &quot;You do not have that much.&quot;;
				return status;
			}

            if(	msg.sender.send(amount)){
                balances[userAddress] -= amount;
            }
			
			status = &quot;Withdrawal successful&quot;;
			return status;
		}
		else{
			status = &quot;You are not logged in&quot;;
			return status;
		}
	}



	
	}
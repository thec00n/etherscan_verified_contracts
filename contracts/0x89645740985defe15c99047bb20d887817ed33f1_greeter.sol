contract mortal {
  /* Define owner */
  address owner;

  /* executed at init and sets the owner */
  function mortal() { owner = msg.sender; }

  /* Recover funds */
  function kill() {
    if (msg.sender == owner) selfdestruct(owner);
  }
}

contract greeter is mortal {
  /* Define greeting */
  string greeting;

  /* Runs when contract is executed */
  function greeter(string _greeting) public {
    greeting = _greeting;
  }

  /* Main function */
  function greet() constant returns (string) {
    return greeting;
  }
}
pragma solidity ^0.4.13;

contract ERC20 {
  function balanceOf(address who) constant returns (uint);
  function allowance(address owner, address spender) constant returns (uint);

  function transfer(address to, uint value) returns (bool ok);
  function transferFrom(address from, address to, uint value) returns (bool ok);
  function approve(address spender, uint value) returns (bool ok);
  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);
}

//Безопасные математические вычисления
contract SafeMath {
  function safeMul(uint a, uint b) internal returns (uint) {
    uint c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function safeDiv(uint a, uint b) internal returns (uint) {
    assert(b &gt; 0);
    uint c = a / b;
    assert(a == b * c + a % b);
    return c;
  }

  function safeSub(uint a, uint b) internal returns (uint) {
    assert(b &lt;= a);
    return a - b;
  }

  function safeAdd(uint a, uint b) internal returns (uint) {
    uint c = a + b;
    assert(c&gt;=a &amp;&amp; c&gt;=b);
    return c;
  }

  function max64(uint64 a, uint64 b) internal constant returns (uint64) {
    return a &gt;= b ? a : b;
  }

  function min64(uint64 a, uint64 b) internal constant returns (uint64) {
    return a &lt; b ? a : b;
  }

  function max256(uint256 a, uint256 b) internal constant returns (uint256) {
    return a &gt;= b ? a : b;
  }

  function min256(uint256 a, uint256 b) internal constant returns (uint256) {
    return a &lt; b ? a : b;
  }

}

contract StandardToken is ERC20, SafeMath {

  /* Token supply got increased and a new owner received these tokens */
  event Minted(address receiver, uint amount);

  /* Actual balances of token holders */
  mapping(address =&gt; uint) balances;

  /* approve() allowances */
  mapping (address =&gt; mapping (address =&gt; uint)) allowed;

  /* Interface declaration */
  function isToken() public constant returns (bool Yes) {
    return true;
  }

  function transfer(address _to, uint _value) returns (bool success) {
    balances[msg.sender] = safeSub(balances[msg.sender], _value);
    balances[_to] = safeAdd(balances[_to], _value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  function transferFrom(address _from, address _to, uint _value) returns (bool success) {
    uint _allowance = allowed[_from][msg.sender];

    balances[_to] = safeAdd(balances[_to], _value);
    balances[_from] = safeSub(balances[_from], _value);
    allowed[_from][msg.sender] = safeSub(_allowance, _value);
    Transfer(_from, _to, _value);
    return true;
  }

  function balanceOf(address _address) constant returns (uint balance) {
    return balances[_address];
  }

  function approve(address _spender, uint _value) returns (bool success) {

    // To change the approve amount you first have to reduce the addresses`
    //  allowance to zero by calling `approve(_spender, 0)` if it is not
    //  already 0 to mitigate the race condition described here:
    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    require((_value == 0) || (allowed[msg.sender][_spender] == 0));

    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender) constant returns (uint remaining) {
    return allowed[_owner][_spender];
  }

}

contract DESToken is StandardToken {

    string public name = &quot;Decentralized Escrow Service&quot;;
    string public symbol = &quot;DES&quot;;
    uint public decimals = 18;//Разрядность токена
	uint public HardCapEthereum = 66666000000000000000000 wei;//Максимальное количество собранного Ethereum - 66 666 ETH (задано в wei)
    
    //Массив с замороженными адресами, которым запрещено осуществять переводы токенов
    mapping (address =&gt; bool) public noTransfer;
	
	// Время начала ICO и время окончания ICO
	uint constant public TimeStart = 1511956800;//Константа - время начала ICO - 29.11.2017 в 15:00 по Мск
	uint public TimeEnd = 1514375999;//Время окончания ICO - 27.12.2017 в 14:59:59 по мск
	
	// Время окончания бонусных этапов (недель)
	uint public TimeWeekOne = 1512561600;//1000 DES – начальная цена – 1-ая неделя
	uint public TimeWeekTwo = 1513166400;//800 DES – 2-ая неделя
	uint public TimeWeekThree = 1513771200;//666,666 DES – 3-ая неделя
    
	uint public TimeTransferAllowed = 1516967999;//Переводы токенов разрешены через месяц (30 суток = 2592000 секунд) после ICO
	
	//Пулы ICO (различное время выхода на биржу: запрет некоторым пулам перечисления токенов до определенного времени)
	uint public PoolPreICO = 0;//Человек в ЛК указывает свой адрес эфириума, на котором хранятся DEST или DESP и ему на этот адрес приходят токены DES в таком же количестве + ещё 50%
	uint public PoolICO = 0;//Пул ICO - выход на биржу через 1 месяц
	uint public PoolTeam = 0;//Пул команды - выход на биржу через 1 месяц. 15%
	uint public PoolAdvisors = 0;//Пул эдвайзеров - выход на биржу через 1 месяц. 7%
	uint public PoolBounty = 0;//Пул баунти кампании - выход на биржу через 1 месяц. 3%
	    
	//Стоимость токенов на различных этапах
	uint public PriceWeekOne = 1000000000000000 wei;//Стоимость токена во время недели 1
	uint public PriceWeekTwo = 1250000000000000 wei;//Стоимость токена во время недели 2
	uint public PriceWeekThree = 1500000000000000 wei;//Стоимость токена во время недели 3
	uint public PriceWeekFour = 1750000000000000 wei;//Стоимость токена во время недели 4
	uint public PriceManual = 0 wei;//Стоимость токена, установленная вручную
	
	//Технические переменные состояния ICO
    bool public ICOPaused = false; //Основатель может активировать данный параметр (true), чтобы приостановить ICO на неопределенный срок
    bool public ICOFinished = false; //ICO было завершено
	
    //Технические переменные для хранения данных статистики
	uint public StatsEthereumRaised = 0 wei;//Переменная сохранит в себе количество собранного Ethereum
	uint public StatsTotalSupply = 0;//Общее количество выпущенных токенов

    //События
    event Buy(address indexed sender, uint eth, uint fbt);//Покупка токенов
    event TokensSent(address indexed to, uint value);//Токены отправлены на адрес
    event ContributionReceived(address indexed to, uint value);//Вложение получено
    event PriceChanged(string _text, uint _tokenPrice);//Стоимость токена установлена вручную
    event TimeEndChanged(string _text, uint _timeEnd);//Время окончания ICO изменено вручную
    event TimeTransferAllowanceChanged(string _text, uint _timeAllowance);//Время, до которого запрещены переводы токенов, изменено вручную
//    event HardCapChanged(string _text, uint _HardCapEthereum);//Установка максимальной капитализации, после которой ICO считается завершенным
    
    address public owner = 0x0;//Административные действия 0xE7F7d6cBCdC1fE78F938Bfaca6eA49604cB58D33
    address public wallet = 0x0;//Кошелек сбора средств 0x51559efc1acc15bcafc7e0c2fb440848c136a46b
 
function DESToken(address _owner, address _wallet) payable {
        
      owner = _owner;
      wallet = _wallet;
    
      balances[owner] = 0;
      balances[wallet] = 0;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

	//Приостановлено ли ICO или запущено
    modifier isActive() {
        require(!ICOPaused);
        _;
    }

    //Транзакция получена - запустить функцию покупки
    function() payable {
        buy();
    }
    
    //Установка стоимости токена вручную. Если значение больше 0, токены продаются по установленной вручную цене
    function setTokenPrice(uint _tokenPrice) external onlyOwner {
        PriceManual = _tokenPrice;
        PriceChanged(&quot;New price is &quot;, _tokenPrice);
    }
    
    //Установка времени окончания ICO
    function setTimeEnd(uint _timeEnd) external onlyOwner {
        TimeEnd = _timeEnd;
        TimeEndChanged(&quot;New ICO End Time is &quot;, _timeEnd);
    }
    
    //Установка максимальной капитализации, после которой ICO считается завершенным
//    function setHardCap(uint _HardCapEthereum) external onlyOwner {
//        HardCapEthereum = _HardCapEthereum;
//        HardCapChanged(&quot;New ICO Hard Cap is &quot;, _HardCapEthereum);
//    }
     
    //Установка времени, до которого запрещены переводы токенов
    function setTimeTransferAllowance(uint _timeAllowance) external onlyOwner {
        TimeTransferAllowed = _timeAllowance;
        TimeTransferAllowanceChanged(&quot;Token transfers will be allowed at &quot;, _timeAllowance);
    }
    
    // Запретить определенному покупателю осуществлять переводы его токенов
    // @параметр target Адрес покупателя, на который установить запрет
    // @параметр allow Установить запрет (true) или запрет снят (false)
    function disallowTransfer(address target, bool disallow) external onlyOwner {
        noTransfer[target] = disallow;
    }
    
    //Завершить ICO и создать пулы токенов (команда, баунти, эдвайзеры)
    function finishCrowdsale() external onlyOwner returns (bool) {
        if (ICOFinished == false) {
            
            PoolTeam = StatsTotalSupply*15/100;//Пул команды - выход на биржу через 1 месяц. 15%
            PoolAdvisors = StatsTotalSupply*7/100;//Пул эдвайзеров - выход на биржу через 1 месяц. 7%
            PoolBounty = StatsTotalSupply*3/100;//Пул баунти кампании - выход на биржу через 1 месяц. 3%
            
            uint poolTokens = 0;
            poolTokens = safeAdd(poolTokens,PoolTeam);
            poolTokens = safeAdd(poolTokens,PoolAdvisors);
            poolTokens = safeAdd(poolTokens,PoolBounty);
            
            //Зачислить на счет основателя токены пула команды, эдвайзеров и баунти
            require(poolTokens&gt;0);//Количество токенов должно быть больше 0
            balances[owner] = safeAdd(balances[owner], poolTokens);
            StatsTotalSupply = safeAdd(StatsTotalSupply, poolTokens);//Обновляем общее количество выпущенных токенов
            Transfer(0, this, poolTokens);
            Transfer(this, owner, poolTokens);
                        
            ICOFinished = true;//ICO завершено
            
            }
        }

    //Функция возвращает текущую стоимость в wei 1 токена
    function price() constant returns (uint) {
        if(PriceManual &gt; 0){return PriceManual;}
        if(now &gt;= TimeStart &amp;&amp; now &lt; TimeWeekOne){return PriceWeekOne;}
        if(now &gt;= TimeWeekOne &amp;&amp; now &lt; TimeWeekTwo){return PriceWeekTwo;}
        if(now &gt;= TimeWeekTwo &amp;&amp; now &lt; TimeWeekThree){return PriceWeekThree;}
        if(now &gt;= TimeWeekThree){return PriceWeekFour;}
    }
    
    // Создать `amount` токенов и отправить их `target`
    // @параметр target Адрес получателя токенов
    // @параметр amount Количество создаваемых токенов
    function sendPreICOTokens(address target, uint amount) onlyOwner external {
        
        require(amount&gt;0);//Количество токенов должно быть больше 0
        balances[target] = safeAdd(balances[target], amount);
        StatsTotalSupply = safeAdd(StatsTotalSupply, amount);//Обновляем общее количество выпущенных токенов
        Transfer(0, this, amount);
        Transfer(this, target, amount);
        
        PoolPreICO = safeAdd(PoolPreICO,amount);//Обновляем общее количество токенов в пуле Pre-ICO
    }
    
    // Создать `amount` токенов и отправить их `target`
    // @параметр target Адрес получателя токенов
    // @параметр amount Количество создаваемых токенов
    function sendICOTokens(address target, uint amount) onlyOwner external {
        
        require(amount&gt;0);//Количество токенов должно быть больше 0
        balances[target] = safeAdd(balances[target], amount);
        StatsTotalSupply = safeAdd(StatsTotalSupply, amount);//Обновляем общее количество выпущенных токенов
        Transfer(0, this, amount);
        Transfer(this, target, amount);
        
        PoolICO = safeAdd(PoolICO,amount);//Обновляем общее количество токенов в пуле Pre-ICO
    }
    
    // Перечислить `amount` командных токенов на адрес `target` со счета основателя (администратора) после завершения ICO
    // @параметр target Адрес получателя токенов
    // @параметр amount Количество перечисляемых токенов
    function sendTeamTokens(address target, uint amount) onlyOwner external {
        
        require(ICOFinished);//Возможно только после завершения ICO
        require(amount&gt;0);//Количество токенов должно быть больше 0
        require(amount&gt;=PoolTeam);//Количество токенов должно быть больше или равно размеру пула команды
        require(balances[owner]&gt;=PoolTeam);//Количество токенов должно быть больше или равно балансу основателя
        
        balances[owner] = safeSub(balances[owner], amount);//Вычитаем токены у администратора (основателя)
        balances[target] = safeAdd(balances[target], amount);//Добавляем токены на счет получателя
        PoolTeam = safeSub(PoolTeam, amount);//Обновляем общее количество токенов пула команды
        TokensSent(target, amount);//Публикуем событие в блокчейн
        Transfer(owner, target, amount);//Осуществляем перевод
        
        noTransfer[target] = true;//Вносим получателя в базу аккаунтов, которым 1 месяц после ICO запрещено осуществлять переводы токенов
    }
    
    // Перечислить `amount` токенов эдвайзеров на адрес `target` со счета основателя (администратора) после завершения ICO
    // @параметр target Адрес получателя токенов
    // @параметр amount Количество перечисляемых токенов
    function sendAdvisorsTokens(address target, uint amount) onlyOwner external {
        
        require(ICOFinished);//Возможно только после завершения ICO
        require(amount&gt;0);//Количество токенов должно быть больше 0
        require(amount&gt;=PoolAdvisors);//Количество токенов должно быть больше или равно размеру пула эдвайзеров
        require(balances[owner]&gt;=PoolAdvisors);//Количество токенов должно быть больше или равно балансу основателя
        
        balances[owner] = safeSub(balances[owner], amount);//Вычитаем токены у администратора (основателя)
        balances[target] = safeAdd(balances[target], amount);//Добавляем токены на счет получателя
        PoolAdvisors = safeSub(PoolAdvisors, amount);//Обновляем общее количество токенов пула эдвайзеров
        TokensSent(target, amount);//Публикуем событие в блокчейн
        Transfer(owner, target, amount);//Осуществляем перевод
        
        noTransfer[target] = true;//Вносим получателя в базу аккаунтов, которым 1 месяц после ICO запрещено осуществлять переводы токенов
    }
    
    // Перечислить `amount` баунти токенов на адрес `target` со счета основателя (администратора) после завершения ICO
    // @параметр target Адрес получателя токенов
    // @параметр amount Количество перечисляемых токенов
    function sendBountyTokens(address target, uint amount) onlyOwner external {
        
        require(ICOFinished);//Возможно только после завершения ICO
        require(amount&gt;0);//Количество токенов должно быть больше 0
        require(amount&gt;=PoolBounty);//Количество токенов должно быть больше или равно размеру пула баунти
        require(balances[owner]&gt;=PoolBounty);//Количество токенов должно быть больше или равно балансу основателя
        
        balances[owner] = safeSub(balances[owner], amount);//Вычитаем токены у администратора (основателя)
        balances[target] = safeAdd(balances[target], amount);//Добавляем токены на счет получателя
        PoolBounty = safeSub(PoolBounty, amount);//Обновляем общее количество токенов пула баунти
        TokensSent(target, amount);//Публикуем событие в блокчейн
        Transfer(owner, target, amount);//Осуществляем перевод
        
        noTransfer[target] = true;//Вносим получателя в базу аккаунтов, которым 1 месяц после ICO запрещено осуществлять переводы токенов
    }

    //Функция покупки токенов на ICO
    function buy() public payable returns(bool) {

        require(msg.sender != owner);//Основатели не могут покупать токены
        require(msg.sender != wallet);//Основатели не могут покупать токены
        require(!ICOPaused);//Покупка разрешена, если ICO не приостановлено
        require(!ICOFinished);//Покупка разрешена, если ICO не завершено
        require(msg.value &gt;= price());//Полученная сумма в wei должна быть больше стоимости 1 токена
        require(now &gt;= TimeStart);//Условие продажи - ICO началось
        require(now &lt;= TimeEnd);//Условие продажи - ICO не завершено
        uint tokens = msg.value/price();//Количество токенов, которое должен получить покупатель
        require(safeAdd(StatsEthereumRaised, msg.value) &lt;= HardCapEthereum);//Собранный эфир не больше hard cap
        
        require(tokens&gt;0);//Количество токенов должно быть больше 0
        
        wallet.transfer(msg.value);//Отправить полученные ETH на кошелек сбора средств
        
        //Зачисление токенов на счет покупателя
        balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
        StatsTotalSupply = safeAdd(StatsTotalSupply, tokens);//Обновляем общее количество выпущенных токенов
        Transfer(0, this, tokens);
        Transfer(this, msg.sender, tokens);
        
        StatsEthereumRaised = safeAdd(StatsEthereumRaised, msg.value);//Обновляем цифру собранных ETH
        PoolICO = safeAdd(PoolICO, tokens);//Обновляем размер пула ICO
        
        //Записываем события в блокчейн
        Buy(msg.sender, msg.value, tokens);
        TokensSent(msg.sender, tokens);
        ContributionReceived(msg.sender, msg.value);

        return true;
    }
    
    function EventEmergencyStop() onlyOwner() {ICOPaused = true;}//Остановить ICO (в случае непредвиденных обстоятельств)
    function EventEmergencyContinue() onlyOwner() {ICOPaused = false;}//Продолжить ICO

    //Если переводы токенов для всех участников еще не разрешены (1 месяц после ICO), проверяем, участник ли это Pre-ICO. Если нет, запрещаем перевод
    function transfer(address _to, uint _value) isActive() returns (bool success) {
        
    if(now &gt;= TimeTransferAllowed){
        if(noTransfer[msg.sender]){noTransfer[msg.sender] = false;}//Если переводы разрешены по времени, разрешаем их отправителю
    }
        
    if(now &lt; TimeTransferAllowed){require(!noTransfer[msg.sender]);}//Если переводы еще не разрешены по времени, переводить могут только участники Pre-ICO
        
    return super.transfer(_to, _value);
    }
    /**
     * ERC 20 Standard Token interface transfer function
     *
     * Prevent transfers until halt period is over.
     */
    function transferFrom(address _from, address _to, uint _value) isActive() returns (bool success) {
        
    if(now &gt;= TimeTransferAllowed){
        if(noTransfer[msg.sender]){noTransfer[msg.sender] = false;}//Если переводы разрешены по времени, разрешаем их отправителю
    }
        
    if(now &lt; TimeTransferAllowed){require(!noTransfer[msg.sender]);}//Если переводы еще не разрешены по времени, переводить могут только участники Pre-ICO
        
        return super.transferFrom(_from, _to, _value);
    }

    //Сменить владельца
    function changeOwner(address _to) onlyOwner() {
        balances[_to] = balances[owner];
        balances[owner] = 0;
        owner = _to;
    }

    //Сменить адрес кошелька для сбора средств
    function changeWallet(address _to) onlyOwner() {
        balances[_to] = balances[wallet];
        balances[wallet] = 0;
        wallet = _to;
    }
}
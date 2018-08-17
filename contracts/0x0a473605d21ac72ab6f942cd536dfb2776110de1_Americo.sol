contract Americo {
  /* Variables p&#250;blicas del token */
    string public standard = &#39;Token 0.1&#39;;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public initialSupply;
    uint256 public totalSupply;

    /* Esto crea una matriz con todos los saldos */
    mapping (address =&gt; uint256) public balanceOf;
    mapping (address =&gt; mapping (address =&gt; uint256)) public allowance;

  
    /* Inicializa el contrato con los tokens de suministro inicial al creador del contrato */
    function Americo() {

         initialSupply=160000000000000;
         name=&quot;Americo&quot;;
        decimals=6;
         symbol=&quot;AME&quot;;
        
        balanceOf[msg.sender] = initialSupply;              // Americo recibe todas las fichas iniciales
        totalSupply = initialSupply;                        // Actualizar la oferta total
                                   
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] &lt; _value) throw;           // Compruebe si el remitente tiene suficiente
        if (balanceOf[_to] + _value &lt; balanceOf[_to]) throw; // Verificar desbordamientos
        balanceOf[msg.sender] -= _value;                     // Reste del remitente
        balanceOf[_to] += _value;                            // Agregue lo mismo al destinatario
      
    }

    /* Esta funci&#243;n sin nombre se llama cada vez que alguien intenta enviar &#233;ter a ella */
    function () {
        throw;     // Evita el env&#237;o accidental de &#233;ter
    }
}
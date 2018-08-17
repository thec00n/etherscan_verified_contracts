pragma solidity ^0.4.2;
/*&#39;pragma&#39; indique au compileur dans quelle version de Solidity ce code est &#233;crit */
contract storer {
/*&#39;contract&#39; indique le d&#233;but du contrat a proprement parler &#39;contract&#39; est similaire
&#224; &#39;class&#39; dans d&#39;autres langages (class variables, inheritance, etc.)*/
address public owner;
string public log;
/* 29979245621189875516790
function storer() {
    owner = msg.sender ;
}
/* &#39;storer&#39; est une fonction un peu particuli&#232;re, il s&#39;agit du constructeur du contrat.
Cette fonction s&#39;ex&#233;cute une seule fois au moment de la cr&#233;ation du contrat.
La cr&#233;ation du contrat est une transaction et comme toute transaction elle est
repr&#233;sent&#233;e en Solidity par &quot;msg&quot;, &quot;msg.sender&quot; correspond  &#224; l&#39;adresse qui
&#233;met cette transaction.  
A la cr&#233;ation du contrat la variable owner re&#231;oit l&#39;adresse qui a d&#233;ploy&#233; le
contrat */
modifier onlyOwner {
        if (msg.sender != owner)
            throw;
        _;
    }
/* le &#39;modifier&#39; permet de poser des conditions &#224; l&#39;ex&#233;cution des fonctions.
Ici, &#39;onlyOwner&#39; sera ajout&#233; &#224; la syntaxe des fonctions que l&#39;on
veut r&#233;server au &#39;owner&#39;. Le modifier teste la condion msg.sender != owner
si le requ&#234;teur de la fonction n&#39;est pas le owner alors l&#39;ex&#233;cution
s&#39;interrompt, c&#39;est le sens du &#39;throw&#39;; s&#39;il s&#39;agit bien du owner alors
la fonction s&#39;ex&#233;cute. Notez le &#39;_&#39; underscore apr&#232;s le test, il signifie
&#224; la fonction de continuer son ex&#233;cution.*/    
function store(string _log) onlyOwner() {
    log = _log;
}
/*La fonction &#39;store&#39; re&#231;oit une cha&#238;ne de caract&#232;res qu&#39;elle associe &#224; une
variable d&#39;&#233;tat &#39;_log&#39;. Cette fonction n&#39;est utilisable que par l&#39;adresse qui
est &#39;owner&#39;, si c&#39;est bien cette adresse qui fait la requ&#234;te alors la variable
&#39;log&#39; devient &#39;_log&#39;.*/
function kill() onlyOwner() {
  selfdestruct(owner); }
/* Cette derni&#232;re fonction permet de &quot;nettoyer&quot; la blockchain en supprimant le
contrat. Il est important de la faire figurer pour lib&#233;rer de l&#39;espace sur
la blockchain mais aussi pour supprimer un contrat bugg&#233;. En pr&#233;cisant une
adresse selfdestruct(address), tous les ethers stock&#233;s par le contrat y sont
envoy&#233;s. Attention si une transaction envoie des ethers &#224; un contrat qui s&#39;est
&quot;selfdestruct&quot; ces ethers seront perdus*/
}
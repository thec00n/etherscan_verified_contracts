pragma solidity 0.4.25;


contract Acquis {
    using SafeMath for uint256;

    address public proprio;             //  Propiètaire du contrat
    address public nouveauProprio;      //  tmp pour la passation éventuelle de pouvoir
    
    event changementProprio ( address indexed _de, address indexed _a );
    
    modifier proprioSeulement {
        require ( msg.sender == proprio );
        _;
    }
    
    function changerProprio ( address _nouveauProprio ) public proprioSeulement {
        nouveauProprio = _nouveauProprio;
    }
        
    function confirmerNouveauProprio() public {
        require ( msg.sender == nouveauProprio );
        emit changementProprio ( proprio, nouveauProprio );
        proprio = nouveauProprio;
        delete nouveauProprio;
    }
    
}
interface ReceveurDeTokens {
    
    function recevoirApprobation ( address _de, uint256 _montant, address _token ) external;
    
}
contract TokenERC20 {
    
    // Variables publiques du token.
    string public nom;
    string public symbole;
    uint8 public decimales = 18;
    // 18 décimales par défaut, fortement recommandé.
    uint256 public sommeTotale;

    // Création d'untableau avec tous les comptes.
    mapping ( address => uint256 ) public comptes;
    mapping ( address => mapping ( address => uint256 ) ) public autorisations;

    // Génère un évènement publique sur la BlocChaîne qui notifie les clients.
    event Transfert ( address indexed de, address indexed a, uint256 somme );

    // Notifie les clients du montant brûlé.
    event Brules ( address indexed from, uint256 value );


    /**
     * Constrcteur
     *
     * Initialise le contrat et donne la sommeTotale au proprio du contrat.
     */
            constructor ( uint256 sommeInitiale, string nomToken, string symboleToken ) public {
                
                sommeTotale = sommeInitiale * 10 ** uint256 ( decimales );  // Met à jour la sommeTotale.
                comptes[msg.sender] = sommeTotale;                          // Donne au créateur tous les tokens.
                nom = nomToken;                                             // Nom complet du token.
                symbole = symboleToken;                                     // Symbole du token.
                
            }


    /**
     * Transfert interne, ne peut être appelé que par ce contrat.
     */
    function _transfert ( address _de, address _a, uint _somme ) internal {
        require ( _de != 0x0);
        require ( comptes[_de] >= _somme );
        require ( comptes[_a] + _somme > comptes[_a] );
        uint balancePrecedente = comptes[_de] + comptes[_a];
        comptes[_de] -= _somme;
        comptes[_a] += _somme;
        emit Transfert ( _de, _a, _somme );
        assert ( comptes[_de] + comptes[_a] == balancePrecedente );
    }

    /**
     * Transfert de tokens
     *
     * Envoie `_valeur` tokens à `_a` de votre compte.
     *
     * @param _a l'adresse du receveur
     * @param _valeur le montant de l'envoi
     */
    function transfert ( address _a, uint256 _valeur ) public {
        _transfert ( msg.sender, _a, _valeur );
    }

    /**
     * Transfert de tokens depuis une autre addresse
     *
     * Envoie `_valeur` tokens à `_a` au nom de `_de`
     *
     * @param _de L'adress de l'envoyeur.
     * @param _a L'adresse du receveur.
     * @param _valeur Le montant à envoyer.
     */
    function transferFrom ( address _de, address _a, uint256 _valeur ) public returns ( bool succes ) {
        require ( _valeur <= autorisations[_de][msg.sender] );     // Check allowance
        autorisations[_de][msg.sender] -= _valeur;
        _transfert ( _de, _a, _valeur );
        return true;
    }

    /**
     * Définir une autorisation pour une autre adresse
     *
     * Autorise `_depenseur` à ne pas dépenser plus que `_valeur` tokens en votre nom
     *
     * @param _depenseur L'adresse autorisée à dépenser.
     * @param _valeur Le montant maximum à dépenser.
     */
    function approuver ( address _depenseur, uint256 _valeur ) public returns ( bool succes ) {
        autorisations[msg.sender][_depenseur] = _valeur;
        return true;
    }

    /**
     * Définir une autorisation pour une autre adresse et le notifier
     *
     * Autorise `_depenseur` à ne pas dépenser plus que `_valeur` tokens en votre nom et le notifie
     *
     * @param _depenseur L'adresse autorisée à dépenser.
     * @param _valeur Le montant maximum à dépenser.
     * @param _extraData Des données externes à envoyer au contrat.
     */
    function approveAndCall ( address _depenseur, uint256 _valeur, bytes _extraData ) public returns ( bool success ) {
        ReceveurDeTokens depenseur = ReceveurDeTokens ( _depenseur );
        if ( approuver ( _depenseur, _valeur ) ) {
            depenseur.recevoirApprobation ( msg.sender, _valeur, this );
            return true;
        }
    }

    /**
     * Destruction de tokens
     *
     * Retire `_valeur` tokens du système de manière irréversible
     *
     * @param _valeur Le montant de tokens à bruler.
     */
    function bruler ( uint256 _valeur ) public returns ( bool succes ) {
        require ( comptes[msg.sender] >= _valeur );   // Check if the sender has enough
        comptes[msg.sender] -= _valeur;            // Subtract from the sender
        sommeTotale -= _valeur;                      // Updates totalSupply
        emit Brules ( msg.sender, _valeur );
        return true;
    }

    /**
     * Destruction de tokens d'un autre compte'
     *
     * Retire `_valeur` tokens du système de manière irréversible au nom de '_de'
     *
     * @param _de L'adresse de l'envoyeur.
     * @param _valeur Le montant de tokens à brûler.
     */
    function brulerDe ( address _de, uint256 _valeur ) public returns ( bool success ) {
        require ( comptes[_de] >= _valeur );                // Check if the targeted balance is enough
        require ( _valeur <= autorisations[_de][msg.sender] );    // Check allowance
        comptes[_de] -= _valeur;                         // Subtract from the targeted balance
        autorisations[_de][msg.sender] -= _valeur;             // Subtract from the sender's allowance
        sommeTotale -= _valeur;                              // Update totalSupply
        emit Brules ( _de, _valeur );
        return true;
    }
    
}
/******************************************/
/*       LE TOKEN AVANCé COMMENCE ICI     */
/******************************************/
contract MonTokenAvance is Acquis, TokenERC20 {

    uint256 public prixDeVente;
    uint256 public prixDAchat;

    mapping ( address => bool ) public comptesGeles;

    /* Génère un évènement publique sur la BlocChaîne qui notifie les clients. */
    event ComptesGeles ( address cible, bool gele );


    /* Initialise le contrat et donne la sommeTotale au proprio du contrat. */
            constructor ( uint256 sommeInitiale, string nomToken, string symboleToken )
                TokenERC20 ( sommeInitiale, nomToken, symboleToken ) public {
                
                proprio = msg.sender;
                
            }

        
    /* Transfert interne, ne peut être appelé que par ce contrat. */
    function _transfert ( address _de, address _a, uint _valeur ) internal {
        require ( _a != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
        require ( comptes[_de] >= _valeur );               // Check if the sender has enough
        require ( comptes[_a] + _valeur > comptes[_a]); // Check for overflows
        require ( !comptesGeles[_de] );                     // Check if sender is frozen
        require( !comptesGeles[_a] );                       // Check if recipient is frozen
        comptes[_de] -= _valeur;                         // Subtract from the sender
        comptes[_a] += _valeur;                           // Add the same to the recipient
        emit Transfert ( _de, _a, _valeur );
    }


    /// @notice Crée un `montantMine` de tokens et l'envoie à `cible`
    /// @param cible Adresse qui reçoit les tokens.
    /// @param montantMine Le montant de tokens à recevoir.
    function minerToken ( address cible, uint256 montantMine ) proprioSeulement public {
        comptes[cible] += montantMine;
        sommeTotale += montantMine;
        emit Transfert ( 0, this, montantMine );
        emit Transfert ( this, cible, montantMine );
    }

    /// @notice `gelerCompte? Interdit | Autorise` `cible` à envoyer et recevoir des tokens
    /// @param cible L'adresse à geler.
    /// @param gele Booléen gelé/pas gelé.
    function gelerCompte ( address cible, bool gele ) proprioSeulement public {
        comptesGeles[cible] = gele;
        emit ComptesGeles ( cible, gele );
    }

    /// @notice Autorise les utilisateurs à acheter des tokens à `nouvPrixDAchat` eth et à vendre des tokens pour `nouvPrixDeVente` eth
    /// @param nouvPrixDeVente Prix auquel les utilisateurs peuvent vendre des tokens au contrat.
    /// @param nouvPrixDAchat Prix auquel les utilisateurs peuvent acheter des tokens.
    function setPrix ( uint256 nouvPrixDeVente, uint256 nouvPrixDAchat ) proprioSeulement public {
        prixDeVente = nouvPrixDeVente;
        prixDAchat = nouvPrixDAchat;
    }

    /// @notice Acheter des tokens du contrat en envoyant des ethers
    function acheter() payable public {
        uint montant = msg.value / prixDAchat;               // calcule le montant
        _transfert ( this, msg.sender, montant );            // fais le transfert
    }

    /// @notice Vend `montant` tokens au contrat
    /// @param montant Montant de tokens à vendre.
    function vendre ( uint256 montant ) public {
        require( address ( this ).balance >= montant * prixDeVente );// vérifie si le contrat a assez d'ethers pour acheter
        _transfert ( msg.sender, this, montant );           // fait le transfert
        msg.sender.transfer ( montant * prixDeVente );      // envoie les ethers au vendeur. Il est important de le faire endernier afin d'éviter toute attaque de récursion'
    }
    
}



/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}
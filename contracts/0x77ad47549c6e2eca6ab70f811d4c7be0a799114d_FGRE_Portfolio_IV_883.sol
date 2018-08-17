pragma solidity 		^0.4.21	;						
										
	contract	FGRE_Portfolio_IV_883				{				
										
		mapping (address =&gt; uint256) public balanceOf;								
										
		string	public		name =	&quot;	FGRE_Portfolio_IV_883		&quot;	;
		string	public		symbol =	&quot;	FGRE883IV		&quot;	;
		uint8	public		decimals =		18			;
										
		uint256 public totalSupply =		32288098633865000000000000000					;	
										
		event Transfer(address indexed from, address indexed to, uint256 value);								
										
		function SimpleERC20Token() public {								
			balanceOf[msg.sender] = totalSupply;							
			emit Transfer(address(0), msg.sender, totalSupply);							
		}								
										
		function transfer(address to, uint256 value) public returns (bool success) {								
			require(balanceOf[msg.sender] &gt;= value);							
										
			balanceOf[msg.sender] -= value;  // deduct from sender&#39;s balance							
			balanceOf[to] += value;          // add to recipient&#39;s balance							
			emit Transfer(msg.sender, to, value);							
			return true;							
		}								
										
		event Approval(address indexed owner, address indexed spender, uint256 value);								
										
		mapping(address =&gt; mapping(address =&gt; uint256)) public allowance;								
										
		function approve(address spender, uint256 value)								
			public							
			returns (bool success)							
		{								
			allowance[msg.sender][spender] = value;							
			emit Approval(msg.sender, spender, value);							
			return true;							
		}								
										
		function transferFrom(address from, address to, uint256 value)								
			public							
			returns (bool success)							
		{								
			require(value &lt;= balanceOf[from]);							
			require(value &lt;= allowance[from][msg.sender]);							
										
			balanceOf[from] -= value;							
			balanceOf[to] += value;							
			allowance[from][msg.sender] -= value;							
			emit Transfer(from, to, value);							
			return true;							
		}								
//	}									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
	// Programme d&#39;&#233;mission - Lignes 1 &#224; 10									
	//									
	//									
	//									
	//									
	//     [ Nom du portefeuille ; Num&#233;ro de la ligne ; Nom de la ligne ; Ech&#233;ance ]									
	//         [ Adresse export&#233;e ]									
	//         [ Unit&#233; ; Limite basse ; Limite haute ]									
	//         [ Hex ]									
	//									
	//									
	//									
	//     &lt; FGRE_Portfolio_IV_metadata_line_1_____GROUPE_LINGENHELD_SA_20580515 &gt;									
	//        &lt; 89VYugyOn2HWVg9eYXUl6sO7Eep6hrdh6h0w7ryjwNc5hS7sJU6U3ZMssD9agbex &gt;									
	//        &lt; 1E-018 limites [ 1E-018 ; 1705593900,42023 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000000000000A2A879E &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_2_____GROUPE_LINGENHELD_SA_OBS_DAC_20580515 &gt;									
	//        &lt; ZgRDYUwO6r2KyorejZSm4946331BO83TyTC0LFprlmJ4XxEFUv9J3w07fympKnN8 &gt;									
	//        &lt; 1E-018 limites [ 1705593900,42023 ; 1902022422,84078 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000000A2A879EB564182 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_3_____CARRIERE_DU_VIEUX_MOULIN_20580515 &gt;									
	//        &lt; r1q4omFFZCvh1bc2oOgvj841xbTgcflsD6u5rf9B734LW2DgIu5k9zo8GMtIvVfI &gt;									
	//        &lt; 1E-018 limites [ 1902022422,84078 ; 2615029451,87045 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000000B564182F9637E1 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_4_____CARRIERE_DU_VIEUX_MOULIN_OBS_DAC_20580515 &gt;									
	//        &lt; pAg56eK6yvE29D8xg0dqKZjse9MXu6bJdsKx6ZcNq1SyS5BDjqmXD4gHvdBdmlz9 &gt;									
	//        &lt; 1E-018 limites [ 2615029451,87045 ; 2801217325,17961 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000F9637E110B25185 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_5_____CARRIERE_DE_TANCONVILLE_20580515 &gt;									
	//        &lt; Ew47pkcwz21Og6EIDNt8wa0cWeF75P87Xi2uJ6EPeGyvJ162Lvvcq1mYLKV58Yf1 &gt;									
	//        &lt; 1E-018 limites [ 2801217325,17961 ; 3038224476,52331 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000010B25185121BF670 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_6_____CARRIERE_DE_TANCONVILLE_OBS_DAC_20580515 &gt;									
	//        &lt; 2WEpas7T85hK7ai630ep85wM4JHv7WpWhf7o177NYX8DSYuEL9cgTQsvrKKirWPa &gt;									
	//        &lt; 1E-018 limites [ 3038224476,52331 ; 5117427039,26729 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000121BF6701E8092F0 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_7_____DELTA_AMENAGEMENT_ALSACE_LORRAINE_20580515 &gt;									
	//        &lt; 5aMxW6Zg6l9bQEBteBA5h8DjUuen3t3VZ8n8Vxqs8Q4Iv85WrT9eCJqK2t3K2mp9 &gt;									
	//        &lt; 1E-018 limites [ 5117427039,26729 ; 5685697174,60486 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000001E8092F021E3AF75 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_8_____DELTA_PROMOTION_20580515 &gt;									
	//        &lt; wafrZcPMsVyne7Uh6P9wGvCfp0Oty2pKX8zvPfPXuU0AO6v7XehV72FY2tK90222 &gt;									
	//        &lt; 1E-018 limites [ 5685697174,60486 ; 6077528100,8547 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000021E3AF752439926A &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_9_____DELTA_PROMOTION_OBS_DAC_20580515 &gt;									
	//        &lt; 7383Ks6Ux6Uy7QdNZS7e4ZPCc4SlYJfre4J8XT0S5X67BGAz9I2DTjaMsW06N941 &gt;									
	//        &lt; 1E-018 limites [ 6077528100,8547 ; 6153294231,57834 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000002439926A24AD2E8F &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_10_____EST_ENROBES_20580515 &gt;									
	//        &lt; 55tlRf3O418oc4QCcc89TME4W40wUwfItJHvW2B8UuAlk1EV9VJAVEw0t8Zf8QZb &gt;									
	//        &lt; 1E-018 limites [ 6153294231,57834 ; 6242456360,7993 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000024AD2E8F25353B84 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
	// Programme d&#39;&#233;mission - Lignes 11 &#224; 20									
	//									
	//									
	//									
	//									
	//     [ Nom du portefeuille ; Num&#233;ro de la ligne ; Nom de la ligne ; Ech&#233;ance ]									
	//         [ Adresse export&#233;e ]									
	//         [ Unit&#233; ; Limite basse ; Limite haute ]									
	//         [ Hex ]									
	//									
	//									
	//									
	//     &lt; FGRE_Portfolio_IV_metadata_line_11_____EST_ENROBES_OBS_DAC_20580515 &gt;									
	//        &lt; iMn6LNYaRCqsI59Qjt8tilE4WxSU3ZP9JQqWh6Idb6BzGm06tNKho23M8oWD0gMa &gt;									
	//        &lt; 1E-018 limites [ 6242456360,7993 ; 8617470777,99238 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000025353B84335D3786 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_12_____FEHR_BETON_ENVIRONNEMENT_20580515 &gt;									
	//        &lt; f22D3k9I9vg99csjIoxFUaYJjNb5KJe8H6917Dyz6Azxf5Xd6uRz2aY7XOBUHA06 &gt;									
	//        &lt; 1E-018 limites [ 8617470777,99238 ; 8915118832,47193 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000335D37863523644B &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_13_____FEHR_BETON_ENVIRONNEMENT_OBS_DAC_20580515 &gt;									
	//        &lt; G9t2bk7V6gSzL1LSl481aOKkX7aUbtMV97bYl5eK2LMqkyyW5ckQF91m3xNfAZz6 &gt;									
	//        &lt; 1E-018 limites [ 8915118832,47193 ; 9335830143,8938 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000003523644B37A558A6 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_14_____LINGENHELD_ENVIRONNEMENT_20580515 &gt;									
	//        &lt; eNBCcPn9u4J3I7eS8VDOBq98yhi5Pq3zL28H2pgy1qTf0G8CyOYrH4zwF7QZwC5d &gt;									
	//        &lt; 1E-018 limites [ 9335830143,8938 ; 9421787943,35482 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000037A558A6382881EA &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_15_____LINGENHELD_ENVIRONNEMENT_OBS_DAC_20580515 &gt;									
	//        &lt; 6F2PQA1t9zNe5uj6Urfa7zZCG8M4W3Es53fO94HMBlo0c493CO0gscoDOAOpCR7V &gt;									
	//        &lt; 1E-018 limites [ 9421787943,35482 ; 10368177466,3621 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000382881EA3DCC9553 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_16_____LINGENHELD_TRAVAUX_PUBLICS_20580515 &gt;									
	//        &lt; jpMf1drf9Mpd7V2LmWv32dD285XF1Q5rt50G2bpfK1I5IEOx6cc36ir5K0v663BL &gt;									
	//        &lt; 1E-018 limites [ 10368177466,3621 ; 11043456970,7643 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000003DCC955341D2FA61 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_17_____LINGENHELD_TRAVAUX_PUBLICS_OBS_DAC_20580515 &gt;									
	//        &lt; Cy6vuXz4zXlnw1M3h6v8Ih6x1g578PMULOgmEQJ1kxZ75e3nXnc0X32E3CbQgR40 &gt;									
	//        &lt; 1E-018 limites [ 11043456970,7643 ; 13305247330,5751 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000041D2FA614F4E323D &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_18_____LINGENHELD_TRAVAUX_SPECIAUX_20580515 &gt;									
	//        &lt; r6gvnrhB1bi325p4M06jL090EF3h4iiF0u27oQPGh2BMuKcGEW6fef3D6GV63dcZ &gt;									
	//        &lt; 1E-018 limites [ 13305247330,5751 ; 14375917277,2544 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000004F4E323D55AFE8B0 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_19_____LINGENHELD_TRAVAUX_SPECIAUX_OBS_DAC_20580515 &gt;									
	//        &lt; c69XJi8pH54x3k5ty33487Fd1G4R5E9i4c7KNKd4tCD886HRfERoUT72t0nNhO8E &gt;									
	//        &lt; 1E-018 limites [ 14375917277,2544 ; 14560490283,1728 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000055AFE8B056C98B84 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_20_____LTS_LUXEMBOURG_20580515 &gt;									
	//        &lt; 2C0fSyyD5U7R94Kk0vEkC4VpXGck9qwkp6W6rNqi1RB2X72JRhMbuy783t5LZ7Kc &gt;									
	//        &lt; 1E-018 limites [ 14560490283,1728 ; 16441509775,544 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000056C98B8461FFC0C2 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
	// Programme d&#39;&#233;mission - Lignes 21 &#224; 30									
	//									
	//									
	//									
	//									
	//     [ Nom du portefeuille ; Num&#233;ro de la ligne ; Nom de la ligne ; Ech&#233;ance ]									
	//         [ Adresse export&#233;e ]									
	//         [ Unit&#233; ; Limite basse ; Limite haute ]									
	//         [ Hex ]									
	//									
	//									
	//									
	//     &lt; FGRE_Portfolio_IV_metadata_line_21_____LTS_LUXEMBOURG_OBS_DAC_20580515 &gt;									
	//        &lt; 69xF4Bl924kQ8Asoa04mfH5sqI59ypye2yW9664y73k4z7T5KtOQ61zW40IWawf6 &gt;									
	//        &lt; 1E-018 limites [ 16441509775,544 ; 17597183137,7498 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000061FFC0C268E32BAA &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_22_____METHAVOS_SAS_20580515 &gt;									
	//        &lt; 3aRU1AC1dSO5NETbDp6oPa5BtdV2AAd3S5l69eqSB2oSf26JionQsktZjF055CpG &gt;									
	//        &lt; 1E-018 limites [ 17597183137,7498 ; 17708133655,1456 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000068E32BAA698C77B6 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_23_____METHAVOS_SAS_OBS_DAC_20580515 &gt;									
	//        &lt; 2wRQO3PGxFZfam7GNOH563t85QR8IDt6p5Krc0Wz3O756Qt0FMwI3fcaWu0SFi3G &gt;									
	//        &lt; 1E-018 limites [ 17708133655,1456 ; 17782556318,6929 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000698C77B669FE0710 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_24_____MTS_MANUTENTION_TRANSPORT_SERVICES_20580515 &gt;									
	//        &lt; 96xfd11i42nf277LOv3jnZU4LDV3ap32fXw7ZZdT65goG8P2604g2BQ7EcNfqVLc &gt;									
	//        &lt; 1E-018 limites [ 17782556318,6929 ; 18117686542,2991 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000069FE07106BFD654E &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_25_____MTS_MANUTENTION_TRANSPORT_SERVICES_OBS_DAC_20580515 &gt;									
	//        &lt; 38t1GkgRuaa7aj08DB2f9pqKCNzTnS47MDbb44SF59irvbD1W612HQBdJ07HI3JF &gt;									
	//        &lt; 1E-018 limites [ 18117686542,2991 ; 18396997232,1735 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000006BFD654E6DA7970B &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_26_____SEMAROUTE_ENROBES_20580515 &gt;									
	//        &lt; dS9lDTlU5euQiO3G1qOl57St1bEkKL9F2cLa9z55f98wtX59W49L064V77NAudfE &gt;									
	//        &lt; 1E-018 limites [ 18396997232,1735 ; 18530242252,4897 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000006DA7970B6E72E7E1 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_27_____SEMAROUTE_ENROBES_OBS_DAC_20580515 &gt;									
	//        &lt; 8xhyGsLdH2o70q1CnZ46b7Jys7kpp95eFF2dvUPs7k8M10Noargw57Dam9v4Xz4W &gt;									
	//        &lt; 1E-018 limites [ 18530242252,4897 ; 19247527405,4998 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000006E72E7E172B96565 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_28_____SPIRALTRANS_SAS_20580515 &gt;									
	//        &lt; X44GLZiAqu01RjzTyWEHAfF5TVyICiCXniD7FLOHCHiuZ1zDzB7l58Z6RZuWWyQE &gt;									
	//        &lt; 1E-018 limites [ 19247527405,4998 ; 20583466136,8286 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000072B965657AAFE076 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_29_____SPIRALTRANS_SAS_OBS_DAC_20580515 &gt;									
	//        &lt; N8FAJl1E76F7xN4yi2w8nh2tPPaaBgQ12AJiKFY7AX85O43uot179d79Z36D4a7R &gt;									
	//        &lt; 1E-018 limites [ 20583466136,8286 ; 21226982810,361 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000007AAFE0767E85CE29 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_30_____LTS_sarl__ab__20580515 &gt;									
	//        &lt; clu31pb3kJdi73B9ErV1M57bk00v17B9dEH42mEzcRHl7d3kcP4H6hGtg3cxsXt6 &gt;									
	//        &lt; 1E-018 limites [ 21226982810,361 ; 21857654667,4109 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000007E85CE298248225B &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
	// Programme d&#39;&#233;mission - Lignes 31 &#224; 40									
	//									
	//									
	//									
	//									
	//     [ Nom du portefeuille ; Num&#233;ro de la ligne ; Nom de la ligne ; Ech&#233;ance ]									
	//         [ Adresse export&#233;e ]									
	//         [ Unit&#233; ; Limite basse ; Limite haute ]									
	//         [ Hex ]									
	//									
	//									
	//									
	//     &lt; FGRE_Portfolio_IV_metadata_line_31_____ORTP_SA__ab__20580515 &gt;									
	//        &lt; 6584R556A7WW0068awl60TeaxEu0dWw16Gt53xfveSI6mIy9cBp2N8tPKguca9DJ &gt;									
	//        &lt; 1E-018 limites [ 21857654667,4109 ; 23037465373,7383 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000008248225B895061E9 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_32_____DESAMEST_SOLUTIONS__ab__20580515 &gt;									
	//        &lt; PEi5ty0M2462R3ALw7MNO50748915r13BI7KoG1ZN415K5ecY3k541j0eiFeP1SO &gt;									
	//        &lt; 1E-018 limites [ 23037465373,7383 ; 23367534916,1298 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000895061E98B480754 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_33_____LINGENHELD_DEMOLITION__ab__20580515 &gt;									
	//        &lt; 8i7017a3QRsrl9M7b3m06puoxYUr4279b2SDSWA4q4m5LFtEKtxYW83yhKP8bMZ6 &gt;									
	//        &lt; 1E-018 limites [ 23367534916,1298 ; 23568851057,7405 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000008B4807548C7B3672 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_34_____LIGENHELD_&amp;_FILS__ab__20580515 &gt;									
	//        &lt; V9x41l9T046akbnTAzil4f137SlSg4shv85CM4p01l315U2zE78DxzlcGRI4A8US &gt;									
	//        &lt; 1E-018 limites [ 23568851057,7405 ; 25384664109,683 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000008C7B3672974DEC6B &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_35_____EUROPEAN_TP__ab__20580515 &gt;									
	//        &lt; 4q3p4so7fPg3N28nGXj2h95q2Xmc1GH915mvHBZ5j1zNvt3Z0987QVljSTbK9Jiv &gt;									
	//        &lt; 1E-018 limites [ 25384664109,683 ; 25495378182,1856 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000974DEC6B97F6DC1A &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_36_____ENVALOR_ENVIRONNEMENT__ab__20580515 &gt;									
	//        &lt; kqYwZOy5PUtdG0s6B26kO562WgK0OH1Jf361609u437bYV1obWY2hW25v6t8VjD4 &gt;									
	//        &lt; 1E-018 limites [ 25495378182,1856 ;  ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000097F6DC1AA6D0C9F9 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_37_____HAAR_ENVIRONNEMENT__ab__20580515 &gt;									
	//        &lt; zgQXQkQMobHbRh9c6R0hF2fzcCELB7S33Ki0g6cp5g0CPFKPW8p454g0cZDXueaP &gt;									
	//        &lt; 1E-018 limites [ 27987010489,0193 ; 28166175926,1149 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000A6D0C9F9A7E22C79 &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_38_____AXIUM_DESAMIANTAGE__ab__20580515 &gt;									
	//        &lt; QiBiW9YQnIKCEzdh6d218vmSKKu5tw4lkz64Vms618MT836c9gWxbJckGx0DFxHl &gt;									
	//        &lt; 1E-018 limites [ 28166175926,1149 ; 30113604579,9814 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000A7E22C79B37DB6CA &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_39_____DELTA_AMENAGEMENT_ALSACE__ab__20580515 &gt;									
	//        &lt; N4r06EuMti3Ld9e563TjRH67TDD4ox1pr6G4ru1uz3301pDSYFS4274AxXvv58N1 &gt;									
	//        &lt; 1E-018 limites [ 30113604579,9814 ; 30313034545,5795 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000B37DB6CAB4AE051F &gt;									
	//     &lt; FGRE_Portfolio_IV_metadata_line_40_____DELTA_AMENAGEMENT_LORRAINE__ab__20580515 &gt;									
	//        &lt; KnO9415z7RIbW7r03xgW3SewMx4nEoYNDX1d1iSjf0SAhNtWjKc2EI69ZjCO3SEc &gt;									
	//        &lt; 1E-018 limites [ 30313034545,5795 ; 32288098633,865 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000B4AE051FC073BA87 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
	}
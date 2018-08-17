pragma solidity 		^0.4.21	;						
										
	contract	VEKSELBERG_Portfolio_I_883				{				
										
		mapping (address =&gt; uint256) public balanceOf;								
										
		string	public		name =	&quot;	VEKSELBERG_Portfolio_I_883		&quot;	;
		string	public		symbol =	&quot;	VEK883		&quot;	;
		uint8	public		decimals =		18			;
										
		uint256 public totalSupply =		1248388771473920000000000000					;	
										
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
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_1_____Octo_Telematics_20250515 &gt;									
	//        &lt; EKRSqS2yGRKDo97T05k3986AGvdb0cuGqseOzpqD07IgSzF7ouXqs1NCFZ80cpBe &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000000000000.000000000000000000 ; 000000023042028.993840800000000000 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000000000000037A0ED4 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_2_____Hevel_LLC_20250515 &gt;									
	//        &lt; s0ObBpti17J5WccIyF43X8F052pT036j93bDvxUA93mmAGoO6Y2IPutMHPM8HOkz &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000023042028.993840800000000000 ; 000000052775685.551625400000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000037A0ED456471373 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_3_____Big_Pension_Fund_20250515 &gt;									
	//        &lt; RnJNF7P9op2hTh08s75v5Bq9U857D88T1Wny2c0AJKks6vI4R0C3k5Q071wl6p3f &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000052775685.551625400000000000 ; 000000080573727.454863400000000000 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000564713732B64E852B &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_4_____Airports_Regions_20250515 &gt;									
	//        &lt; G9SzEctYK0xxHh8855259gU1ZIh523io7PXFoz1JHU9P2v976q6Mi57Jc3p94WsM &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000080573727.454863400000000000 ; 000000120250863.429500000000000000 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000002B64E852B4E34C5460 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_5_____Zoloto_Kamchatki_20250515 &gt;									
	//        &lt; oe66Ec43e69T6qs7JYUq56JF2DShp1b63KINtrVBE2zrpHtRsGjvjVC7M5NQ1YXz &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000120250863.429500000000000000 ; 000000147530690.473885000000000000 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000004E34C54604ECBCF485 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_6_____Ekaterinburg_non_Ferrous_Metals_Processing_Plant_20250515 &gt;									
	//        &lt; G3BfPZr3O1J6K45vh2qyJV8cv0nCy2rEscPukD888PI648RBxtlHN7NTr4CqH7cH &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000147530690.473885000000000000 ; 000000176512024.769395000000000000 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000004ECBCF48550ED00309 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_7_____Rotec_20250515 &gt;									
	//        &lt; o3f7Qb5l187PpC8ZasDh8R7iPFU1D129GQDT85WOVw5i8f9sA1qpU1ueweFv4NDp &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000176512024.769395000000000000 ; 000000211362058.583589000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000050ED00309816B8E20D &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_8_____Ural_Turbine_Works_20250515 &gt;									
	//        &lt; l83YqZiQ9S6oO061lE1OuOU7v3R4cZ0A93P6AU67St9Cy9pyqr5GwwbT908dLEIe &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000211362058.583589000000000000 ; 000000250124829.957700000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000816B8E20DBFD699807 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_9_____Invetsment_Fund_New_Europe_Real_Estate_Limited_20250515 &gt;									
	//        &lt; atITlU00O8Oc88G1ngL00C1G3zxX09YQ2U68UYUQ4fPhuUzIgUBKShM0566iO416 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000250124829.957700000000000000 ; 000000289836954.309925000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000BFD699807C00CC925C &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_10_____Kamensk_Uralsky_non_Ferrous_Metals_Working_Plant_20250515 &gt;									
	//        &lt; PDdWzd4eadV6VBNiG2DFh76hDsOlQ78SvSSIe4q44N0MgR8CQ51BqF36bwQHZt63 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000289836954.309925000000000000 ; 000000314241946.682258000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000C00CC925CC8B19E052 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_11_____Renova_Management_20250515 &gt;									
	//        &lt; 4i7rfOM3r1FPPs4WEp0L3FI07kl7zQNMUtkJpfjep3JJ2fSe9NuIq1is0R8l2Wd6 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000314241946.682258000000000000 ; 000000341440588.392048000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000C8B19E052C95A3ECBC &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_12_____Oerlikon_20250515 &gt;									
	//        &lt; xnR1X1x65V8ny3i0uTbe15YH791T6TxNrt81h7kXY9d0U61p9DI0M47ZpdN04IE2 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000341440588.392048000000000000 ; 000000379744181.328077000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000C95A3ECBCCA5EAC970 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_13_____Sulzer_20250515 &gt;									
	//        &lt; lG8xa5QK97iN837vZjHKCD9N30SHsyujt349K11vf8O67kUVGChwNfPC3z3WSwz6 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000379744181.328077000000000000 ; 000000404968043.601462000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000CA5EAC970CFBA12F64 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_14_____Akado_20250515 &gt;									
	//        &lt; q0t03rXWc09kJE187kGm4ht1aYfBIQ3zB7bYbHE74uT6U0SCevFQhAqV7wivG13m &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000404968043.601462000000000000 ; 000000443413207.517843000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000CFBA12F64D359422C8 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_15_____Akado_Telecom_20250515 &gt;									
	//        &lt; BHWzvc1GqoDemvGkUFEs1wCXEa368MDxUqcTWBhuzsZmR3nHF075Tsl47852Y119 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000443413207.517843000000000000 ; 000000479267729.497339000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000D359422C81191394DA5 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_16_____Orgsyntes_Group_20250515 &gt;									
	//        &lt; v6qRni01Ku0L6pC01A2u6P5B13O06O0rR6oTT6dJH0H2zWnMvP5EwlbinNP76FNe &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000479267729.497339000000000000 ; 000000513810214.854941000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001191394DA5119E78BA38 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_17_____Khimprom_Novocheboksarsk_20250515 &gt;									
	//        &lt; M2fUsdLXvIj3PutiUw3Rj5uB8iROZx0G3mcP3L4H8UZ28m58u8u316czB8xRqlh4 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000513810214.854941000000000000 ; 000000541921460.861913000000000000 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000119E78BA3811A5A651C7 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_18_____Percarbonate_20250515 &gt;									
	//        &lt; n02txCFf6yf6o2YH0Xy2q7G2B4HzHo6Vm74gOEfeqd0u01t4yYWk31M5Duxd723y &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000541921460.861913000000000000 ; 000000565570928.010199000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000011A5A651C711A7337AA6 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_19_____Kortros_20250515 &gt;									
	//        &lt; 0d6xgPE0HkY6Fg4Q7cV1Na1RB51ivlpdk7V66AJVaBc5wM6oesZDIQFfe0LfC72r &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000565570928.010199000000000000 ; 000000589235868.702825000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000011A7337AA611A80D764A &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_20_____Academia_City_20250515 &gt;									
	//        &lt; olmhpjEKJl5qk1CSVkBy2wB45UULhes4n6g3OAr0Cz8HDv29RO6a3jC2A14rf9F5 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000589235868.702825000000000000 ; 000000623079382.960559000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000011A80D764A11A9E0DEC1 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_21_____Energoprom_Group_20250515 &gt;									
	//        &lt; 2ftJL48ky9S2ig80MFR5GeH92a66iccBj1MdRWU28bR8i8819RE81eUTim0QR5h4 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000623079382.960559000000000000 ; 000000655160100.266606000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000011A9E0DEC11337C233DB &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_22_____Novocherkassk_Electrode_Plant_20250515 &gt;									
	//        &lt; 584t7Eoo72PukQUp608h5J2vZJm13Q89k4pO9C3tpU6P7pX600dx0EZ3n9e962rz &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000655160100.266606000000000000 ; 000000678795138.435003000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001337C233DB16FC133A49 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_23_____Novosibirsk_Electrode_Plant_20250515 &gt;									
	//        &lt; 8SVVxy322965mRt5I768r0A8412Q55Fdl836Uu6tmjquhZz6qS9i597qCNx8V92C &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000678795138.435003000000000000 ; 000000718084387.936806000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000016FC133A4916FCE8C776 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_24_____Chelyabinsk_Electrode_Plant_20250515 &gt;									
	//        &lt; h1D21a1cOQ1gJyAZ97ETT2a7BkE07GPkA98b7ujAJ1R8OIG1G6B60pWSI0mxaqKl &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000718084387.936806000000000000 ; 000000751142944.299394000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000016FCE8C77616FE4B3578 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_25_____Columbus_Nova_20250515 &gt;									
	//        &lt; lUtolol1xKrSOD4qYCXZwla520072i5flx6C10SFi48BKad65surUBT1TZ6kfsmC &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000751142944.299394000000000000 ; 000000779727170.939986000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000016FE4B357817094B7C8A &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_26_____Irkutskcable_Kirscable_20250515 &gt;									
	//        &lt; 60fPi84eH99S8rmSnH84064hX4qoRO090Pb3dRl0B34AIfDr0WpNU36BqKs7dHtV &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000779727170.939986000000000000 ; 000000802191417.439658000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000017094B7C8A170A9FCB93 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_27_____Kamensk_Uralsky_Metallurgical_Works_20250515 &gt;									
	//        &lt; aJCdZhjnMcCpWQ9u3q9GKowac415c4103e8Rp58kDABKktO57TBBo3c2043Dhk88 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000802191417.439658000000000000 ; 000000832978406.470545000000000000 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000170A9FCB931710216274 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_28_____United_Manganese_Kalahari_20250515 &gt;									
	//        &lt; EJ3TXbzt6dECQmY0TYZ5MF0dng3r0M25yh0xp98tM67g9C1O40vNZWn9Tmvd2Rw2 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000832978406.470545000000000000 ; 000000856794111.031656000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000017102162741710DAFC71 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_29_____Bank_Cyprus_Group_20250515 &gt;									
	//        &lt; dgKGtjpB1O456W07rY0KGMqNQQmV06P7QY4AGBjnsO4P1O4u9AqvfmHRMlI25A8m &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000856794111.031656000000000000 ; 000000896058416.182399000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001710DAFC71171F5B98B4 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_30_____Skolkovo_Foundation_20250515 &gt;									
	//        &lt; 4RP21423cu16GNKtLwmY9n9l7T9rNA232959oko1Pb4kZMyvRI56A6GPLhsJqb3w &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000896058416.182399000000000000 ; 000000934008155.568507000000000000 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000171F5B98B41B22EC3D9C &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_31_____Ascometal_SAS_20250515 &gt;									
	//        &lt; 40Oo3UTarPPlhoanLXf4UNpl81pYgu52ehXkiWhNfpt4YwT15ABO8985eU1UdDH5 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000934008155.568507000000000000 ; 000000966287331.905784000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001B22EC3D9C1E0D333C03 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_32_____Ascometal_gmbh_20250515 &gt;									
	//        &lt; Vk07wp2L3GDCkXX53DRXlL3z2h4KiOCWzoDK74jlGh8Xxw4eA36ibZsw3jCK8hK2 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000966287331.905784000000000000 ; 000000989734609.846814000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001E0D333C031E29356C3E &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_33_____Schmolz_Bickenbach_20250515 &gt;									
	//        &lt; L8bI4Hlk73H8ezT04mp01aVi60QnSvV967H288TV67k2WR773XwaNOTI96T493We &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000989734609.846814000000000000 ; 000001015241645.880770000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001E29356C3E1E2A15F705 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_34_____Deutsche_Edelstahlwerke_GmbH_20250515 &gt;									
	//        &lt; 1AS7n652WZ78qnEbmHZGSPWMwyO3U1A121S95OTeDmRvhHnS8B9sGFB17074e85R &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000001015241645.880770000000000000 ; 000001043255370.431440000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001E2A15F7051E37D2E629 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_35_____A_Finkl_Sons_Steel_20250515 &gt;									
	//        &lt; 8nb511JJ1JNOE9ACrR2DhPjAwv67c5wJOiDDJ8Go4Bty03Y7DbFU6Om9Oz5pTR0C &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000001043255370.431440000000000000 ; 000001073611986.757450000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001E37D2E62921F0EF1D76 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_36_____dr._wilhelm_mertens_gmbh_20250515 &gt;									
	//        &lt; A85B453pTrw5yeEeUyv05A185e92Ywd7103RrvOot9YTs9jVa5s1CypZtaPxgK3I &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000001073611986.757450000000000000 ; 000001107231909.406060000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000021F0EF1D7623C829D434 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_37_____stemcor_flachstahl_gmbh_20250515 &gt;									
	//        &lt; cvPGEhq5TR3R90sQo1rDoTPWwhNyg8eniC61hQ3y72PLZBuNOtV6fp3YiYPIDqi2 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000001107231909.406060000000000000 ; 000001146506892.993330000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000023C829D43423C95BAE77 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_38_____dk_automotive_ag_20250515 &gt;									
	//        &lt; pE0YvaeM29u3rcnZfcLT2ezX1IRu3tBBxtC2Wu4h18Q1n0f0y5DoNM9op6O9nd2u &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000001146506892.993330000000000000 ; 000001182514322.750160000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000023C95BAE7724A65522E8 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_39_____deutsche_edelstahlwerke_h&#228;rterei_technik_gmbh_20250515 &gt;									
	//        &lt; T1HkhBTC8b4teSRFVG59x5S5BK7LI6IDOoVTM4oZXNJ5P1W0W834dcXo7E9Yv9nN &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000001182514322.750160000000000000 ; 000001219191805.625200000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000024A65522E824C0198909 &gt;									
	//     &lt; VEKSELBERG_Portfolio_I_metadata_line_40_____schmolz_bickenbach_polska_spzoo_20250515 &gt;									
	//        &lt; 2RYC8w4jiUGR2u3YzcqcubQZ2X88b6B76hP6MLuE68WUxsPAbpIknzraqW15lk40 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000001219191805.625200000000000000 ; 000001248388771.473920000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000024C019890924C8475D18 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
	}
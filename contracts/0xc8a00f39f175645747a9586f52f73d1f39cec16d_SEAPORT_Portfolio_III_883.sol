pragma solidity 		^0.4.21	;						
										
	contract	SEAPORT_Portfolio_III_883				{				
										
		mapping (address =&gt; uint256) public balanceOf;								
										
		string	public		name =	&quot;	SEAPORT_Portfolio_III_883		&quot;	;
		string	public		symbol =	&quot;	SEAPORT883III		&quot;	;
		uint8	public		decimals =		18			;
										
		uint256 public totalSupply =		1212351653649260000000000000					;	
										
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
	//     &lt; SEAPORT_Portfolio_III_metadata_line_1_____Sochi_Port_Authority_20250515 &gt;									
	//        &lt; N5c25pOC7RIvsC8iR6DKwUQw8XAvMos42m19WB0QgT354bj1zpwK5JIvLE3lNdq7 &gt;									
	//        &lt; 1E-018 limites [ 1E-018 ; 24173024,4266269 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000000000090151D9E &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_2_____Sochi_Port_Spe_Value_20250515 &gt;									
	//        &lt; CW1e6c4NiOJxDjR7vVTVrN96FWaL63m5LOzxCF16eDub90uGEgWCDbF7T6u21C2T &gt;									
	//        &lt; 1E-018 limites [ 24173024,4266269 ; 70412176,817712 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000090151D9E1A3B07685 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_3_____Solombala_Port_Spe_Value_20250515 &gt;									
	//        &lt; yfeXMo2j2apE74HqGGMU87yyWIuEtBUR5w3y4QjZrBOwiNFw06T0mOQ8s5kXg9H6 &gt;									
	//        &lt; 1E-018 limites [ 70412176,817712 ; 97416758,1548618 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000001A3B07685244A62F1B &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_4_____Sovgavan_Port_Limited_20250515 &gt;									
	//        &lt; ZD3U1Sf1SKanXUXkJ7YhJ3m7MAYlvEhn2Vg0ia7zw69K4MbP2h9g1xx4yGR4KvZF &gt;									
	//        &lt; 1E-018 limites [ 97416758,1548618 ; 136747777,02979 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000244A62F1B32F148E5A &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_5_____Port_Authority_of_St_Petersburg_20250515 &gt;									
	//        &lt; 8UGcZ1c97DC32u8RkLsNU9U8VFO5fzkHucidE64sDgH84aa3Pj5i61dof4L0mx4s &gt;									
	//        &lt; 1E-018 limites [ 136747777,02979 ; 161609547,464551 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000032F148E5A3C3449B6E &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_6_____Surgut_Port_Spe_Value_20250515 &gt;									
	//        &lt; MxRCsQUlOc1dnUR89yejMm3VUD3e2nNFqhM6y4m29ISdT476CenpHHPBDI4ft10X &gt;									
	//        &lt; 1E-018 limites [ 161609547,464551 ; 181738154,473837 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000003C3449B6E43B3E6C8B &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_7_____Taganrog_Port_Authority_20250515 &gt;									
	//        &lt; 5hHEucQGNkI301x20gt04M9sj22ZghU77sbA402MbgnP1aNjv203cBZ4AwO8c85H &gt;									
	//        &lt; 1E-018 limites [ 181738154,473837 ; 222561478,06799 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000043B3E6C8B52E91DF52 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_8_____Tara_Port_Spe_Value_20250515 &gt;									
	//        &lt; VBSU0CdXN993TnfbvEcVv7VE0353colW357810rYib694Ae0Tsyptxx3czm83ieU &gt;									
	//        &lt; 1E-018 limites [ 222561478,06799 ; 241347812,860728 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000052E91DF5259E8B8B5A &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_9_____Temryuk_Port_Authority_20250515 &gt;									
	//        &lt; mzIasnrCk3DN7gqW61zkYpQsAiW3O9GPB7Dt6S4h8T31zVblR3G4k8VqLQ5QGSSg &gt;									
	//        &lt; 1E-018 limites [ 241347812,860728 ; 286188807,503747 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000059E8B8B5A6A9D178E2 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_10_____Tiksi_Sea_Trade_Port_20250515 &gt;									
	//        &lt; vkRd5lc9vwQ617sym4tZlrKYLP9NgRaLRMYWZUKi3h9o309pAF5sSQ76dB335HB8 &gt;									
	//        &lt; 1E-018 limites [ 286188807,503747 ; 304798054,669959 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000006A9D178E2718BCEE0E &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; SEAPORT_Portfolio_III_metadata_line_11_____Tobolsk_Port_Spe_Value_20250515 &gt;									
	//        &lt; wRSgAc7u9737tR1FuoqP4sv411n24z5wzJj962ZE53Y9v6W4LemGmPQmfDJFc4N3 &gt;									
	//        &lt; 1E-018 limites [ 304798054,669959 ; 325878450,352155 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000718BCEE0E796630F9F &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_12_____Tuapse_Port_Authorities_20250515 &gt;									
	//        &lt; ip2vLH3dp1Ba92GE8v96OjbL61sY09p17WwwTN0FG18Ye17Y12zC53kn7sup03hY &gt;									
	//        &lt; 1E-018 limites [ 325878450,352155 ; 361292717,805315 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000796630F9F86978F1D8 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_13_____Tver_Port_Spe_Value_20250515 &gt;									
	//        &lt; Aq5Q9Po2200gW6e6b2t03NL8GFw7JFmbB3b4C0TpTQ994er7EM1YauXiI33IxW01 &gt;									
	//        &lt; 1E-018 limites [ 361292717,805315 ; 395369082,633462 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000086978F1D89349559DB &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_14_____Tyumen_Port_Spe_Value_20250515 &gt;									
	//        &lt; SY0aY8j8i2rmOndg2b03eiH7x1G4yM8n65rTekl2pV2wkEMg0326MC3P049sQ506 &gt;									
	//        &lt; 1E-018 limites [ 395369082,633462 ; 420347407,677249 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000009349559DB9C9774013 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_15_____Ufa_Port_Spe_Value_20250515 &gt;									
	//        &lt; L4v5xA9MHZ32pZDV9qy01iPa77End75530ap7IE3E6J272VCqf6empc09WYBj39q &gt;									
	//        &lt; 1E-018 limites [ 420347407,677249 ; 462027798,80836 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000009C9774013AC1E67ADC &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_16_____Uglegorsk_Port_Authority_20250515 &gt;									
	//        &lt; oL3NYWz1e51A0D2zh322D07ieo9gKBGJP3YUx1QfBuo9vnvPmO4XFLevcYhXgx42 &gt;									
	//        &lt; 1E-018 limites [ 462027798,80836 ; 502237837,104432 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000AC1E67ADCBB1922112 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_17_____Ulan_Ude_Port_Spe_Value_20250515 &gt;									
	//        &lt; Lv74GT72ohrtHeJEn89Z4B3Y4fOIcR50X8364B3xJM4Gs568mOVC8PMIuMO1KyD1 &gt;									
	//        &lt; 1E-018 limites [ 502237837,104432 ; 520875103,568488 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000BB1922112C20A85748 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_18_____Ulyanovsk_Port_Spe_Value_20250515 &gt;									
	//        &lt; 84GW3dV0XuhV4Jak0oq2MLkWew6zBiFe3OUVFQ6r09kV9k2WJO66q4jlWRS3FsoR &gt;									
	//        &lt; 1E-018 limites [ 520875103,568488 ; 552770599,01717 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000C20A85748CDEC50131 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_19_____Ust_Kamchatsk_Sea_Trade_Port_20250515 &gt;									
	//        &lt; 3tWA9OCwOKFe6y1L5NrVDJ4rh0406V38xm6E2atggMI22cilcz46m8CYZ1PO4GuL &gt;									
	//        &lt; 1E-018 limites [ 552770599,01717 ; 587907385,448652 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000CDEC50131DB0337C64 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_20_____Ust_Luga_Sea_Port_20250515 &gt;									
	//        &lt; 5As75P0g4be7PW4e9Zn7J56DOFW4H0xDj1w9r54nchEc9Ca6xqVa8j503vtH8N3E &gt;									
	//        &lt; 1E-018 limites [ 587907385,448652 ; 613230699,671525 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000DB0337C64E4723CC03 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; SEAPORT_Portfolio_III_metadata_line_21_____Vanino_Port_Authority_20250515 &gt;									
	//        &lt; 39aulGJyRds06AFT7h4wRrtybJoyh3VY1o4qwPH6w7y9yQdEEF9LkFRiZ2X7bEDo &gt;									
	//        &lt; 1E-018 limites [ 613230699,671525 ; 640293991,473941 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000E4723CC03EE8731A5F &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_22_____Central_Office_of_the_Port_Vitino_20250515 &gt;									
	//        &lt; HNG2jKb45O3L11Pd6L6vI0tsOWWSiWL2917u8v2gfBqz1819mpwdN4U3I4Ims9GM &gt;									
	//        &lt; 1E-018 limites [ 640293991,473941 ; 660992415,885237 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000EE8731A5FF63D26468 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_23_____The_Commercial_Port_of_Vladivostok_JSC_20250515 &gt;									
	//        &lt; 9zM1rnfY7vE6iI6bm4zDML3lw3pBbq9aEgPfMDQmb5uEJ1G8FuC5KZ4U14r2Ju8B &gt;									
	//        &lt; 1E-018 limites [ 660992415,885237 ; 683795047,249155 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000F63D26468FEBBC7248 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_24_____Volgodonsk_Port_Spe_Value_20250515 &gt;									
	//        &lt; r05hMwcuypt87uPYC18Ho34Z3sN5cjzVC7ju30r94aXGDVcc1h33ZEPwruEP7blm &gt;									
	//        &lt; 1E-018 limites [ 683795047,249155 ; 703376088,063585 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000FEBBC7248106072BE5A &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_25_____Volgograd_Port_Spe_Value_20250515 &gt;									
	//        &lt; 9D54iqqWQS54yK1y2V1F170MnTVoOSVDX88yBmBrO49M0AOVX8Ymj3XhZ4T36i25 &gt;									
	//        &lt; 1E-018 limites [ 703376088,063585 ; 731646315,773686 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000106072BE5A1108F3B00D &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_26_____Vostochny_Port_Joint_Stock_Company_20250515 &gt;									
	//        &lt; lR9M5NbL836b6w5LHQJS57c9PWlx1Qp63fTRXjctzLI7h9qk40441sS3Ap97y7Zr &gt;									
	//        &lt; 1E-018 limites [ 731646315,773686 ; 780063148,45697 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001108F3B00D122989E951 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_27_____Vyborg_Port_Authority_20250515 &gt;									
	//        &lt; F24J8d041LE7XWQ2zNZo1Fw51936xt4n9I32BtBjGXe6tIRLLEBJU0LX64H8auhs &gt;									
	//        &lt; 1E-018 limites [ 780063148,45697 ; 829618161,684538 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000122989E9511350E8DC5C &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_28_____Vysotsk_Marine_Authority_20250515 &gt;									
	//        &lt; QGiqn7rhKaF71L7264mG0LsN4n5lS3o1p56SoLZ30uUFcbtOD7ahRDOHUUeW5eJN &gt;									
	//        &lt; 1E-018 limites [ 829618161,684538 ; 858789215,737113 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001350E8DC5C13FEC85B59 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_29_____Yakutsk_Port_Spe_Value_20250515 &gt;									
	//        &lt; 9Zak1LcP7Ry6xyk8X2HR8GtDm8jFy6Bf0lfSNY6H1R318Pw8N94mMD3TgddeYTZP &gt;									
	//        &lt; 1E-018 limites [ 858789215,737113 ; 877520452,855942 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000013FEC85B59146E6DF4D9 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_30_____Yaroslavl_Port_Spe_Value_20250515 &gt;									
	//        &lt; 5six2Pnpiexpjh2VbtkoVz2eXW64ffr7lf43f6u8vO2TC5ESQFkre8Wbt5G29Jfq &gt;									
	//        &lt; 1E-018 limites [ 877520452,855942 ; 895890545,002664 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000146E6DF4D914DBEC7E18 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; SEAPORT_Portfolio_III_metadata_line_31_____JSC_Yeysk_Sea_Port_20250515 &gt;									
	//        &lt; pTfIoP5B71IjOIDy7STbd93z2TTvWZ6Bo1yi2qUs71qKl0x6WBTRZAf4KtPW7KZ9 &gt;									
	//        &lt; 1E-018 limites [ 895890545,002664 ; 934213684,631552 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000014DBEC7E1815C058F683 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_32_____Sea_Port_Zarubino_20250515 &gt;									
	//        &lt; 35iRQRc7d4oqehkoE2H0mDTwAp56Z0Hkc0Pud1355dAhgBW9cfh5W7Dj7bxKX8Wt &gt;									
	//        &lt; 1E-018 limites [ 934213684,631552 ; 959658988,283161 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000015C058F6831658036A40 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_33_____Sevastopol_Marine_Trade_Port_20250515 &gt;									
	//        &lt; 4JMz36v5PCfa2a5D9t5pVee9uj2a91K2uwu66pd7jwC4BtUFZ2I1NAGH5u3975aW &gt;									
	//        &lt; 1E-018 limites [ 959658988,283161 ; 985045862,526475 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001658036A4016EF54B600 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_34_____Sevastopol_Port_Spe_Value_20250515 &gt;									
	//        &lt; avvhK50jO2100iyoD90rtiztQk2jM3taYJu276ztIL7L3Q3SsyceeB3I6Pb3hO1V &gt;									
	//        &lt; 1E-018 limites [ 985045862,526475 ; 1032997479,62945 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000016EF54B600180D25126E &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_35_____Kerchenskaya_Port_Spe_Value_20250515 &gt;									
	//        &lt; cic5VJFMi81xaZj32KX2RyUUYOxcl8zF9JSgfTE5cfkSnRVK4r4PT28pBUfg7t9Q &gt;									
	//        &lt; 1E-018 limites [ 1032997479,62945 ; 1070357995,06771 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000180D25126E18EBD4B1C6 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_36_____Kerch_Port_Spe_Value_20250515 &gt;									
	//        &lt; D6x4v1q911564i9Rrq5JafT2sI0n3bO3n4MTCXCC7VgvI5Tmd4KS8I0F3J3iJ4cS &gt;									
	//        &lt; 1E-018 limites [ 1070357995,06771 ;  ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000018EBD4B1C619F59EB05B &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_37_____Feodossiya_Port_Spe_Value_20250515 &gt;									
	//        &lt; Z3bE0OY4xv7yjGv7guebeSCVzTM7203t7ESbk2FYFuxI54946y1WmxbO612vDz7N &gt;									
	//        &lt; 1E-018 limites [ 1114949996,557 ; 1133401209,07297 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000019F59EB05B1A6399013F &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_38_____Yalta_Port_Spe_Value_20250515 &gt;									
	//        &lt; 50bSWARbOkzihMKN3IO7g68xe9jsNnd74e6L27GVyyEw9fFV9JPmz98BN2SICuw3 &gt;									
	//        &lt; 1E-018 limites [ 1133401209,07297 ; 1151185727,68806 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001A6399013F1ACD9A06D4 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_39_____Vidradne_Port_Spe_Value_20250515 &gt;									
	//        &lt; So3gwQ0q543zXBPdte61LQR0Fyr5y7gMjPkyXnq0MK06h3Ret7d17D0y7e634sKw &gt;									
	//        &lt; 1E-018 limites [ 1151185727,68806 ; 1171897491,37218 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001ACD9A06D41B490DAB85 &gt;									
	//     &lt; SEAPORT_Portfolio_III_metadata_line_40_____Severodvinsk_Port_Spe_Value_20250515 &gt;									
	//        &lt; EIlp4lJNYvWhXgSGfW9116Ta4pi97r0f4s08nIb933w154A2C7ze9W3cbo41R4Tc &gt;									
	//        &lt; 1E-018 limites [ 1171897491,37218 ; 1212351653,64926 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001B490DAB851C3A2DD2A8 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
	}
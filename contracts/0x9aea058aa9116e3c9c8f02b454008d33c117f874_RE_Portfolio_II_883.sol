pragma solidity 		^0.4.21	;						
										
	contract	RE_Portfolio_II_883				{				
										
		mapping (address =&gt; uint256) public balanceOf;								
										
		string	public		name =	&quot;	RE_Portfolio_II_883		&quot;	;
		string	public		symbol =	&quot;	RE883II		&quot;	;
		uint8	public		decimals =		18			;
										
		uint256 public totalSupply =		1546798683705000000000000000					;	
										
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
	//     &lt; RE_Portfolio_II_metadata_line_1_____Allianz_SE_20250515 &gt;									
	//        &lt; aD6659uLmi5A3u43fpHdW3jo6Md642TsTt4rbMDO56c03aI1zCRtFrWlr3b70RVW &gt;									
	//        &lt; 1E-018 limites [ 1E-018 ; 78550116,981511 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000000000001D431F966 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_2_____Allianz_SE_AA_Ap_20250515 &gt;									
	//        &lt; 3t3sYFCF153lY8Jj1yjgwmV80Ib4e9SX8dp277Fji7m7Iua73dNzFH4ERqF29fIo &gt;									
	//        &lt; 1E-018 limites [ 78550116,981511 ; 93956046,2773862 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000001D431F966230058E87 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_3_____Allianz_Suisse_Versich_AAm_m_20250515 &gt;									
	//        &lt; M4R45Sq8qxZq0o98MYjbzQXi9x4ma2VkxwO5T4Ss8lqd9LgPxcqCbsd7Gys4bdn7 &gt;									
	//        &lt; 1E-018 limites [ 93956046,2773862 ; 157595717,514915 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000230058E873AB57FD1B &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_4_____Allied_World_Assurance_Co_A_20250515 &gt;									
	//        &lt; zXFdwOHE246ISr988J3160nrD5d85Cm8wI80XrRqNZgIF4QVc6Vp2S5T79msP3Iz &gt;									
	//        &lt; 1E-018 limites [ 157595717,514915 ; 175387761,620715 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000003AB57FD1B415647E56 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_5_____Allied_World_Assurance_Company_Holdings_AG_20250515 &gt;									
	//        &lt; bSF21r77gJ82H2IL2s6l21sI7AC1S8T6e2wg776L3TX1b7x860y8dFnrR264juGr &gt;									
	//        &lt; 1E-018 limites [ 175387761,620715 ; 215213125,864114 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000415647E56502C52D3E &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_6_____Allied_World_Managing_Agency_Limited_20250515 &gt;									
	//        &lt; 8f9BBUe1Eq4ixzn04q6Q8MarKfz4Sl9fA22fFQ5O6AL3V0cvW5ukdEf6rpKeW9pL &gt;									
	//        &lt; 1E-018 limites [ 215213125,864114 ; 226148928,258301 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000502C52D3E543F3E30D &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_7_____Allied_World_Managing_Agency_Limited_20250515 &gt;									
	//        &lt; dG64xI6G4e93eF7SaHMN1eib5eq6w97UgLToPRMzUsl04ekLfQ0A5USWOD9N7G1t &gt;									
	//        &lt; 1E-018 limites [ 226148928,258301 ; 301360847,798055 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000543F3E30D704402B1F &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_8_____AlmAhleia_Insurance_Co_SAK_Am_A3_20250515 &gt;									
	//        &lt; S6hiyVDEP7qY8VhPE8Xu6gqmqsIo9UI71f36YZg9UCTbwH25dVcgM0V5iNpE27L0 &gt;									
	//        &lt; 1E-018 limites [ 301360847,798055 ; 329870172,394454 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000704402B1F7AE2DF20B &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_9_____Alterra_Capital_Holdings_Limited_20250515 &gt;									
	//        &lt; eYkpq8985X5Dmf78T7D4wy73KQ5tOsDZgw9Drgkty4j5ovqT6sfr8yoafo44uece &gt;									
	//        &lt; 1E-018 limites [ 329870172,394454 ; 409321953,097704 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000007AE2DF20B987BFBDE1 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_10_____American_Agricultural_insurance_CO_m_Am_20250515 &gt;									
	//        &lt; STWYsk8TCAi88T5c0Phq39IZ1C99L5D0m5HaO4LbPf1e31agive1JE1OIVQ0AZG8 &gt;									
	//        &lt; 1E-018 limites [ 409321953,097704 ; 430334973,954591 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000987BFBDE1A04FF1127 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; RE_Portfolio_II_metadata_line_11_____American_Agricultural_Insurance_Company_20250515 &gt;									
	//        &lt; 7Ld4asiGt25K5JURa1tPGRUM60tWhOJ61tBV401bAPTw7SbXy39B90eTkN20psS3 &gt;									
	//        &lt; 1E-018 limites [ 430334973,954591 ; 476302664,431914 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000A04FF1127B16FC323F &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_12_____American_Home_Assurance_CO_Ap_A_20250515 &gt;									
	//        &lt; AieC7cnSzO4VAL0HQeV7XGfCQdF7mh081VT4w1q00wa014K78Z9B9B3ZWo69NQXG &gt;									
	//        &lt; 1E-018 limites [ 476302664,431914 ; 487031305,818764 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000B16FC323FB56EECDC9 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_13_____American_International_Group__Chartis__Am_BBB_20250515 &gt;									
	//        &lt; 4Y09lwNUnh1I1vM199OLr52hW0xPKNpq6GYUb1csvV1Q3pjJohHt9NVwW8r5G452 &gt;									
	//        &lt; 1E-018 limites [ 487031305,818764 ; 511039276,250391 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000B56EECDC9BE6080F3D &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_14_____American_Life_InsurancemDelaware_AAm_20250515 &gt;									
	//        &lt; s8Y3JGlD1zFPmyD7J29IApZC5Px6d8emgdqBQLc7SLGRMBUu61xkVoGW9UjqLUa7 &gt;									
	//        &lt; 1E-018 limites [ 511039276,250391 ; 539816850,735835 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000BE6080F3DC918F2745 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_15_____American_Re_20250515 &gt;									
	//        &lt; vp5FO57Sm9OdrzZqKbNL1lp1v4H7LP34JL4zX852YfkH0K7Ss3Vug7G0WN8cKsT6 &gt;									
	//        &lt; 1E-018 limites [ 539816850,735835 ; 554809069,609304 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000C918F2745CEAEB76C4 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_16_____American_Re_20250515 &gt;									
	//        &lt; zAr3f7226e8VWqHT0rM0Ab0YBqQJlo986TN10IGrIqhA4lM67W9PbgynQ9zlKv5b &gt;									
	//        &lt; 1E-018 limites [ 554809069,609304 ; 604153363,238962 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000CEAEB76C4E1108E177 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_17_____Amlin_AG_A_m_20250515 &gt;									
	//        &lt; 9cz8d8VF27PLPb7rF52r2PBmT3iyI6SY47FHqQMdZsd8O90uG4t3OI4K9Ne4dgl8 &gt;									
	//        &lt; 1E-018 limites [ 604153363,238962 ; 616365063,076824 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000E1108E177E59D274B7 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_18_____Amlin_Underwriting_Limited_20250515 &gt;									
	//        &lt; YB5jC0gD9Bd7gLq1JJhEwX64x9beqLN84zf7RZ6Xj1TRL3qipg3g1uDTok0Jk94y &gt;									
	//        &lt; 1E-018 limites [ 616365063,076824 ; 694824910,429081 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000E59D274B7102D7AAE96 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_19_____Amlin_Underwriting_Limited_20250515 &gt;									
	//        &lt; dK7jv4pXHQX3YUj36xVJ37giQv0MTMnvMAw2J8VAF8I625mMn94714cS8I27B99e &gt;									
	//        &lt; 1E-018 limites [ 694824910,429081 ; 729038041,376321 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000102D7AAE9610F967C6DD &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_20_____AmTrust_at_Lloyd_s_Limited_20250515 &gt;									
	//        &lt; kqNe40Gywy3hKBuuMh5PISVf9jeNY3GIgp569JvlS9fVVKUL7YJ6H5Il3KhpURex &gt;									
	//        &lt; 1E-018 limites [ 729038041,376321 ; 746233257,528246 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000010F967C6DD115FE5982C &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; RE_Portfolio_II_metadata_line_21_____AmTrust_at_Lloyd_s_Limited_20250515 &gt;									
	//        &lt; AI2lvL0o44Z62Ub7aD7dNZ22s9s6LD08h0M93GPrC5bOQsc3jXdHTsD8Y34uToPN &gt;									
	//        &lt; 1E-018 limites [ 746233257,528246 ; 768580992,981868 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000115FE5982C11E5198856 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_22_____AmTrust_at_Lloyd_s_Limited_20250515 &gt;									
	//        &lt; 8ioQp28s9WRwx6TmT21qzu9x2MYi7LR26na031Tjgwt90cyTG4OFjR6Ow4aPIACv &gt;									
	//        &lt; 1E-018 limites [ 768580992,981868 ; 806646950,959609 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000011E519885612C7FD932B &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_23_____AmTrust_Syndicates_Limited_20250515 &gt;									
	//        &lt; 6i89KU5mXejg0jj4GW9k84ZS5N1Rx5H8t40uJLUZ40D0rt9sWzzC0BUL0ukP2j4e &gt;									
	//        &lt; 1E-018 limites [ 806646950,959609 ; 837377152,317488 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000012C7FD932B137F282413 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_24_____AmTrust_Syndicates_Limited_20250515 &gt;									
	//        &lt; 2O1z6Jq919ge54SWslke0jG6lgzHcQoj0i00gd3HZ6ld6Lb8lC51gMjm7yawqF04 &gt;									
	//        &lt; 1E-018 limites [ 837377152,317488 ; 912708164,125266 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000137F28241315402A2490 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_25_____AmTrust_Syndicates_Limited_20250515 &gt;									
	//        &lt; oTB287DUgl7k2TJ6r2I4ADnoXBgN3046OD2c67MnJJz2APj3Crq75r6I93YN8b7F &gt;									
	//        &lt; 1E-018 limites [ 912708164,125266 ; 936043661,281416 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000015402A249015CB414924 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_26_____AmTrust_Syndicates_Limited_20250515 &gt;									
	//        &lt; jfrvR6K3F3vk4mCx003JvtU1P0pzfCf8T8hBb7sFh8047A116zCo5y5NCgg2Xdl3 &gt;									
	//        &lt; 1E-018 limites [ 936043661,281416 ; 987754411,910278 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000015CB41492416FF79A11B &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_27_____AmTrust_Syndicates_Limited_20250515 &gt;									
	//        &lt; 910316ef5Q9d69t30iChKQY3O31o0k2cAcfe17i498gPxfGanG0n4TkWsmg95y1n &gt;									
	//        &lt; 1E-018 limites [ 987754411,910278 ; 1041530938,58336 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000016FF79A11B18400218D6 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_28_____AmTrust_Syndicates_Limited_20250515 &gt;									
	//        &lt; 6PZH4i0bWX4DmS73uYXOXB5c5e5IW636394Ti6rEMc7i7V9xn8SbzHln4iLGC1vH &gt;									
	//        &lt; 1E-018 limites [ 1041530938,58336 ; 1119585564,13246 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000018400218D61A114000F1 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_29_____AmTrust_Syndicates_Limited_20250515 &gt;									
	//        &lt; 63843qJO3afqH69Su8oX38TVTvV9IquXMnF8VPP31i3jByrPz3vvt5vOUFP8XofK &gt;									
	//        &lt; 1E-018 limites [ 1119585564,13246 ; 1139150556,08023 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001A114000F11A85DDCFEC &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_30_____AmTrust_Syndicates_Limited_20250515 &gt;									
	//        &lt; vKV34Zi6lN0TEjT7vCWPs7NsedOj0W2Sf7uyhHSOpnh3WDVm6SHXtfM9rcjtA0T0 &gt;									
	//        &lt; 1E-018 limites [ 1139150556,08023 ; 1199582495,60836 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001A85DDCFEC1BEE11A24C &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; RE_Portfolio_II_metadata_line_31_____AmTrust_Syndicates_Limited_20250515 &gt;									
	//        &lt; 8Jix206EZ1N8Ji8qphX49V9vI7pDAf0q8ia5vQR1cL6G9f5S28AV2092vdfymtwc &gt;									
	//        &lt; 1E-018 limites [ 1199582495,60836 ; 1231768407,83365 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001BEE11A24C1CADE97043 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_32_____AmTrust_Syndicates_Limited_20250515 &gt;									
	//        &lt; 1P789e2Gr3Sawjun2VcK6ZDVwx88slnnd2YcKMy6wfZ30wMwViPnkRnYBQ8E1Su0 &gt;									
	//        &lt; 1E-018 limites [ 1231768407,83365 ; 1258806268,71458 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001CADE970431D4F11F0AB &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_33_____Anadolu_Sigorta_20250515 &gt;									
	//        &lt; SrS1GHiwpz61DrSvWPTwrqc5arMO1wyZ0612ujjf6WCL3Wz25kx49TCY21DM6kXa &gt;									
	//        &lt; 1E-018 limites [ 1258806268,71458 ; 1283223875,69213 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001D4F11F0AB1DE09C4065 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_34_____Annuity_and_Life_Re_20250515 &gt;									
	//        &lt; SIQj8xXKlbjnQJ4UWx27gRQ50Jpd19Kw5nOl8AC0qveG5R202D4K3BYAt234JNr1 &gt;									
	//        &lt; 1E-018 limites [ 1283223875,69213 ; 1313911165,01785 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001DE09C40651E978556C9 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_35_____Annuity_and_Life_Re_20250515 &gt;									
	//        &lt; y12Igvd1Pg42DjsYd9pYEN53RrmtvbR67euxE621jVb1Uv0mD3OunwV9N0AZGkb9 &gt;									
	//        &lt; 1E-018 limites [ 1313911165,01785 ; 1337384016,3828 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001E978556C91F236E115A &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_36_____Antares_Managing_Agency_Limited_20250515 &gt;									
	//        &lt; Ej1GF562TWmSmvlH33023bcNPtJSo4U351uGXnu5DZyMb3vmg4rC01sr35i69qHy &gt;									
	//        &lt; 1E-018 limites [ 1337384016,3828 ;  ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001F236E115A21044BE921 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_37_____Antares_Managing_Agency_Limited_20250515 &gt;									
	//        &lt; SN01g365LHxIE6FZW6i8M0Qj6aICkAD9XmC2lnywo9cE4020exikAxozmGRS4gVS &gt;									
	//        &lt; 1E-018 limites [ 1418060040,13825 ; 1438045892,93654 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000021044BE921217B6BE6E1 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_38_____ANV_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; 40stng5KZW5ytKymrA6awYS7F2qLFCRfZhLJnEG1H25968Xt431ZV2tv3NX0uQkz &gt;									
	//        &lt; 1E-018 limites [ 1438045892,93654 ; 1486639903,4223 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000217B6BE6E1229D107A3A &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_39_____ANV_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; Wh791C3b8at1Hq9q3IQwF5FOyV9GIs5G6GNYeeV1Xvz8pyMMxr16N51Ta7RZ8W2T &gt;									
	//        &lt; 1E-018 limites [ 1486639903,4223 ; 1531557907,00135 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000229D107A3A23A8CBE960 &gt;									
	//     &lt; RE_Portfolio_II_metadata_line_40_____ANV_Syndicates_Limited_20250515 &gt;									
	//        &lt; 2ZPnzM8g0JK5xeabBzerVPFV8Eyp583qErdPd6l65x7zL1r070Da8D5rhdLks39C &gt;									
	//        &lt; 1E-018 limites [ 1531557907,00135 ; 1546798683,705 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000023A8CBE9602403A37DC6 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
	}
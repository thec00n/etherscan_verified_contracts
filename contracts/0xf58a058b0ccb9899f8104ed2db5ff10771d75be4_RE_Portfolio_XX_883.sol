pragma solidity 		^0.4.21	;						
										
	contract	RE_Portfolio_XX_883				{				
										
		mapping (address =&gt; uint256) public balanceOf;								
										
		string	public		name =	&quot;	RE_Portfolio_XX_883		&quot;	;
		string	public		symbol =	&quot;	RE883XX		&quot;	;
		uint8	public		decimals =		18			;
										
		uint256 public totalSupply =		1401819335116930000000000000					;	
										
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
	//     &lt; RE_Portfolio_XX_metadata_line_1_____Trust_International_Insurance_&amp;_Reinsurance_Company_BSC__c__Trust_Re_Am_Am_20250515 &gt;									
	//        &lt; 1BXPW0595SF9QK83Y2IU7l4Dfj45M15NVKNaskZ5EN6UeS4qfNG25218BP82PYng &gt;									
	//        &lt; 1E-018 limites [ 1E-018 ; 17455979,3632816 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000000000000680BB7E4 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_2_____Trust_International_Insurance_&amp;_Reinsurance_Company_BSC__c__Trust_Re_Am_Am_20250515 &gt;									
	//        &lt; 1ingNjC0JwHS7gaw9aTpab05xlRKQz3E8ujh1G5R3Ug1T6U89P31ae71jgeKGvjk &gt;									
	//        &lt; 1E-018 limites [ 17455979,3632816 ; 54341746,4883302 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000680BB7E4143E6EEAC &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_3_____TT_Club_Mutual_Insurance_Limited_Am_20250515 &gt;									
	//        &lt; 55SDgre763R03433OU853ZDymgB6D26J1ZHIteJ1mAAm7BIRrkFeQzQI7VXds7At &gt;									
	//        &lt; 1E-018 limites [ 54341746,4883302 ; 79055470,0719512 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000143E6EEAC1D73514F3 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_4_____Tunis_BBm_Societe_Tunisienne_de_Reassurance__Tunis_Re___Tunisia__m_Bp_20250515 &gt;									
	//        &lt; gPryyk021QEC23t3YEeev95461988LE2Lo5EMTZrOW6R2Rw9j4xiwAtAN3Tma6x8 &gt;									
	//        &lt; 1E-018 limites [ 79055470,0719512 ; 107112337,418376 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000001D73514F327E7076C1 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_5_____Tunis_Societe_Tunisienne_de_Reassurance_20250515 &gt;									
	//        &lt; AknNk9EkaiA2B82u0uUVM89p25zXVe9AElkps06Jaex4t0ZvX95L3pg3a8ARwCjG &gt;									
	//        &lt; 1E-018 limites [ 107112337,418376 ; 119668944,053987 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000027E7076C12C9485339 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_6_____UnipolSai_Assicurazioni_SpA_Am_BBB_20250515 &gt;									
	//        &lt; VP9p0Ml8wPAkfA3EYROh3Dt345gKtQO4wt0pvo71sA9zC2npYhJ93f9f3L285XZD &gt;									
	//        &lt; 1E-018 limites [ 119668944,053987 ; 137075938,136415 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000002C9485339331094A49 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_7_____Uniqa_Insurance_Group_Am_20250515 &gt;									
	//        &lt; a3AE039K0t779Og8kc4F01mwGg931XC0UobnjC7sRe10kz1g2F6iK2OH7QkF98sG &gt;									
	//        &lt; 1E-018 limites [ 137075938,136415 ; 175332817,47607 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000331094A4941510A7C7 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_8_____Uniqa_Insurance_Group_Am_20250515 &gt;									
	//        &lt; tQ7XKXQO68d5c2AQ6y5Zv0fSCOyf33nD71gv614dD9QnZY3EZRk7stpmz966jR35 &gt;									
	//        &lt; 1E-018 limites [ 175332817,47607 ; 189214925,284186 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000041510A7C7467CF1224 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_9_____Unity_Reinsurance_Company_Limited_Bp_20250515 &gt;									
	//        &lt; fPHtj1Y5yp2q4Ak0BTTd87g3253hz4RmZ753FjSG4a57S8v6y3hCSgjrUYAl5O6h &gt;									
	//        &lt; 1E-018 limites [ 189214925,284186 ; 230888000,299187 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000467CF1224560332311 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_10_____US_Re_Companies_20250515 &gt;									
	//        &lt; VPn79qupSCM2H6xBB7qk5Bn1VdEAn3GT8sjY5iCxCRUvq0mc9376RbO8lD8em4Y7 &gt;									
	//        &lt; 1E-018 limites [ 230888000,299187 ; 242557494,555415 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000005603323115A5C15F43 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; RE_Portfolio_XX_metadata_line_11_____Validus_Holdings_Limited_20250515 &gt;									
	//        &lt; qpU50owrp5uj0255k5w1FTHO25mhOtjrA1ujmF87M22wl589sS87DgcrqRF13j4u &gt;									
	//        &lt; 1E-018 limites [ 242557494,555415 ; 269895374,280715 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000005A5C15F43648B3AA88 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_12_____VHV_Allgemeine_Versicherung_AG_A_m_20250515 &gt;									
	//        &lt; Ef83dHS9Kw3XolItU6E2qz3J36deNjdQIwqJ8jP74JoTfWZQES8IV3XeuEZNjSix &gt;									
	//        &lt; 1E-018 limites [ 269895374,280715 ; 314645335,085268 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000648B3AA887536EAFF8 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_13_____Vibe_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; 3qi3yaX8otX417xNpMgoNoJKqv9O435OtWkLJAZf6z089BCPFAYDqr4r11yo0SEp &gt;									
	//        &lt; 1E-018 limites [ 314645335,085268 ; 370345979,752079 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000007536EAFF889F6F204B &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_14_____Vibe_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; f0aaSG0GnX0FmxdMz2j3vWWy7Cfw07b0sGcuiDNHmqQaND3d0sm88D5r8FRiyN6B &gt;									
	//        &lt; 1E-018 limites [ 370345979,752079 ; 415432882,292015 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000089F6F204B9AC2C4799 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_15_____Vibe_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; 07LFpeC7XTQ8nyJzCSSI1IBx4uL55A7fC72GG6W98Xv0EhQYCm8n0z1wPqP4Yb7o &gt;									
	//        &lt; 1E-018 limites [ 415432882,292015 ; 464547414,233616 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000009AC2C4799AD0EB1BA3 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_16_____Vienna_Insurance_Group_AG_Wiener_Versicherung_Ap_20250515 &gt;									
	//        &lt; t20f60vSo13SU5mA6A972y7mlDeUp098D3AOIrslCyZ686oaz3B722H2Crp8BPn9 &gt;									
	//        &lt; 1E-018 limites [ 464547414,233616 ; 504507491,180122 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000AD0EB1BA3BBF1958B2 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_17_____Vienna_Insurance_Group_AG_Wiener_Versicherung_Ap_20250515 &gt;									
	//        &lt; p98c9D2PPYKELgY5p185UDeojeXs0x37l91pBP2PjY9o81Z325G50Cm89oTDXhg4 &gt;									
	//        &lt; 1E-018 limites [ 504507491,180122 ; 578394547,253117 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000BBF1958B2D77800BF9 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_18_____Vietnam_BBm_PetroVietnam_Insurance_Corporation__PVI__Bpp_20250515 &gt;									
	//        &lt; U0P3yG4HiJRofgQRN4f7m9E1iF2YU98HM2W3vIuje9HTkRPv1hFe9k6y8iMK3VnZ &gt;									
	//        &lt; 1E-018 limites [ 578394547,253117 ; 606058777,838682 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000D77800BF9E1C64500B &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_19_____W_R_Berkley_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; 7BX859YYk608E34W2y2Q7686L3L9yEbM41fxvPT3Z8FBLfCeWY76Tc5OPTliXP1S &gt;									
	//        &lt; 1E-018 limites [ 606058777,838682 ; 658462063,040519 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000E1C64500BF54BD6154 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_20_____W_R_Berkley_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; fFM1LLTCdN0EfMw2VsXt4mFao8Poy8Uf744m624nLJnThAh1pFkl6wh625Cc334v &gt;									
	//        &lt; 1E-018 limites [ 658462063,040519 ; 697328045,164976 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000F54BD6154103C662998 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; RE_Portfolio_XX_metadata_line_21_____Watkins_Syndicate_20250515 &gt;									
	//        &lt; R76T1XsU2Sa9tCKgfvi7dA1UZB9VvL4Moz55h7yXMAFMt68h61mZ6csNuab7Pi7Q &gt;									
	//        &lt; 1E-018 limites [ 697328045,164976 ; 726790798,707558 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000103C66299810EC02C1B2 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_22_____White_Mountains_Insurance_Group_Limited_20250515 &gt;									
	//        &lt; vQT91gs7w10dCb58w7oMTJwPTk0JSBPtFfy81x9cax8tJp9ExNoRLHjrlN8kaPK2 &gt;									
	//        &lt; 1E-018 limites [ 726790798,707558 ; 749819874,592732 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000010EC02C1B21175465677 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_23_____White_Mountains_Re_Group_Limited_20250515 &gt;									
	//        &lt; 9K7n1NYdNNx1u5wcP20QzAHQp8tf79xPVtJ0m9UU45W4t0ogP6X5xvC9t109f2if &gt;									
	//        &lt; 1E-018 limites [ 749819874,592732 ; 780070079,081868 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000011754656771229947C98 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_24_____Willis_Re_20250515 &gt;									
	//        &lt; 7BuEjBPDQQ6pOjOnAQDOfX70T2qCw05uMwRsr55m5j6CWa26QR3JQ83cfaV5XRGa &gt;									
	//        &lt; 1E-018 limites [ 780070079,081868 ; 841937668,853115 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001229947C98139A56EFD9 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_25_____Wisconsin_Reinsurance_Corporation_20250515 &gt;									
	//        &lt; 360rm1902417F0PBeXYG0byJZ82uIH5706LDAUxj5azpNSdOSDFJS5nf0725DB5C &gt;									
	//        &lt; 1E-018 limites [ 841937668,853115 ; 898960342,172433 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000139A56EFD914EE38A19D &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_26_____Workers_Compensation_Reinsurance_Assoc_20250515 &gt;									
	//        &lt; 3vtfLRQ02ZlJ0n354Qel18fuE8jhTRKvud2mam6TW8m39481JFqVZD4W4WL2H1Wd &gt;									
	//        &lt; 1E-018 limites [ 898960342,172433 ; 952359715,146174 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000014EE38A19D162C819BAE &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_27_____WR_Berkley_Corporation_20250515 &gt;									
	//        &lt; h8395M3gZQwnpRqeKPZKS2Gh93SlA96WrvXxXPpNVlZe1af0Zlw005kAWnk41byA &gt;									
	//        &lt; 1E-018 limites [ 952359715,146174 ; 1002150075,78951 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000162C819BAE175547AB4E &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_28_____Wuerttembergische_versicherung_AG_Am_m_20250515 &gt;									
	//        &lt; S5H6sdl9g54fy47aXNk8XoIjGMGiY102k8rPPm4fHw7vAHrH01Qewknm0rzpymo7 &gt;									
	//        &lt; 1E-018 limites [ 1002150075,78951 ; 1025242796,34135 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000175547AB4E17DEEC5D46 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_29_____XL_Bermuda_Limited_A_A2_20250515 &gt;									
	//        &lt; 0Y987jO3Rs7U4dhjV173BC6Q5V30KA28d699A0r47Cvn8K4Y770CrQ8Q8UPVClm6 &gt;									
	//        &lt; 1E-018 limites [ 1025242796,34135 ; 1098510309,58296 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000017DEEC5D461993A1B7A2 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_30_____XL_Group_Plc_20250515 &gt;									
	//        &lt; 810TUXd563gkI86a3B7YQ7GEXY4g7Uk834ZN2K5Ocbm5BUd9clww45pfcDjiAz67 &gt;									
	//        &lt; 1E-018 limites [ 1098510309,58296 ; 1119428835,35238 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001993A1B7A21A1050DAC3 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; RE_Portfolio_XX_metadata_line_31_____XL_insurance_company_SE_Ap_20250515 &gt;									
	//        &lt; vNGuW3kv8WNAL54CSN67Lqzl9z2dg6y0U0sBfX1rD3k4Mepp5RsVw7l6MoB983s8 &gt;									
	//        &lt; 1E-018 limites [ 1119428835,35238 ; 1138969919,95358 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001A1050DAC31A84CA2EEF &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_32_____XL_London_Market_Limited_20250515 &gt;									
	//        &lt; 3P5voUT3pF4Te862GdLB0VJpHj23PV1C63BV1K3yXY8WusLtF925tQD26G80mHZf &gt;									
	//        &lt; 1E-018 limites [ 1138969919,95358 ; 1173586864,52707 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001A84CA2EEF1B531F72E8 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_33_____XL_Re_20250515 &gt;									
	//        &lt; RNbm1ZLoS9KVLu5VOW8Ug3BER83kZ5Ue5vz1rl03n7zTE6r2DKnATs2F9mkLe1Eb &gt;									
	//        &lt; 1E-018 limites [ 1173586864,52707 ; 1214068413,78663 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001B531F72E81C44696416 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_34_____XL_Re_Limited_m_A2_20250515 &gt;									
	//        &lt; H40s33wAB2ojx52isC26L684sm0oYpEA14016Oy3s099Je8XxsF7UtzRg358VGAK &gt;									
	//        &lt; 1E-018 limites [ 1214068413,78663 ; 1235703534,37391 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001C446964161CC55DF711 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_35_____XL_Reinsurance_20250515 &gt;									
	//        &lt; 7XNH3Vj6d0QA5Tpf41gT76Y506D5f0n4Txv7QEBXoqVZydHVfY85B00PecRlRjsp &gt;									
	//        &lt; 1E-018 limites [ 1235703534,37391 ; 1252742672,52579 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001CC55DF7111D2AEDA068 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_36_____ZEPmRE__PTA_Reinsurance_Company__Bp_20250515 &gt;									
	//        &lt; Tqzmk6D8pnfom0368z5989tVe21cSI2uxE34Dcn26uP1xB2iVB4Uflq842vR5616 &gt;									
	//        &lt; 1E-018 limites [ 1252742672,52579 ;  ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001D2AEDA0681EFAA6C21B &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_37_____Zurich_American_Insurance_Company_Ap_20250515 &gt;									
	//        &lt; 6qY6f82zQeVmj0DFzfbjC9Jg9WRQ4H8xRdM5pp0y7z9ZV34HO8l43f5FjD8JUuOH &gt;									
	//        &lt; 1E-018 limites [ 1330542510,47962 ; 1350126058,04154 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001EFAA6C21B1F6F60E160 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_38_____Zurich_Insurance_Co_Limited_20250515 &gt;									
	//        &lt; 04c4Afib79398Z8R4cYsE6mh81tFa4Y886YDNi23Eia6gGMm9nGfiYMThKKal7n8 &gt;									
	//        &lt; 1E-018 limites [ 1350126058,04154 ; 1365165733,05921 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001F6F60E1601FC9059A6D &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_39_____Zurich_Insurance_Co_Limited_AAm_Ap_20250515 &gt;									
	//        &lt; 0kuQKPEPfh1FFo1l4T88DCNhE1fS41b6cC602h61N1yWp5Na30fZ2d7GD91HEN9u &gt;									
	//        &lt; 1E-018 limites [ 1365165733,05921 ; 1388842492,31882 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001FC9059A6D2056257883 &gt;									
	//     &lt; RE_Portfolio_XX_metadata_line_40_____Zurich_Insurance_plc_AAm_Ap_20250515 &gt;									
	//        &lt; dKDRhqay9Ke447gf6Y1eezTQ25d8rmI6k9lVnWBzbjC7f1zk0YE9MFdUf0pNhj1B &gt;									
	//        &lt; 1E-018 limites [ 1388842492,31882 ; 1401819335,11693 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000205625788320A37E8FBB &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
	}
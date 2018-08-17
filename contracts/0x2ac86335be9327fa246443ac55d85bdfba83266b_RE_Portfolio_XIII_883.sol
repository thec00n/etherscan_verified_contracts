pragma solidity 		^0.4.21	;						
										
	contract	RE_Portfolio_XIII_883				{				
										
		mapping (address =&gt; uint256) public balanceOf;								
										
		string	public		name =	&quot;	RE_Portfolio_XIII_883		&quot;	;
		string	public		symbol =	&quot;	RE883XIII		&quot;	;
		uint8	public		decimals =		18			;
										
		uint256 public totalSupply =		1298226364411140000000000000					;	
										
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
	//     &lt; RE_Portfolio_XIII_metadata_line_1_____Liberty_Mutual_Insurance_Europe_Limited_A_A_20250515 &gt;									
	//        &lt; Y9hzWK4xv0a3w93w760ydeTGH6uz0c1c34M27yYkALtoHQ5VXH5g9D17xC980v2Z &gt;									
	//        &lt; 1E-018 limites [ 1E-018 ; 51393084,7281305 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000000000013253A1AC &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_2_____Lloyd_s_20250515 &gt;									
	//        &lt; JWuULh7FAcxJ4FkaTlZ2n1911RuL1n8r60460Lg7VzVQ3316kGvTVbckMI5717j4 &gt;									
	//        &lt; 1E-018 limites [ 51393084,7281305 ; 97821150,8737296 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000013253A1AC2470F3D03 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_3_____Lloyd_s_Ap_A_20250515 &gt;									
	//        &lt; 1TPH6WP3x6mYCtYaL8HfWqs703M36o1E565529z53uK06R95C99xzjE1YR6775ge &gt;									
	//        &lt; 1E-018 limites [ 97821150,8737296 ; 146453579,095393 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000002470F3D03368EE6F49 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_4_____Lloyd’s_of_London_20250515 &gt;									
	//        &lt; F7zZMG01Gpaie9aE4yj0STIRRqWuFJ33r5i5l58cchvk7BD7sG6tl3p2oA5orS19 &gt;									
	//        &lt; 1E-018 limites [ 146453579,095393 ; 169616949,512256 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000368EE6F493F2FEEEDB &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_5_____Lloyd’s_of_London_20250515 &gt;									
	//        &lt; 7mDEaLd0wW0fTXG6SQqH6J19O5un8LjrU5358Q7tZ3n4CN46HFXE740X9Jf65kuD &gt;									
	//        &lt; 1E-018 limites [ 169616949,512256 ; 201050354,902652 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000003F2FEEEDB4AE5A80D6 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_6_____Lloyds_America_20250515 &gt;									
	//        &lt; 467iVjI2b6H5MpLAI24k3Q1t0K9H4j6w1MYeJCpQl1yjEFjslIrO6i7gGYojrF8s &gt;									
	//        &lt; 1E-018 limites [ 201050354,902652 ; 217099180,499057 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000004AE5A80D650E031155 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_7_____London_Reinsurance_Group_20250515 &gt;									
	//        &lt; 77PV1inG6041czRkoF68kit80781y7IXhWMS9cWI249c8TcS2xR1ABt267vqaiHB &gt;									
	//        &lt; 1E-018 limites [ 217099180,499057 ; 228807603,033191 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000050E031155553CCB3E3 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_8_____London_Reinsurance_Group_Incorporated_20250515 &gt;									
	//        &lt; dkUVLE3usgHKBa7hQ1w8AWAP26Ft7DBi0m07yh1Mwo3UsXAVOjbK51qenLxT48S2 &gt;									
	//        &lt; 1E-018 limites [ 228807603,033191 ; 292383025,911828 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000553CCB3E36CEBD1973 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_9_____Maiden_Holdings_Limited_20250515 &gt;									
	//        &lt; 269GG16z4NG9Y3zW4PNHy6Sc88blV5v09V5qM72DPEU2T9Z9IsPelpL5rNo74MpT &gt;									
	//        &lt; 1E-018 limites [ 292383025,911828 ; 363145544,202577 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000006CEBD1973874842228 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_10_____Malath_Cooperative_Insurance_&amp;_Reinsurance_Co_20250515 &gt;									
	//        &lt; 5qu0lPdb54w1JsG4HSGn6sNhKMtpf8KO9370Imrp75EXQozZPhQr97pZ2HQx7YdT &gt;									
	//        &lt; 1E-018 limites [ 363145544,202577 ; 386557864,947034 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000874842228900107FF2 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; RE_Portfolio_XIII_metadata_line_11_____Malaysian_National_Reinsurance_Berhad_20250515 &gt;									
	//        &lt; sLE99jjhyu5Dy14FWg0ebb2Jdobi6ae4iYoecv0xc3jukyc6Y3Ls40VgX0Hq9QrP &gt;									
	//        &lt; 1E-018 limites [ 386557864,947034 ; 455447469,473933 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000900107FF2A9AADB1B7 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_12_____Malaysian_re_Am_20250515 &gt;									
	//        &lt; I7r65ZVUNnx6VHbqC49yJQ45GVM8d4Npj1SvIvg6uXZ8cxpDp9qm02sxbjLi6HuA &gt;									
	//        &lt; 1E-018 limites [ 455447469,473933 ; 469777908,049343 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000A9AADB1B7AF0183548 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_13_____Malta_Am_QEL_Qic_Europe_Limited__A_20250515 &gt;									
	//        &lt; 38HfWX7CFVziVqu17e2wy2WPA93HrDQs60qk6LI4x9QY5xKbhXkYt3804DZ0i1fj &gt;									
	//        &lt; 1E-018 limites [ 469777908,049343 ; 526147269,806712 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000AF0183548C40150738 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_14_____Managed_Care_Resources_20250515 &gt;									
	//        &lt; Wx6AV4m38AWB1955G64SKvoBF6ze66wSL6b9l783Gg6et5Nnt1BAAN3Ccfg4x8O2 &gt;									
	//        &lt; 1E-018 limites [ 526147269,806712 ; 551190581,500673 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000C40150738CD55A16DA &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_15_____Managing_Agency_Partners_Limited_20250515 &gt;									
	//        &lt; Wo4PmF8WrQqP5xv8ao4hc3pVzZ4FDNnMbn2Op1D0PVU2ssvw3E7VKp3P86azn7Wx &gt;									
	//        &lt; 1E-018 limites [ 551190581,500673 ; 595126874,501715 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000CD55A16DADDB3B8D4E &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_16_____Managing_Agency_Partners_Limited_20250515 &gt;									
	//        &lt; qN8ZaR93IX576lvZGxH944zwV158iewwMseFd0H4KiicVUQFqAXjmWC1os0LvWsD &gt;									
	//        &lt; 1E-018 limites [ 595126874,501715 ; 659377643,160504 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000DDB3B8D4EF5A3271D0 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_17_____Managing_Agency_Partners_Limited_20250515 &gt;									
	//        &lt; QV62kR335nhgEreK8nFS8Hk1rv8jq4UoxE3DHkMNajKb9lIJmIjZ4XO48w30X2i5 &gt;									
	//        &lt; 1E-018 limites [ 659377643,160504 ; 671598294,797248 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000F5A3271D0FA309ADDB &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_18_____Managing_Agency_Partners_Limited_20250515 &gt;									
	//        &lt; dHLnx3JPEnxi55U7Uq8Qug5Rr51CIEaBgWQ3O8g8w6NPmW8Gh9JzUmZ5Q8TeIyh3 &gt;									
	//        &lt; 1E-018 limites [ 671598294,797248 ; 704760652,687265 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000FA309ADDB1068B36BE8 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_19_____Managing_Agency_Partners_Limited_20250515 &gt;									
	//        &lt; 7b3wpcX1LQPz6W1Y7g0ly6ViO0LXX38P6ftaBjKBu6zO7uUBfTOx1ulIb4KSyUmn &gt;									
	//        &lt; 1E-018 limites [ 704760652,687265 ; 740179625,983674 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001068B36BE8113BD07C5A &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_20_____Manulife_Financial_Corporation_20250515 &gt;									
	//        &lt; 3bw0FSzSpw9S4LPI5ZWMex803X0TbAR732GR9zSZMQL11q26Y59EFZIjkdD6yDho &gt;									
	//        &lt; 1E-018 limites [ 740179625,983674 ; 754327021,542943 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000113BD07C5A119023B2BE &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; RE_Portfolio_XIII_metadata_line_21_____Mapfre_Genel_Sigorta_AS_AA_20250515 &gt;									
	//        &lt; 2LI3cXf9hQ5ILI48Rkg43k39gN284UStLrlIyTYF389f10VFKaj3Up4Q4Xs72TMX &gt;									
	//        &lt; 1E-018 limites [ 754327021,542943 ; 781822658,285778 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000119023B2BE123406B5D8 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_22_____MAPFRE_RE_Compania_de_Reaseguros_SA_20250515 &gt;									
	//        &lt; 9Ha0sT2u2s3S55NR96zB0l9Kr53XYEA955MS9kt1DQW2GH0h1428aw9YWXOKy0l2 &gt;									
	//        &lt; 1E-018 limites [ 781822658,285778 ; 794112777,039916 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000123406B5D8127D47F17B &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_23_____MAPFRE_RE,_Compania_de_Reaseguros,_SA_A_A_20250515 &gt;									
	//        &lt; 3i813i8sQ760Dox9QFK5v7Gk13y2wAVVm115IWBZt5TN60e3qb27zZcCt4yhYlI4 &gt;									
	//        &lt; 1E-018 limites [ 794112777,039916 ; 811605927,269188 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000127D47F17B12E58C5F4A &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_24_____Markel_Corporation_20250515 &gt;									
	//        &lt; Nq5M6sh22c7E5yKwta4EBBQyWys84345brSl1nk5Nvj91jgIq9AVE01C5JK5l8iO &gt;									
	//        &lt; 1E-018 limites [ 811605927,269188 ; 836674378,216654 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000012E58C5F4A137AF7CAF1 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_25_____Markel_Europe_plc_m_Ap_20250515 &gt;									
	//        &lt; KFK553QUifnIC72F00yT2JZBmKbn98CdBKOYu7PCjH3e2xxbwXcVZFqbq1KywJVN &gt;									
	//        &lt; 1E-018 limites [ 836674378,216654 ; 864284830,175732 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000137AF7CAF1141F89FFBD &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_26_____Markel_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; vzEBp94jr9XO2FZ0giCVGedM0SHuf8UDoFX97HytI5o4jiQdp2v6x10o848pLseM &gt;									
	//        &lt; 1E-018 limites [ 864284830,175732 ; 893785840,70027 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000141F89FFBD14CF60F7FA &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_27_____Markel_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; VMgs1YKjAk6L2w3dre1s0hMVBXi1m48dxFre52duBl99EVzhe9785EM1eBTBuqhV &gt;									
	//        &lt; 1E-018 limites [ 893785840,70027 ; 926682194,100706 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000014CF60F7FA159374D206 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_28_____Markel_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; XRfE9eIZ2uAJf8g39dVXLTrdWbI5a5D6SKlFU8KnB7NT64E83H9SviY44k7bx2b1 &gt;									
	//        &lt; 1E-018 limites [ 926682194,100706 ; 956127688,115235 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000159374D2061642F7141F &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_29_____Marketform_Managing_Agency_Limited_20250515 &gt;									
	//        &lt; Jl1kMdo6c1XA7ZaZ8Sji3OK9PTrgm44FoO6DN96pRmHs2mA115vASnNcByU4eR7N &gt;									
	//        &lt; 1E-018 limites [ 956127688,115235 ; 971897280,708902 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001642F7141F16A0F5913A &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_30_____Max_Re_20250515 &gt;									
	//        &lt; Y0o6FJf0VeboDRx45a57Qyxl92ajx3ORok1PHwYiT6lV6d8YWiXq5U61tC78tND5 &gt;									
	//        &lt; 1E-018 limites [ 971897280,708902 ; 997719459,970261 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000016A0F5913A173ADF1601 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; RE_Portfolio_XIII_metadata_line_31_____MetLife_Insurance_Company_USA_MICUSA__Ap_20250515 &gt;									
	//        &lt; i9mK50c7mY37yNsFwea0JNSSK7981bSnH51CfB281s30527HOXqbpHcnkGbsN4zN &gt;									
	//        &lt; 1E-018 limites [ 997719459,970261 ; 1034934500,53727 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000173ADF16011818B0BB39 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_32_____MetLife_Investors_USA_insurance_Company_Ap_Ap_20250515 &gt;									
	//        &lt; 0CTM8HXnNYz1k7Lff6EDS7f8O36jGoV8tB4Mn80RX4hn6u0aSzVhuil7sp95dbzY &gt;									
	//        &lt; 1E-018 limites [ 1034934500,53727 ; 1049364589,86927 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001818B0BB39186EB34CDE &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_33_____Mexico_BBBp_Reaseguradora_Patria,_SA__Patria_Re__A_20250515 &gt;									
	//        &lt; MH3YXEq215G556R6G4PcapD3uNnlqpN6YS6beY9hIT9TSJ82R0H06uiG3KFi5F9q &gt;									
	//        &lt; 1E-018 limites [ 1049364589,86927 ; 1059911684,60012 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000186EB34CDE18AD90E3C0 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_34_____Middle_East_Insurance_Bpp_20250515 &gt;									
	//        &lt; XX4e7Gu4VJh6ZmNc3zkQ6lcZZQML016Lxb1S8CmxV9zppQ702f7iZMX1mRRh12TA &gt;									
	//        &lt; 1E-018 limites [ 1059911684,60012 ; 1128993871,3548 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000018AD90E3C01A4953F0F3 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_35_____Milli_Re_Bp_20250515 &gt;									
	//        &lt; 5n8j4g5P08l5s1vjyz317UzQI1svkhF0ys9fQbk7U03k5u9pqe4h131jOW660q8k &gt;									
	//        &lt; 1E-018 limites [ 1128993871,3548 ; 1143905766,11543 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001A4953F0F31AA235AFD7 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_36_____Mitsui_Sumitomo_Ins_Co_Limited_Ap_Ap_20250515 &gt;									
	//        &lt; NSEW31NW2LjJExG85P0SnjeN2xhA3Cem5ig9D3Rx7X9V34qYL6KGDot1WBBiSM70 &gt;									
	//        &lt; 1E-018 limites [ 1143905766,11543 ;  ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001AA235AFD71BE03666E9 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_37_____Mitsui_Sumitomo_Insurance_Underwriting_at_Lloyd_s_Limited_20250515 &gt;									
	//        &lt; 6DGM3lGlz461B91q0IYHzEc7GfcKds3YR1Q0y1r52E0e9W3GDT8a4ZzG54G8d6TX &gt;									
	//        &lt; 1E-018 limites [ 1197257781,65277 ; 1214596240,38686 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001BE03666E91C478ECA5A &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_38_____MMA_IARD_Assurances_Mutuelles_Ap_20250515 &gt;									
	//        &lt; 7up8cVPZ7km2XPns4SEW9Rj3nNOT9Cc4QtQpy2v3QdGKHE9403SjjNpIUCIQ4K1e &gt;									
	//        &lt; 1E-018 limites [ 1214596240,38686 ; 1227689017,60894 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001C478ECA5A1C9598C874 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_39_____MNK_Re_Limited__UK__20250515 &gt;									
	//        &lt; xQHLIfZFKgw7C9F3O9Y9FX5TvU5apWc8S7RN7T5AqXfD1om89Wn186Yg1TC7iwWs &gt;									
	//        &lt; 1E-018 limites [ 1227689017,60894 ; 1285206261,6574 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001C9598C8741DEC6D21E9 &gt;									
	//     &lt; RE_Portfolio_XIII_metadata_line_40_____Montpelier_Re_Holdings_Limited_20250515 &gt;									
	//        &lt; 051I8hrsPBZVX47054Nd7O6tla9GBI830qbOuW2O97mHnghMSX5z1cF6Cj5jnznD &gt;									
	//        &lt; 1E-018 limites [ 1285206261,6574 ; 1298226364,41114 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001DEC6D21E91E3A083B8D &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
	}
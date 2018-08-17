pragma solidity 		^0.4.21	;						
										
	contract	RE_Portfolio_XIX_883				{				
										
		mapping (address =&gt; uint256) public balanceOf;								
										
		string	public		name =	&quot;	RE_Portfolio_XIX_883		&quot;	;
		string	public		symbol =	&quot;	RE883XIX		&quot;	;
		uint8	public		decimals =		18			;
										
		uint256 public totalSupply =		1340600412721820000000000000					;	
										
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
	//     &lt; RE_Portfolio_XIX_metadata_line_1_____Thai_Reinsurance_Public_Company_20250515 &gt;									
	//        &lt; 6Xacg7qV0pmlCK86Ui8D1EfJYJT7KZ1E5GjoyNG0g6H6Kd3vsx473XyG3Y4nH61l &gt;									
	//        &lt; 1E-018 limites [ 1E-018 ; 36864781,5976893 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000000000000DBBB3343 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_2_____Thailand_Asian_Re_20250515 &gt;									
	//        &lt; xz0s9bTrz7RR5756aBtCnB1A1F9zEzWe0X1218w8v16rByDe50700Nn59E2k4el1 &gt;									
	//        &lt; 1E-018 limites [ 36864781,5976893 ; 63941863,4799876 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000DBBB334317D1F8C5F &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_3_____Thailand_BBBp_Asian_Re_m_Bp_20250515 &gt;									
	//        &lt; jdtil5D7nt3SuLJL2cg35xTx1NpnjBq3vZUwWckm7KaNbPW0peDYV1219fJY0JRc &gt;									
	//        &lt; 1E-018 limites [ 63941863,4799876 ; 111148150,472025 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000017D1F8C5F2967EA03B &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_4_____The_Channel_Managing_Agency_Limited_20250515 &gt;									
	//        &lt; 6U5Jv83h0rFK15oF15i0hSEiEQ7XfI1E047155jxuL0DsLlb0p8Hx6K41ZElNO71 &gt;									
	//        &lt; 1E-018 limites [ 111148150,472025 ; 183167663,472869 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000002967EA03B443C3AE7F &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_5_____The_Channel_Managing_Agency_Limited_20250515 &gt;									
	//        &lt; TEtY8u1g3o714Cq066z3i6Rzj082U4e8nluoBYdvqFY91So7hTyI64r885EMuY9Z &gt;									
	//        &lt; 1E-018 limites [ 183167663,472869 ; 232397890,320488 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000443C3AE7F569330BDC &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_6_____The_Fuji_Fire_&amp;_Marine_Insurance_Co_Limited_Ap_m_20250515 &gt;									
	//        &lt; f4ERz1Wp71hM4XmLh4h943qjLr0tFpg4t0K6xvbM41ngAUm15xjN941yvb6peUFN &gt;									
	//        &lt; 1E-018 limites [ 232397890,320488 ; 244050519,202988 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000569330BDC5AEA78C04 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_7_____The_Mediterranean_&amp;_Gulf_Insurance_&amp;_Reinsurance_Company_Am_20250515 &gt;									
	//        &lt; 2n7ULJSoAaWNStOsq2IbEbWIHFY3X7t911a3OaHu695646hdD1RY4ZaD4wuCM4A2 &gt;									
	//        &lt; 1E-018 limites [ 244050519,202988 ; 278787034,066869 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000005AEA78C0467DB34322 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_8_____The_Mediterranean_&amp;_Gulf_Insurance_&amp;_Reinsurance_Company_Am_20250515 &gt;									
	//        &lt; qFHigv1282OK1MR7hXH2bqR5x5MQQfevEz3yyh38N28J2fN36HtwmhMtwpo2v8WS &gt;									
	//        &lt; 1E-018 limites [ 278787034,066869 ; 307072893,163624 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000067DB343227264C0ED8 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_9_____The_New_India_Assurance_Company_Limited_Am_20250515 &gt;									
	//        &lt; 8HW0tn493B8e1Q5L1KK51sOCWSwuHVq6l4323ldxR83XlaMl1a40p2O8R9768nk0 &gt;									
	//        &lt; 1E-018 limites [ 307072893,163624 ; 336339405,065176 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000007264C0ED87D4BD360E &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_10_____The_Oriental_Insurance_Company_Limited_Bpp_20250515 &gt;									
	//        &lt; x7eqCPp3OQna559cM4O53MR0Uebt21rt5J75D7FBk81Oh76ug66P75Q77XuU5q85 &gt;									
	//        &lt; 1E-018 limites [ 336339405,065176 ; 398265421,292264 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000007D4BD360E945D8D025 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; RE_Portfolio_XIX_metadata_line_11_____The_Toa_Reinsurance_Company_Limited_20250515 &gt;									
	//        &lt; C27HZf4FOaVYek5pX71243AS1BkKWRK5EVsbhjLk0FHT23W7N7I514Y9PG1ELvDl &gt;									
	//        &lt; 1E-018 limites [ 398265421,292264 ; 444981485,562693 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000945D8D025A5C4BDEC0 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_12_____Third_Point_Reinsurance_20250515 &gt;									
	//        &lt; fC0h29Rm9ocPohp9k7InnRo2vAz51YIlY88WsYK2c3rhIZ0Q1ZN28fI3jxq9pdkF &gt;									
	//        &lt; 1E-018 limites [ 444981485,562693 ; 506207468,160163 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000A5C4BDEC0BC93B4E34 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_13_____Toa_Re_Co_Ap_Ap_20250515 &gt;									
	//        &lt; 0F6Y2bYEjTQEty18YK1Yf8pU9Fnm7xkFLmDyHQvTFG1n9Ibtxm4C7OgWqT2IXZDZ &gt;									
	//        &lt; 1E-018 limites [ 506207468,160163 ; 552950676,871448 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000BC93B4E34CDFD7C81B &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_14_____Tokio_Marine_Global_Re__Asia_Limited__20250515 &gt;									
	//        &lt; 4Uv7m9mj2c4tYBqpHP6Mdob500N05SIh1oRP2Rfqb2N822HqsuBGP3QmiI4qisfm &gt;									
	//        &lt; 1E-018 limites [ 552950676,871448 ; 585414558,533241 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000CDFD7C81BDA157BBE1 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_15_____Tokio_Marine_Holdings_Incorporated_20250515 &gt;									
	//        &lt; z95bDnU95A92kciV43h5sb2iZ7934ZS2t69z72Jc1Ws4PHAaS31Zh304VCgvB5TN &gt;									
	//        &lt; 1E-018 limites [ 585414558,533241 ; 602538129,447563 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000DA157BBE1E07683AC4 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_16_____Tokio_Marine_Kiln_Syndicates_Limited_20250515 &gt;									
	//        &lt; 6f4g2q9OeJV9c6VVvchEEnxr4Cv378e5yNB4nMrwtdy5V443S05kPc39XTc2HF06 &gt;									
	//        &lt; 1E-018 limites [ 602538129,447563 ; 628991114,826927 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000E07683AC4EA514482E &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_17_____Tokio_Marine_Kiln_Syndicates_Limited_20250515 &gt;									
	//        &lt; iPt6B77Bl3RZ7h77fu88iO7ev488A2DjS4SZZxmencBOcET49Wp81gHOmA16l0E6 &gt;									
	//        &lt; 1E-018 limites [ 628991114,826927 ; 653664998,582608 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000EA514482EF3825A406 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_18_____Tokio_Marine_Kiln_Syndicates_Limited_20250515 &gt;									
	//        &lt; z8tE1C9pT508U5L9E4xTwNDi3807k9JZYk2uuR7i5ac5W8uyjo1tv409yFEjaZsU &gt;									
	//        &lt; 1E-018 limites [ 653664998,582608 ; 665148788,281526 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000F3825A406F7C988360 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_19_____Tokio_Marine_Kiln_Syndicates_Limited_20250515 &gt;									
	//        &lt; F5rbD2A4YFUm3t95c22MgJdko2IWDlDjD15B03u4Bn44nOxqF497Up68poE5l36F &gt;									
	//        &lt; 1E-018 limites [ 665148788,281526 ; 692363511,442255 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000F7C988360101ECEE29C &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_20_____Tokio_Marine_Kiln_Syndicates_Limited_20250515 &gt;									
	//        &lt; 71qm6JMO9DdJ9dokd6M8010L8EP18g8g7QQbWisuxf0SOt3jOjriAgHtTxEPx4t6 &gt;									
	//        &lt; 1E-018 limites [ 692363511,442255 ; 724633371,593046 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000101ECEE29C10DF26C8BB &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; RE_Portfolio_XIX_metadata_line_21_____Tokio_Marine_Kiln_Syndicates_Limited_20250515 &gt;									
	//        &lt; NtO4R5z8Hmq5gyTbb27oq3w879404Q7c7vAGxPb54wIFKgrsHL91QQ319PF7IgNW &gt;									
	//        &lt; 1E-018 limites [ 724633371,593046 ; 797817953,472696 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000010DF26C8BB12935D9807 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_22_____Tokio_Marine_Kiln_Syndicates_Limited_20250515 &gt;									
	//        &lt; b5Vq3e1JmThrk9aVq0BkT6H9rgC5886X04cLS8LKu5Kbn2ethsP01gxK359I9D0M &gt;									
	//        &lt; 1E-018 limites [ 797817953,472696 ; 826159686,009524 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000012935D9807133C4BA54C &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_23_____Tokio_Marine_Kiln_Syndicates_Limited_20250515 &gt;									
	//        &lt; bagbt2n0F5CFG1Aaj6eH5ls5qnElLCnMN0L0P87O765u41AC0ChA93ZFGB6aEPTu &gt;									
	//        &lt; 1E-018 limites [ 826159686,009524 ; 837798262,824859 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000133C4BA54C1381AAB45E &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_24_____Tokio_Marine_Kiln_Syndicates_Limited_20250515 &gt;									
	//        &lt; y6fsIS3j1m8vv4eZ9whZ54VoS8CbFSz16V9QKtZ6xYDrfq6uf0rUxK7DJr1837Mq &gt;									
	//        &lt; 1E-018 limites [ 837798262,824859 ; 856011397,919842 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001381AAB45E13EE39BE43 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_25_____Tokio_Marine_Nichido&amp;_Fire_Ins_Co_Ap_App_20250515 &gt;									
	//        &lt; 75fl1uTS32nKG3OT9Pw5Ot8Y5LAmU43x0kGKoX82k4vnU95Dwztn12G6a3ESuCIk &gt;									
	//        &lt; 1E-018 limites [ 856011397,919842 ; 904493694,143151 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000013EE39BE43150F33DB3A &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_26_____Torus_Underwriting_Management_Limited_20250515 &gt;									
	//        &lt; I12A7dRCEI2meH2ft5Cd6K7U7w9RMpQ3JLSwW1x49X5DEMFh0m0r2AElUyabMIFy &gt;									
	//        &lt; 1E-018 limites [ 904493694,143151 ; 925858141,165202 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000150F33DB3A158E8B6A58 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_27_____Towers_Perrin_Reinsurance_20250515 &gt;									
	//        &lt; P1Gq46BCkvTcbhi1MGYTv588qA2CMse4xLrS9yoB0m1j9tr8l8Zusi31OSX137AP &gt;									
	//        &lt; 1E-018 limites [ 925858141,165202 ; 972670559,352482 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000158E8B6A5816A5917F33 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_28_____Trans_Re_Zurich_Ap_Ap_20250515 &gt;									
	//        &lt; KU27aNuH8Ws1P056Spm5T6l5of15zm5GRkcQ5k5X6dB39S72r2BVPS9U90d31p55 &gt;									
	//        &lt; 1E-018 limites [ 972670559,352482 ; 1003445887,17497 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000016A5917F33175D00EBA1 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_29_____Transamerica_Reinsurance_20250515 &gt;									
	//        &lt; e6moO2T5A1i3E9iR4TVjMr76xI74u0j0STEZb3yx1wXdvv8AMxNaN9CN0q6VxCAK &gt;									
	//        &lt; 1E-018 limites [ 1003445887,17497 ; 1052832072,74501 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000175D00EBA118835E425E &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_30_____Transatlantic_Holdings_Inc_20250515 &gt;									
	//        &lt; 46tMpDbp7q137KJzXfmVY6tyaB1ewU0W5870841Nwz9KQhsQst6iffUEMzL4ZCRw &gt;									
	//        &lt; 1E-018 limites [ 1052832072,74501 ; 1071982514,72323 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000018835E425E18F58383C4 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; RE_Portfolio_XIX_metadata_line_31_____Transatlantic_Holdings_Incorporated_20250515 &gt;									
	//        &lt; mW5qxaV89E18KD5Z2RzfbZu3EwR5By3OFVv5X73vShbWYyk7koUyjR1FwEpGGDgw &gt;									
	//        &lt; 1E-018 limites [ 1071982514,72323 ; 1131282169,57941 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000018F58383C41A56F79B71 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_32_____Transatlantic_Re_Co_Ap_Ap_20250515 &gt;									
	//        &lt; 575zQ849jD7242nj6Bfdze2t4RVPlIVS9olpD2b633ayOnYVJGPT6jfJ071l2RDl &gt;									
	//        &lt; 1E-018 limites [ 1131282169,57941 ; 1148292341,15667 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001A56F79B711ABC5B11B7 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_33_____Transatlantic_Reinsurance_Company_20250515 &gt;									
	//        &lt; 7U4iRcxih6bX09Kc46r4vzWlt7Oqa700Zp4szm674bt6pUMO4rDw1i9khwM8zXf5 &gt;									
	//        &lt; 1E-018 limites [ 1148292341,15667 ; 1167136300,51226 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001ABC5B11B71B2CACAB57 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_34_____TransRe_London_Limited_Ap_20250515 &gt;									
	//        &lt; rsfbdcGB3Ha1l60W97Oj5O39zNmXjI3DKi798W4pv4W00l6U9g0VRy06j8HRrQOC &gt;									
	//        &lt; 1E-018 limites [ 1167136300,51226 ; 1191694904,72507 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001B2CACAB571BBF0E201C &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_35_____Travelers_Companies_inc_Ap_20250515 &gt;									
	//        &lt; LW88do6tS3Tecid7vhspU9uO9Dk71K3u55x93n93IMvH17b4A9MGo8MOPreMo3Xm &gt;									
	//        &lt; 1E-018 limites [ 1191694904,72507 ; 1204457921,47698 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001BBF0E201C1C0B20F187 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_36_____Travelers_insurance_Co_A_20250515 &gt;									
	//        &lt; SAn1Xal1iTdOyy93T1ZWq18iGD31hmoZ9WBSD0pw35dH1JqLLcKJGD4hSnO0O5q8 &gt;									
	//        &lt; 1E-018 limites [ 1204457921,47698 ;  ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001C0B20F1871C8A40B8DB &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_37_____Travelers_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; m33tL2DET1N5IfqkQy1z9Tw2ElQ48E99HZq24kH00Z61SAPff92cyEHoqDTnbj33 &gt;									
	//        &lt; 1E-018 limites [ 1225785812,23849 ; 1245765107,96977 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001C8A40B8DB1D0156B540 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_38_____Travelers_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; D9s016f658m026HP66qaoGlovX72HLUwILoN7uPIeOr28I1ml1ey1E8BejNsS97M &gt;									
	//        &lt; 1E-018 limites [ 1245765107,96977 ; 1280751310,25896 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001D0156B5401DD1DF6A85 &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_39_____Travelers_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; 6U5dHCsHKpsER95yn91gfu5A1r049Vj8eEy74196r8n7WyTLycewi7r3pac7X11E &gt;									
	//        &lt; 1E-018 limites [ 1280751310,25896 ; 1315420823,44311 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001DD1DF6A851EA084E51C &gt;									
	//     &lt; RE_Portfolio_XIX_metadata_line_40_____Triglav_Reinsurance_Co_A_20250515 &gt;									
	//        &lt; iT1Dw4CktA63FFDv2h9wr29Bz3N5zJbRL8uD1F51hVEAB9wpa70Ug744MCBy638t &gt;									
	//        &lt; 1E-018 limites [ 1315420823,44311 ; 1340600412,72182 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001EA084E51C1F3699E62C &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
	}
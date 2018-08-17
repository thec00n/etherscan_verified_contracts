pragma solidity 		^0.4.21	;						
										
	contract	RE_Portfolio_III_883				{				
										
		mapping (address =&gt; uint256) public balanceOf;								
										
		string	public		name =	&quot;	RE_Portfolio_III_883		&quot;	;
		string	public		symbol =	&quot;	RE883III		&quot;	;
		uint8	public		decimals =		18			;
										
		uint256 public totalSupply =		1428500225823590000000000000					;	
										
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
	//     &lt; RE_Portfolio_III_metadata_line_1_____ANV_Syndicates_Limited_20250515 &gt;									
	//        &lt; 7N6Dk8Gio8xncEOjU86Uh11II00P5puMq3Fc36i86mddphNuIBIYN1u7S7mYRC22 &gt;									
	//        &lt; 1E-018 limites [ 1E-018 ; 10463953,2355295 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000000000003E5EBBAF &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_2_____ANV_Syndicates_Limited_20250515 &gt;									
	//        &lt; nbo4oQhdGFkzUwtbC65s53AIcjk8BE677J6872Sr3YBDz938pjo2K4MRHU4jTU29 &gt;									
	//        &lt; 1E-018 limites [ 10463953,2355295 ; 28638065,381621 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000003E5EBBAFAAB23A3E &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_3_____ANV_Syndicates_Limited_20250515 &gt;									
	//        &lt; XV6v2q487c1c4O7hF1BvciLwL45c6hv7JMD72ALctXWuBfmSRuKx05lUcwcSPHDj &gt;									
	//        &lt; 1E-018 limites [ 28638065,381621 ; 43938346,0765835 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000AAB23A3E105E49A63 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_4_____ANV_Syndicates_Limited_20250515 &gt;									
	//        &lt; 4a183zPqOO1nTg3YG0zSt69Uz0W3v8Q80hW4T9oY47z7mH33JdXo4874WF84zcir &gt;									
	//        &lt; 1E-018 limites [ 43938346,0765835 ; 85458105,4915343 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000105E49A631FD5EBA69 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_5_____ANV_Syndicates_Limited_20250515 &gt;									
	//        &lt; LCQZr9IBe7bOhNXvsM14B8uyjXqVOhbgrV92LN4D9E3rXeegVre9pMU2w2S7ams1 &gt;									
	//        &lt; 1E-018 limites [ 85458105,4915343 ; 96433837,1604093 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000001FD5EBA6923ECA5D98 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_6_____Aon_20250515 &gt;									
	//        &lt; kqy3XBkLGp2E6f3YzuMPm5Fsj2Z3ShebHjsk88L3Z2Wfzl6IZu0I3f4A94snERB3 &gt;									
	//        &lt; 1E-018 limites [ 96433837,1604093 ; 112019961,47251 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000023ECA5D9829BB0E767 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_7_____Aon_20250515 &gt;									
	//        &lt; 2ahuAkXqEH62rCeS1FpWVJa3Vjlmb55fzx7iS35wpaPfnudvwl69BBE9k3fsI6pi &gt;									
	//        &lt; 1E-018 limites [ 112019961,47251 ; 145922665,927234 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000029BB0E767365C45354 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_8_____Apollo_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; 5YXy8Vbn0pg4023N37zzA6ILG56Q5o14ldgH5EKU7NIchAzUjFmCPC0FJd3H4ATA &gt;									
	//        &lt; 1E-018 limites [ 145922665,927234 ; 159786968,037229 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000365C453543B8679257 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_9_____Apollo_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; UPkDPODz4MH84pxD2d14Mj69hE5933rniI2FZ70v77s4447iJ8cuPAAm9TeMUrlF &gt;									
	//        &lt; 1E-018 limites [ 159786968,037229 ; 228331531,58341 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000003B8679257550F6467A &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_10_____Apollo_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; c8UPHsc3E90OCtAYzSrY05mh0mJ01OGl731DqbzMG98Il8yj9gW90xmNQ94E3w08 &gt;									
	//        &lt; 1E-018 limites [ 228331531,58341 ; 276044721,837841 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000550F6467A66D5AD36B &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; RE_Portfolio_III_metadata_line_11_____Applied_Insurance_Research_20250515 &gt;									
	//        &lt; g6K6qjv40hKUQyt9p9lBsMkpiq0PwX1bvPIyn6N3E7TWdtmR03E5u3d7U9fmUsJi &gt;									
	//        &lt; 1E-018 limites [ 276044721,837841 ; 337326932,494631 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000066D5AD36B7DAA00EF5 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_12_____Applied_Insurance_Research_20250515 &gt;									
	//        &lt; 42HRRiPC0Dx5iSL9gWuAirUAE4A0Je29OcourgzWy9bCOo65620ov4C39r2d7WdE &gt;									
	//        &lt; 1E-018 limites [ 337326932,494631 ; 371203835,410037 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000007DAA00EF58A48C1C29 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_13_____Arab_Insurance_Group___ARIG___m_Bpp_20250515 &gt;									
	//        &lt; 10NM84q1670n21bK82K9MP71n3FW1KSKw9EH8kpK0eRlfsFY5oQSqBvf4813bIc3 &gt;									
	//        &lt; 1E-018 limites [ 371203835,410037 ; 396159335,174049 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000008A48C1C299394B2E41 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_14_____Arab_Insurance_Group___ARIG___m_Bpp_20250515 &gt;									
	//        &lt; HBiSqP8v3guclVL7e7QVD5mm1Ak9eb9V75bcEnGa897gfB2BK50Kv01hOSL3yaQw &gt;									
	//        &lt; 1E-018 limites [ 396159335,174049 ; 418274267,871409 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000009394B2E419BD1BE3D7 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_15_____Arab_Reinsurance_Company_20250515 &gt;									
	//        &lt; 57Lobqn3rNyOLk1ez5fZxw15SZplJBv6Tl46p7y92pHNe9fzI3b1xUfL7gB4X6Y0 &gt;									
	//        &lt; 1E-018 limites [ 418274267,871409 ; 449471538,13906 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000009BD1BE3D7A770F2589 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_16_____Arab_Reinsurance_Company_20250515 &gt;									
	//        &lt; 66d7FA8SR7H9r4tm7io5YD8t6uGiE06K11gYH2bzQ773J9RZcHssKzLhq4LT5Irs &gt;									
	//        &lt; 1E-018 limites [ 449471538,13906 ; 526891354,690947 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000A770F2589C44846961 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_17_____Arch_Capital_Group_Limited_20250515 &gt;									
	//        &lt; 4MC2JPkO5UhW0ohNg5LYQ8ZvWUD9vqi3W6CFTCAP5881NGeIUgBqP0DIL6iZRt3L &gt;									
	//        &lt; 1E-018 limites [ 526891354,690947 ; 543746402,677441 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000C44846961CA8FB2C7F &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_18_____Arch_Insurance_Co__Europe__Limited_Ap_Ap_20250515 &gt;									
	//        &lt; bCZZBsPc2ZfslYwJkUGL2Glp6qjoJo8V6t6wjTCrC7MMyoqDq1L6wQjPIf21orm1 &gt;									
	//        &lt; 1E-018 limites [ 543746402,677441 ; 557500027,866389 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000CA8FB2C7FCFAF58A56 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_19_____Arch_Re_Ap_Ap_20250515 &gt;									
	//        &lt; sf0UnuHn93zCWF97d1m1qF3XT8Hv8ejL7pKaV1K0vSnAn7uRI730QR5AeCeZdOR7 &gt;									
	//        &lt; 1E-018 limites [ 557500027,866389 ; 591344873,705104 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000CFAF58A56DC4B0AD3E &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_20_____Arch_Underwriting_at_Lloyd_s_Limited_20250515 &gt;									
	//        &lt; 7PC71jged0eJzSi2sf85y5pvY44I27ks2r2vnN1ZI32c1y6Yz7O6f92uOoS30nkj &gt;									
	//        &lt; 1E-018 limites [ 591344873,705104 ; 602495811,294365 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000DC4B0AD3EE0727A83D &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; RE_Portfolio_III_metadata_line_21_____Arch_Underwriting_at_Lloyd_s_Limited_20250515 &gt;									
	//        &lt; Ev7k356sA0k7OcaKvtmFnLG5TfNOE993V51i2Gt4sQi61JGr1a9Jgw8O0gxlw6AP &gt;									
	//        &lt; 1E-018 limites [ 602495811,294365 ; 621583020,855492 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000E0727A83DE78EC6D79 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_22_____ARDAF_Insurance_Reinsurance_20250515 &gt;									
	//        &lt; 3ug4QW2p5182G6V26DF8PeEnMtPUg78M9IxcLtXn8N9f2X525d2CDM0xj73QT0or &gt;									
	//        &lt; 1E-018 limites [ 621583020,855492 ; 694894265,326738 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000E78EC6D79102DE48258 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_23_____ARDAF_Insurance_Reinsurance_20250515 &gt;									
	//        &lt; u69u9LK7m9Bs3K8gbT01XEJd2vqbWt8eE2By2k3yRTr7RaC514Ul6os4FFxTdRtf &gt;									
	//        &lt; 1E-018 limites [ 694894265,326738 ; 768158672,301927 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000102DE4825811E2951F52 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_24_____Argenta_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; C8w9smg406552BYuZcwe9L1n75Y0dEN2L4ItHGZ7no0Vv216991KOH0QvICnc1aT &gt;									
	//        &lt; 1E-018 limites [ 768158672,301927 ; 797316207,671731 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000011E2951F5212905FFD93 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_25_____Argenta_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; vyBX7ps63JuQ5F4A64FfCX00UDr80654X5iLMtP90HGVy1Uy2gjOV8ND32vSTS3Z &gt;									
	//        &lt; 1E-018 limites [ 797316207,671731 ; 818134317,195205 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000012905FFD93130C75E79B &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_26_____Argenta_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; Jh8x2qlgHLPv9vWelF2XA3y579VtUq3lf1AXB44011HceYymJCiw0jqDp9zMxe9k &gt;									
	//        &lt; 1E-018 limites [ 818134317,195205 ; 886687234,532951 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000130C75E79B14A5115AF1 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_27_____Argenta_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; HQrDeJYRbXDZCuKCvNKpEv4v8u2FUFxC2bd0RYn06drp4v6w6tjhpbE3J59FUvDA &gt;									
	//        &lt; 1E-018 limites [ 886687234,532951 ; 913940297,46038 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000014A5115AF11547823AA6 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_28_____Argenta_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; J3IV0Ol36067gCFCfwdd1hwIrJEHH0VRwW1NbnNw3W5ijvG68uvn9Ga4Btlj5ksp &gt;									
	//        &lt; 1E-018 limites [ 913940297,46038 ; 952946516,39597 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001547823AA6163000FEEB &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_29_____Argo_Group_20250515 &gt;									
	//        &lt; t76lq12xousmR1r12y5l08DrI94577J1243KT26t5b4eA16W5ZI49n77gK8jfr1f &gt;									
	//        &lt; 1E-018 limites [ 952946516,39597 ; 983798390,983051 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000163000FEEB16E7E5386E &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_30_____Argo_Group_20250515 &gt;									
	//        &lt; Eb1Y1dr9mVntdpg4PP596g3FX6eIXKJnflcp24543hOfOIQ5J7rwRnSezPyW7W8M &gt;									
	//        &lt; 1E-018 limites [ 983798390,983051 ; 1003707831,53188 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000016E7E5386E175E909DA5 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; RE_Portfolio_III_metadata_line_31_____Argo_Managing_Agency_Limited_20250515 &gt;									
	//        &lt; 52f1BD52Yp3217Hfxjm8r2IYUKv7isWMZ0WO69n8qK890uBlNorNmC6WnYv2oU8k &gt;									
	//        &lt; 1E-018 limites [ 1003707831,53188 ; 1082977078,00083 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000175E909DA519370BE30C &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_32_____Argo_Managing_Agency_Limited_20250515 &gt;									
	//        &lt; xc48kg1d5D7WN9m3Koo3nB34Yan50ozU820s7xne1pW67cqGEYI6ed2me0L59Ao1 &gt;									
	//        &lt; 1E-018 limites [ 1082977078,00083 ; 1096814000,41496 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000019370BE30C1989855ADD &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_33_____Argo_Managing_Agency_Limited_20250515 &gt;									
	//        &lt; alo8qHM7WJRuuvUX2fafD0mCZw09r5mk7m8Ou49rM7YMO61R52L8oHbk2GRG6h6Z &gt;									
	//        &lt; 1E-018 limites [ 1096814000,41496 ; 1129321741,74424 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001989855ADD1A4B483B52 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_34_____Argo_Managing_Agency_Limited_20250515 &gt;									
	//        &lt; foG0k01Kc1Y3p3zZLz1I4IwFs217JGgIV2Goa7dlw9M8U6H6v7i78o26O514Yq30 &gt;									
	//        &lt; 1E-018 limites [ 1129321741,74424 ; 1166709573,14631 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001A4B483B521B2A2188F6 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_35_____Argo_Managing_Agency_Limited_20250515 &gt;									
	//        &lt; 0e9UKluyPFJJw6mP4x58o32vhpG8wBhIuC9T0B79827YJ88dp48v0sgu22zt6VJ4 &gt;									
	//        &lt; 1E-018 limites [ 1166709573,14631 ; 1206307260,38694 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001B2A2188F61C1626CF8A &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_36_____Argo_Managing_Agency_Limited_20250515 &gt;									
	//        &lt; l1es6lnp8T39ZGKPir1gQl6C76ijMR9pmHD75GW0zwK1b6rr1o23124N6bww0b81 &gt;									
	//        &lt; 1E-018 limites [ 1206307260,38694 ;  ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001C1626CF8A1CC15D1BF3 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_37_____Argo_Managing_Agency_Limited_20250515 &gt;									
	//        &lt; uolxrKbwmd68mp4O4N8zikmZ9vS0w465HuxFz2yAqwMA316aRX8U2Pxj7d1hP372 &gt;									
	//        &lt; 1E-018 limites [ 1235031884,79536 ; 1297786088,4799 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001CC15D1BF31E37686CC3 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_38_____Argo_Re_A_20250515 &gt;									
	//        &lt; E2Ai7Hzu521HCzc72Owo1Czmm4w2K49r3tBvs2tAn7TusxX9HK9TCheg36dNSlpS &gt;									
	//        &lt; 1E-018 limites [ 1297786088,4799 ; 1356690476,39651 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001E37686CC31F9681634B &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_39_____Ariel_Holdings_Limited_20250515 &gt;									
	//        &lt; o4oQ3hnehguFadXz9jlme9o9IFi49L5cbu1Q0xjzsg60d4KRtbu4v5NTV089253v &gt;									
	//        &lt; 1E-018 limites [ 1356690476,39651 ; 1413422403,06593 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001F9681634B20E8A77026 &gt;									
	//     &lt; RE_Portfolio_III_metadata_line_40_____Ark_Syndicate_Management_Limited_20250515 &gt;									
	//        &lt; 7lVi6KD7A454148Yw40v71HaC8RFO72kJ702KIAn3PPLAhfPf9IW6X4Bv398POyk &gt;									
	//        &lt; 1E-018 limites [ 1413422403,06593 ; 1428500225,82359 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000020E8A770262142865EAA &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
	}
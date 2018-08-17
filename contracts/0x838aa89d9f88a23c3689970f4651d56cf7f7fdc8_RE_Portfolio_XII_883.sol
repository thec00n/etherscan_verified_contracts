pragma solidity 		^0.4.21	;						
										
	contract	RE_Portfolio_XII_883				{				
										
		mapping (address =&gt; uint256) public balanceOf;								
										
		string	public		name =	&quot;	RE_Portfolio_XII_883		&quot;	;
		string	public		symbol =	&quot;	RE883XII		&quot;	;
		uint8	public		decimals =		18			;
										
		uint256 public totalSupply =		1344165245303120000000000000					;	
										
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
	//     &lt; RE_Portfolio_XII_metadata_line_1_____Holland_AAp_Nationale_Borg_Reinsurance_NV_Am_20250515 &gt;									
	//        &lt; nv4yc6tXpx94z0R5bmvD8WuVpgaOJ26yzWzBES61Fs1wcm4R6WvAb54z5ySwg4oD &gt;									
	//        &lt; 1E-018 limites [ 1E-018 ; 38855000,2732126 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000000000000E798086F &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_2_____Houston_Casuality_m_App_20250515 &gt;									
	//        &lt; Z53jGK0Efnca8K20At0Nht678QA2FCgNQrGij9qLp95I7U198n0NpOt9qu0NfTva &gt;									
	//        &lt; 1E-018 limites [ 38855000,2732126 ; 100606255,461729 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000E798086F257A8F87E &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_3_____Huatai_Insurance_Co,_Limited_Am_20250515 &gt;									
	//        &lt; LrljJpleRfS529fi3hur6a9rCEeH9GAdW9uDu6tkQ262i5430d0w9bMe14t66RwP &gt;									
	//        &lt; 1E-018 limites [ 100606255,461729 ; 123902825,057492 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000257A8F87E2E284B6FD &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_4_____ICICI_Lombard_General_Insurance_Co_Limited_20250515 &gt;									
	//        &lt; mk9rsTp9o5W842qNBYCGs17E8eG3ZBwtPLty62RkZp9G118ax5F2F4oo74HSjNeH &gt;									
	//        &lt; 1E-018 limites [ 123902825,057492 ; 147344007,577643 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000002E284B6FD36E3D1EE9 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_5_____IF_P&amp;C_Insurance_Limited__Publ__Ap_A2_20250515 &gt;									
	//        &lt; 4P7mI2taS8v6MO7T81NxHnoL0qDRkw0gd0F3DNxYmhEEMv5F1c70DjV5liyf91pN &gt;									
	//        &lt; 1E-018 limites [ 147344007,577643 ; 210249352,179246 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000036E3D1EE94E52F0F25 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_6_____India_International_Insurance_Pte_Limited_Am_20250515 &gt;									
	//        &lt; G0c0bbO24509PXW525J7ZT1MjX4yx5yh9PVKod1f3Cr97dx37e7LO8TT87P6xl88 &gt;									
	//        &lt; 1E-018 limites [ 210249352,179246 ; 228191686,623336 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000004E52F0F2555020E38A &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_7_____India_International_Insurance_Pte_Limited_Am_20250515 &gt;									
	//        &lt; woaA9eAF646EN65X9kg1w6y732p2eIcJN3YtN9Gp805ru6GXfF24h6XkoBQ2S54g &gt;									
	//        &lt; 1E-018 limites [ 228191686,623336 ; 240589715,957431 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000055020E38A59A06C7BF &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_8_____ING_Reinsurance_20250515 &gt;									
	//        &lt; 7e5M8L22H61iVo339jvE3t0vT9G4HD3Y14N8iFa2q7m8e3649cOrzWMEflgafD2M &gt;									
	//        &lt; 1E-018 limites [ 240589715,957431 ; 266846286,514168 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000059A06C7BF63687209F &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_9_____ING_USA_20250515 &gt;									
	//        &lt; 400w78zskOwZV9hVbZhIYWHE0aDg0s2g6A83F0R1LbN8oY02UoKKJttuKFv4W1eF &gt;									
	//        &lt; 1E-018 limites [ 266846286,514168 ; 291379206,9308 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000063687209F6C8C164A9 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_10_____Ingosstrakh_Ins_Co_BBp_m_20250515 &gt;									
	//        &lt; 6x30kpVVnSAF8p067BIr4lTCp92DlAJOM1nVk6g0pdVfJ7bOOARL2LGm7nZMe9Il &gt;									
	//        &lt; 1E-018 limites [ 291379206,9308 ; 363574584,99288 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000006C8C164A987712CC37 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; RE_Portfolio_XII_metadata_line_11_____Inrerlink_Reinsurance_20250515 &gt;									
	//        &lt; C54k0VEw30zaQVQX72N6649kwF288N64hElk1BvJ79vK67v2Ht3QG41v2W0iyXa2 &gt;									
	//        &lt; 1E-018 limites [ 363574584,99288 ; 377489411,804432 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000087712CC378CA032370 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_12_____Intermediaries_and_Reinsurance_Underwriters_Assoc_20250515 &gt;									
	//        &lt; 547nmuo8FkbmMF12zzK8GLdw7D8B681v0js1fto9MIqe148zo879f55gkgNyHz9Q &gt;									
	//        &lt; 1E-018 limites [ 377489411,804432 ; 390721861,095138 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000008CA032370918E240F1 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_13_____International_General_Insurance_Company_Limited_Am_Am_20250515 &gt;									
	//        &lt; 3ZKrDZAPKvw5NWP2ic5d275Cc6nTmMYO8Jx911eKr2s5je9kM21dQEx9472bck32 &gt;									
	//        &lt; 1E-018 limites [ 390721861,095138 ; 408222693,38801 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000918E240F198132678E &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_14_____International_Insurance_Co_of_Hannover_SE_AAm_20250515 &gt;									
	//        &lt; Wc7XxZJJJywcgZ83jqu5wtTyX8L9w85fTh9bGPRAgG752k930cJuWDF30C5HZ3IU &gt;									
	//        &lt; 1E-018 limites [ 408222693,38801 ; 442982730,968393 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000098132678EA5062033C &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_15_____International_Insurance_Co_of_Hannover_SE_AAm_Ap_20250515 &gt;									
	//        &lt; mEid30E9PyP601cqWtA24Loz1Z8xWGEx5CA6uFE0no1OmjPmLXG49629d2MMs6fI &gt;									
	//        &lt; 1E-018 limites [ 442982730,968393 ; 457941981,547481 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000A5062033CAA98C047E &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_16_____Investors_Guaranty_Fund_20250515 &gt;									
	//        &lt; Iqc2PUNaEWFo8qXQ0Sc9YOcM6N0xlafOtRm1G8U26yhrEwgIOGnhA99OHu67IXOL &gt;									
	//        &lt; 1E-018 limites [ 457941981,547481 ; 486148923,435821 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000AA98C047EB51AC652B &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_17_____IRB_Brasil_Resseguros_SA_20250515 &gt;									
	//        &lt; ktxvUHb3dj9rUC7cFo6cjR5P6A1Mk8x35R1V9z2221lwF90m1Rv4R4UyYW68gqWg &gt;									
	//        &lt; 1E-018 limites [ 486148923,435821 ; 501254894,24612 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000B51AC652BBABB64704 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_18_____IRB_Brazil_Re_20250515 &gt;									
	//        &lt; htiFLVtUzw38uSOUJJG9rJ1WEo35Mx25Qh8MWm9Tau5RQN207V0kGwtKwEe3tJIX &gt;									
	//        &lt; 1E-018 limites [ 501254894,24612 ; 513223636,19488 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000BABB64704BF30D20D7 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_19_____Ironshore_Insurance_Limited_m_A_20250515 &gt;									
	//        &lt; yX1gAdEJpt7Ch64amzirfX8T4LNuZ7Ac15qKbXW92L301jrbiGb1p8MFZSk0c8LK &gt;									
	//        &lt; 1E-018 limites [ 513223636,19488 ; 535454451,534138 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000BF30D20D7C778EA915 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_20_____Jordan_Insurance_co_Bpp_20250515 &gt;									
	//        &lt; MXh9674b21NSXXc6OjZxR02Ch4AC7Wnzq6mX6qE0Y4syn9ziF3gYUsT3NIGyCDf3 &gt;									
	//        &lt; 1E-018 limites [ 535454451,534138 ; 599537026,921147 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000C778EA915DF584E918 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; RE_Portfolio_XII_metadata_line_21_____JTW_Reinsurance_Consultants_20250515 &gt;									
	//        &lt; olL637924GLPv9kSr01irls9JY21ww377eoMHtLK56A8STL0B0dB14Vh7ob7i462 &gt;									
	//        &lt; 1E-018 limites [ 599537026,921147 ; 634349215,713688 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000DF584E918EC5041857 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_22_____Kazakhstan_BBBp_Eurasia_Insurance_Co_JSC_BBp_Bpp_20250515 &gt;									
	//        &lt; 201c9VIuD2MU6S21YBF51dUlEY8d568jIvaJp2h8NMTUEuAF6l20lwFp1IbZ4XFh &gt;									
	//        &lt; 1E-018 limites [ 634349215,713688 ; 673026363,731846 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000EC5041857FAB8CBD49 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_23_____Kenya_Re_Bp_20250515 &gt;									
	//        &lt; 9A4rw5WtanVrf99j76ArwQ4300is0OU92Y0U7aP13BzIrp80mdGK2m8ci8r6SmAs &gt;									
	//        &lt; 1E-018 limites [ 673026363,731846 ; 683731689,978009 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000FAB8CBD49FEB5BC559 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_24_____Korean_Re_20250515 &gt;									
	//        &lt; Abvao6S465TOU6DU4j62mOPOI5bT90cxH9JcEMTeuqFqD16u41GdXSF1ECEJ9r0N &gt;									
	//        &lt; 1E-018 limites [ 683731689,978009 ; 751996302,38762 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000FEB5BC55911823F4D92 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_25_____Korean_Re_20250515 &gt;									
	//        &lt; 7572rcsX9ka7KEK4LC1MAXtun5pA2dcX0FMLA8vq2EPzI43j8640aIyI3j28wg29 &gt;									
	//        &lt; 1E-018 limites [ 751996302,38762 ; 784815775,723991 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000011823F4D921245DDD858 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_26_____Korean_Re_A_20250515 &gt;									
	//        &lt; onZG122P61qRkm6Nt38u8vQ3aYFo7TCu4J8rv8T91490H5g1m8vNbfmtZRek7K9D &gt;									
	//        &lt; 1E-018 limites [ 784815775,723991 ; 801223849,211753 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001245DDD85812A7AA940D &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_27_____Korean_Reinsurance_Company_20250515 &gt;									
	//        &lt; 6LgpFz6t3Trx5G7k4JG0V2u7rsi2Y31iL3ZiFXWmn11Iy5I07a74ZyY5B1m7FO8p &gt;									
	//        &lt; 1E-018 limites [ 801223849,211753 ; 850293555,968376 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000012A7AA940D13CC250240 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_28_____Korean_Reinsurance_Company_20250515 &gt;									
	//        &lt; dzsbp50PA636xUI786NG48Ovy9xV8GZy4DDHnkrF2ZeWmuWE01od0vqDhKHpl10B &gt;									
	//        &lt; 1E-018 limites [ 850293555,968376 ; 867540116,268735 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000013CC2502401432F12BDE &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_29_____Kuwait_Reins_Co_A_20250515 &gt;									
	//        &lt; DrCjPZ8w57h0Xg64d12bQa9FA5stz1y5I8wmjPYPoFZiW1Nz6lx0iVFX53v4r2CY &gt;									
	//        &lt; 1E-018 limites [ 867540116,268735 ; 933909612,153269 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001432F12BDE15BE88FC33 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_30_____Labuan_Re_Am_20250515 &gt;									
	//        &lt; 11i8ZI5Z1KiVtj9RqYEiPB41m511IfgTdMY1f5B15qSz2e25rRLrf8553yJtzkV5 &gt;									
	//        &lt; 1E-018 limites [ 933909612,153269 ; 949023008,483127 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000015BE88FC3316189E32A4 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; RE_Portfolio_XII_metadata_line_31_____Labuan_Reinsurance_20250515 &gt;									
	//        &lt; OO2RuQjBfhA0iU29S1Bkty94h9033i90VDWF2SFo49TY9eew351CXf8JNe216OJZ &gt;									
	//        &lt; 1E-018 limites [ 949023008,483127 ; 989885392,080596 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000016189E32A4170C2D3F3C &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_32_____Lancashire_Insurance_Co_Limited_Am_A_20250515 &gt;									
	//        &lt; 4L5I8E48Tcvt3R2FQOKe9pK5oRP1Rer8Ae2ak0boBhvB1lh21Bb586Q4ZbjCzFIs &gt;									
	//        &lt; 1E-018 limites [ 989885392,080596 ; 1024352742,77984 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000170C2D3F3C17D99E4019 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_33_____Lansforsakringar_Sak_Forsakrings_AB_A_20250515 &gt;									
	//        &lt; oDFfdsD6plJdq4MI8wcc1AlX8p1c19Rf3LbfB1yOW3gf95k9F4CN9227itt79Ca4 &gt;									
	//        &lt; 1E-018 limites [ 1024352742,77984 ; 1039505072,73667 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000017D99E40191833EEDEFD &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_34_____LaSalle_Re_Limited_20250515 &gt;									
	//        &lt; xNQ2jMTVAWyLM325AmnhHkijgdIatN2J007j2yaCI4IeK23xM9ftjSuUPi98vs72 &gt;									
	//        &lt; 1E-018 limites [ 1039505072,73667 ; 1108377962,4577 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001833EEDEFD19CE728F89 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_35_____Lebanon_B_Arab_Re_Co_Bp_20250515 &gt;									
	//        &lt; A9w0Q65of6ui89Jp4z3Z6GLq8p1i5esGl3YxF5fGh1XoA3vX23h2z90qxaBL30Z7 &gt;									
	//        &lt; 1E-018 limites [ 1108377962,4577 ; 1177702873,59844 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000019CE728F891B6BA7FAF3 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_36_____Legal_&amp;_General_Assurance_Society_Limited_AAm_Ap_20250515 &gt;									
	//        &lt; XFL0ADikYvGHNqc6G3rL7dIeomAk88iqh3SU2v525wvBWzW16T36eoM0t1OQLLzr &gt;									
	//        &lt; 1E-018 limites [ 1177702873,59844 ;  ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001B6BA7FAF31BCCE82895 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_37_____Liberty_Managing_Agency_Limited_20250515 &gt;									
	//        &lt; 5xU9mANVxlJ6i0TENja9Eq3028INN04j2Ajw9uAAf6PU5D48QvH93e86blYvlNfE &gt;									
	//        &lt; 1E-018 limites [ 1194018832,97407 ; 1226652347,86245 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001BCCE828951C8F6AF356 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_38_____Liberty_Managing_Agency_Limited_20250515 &gt;									
	//        &lt; qI2zGKBZ2k44b2f080hc0zbcnL6Za1ck7E8nz02r2e6ffpTfWmsirP36ox5c8uf4 &gt;									
	//        &lt; 1E-018 limites [ 1226652347,86245 ; 1237807252,34683 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001C8F6AF3561CD1E7FBE6 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_39_____Liberty_Managing_Agency_Limited_20250515 &gt;									
	//        &lt; 25w08lsSUnT3KX4nGb7isEZ9V23Yl0i36qSvvR8ar6j5Mb3hXPhzarsUHQzoIFM8 &gt;									
	//        &lt; 1E-018 limites [ 1237807252,34683 ; 1295936303,25949 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001CD1E7FBE61E2C61E069 &gt;									
	//     &lt; RE_Portfolio_XII_metadata_line_40_____Liberty_Mutual_Ins_Co_A_A_20250515 &gt;									
	//        &lt; wIK48ILH5JcQLPLU1ha4jP6718H9ekvMk1gz0KrBB52H8swH0p9wfPkzMZfwdHzr &gt;									
	//        &lt; 1E-018 limites [ 1295936303,25949 ; 1344165245,30312 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001E2C61E0691F4BD966E6 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
	}
pragma solidity 		^0.4.21	;						
										
	contract	DOHA_Portfolio_I_883				{				
										
		mapping (address =&gt; uint256) public balanceOf;								
										
		string	public		name =	&quot;	DOHA_Portfolio_I_883		&quot;	;
		string	public		symbol =	&quot;	DOHA883		&quot;	;
		uint8	public		decimals =		18			;
										
		uint256 public totalSupply =		731661609544533000000000000					;	
										
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
	//     &lt; DOHA_Portfolio_I_metadata_line_1_____QNB_20250515 &gt;									
	//        &lt; hU1zJfAXIWjwRzQjUIScl4o8bq7axH6HuBDtiGTA019b7oj61f5kl4696PW83S71 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000000000000.000000000000000000 ; 000000016274632.348746100000000000 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000000000000037A0ED4 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_2_____Qatar_Islamic_Bank_20250515 &gt;									
	//        &lt; 17aFYFQ9CA4SOK0902m34ul7ucv4VLQA7cAR72zAxTdG265k7AnJ5mep6RUfDuBJ &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000016274632.348746100000000000 ; 000000035339142.975448700000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000037A0ED456471373 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_3_____Comm_Bank_of_Qatar_20250515 &gt;									
	//        &lt; V83Tsv22iNFkOrBA3D5U7jIA6cJKFb2e1qMTHct8247Wh5x6Y2t3wL8CjA5fQQdR &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000035339142.975448700000000000 ; 000000052957892.175272000000000000 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000564713732B64E852B &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_4_____Doha_Bank_20250515 &gt;									
	//        &lt; qUju69Sx8gMl6OkjbtMkUItcls3LKlv685Dfa6ulBiQciq6U16poLhbAC3gZ611Y &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000052957892.175272000000000000 ; 000000071717351.549108500000000000 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000002B64E852B4E34C5460 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_5_____Ahli_Bank_20250515 &gt;									
	//        &lt; C7KoV79oZ8H6SAQEo25AofOM0UL4Wn90au54EN7gqZ49lB6Zm1ry6a6c2AE4ZONG &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000071717351.549108500000000000 ; 000000090903570.386118500000000000 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000004E34C54604ECBCF485 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_6_____Intl_Islamic_Bank_20250515 &gt;									
	//        &lt; 7rN94JK4sOb7NGC86JU49Xuh7En2gss8bD2J45V1KsuZeEf4iU1cCCbsWgv3GhmH &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000090903570.386118500000000000 ; 000000107832399.217995000000000000 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000004ECBCF48550ED00309 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_7_____Rayan_20250515 &gt;									
	//        &lt; Jgp0QI6C7OKSGJ8Z6N1fmQ2Z9Vse0rP274ezlcf0Aw4r9xPLxdBsWlq50Ev9p5hl &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000107832399.217995000000000000 ; 000000127559187.842301000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000050ED00309816B8E20D &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_8_____Qatar_Insurance_20250515 &gt;									
	//        &lt; dc0Y668z2toyy6N8eT2QhKGmjh3P9YALc88654xY56D1mTvAY1y6SDKxZpbb3CNi &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000127559187.842301000000000000 ; 000000144536843.696412000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000816B8E20DBFD699807 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_9_____Doha_Insurance_20250515 &gt;									
	//        &lt; NV9L14h25w61rSg9X9zQDFwy3e7gOu6msP2r2949VmDhJ61fzo9ggNu70wgodwgJ &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000144536843.696412000000000000 ; 000000161032169.770494000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000BFD699807C00CC925C &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_10_____General_Insurance_20250515 &gt;									
	//        &lt; b1qf4nM067k5B0WSoo7wshTv2h1grIOR8ra5A8xKb8ba8Ftoo4uO5zO5bcG5BH3Z &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000161032169.770494000000000000 ; 000000179876905.111256000000000000 ] &gt;									
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
	//     &lt; DOHA_Portfolio_I_metadata_line_11_____Islamic_Insurance_20250515 &gt;									
	//        &lt; 9qcbUt0742le3FI3SDqDZc281rNM6nRV9Tgn6uOyNz9mP1sOm7U6mdHY1s42dUSd &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000179876905.111256000000000000 ; 000000195844859.003573000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000C8B19E052C95A3ECBC &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_12_____Ind_Manf_Co_20250515 &gt;									
	//        &lt; 3H6E0f64Nrl2wS84a41EU74v4M6e50Mm8O3KhW9zKMWtQVfVXlbaH0ZD02uiY3qj &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000195844859.003573000000000000 ; 000000216103494.501970000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000C95A3ECBCCA5EAC970 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_13_____National_Cement_Co_20250515 &gt;									
	//        &lt; 11T8O4S7kL062mgfNaHVj1Jul8Aep7d6pgFGRfoH7H8zq2MBzk503lJ7JTpp4pgT &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000216103494.501970000000000000 ; 000000231573394.642144000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000CA5EAC970CFBA12F64 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_14_____Zad_Holding_Company_20250515 &gt;									
	//        &lt; uAFlkA36REFbTmSIiAdy3506KdOr51okG3tGVZjDm0r8PawduO933AFNYY1c9wn2 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000231573394.642144000000000000 ; 000000248503661.237730000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000CFBA12F64D359422C8 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_15_____Industries_Qatar_20250515 &gt;									
	//        &lt; 6j92OsXVYJ1l6U92UvJgrT5085Km60aNuDmNrGUo2wmJ2fGzzodsd0R1lKLYd95o &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000248503661.237730000000000000 ; 000000269472454.885304000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000D359422C81191394DA5 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_16_____United_Dev_Company_20250515 &gt;									
	//        &lt; K8Uz43p03ZRnsM1I1El5l3FOWnAU2UL50ofgWD9Evb1cen5H0cUmLc39dX9rj026 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000269472454.885304000000000000 ; 000000287571177.938346000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001191394DA5119E78BA38 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_17_____Qatar_German_Co_Med_20250515 &gt;									
	//        &lt; lzt1mh1llK1Q9o9vqKWGwq40eMl57QjE92hs9V143a0GSW1E05C48hBvXeShZe6J &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000287571177.938346000000000000 ; 000000308285565.409239000000000000 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000119E78BA3811A5A651C7 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_18_____The_Investors_20250515 &gt;									
	//        &lt; tP1j5nLD1kSaQT5q80bu54TH699s4Jlr9oVDz6Y283K7MoY9P3q048QfAUBot3sJ &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000308285565.409239000000000000 ; 000000327290026.380911000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000011A5A651C711A7337AA6 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_19_____Ooredoo_20250515 &gt;									
	//        &lt; S5toJup3HvP9lOX9U8vDvbI52NVjMFj8ZBaZ0fb4v48CxvsikOWQ7gFR8jozIFU1 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000327290026.380911000000000000 ; 000000345131694.306823000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000011A7337AA611A80D764A &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_20_____Electricity_Water_20250515 &gt;									
	//        &lt; 16tFUCxP9z56o56qEP4d9DpOo12O5v43dOuDdZOIF9y2DV2wz12EYSRRSac0yD4u &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000345131694.306823000000000000 ; 000000362497439.836218000000000000 ] &gt;									
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
	//     &lt; DOHA_Portfolio_I_metadata_line_21_____Salam_International_20250515 &gt;									
	//        &lt; Ni1yj387aR192u9HPN00pvqzg4enG5LZ0oNst39961slyNHKscdK470agBRt3iCM &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000362497439.836218000000000000 ; 000000382904305.195081000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000011A9E0DEC11337C233DB &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_22_____National_Leasing_20250515 &gt;									
	//        &lt; Bv985pP18xveBi1B932C9wtp2WoN0gNU5nM7x84lXw956S7X7U3t9BLCtjWzyExF &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000382904305.195081000000000000 ; 000000400194896.475562000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001337C233DB16FC133A49 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_23_____Qatar_Navigation_20250515 &gt;									
	//        &lt; qR6ygvkxcKIMgf1nv2OjY5443PwX398dMscw07K17J9df3j7D7EAnTV52b7af8P4 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000400194896.475562000000000000 ; 000000421541317.440349000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000016FC133A4916FCE8C776 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_24_____Medicare_20250515 &gt;									
	//        &lt; n2wn10DZWnFK7x51f67xoOH08Q9oP7jChMEeM6LUa7ScseH8zv9xFuZAQ5Z5H3p8 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000421541317.440349000000000000 ; 000000439914097.661349000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000016FCE8C77616FE4B3578 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_25_____Qatar_Fuel_20250515 &gt;									
	//        &lt; 6IGcy1yy61hb6zPZa15c18ZM7eYHFe4xR9ZKoL3779fl3qHmF3n113kPgI5DCf7X &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000439914097.661349000000000000 ; 000000458367335.013190000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000016FE4B357817094B7C8A &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_26_____Widam_20250515 &gt;									
	//        &lt; 119X5jFvluZlpeZbBncK0LlpeL5gzbVpU1W7Y0LS8IH91FrG91vQ8ylH1Yb8oD8K &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000458367335.013190000000000000 ; 000000478441596.983324000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000017094B7C8A170A9FCB93 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_27_____Gulf_Warehousing_Co_20250515 &gt;									
	//        &lt; QS08Q002ksrpV138t16vm9PPqjP685d2uV6qI37ubxd9C04ZCU59pVJ1724VWRd0 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000478441596.983324000000000000 ; 000000497169845.837768000000000000 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000170A9FCB931710216274 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_28_____Nakilat_20250515 &gt;									
	//        &lt; Zd7z6d719i7nP8Ojfi5Hv9MG4yNDDuT5J92k2oCR6ApxRj5gX9vj0X686KLG91uG &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000497169845.837768000000000000 ; 000000518690628.088998000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000017102162741710DAFC71 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_29_____Dlala_20250515 &gt;									
	//        &lt; JAjRd29ZC9NJdJs2BAybBuwjK9S5Sl8R84ZLN7TG5T00GAPc70iu52Ch9f4FN1gc &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000518690628.088998000000000000 ; 000000537450199.090268000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001710DAFC71171F5B98B4 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_30_____Barwa_20250515 &gt;									
	//        &lt; 3rm72307dFqy6I9rsdy9v2D64Jsc2YN8NY1kiEqw1aqSCW9AXUx8R47iaxK2y4pP &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000537450199.090268000000000000 ; 000000556120702.498486000000000000 ] &gt;									
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
	//     &lt; DOHA_Portfolio_I_metadata_line_31_____Mannai_Corp_20250515 &gt;									
	//        &lt; R87R6f1o3Ao0dMab8CRn1x667z1y32Al3735wQIW8ob6GRn8ZwgTt436F91hkkrS &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000556120702.498486000000000000 ; 000000571250335.778555000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001B22EC3D9C1E0D333C03 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_32_____Aamal_20250515 &gt;									
	//        &lt; 20Q0BmypqM20e2D7tAvz0me07Dd088s5Lhrt45dvA5miuAkV7ZZZF4ER03Q6Yg6I &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000571250335.778555000000000000 ; 000000589336693.020642000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001E0D333C031E29356C3E &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_33_____Ezdan_Holding_20250515 &gt;									
	//        &lt; 6mx3P53haYX3py1lC65ju35E6TuSEj96O2zsyx368CEU3j8tkRjR976WA0w752TI &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000589336693.020642000000000000 ; 000000609982290.002993000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001E29356C3E1E2A15F705 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_34_____Islamic_Holding_20250515 &gt;									
	//        &lt; HOv8F7Kx6y6s42u5L2b3RlXf1bfDe8IW2Z36aH4C17kpvYr1o3C24em55214cE14 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000609982290.002993000000000000 ; 000000629463147.327816000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001E2A15F7051E37D2E629 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_35_____Gulf_International_20250515 &gt;									
	//        &lt; 6eY3I7FrI7496yR67IiI1c4S4JnXj0CE5KXVwb2DQUy7vbB3m9lw9E05nt3oI4K6 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000629463147.327816000000000000 ; 000000645101166.345170000000000000 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000001E37D2E62921F0EF1D76 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_36_____Mesaieed_20250515 &gt;									
	//        &lt; ryl7cMN94yiZD5RONLr9cwcI4ptcugDl9q3LLwAkqL5Cv2NonDWc20e3xyRGuwRb &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000645101166.345170000000000000 ; 000000663023778.091517000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000021F0EF1D7623C829D434 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_37_____Investment_Holding_20250515 &gt;									
	//        &lt; 88IJsHJ6RyK04JocbkkS24CvpC8Nyi9h7ZMAmR76dDPEhQA7Gr8K25pei6p19YaD &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000663023778.091517000000000000 ; 000000679618430.217144000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000023C829D43423C95BAE77 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_38_____Vodafone_Qatar_20250515 &gt;									
	//        &lt; fISYneH515HPPH71N3i7g3XGP47758P8Tot55WA3MFEiwS1E71n84ZPfR3A3X954 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000679618430.217144000000000000 ; 000000696650731.029694000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000023C95BAE7724A65522E8 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_39_____Al_Meera_20250515 &gt;									
	//        &lt; MC478Yn9L57xXd7Rl7AWtji1z9PuaiFju9o6hpl513N5x9SoTAiG8ZEaU0whdHG5 &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000696650731.029694000000000000 ; 000000713763718.708142000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000024A65522E824C0198909 &gt;									
	//     &lt; DOHA_Portfolio_I_metadata_line_40_____Mazaya_Qatar_20250515 &gt;									
	//        &lt; qU6WF5UZ2tC2JO47760v32G7qX8sJjV3xB6TYZ00yn11VfJ317iK4MM1tRzOZR8f &gt;									
	//        &lt;  u ==&quot;0.000000000000000001&quot; : ] 000000713763718.708142000000000000 ; 000000731661609.544533000000000000 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000024C019890924C8475D18 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
	}
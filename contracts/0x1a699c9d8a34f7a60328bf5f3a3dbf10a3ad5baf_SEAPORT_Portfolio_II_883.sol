pragma solidity 		^0.4.21	;						
										
	contract	SEAPORT_Portfolio_II_883				{				
										
		mapping (address =&gt; uint256) public balanceOf;								
										
		string	public		name =	&quot;	SEAPORT_Portfolio_II_883		&quot;	;
		string	public		symbol =	&quot;	SEAPORT883II		&quot;	;
		uint8	public		decimals =		18			;
										
		uint256 public totalSupply =		1237146528101310000000000000					;	
										
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
	//     &lt; SEAPORT_Portfolio_II_metadata_line_1_____Krasnoyarsk_Port_Spe_Value_20250515 &gt;									
	//        &lt; h5SSYTs2kmePD4Y24CVf36v656xiVi3EhF981CSxdANmjKPn3uy1DYH6Z7v4zZRZ &gt;									
	//        &lt; 1E-018 limites [ 1E-018 ; 37320542,1292223 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000000000000038F256 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_2_____Kronshtadt_Port_Spe_Value_20250515 &gt;									
	//        &lt; 9gEFYns3mYVmNRZr2Co6eu0a13bJqBLGop717pGgkV7yIJmmfz4gi08Ln76Kvjis &gt;									
	//        &lt; 1E-018 limites [ 37320542,1292223 ; 63307677,211098 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000000038F256609990 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_3_____Labytnangi_Port_Spe_Value_20250515 &gt;									
	//        &lt; Xru6aEANhlsc2W18Yd5oA995211nPXGW13Fk5393r27k982pl2T2g7DpOOwGP25a &gt;									
	//        &lt; 1E-018 limites [ 63307677,211098 ; 89982439,5165861 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000000609990894D64 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_4_____Lazarev_Port_Spe_Value_20250515 &gt;									
	//        &lt; awE3old1bF86K0jS5Ico5C4KfbD9IA02C6pq2OY2tEl27PkirKxJ7ohhGYmxyghV &gt;									
	//        &lt; 1E-018 limites [ 89982439,5165861 ; 139812199,062043 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000000894D64D55624 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_5_____Lomonosov_Port_Authority_20250515 &gt;									
	//        &lt; rVH50sWM27pL0ZyOCf0i8I7Z6TQ5gv69k1hK52bl3O6S4t67j72Rv2d7Xcv3Eu80 &gt;									
	//        &lt; 1E-018 limites [ 139812199,062043 ; 163481566,546536 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000000D55624F973FD &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_6_____Magadan_Port_Authority_20250515 &gt;									
	//        &lt; qM8W86q6edy1YXX6gX5cPf1jUPDE5c69f02pAqYrvJGTOHq3o4142qQTxzFUjvXs &gt;									
	//        &lt; 1E-018 limites [ 163481566,546536 ; 193865163,448014 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000000F973FD127D094 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_7_____Mago_Port_Spe_Value_20250515 &gt;									
	//        &lt; Z42Tr58FTcP8MB1uh3OMj74cz26JKnSQmm0mZy0zsa6920885YsyUH8y3J1BYkVj &gt;									
	//        &lt; 1E-018 limites [ 193865163,448014 ; 220149891,185153 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000000127D09414FEC0D &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_8_____Makhachkala_Sea_Trade_Port_20250515 &gt;									
	//        &lt; i5I2Cw4qj5lKGV6uIqM5xUvc5AuXi0gkq21nnblN7M1gwS5UW3g7xmNJ3sKQpunp &gt;									
	//        &lt; 1E-018 limites [ 220149891,185153 ; 261225008,518097 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000014FEC0D18E9905 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_9_____Makhachkala_Port_Spe_Value_20250515 &gt;									
	//        &lt; Q3ckL8Mj7PL8XLMSnNyfY6856ESL3xS44P4e2I4PxS96WrZ31lOy9O0nFf6GF5bb &gt;									
	//        &lt; 1E-018 limites [ 261225008,518097 ; 308090672,705512 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000018E99051D61BEB &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_10_____Mezen_Port_Authority_20250515 &gt;									
	//        &lt; 6ULIZVCGDH0Y305xtvU8717ZmQs57a3t8ZW46w1UeD5JWq3aqt16k0JgDvw6S76H &gt;									
	//        &lt; 1E-018 limites [ 308090672,705512 ; 339325554,308506 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000001D61BEB205C50B &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; SEAPORT_Portfolio_II_metadata_line_11_____Moscow_Port_Spe_Value_20250515 &gt;									
	//        &lt; f63o1699ulpM3g5A35c85S2xoo940ytDaMI2MXnR8316E2tE9akDeQ70SK264a4Z &gt;									
	//        &lt; 1E-018 limites [ 339325554,308506 ; 357800137,979412 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000000205C50B221F5AE &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_12_____Murmansk_Port_Authority_20250515 &gt;									
	//        &lt; tw04a2AQVW38tZ1v3fGlZDUjU1aU2In0yz0nLzPHfYdiJUQgizaQuKwlvqAWlI31 &gt;									
	//        &lt; 1E-018 limites [ 357800137,979412 ; 406854841,491244 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000000221F5AE26CCFAC &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_13_____Murom_Port_Spe_Value_20250515 &gt;									
	//        &lt; 53jhs8R0au0fxk7K2joi0tr5QO7j2H058V7XECd05o06Y8O19D5Z5Hl52WZLrM22 &gt;									
	//        &lt; 1E-018 limites [ 406854841,491244 ; 443427177,101728 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000026CCFAC2A49DBE &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_14_____Commercial_Port_Livadia_Limited_20250515 &gt;									
	//        &lt; 0tUWuO1rJ4nzkkyFX35JCaHJIN1hlSFh22546epnsW1BXbmJaH5XQv6rMC8DJd6A &gt;									
	//        &lt; 1E-018 limites [ 443427177,101728 ; 463905140,849857 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000002A49DBE2C3DCF2 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_15_____Joint_Stock_Company_Nakhodka_Commercial_Sea_Port_20250515 &gt;									
	//        &lt; AUPJVPHjWUvzuxI8nHdY0wd92g38kBaXFb1yUluN11obw2epg7szE5b5ImI38I79 &gt;									
	//        &lt; 1E-018 limites [ 463905140,849857 ; 481984275,352298 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000002C3DCF22DF731C &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_16_____Naryan_Mar_Port_Authority_20250515 &gt;									
	//        &lt; dczZPArMGJXa9MCGp7z92pQk5pUq0Wb8cj3PTyTE1d0v6LBV316v1044CtK5jvDd &gt;									
	//        &lt; 1E-018 limites [ 481984275,352298 ; 531578837,126971 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000002DF731C32B1FFC &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_17_____Nevelsk_Port_Authority_20250515 &gt;									
	//        &lt; 02vb2HVTtjn9QAuJFcaj7ny2bYE3U4FJ7c71J4BDxQL2XB9Yz4G1n9LOWg6yzmWC &gt;									
	//        &lt; 1E-018 limites [ 531578837,126971 ; 557174543,429669 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000032B1FFC3522E4E &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_18_____Nikolaevsk_on_Amur_Sea_Port_20250515 &gt;									
	//        &lt; 6hHsg522eEx606SVLV2uFKz1HGX81485dl956a15RPO8S4SQ1p3y0vzQ0782Ad55 &gt;									
	//        &lt; 1E-018 limites [ 557174543,429669 ; 575206028,05771 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000003522E4E36DB1DB &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_19_____Nizhnevartovsk_Port_Spe_Value_20250515 &gt;									
	//        &lt; 2lr55a96dU44MtSB46JdYQ93IoRJS2nEO75viFqRwD9pVxt875kfRX9ZM3Ut27p8 &gt;									
	//        &lt; 1E-018 limites [ 575206028,05771 ; 594874048,878873 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000036DB1DB38BB4AD &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_20_____Novgorod_Port_Spe_Value_20250515 &gt;									
	//        &lt; Jpk37o34i8Tz2W5aAMAUAL2Dm3DYk9UG0Ia4iAroj7U9S7nn5x6o32a30Pn8x9Sh &gt;									
	//        &lt; 1E-018 limites [ 594874048,878873 ; 628074436,103043 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000038BB4AD3BE5D94 &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; SEAPORT_Portfolio_II_metadata_line_21_____JSC_Novoroslesexport_20250515 &gt;									
	//        &lt; 2EIQ603mo52CchA78eht4PMp4k005h7hJVy25r40y341Rn3v2nWq213A8SoTKV7F &gt;									
	//        &lt; 1E-018 limites [ 628074436,103043 ; 646358470,451486 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000003BE5D943DA43C7 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_22_____Novorossiysk_Port_Spe_Value_20250515 &gt;									
	//        &lt; V0CszlxzvIIS99KPctnEO58Kn1ooJzuwQ0KFN7Ix4Z72ZUAIm380Miz0f6y1vR1T &gt;									
	//        &lt; 1E-018 limites [ 646358470,451486 ; 677653565,992141 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000003DA43C740A046D &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_23_____Novosibirsk_Port_Spe_Value_20250515 &gt;									
	//        &lt; aJK7jan1p1qmsFuH1A89U9SBS54767c7f4UFYK6I7JMdsyfG1qK8Cd8F4keiWeXo &gt;									
	//        &lt; 1E-018 limites [ 677653565,992141 ; 719692467,807047 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000040A046D44A29DF &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_24_____Olga_Port_Authority_20250515 &gt;									
	//        &lt; BSqF34P8HHdyz0aPRbtFUkXCJtDAHeVX6B836ABR25VOc0TD9O5kzN3KQOCTwXqc &gt;									
	//        &lt; 1E-018 limites [ 719692467,807047 ; 737548084,916969 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000044A29DF46568B8 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_25_____Omsk_Port_Spe_Value_20250515 &gt;									
	//        &lt; 5w6lhE59DKRkY9P8slXI0Sjs64FIDJ8Cm16QgV7mMuqS8WT52qIaWZXBO4fg86u1 &gt;									
	//        &lt; 1E-018 limites [ 737548084,916969 ; 759810912,351829 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000046568B84876123 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_26_____Onega_Port_Authority_20250515 &gt;									
	//        &lt; YSG01HIHRUhOp6ed2bf84CnF24C23BQJlmK41c23QVibW109BLyh2c5enFy9D73M &gt;									
	//        &lt; 1E-018 limites [ 759810912,351829 ; 780183689,534782 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000048761234A67741 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_27_____Perm_Port_Spe_Value_20250515 &gt;									
	//        &lt; PWVDj6Ao78XGuNZsLa4SIAH63k61EdY7MzbR3YIQvt7R73Xv9cmo4MrXX84jjzuD &gt;									
	//        &lt; 1E-018 limites [ 780183689,534782 ; 801253812,266948 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000004A677414C69DC5 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_28_____Petropavlovsk_Kamchatskiy_Port_Spe_Value_20250515 &gt;									
	//        &lt; Nu4m0TsLFT6fXc4aB69wcCa8m5Ro8ch916zh8c20ig7w6p2Frv43xD4ADInDk7j6 &gt;									
	//        &lt; 1E-018 limites [ 801253812,266948 ; 827411237,378695 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000004C69DC54EE8784 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_29_____Marine_Administration_of_Chukotka_Ports_20250515 &gt;									
	//        &lt; WnWH20C8oUt144TfjX1A9uQJGnX2c7rs2KZ92uDrxCd8QwgyPqRnco8R8tFJxRUh &gt;									
	//        &lt; 1E-018 limites [ 827411237,378695 ; 870217680,336145 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000004EE878452FD8C8 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_30_____Poronaysk_Port_Authority_20250515 &gt;									
	//        &lt; 6C2Ok3lsS6SujuvJp2tr7URVi1U8R1ieRa9J2Cr03O1A4vtOIv8qziDQ43oBCkoj &gt;									
	//        &lt; 1E-018 limites [ 870217680,336145 ; 918218705,158242 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000052FD8C8579172F &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
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
	//     &lt; SEAPORT_Portfolio_II_metadata_line_31_____Marine_Administration_of_Vladivostok_Port_Posyet_Branch_20250515 &gt;									
	//        &lt; gn7W7X0nt1cDiNpm70BhSDB78eHim5DO110Z70g2B803pEJy2bM4lyA7K2CxL691 &gt;									
	//        &lt; 1E-018 limites [ 918218705,158242 ; 951723027,399514 ] &gt;									
	//        &lt; 0x00000000000000000000000000000000000000000000000000579172F5AC36CF &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_32_____Primorsk_Port_Authority_20250515 &gt;									
	//        &lt; FHrzkjop8S6IzdqCC4JQAbF43p1KpJqclm2eb7uXy3LKY5HCLdmV4QWLD4yA7y4w &gt;									
	//        &lt; 1E-018 limites [ 951723027,399514 ; 996989921,879143 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000005AC36CF5F14930 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_33_____Marine_Administration_of_Chukotka_Ports_20250515 &gt;									
	//        &lt; 4hucRUr8cxdbQb1W4vC3Rrae7E8qf9V2C3KOjTtDN5UCE9h3pUQdos8B5F9ELf4c &gt;									
	//        &lt; 1E-018 limites [ 996989921,879143 ; 1027322346,81577 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000005F1493061F91CB &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_34_____Rostov_on_Don_Port_Spe_Value_20250515 &gt;									
	//        &lt; 3u87h559hKDY2iIs5lI0695LXY0I89dtCF3w9ucbOuU3o67cuzQg1C7L6i0O5moM &gt;									
	//        &lt; 1E-018 limites [ 1027322346,81577 ; 1045446214,78618 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000061F91CB63B396D &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_35_____Ryazan_Port_Spe_Value_20250515 &gt;									
	//        &lt; 6vnQ3A57fJKBJ3fxscj4L36w1Rd2Cz30M1h60W2MWQOpfp1iii20gCU60YAu96j6 &gt;									
	//        &lt; 1E-018 limites [ 1045446214,78618 ; 1089690487,88297 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000063B396D67EBC59 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_36_____Salekhard_Port_Spe_Value_20250515 &gt;									
	//        &lt; bGtQ9J7y2OSWc86V0cOT9ZDxx6RU31p3WFzL0M421J0VO692dHJNPGNuW3PiC049 &gt;									
	//        &lt; 1E-018 limites [ 1089690487,88297 ;  ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000067EBC596ACCA4B &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_37_____Samara_Port_Spe_Value_20250515 &gt;									
	//        &lt; 4ckNE5Ax1t3cdA62hXuz6GaS8mM6FXCZBl18LygwjHh53j91G09ZPCxgUTIT26Ep &gt;									
	//        &lt; 1E-018 limites [ 1119872753,76494 ; 1147835076,7578 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000006ACCA4B6D77514 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_38_____Saratov_Port_Spe_Value_20250515 &gt;									
	//        &lt; f5clcyPy3bdaaT6bU1O2BuW6AvRsXVm5s8D6Y98HBDxzvbu29MpYSt2sh8d67DzM &gt;									
	//        &lt; 1E-018 limites [ 1147835076,7578 ; 1186968862,49198 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000006D775147132BB6 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_39_____Sarepta_Port_Spe_Value_20250515 &gt;									
	//        &lt; 408ueC5iaKuug4Aab9184UPd2TGUIl9Y7rN0qqcy82hSjyA4i7t691j9DVU9uKmk &gt;									
	//        &lt; 1E-018 limites [ 1186968862,49198 ; 1218380341,25779 ] &gt;									
	//        &lt; 0x000000000000000000000000000000000000000000000000007132BB674319D2 &gt;									
	//     &lt; SEAPORT_Portfolio_II_metadata_line_40_____Serpukhov_Port_Spe_Value_20250515 &gt;									
	//        &lt; 4qkl5vDgV9A0i1a2vHIO8LgU2oTVgUj4f89eJiDw199ZkgEVd8S48sn25pj7O58q &gt;									
	//        &lt; 1E-018 limites [ 1218380341,25779 ; 1237146528,10131 ] &gt;									
	//        &lt; 0x0000000000000000000000000000000000000000000000000074319D275FBC5D &gt;									
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
	}
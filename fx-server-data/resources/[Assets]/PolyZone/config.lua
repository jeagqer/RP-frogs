Config = Config or {}

Config.Zones = {
	garages = {
		-- Garage A --

		BoxZone:Create(vector3(466.49, -71.76, 77.49), 8.4, 13.8, {
			name="garagea",
			heading=337,
			--debugPoly=true
		}),

		BoxZone:Create(vector3(472.67, -61.76, 77.46), 8.4, 13.8, {
			name="garagea",
			heading=330,
			--debugPoly=true
		}),

		BoxZone:Create(vector3(487.94, -32.5, 77.72), 10.0, 24.4, {
			name="garagea",
			heading=60,
			--debugPoly=true
		}),
		
		BoxZone:Create(vector3(-356.31, -753.56, 33.97), 53.25, 10.4, {
			name="garageb",
			heading=1,
		}),

	
	 -- Garage LS --
	
		BoxZone:Create(vector3(-685.97894287109, -982.13201904297, 19.871116638184), 8.4, 13.8, {
			name="garagels",
			heading=337,
			--debugPoly=true
		}),
	
			
			

		-- Garage B --
  
  		BoxZone:Create(vector3(-341.99, -758.46, 33.97), 23.35, 8.6, {
			name="garageb",
			heading=0,
		}),
  
  		BoxZone:Create(vector3(-326.87, -751.89, 33.97), 31.2, 11.6, {
			name="garageb",
			heading=262,
		}),
  
		-- Garage C --

		BoxZone:Create(vector3(-321.95, -980.58, 31.08), 59.0, 9.0, {
			name="garagec",
			heading=70,
			--debugPoly=true
		}),
  
  		BoxZone:Create(vector3(-321.51, -941.79, 31.08), 37.6, 7.6, {
			name="garagec",
			heading=340,
		}),

  		BoxZone:Create(vector3(-307.8, -949.2, 31.08), 40.8, 7.8, {
			name="garagec",
			heading=340,
			--debugPoly=truew
		}),

		-- Garage D --

		BoxZone:Create(vector3(385.34, -1331.04, 33.22), 44.0, 7.6, {
			name="garaged",
			heading=50,
		}),
  
  		BoxZone:Create(vector3(427.39, -1366.02, 33.17), 44.0, 7.6, {
			name="garaged",
			heading=49,
		}),
  
		-- Garage E --

		BoxZone:Create(vector3(614.2, 112.74, 92.2), 46.85, 34.6, {
			name="garagee",
			heading=339,
		}),

		-- Garage F --

		BoxZone:Create(vector3(636.49, 176.47, 96.6), 60.2, 36.2, {
  			name="garagef",
  			heading=340,
		}),

		-- Garage G --

		--Name: garageg | 2022-04-15T14:21:42Z
		PolyZone:Create({
			vector2(73.410469055176, 6409.0766601562),
			vector2(86.314140319824, 6396.470703125),
			vector2(80.823600769042, 6391.3237304688),
			vector2(67.736724853516, 6403.912109375),
			vector2(58.429000854492, 6395.7470703125),
			vector2(54.763328552246, 6401.5463867188),
			vector2(63.778270721436, 6411.203125),
			vector2(67.96891784668, 6405.033203125)
		  }, {
			name="garageg",
			--minZ = 31.225761413574,
			--maxZ = 31.375890731812
		  }),
  
  
  

		-- Garage H --

		BoxZone:Create(vector3(-759.44, -2026.07, 8.93), 72.6, 50, {
  			name="garageh",
  			heading=335,
		}),

		-- Garage I --

		BoxZone:Create(vector3(-675.98, -2056.88, 8.87), 70.4, 33.8, {
  			name="garagei",
  			heading=85,
		}),

		-- Garage J --

		BoxZone:Create(vector3(-629.4, -2196.03, 5.99), 82.400000000001, 23.0, {
  			name="garagej",
  			heading=50,
		}),

		-- Garage K --

		BoxZone:Create(vector3(-125.32, -2133.55, 16.7), 61.2, 32.0, {
  			name="garagek",
  			heading=290,
		}),

		-- Garage L --

		BoxZone:Create(vector3(-51.6, -2101.08, 16.7), 27.8, 16.6, {
  			name="garagel",
  			heading=290,
		}),

		-- Garage M --

		BoxZone:Create(vector3(-83.62, -2006.09, 18.02), 51.0, 19.8, {
  			name="garagem",
  			heading=260,
		}),

		-- Garage O --

		BoxZone:Create(vector3(375.1, 281.46, 103.43), 41.0, 35.0, {
  			name="garageo",
  			heading=253,
		}),

		-- Garage P --

		BoxZone:Create(vector3(-339.36, 288.01, 85.83), 35.6, 30.2, {
  			name="garagep",
  			heading=0,
		}),

		-- Garage Q --

		PolyZone:Create({
			vector2(295.66567993164, -356.21514892578),
			vector2(305.9580078125, -327.55197143555),
			vector2(266.70874023438, -314.34658813477),
			vector2(258.60485839844, -339.76541137695)
		}, {
			name="garageq",
		}),

		-- Garage R --

		BoxZone:Create(vector3(59.43, 17.81, 69.78), 14.8, 7.0, {
  			name="garager",
  			heading=70,
		}),

		-- Garage S --

		BoxZone:Create(vector3(305.14, 71.33, 94.37), 30.4, 6.0, {
  			name="garages",
  			heading=70,
		}),

		-- Garage T --

		PolyZone:Create({
			vector2(239.68876647949, -820.34033203125),
			vector2(258.72216796875, -768.09613037109),
			vector2(218.64688110352, -754.83935546875),
			vector2(200.06071472168, -805.73034667969)
		}, {
			name="garaget",
		}),

		-- Garage PD --

		BoxZone:Create(vector3(441.45, -991.72, 25.7), 15.2, 14.0, {
			name="garagepd",
			heading=0,
			minZ=24.7,
			maxZ=28.7
  		}),
		  
		--Name: garagewinery | 2022-04-15T14:23:56Z
		PolyZone:Create({
			vector2(-1921.7097167968, 2059.7788085938),
			vector2(-1914.5228271484, 2058.3664550782),
			vector2(-1920.3664550782, 2034.2614746094),
			vector2(-1927.1101074218, 2035.0225830078)
		  }, {
			name="garagewinery",
			--minZ = 140.73403930664,
			--maxZ = 140.7364654541
		  }),
  
		  --Name: garageairport | 2022-04-15T14:27:33Z
		PolyZone:Create({
			vector2(-1285.150390625, -3360.7502441406),
			vector2(-1302.8341064454, -3390.6330566406),
			vector2(-1266.5590820312, -3413.6916503906),
			vector2(-1247.4185791016, -3380.1447753906)
		  }, {
			name="garageairport",
			--minZ = 13.94015789032,
			--maxZ = 13.95150566101
		  }),

		  --Name: garagepdpaletoheli | 2022-04-15T14:37:29Z
		PolyZone:Create({
			vector2(-477.5827331543, 6005.0922851562),
			vector2(-458.5365600586, 5986.3774414062),
			vector2(-472.7469177246, 5972.177734375),
			vector2(-491.39459228516, 5991.0893554688)
			}, {
			name="garagepdpaletoheli",
			--minZ = 31.306163787842,
			--maxZ = 31.31202697754
			}),
  
  
  

		  --Name: garagepdpaleto | 2022-04-15T14:35:02Z

		PolyZone:Create({
			vector2(-465.26455688476, 6038.5415039062),
			vector2(-482.22436523438, 6021.869140625),
			vector2(-486.12310791016, 6025.037109375),
			vector2(-469.2801208496, 6042.0849609375)
		  }, {
			name="garagepdpaleto",
			--minZ = 31.340375900268,
			--maxZ = 31.357749938964
		  }),

		--Name: garagecluckin | 2022-04-15T14:19:36Z
		PolyZone:Create({
			vector2(-494.62088012696, -775.76824951172),
			vector2(-488.4714050293, -773.99786376954),
			vector2(-489.98852539062, -770.20233154296),
			vector2(-491.50805664062, -766.6304321289),
			vector2(-493.98547363282, -761.40606689454),
			vector2(-497.58126831054, -754.63946533204),
			vector2(-500.34393310546, -749.96081542968),
			vector2(-505.88424682618, -752.84478759766),
			vector2(-501.97717285156, -758.59301757812),
			vector2(-499.48254394532, -763.58306884766),
			vector2(-496.62908935546, -769.44024658204)
		  }, {
			name="garagecluckin",
			--minZ = 31.176433563232,
			--maxZ = 32.181911468506
		}),

		
		PolyZone:Create({
			vector2(372.17388916016, 793.12463378906),
			vector2(376.51364135742, 792.91687011718),
			vector2(376.58721923828, 800.82946777344),
			vector2(372.00106811524, 800.42266845704)
		  }, {
			name="garageranger",
			--minZ = 187.27281188964,
			--maxZ = 187.62010192872
		}),
		  
		--Name: garagebs | 2022-04-15T14:14:07Z
		PolyZone:Create({
			vector2(-1206.301147461, -855.40521240234),
			vector2(-1207.7177734375, -852.7456665039),
			vector2(-1208.212890625, -852.2939453125),
			vector2(-1227.5672607422, -865.55786132812),
			vector2(-1226.2021484375, -868.61993408204)
		  }, {
			name="garagebs",
			--minZ = 12.908666610718,
			--maxZ = 13.785143852234
		}),
  

		
		--Name: garagerockey | 2022-04-15T11:27:09Z
		BoxZone:Create(vector3(2415.6, 3098.37, 48.15), 10, 6, {
			name="garagerockey",
			heading=0,
			--debugPoly=true
		}),

		--Name: fib_parking | 2022-04-15T09:50:46Z
		PolyZone:Create({
			vector2(2535.0710449218, -380.25387573242),
			vector2(2556.6813964844, -380.9454650879),
			vector2(2559.1909179688, -370.44659423828),
			vector2(2536.7919921875, -369.65060424804)
		}, {
			name="garagefib",
			--minZ = 92.99341583252,
			--maxZ = 93.08039855957
		}),

		--Name: fib_heli | 2022-04-15T09:57:36Z
		PolyZone:Create({
			vector2(2506.2463378906, -342.2776184082),
			vector2(2511.0375976562, -347.0443725586),
			vector2(2515.4782714844, -342.15182495118),
			vector2(2510.7189941406, -337.78399658204)
			},
			{
				name="garagefibheli",
				--minZ = 118.18542480468,
				--maxZ = 118.18616485596
			}
		),

		BoxZone:Create(vector3(264.6512, -1123.8561, 29.2180), 20.0, 22.5, {  -- Far right side from sandy pd
		  name="garagecourt",
		  heading=266.0793,
		}),

		BoxZone:Create(vector3(1850.4, 3674.66, 33.77), 5.0, 12.2, {  -- Far right side from sandy pd
			name="garagesandy",
			heading=6,
  		}),

		BoxZone:Create(vector3(1827.16, 3660.73, 33.71), 22.2, 5.4, { -- Far left side from sandy pd
			name="garagesandy",
			heading=301,
  		}),

		BoxZone:Create(vector3(383.62, -1586.96, 29.32), 5.4, 26.2, {  -- State Police HQ
		  name="garagestate",
		  heading=320,
		}),

		BoxZone:Create(vector3(390.01, -1611.76, 29.29), 5.4, 12.8, {  -- State Police HQ
		  name="garagestate",
		  heading=50,
		  minZ=28.29,
		  maxZ=32.29
		}),

		BoxZone:Create(vector3(398.17, -1622.6, 29.29), 5.4, 19.2, {  -- State Police HQ
		  name="garagestate",
		  heading=50,
	  	}),

		BoxZone:Create(vector3(386.07, -1635.55, 29.29), 5.4, 6.6, {  -- State Police HQ
		  name="garagestate",
		  heading=320,
		  minZ=28.29,
		  maxZ=32.29
	  	}),

		-- Garage Harm --

		BoxZone:Create(vector3(570.53, 2728.13, 42.06), 22.6, 34.8, {
			name="garageharm",
			heading=3,
  		}),

		-- Garage Pier --

		BoxZone:Create(vector3(-1587.95, -902.0, 9.21), 13.6, 18.0, {
			name="garagepier",
			heading=321,
  		}),

		-- Garage Richman --

		BoxZone:Create(vector3(-1308.41, 254.07, 64.49), 73.2, 62.8, {
			name="garagerich",
			heading=254,
  		}),

		-- Garage EMS --

		BoxZone:Create(vector3(325.88, -588.31, 28.8), 5.8, 19.0, {
			name="garageems",
			heading=340,
			minZ=27.8,
			maxZ=31.8
		}),
		  
		  BoxZone:Create(vector3(318.48, -572.01, 28.8), 20, 10, {
			name="garageems",
			minZ=27.8,
			maxZ=31.8
		}),
		  
		-- Garage Casino --

		PolyZone:Create({
			vector2(870.51776123047, 20.484987258911),
			vector2(876.04241943359, 17.465185165405),
			vector2(956.79577636719, -30.344190597534),
			vector2(947.38110351562, -63.22282409668),
			vector2(954.59088134766, -88.86612701416),
			vector2(926.10278320312, -116.17047119141),
			vector2(884.08178710938, -92.043014526367),
			vector2(827.90643310547, -56.764553070068),
			vector2(816.08416748047, -46.162780761719)
		}, {
			name="garagecasino",
		}),

		-- Garage Impound --

		BoxZone:Create(vector3(-153.13, -1168.22, 23.77), 7.4, 6.2, {
			name="nomalimpound",
			heading=0,
			--debugPoly=true
		}),

		BoxZone:Create(vector3(1524.12, 2240.05, 74.18), 59.0, 9.0, {
			name="garageoak",
			heading=70,
			--debugPoly=true
		}),
  

		--Job Storing
		BoxZone:Create(vector3(445.52, -991.54, 25.7), 13.2, 4.6, {
			name="garage_PD1_state",
			heading=0,
			--debugPoly=true,
			minZ=24.3,
			maxZ=28.7
		}),
		BoxZone:Create(vector3(437.36, -991.19, 25.7), 13.2, 4.6, {
			name="garage_PD2_state",
			heading=0,
			--debugPoly=true,
			minZ=24.3,
			maxZ=28.7
		}),
		BoxZone:Create(vector3(1866.73, 3698.52, 33.62), 9.4, 5.6, {
			name="garage_sandy_state",
			heading=31,
			--debugPoly=true,
			minZ=32.62,
			maxZ=36.62
		}),
		BoxZone:Create(vector3(-455.44, 6003.06, 31.34), 25.0, 5.4, {
			name="garage_paleto_state",
			heading=45,
			--debugPoly=true,
			minZ=30.34,
			maxZ=34.34
		}),
		BoxZone:Create(vector3(-475.33, 5988.43, 31.28), 12.8, 13.0, {
			name="garage_paletohelicopter_state",
			heading=315,
			--debugPoly=true,
			minZ=30.28,
			maxZ=35.28
		}),
		BoxZone:Create(vector3(1867.57, 3646.96, 35.82), 9.0, 7.4, {
			name="garage_sandyhelicopter_state",
			heading=300,
			--debugPoly=true,
			minZ=34.42,
			maxZ=38.42
		}),
		BoxZone:Create(vector3(449.33, -981.27, 43.69), 8.4, 6.4, {
		  name="garage_mrpdheli",
		  heading=0,
		  --debugPoly=true,
		  minZ=42.69,
		  maxZ=46.89
		}),
		BoxZone:Create(vector3(351.88, -588.13, 74.16), 10, 10, {
			name="garage_pbmchelicopter_state",
			heading=70,
			--debugPoly=true,
			minZ=73.16,
			maxZ=77.16
		}),
		BoxZone:Create(vector3(1843.11, 3666.55, 33.68), 5.0, 8.6, {
		  name="garage_sandyemt_state",
		  heading=30,
		  --debugPoly=true,
		  minZ=32.68,
		  maxZ=36.88
		}),
		BoxZone:Create(vector3(-256.26, 6343.38, 32.43), 5, 10.6, {
			name="garage_paletoEMT_state",
			heading=45,
			--debugPoly=true,
			minZ=31.23,
			maxZ=35.23
		}),
		BoxZone:Create(vector3(326.18, -588.42, 28.8), 17.4, 5.2, {
			name="garage_pbmc_state",
			heading=70,
			--debugPoly=true,
			minZ=27.8,
			maxZ=31.8
		})
	}
}
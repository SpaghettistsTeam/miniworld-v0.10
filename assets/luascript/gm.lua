
--命令行输入/gm 函数名后半部分, 比如/gm wuqi
--//gm wuqi			--武器	
--//gm 0			-- 清理背包
--//gm ym			--羊毛
--//gm gj			--工具
--//gm hj			--护甲
--//gm hs			--红石
--//gm jx			--机械

--//gm mybuff		--给自己加buff
--//gm clearbuff	--给自己取消buff

--//gm new 			--新手资源

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
--获得新手资源
local tNew = {200,505,101,401,402,400,405,408,};
function GM_new()

	for i= 1 ,table.getn(tNew) do
		ClientBackpack:addItem(tNew[i], 128);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tNew[i]).Name);
	end

	return	
end



--获得武器
local tWuQi = {2001,2002,2003,2004,2005,2050};
local tZiDan = {2051,2052,2054};
function GM_wuqi()
	for i= 1 ,table.getn(tWuQi) do
		ClientBackpack:addItem(tWuQi[i], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tWuQi[i]).Name);
	end
	
	for i= 1 ,table.getn(tZiDan) do
		ClientBackpack:addItem(tZiDan[i], 64);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tZiDan[i]).Name);
	end
end
----------------------------------------------------------------------------------------------------------------------------------------
--清除背包
function GM_0()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
end

--获得羊毛
local tYangMao = {600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615};
function GM_ym()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");

	for i= 1 ,table.getn(tYangMao) do
		ClientBackpack:addItem(tYangMao[i], 128);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tYangMao[i]).Name);
	end

	return	
end

--获得工具
local tTools = {1001,1002,1003,1004,1005,1011,1012,1013,1014,1015,1021,1022,1023,1024,1025,1031,1032,1033,1034,1035};

function GM_gj()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");

	for i= 1 ,table.getn(tTools) do
		ClientBackpack:addItem(tTools[i], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTools[i]).Name);
	end

	return	
end

--获得护甲
local tHuJia = {2201,2202,2203,2204,2205,2211,2212,2213,2214,2215,2221,2222,2223,2224,2225,2231,2232,2233,2234,2235,2241,2242,2243,2244,2245};

function GM_hj()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");

	for i= 1 ,table.getn(tHuJia) do
		ClientBackpack:addItem(tHuJia[i], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tHuJia[i]).Name);
	end

	return	
end

--获得红石
local tRedStone = {701,703,705,707,709,710,711,712,715,716,717,718,720,724};

function GM_hs()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");

	for i= 1 ,table.getn(tRedStone) do
		ClientBackpack:addItem(tRedStone[i], 64);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tRedStone[i]).Name);
	end
	
	ClientBackpack:addItem(706, 640);
	ClientCurGame:sendChat("获得"..DefMgr:getItemDef(706).Name)
	
	return	
end


--获得机械
local tMachine = {725,728,729,};

function GM_jx()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	ClientBackpack:addItem(3800, 3);
	ClientCurGame:sendChat("获得"..DefMgr:getItemDef(3800).Name)
	for i= 1 ,table.getn(tMachine) do
		ClientBackpack:addItem(tMachine[i], 128);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tMachine[i]).Name);
	end
	
	return	
end

--获得机械
local tTest1 = 
{
1,
1,
2,
3,
4,
5,
6,
7,
8,
9,
100,
101,
102,
104,
105,
106,
107,
108,
109,
112,
113,
114,
115,
122,
123,
126,
200,
201,
202,
203,
204,
205,
206,
207,
208,
209,
210,
211,
212,
213,
214,
215,
216,
217,
218,
219,
220,
221,
222,
223,
224,
225,
226,
227,
228,
229,
230,
231,
236,
237,
238,
239,
240,
241,
242,
243,
300,
301,
302,
303,
304,
305,
306,
307,
308,
309,
310,
311,
312,
313,
400,
401,
402,
403,
404,
405,
406,
408,
409,
410,
411,
412,
413,
414,
415,
416,
417,
500,
501,
502,
503,
504,
505,
506,
507,
509,
510,
511,
513,
514,
515,
516,
517,
518,
519,
520,
521,
522,
523,
524,
525,
526,
527,
529,
530,
531,
534,
535,
540,
541,
547,
548,
549,
600,
601,
602,
603,
604,
605,
606,
607,
608,
609,
610,
611,
612,
613,
614,
615,
616,
617,
618,
619,
620,
621,
622,
623,
624,
625,
626,
627,
628,
629,
630,
631,
632,
633,
634,
635,
636,
637,
638,
639,
640,
641,
642,
643,
644,
645,
646,
647,
648,
649,
650,
651,
652,
653,
654,
655,
656,
657,
658,
659,
660,
661,
662,
663,
664,
665,
666,
667,
668,
669,
670,
671,
672,
673,
674,
675,
676,
677,
678,
679,
680,
681,
682,
700,
701,
702,
703,
704,
705,
706,
707,
708,
709,
710,
711,
712,
715,
716,
717,
718,
719,
720,
724,
725,
726,
728,
729,
730,
731,
800,
801,
802,
803,
804,
805,
806,
807,
808,
809,
810,
811,
812,
813,
814,
815,
816,
817,
819,
820,
822,
823,
824,
828,
829,
830,
832,
833,
834,
839,
1000,
1001,
1002,
1003,
1004,
1005,
1011,
1012,
1013,
1014,
1015,
1021,
1022,
1023,
1024,
1025,
1031,
1032,
1033,
1034,
1035,
1041,
1042,
1043,
1044,
1045,
1050,
1051,
1052,
1055,
1056,
1200,
1201,
1202,
1203,
1204,
1205,
1207,
1208,
1209,
1302,
1303,
1304,
1306,
1307,
1308,
1310,
1314,
1315,
1316,
1320,
1321,
1322,
1323,
1326,
1400,
1401,
1402,
1403,
1500,
1501,
1502,
1503,
1504,
1505,
1506,
1507,
1508,
1509,
1510,
1511,
1512,
1513,
1514,
1800,
1804,
1805,
1806,
1807,
1809,
1810,
1811,
1812,
1813,
1814,
1815,
1816,
1817,
1818,
1819,
1820,
1821,
1822,
1900,
1901,
1902,
1903,
1904,
1905,
1906,
1907,
1908,
1909,
1910,
1911,
1912,
1913,
1914,
1915,
1916,
1917,
1918,
1919,
1920,
1921,
1922,
1923,
1924,
1925,
1926,
1927,
1928,
1929,
1935,
1936,
1937,
1938,
1939,
2001,
2002,
2003,
2004,
2005,
2050,
2051,
2052,
2054,
2201,
2202,
2203,
2204,
2205,
2211,
2212,
2213,
2214,
2215,
2221,
2222,
2223,
2224,
2225,
2231,
2232,
2233,
2234,
2235,
2241,
2242,
2243,
2244,
2245,
2250,
2251,
2252,
2500,
2501,
2502,
2505,
2506,
2507,
2508,
2509,
2510,
2512,
2513,
2514,
2515,
2516,
2517,
2518,
2519,
2520,
2521,
2522,
2523,
2524,
2525,
2526,
2527,
2530,
2531,
2533,
2700,
2701,
2702,
2703,
2704,
2705,
2706,
2707,
2708,
2709,
2710,
2711,
2712,
2713,
2714,
2715,
2716,
2717,
2718,
2719,
2720,
2721,
2722,
2723,
2724,
2725,
2726,
2727,
2728,
2729,
2730,
2731,
2732,
2733,
2734,
2735,
2736,
2737,
2738,
2739,
2740,
2741,
2742,
2743,
2744,
2745,
2746,
2747,
2748,
2749,
2750,
2751,
2752,
2753,
2754,
2755,
2756,
2757,
2758,
2759,
2760,
2761,
2762,
2763,
2764,
2765,
2766,
2767,
2768,
2769,
2770,
2771,
2772,
2773,
2774,
2775,
2776,
2777,
2778,
2779,
2780,
2781,
2782,
2783,
2784,
2800,
2801,
2802,
2803,
2804,
2805,
2806,
2807,
2808,
2809,
2810,
2811,
2812,
2813,
2814,
2815,
2816,
2817,
2818,
2819,
2820,
2821,
2822,
2823,
2824,
2825,
2826,
2827,
2828,
2829,
2830,
2831,
2832,
2833,
2834,
2835,
2836,
2837,
2838,
2839,
2840,
2841,
2842,
2843,
2844,
2845,
2846,
2847,
2848,
2849,
2850,
2851,
2852,
2853,
2854,
2855,
2856,
2857,
2858,
2859,
2860,
2861,
2862,
2863,
2864,
2865,
2866,
2867,
2868,
2869,
2900,
3001,
3002,
3003,
3004,
3005,
3006,
3007,
3008,
3101,
3102,
3105,
3107,
3108,
3109,
3117,
3400,
3401,
3402,
3403,
3404,
3407,
3408,
3501,
3502,
3800,
3802,
3804,
3807,

};

function GM_1()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 0
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end

function GM_2()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 30
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_3()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 60
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_4()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 90
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_5()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 120
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_6()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 150
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_7()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 180
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_8()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 210
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_9()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 240
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_10()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 270
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_11()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 300
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_12()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 330
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_13()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 360
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_14()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 390
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_15()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 420
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_16()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 450
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_17()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 480
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_18()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 510
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_19()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 540
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_20()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 570
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_21()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 600
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end
function GM_22()
	ClientBackpack:clearPack();
	ClientCurGame:sendChat("清除背包");
	for i= 1 ,30 do
		local k = 630
		ClientBackpack:addItem(tTest1[i+k], 1);
		ClientCurGame:sendChat("获得"..DefMgr:getItemDef(tTest1[i+k]).Name);
	end
	
	return	
end

--给自己加buff
function GM_mybuff()
	MainPlayerAttrib:addBuff(1, 2);
end

function GM_clearbuff()
	MainPlayerAttrib:removeBuff(1);
end












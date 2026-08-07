--Protocol.lua
--@brief	所有协议记录表
--@date  	2013/12/05
--@author 	SuYuan
--@note 	所有协议记录表

ProtocolLoadingList = {
	-------------------------------------帐号相关协议--------------------------------------
	[10] = {
			[20] = 0,[10] = 0,[12] = 0,[22] = 0,[30] = 0,[24] = 0,[26] = 0,[15] = 0,[28] = 0,[29] = 0,
			[1] = 0,[3] = 0,[5] = 0,[57] = 0,[59] = 0,[61] = 0,[63] = 0,[65] = 0,[7] = 0,[40] = 0,[21] = 0,
			[32] = 0,[13] = 0,[23] = 0,[25] = 0,[27] = 0,[16] = 0,[4000] = 0,[3000] = 0,[56] = 0,[58] = 0,[33] = 0,
			[60] = 0,[64] = 0,[2] = 0,[4] = 0,[6] = 0,[8] = 0,[41] = 0,},
	-------------------------------------交易行相关协议--------------------------------------
	[12] = {
			[1] = 1,[3] = 1,[5] = 1,[7] = 1,[9] = 1,[11] = 1,[2] = 1,[4] = 1,[6] = 1,[8] = 1,
			[10] = 1,[12] = 1,},
	-------------------------------------房间相关协议--------------------------------------
	[60] = {
			[1] = 1,[3] = 0,[7] = 0,[11] = 1,[12] = 1,[13] = 0,[14] = 1,[16] = 1,[18] = 0,[21] = 0,
			[34] = 0,[81] = 1,[95] = 1,[97] = 1,[2] = 1,[4] = 0,[6] = 1,[9] = 1,[8] = 0,[10] = 1,[11] = 1,
			[12] = 1,[15] = 1,[17] = 1,[18] = 0,[19] = 0,[20] = 0,[22] = 0,[23] = 1,[24] = 1,[25] = 1,[26] = 1,
			[27] = 1,[28] = 1,[35] = 0,[82] = 1,[29] = 1,[30] = 1,[31] = 1,[32] = 1,[33] = 1,[36] = 0,[98] = 1,
			[100] = 0,},
	-------------------------------------vip中心相关协议--------------------------------------
	[52] = {
			[1] = 1,[3] = 1,[5] = 1,[9] = 1,[11] = 1,[13] = 1,[2] = 1,[4] = 1,[6] = 1,[11] = 0,
			[10] = 1,[12] = 1,[14] = 1,},
	-------------------------------------英雄联赛相关协议--------------------------------------
	[120] = {
			[1] = 1,[3] = 1,[5] = 1,[7] = 1,[9] = 1,[11] = 1,[13] = 1,[15] = 1,[17] = 0,[19] = 1,
			[21] = 1,[23] = 0,[24] = 1,[28] = 1,[29] = 1,[31] = 1,[34] = 1,[37] = 1,[39] = 1,[41] = 1,[43] = 1,
			[45] = 1,[47] = 0,[52] = 0,[53] = 0,[59] = 1,[60] = 1,[61] = 1,[62] = 1,[71] = 1,[73] = 1,[75] = 1,
			[77] = 1,[79] = 1,[81] = 1,[83] = 1,[85] = 1,[87] = 1,[89] = 1,[2] = 1,[4] = 1,[6] = 1,[8] = 1,
			[10] = 1,[12] = 1,[14] = 1,[16] = 1,[18] = 1,[20] = 1,[22] = 1,[25] = 1,[30] = 1,[32] = 1,[33] = 0,
			[35] = 1,[36] = 0,[38] = 1,[40] = 1,[42] = 1,[44] = 1,[46] = 1,[48] = 0,[49] = 0,[54] = 0,[55] = 0,
			[58] = 1,[72] = 1,[74] = 1,[76] = 1,[78] = 1,[80] = 1,[82] = 1,[84] = 1,[86] = 1,[88] = 1,[90] = 1,
			[91] = 0,[63] = 0,},
	-------------------------------------宠物系统相关协议--------------------------------------
	[96] = {
			[1] = 0,[5] = 1,[3] = 1,[7] = 1,[8] = 1,[9] = 1,[18] = 1,[20] = 1,[22] = 1,[24] = 1,
			[26] = 1,[2] = 1,[6] = 1,[4] = 1,[16] = 1,[17] = 1,[12] = 0,[13] = 1,[14] = 0,[15] = 1,[19] = 1,
			[21] = 1,[25] = 1,[27] = 1,},
	-------------------------------------抽奖相关协议--------------------------------------
	[95] = {
			[1] = 1,[3] = 1,[5] = 1,[6] = 1,[7] = 1,[2] = 1,[4] = 1,[8] = 1,},
	-------------------------------------师徒相关协议--------------------------------------
	[24] = {
			[1] = 1,[3] = 1,[5] = 1,[7] = 1,[9] = 1,[11] = 1,[13] = 1,[16] = 1,[18] = 1,[23] = 1,
			[25] = 0,[26] = 1,[28] = 1,[2] = 1,[4] = 1,[6] = 1,[8] = 1,[10] = 1,[12] = 1,[14] = 1,[15] = 0,
			[17] = 1,[19] = 1,[20] = 0,[21] = 0,[22] = 0,[24] = 1,[27] = 1,[29] = 1,},
	-------------------------------------坐骑许愿相关协议--------------------------------------
	[108] = {
			[1] = 1,[3] = 1,[5] = 1,[6] = 1,[7] = 1,[2] = 1,[4] = 1,[8] = 1,[9] = 1,},
	-------------------------------------爱心许愿相关协议--------------------------------------
	[83] = {
			[1] = 1,[3] = 1,[2] = 1,[4] = 1,},
	-------------------------------------称号相关协议--------------------------------------
	[22] = {
			[1] = 1,[4] = 0,[2] = 1,[5] = 0,[3] = 0,},
	-------------------------------------成就相关协议--------------------------------------
	[23] = {
			[1] = 1,[4] = 0,[5] = 1,[2] = 1,[3] = 0,[6] = 1,},
	----------------------------------------徽章相关协议------------------------------------
	[117] = {
			[1] = 1,[3] = 1,[2] = 1,[4] = 1,},
	-------------------------------------错误日志协议--------------------------------------
	[72] = {
			[2] = 1,[4] = 1,[1] = 1,[3] = 1,},
	-------------------------------------错误信息协议--------------------------------------
	[73] = {
			[3] = 1,[1] = 1,[14] = 1,[4] = 1,[2] = 1,[15] = 1,[20] = 1,[21] = 1,},
	-------------------------------------副本房间相关协议--------------------------------------
	[18] = {
			[1] = 1,[3] = 0,[5] = 1,[7] = 0,[11] = 1,[12] = 1,[13] = 1,[14] = 1,[16] = 1,[18] = 1,
			[20] = 1,[22] = 0,[24] = 1,[27] = 1,[29] = 1,[31] = 1,[32] = 0,[6] = 1,[4] = 0,[9] = 1,[8] = 0,
			[10] = 1,[15] = 1,[17] = 1,[19] = 1,[21] = 1,[23] = 0,[24] = 1,[25] = 1,[26] = 1,[28] = 1,[30] = 1,
			[33] = 0,},
	-------------------------------------商城相关协议--------------------------------------
	[61] = {
			[1] = 1,[3] = 1,[6] = 1,[8] = 1,[10] = 1,[12] = 1,[14] = 1,[16] = 1,[19] = 1,[20] = 1,
			[23] = 1,[25] = 1,[27] = 1,[2] = 1,[4] = 1,[5] = 1,[7] = 1,[9] = 1,[11] = 1,[13] = 1,[15] = 1,
			[17] = 1,[18] = 0,[21] = 1,[22] = 0,[24] = 1,[26] = 1,[28] = 1,},
	-------------------------------------公告相关协议--------------------------------------
	[11] = {
			[1] = 1,[3] = 1,[5] = 1,[7] = 1,[2] = 1,[4] = 1,[6] = 1,[8] = 1,[9] = 0,},
	-------------------------------------弹弹岛好友相关协议--------------------------------------
	[27] = {
			[2] = 1,[4] = 1,[6] = 1,[8] = 1,[10] = 1,[15] = 1,[18] = 0,[23] = 1,[24] = 1,[28] = 1,
			[29] = 1,[38] = 1,[40] = 1,[42] = 1,[44] = 1,[1] = 1,[3] = 1,[5] = 1,[7] = 1,[9] = 1,[11] = 1,
			[13] = 1,[14] = 0,[12] = 0,[16] = 1,[17] = 0,[19] = 0,[20] = 0,[21] = 0,[22] = 0,[25] = 1,[30] = 1,
			[39] = 1,[41] = 1,[43] = 1,[45] = 1,},
	-------------------------------------活动广场相关协议--------------------------------------
	[91] = {
			[1] = 1,[3] = 1,[2] = 1,[4] = 1,},
	-------------------------------------成长基金相关协议--------------------------------------
	[116] = {
			[1] = 1,[3] = 1,[5] = 1,[2] = 1,[4] = 1,[6] = 1,},
	-------------------------------------结婚系统协议--------------------------------------
	[84] = {
			[1] = 1,[4] = 1,[7] = 1,[8] = 1,[10] = 1,[12] = 1,[16] = 1,[22] = 1,[24] = 1,[26] = 1,
			[28] = 1,[30] = 1,[32] = 1,[37] = 1,[39] = 0,[18] = 1,[44] = 1,[47] = 1,[42] = 1,[49] = 1,[51] = 1,
			[54] = 1,[2] = 1,[3] = 0,[5] = 1,[6] = 1,[14] = 1,[9] = 1,[15] = 1,[11] = 1,[13] = 1,[17] = 1,
			[21] = 1,[23] = 1,[25] = 1,[27] = 1,[29] = 1,[33] = 1,[34] = 0,[31] = 1,[35] = 1,[36] = 0,[38] = 1,
			[40] = 0,[19] = 1,[20] = 0,[45] = 1,[48] = 1,[50] = 1,[46] = 0,[43] = 1,[52] = 1,[53] = 0,[55] = 1,
			[41] = 1,[56] = 0,},
	-------------------------------------礼包道具相关协议--------------------------------------
	[90] = {
			[1] = 1,[3] = 1,[2] = 1,[4] = 1,},
	-------------------------------------弹弹岛礼包码兑换--------------------------------------
	[82] = {
			[1] = 1,[2] = 1,},
	-------------------------------------聊天相关协议--------------------------------------
	[16] = {
		[1] = 0,[3] = 0,[5] = 0,[7] = 0,[11] = 0,[2] = 0,[6] = 0,[8] = 0,[9] = 0,[10] = 0,
		[12] = 0,},
	-------------------------------------排行榜相关协议（新）----------------------------------
	[111] = {
			[1] = 1,[3] = 1,[2] = 1,[4] = 1,[5] = 1,[6] = 1,[7] = 1,[8] = 1,[9]=1,[10]=1},
	-------------------------------------升阶相关协议----------------------------------
	[126] = {
			[1] = 1,[3] = 1,[5] = 1,[7] = 0,[8] = 1,[10] = 1,[2] = 1,[4] = 1,[6] = 1,[9] = 1,
			[11] = 1,},
	-------------------------------------强化相关协议--------------------------------------
	[109] = {
			[1] = 1,[3] = 1,[5] = 1,[7] = 1,[9] = 1,[11] = 1,[13] = 1,[15] = 1,[2] = 1,[4] = 1,
			[6] = 1,[8] = 1,[10] = 1,[12] = 1,[14] = 1,[16] = 1,},
	-------------------------------------任务相关协议--------------------------------------
	[20] = {
			[1] = 1,[4] = 1,[13] = 1,[14] = 1,[16] = 0,[24] = 1,[18] = 1,[20] = 1,[21] = 1,[11] = 0,
			[27] = 1,[29] = 1,[30] = 1,[32] = 1,[34] = 1,[36] = 1,[38] = 1,[40] = 1,[42] = 1,[2] = 1,[3] = 0,
			[5] = 1,[6] = 1,[7] = 1,[8] = 1,[9] = 1,[8] = 1,[10] = 0,[15] = 0,[17] = 1,[19] = 1,[22] = 1,
			[25] = 1,[28] = 1,[31] = 1,[33] = 1,[35] = 1,[37] = 1,[39] = 1,[41] = 1,[43] = 1,[44] = 1,},
	-------------------------------------首冲奖励、抽奖相关协议--------------------------------------
	[87] = {
			[1] = 1,[3] = 1,[2] = 1,[4] = 1,},
	-------------------------------------玩家物品相关协议--------------------------------------
	[21] = {
			[1] = 0,[3] = 0,[5] = 1,[73] = 0,[75] = 0,[76] = 0,[78] = 0,[79] = 0,[17] = 0,[20] = 0,
			[42] = 0,[35] = 0,[37] = 0,[39] = 0,[41] = 0,[43] = 0,[45] = 0,[46] = 0,[49] = 0,[51] = 0,[54] = 0,
			[58] = 0,[60] = 0,[65] = 0,[70] = 0,[63] = 0,[80] = 0,[82] = 0,[2] = 0,[4] = 0,[6] = 1,[74] = 0,
			[77] = 0,[16] = 0,[18] = 0,[21] = 0,[36] = 0,[38] = 0,[40] = 0,[44] = 0,[47] = 0,[48] = 0,[50] = 0,
			[52] = 0,[53] = 0,[55] = 0,[59] = 0,[61] = 0,[62] = 0,[64] = 0,[66] = 0,[67] = 0,[62] = 0,[64] = 0,
			[81] = 0,[83] = 0,[85] = 0,[30] = 0,[68] = 0,[31] = 0,[69] = 0,[88] = 0,},
	-------------------------------------附近好友相关协议--------------------------------------
	[28] = {
			[1] = 1,[3] = 1,[5] = 1,[7] = 1,[9] = 1,[11] = 1,[13] = 1,[15] = 1,[17] = 1,[22] = 1,
			[2] = 1,[4] = 1,[6] = 1,[8] = 1,[10] = 1,[12] = 1,[14] = 1,[16] = 1,[18] = 1,[19] = 1,[20] = 1,
			[21] = 1,[23] = 1,},
	-------------------------------------系统相关协议--------------------------------------
	[80] = {
			[7] = 1,[11] = 1,[13] = 0,[16] = 0,[24] = 0,[8] = 1,[12] = 1,[14] = 0,[15] = 0,[23] = 0,
			[25] = 0,[26] = 0,[27] = 0,[28] = 0,[29] = 0,[5] = 0,[4] = 0,},
	-------------------------------------邀请码相关协议--------------------------------------
	[89] = {
			[1] = 1,[3] = 1,[5] = 1,[7] = 1,[11] = 1,[13] = 1,[15] = 1,[9] = 1,[2] = 1,[4] = 1,
			[6] = 1,[8] = 1,[10] = 1,[12] = 1,[14] = 1,[16] = 1,[17] = 0,},
	-------------------------------------战斗相关协议--------------------------------------
	[70] = {
			[3] = 0,[4] = 0,[8] = 0,[10] = 0,[11] = 0,[13] = 0,[15] = 0,[18] = 0,[20] = 0,[22] = 0,
			[23] = 0,[26] = 0,[34] = 0,[36] = 0,[37] = 0,[39] = 0,[41] = 0,[43] = 0,[45] = 0,[47] = 0,[49] = 0,
			[50] = 0,[51] = 0,[55] = 0,[60] = 0,[62] = 0,[1] = 0,[5] = 0,[9] = 0,[12] = 0,[14] = 0,[16] = 0,
			[17] = 0,[19] = 0,[21] = 0,[24] = 0,[30] = 0,[28] = 0,[27] = 0,[32] = 0,[33] = 0,[35] = 0,[38] = 0,
			[40] = 0,[42] = 0,[44] = 0,[46] = 0,[48] = 0,[52] = 0,[61] = 0,[63] = 0,[64] = 0,[6] = 0,[7] = 0,
			[53] = 0,[54] = 0,[56] = 0,[57] = 0,[29] = 0,[65] = 0,[105] = 0,[108]=0,[110]=0,[112]=0,},
	-------------------------------------转生相关协议--------------------------------------
	[92] = {
			[1] = 1,[3] = 1,[2] = 1,[4] = 1,},
	-------------------------------------装备升星相关协议--------------------------------------
	[93] = {
			[1] = 1,[2] = 1,},
	-------------------------------------付费相关协议--------------------------------------
	[74] = {
			[1] = 0,[3] = 0,[6] = 0,[2] = 0,[4] = 0,[7] = 0,[8] = 0,[9] = 0,[12]=1,[13]=1,[14]=0,[16]=0},
	-------------------------------------公会相关协议--------------------------------------
	[32] = {
			[1] = 1,[3] = 1,[5] = 1,[7] = 1,[9] = 1,[11] = 1,[12] = 1,[14] = 1,[16] = 1,[18] = 1,
			[20] = 1,[22] = 1,[24] = 1,[26] = 1,[28] = 1,[30] = 1,[32] = 1,[34] = 1,[36] = 1,[38] = 1,[40] = 1,
			[42] = 1,[44] = 1,[46] = 1,[48] = 1,[49] = 1,[51] = 1,[52] = 1,[53] = 1,[55] = 1,[57] = 1,[59] = 1,
			[61] = 1,[63] = 1,[65] = 1,[68] = 1,[73] = 1,[71] = 1,[74] = 1,[76] = 1,[78] = 1,[80] = 1,[81] = 1,
			[83] = 1,[86] = 1,[88] = 1,[2] = 1,[4] = 1,[6] = 1,[8] = 1,[10] = 1,[13] = 1,[15] = 1,[17] = 1,
			[19] = 1,[21] = 1,[23] = 1,[25] = 1,[27] = 1,[29] = 1,[31] = 1,[33] = 1,[35] = 1,[37] = 1,[39] = 1,
			[41] = 1,[43] = 1,[45] = 1,[47] = 1,[50] = 1,[54] = 1,[56] = 1,[58] = 1,[60] = 1,[62] = 1,[64] = 1,
			[66] = 1,[69] = 1,[70] = 1,[72] = 1,[75] = 1,[77] = 1,[79] = 1,[82] = 1,[84] = 1,[85] = 0,[87] = 1,
			[89] = 1,},
	-----------------------------------排位赛---------------------
	[63] = {
			[1] = 1,[5] = 1,[23] = 1,[15] = 1,[17] = 1,[19] = 1,[27] = 1,[2] = 1,[6] = 1,[22] = 1,
			[16] = 1,[18] = 1,[20] = 1,[28] = 1,},
	-------------------------------------世界BOSS大厅相关协议--------------------------------------
	[97] = {
			[1] = 1,[3] = 1,[5] = 1,[10] = 1,[12] = 1,[2] = 1,[4] = 1,[6] = 1,[7] = 1,[8] = 1,
			[9] = 1,[11] = 1,[13] = 1,},
	-------------------------------------物品回收相关协议--------------------------------------
	[94] = {
			[1] = 1,[3] = 0,[4] = 1,[6] = 1,[8] = 1,[10] = 1,[2] = 1,[5] = 1,[7] = 1,[9] = 1,
			[11] = 1,},
	-------------------------------------邮件相关协议--------------------------------------
	[38] = {
			[1] = 1,[3] = 1,[5] = 1,[7] = 1,[10] = 1,[12] = 1,[16] = 1,[18] = 1,[12] = 1,[14] = 1,
			[15] = 1,[2] = 1,[4] = 1,[6] = 1,[8] = 1,[9] = 0,[11] = 1,[19] = 1,[13] = 1,[2] = 1,[10] = 1,
			[13] = 1,[17] = 1,},
	    ----------------------------------弹王挑战赛相关协议--------------------------------------
	[98] = {
			[1] = 1,[3] = 1,[7] = 1,[8] = 1,[10] = 1,[15] = 1,[12] = 1,[17] = 1,[19] = 1,[21] = 1,
			[23] = 1,[26] = 1,[27] = 1,[28] = 1,[2] = 1,[4] = 1,[5] = 1,[9] = 1,[13] = 1,[18] = 1,[20] = 1,
			[22] = 1,[25] = 1,[24] = 1,[26] = 1,[19] = 1,[20] = 1,},
	    ----------------------------------弹王挑战赛相关协议--------------------------------------
	[113] = {
			[1] = 1,[3] = 1,[5] = 1,[7] = 1,[9] = 1,[11] = 1,[13] = 1,[2] = 1,[4] = 1,[6] = 1,
			[8] = 1,[10] = 1,[12] = 1,},
	    -------------------------------------单人副本相关协议--------------------------------------
	[99] = {
			[1] = 1,[3] = 1,[5] = 1,[7] = 1,[9] = 1,[11] = 1,[13] = 1,[15] = 1,[17] = 1,[19] = 1,
			[21] = 1,[22] = 1,[24] = 1,[25] = 1,[27] = 1,[30] = 1,[32] = 1,[34] = 1,[36] = 1,[38] = 1,[2] = 1,
			[4] = 1,[6] = 1,[8] = 1,[10] = 1,[12] = 1,[14] = 1,[16] = 1,[18] = 1,[20] = 1,[23] = 1,[26] = 1,
			[28] = 1,[31] = 1,[33] = 1,[35] = 1,[37] = 1,[39] = 1,[29] = 1,},
	    -------------------------------------修炼系统相关协议--------------------------------------
	[103] = {
			[1] = 1,[3] = 1,[5] = 1,[2] = 1,[4] = 1,[6] = 1,},
	    -------------------------------------星魂系统相关协议--------------------------------------
	[19] = {
			[1] = 1,[3] = 1,[2] = 1,[4] = 1,},
	    -------------------------------------星魂系统相关协议 END --------------------------------
	[106] = {
			[1] = 1,[2] = 1,},
	    -------------------------------------公告协议id --------------------------------
	[112] = {
			[1] = 1,[2] = 1,},
	    -------------------------------------活动 --------------------------------
	[107] = {
			[1] = 1,[2] = 1,[3] = 1,[4] = 1,[5] = 1,[6] = 1,[7] = 1,[10] = 1,[14] = 1,[16] = 1,
			[9] = 1,[11] = 1,[13] = 1,[15] = 1,[17] = 1,[18] = 1,[22] = 1,[23] = 1,[24] = 1,[25] = 1,[8] = 1,[28]=1,[29] = 1,[30]=1,[31] = 1,[38]=1,[39]=1,[40]=1,[41]=1,[77]=0,[79]=0,[81]=0},
	    -------------------------------------缓存中心相关协议--------------------------------------
	[102] = {
			[1] = 1,[2] = 1,[5] = 1,[6] = 1,[7] = 1,[8] = 1,[11] = 1,[12] = 1,[16] = 1,[17] = 1,
			[18] = 1,},
	 -------------------------------------鸡腿协议--------------------------------------
	[105] = {
			[1] = 1,[2] = 1,},
	    -------------------------------------月卡系统相关协议--------------------------------------
	[104] = {
			[1] = 1,[3] = 1,[2] = 1,[4] = 1,},
	    -------------------------------------合成相关协议--------------------------------------
	[110] = {
			[1] = 1,[3] = 1,[2] = 1,[4] = 1,},
	    ------------------------------------活跃度相关协议--------------------------------------
	[115] = {
			[1] = 1,[3] = 1,[5] = 1,[2] = 1,[4] = 1,[6] = 1,},
	    ------------------------------------活跃度相关协议--------------------------------------
	[15] = {
			[1] = 1,[3] = 1,[4] = 1,[5] = 1,[6] = 1,[7] = 1,[9] = 1,[11] = 1,[12] = 1,[13] = 1,
			[15] = 1,[16] = 1,[17] = 1,[19] = 1,[21] = 1,[23] = 1,[25] = 0,[26] = 1,[28] = 1,[2] = 1,[8] = 1,
			[10] = 1,[14] = 1,[18] = 1,[20] = 1,[22] = 1,[24] = 1,[27] = 1,[29] = 1,[50] = 0,},
	    ------------------------------------祈福相关协议--------------------------------------
	[118] = {
			[1] = 1,[3] = 1,[5] = 1,[7] = 1,[9] = 1,[11] = 1,[13] = 1,[15] = 1,[17] = 1,[19] = 1,
			[22] = 1,[2] = 1,[4] = 1,[6] = 1,[8] = 1,[10] = 1,[12] = 1,[14] = 1,[16] = 1,[18] = 1,[20] = 1,
			[23] = 1,},
	    -----------------------------装备抽奖相关协议----------------------------------------
	[119] = {
			[1] = 1,[14] = 1,[2] = 1,[15] = 1,},
	    -----------------------------修炼相关协议----------------------------------------
	[121] = {
			[1] = 1,[3] = 1,[2] = 1,[4] = 1,},
	    -----------------------------在线奖励相关协议----------------------------------------
	[122] = {
			[1] = 1,[3] = 1,[2] = 1,[4] = 1,},
	    -----------------------------卡牌系统相关协议----------------------------------------
	[123] = {
			[1] = 1,[3] = 1,[5] = 1,[7] = 0,[9] = 0,[11] = 1,[2] = 1,[4] = 1,[6] = 1,[8] = 0,
			[10] = 1,[12] = 1,},
	    -----------------------------LBS系统相关协议----------------------------------------
	[124] = {
			[1] = 1,[3] = 1,[5] = 1,[9] = 1,[11] = 1,[13] = 1,[2] = 1,[4] = 1,[6] = 1,[10] = 1,
			[12] = 1,[14] = 1,},
	    --------------------------公会战相关协议-----------------------------------------
	[125] = {
			[1] = 1,[3] = 1,[5] = 0,[6] = 0,[7] = 1,[8] = 1,[10] = 1,[12] = 1,[14] = 1,[17] = 0,
			[24] = 1,[28] = 1,[60] = 1,[62] = 1,[30] = 1,[32] = 1,[34] = 1,[2] = 1,[4] = 1,[9] = 1,[11] = 1,
			[13] = 1,[15] = 1,[16] = 0,[18] = 0,[19] = 0,[20] = 0,[61] = 1,[63] = 1,[25] = 1,[26] = 1,[27] = 1,
			[29] = 1,[31] = 1,[33] = 1,[35] = 1,},
	---------------------------------幸运礼盒相关协议------------------------
	[127] = {
			[1] = 1,[3] = 1,[5] = 1,[2] = 1,[4] = 1,[6] = 1,},
	-----------------------------------道具赛---------------------
	[64] = {
			[1] = 1,[2] = 1,[3] = 0,},

	-------------------------------符文系统---------------
	[13] = {[1]=1,[2]=1,[5]=1,[6]=1,[16]=1,[17]=1,[18]=1,[19]=1,[14]=1,[15]=1,[16]=1,[17]=1},
	-------------------------------世界组队Boss---------------
	[98] = {[33]=0,},
}
Protocol =
{
	-------------------------------------帐号相关协议--------------------------------------
	--主协议
	MAIN_ACCOUNT = 10,

	--子协议
	--客户端发到服务器 (C->S)					
	--帐号登录
	ACCOUNT_Login = 20,
	--创建角色	
	ACCOUNT_CreateRoleActor = 10,
	--获取角色列表		
	ACCOUNT_GetRoleActorList = 12,
	--角色登录		
	ACCOUNT_RoleActorLogin = 22,
	--帐号重新登录	
	ACCOUNT_LoginAgain = 30,
	--取随机名称		
	ACCOUNT_GetRandomName = 24,
	--设置帐号关联的token	
	ACCOUNT_SetToken = 26,
	--渠道登录验证	
	ACCOUNT_ChannelLogin = 15,	
	--客户端退到后台	
	ACCOUNT_ToBackGround = 28,
	--客户端回到前台		
	ACCOUNT_FromBackGround = 29,	
	--帐号注册			
	ACCOUNT_Register = 1,
	--修改密码
	ACCOUNT_ModifyPassword = 3,
	--找回密码
	ACCOUNT_FindPassword = 5,
	--帐号密码验证		
	ACCOUNT_Verification = 57,	
    --推送Token值
    ACCOUNT_SetNewToken  = 59,
    --获取本地推送信息列表
    ACCOUNT_GetPushList  = 61,
    --获取下载奖励物品列表
    ACCOUNT_GetDownloadRewardList = 63,
	--同步玩家帐号绑定状态
	ACCOUNT_SynAccountState = 65,
    -- 绑定邮箱
    ACCOUNT_SetEMail = 7,
	--获取角色信息列表
	ACCOUNT_GetRoleActorInfo = 40,

	--服务器发到客户端 (S->C)	
	--帐号登录成功
	ACCOUNT_LoginOk = 21,	
	--帐号登录失败
	ACCOUNT_LoginFail = 32,
	--发送角色列表
	ACCOUNT_SendRoleActorList = 13,
	--角色登录成功
	ACCOUNT_RoleActorLoginOk = 23,
	--返回随机名称
	ACCOUNT_GetRandomNameOk = 25,	
	--设置token成功
	ACCOUNT_SetTokenOk = 27,	
	--渠道登录结果
	ACCOUNT_ChannelLoginResult = 16,
	--快速帐号注册成功
	ACCOUNT_QuickRegisterOk = 4000,
	--帐号注册失败
	ACCOUNT_RegisterFail = 3000,

	--修改密码失败
	ACCOUNT_ModifyPasswordFail = 56,	

	--帐号密码验证结果
	ACCOUNT_VerificationResult = 58,
	--用户重复登录账号
	ACCOUNT_RepeatLogin = 33,
    --设置token成功
    ACCOUNT_SetNewTokenOk = 60,
    --获取下载奖励物品列表成功
    ACCOUNT_GetDownloadRewardListOK = 64,

    --帐号注册成功
    ACCOUNT_RegisterOk = 2,
    --修改密码成功
    ACCOUNT_ModifyPasswordOk = 4,
    --找回密码成功
    ACCOUNT_FindPasswordOk = 6,
    -- 绑定邮箱
    ACCOUNT_SetEMailOk = 8,
	--发送角色信息列表
	ACCOUNT_GetRoleActorInfoOk = 41,
	-------------------------------------交易行相关协议--------------------------------------
	--主协议
	MAIN_TRANSACTION = 12,					

	--子协议
	--客户端发到服务器 (C->S)		
	TRANSACTION_GetCommodityList = 1,		
	TRANSACTION_BuyCommodity = 3,		
	TRANSACTION_GetSaleList = 5,		
	TRANSACTION_Sales = 7,		
	TRANSACTION_UnSales = 9,		
	TRANSACTION_GetTransactionLogList = 11,		
	
	--服务器发到客户端 (S->C)
	--创建房间成功
	TRANSACTION_GetCommodityListOk = 2,		
	TRANSACTION_BuyCommodityStatus = 4,		
	TRANSACTION_GetSaleListOk = 6,		
	TRANSACTION_SalesStatus = 8,		
	TRANSACTION_UnSalesStatus = 10,		
	TRANSACTION_GetTransactionLogListOk = 12,		

	-------------------------------------幻化相关协议--------------------------------------
	--主协议
	MAIN_SHAPE = 17,					

	--子协议
	--客户端发到服务器 (C->S)		
	SHAPE_GetShapeInfo = 1,		
	SHAPE_OpenBox = 3,		
	SHAPE_UseItem = 5,		
	SHAPE_UseShape = 7,		
	SHAPE_SetShow = 9,		
	SHAPE_UpShapeInfo = 11,		
	
	--服务器发到客户端 (S->C)
	--创建房间成功
	SHAPE_GetShapeInfoOk = 2,		
	SHAPE_OpenBoxOk = 4,		
	SHAPE_UseItemOk = 6,		
	SHAPE_UseShapOk = 8,		
	SHAPE_SetShowOk = 10,		
	SHAPE_UpShapeInfoOk = 12,		
	
	-------------------------------------房间相关协议--------------------------------------
	--主协议
	MAIN_ROOM = 60,					

	--子协议
	--客户端发到服务器 (C->S)		
	--创建房间
	ROOM_CreateRoom = 1,		
	--获取房间列表
	ROOM_GetRoomList = 3,
	--退出房间
	ROOM_QuitRoom = 7,		
	--玩家更换座位
	ROOM_UpdateSeat = 11,		
	--房主更新房间属性
	ROOM_UpdateRoom = 12,		
	--快速游戏
	ROOM_QuickGame = 13,		
	--查找房间
	ROOM_SelectRoom = 14,		
	--玩家准备
	ROOM_GameReady = 16,	
	--随机配对对战用户
	ROOM_MakePair = 18,		
	--邀请
	ROOM_Invite = 21,
	--取消随机配对对战用户	
	ROOM_EndPair = 34,
	ROOM_AllRecord=81,

	ROOM_GetInvitePlayerList = 95,

	ROOM_GetFunnyMatchInfo = 97,
	ROOM_CheckPwPunish = 103,

	--服务器发到客户端 (S->C)
	--创建房间成功
	ROOM_CreateRoomOk = 2,		
	--返回房间列表
	ROOM_GetRoomListOk = 4,
	--进入房间成功
	ROOM_EnterRoomOk = 6,		
	--通知房间内玩家有新玩家进入
	ROOM_PlayerEnter = 9,		
	--退出房间成功
	ROOM_QuitRoomOk = 8,		
	--通知房间内玩家，玩家退出房间
	ROOM_PlayerQuit = 10,		
	--通知房间内所有玩家，玩家更换座位
	ROOM_UpdateSeat = 11,		
	--通知房间内所有玩家，房主更新房间属性
	ROOM_UpdateRoom = 12,		
	--找到房间需要密码
	ROOM_SelectRoomOk = 15,		
	--玩家准备
	ROOM_GameReadyOk = 17,		
	--通知所有玩家正在随机配对对战用户
	ROOM_MakePair = 18,		
	--随机配对成功同步对战玩家数据
	ROOM_MakePairOk = 19,		
	--通知所有玩家正在随机配对对战用户
	ROOM_MakePairFail = 20,		
	--被邀请
	ROOM_BeInvite = 22,

    --获取竞技商店物品
    ROOM_GetArenaStore = 23,
    -- 收到竞技商店物品
    ROOM_GetArenaStoreOk = 24,
    -- 购买竞技商店物品
    ROOM_BuyArenaStore = 25,
    -- 购买竞技场商品回调
    ROOM_BuyArenaStoreOk = 26,
    -- 刷新竞技场
    ROOM_RefreshArenaStore = 27,
    -- 开启座位
    ROOM_TurnOnSeat = 28,
    --退出匹配成功
    ROOM_EndPairOk = 35,
	ROOM_AllRecordOK=82,
    
    -- 关闭座位
    ROOM_TurnOffSeat = 29,
    ROOM_GetTournamentAim = 30,
    ROOM_GetTournamentAimOK = 31,
    ROOM_ReceiveTournamentAim = 32,
    ROOM_ReceiveTournamentAimOK = 33,

    ROOM_BackToRoom = 36,

    ROOM_GetGreatEscapeStatus = 40,
    ROOM_GetGreatEscapeStatusOk = 41,

    ROOM_GetFunnyMatchInfoOk = 98,
    ROOM_GetAdditionInfo = 100,
    ROOM_CheckPwPunishOk = 104,
	-------------------------------------vip中心相关协议--------------------------------------
	--主协议
	MAIN_VIP = 52,			

	--客户端发到服务器 (C->S)	
	--领取每日礼包
	VIP_ReceiveGiftBag = 1,	
	--获取vip信息
	VIP_GetVipInfo = 3,	
	--获取vip奖励列表
	VIP_GetVipRewardsInfo = 5,
	--获取vip等级礼包
	--VIP_GetVipLevelAward = 9,
	
	--获取特权礼包信息
	VIP_GetVipPrivilegeGift = 9,

	VIP_GetVipRebateInfo = 11,
	VIP_DrawVipRebate = 13,

	--服务器发到客户端 (S->C)
	--领取每日礼包成功
	VIP_ReceiveGiftBagOk = 2,	
	--获取vip信息成功
	VIP_GetVipInfoOk = 4,
	--奖励列表成功
	VIP_GetVipRewardsInfoOk = 6,
	--获取vip等级礼包
	--VIP_GetVipLevelAwardOK = 10,
	--获取vip礼包领取情况
	VIP_VipReceiveInfo = 11,
	
	--获取特权礼包信息结果
	VIP_GetVipPrivilegeGiftOk = 10,

	VIP_GetVipRebateInfoOk = 12,
	VIP_DrawVipRebateOk = 14,

	VIP_GetWebInfo = 15,
	VIP_GetWebInfoOk = 16,

	
	-------------------------------------英雄联赛相关协议--------------------------------------
	--主协议
	MAIN_HERO = 120,			

	--客户端发到服务器 (C->S)	
	--创建战队
	HERO_CreateTeam = 1,
	--获取战队列表
	HERO_GetHeroTeamList = 3,
	--申请战队
	HERO_ApplyHeroTeam = 5,
	--获取英雄联赛战队申请列表
	HERO_GetApplyList = 7,
	--审核申请列表
	HERO_Reviewed = 9,
	--查找战队
	HERO_SearchTeam = 11,
	--退出战队
	HERO_OutTeam = 13,
	--踢出战队
	HERO_KickTeam = 15,
	--邀请加入战队
	HERO_Invitation = 17,
	--同意加入战队
	HERO_Agree = 19,
	--进入战队界面准备战斗
	HERO_ReadyFight = 21,
	--匹配战斗
	HERO_MakePairHero = 23,
	--退出战队界面
	HERO_OutHeroRoom = 24,
	--取消匹配
	HERO_EndMakePairHero = 28,
	--报名参加小组赛
	HERO_SignHeroStrong = 29,
	--队长切换成员状态
	HERO_ChangeStatus = 31,
	--修改宣言和图片
	HERO_NewPhotoAndDec=34,
	--获取回放列表
	HERO_RecordList = 37,
	--请求观看回放
	HERO_Record = 39, 
	--获取某个回放中的双方玩家信息成功
	HERO_RecordMes = 41,
	--正在进行列表获取
	HERO_WatchList=43,
	PLAYER_Watch = 45,
	PLAYER_SynchronousWatch = 47,
	HERO_EndWatch = 52,
	--邀请进入战队准备
	HERO_InvitationReady = 53,
	--准备战斗
	HERO_Ready = 59,
	--取消准备
	HERO_CancelReady = 60,
	--提升为副队长
	HERO_Promotion = 61,
	--取消副队长
	HERO_Cancel  = 62,
	--英雄联赛奖励
	HERO_FirstSelectReward = 71,
	--海选赛排行
	HERO_FirstSelectRank = 73,
	--小组赛战绩
	HERO_TeamSelectRank = 75,
	--16强战绩
	HERO_Team16SelectStatus = 77,
	--8强战绩
	HERO_Team8SelectStatus = 79,
	--获取荣誉左边列表
	HERO_TeamFirstList = 81,
	--获取荣誉队伍信息
	HERO_TeamFirstDetail = 83,
	--英雄联赛开始时间
	HERO_HeroStartTime = 85,
	--获得报名参加的玩家列表
	HERO_GetEnterPlayerList = 87,
	-- 战队战绩
	HERO_GetFightMes = 89,

	--服务器发到客户端 (S->C)
	--创建战队成功
	HERO_CreateTeamOK = 2,
	--获取战队列表
	HERO_GetHeroTeamListOK = 4,
	--申请战队
	HERO_ApplyHeroTeamOK = 6,
	--获取英雄联赛战队申请列表成功
	HERO_GetApplyListOK = 8,
	--审核申请列表成功返回申请列表
	HERO_ReviewedOK = 10,
	--查找战队
	HERO_SearchTeamOK = 12,
	--退出战队
	HERO_OutTeamOK = 14,
	--踢出战队
	HERO_KickTeamOK = 16,
	--邀请加入战队，被邀请人收到
	HERO_InvitationOK = 18,
	--同意加入战队
	HERO_AgreeOK = 20,
	--进入战队界面准备战斗，战队界面成员收到
	HERO_ReadyFightOK = 22,
	--退出战队界面，战队界面成员收到
	HERO_OutHeroRoomOK = 25,
	--报名参加小组赛成功
	HERO_SignHeroStrongOk = 30,
	--队长切换成员状态，所有在战队界面成员都会收到
	HERO_ChangeStatuOk = 32,
	--更新玩家战队Id
	HERO_ChangeTeamOk = 33,
	--修改宣言和图片
	HERO_NewPhotoAndDecOK=35,
	-- 取消匹配
	HERO_EndMakePairHeroOk = 36,
	--获取回放列表成功
	HERO_RecordListOk = 38,
	--请求回放成功
	HERO_RecordOk = 40,
	--获取某个回放中的双方玩家信息成功
	HERO_RecordMesOk = 42,
	--正在进行列表获取成功
	HERO_WatchListOk=44,
	PLAYER_WatchOk = 46,
	PLAYER_SynchronousWatchOk = 48,
	PLAYER_WatchMes = 49,
	-- 邀请进入战队准备（被邀请人才能收到）
	HERO_InvitationReadyOk = 54,
	--审核小红点（队长才能收到）
	HERO_ReviewRedDot = 55,
	--匹配战斗失败
	HERO_MakePairHeroFail = 58,
	--英雄联赛奖励
	HERO_FirstSelectRewardOk = 72,
	--海选赛排行
	HERO_FirstSelectRankOk = 74,
	--小组赛战绩
	HERO_TeamSelectRankOk = 76,
	--16强战绩
	HERO_Team16SelectStatusOk = 78,
	--8强战绩
	HERO_Team8SelectStatusOk = 80,
	--荣誉列表
	HERO_TeamFirstListOk = 82,
	--获取荣誉队伍信息成功
	HERO_TeamFirstDetailOk = 84,
	--英雄联赛开始时间
	HERO_HeroStartTimeOk = 86,
	--获得报名参加的玩家列表
	HERO_GetEnterPlayerListOk = 88,
    --战队战绩
	HERO_GetFightMesOk = 90,
	--小组赛战斗匹配胜利
	HERO_CrossFightSuc = 91,
    --系统邀请进入联赛
	Invite_League  = 63,
	-------------------------------------宠物系统相关协议--------------------------------------
	--主协议
	MAIN_PET = 96,			

	--子协议
	--客户端发到服务器 (C->S)	
	--获取所有宠物列表
	PET_GetAllPetList = 1,
	--宠物出战状态
	PET_ChangeState = 5,
    --宠物抽奖
    PET_Lottery = 3,
    --宠物升级
    PET_Upgrade = 7,
    --宠物进阶
    PET_Advanced = 8,
	--宠物重生
	PET_Rebirth = 9,
	--获取宠物商店		
	PET_GetPetStore = 18,
	--购买宠物
	PET_PurchasePet = 20,
	--刷新宠物列表
	PET_RefreshStore = 22,
	--洗练宠物资质
	WashPetGift = 24,
	--宠物回收
	PET_RecyclePet = 26,
	PET_ChangePetSkin = 28,
	PET_GetPetSkinList = 30,

	--服务器发到客户端 (S->C)
	--获取所有宠物列表成功
	PET_GetAllPetListOk = 2,	
	--宠物出战状态
	PET_ChangeStateOK = 6,
	--宠物成功信息
	PET_PetInfoOK = 4,
    --宠物洗炼
	PET_ResetSkill = 16,
	--洗炼成功
	PET_ResetSkillOK = 17,
    --删除宠物
	PET_DeletePet = 12,
	--宠物抽奖成功
	PET_LotteryOK = 13,
	--宠物免费抽奖
	PET_GetFreeTime = 14,
	--宠物免费抽奖成功
	PET_GetFreeTimeOK = 15,
	--获取宠物商店成功
	PET_GetPetStoreOk = 19,
	--购买宠物成功
	PET_PurchasePetOk = 21,
	--洗练宠物资质成功
	PET_WashPetGiftOk = 25,
	--宠物回收成功
	PET_RecyclePetOk = 27,
	PET_ChangePetSkinOk = 29,
	PET_GetPetSkinListOk = 31,
	-------------------------------------抽奖相关协议--------------------------------------
	--主协议
	MAIN_DRAW = 95,						

	--子协议
	--客户端发到服务器 (C->S)	
	DRAW_GetDrawTypeList = 1,		
	DRAW_GetItemList = 3,		
	DRAW_DrawRefresh = 5,		
	DRAW_GetReward = 6,		
	DRAW_Draw = 7,	
			
	--服务器发到客户端 (S->C)
	DRAW_SendDrawTypeList = 2,	
	DRAW_SendItemList = 4,			
	DRAW_DrawOk = 8,

	-------------------------------------师徒相关协议--------------------------------------
	--主协议号
	MAIN_MENTORING = 24,

	--子协议
	--客户端发到服务器 (C->S)	
	MENTORING_GetTemple = 1,		
	MENTORING_GetMentoring = 3,		
	MENTORING_GetMyMaster = 5,		
	MENTORING_GetMyPupils = 7,		
	MENTORING_Baishi = 9,	
	MENTORING_Shoutu = 11,	
	MENTORING_GetMentoringMessage = 13,	
	MENTORING_Processing = 16,	
	MENTORING_Disassociate = 18,	
	MENTORING_GetTask = 23,
	MENTORING_GetReward = 25,
	MENTORING_XiaoJing = 26,
	MENTORING_ShouYe = 28,
			
	--服务器发到客户端 (S->C)
	MENTORING_GetTempleOk = 2,	
	MENTORING_GetMentoringOk = 4,	
	MENTORING_GetMyMasterOk = 6,	
	MENTORING_GetMyPupilsOk = 8,	
	MENTORING_BaishiOk = 10,	
	MENTORING_ShoutuOk = 12,	
	MENTORING_ApplerList = 14,	
	MENTORING_LogList = 15,	
	MENTORING_ProcessingOk = 17,	
	MENTORING_DisassociateOk = 19,	
	MENTORING_MoralityUpLevel = 20,
	MENTORING_BaishiPopMsg = 21,
	MENTORING_ShoutuPopMsg = 22,
	MENTORING_GetTaskOk = 24,
	MENTORING_XiaoJingOk = 27,
	MENTORING_ShouYeOk = 29,

	-------------------------------------坐骑许愿相关协议--------------------------------------
	--主协议号
	MAIN_MOUNTS = 108,
	
	--子协议--客户端发到服务器 (C->S)
	MOUNTS_GetAllMountsList = 1,
	MOUNTS_Activation = 3,
	MOUNTS_Upgrade = 5,
	MOUNTS_Advanced = 6,
	MOUNTS_ChangeState = 7,
	
	--子协议--服务器发到客户端 (S->C)
	MOUNTS_GetAllMountsListOK = 2,
	MOUNTS_MountsInfoOK = 4,
	MOUNTS_ChangeStateOK = 8,
	MOUNTS_UpgradeRecordOk = 9,

	-------------------------------------爱心许愿相关协议--------------------------------------
	--主协议
	MAIN_LOTTERY = 83,

	--子协议
	--客户端发到服务器 (C->S)		
	LOTTERY_ReceiveReward = 1,	
	LOTTERY_ReceiveZflh = 3,

	--服务器发到客户端 (S->C)
	LOTTERY_ReceiveRewardOk = 2,	
	LOTTERY_ReceiveZflhOk = 4,	
			
	-------------------------------------称号相关协议--------------------------------------
	--主协议	
	MAIN_TITLE = 22,						

	--子协议
	--客户端发到服务器 (C->S)
	TITLE_GetTitleList = 1,		
	TITLE_SetTitle = 4,		

	--服务器发到客户端 (S->C)		
	TITLE_GetTitleListOk = 2,		
	TITLE_SetTitleOk = 5,		
	TITLE_UpdateTitle = 3,		

	-------------------------------------成就相关协议--------------------------------------
	--主协议	
	MAIN_ACHIEVEMENT = 23,						

	--子协议
	--客户端发到服务器 (C->S)
	ACHIEVEMENT_GetAchievementList = 1,		
	ACHIEVEMENT_ChangeAchievement  = 4,	
	ACHIEVEMENT_GetAchievementReward = 5,	

	--服务器发到客户端 (S->C)		
	ACHIEVEMENT_GetAchievementListOk = 2,		
	ACHIEVEMENT_UpdateAchievement = 3,		
	ACHIEVEMENT_GetAchievementRewardOk = 6,

	----------------------------------------徽章相关协议------------------------------------
	--主协议
	MAIN_BADGE = 117,

	--子协议
	--客户端发到服务器（C->S）
	BADGE_GetBadgeList = 1,
	BADGE_UpgradeBadge = 3,

	--服务器发到客户端（S->C）
	BADGE_GetBadgeListOk = 2,
	BADGE_UpgradeBadgeOK = 4,
	-------------------------------------错误日志协议--------------------------------------
	--主协议
	MAIN_ERRORLOG = 72,						

	--子协议
	--客户端发到服务器 (C->S)
	ERRORLOG_SendLogList = 2,		
	ERRORLOG_SendLog = 4,		

	--服务器发到客户端 (S->C)		
	ERRORLOG_GetLogList = 1,		
	ERRORLOG_GetLog = 3,		

	-------------------------------------错误信息协议--------------------------------------
	--主协议
	MAIN_ERRORCODE = 73,						

	--子协议
	--客户端发到服务器 (C->S)
	ERRORCODE_CheckList = 3,		
	ERRORCODE_GetList = 1,	
	ERRORCODE_GetSmsCodeNewList = 14,	

	--服务器发到客户端 (S->C)
	ERRORCODE_CheckOK = 4,		
	ERRORCODE_GetListOK = 2,	
	ERRORCODE_GetSmsCodeNewListOk = 15,

	-------------------------------------地图相关协议--------------------------------------


	-------------------------------------分区相关协议--------------------------------------					
							
	--子协议
	--客户端发到服务器 (C->S)
	SERVER_GetPlayerArea = 20,		

	--服务器发到客户端 (S->C)
	SERVER_GetPlayerAreaOk = 21,		

	-------------------------------------副本房间相关协议--------------------------------------
	--主协议
	MAIN_BOSSMAPROOM = 18,						
										
	--子协议
	--客户端发到服务器 (C->S)	
	BOSSMAPROOM_CreateRoom = 1,			
	BOSSMAPROOM_GetRoomList = 3,		
	BOSSMAPROOM_EnterRoom = 5,		
	BOSSMAPROOM_QuitRoom = 7,
	BOSSMAPROOM_UpdateSeat = 11,		
	BOSSMAPROOM_UpdateRoom = 12,		
	BOSSMAPROOM_QuickGame = 13,		
	BOSSMAPROOM_SelectRoom = 14,
	BOSSMAPROOM_GameReady = 16,		
	BOSSMAPROOM_GetBossMapList = 18,		
	BOSSMAPROOM_GetRoomInfo = 20,		
	BOSSMAPROOM_Invite = 22,		
	BOSSMAPROOM_MakePair = 24,		
	BOSSMAPROOM_ResetMap = 27,
	BOSSMAPROOM_BossMapRecord = 29,
	BOSSMAPROOM_BackToRoom = 31,
	BOSSMAPROOM_Reward = 32,

	--服务器发到客户端 (S->C)
	BOSSMAPROOM_EnterRoomOk = 6,		
	BOSSMAPROOM_GetRoomListOk = 4,				
	BOSSMAPROOM_PlayerEnter = 9,		
	BOSSMAPROOM_QuitRoomOk = 8,		
	BOSSMAPROOM_PlayerQuit = 10,			
	BOSSMAPROOM_SelectRoomOk = 15,		
	BOSSMAPROOM_GameReadyOk = 17,		
	BOSSMAPROOM_SendBossMapList = 19,	
    BOSSMAPROOM_SendRoomInfo = 21,
	BOSSMAPROOM_BeInvite = 23,	
	BOSSMAPROOM_MakePair = 24,		
	BOSSMAPROOM_MakePairOk = 25,		
	BOSSMAPROOM_MakePairFail = 26,	
	BOSSMAPROOM_ResetMapOk = 28,
	BOSSMAPROOM_BossMapRecordOk = 30,
	BOSSMAPROOM_OtherRewardOk = 33,

	-------------------------------------副本战斗相关协议--------------------------------------

	-------------------------------------商城相关协议--------------------------------------
	--主协议
	MAIN_MALL = 61,						
														
	--子协议
	--客户端发到服务器 (C->S)
	MALL_GetMallList = 1,		
	MALL_BuyItems = 3,
	MALL_BuyLimitedItem = 6,
	MALL_GetUpdateLimited = 8,
	MALL_GetLimitedTime = 10,
	MALL_GetMallListBySex = 12,
	MALL_GetOperateFriend = 14,
	MALL_MallOperate = 16,
	MALL_RequestUpdateMall = 19,
	MALL_GetBlackMarketInfo = 20,
	MALL_PurchaseBlackMarket = 23,
	MALL_CloseBlackMarket = 25,
	MALL_GetHotMallList = 27,
	MALL_GetSpecialOffer = 29,
	MALL_GetLuckDrawInfo = 31,
	MALL_LuckDraw = 33,
	MALL_GetDiscountStoreStatus = 35,
	MALL_GetDiscountStore = 37,
	MALL_DiscountStoreBribery = 39, 
	MALL_DiscountStorePurchase = 41,
	MALL_DiscountStoreRefresh = 43,
	MALL_GetVipGift = 45,
	MALL_BuyVipGift = 47,
	MALL_GetArenaStore = 49,
	MALL_RefreshArenaStore = 53,
	MALL_BuyArenaStore = 51,

	--服务器发到客户端 (S->C)
	MALL_MallList = 2,		
	MALL_BuyResult = 4,		
	MALL_UpdateMall = 5,
	MALL_BuyLimitedItemOK = 7,
	MALL_GetUpdateLimitedOK = 9,
	MALL_GetLimitedTimeOK = 11,
	MALL_GetMallListBySexOK = 13,
	MALL_GetOperateFriendOK = 15,
	MALL_MallOperateOK = 17,
	MALL_UpdateMallBySex = 18,
	MALL_GetBlackMarketInfoOk = 21,
	MALL_PushBlackMarketActivate = 22,
	MALL_PurchaseBlackMarketOk = 24,
	MALL_CloseBlackMarketOk = 26,
	MALL_GetHotMallListOk = 28,
	MALL_GetSpecialOfferOk = 30,
	MALL_GetLuckDrawInfoOk = 32,
	MALL_LuckDrawResult = 34,
	MALL_GetDiscountStoreStatusOk = 36,
	MALL_GetDiscountStoreOk = 38,
	MALL_DiscountStoreBriberyOk = 40,
	MALL_DiscountStorePurchaseOk = 42,
	MALL_DiscountStoreRefreshOk = 44,
	MALL_GetVipGiftOk = 46,
	MALL_BuyVipGiftOk = 48,
	MALL_GetArenaStoreOk = 50,
	MALL_BuyArenaStoreOk = 52,

	-------------------------------------公告相关协议--------------------------------------																			
	--子协议
	--客户端发到服务器 (C->S)	
	BULLETINT_GetAbout = 3,		
	BULLETINT_GetHelp = 5,		
	BULLETINT_GetWeiboInfo = 7,		

	--服务器发到客户端 (S->C)		
	BULLETINT_GetAboutOk = 4,	
	BULLETINT_GetHelpOk = 6,	
	BULLETINT_GetWeiboInfoOk = 8,
	BULLETINT_WeiboShare = 9,	

	-------------------------------------弹弹岛好友相关协议--------------------------------------
	--主协议
	MAIN_FRIEND = 27,						
	--子协议
	--客户端发到服务器 (C->S)
	FRIEND_AddFriend = 2,
	FRIEND_DeleteFriend = 4,
	FRIEND_SearchFriend = 6,
	FRIEND_Approve = 8,
	FRIEND_Operation = 10,
	FRIEND_OnlinePlayer = 15,
	FRIEND_GetFriend = 18,
	FRIEND_GetFriendInfoList = 23,
	FRIEND_SendGift = 24,
	FRIEND_Accept = 28, 
	FRIEND_ChangeNotify = 29, 
	FRIEND_AddChum = 38,
	FRIEND_RemoveChum = 40,
	FRIEND_ApproveChum = 42,
	FRIEND_CoupleNum = 44,
	FRIENT_BlackListOperate = 46,
	FRIENT_GetBlackList = 48,
	FRIEND_AddShuangXiu = 50,
	FRIENTD_ApproveShuangXiu = 52,

	--服务器发到客户端 (S->C)
	FRIEND_FriendInfoList = 1,
	FRIEND_AddFriendOK = 3,
	FRIEND_DeleteFriendOK = 5,
	FRIEND_SearchFriendOK = 7,
	FRIEND_ApproveOK = 9,
	FRIEND_OperationOK = 11,
	FRIEND_AcceptOK = 13,
	FRIEND_AddFriendInfo = 14,
	FRIEND_DeleteAccept = 12,
	FRIEND_OnlinePlayerOK = 16,
	FRIEND_IsOnline = 17,
	FRIEND_GetFriendOK = 19,
	FRIEND_GetVigorNum = 20,
	FRIEND_UpdateAccept = 21,
	FRIEND_UpdateFriend = 22,
	FRIEND_SendGiftOk = 25,
	FRIEND_ChangeNotifyOk = 30, 
	FRIEND_AddChumOK = 39,
	FRIEND_RemoveChumOK = 41,
	FRIEND_ApproveChumOK = 43,
	FRIEND_CoupleNumOK = 45,
	FRIENT_BlackListOperateOk = 47,
	FRIENT_GetBlackListOk = 49,
	FRIEND_AddShuangXiuOk = 51,
	FRIEND_ApproveShuangXiuOk = 53,
	-------------------------------------活动广场相关协议--------------------------------------
	--主协议
	MAIN_SQUARE = 91,						
																				
	--子协议
	--客户端发到服务器 (C->S)	
	SQUARE_GetInfo = 1,		
	SQUARE_GetMhUrl = 3,		

	--服务器发到客户端 (S->C)
	SQUARE_SendInfo = 2,		
	SQUARE_GetMhUrlOk = 4,		

	-------------------------------------成长基金相关协议--------------------------------------
	--主协议
	MAIN_FUNDGROW = 116,
																							
	--子协议
	--客户端发到服务器 (C->S)
	FUNDGROW_GetFundInfo = 1,	
	FUNDGROW_BuyFundgrow = 3,		
	FUNDGROW_GetFundAward = 5,		

	--服务器发到客户端 (S->C)
	FUNDGROW_GetFundInfoOk = 2,		
	FUNDGROW_BuyFundgrowOk = 4,		
	FUNDGROW_GetFundAwardOk = 6,		

	-------------------------------------结婚系统协议--------------------------------------
	--主协议
	MAIN_WEDDING = 84,					
																									
	--子协议
	--客户端发到服务器 (C->S)
	WEDDING_GetMaritalStatus = 1,		
	WEDDING_SendLoveLetter = 4,		
	WEDDING_GetLoveLetterInfo = 7,		
	WEDDING_ChangeMarryStatus = 8,		
	WEDDING_RemoveEngagement = 10,		
	WEDDING_GiveDiamond = 12,		
	WEDDING_GetWedList = 16,
	WEDDING_JoinWedding = 22,
	WEDDING_EXTWedding = 24,
	WEDDING_GetJoinList = 26,
	WEDDING_Operation = 28,
	WEDDING_GetSomething = 30,
	WEDDING_Blessing = 32,
	WEDDING_SetPassword = 37,
	WEDDING_PleaseOut = 39,
	WEDDING_SendCard =18 ,
	WEDDING_GetMarryInfo = 44,
	WEDDING_GetLoveLog = 47,
	WEDDING_GetMarryLog = 42,
	WEDDING_SendGift=49,
	WEDDING_Invitation = 51,
	WEDDING_GetCDTime = 54,
	WEDDING_GetHouseInfo = 57, 
	WEDDING_GetHouseBuildingStore = 61,
	WEDDING_WEDDING_BearChild = 63,
	WWEDDING_DecideChildSex = 65,
	WEDDING_HireNanny = 67,
	WEDDING_ChildInteract = 69,
	WEDDING_AppeaseChild = 71,
	WEDDING_ChangeChildFashion = 73,
	WEDDING_GetChildBuff = 75,
	WEDDING_AddHouseBuilding = 77,
	WEDDING_MoveHouseBuilding = 79,
	WEDDING_RemoveHouseBuilding = 81,
	WWEDDING_GetHouseRankInfo = 83,
	WEDDING_GetChildStatus = 85,
	WEDDING_GetHouseItemCache = 87,
	WWEDDING_GetRemoveEngageStatus = 93,
	WEDDING_SelectChild = 97,
	WEDDING_DatingServiceSign = 98, 
	WEDDING_DatingServiceRecommend = 100,
	WEDDING_GetDatingServiceInfoList = 102,
	WEDDING_GetDatingServiceInfo = 104,
	WEDDING_CancelDatingServiceSign = 106,
	
	--服务器发到客户端 (S->C)
	WEDDING_GetMaritalStatusOK = 2,		
	WEDDING_GetMarryRecordList = 3,		
	WEDDING_SendLoveLetterOK = 5,		
	WEDDING_SendLoveLetterToCouple = 6,			
	WEDDING_ChangeMarryStatusOK = 14,		
	WEDDING_SendMarryStatusToCouple = 9,		
	WEDDING_RemoveEngagementOK = 15,		
	WEDDING_RemoveEngagementToCouple = 11,	
	WEDDING_GiveDiamondOK = 13,	
	WEDDING_GetWedListOK = 17,
	WEDDING_SendCanWedTime = 21,
	WEDDING_JoinWeddingOK = 23,
	WEDDING_ExtWeddingOk = 25,
	WEDDING_SendJoinList = 27,
	WEDDING_OperationOK = 29,
	WEDDING_BlessingOk = 33,
	WEDDING_WeddingOver = 34,
	WEDDING_GetSomethingOK = 31,
	WEDDING_PlayerHaveBless = 35,
	WEDDING_RefreshWedding = 36,
	WEDDING_SetPasswordOk = 38,
	WEDDING_OperationToPlayer = 40,
	WEDDING_SendCardOK = 19,
	WEDDING_SendCardToFriend =20,
	WEDDING_GetMarryInfoOK = 45,
	WEDDING_GetLoveLogOK = 48,
	WEDDING_SendGiftOK = 50,
	WEDDING_UpLoveLevel= 46,
	WEDDING_GetMarryLogOK = 43,
	WEDDING_InvitationOK = 52,
	WEDDING_InvitationToFriend = 53,
	WEDDING_GetCDTimeOK = 55,
	WEDDING_ResultCode = 41,
	WEDDING_NoticeOnlinePlayer = 56,
	WEDDING_GetHouseInfoOK = 58,
	WEDDING_GetHouseBuildingStoreOk = 62,
	WEDDING_WEDDING_BearChildOk = 64,
	WWEDDING_DecideChildSexOk = 66,
	WEDDING_HireNannyOk = 68,
	WEDDING_ChildInteractOk = 70,
	WEDDING_AppeaseChildOk = 72,
	WEDDING_GetChildBuffOk = 76,
	WEDDING_AddHouseBuildingOk = 78,
	WEDDING_MoveHouseBuildingOk = 80,
	WEDDING_RemoveHouseBuildingOk = 82,
	WWEDDING_GetHouseRankInfoOk = 84,
	WEDDING_GetChildStatusOk = 86,
	WEDDING_GetHouseItemCacheOk = 88,
	WEDDING_AddHouseItemCache = 89,
	WEDDING_UpdateHouseItemCache = 90,
	WEDDING_RemoveHouseItemCache = 91,
	WEDDING_GetHouseSummaryOk = 92,
	WWEDDING_GetRemoveEngageStatusOk = 94,
	WEDDING_GetDivorceResultOk = 95,
	WEDDING_GetAllotChildInfoOk = 96,
	WEDDING_DatingServiceSignOk = 99,
	WEDDING_DatingServiceRecommendOk = 101,
	WEDDING_GetDatingServiceInfoListOk = 103,
	WEDDING_GetDatingServiceInfoOk = 105,
	WEDDING_CancelDatingServiceSignOk = 107,
	-------------------------------------礼包道具相关协议--------------------------------------
	--主协议
	MAIN_SPREE = 90,					
																											
	--子协议
	--客户端发到服务器 (C->S)
	SPREE_GetGift = 1,	
	SPREE_OpenBox = 3,	

	--服务器发到客户端 (S->C)
	SPREE_GetGiftOk = 2,
	SPREE_OpenBoxOk = 4,	

	-------------------------------------弹弹岛礼包码兑换--------------------------------------
	--主协议
	MAIN_EXCHANGECODE = 82,						
																														
	--子协议
	--客户端发到服务器 (C->S)
	EXCHANGECODE_SendExchangeCode = 1,	
			
	--服务器发到客户端 (S->C)
	EXCHANGECODE_SendExchangeCodeOk = 2,	

	-------------------------------------聊天相关协议--------------------------------------
	--主协议
	MAIN_CHAT = 16,						
																																		
	--子协议
	--客户端发到服务器 (C->S)
	CHAT_SendMessage = 1,		
	CHAT_ChangeChannel = 3,		
	CHAT_GetIMToken = 5,
	CHAT_GetRoomList = 7,
	CHAT_WorldIM = 11,
	CHAT_Activate = 14,
	CHAT_BuyChatBubble = 16,

	--服务器发到客户端 (S->C)
	CHAT_ReceiveMessage = 2,		
	CHAT_GetIMTokenOK = 6,	
	CHAT_GetRoomListOK = 8,
	CHAT_AddRoom = 9,
	CHAT_DelRoom = 10,
	CHAT_WorldIMOK = 12,
	CHAT_PushVoiceChatButtonInfo = 13,
	CHAT_ActivateOK = 15,
	CHAT_BuyChatBubbleOk = 17,
	-------------------------------------排行榜相关协议--------------------------------------

    -------------------------------------排行榜相关协议（新）----------------------------------
    ----主协议
    MAIN_RANK = 111,
    ----子协议
    --客户端发到服务器端（C->S）
    RANK_GetRankRecord = 1,
    RANK_GetPlayerRank = 3,
    RANK_GetFireworkRank = 9,

    --服务器端发到客户端（S->C）
    RANK_GetRankRecordOK = 2,
    RANK_GetPlayerRankOK = 4,
    RANK_Worship = 5,
    RANK_WorshipOK = 6,
    RANK_GetWorshipLog = 7,
    RANK_GetWorshipLogOK = 8,
    RANK_GetFireworkRankOK = 10,

	-------------------------------------升阶相关协议----------------------------------
    ----主协议
    MAIN_ADVANCED = 126,
    ----子协议
    --客户端发到服务器端（C->S）
    ADVANCED_MakePurpleEqui= 1,
    ADVANCED_MakeOrangeEqui= 3,
    ADVANCED_AdjustGrade= 5,
    ADVANCED_KeepOldGrade= 7,
    ADVANCED_EvoOrangePet= 8,
    ADVANCED_UpgradeMountQuality = 10,
    --服务器端发到客户端（S->C）
    ADVANCED_MakePurpleEquiOk = 2,
    ADVANCED_MakeOrangeEquiOK = 4,
    ADVANCED_AdjustGradeOK = 6,
    ADVANCED_EvoOrangePetOk = 9,
    ADVANCED_UpgradeMountQualityOk = 11,

	-------------------------------------强化相关协议--------------------------------------
	--主协议
	MAIN_FORGING = 109,
																																								
	--子协议
	--客户端发到服务器 (C->S)
	FORGING_Merge= 1,
	FORGING_UpStar= 3,
	FORGING_Mosaic= 5,
	FORGING_Dismantle= 7,
	FORGING_MoveAttribute= 9,
	FORGING_MergeNew= 11,
	FORGING_UpStarNew= 13,
	FORGING_WeaponWashing= 15,

	--服务器发到客户端 (S->C)
	FORGING_MergeOK = 2,
	FORGING_UpStarOK = 4,
	FORGING_MosaicOK = 6,
	FORGING_DismantleOK = 8,
	FORGING_MoveAttributeOK = 10,
	FORGING_MergeNewOK = 12,
	FORGING_UpStarNewOK = 14,
	FORGING_WeaponWashingOK = 16,

	-------------------------------------任务相关协议--------------------------------------
	--主协议
	MAIN_TASK = 20,						

	--子协议
	--客户端发到服务器 (C->S)	
	TASK_GetTaskList = 1,
	TASK_GetTaskReward = 4,		
	--TASK_GetTaskStatus = 7,		
	--TASK_TiroTask = 9,	
	--TASK_TiroFlish = 11,
	TASK_GetADReward = 13,				
	TASK_GetEverydayRewardList = 14,		
	TASK_ReceiveReward = 16,
	TASK_WeChatShare = 24,		
	TASK_GetSignInList = 18,
    TASK_SendWeibo = 20,    
	TASK_AttendanceGetReward = 21,		
	TASK_TiroStep = 11,
	TASK_AddFaceBookNum = 12,
	TASK_SupplSign = 27,
	TASK_DiamondCompletion = 29,
	TASK_GetActiveTaskList = 30,
	TASK_GetActiveReward = 32,
	TASK_QuickUpExp = 34,	
	TASK_GetStrongerList = 38,
	TASK_GetLevelRewardList = 40,
	TASK_GetOnileRewardList = 42,
	TASK_ReceiveDailyReward = 26,

	--服务器发到客户端 (S->C)
	TASK_GetTaskListOk = 2,		
	TASK_UpdateTask = 3,	
	TASK_GetTaskRewardOk = 5,	
	TASK_GetSignStatus = 6,	
	TASK_GetSignStatusOk = 7,
	TASK_Sign = 8,
	TASK_SignOk = 9,
	TASK_GetCommitTaskNum = 8,		
	TASK_TiroTaskOk = 10,	
	TASK_GetADRewardOk = 14,
	TASK_SendADRewardInfo = 15,		
	TASK_ReceiveRewardOk = 17,		
	TASK_SendSignInList = 19,		
	TASK_AttendanceGetRewardOk = 22,				
	TASK_WeChatShareOk = 25,		
	TASK_SupplSignOk = 28,
	TASK_SendActiveTaskList = 31,
	TASK_GetActiveRewardOk = 33,
	TASK_QuickUpExpOk = 35,
	TASK_GetStrongerListOk = 39,
	TASK_GetLevelRewardListOk = 41,
	TASK_GetOnileRewardListOk = 43,
	TASK_GetRewardNum = 44,
	TASK_ReceiveDailyRewardOk = 27,
	-------------------------------------首冲奖励、抽奖相关协议--------------------------------------
	--主协议
	MAIN_REWARD = 87,												
																																																	
	--子协议
	--客户端发到服务器 (C->S)
	REWARD_GetRewardList = 1,		
	REWARD_GetReward = 3,	

	--服务器发到客户端 (S->C)
	REWARD_GetRewardListOk = 2,		
	REWARD_GetRewardOk = 4,		

	-------------------------------------玩家物品相关协议--------------------------------------
	--主协议
	MAIN_PLAYER = 21,						
																																																											
	--子协议
	--客户端发到服务器 (C->S)
	--PLAYER_GetPlayerStoreEquipment = 1,
	PLAYER_GetPlayerInfo = 1,	
	PLAYER_SaveFacebook = 3,		


	PLAYER_GetPlayerBodyEquipment = 5,	
	PLAYER_GetSkillList = 73,
	PLAYER_UpgradeSkill = 75,
	PLAYER_GetPlayerSkill = 76,
	--PLAYER_GetPlayerProp = 13,
	PLAYER_ChangeSkill = 78,	
	PLAYER_BuySkillBox = 79,
	PLAYER_ChangeProp = 17,		
	PLAYER_GetOnlinePlayer = 20,		
	PLAYER_GetOnlinePlayerNew = 42,	
	PLAYER_Rename = 35,		
	PLAYER_GetBuffList = 37,		
	PLAYER_GetStrengthenInfo = 39,		
	PLAYER_GetPlayerStoreEquipmentNew = 41,		
	PLAYER_GetAttribute = 43,	
	PLAYER_SetPlayerWeiboId = 45,		
	PLAYER_NoviceSteps = 46,
    PLAYER_LookPlayerInfo = 49,
    PLAYER_ChangeEquipment = 51,
    PLAYER_GetOnlineReward = 54,
	PLAYER_PictureUploadFirst = 58,
	PLAYER_UpdateContext = 60,
	PLAYER_GetPlayerInfoNovice = 65,
    PLAYER_GetUpdateRedDot = 70,
    PLAYER_CancelRedDot = 63,
    BATTLE_Record = 80,
	PLAYER_ChangeColour = 82,
    PLAYER_FinishComment = 88,
    PLAYER_CheckOnline = 90,
    PLAYER_AppStoreCommentStatus = 93,
	PLAYER_GetWeaponSkillList = 94,
	PLAYER_UpgradeWeaponSkill = 96,
	PLAYER_changeWeaponSkill = 97,
	PLAYER_ResetWeaponSkill = 98,
	PLAYER_GetShapeSkillList = 100,
	PLAYER_ChangeShapeSkill = 102,
	PLAYER_GetTrioRankMatchShop = 104,
	PLAYER_RefreshTrioRankMatchShop = 106,
	PLAYER_BuyTrioRankMatch = 107,
	PLAYER_SetBackgroundShow = 109,
	PLAYER_BuyBackgroundShow = 111,

	--服务器发到客户端 (S->C)
	--PLAYER_GetPlayerStoreEquipmentOk = 2,
	PLAYER_GetPlayerInfoOk = 2,	
	PLAYER_SaveFacebookOK = 4,		
	PLAYER_GetPlayerBodyEquipmentOk = 6,
	PLAYER_GetSkillListOk = 74,
	PLAYER_GetPlayerSkillOk = 77,
	--PLAYER_GetPlayerPropOk = 14,
	PLAYER_ChangeSkillOk = 16,
	PLAYER_ChangePropOk = 18,	
	PLAYER_SendOnlinePlayer = 21,
	PLAYER_RenameOk = 36,
	PLAYER_GetBuffListOk = 38,		
	PLAYER_GetStrengthenInfoOk = 40,		
	PLAYER_GetAttributeOk = 44,		
	PLAYER_UpdatePlayerAttribute = 47,	
	PLAYER_UpdatePlayerLevel = 48,
    PLAYER_LookPlayerInfoOk = 50,
    PLAYER_PlayerButtonInfo = 52,
    PLAYER_OnlineRewardInfo = 53,
    PLAYER_GetOnlineRewardOk = 55,
	PLAYER_PictureUploadOk = 59,
	PLAYER_UpdateContextOK = 61,
	PLAYER_PictureUploadDeleteOk = 62,
	PLAYER_RechargeCritResultOk = 64,
    PLAYER_GetPlayerInfoNoviceOk = 66,
    PLAYER_PlayerSceneInfo = 67,
    PLAYER_UpdateRedDot = 62,
    PLAYER_CancelRedDotOK = 64,
    BATTLE_RecordOk = 81,	
	PLAYER_ChangeColourOK = 83,
	PLAYER_ServerError = 85,
	PLAYER_PushCommentGuide = 87,
	PLAYER_FinishCommentOk = 89,
	PLAYER_CheckOnlineOk = 91,
	PLAYER_CheckFirstWeChat = 92,
	PLAYER_GetWeaponSkillListOk = 95,
	PLAYER_ResetWeaponSkillOk = 99,
	PLAYER_GetShapeSkillListOk = 101,
	PLAYER_UpAwakeSkillOk = 103,
	PLAYER_GetTrioRankMatchShopOk = 105,
	PLAYER_BuyTrioRankMatchOk = 108,
	PLAYER_SetBackgroundShowOk = 110,
	PLAYER_BuyBackgroundShowOk = 112,
	
	--子协议
	--客户端发到服务器 (C->S)
	PLAYER_GetTopRecord = 30,	
	PLAYER_GetSimpleInfo = 68,		

	--服务器发到客户端 (S->C)
	PLAYER_GetTopRecordOk = 31,
	PLAYER_GetSimpleInfoOK = 69,
	
	-------------------------------------附近好友相关协议--------------------------------------
	--主协议
	MAIN_NEARBY = 28,
	
	--子协议
	--客户端发到服务器 (C->S)
	NEARBY_GetNearbyFriendList = 1,
	NEARBY_GetNearbyPlayerList = 3,
	NEARBY_AddNearbyFriend = 5,
	NEARBY_RemoveNearbyFriend = 7,
	NEARBY_GetNearbyReceivedMailList = 9,
	NEARBY_GetNearbySendMailList = 11,
	NEARBY_GetNearbyMailContent = 13,
	NEARBY_DeleteNearbyMail = 15,
	NEARBY_UpdatePlayerLocationInfo = 17,
	NEARBY_SendNearbyMail = 22,
	
	--服务器发到客户端 (S->C)
	NEARBY_GetNearbyFriendListOk = 2,
	NEARBY_GetNearbyPlayerListOk = 4,
	NEARBY_AddNearbyFriendOk = 6,
	NEARBY_RemoveNearbyFriendOk = 8,
	NEARBY_GetNearbyReceivedMailListOk = 10,
	NEARBY_GetNearbySendMailListOk = 12,
	NEARBY_GetNearbyMailContentOk = 14,
	NEARBY_DeleteNearbyMailOk = 16,
	NEARBY_UpdatePlayerInfo = 18,
	NEARBY_UpdatePlayerInfoOk = 19,
	NEARBY_PlayerOnline = 20,
	NEARBY_PlayerOffline = 21,
	NEARBY_SendNearbyMailOk = 23,
	
	-------------------------------------系统相关协议--------------------------------------
	--主协议
	MAIN_SYSTEM = 80,							
																																																											
	--子协议
	--客户端发到服务器 (C->S)
	SYSTEM_GetIslandState = 7,	
	SYSTEM_GetNoviceRemark = 11,		
	SYSTEM_GetItemPriceAndVip = 13,
	SYSTEM_BattleShakeHands = 16,
    SYSTEM_GetAboutGame = 24,

	--服务器发到客户端 (S->C)
	SYSTEM_GetIslandStateOk = 8,		
	SYSTEM_GetNoviceRemarkOk = 12,		
	SYSTEM_GetItemPriceAndVipOk = 14,		
	SYSTEM_EarthPush = 15,		
    SYSTEM_NextDay = 23,
    SYSTEM_GetAboutGameOk = 25,
    SYSTEM_SynButtonInfo = 26,
    SYSTEM_GetRankMatchOk = 27,
	SYSTEM_GetServerInfo = 28,
	SYSTEM_SynAdMessage = 29,
	-------------------------------------心跳相关协议--------------------------------------
																																																											
	--子协议
	--客户端发到服务器 (C->S)
	--双向心跳
	--SYSTEM_ShakeHands = 4,
	--单向心跳	
	SYSTEM_TopHands = 5,		

	--服务器发到客户端 (S->C)
	--双向心跳
	SYSTEM_ShakeHands = 4,		

	-------------------------------------邀请码相关协议--------------------------------------
	--主协议
	MAIN_INVITE = 89,																	
																																																											
	--子协议
	--客户端发到服务器 (C->S)
	INVITE_GetInviteInfo = 1,		
	INVITE_GetInviteList = 3,	
	INVITE_GetInviteReward = 5,		
	INVITE_BindInvite = 7,	
	INVITE_InviteWriteCode = 11,
	INVITE_GetInviteRewards = 13,
	INVITE_requestList = 15,
	INVITE_RequestInviteInfoList = 9,

	--服务器发到客户端 (S->C)
	INVITE_GetInviteInfoOk = 2,		
	INVITE_GetInviteListOk = 4,		
	INVITE_GetInviteRewardOk = 6,		
	INVITE_BindInviteResult = 8,	
	INVITE_InviteInfoListOk = 10, 
	INVITE_InviteAwardOk = 12,
	INVITE_GetInviteRewardsOk = 14,
	INVITE_UpdatePlayerInviteInfoOk = 16,
	INVITE_InviteFinishTaskOk = 17,

	-------------------------------------战斗相关协议--------------------------------------
	--主协议
	MAIN_BATTLE = 70,					
																																																																									
	--子协议
	--客户端发到服务器 (C->S)
	BATTLE_StartLoading = 3,		
	BATTLE_PositionsInMap = 4,		
	BATTLE_FinishLoading = 8,		
	BATTLE_StartNewTimer = 10,
	BATTLE_EndCurRound = 11,		
	BATTLE_PlayerMove = 13,
	BATTLE_SkillEquip = 15,		
	BATTLE_PetAttack = 18,		
	BATTLE_Shoot = 20,		
	BATTLE_Hurt = 22,		
	BATTLE_Fly = 23,		
	BATTLE_Pass = 26,
	BATTLE_ChooseCard = 34,		
	BATTLE_OutOfScene = 36,		
	BATTLE_RebornPosition = 37,	
	BATTLE_QuitBattle = 39,
	BATTLE_LoadingPercent = 41,
	BATTLE_UsingFace = 43,	
	BATTLE_AddBuff = 45,
	BATTLE_GetTips = 47,
	BATTLE_BuildGuai = 49,
	BATTLE_OtherBuildGuai = 50,		
	BATTLE_ClearFailNum = 51,		
	BATTLE_SendPlayerBattleAttribute = 55,	
    -- BATTLE_GetEventInfo = 56,
    -- BATTLE_EventContact = 58,
    BATTLE_SendCurRoundInfo = 60,
    BATTLE_SynchronousBattleInfo = 62,
    BATTLE_BuffChange = 65,
    BATTLE_Hit = 46,
    BATTLE_ThumbUp = 105,
    BATTLE_GetGhostSkill = 108,
    BATTLE_RemoveGhostSkill = 110,
    BATTLE_GhostMove = 112,
    
	--服务器发到客户端 (S->C)
	BATTLE_AIControlCommon = 1,	
	BATTLE_PostionsForPlayers = 5,		
	BATTLE_GotoBattle = 9,
	BATTLE_CanStartCurRound = 12,		
	BATTLE_OtherPlayerMove = 14,		
	BATTLE_OtherSkillEquip = 16,		
	BATTLE_ChangeAngryValue = 17,		
	BATTLE_OtherBigSkill= 19,		
	BATTLE_OtherShoot = 21,
	BATTLE_OtherFly = 24,		
	BATTLE_SomeOneDead = 30,		
	BATTLE_OtherPass = 28,		
	BATTLE_GameOver = 27,
	BATTLE_PlayerLose = 32,
	BATTLE_PlayerReborn = 33,		
	BATTLE_OhterChooseCard = 35,		
	BATTLE_UpdateMedal = 38,		
	BATTLE_QuitBattleOk = 40,		
	BATTLE_OtherLoadingPercent = 42,		
	BATTLE_OtherUsingFace= 44,		
	BATTLE_OtherUseFly = 46,		
	BATTLE_GetTipsOk = 48,		
	BATTLE_ClearFailNumOk = 52,		
    -- BATTLE_GetEventInfoOk = 57,
    -- BATTLE_OtherEventContact = 59,
    BATTLE_SendCurRoundInfoOk = 61,
    BATTLE_SynchronousBattleInfoOk = 63,
    BATTLE_ComeBackBattleInfoOk = 64,
    BATTLE_HitOK = 47,
    BATTLE_ThumbUpOk = 106,
    BATTLE_SyncGhostSkillList = 107,
    BATTLE_GetGhostSkillOk = 109,
    BATTLE_RemoveGhostSkillOk = 111,
    BATTLE_OtherGhostMove = 113,
    --==================副本=================================
    BOSSMAPBATTLE_BossChange = 6,		
    BOSSMAPBATTLE_OtherChange = 7,

    BOSSMAPBATTLE_NearAttack = 53,	
    BOSSMAPBATTLE_OtherNearAttack= 54,

    BOSSMAPBATTLE_SynPosition = 56,
	BOSSMAPBATTLE_OtherSynPosition = 57,

	BOSSMAPBATTLE_GameOver = 29,
    --==================副本=================================
   
	-------------------------------------转生相关协议--------------------------------------
	--主协议
	MAIN_REBIRTH = 92,										
																																																																									
	--子协议
	--客户端发到服务器 (C->S)
	REBIRTH_GetRebirthInfo = 1,		
	REBIRTH_Rebirth = 3,		

	--服务器发到客户端 (S->C)
	REBIRTH_GetRebirthInfoOk = 2,		
	REBIRTH_RebirthResult = 4,	

	-------------------------------------装备升星相关协议--------------------------------------
	--主协议
	MAIN_STAR = 93,						
																																																																																		
	--子协议
	--客户端发到服务器 (C->S)
	STAR_Upgrade = 1,		

	--服务器发到客户端 (S->C)
	STAR_UpgradeOk = 2,		

	-------------------------------------付费相关协议--------------------------------------
	--主协议
	MAIN_PURCHASE = 74,						
																																																																																								
	--子协议
	--客户端发到服务器 (C->S)
	PURCHASE_GetProductIdList = 1,		
	PURCHASE_IOSSendProductCheckInfo = 3,			
	PURCHASE_RequestSmsCodeSerialid = 6,	
	PURCHASE_GetNianGiftIdList = 10,
	PURCHASE_GetSummerGiftIdList = 12,
	PURCHASE_IOSSubscription = 14,
	PURCHASE_GoogleSendProductCheckInfo = 15,
	PURCHASE_IOSSubscrip = 16,

	--服务器发到客户端 (S->C)
	PURCHASE_GetProductIdListOK = 2,		
	PURCHASE_BuySuccess = 4,			
	PURCHASE_RequestSmsCodeSerialidOk = 7,		

	PURCHASE_GetGiftIdList = 8,
	PURCHASE_GetGiftIdListOK = 9,	
	PURCHASE_GetNianGiftIdListOK = 11,
	PURCHASE_GetSummerGiftIdListOk = 13,
	PURCHASE_IOSSubscripOk = 17,
	-------------------------------------公会相关协议--------------------------------------
	--主协议
	MAIN_GUILD = 32,						

	--子协议
	--客户端发到服务器 (C->S)
	GUILD_CreateGuild = 1,
	GUILD_GetGuildList = 3,
	GUILD_GetGuild = 5,
	GUILD_ApplyGuild = 7,
	GUILD_GetApplyerList = 9,
	GUILD_Approval = 11,
	GUILD_Resignations = 12,
	GUILD_Abdicate = 14,
	GUILD_GetGuildHall = 16,
	GUILD_ChangePost = 18,
	GUILD_ExpelMember = 20,
	GUILD_EditGuildDesc = 22,
	GUILD_GuildUpLevel = 24,
	GUILD_SendGuildMail = 26,
	GUILD_GuildSetting = 28,
	GUILD_GetOperationLog = 30,
	GUILD_GuildDonate = 32,
	GUILD_GetDonateLog = 34,
	GUILD_BuildUpLevel = 36,
	GUILD_TotemPay = 38,
	GUILD_GetGuildSkill = 40,
	GUILD_LearnGuildSkill = 42,
	GUILD_GetGuildStore = 44,
	GUILD_BuyGuildStore = 46,
	GUILD_RefreshGuildStore = 48,
	GUILD_GetGuildWar = 49,
	GUILD_CreateWarRoom = 51,
	GUILD_QuickGame = 52,
	GUILD_GetGuildWarRank = 53,
	GUILD_GetGuildWeekRank = 55,
	GUILD_RequestGuildTask = 57,
	GUILD_RequestFundReward = 59,
	GUILD_RequestFlushTask = 61,
	GUILD_LeaveMsg = 63,
	GUILD_PublishTask = 65,
	GUILD_ChangeMemberPost = 68,
	GUILD_GetImpeachInfo = 73,
	GUILD_ImpeachVote = 71,
	GUILD_Recommend = 74,
	GUILD_EditDeclaration = 76,
	GUILD_GetGuildBossInfo = 78,
	GUILD_GuildInspire = 80,
	GUILD_GetGuildBossRank = 81,
	GUILD_MakePair = 83,
	GUILD_GetGuildStoreLog = 86,
	GUILD_GetHurtReward = 88,
	GUILD_Invite = 92,
	GUILD_ResponseInvite = 95,
	GUILD_GetGuildBossHurtRank = 97,

	--服务器发到客户端 (S->C)
	GUILD_CreateGuildOk = 2,
	GUILD_GetGuildListOk = 4,
	GUILD_GetGuildOk = 6,
	GUILD_ApplyGuildOk = 8,
	GUILD_GetApplyerListOk = 10,
	GUILD_ResignationsOk = 13,
	GUILD_AbdicateOk = 15,
	GUILD_GetGuildHallOk = 17,
	GUILD_ChangePostOk = 19,
	GUILD_ExpelMemberOk = 21,
	GUILD_EditGuildDescOk = 23,
	GUILD_GuildUpLeveOk = 25,
	GUILD_SendGuildMailOk = 27,
	GUILD_GuildSettingOk = 29,
	GUILD_GetOperationLogOk = 31,
	GUILD_GuildDonateOk = 33,
	GUILD_GetDonateLogOk = 35,
	GUILD_BuildUpLevelOk = 37,
	GUILD_TotemPayOk = 39,
	GUILD_GetGuildSkillOk = 41,
	GUILD_LearnGuildSkillOk = 43,
	GUILD_GetGuildStoreOk = 45,
	GUILD_BuyGuildStoreOk = 47,
	GUILD_GetGuildWarOk = 50,
	GUILD_GetGuildWarRankOk = 54,
	GUILD_GetGuildWeekRankOk = 56,
	GUILD_RequestGuildTaskOk = 58,
	GUILD_RequestFundRewardOk = 60,
	GUILD_RequestFlushTaskOk = 62,
	GUILD_LeaveMsgOk = 64,
	GUILD_PublishTaskOk = 66,
	GUILD_ChangeMemberPostOk = 69,
	GUILD_ImpeachInfo = 70,
	GUILD_ImpeachVoteOk = 72,
	GUILD_RecommendOk = 75,
	GUILD_EditDeclarationOk = 77,
	GUILD_GetGuildBossInfoOk = 79,
	GUILD_GetGuildBossRankOk = 82,
	GUILD_MakePairOk = 84,
	GUILD_SendSettlementInfo = 85,
	GUILD_GetGuildStoreLogOk = 87,
    GUILD_GetHurtRewardOk = 89,
    GUILD_InviteOk = 93,
    GUILD_BeInvite = 94,
    GUILD_ResponseInviteOk = 96,
	GUILD_GetGuildBossHurtRankOk = 98,

	-----------------------------------排位赛---------------------
	--主协议
	MAIN_TRIO = 63,
	-- send
	TRIO_GetMatchInfo = 1,
	TRIO_GetMathcRank = 5,
	TRIO_GetStatueInfo = 23,
	TRIO_Worship = 15,
	TRIO_GetWorshipLog = 17,
	TRIO_GetWorshipGold = 19,
	TRIO_GetPlayerInfo = 27,
	TRIO_GetTourPlayerInfo = 40,
	TRIO_TourWorship = 42,
	TRIO_GetTourWorshipLog = 44,

	-- receive
	TRIO_GetMatchInfoOk = 2,
	TRIO_GetMathcRankOk = 6,
	TRIO_GetStatueInfoOK = 22,
	TRIO_WorshipOK = 16,
	TRIO_GetWorshipLogOK = 18,
	TRIO_GetWorshipGoldOK = 20,
	TRIO_GetPlayerInfoOK = 28,
	TRIO_GetTourPlayerInfoOk = 41,
	TRIO_TourWorshipOk = 43,
	TRIO_GetTourWorshipLogOk = 45,
	-------------------------------------世界BOSS大厅相关协议--------------------------------------
	--主协议
	MAIN_WORLDBOSS = 97,																							
																																																																																												
	--子协议
	--客户端发到服务器 (C->S)
	WORLDBOSS_GetOpenState = 1,		
	WORLDBOSS_GetRoomState = 3,		
	WORLDBOSS_MakePair = 5,		
	WORLDBOSS_Accelerate = 10,
	WORLDBOSS_Inspire = 12,
	--服务器发到客户端 (S->C)
	WORLDBOSS_SendOpenState = 2,		
	WORLDBOSS_GetRoomStateOk = 4,		
	WORLDBOSS_MakePairOK = 6,		
	WORLDBOSS_MakePairFail = 7,
	WORLDBOSSHALL_GetHallState = 8,
	WORLDBOSSHALL_GetHallStateOk = 9,
	--WORLDBOSSHALL_Accelerate = 10,
	WORLDBOSS_SendSettlementInfo = 11,	
	--WORLDBOSSHALL_GetRewardList = 12,
	WORLDBOSSHALL_GetRewardListOk = 13,
	-------------------------------------物品回收相关协议--------------------------------------
	--主协议
	MAIN_PLAYERITEM = 94,																													

	--子协议
	--客户端发到服务器 (C->S)	
	PLAYERITEM_RecycleItem 		= 1,
	PLAYERITEM_ChangeEquipment	= 3,
	PLAYERITEM_UseItem 			= 4,
	PLAYERITEM_OpenGift 		= 6,
	PLAYERITEM_GetOverflowedExpExchange = 8,
	PLAYERITEM_ExchangeExp = 10,
	PLAYERITEM_GetDressSuit = 13,
	PLAYERITEM_ModifyDressSuitName = 15,
	PLAYERITEM_IncreaseDressSuitNum = 17,
	PLAYERITEM_SwitchDressSuit = 19,

	--服务器发到客户端 (S->C)
	PLAYERITEM_RecycleItemOk 	= 2,
	PLAYERITEM_UseItemOk 		= 5,
	PLAYERITEM_OpenGiftOK 		= 7,
	PLAYERITEM_GetOverflowedExpExchangeOk = 9,
	PLAYERITEM_ExchangeExpOk = 11,
	PLAYERITEM_ItemTimeOver = 12,
	PLAYERITEM_GetDressSuitOk = 14,
	PLAYERITEM_ModifyDressSuitNameOk = 16,
	PLAYERITEM_IncreaseDressSuitNumOk = 18,
	PLAYERITEM_SwitchDressSuitOk = 20,
	-------------------------------------邮件相关协议--------------------------------------
	--主协议
	MAIN_MAIL = 38,																																			
																																																																																												
	--子协议
	--客户端发到服务器 (C->S)
	MAIL_GetMailContent = 1,
	MAIL_SendMail = 3,		
	MAIL_DeleteMail = 5,	
	MAIL_GetMailList = 7,		
	MAIL_GetMailReward = 10,
    MAIL_GetAllMailReward = 12,
    MAIL_MallMailOperate = 16,
    MAIL_DeleteMallMail = 18,

	MAIL_LoginCheckMail = 12,		
	MAIL_SendSuggestion = 14,		
	MAIL_SendSuggestionOk = 15,		

	--服务器发到客户端 (S->C)
	MAIL_GetMailContentOk = 2,		
	MAIL_SendMailOk = 4,		
	MAIL_DeleteMailOk = 6,		
	MAIL_GetMailListOk = 8,		
	MAIL_PushMail = 9,		
	MAIL_GetMailRewardOk = 11,
	MAIL_DeleteMallMailOk = 19,

	MAIL_LoginCheckMailOk = 13,		
	MAIL_SendInboxMail = 2,		
	MAIL_SendOutboxMail = 10,
    MAIL_GetAllMailRewardOk = 13,
    MAIL_MallMailOperateOk = 17,
	--------newKingBattle
	--主协议
	MAIN_KING = 113,																																	
																																																																																												
	--子协议
	--客户端发到服务器 (C->S)
	KING_GetKingStart = 1,
	KING_GetKingInfo = 3,
	KING_GetFameHall = 5,
	KING_GetRank = 7,
	KING_GetMallInfo = 9,
	KING_GetMallBuy = 11,
	KING_RefreshMall = 13,
	
	--服务器发到客户端 (S->C)
	KING_GetKingStartOK = 2,
	KING_GetKingInfoOK = 4,
	KING_GetFameHallOK = 6,
	KING_GetRankOK = 8,
	KING_GetMallInfoOK = 10,
	KING_GetMallBuyOK = 12,
	
    -------------------------------------单人副本相关协议--------------------------------------
	--主协议
	MAIN_SINGLEMAP = 99,																															
    --子协议
	--客户端发到服务器 (C->S)
	SINGLEMAP_GetPoints = 1,
	SINGLEMAP_StartChallenge = 3,		
    SINGLEMAP_ChallengeSuccess = 5,
	SINGLEMAP_StartRaids = 7,
    SINGLEMAP_GetSectionReward = 9,
	SINGLEMAP_GetDailyMap = 11,
	SINGLEMAP_ResetDailyMap = 13,
    SINGLEMAP_GetTowerInfo = 15,
    SINGLEMAP_GetTowerRank = 17,
    SINGLEMAP_GetRaidsTowerInfo = 19,
    SINGLEMAP_StartRaidsTower = 21,
    SINGLEMAP_CompleteRaidsTower = 22,
    SINGLEMAP_ResetTowerMap = 24,
    SINGLEMAP_GetTowerReward = 25,
    SINGLEMAP_GetFriendTowerInfo = 27,
    SINGLEMAP_MapRecord = 30,
    MAP_RefreshMapRecord = 32,
    MAP_TrainMes = 34,
    MAP_StartRaidsTeam = 36,
    MAP_GetTodayRaidsTeamTimes = 38 ,
	MAP_GetDailyMap = 40,
	MAP_StartRaidsDaily = 41,
	MAP_GetLandlordData = 43,
	MAP_GetMapLandlordData = 45,
	MAP_GetHeroTowerData = 47,
	MAP_ChangeHeroTowerEnemy = 49,
	MAP_ReceiveHeroTowerReward = 51,

    --服务器发到客户端 (S->C)
    SINGLEMAP_GetPointsOk = 2,
    SINGLEMAP_StartChallengeOk = 4,
    SINGLEMAP_ChallengeSuccessOk = 6,
    SINGLEMAP_StartRaidsOk = 8,
    SINGLEMAP_GetSectionRewardOK = 10,
	SINGLEMAP_GetDailyMapOk = 12,
    SINGLEMAP_ResetDailyMapOk = 14,
    SINGLEMAP_GetTowerInfoOk = 16,
    SINGLEMAP_GetTowerRankOk = 18,
    SINGLEMAP_GetRaidsTowerInfoOk = 20,
    SINGLEMAP_CompleteRaidsTowerOk = 23,
    SINGLEMAP_GetTowerRewardOk = 26,
    SINGLEMAP_GetFriendTowerInfoOk = 28,
    SINGLEMAP_MapRecordOk = 31,
    MAP_RefreshMapRecordOk = 33,
    MAP_TrainMesOk = 35,
    MAP_StartRaidsTeamOk = 37,
    MAP_GetTodayRaidsTeamTimesOk = 39,
    MAP_StartRaidsDailyOk = 42,
	MAP_ResetSingleMap = 29,
	MAP_GetLandlordDataOk = 44,
    MAP_GetMapLandlordDataOk = 46,
    MAP_GetHeroTowerDataOk = 48,
    MAP_ChangeHeroTowerEnemyOk = 50,
    MAP_ReceiveHeroTowerRewardOk = 52,
    -------------------------------------修炼系统相关协议--------------------------------------
   	--主协议
    MAIN_PRACTICE = 103,
    --子协议
	--客户端发到服务器 (C->S)
    PRACTICE_GetPractice = 1,
	PRACTICE_LightNextPractice =3,
	PRACTICE_ActivatePractice =5,

    --服务器发到客户端 (S->C)
    PRACTICE_GetPracticeOk =2,
    PRACTICE_LightNextPracticeOk =4,
    PRACTICE_ActivatePracticeOk =6,

    -------------------------------------星魂系统相关协议--------------------------------------
    --主协议
    MAIN_STARSOUL = 19,
    
    --子协议
	--客户端发到服务器 (C->S)
	STARSOUL_GetStarList = 1,
	STARSOUL_ActivityStar = 3,
    
    --服务器发到客户端 (S->C)
    STARSOUL_GetStarListOK = 2,
    STARSOUL_ActivityStarOK = 4,
    -------------------------------------星魂系统相关协议 END --------------------------------
    --主协议
    MAIN_CIRCULAR = 106,
    --客户端发到服务器 (C->S)
    CIRCULAR_GetBulletinList = 1,
    --服务器发到客户端 (S->C)
    CIRCULAR_GetBulletinListOk = 2,

    -------------------------------------公告协议id --------------------------------
    --主协议
    MAIN_ANNOUNCEMENT = 112,
    CIRCULAR_ANNOUNCEMENT_GETDETAIL = 1,
    CIRCULAR_ANNOUNCEMENT_GETDETAILOK = 2,

    -------------------------------------活动 --------------------------------
    --主协议
    MAIN_ACTIVITY = 107,
    ACTIVITY_GetActivityListInfo = 1,
    ACTIVITY_GetActivityInfo = 3,
    ACTIVITY_ReceiveActivityReward = 5,
    ACTIVITY_RankList = 7,
    ACTIVITY_ReceiveCommandRedPacket = 9, 
    ACTIVITY_DrawCommandeRedPacket = 10,
    ACTIVITY_PushScheduledRedPacket = 13,
    ACTIVITY_DrawScheduledRedPacket = 14,
    ACTIVITY_UseFirework = 16,
    ACTIVITY_PushFirework = 18,
    ACTIVITY_GetWishingWell = 22,
    ACTIVITY_MakeWish = 24,
    ACTIVITY_GetSummerActivityStatus = 26,
    ACTIVITY_GetWantedMonsterInfo = 28,
    ACTIVITY_DrawWantedMonsterReward = 30,
	ACTIVITY_GetSpokesmanActivityStatus = 32,
	ACTIVITY_GetFightingKingInfo = 34,
	ACTIVITY_GetDailyDiscountInfo = 36,
	ACTIVITY_GetDiamondLotteryInfo = 38,
	ACTIVITY_DiamondLottery = 40,
	ACTIVITY_WorshipFigthingKing = 42,
	ACTIVITY_GetCardLotteryInfo = 44,
	ACTIVITY_GetCardLotteryInfoOk = 45,
	ACTIVITY_CardLottery = 46,
	ACTIVITY_GetGrowdfunding = 48,
	ACTIVITY_Growdfunding = 50,
	ACTIVITY_GetGrowdfundingLog = 52,
	ACTIVITY_GetLuckActivityInfo = 60,
	ACTIVITY_GetWelfareCardActivityInfo = 62,
	ACTIVITY_GetChristmasGiftActivityInfo = 64,
	ACTIVITY_ChristmasGiftLottery = 66,
	ACTIVITY_SortChristmasGiftBack = 68,
	ACTIVITY_GetChristmasGift = 70,
	ACTIVITY_GetActivityTaskList = 72,
	ACTIVITY_GetActivityTaskReward = 74,
	ACTIVITY_GetActivitiesShopInfo = 77,
	ACTIVITY_OutActivitiesShop = 79,
	ACTIVITY_BuyActivitiesShop = 81,
	ACTIVITY_GetOpenServerTask = 84,
	ACTIVITY_GetOpenServerReward = 86,
	ACTIVITY_BuyOpenServerShop = 88,
	ACTIVITY_ShootBall = 90,
	ACTIVITY_GetFootballQuizInfoList = 93,
	ACTIVITY_BetOnFootballMatch = 97,
	ACTIVITY_GetBetOnMatchInfo = 101,
	ACTIVITY_GetFootballQuizStore = 105,
	ACTIVITY_PurchaseFootballQuizStore = 107,
	ACTIVITY_GiveFlower = 113,
	ACTIVITY_GetFlowerActivityInfo = 117,
	ACTIVITY_GetMarkTaskInfo = 119,
	ACTIVITY_ReceiveMarkTaskReward = 121,

    ACTIVITY_GetActivityListInfoOK = 2,
    ACTIVITY_GetActivityInfoOK = 4,
    ACTIVITY_ReceiveActivityRewardOK = 6,
    ACTIVITY_RankListOk = 8,
    ACTIVITY_DrawCommandeRedPacketOk = 11,
    ACTIVITY_DrawScheduledRedPacketOk = 15,
    ACTIVITY_UseFireworkOk = 17,
    ACTIVITY_GetWishingWellOk = 23,
    ACTIVITY_MakeWishOk = 25,
    ACTIVITY_GetSummerActivityStatusOk = 27,
    ACTIVITY_GetWantedMonsterInfoOk = 29,
    ACTIVITY_DrawWantedMonsterRewardOk = 31,
    ACTIVITY_GetSpokesmanActivityStatusOk = 33,
    ACTIVITY_GetFightingKingInfoOk = 35,
    ACTIVITY_GetDailyDiscountInfoOk = 37,
    ACTIVITY_GetDiamondLotteryInfoOk = 39,
    ACTIVITY_DiamondLotteryOk = 41,
    ACTIVITY_WorshipFigthingKingOk = 43,
    ACTIVITY_CardLotteryOk = 47,
    ACTIVITY_GetGrowdfundingOk = 49,
    ACTIVITY_GrowdfundingOk = 51,
    ACTIVITY_GetGrowdfundingLogOk = 53,
    ACTIVITY_GetLuckActivityInfoOk = 61,
    ACTIVITY_GetWelfareCardActivityInfoOk = 63,
    ACTIVITY_GetChristmasGiftActivityInfoOk = 65,
    ACTIVITY_ChristmasGiftLotteryOk = 67,
    ACTIVITY_SortChristmasGiftBackOk = 69,
    ACTIVITY_GetChristmasGiftOk = 71,
    ACTIVITY_GetActivityTaskListOk = 73,
    ACTIVITY_GetActivityTaskRewardOk = 75,
	ACTIVITY_PushActivitiesShopMess = 76,
	ACTIVITY_GetActivitiesShopInfoOk = 78,
	ACTIVITY_OutActivitiesShopOk = 80,
	ACTIVITY_BuyActivitiesShopOk = 82,
	ACTIVITY_PushActivitiesShop = 83,
	ACTIVITY_GetOpenServerTaskOk = 85,
	ACTIVITY_GetOpenServerRewardOk = 87,
	ACTIVITY_BuyOpenServerShopOk = 89,
	ACTIVITY_ShootBallOk = 91,
	ACTIVITY_GetFootballQuizInfoListOk = 94,
	ACTIVITY_BetOnFootballMatchOk = 98,
	ACTIVITY_GetBetOnMatchInfoOk = 102,
	ACTIVITY_GetFootballQuizStoreOk = 106,
	ACTIVITY_PurchaseFootballQuizStoreOK = 108,
	ACTIVITY_GetWorldCupActivityStatusOk = 111,
	ACTIVITY_GetUserBackActivityStatusOk = 112,
	ACTIVITY_GiveFlowerOk = 114,
	ACTIVITY_GetFlowerActivityInfoOk = 118,
	ACTIVITY_GetMarkTaskInfoOk = 120,
	ACTIVITY_ReceiveMarkTaskRewardOk = 122,
    -------------------------------------缓存中心相关协议--------------------------------------
	--主协议
	MAIN_CACHE = 102,																						
    --服务器发到客户端 (S->C)
    CACHE_PlayerInfo = 1,
    CACHE_PlayerItemCache = 2,
    CACHE_UpdatePlayer = 5,
    CACHE_AddItemCache = 6,
    CACHE_RemoveItemCache = 7,
    CACHE_UpdateItemCache = 8,
    CACHE_WishList = 11,
    CACHE_ZflhList = 12,
	CACHE_GameParam = 16,
	CACHE_UpdateDataOk = 17,
	CACHE_GuildWarTaskOk = 18, 
	CACHE_BatchUpdateItemCache = 19,
	 -------------------------------------鸡腿协议--------------------------------------
    --主协议号
    MAIN_USEITEMS = 105,
    --子协议
	--客户端发到服务器 (C->S)
    USEITEMS_UseObject = 1,
	
    --服务器发到客户端 (S->C)
    USEITEMS_UseObjectOK = 2,
	
    -------------------------------------月卡系统相关协议--------------------------------------
    --主协议号
    MAIN_MONTHCARD = 104,
    --子协议
	--客户端发到服务器 (C->S)
    MONTHCARD_GetOnlineMember = 1,
    MONTHCARD_GiveMonthCard = 3,

    --服务器发到客户端 (S->C)
    MONTHCARD_GetOnlineMemberOK = 2,
    MONTHCARD_GiveMonthCardOK = 4,
    
    -------------------------------------合成相关协议--------------------------------------
	--主协议
	MAIN_MERGE = 110,
																																								
	--子协议
	--客户端发到服务器 (C->S)
	MERGE_MergeItem = 1,
	MERGE_MergeItemFast=3,

	--服务器发到客户端 (S->C)
    MERGE_MergeItemOK = 2,
    MERGE_MergeItemFastOk=4,

    ------------------------------------活跃度相关协议--------------------------------------
    --主协议
    MAIN_ACTIVE = 115,

    --子协议
    --客户端发到服务器 (C->S)
    ACTIVE_GetActiveInfo = 1,
    ACTIVE_GetActiveAward = 3,
    GetActiveBaseInfo = 5,

    --服务端发到客户端
    GetActiveInfoOk = 2,
    ACTIVE_GetActiveAwardOk = 4,
    GetActiveBaseInfoOk = 6,
    
    ------------------------------------活跃度相关协议--------------------------------------
    --主协议
    MAIN_SPACE = 15,

    --子协议
    --客户端发到服务器 (C->S)
    SPACE_GetSpaceInfo = 1,
    SPACE_UpdatePlayerInfo = 3,
    SPACE_UpdateHeadScul = 4,
    SPACE_UpdateGPSInfo = 5,
    SPACE_BuyGift = 6,
    SPACE_GetVisitorsList = 7,
    SPACE_GetMessageList = 9,
    SPACE_SendMessage = 11,
    SPACE_DelMessage = 12,
    SPACE_GetPhotoList = 13,
    SPACE_SetPhotoUrl = 15,
    SPACE_DelPhoto = 16,
    SPACE_GetJoinList = 17,
    SPACE_JoinPlayer = 19,
    SPACE_GetFlowersList = 21,
    SPACE_GiveFlowers = 23,
    SPACE_SetGPSInfo = 25,
    SPACE_GetRecommendList = 26,
    SPACE_SearchPlayer = 28,
    SPACE_GetFashionRecommendList = 61,
    SPACE_GiveLike = 63,
    SPACE_SearchFashionPlayer = 65,
    SPACE_GetCharmFashionInfo = 67,
    SPACE_Operation = 69,
    SPACE_GetFashionPreviousList = 71,

    --服务端发到客户端
    SPACE_GetSpaceInfoOk = 2,
    SPACE_GetVisitorsListOk = 8,
    SPACE_GetMessageListOk = 10,
    SPACE_GetPhotoListOk = 14,
    SPACE_GetJoinListOk = 18,
    SPACE_JoinPlayerResult = 20,
    SPACE_GetFlowersListOk = 22,
    SPACE_GiveFlowersResult = 24,
    SPACE_GetRecommendListOk = 27,
    SPACE_SearchPlayerOk = 29,
    SPACE_SpaceError = 50,
    SPACE_GetFashionRecommendListOk = 62,
    SPACE_GiveLikeResult = 64,
    SPACE_SearchFashionPlayerOk = 66,
    SPACE_GetCharmFashionInfoOk = 68,
    SPACE_OperationOk = 70,
    SPACE_GetFashionPreviousListOk = 72,
    ------------------------------------祈福相关协议--------------------------------------
    --主协议
    MAIN_TRATE = 118,

    --客户端发到服务器 (C->S)
    PRAY_GetPrayMess = 1,
    PRAY_Pray = 3,
    PRAY_Devour = 5,
    PRAY_ChangeBag = 7,
    PRAY_Sell = 9,
    PRAY_Call = 11,
    PRAY_Equip = 13,
    PRAY_FastDevour = 15,
    PRAY_GetPrayShop = 17,
    PRAY_buy = 19,
    PRAY_MergePray = 22,
    PRAY_FastEquip = 24,
    PRAY_GetRaffleInfo = 26,
    PRAY_Raffle = 28,
    PRAY_ResetRaffle = 30,
    PRAY_GiveRaffleReward = 32,

    --服务端发到客户端
    PRAY_GetPrayMessOk = 2,
    PRAY_PrayOk = 4,
    PRAY_DevourOk = 6,
    PRAY_ChangeBagOk = 8,
    PRAY_SellOk = 10,
    PRAY_CallOk = 12,
    PRAY_EquipOk = 14,
    PRAY_FastDevourOk = 16,
    PRAY_GetPrayShopOk = 18,
    PRAY_GetShopOk = 20,
    PRAY_MergePrayOk = 23,
    PRAY_FastEquipOk = 25,
    PRAY_GetRaffleInfoOk = 27,
    PRAY_RaffleOk = 29,
    PRAY_ResetRaffleOk = 31,
    PRAY_GiveRaffleRewardOk = 33,

    -----------------------------装备抽奖相关协议----------------------------------------
    --主协议
    MAIN_EQUIP = 119,
    --客户端发送到服务器
    EQUIP_Lottery=1,
    EQUIP_GetFreeTime = 14,
    EQUIP_GetEquipStore = 16,
    EQUIP_RefreshEquipStore = 18,
    EQUIP_Purchase = 19,
    EQUIP_TenLotteryRewardStatus = 21,
    EQUIP_ReceiveTenLotteryReward = 23,
    
    --服务端发到客户端
    EQUIP_LotteryOK=2,
    EQUIP_GetFreeTimeOK = 15,
    EQUIP_GetEquipStoreOk = 17,
    EQUIP_PurchaseOk = 20,
    EQUIP_TenLotteryRewardStatusOk = 22,
    EQUIP_ReceiveTenLotteryRewardOk = 24,
    -----------------------------修炼相关协议----------------------------------------
    --主协议
    MAIN_UPGRADE = 121,
    --客户端发送到服务器
    UPGRADE_RequestUpgradeInfo=1,
    UPGRADE_RequestUpgradeRandom = 3,
    UPGRADE_ShuangXiuAction=5,
    
    --服务端发到客户端
    UPGRADE_RequestUpgradeInfoOk=2,
    UPGRADE_RequestUpgradeRandomOk = 4,
    UPGRADE_ShuangXiuActionOK = 6,
    -----------------------------在线奖励相关协议----------------------------------------
    --主协议
    MAIN_ONLINEREWARD = 122,
    --客服端发送到服务器
    ONLINEREWARD_GetOnlineMes = 1,
    ONLINEREWARD_GetReward = 3,
    --服务器发送到客户端
    ONLINEREWARD_GetOnlineMesOk = 2,
    ONLINEREWARD_GetRewardOk = 4,
    -----------------------------卡牌系统相关协议----------------------------------------
    --主协议
    MAIN_CARD = 123,
    --客服端发送到服务器
    CARD_GetCardMes = 1,
    CARD_UpCard = 3,
    CARD_BuyCard = 5,
    CARD_LookCard = 7,
    CARD_GetCardSetList = 9,
    CARD_OpenCardSet = 11,
    CARD_RefreshCardStore = 13,
    CARD_SpeedUp = 14,
    --服务器发送到客户端
    CARD_GetCardMesOk = 2,
    CARD_UpCardOk = 4,
    CARD_BuyCardOk = 6,
    CARD_ActivationCardOk = 8,
    CARD_GetCardSetListOk = 10,
    CARD_OpenCardSetOk = 12,
    CARD_SpeedUpOk = 15,

    -----------------------------LBS系统相关协议----------------------------------------
    --主协议
    MAIN_NEIGHBOR = 124,
    --客服端发送到服务器
    NEIGHBOR_UploadLocation = 1,
    NEIGHBOR_Wander = 3,
    NEIGHBOR_SearchPlayerNearBy = 5,
    NEIGHBOR_SelfPlayerNeighborInfo = 9,
    NEIGHBOR_SearchNpcNearBy = 11,
    NEIGHBOR_ClickNpc = 13,

    --服务器发送到客户端
    NEIGHBOR_UploadLocationOk = 2,
    NEIGHBOR_WanderOk = 4,
    NEIGHBOR_SearchPlayerNearByOk = 6,
    NEIGHBOR_SelfPlayerNeighborInfoOk = 10,
    NEIGHBOR_SearchNpcNearByOk = 12,
    NEIGHBOR_GetNpcRewardOk = 14,

    --------------------------公会战相关协议-----------------------------------------
    --主协议
    MAIN_GUILDWAR = 125,
    --客户端发送到服务器的协议
    GUILDWAR_GuildFightInfo = 1,
    GUILDWAR_EntryGuildRoom = 3,
    GUILDWAR_OutGuildRoom = 5,
    GUILDWAR_InstallMember = 6,
    GUILDWAR_OutMember = 7,
    GUILDWAR_GuildFightRecord = 8,
    GUILDWAR_GuildFightRecordMes = 10,
    GUILDWAR_GetGuildWarTask = 12,
    GUILDWAR_ObtainGuildWarTask = 14,
    GUILDWAR_Invite = 17,
    GUILDWAR_GuildWarOut = 24,
    GUILDWAR_MyGuildWarRank = 28,
    GUILDWAR_LoadRankInfo = 60,
    GUILDWAR_Signup = 62,
    GUILDWAR_OldGuildWarMes = 30,
    GUILDWAR_SetAgent = 32,
    GUILDWAR_GetAgent = 34,
    GUILDWAR_GuildWarTime = 36,

    --服务器发送到客户端的协议
    GUILDWAR_GuildFightInfoOk = 2,
    GUILDWAR_EntryGuildRoomOk = 4,
    GUILDWAR_GuildFightRecordOk = 9,
    GUILDWAR_GuildFightRecordMesOk = 11,
    GUILDWAR_GetGuildWarTaskOk = 13,
    GUILDWAR_ObtainGuildWarTaskOk = 15,
    GUILDWAR_MessageOk = 16, 
    GUILDWAR_InviteOk = 18, 
    GUILDWAR_FightSucOk = 19,
    GUILDWAR_FightFinishOk = 20,
    GUILDWAR_LoadRankInfoOk = 61,
    GUILDWAR_SignupOk = 63,
    GUILDWAR_GuildWarOutOk = 25,
    GUILDWAR_GuildWarRank = 26,

    GUILDWAR_GuildWarRankOk = 27,
    GUILDWAR_MyGuildWarRankOk = 29,
    GUILDWAR_OldGuildWarMesOk = 31,
    GUILDWAR_SetAgentOk = 33,
    
    --代理人
    GUILDWAR_GetAgentOk = 35,
    GUILDWAR_GuildWarTimeOk = 37,
	---------------------------------挖宝相关协议------------------------
	MAIN_MINING = 100,

	--客户端发送给服务器的子协议
	MINING_GetMining = 1,
	MINING_MiningLog = 3,
	MINING_StartMining = 5,
	MINING_StopMining = 6,
	MINING_MiningBuy = 7,
	MINING_BuyTool = 9,
	MINING_GetMiningBag = 10,
	MINING_RecyclingMining = 12,
	MINING_Authenticate = 14,

	--服务器发给客户端的子协议
	MINING_GetMiningOk = 2,
	MINING_MiningLogOk = 4,
	MINING_MiningBuyOk = 8, 
	MINING_GetMiningBagOk = 11,
	MINING_RecyclingMiningOk = 13,
	MINING_AuthenticateOk = 15,
	---------------------------------幸运礼盒相关协议------------------------
	--主协议
	MAIN_LUCKYBOX = 127,

	--客户端发送给服务器的子协议
	LUCKYBOX_GetSysCardsList = 1,
	LUCKYBOX_GetPlayerCardsRecord = 3,
	LUCKYBOX_TurnCard = 5,

	--服务器发给客户端的子协议
	LUCKYBOX_GetSysCardsListOK = 2,
	LUCKYBOX_GetPlayerCardsRecordOK = 4,
	LUCKYBOX_TurnCardOK = 6,
	-----------------------------------道具赛---------------------
	--主协议
	MAIN_PROPS = 64,
	-- send
	PROPS_GetMatchInfo = 1,

	-- receive
	PROPS_GetMatchInfoOk = 2,
	PROPS_SendPropsList = 3,

    ---------------------------------符文系统------------------------
    --主协议
    MAIN_RUNE = 13,
    
    -- send
    RUNE_GetRuneInfo = 1,
    RUNE_OpenPlace = 3,
    RUNE_UpdateRune = 5,
    RUNE_GetRuneList = 7,
    RUNE_SellRune = 9,
    RUNE_GetRuneStore = 11,
    RUNE_RefreshRuneStore = 13,
    RUNE_BuyCommodity = 14,
    RUNE_GetLotteryInfo = 16,
    RUNE_Lottery = 18,

    -- receive
    RUNE_GetRuneInfoOk = 2,
    RUNE_OpenPlaceStatus = 4,
    RUNE_UpdateRuneStatus = 6,
    RUNE_GetRuneListOk = 8,
    RUNE_SellRuneStatus = 10,
    RUNE_GetRuneStoreOk = 12,
    RUNE_BuyCommodityStatus = 15,
    RUNE_GetLotteryInfoOk = 17,
    RUNE_LotteryStatus = 19,

    ---------------------------------禁忌之地系统------------------------
    --主协议
    MAIN_ZONE = 14,

    --send
    ZONE_GetZoneInfo = 1,
    ZONE_RollDice = 3,
    ZONE_GetBoxInfo = 5,
    ZONE_ChoiceBox = 7,
    ZONE_ChoiceDiamondBox = 9,
    ZONE_BuyDice = 11,
    ZONE_GetDiceStatus = 14,

    --receive
    ZONE_GetZoneInfoOk = 2,
    ZONE_PushEvent = 4,
    ZONE_GetBoxInfoOk = 6,
    ZONE_ChoiceBoxOk = 8,
    ZONE_ChoiceDiamondBoxOk = 10,
    ZONE_BuyDiceOk = 12,
    ZONE_PushMapRefresh = 13,
    ZONE_GetDiceStatusOk = 15,

    ----------------------------------推送相关协议----------------------------
	--主协议
	MAIN_COMMONPUSH = 11,
	--发送到服务端的协议
	COMMONPUSH_GetDirectionalPush = 2,
	COMMONPUSH_GetStoredDirectionalPush = 4,
	COMMONPUSH_LoginDirectionalPush = 6,

	--服务端发送到客户端的协议
	COMMONPUSH_GetDirectionalPushOk = 3,
	COMMONPUSH_GetStoredDirectionalPushOk = 5,
	COMMONPUSH_LoginDirectionalPushOk = 7,

    ---------------------------------觉醒系统------------------------
    --主协议
    MAIN_AWAKE = 25,

    --发送到服务端的协议
    AWAKE_GetAwakeInfo = 1,
    AWAKE_AwakeSoulTrain = 3,
    AWAKE_Awake = 5,
    AWAKE_DrawAwakeSuit = 7,
    AWAKE_Extract = 9,
    AWAKE_UpTalent = 11,
    AWAKE_ResetTalentNum = 13,
    AWAKE_AwakeEvolve = 15,
    --接受协议
    AWAKE_GetAwakeInfoOk = 2,
    AWAKE_AwakeSoulTrainOk = 4,
    AWAKE_AwakeOk = 6,
    AWAKE_DrawAwakeSuitOk = 8,
    AWAKE_ExtractOk = 10,
    AWAKE_UpTalentOk = 12,
    AWAKE_ResetTalentNumOk = 14,
    AWAKE_AwakeEvolveOk = 16,
    --------------------------------家园系统---------------------------
    --主协议
    MAIN_HOME = 26,

    --发送到服务端的协议
    HOME_GetPlayerHomeInfo = 1,
    HOME_GetStore = 3,
    HOME_AddBuilding = 5,
    HOME_MoveBuilding = 7,
    HOME_RemoveBuilding = 9,
    HOME_GetHomeRankList = 11,
    HOME_Collect = 13,
    HOME_LevelUp = 15,
    HOME_SpeedUp = 17,
    HOME_GetMapUpdate = 19,
    HOME_CreateHome = 21,
    HOME_Cancel = 23,
    HOME_Purchase = 25,
	HOME_Search = 27,
	HOME_GetBuildingInfo = 33,
	HOME_StartProduct = 35,
	HOME_SpeedUpProduct = 37,
	HOME_DrawReward = 39,
	HOME_AddServant = 41,
	HOME_EmployServant = 43,
	HOME_GetServrantEfficiency = 44,
	HOME_RefreshServrantEfficiency = 46,
	HOME_ReceieveWorkReward = 47,
	HOME_FeedGuardromon = 49,
	HOME_StartGuard = 51,
	HOME_StealWorkReward = 53,
	HOME_GetStealLog = 55,
	HOME_Cure = 57,

    --服务端发送到客户端的协议
    HOME_GetPlayerHomeInfoOk = 2,
    HOME_GetStoreOk = 4,
    HOME_AddBuildingOk = 6,
    HOME_MoveBuildingOk = 8,
    HOME_RemoveBuildingOk = 10,
    HOME_GetHomeRankListOk = 12,
    HOME_CollectOk = 14,
    HOME_LevelUpOk = 16,
    HOME_SpeedUpOk = 18,
    HOME_GetMapUpdateOk = 20,
    HOME_CreateHomeOk = 22,
    HOME_CancelOk = 24,
    HOME_PurchaseOk = 26,
	HOME_SearchOk = 28,
	HOME_GetBuildingInfoOk = 34, 
	HOME_StartProductOk = 36, 
	HOME_SpeedUpProductOk = 38, 
	HOME_DrawRewardOk = 40, 
	HOME_AddServantOk = 42,
	HOME_GetServrantEfficiencyOk = 45,
	HOME_ReceieveWorkRewardOk = 48,
	HOME_FeedGuardromonOk = 50,
	HOME_StartGuardOk = 52,
	HOME_StealWorkRewardOk = 54,
	HOME_GetStealLogOk = 56,
	HOME_CureOk = 58,
	HOME_EmployServantOk = 59,
	----------------------------------推送相关协议----------------------------
	--主协议
	MAIN_COMMONPUSH = 11,
	--发送到服务端的协议
	COMMONPUSH_GetDirectionalPush = 2,

	--服务端发送到客户端的协议
	COMMONPUSH_GetDirectionalPushOk = 3,
	----------------------------------足迹系统相关协议----------------------------
	--主协议
	MAIN_Footmark = 28,
	--发送到服务端的协议
	FOOTMARK_GetFootmark = 1,
	FOOTMARK_UseFootmark = 3,
	FOOTMARK_UpgradeFootmark = 5,
	FOOTMARK_AdvancedFootmark = 7,
	FOOTMARK_ChangeState = 8,

	--服务端发送到客户端的协议
	FOOTMARK_GetFootmarkOk = 2,
	FOOTMARK_UseFootmarkOk = 4,
	FOOTMARK_UpdataFootmark = 6,
	FOOTMARK_ChangeStateOK = 9,
	FOOTMARK_UpgradeRecordOk = 10,
	----------------------------------足迹系统相关协议----------------------------
	--主协议
	MAIN_TEAMWORLDBOSS = 98,
	--发送到服务端的协议
	TEAMWORLDBOSS_MakePair = 3,
	TEAMWORLDBOSS_CreateRoom = 5,
	TEAMWORLDBOSS_GameReady = 7,
	TEAMWORLDBOSS_QuickGame = 9,
	TEAMWORLDBOSS_BeInvite = 8,
	TEAMWORLDBOSS_QuitRoom = 10,
	TEAMWORLDBOSS_UpdateRoom = 12,
	TEAMWORLDBOSS_Inspire = 18,
	TEAMWORLDBOSS_GetTeamWorldBossHp = 22,
	TEAMWORLDBOSS_SelectRoom = 24,
	TEAMWORLDBOSS_GetRoomState = 26,
	TEAMWORLDBOSS_GetHurtRank = 28,
	TEAMWORLDBOSS_GetRoomList = 14,
	TEAMWORLDBOSS_BuyChallengeNum = 31,
	TEAMWORLDBOSS_Invite = 33,
	TEAMWORLDBOSS_BackToRoom = 35,
	--服务端发送到客户端的协议
	TEAMWORLDBOSS_MakePairOk = 4,
	TEAMWORLDBOSS_EnterRoomOk = 6, 
	TEAMWORLDBOSS_QuitRoomOk = 11,
	TEAMWORLDBOSS_GetTeamWorldBossHpOk = 23,
	TEAMWORLDBOSS_InspireOk = 25,
	TEAMWORLDBOSS_GetRoomStateOk = 27,
	TEAMWORLDBOSS_GetHurtRankOk = 29,
	TEAMWORLDBOSS_SendSettlementInfo = 30,
	TEAMWORLDBOSS_GetRoomListOk = 15,
	TEAMWORLDBOSS_BuyChallengeNumOk = 32,
	TEAMWORLDBOSS_BattleHurtInfo = 34,
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议回调函数
--@param 	nMainId:主协议号
--@param 	nSubId:子协议号
--@param 	sCallbackFunc:回调函数（字符串形式）
--@param 	sDataFormat:数据格式
--@return	无
--@note		注册协议回调函数
function Protocol:reg(nMainId, nSubId, sCallbackFunc, sDataFormat)
    --WZLog(debug.traceback())
    if nMainId == nil or nSubId == nil then
        WZLog(debug.traceback())
    end
	KLuaMutiRegSocket:getInstance():registerProtocolProcesser(sCallbackFunc, sDataFormat, nMainId, nSubId)
end

--@brief	反注册协议回调函数
--@param 	nMainId:主协议号
--@param 	nSubId:子协议号
--@param 	sCallbackFunc:回调函数（字符串形式）
--@param 	sDataFormat:数据格式
--@return	无
--@note		反注册协议回调函数
function Protocol:unreg(nMainId, nSubId, sCallbackFunc, sDataFormat)
	KLuaMutiRegSocket:getInstance():unregisterProtocolProcesser(sCallbackFunc, sDataFormat, nMainId, nSubId)
end

--@brief	检查协议是否已经注册
--@param 	nMainId:主协议号
--@param 	nSubId:子协议号
--@param 	sCallbackFunc:回调函数（字符串形式）
--@param 	sDataFormat:数据格式
--@return	无
--@note		检查协议是否已经注册
function Protocol:isReg(nMainId, nSubId, sCallbackFunc, sDataFormat)
	KLuaMutiRegSocket:getInstance():isProtocolProcesserRegistered(sCallbackFunc, sDataFormat, nMainId, nSubId)
end

--@brief	清空协议
--@param 	无
--@return	无
--@note		反注册所有已经注册的协议
function Protocol:clearReg()
	KLuaMutiRegSocket:getInstance():clearProtocolProcesser()
end

--@brief	获取一个ProtocolSender
--@param 	nMainId:主协议号
--@param 	nSubId:子协议号
--@return	#1:ProtocolSender
--@note		获取一个ProtocolSender
			--ProtocolSender相当于一个容器，
			--其中可以存放各种数据，将存放了数据的ProtocolSender发送给服务器
function Protocol:getSender(nMainId, nSubId)
	if not NetManager:isConnected() then
		return nil
	end

	--没有登录成功之前，只能发送登录相关协议与系统协议；登录成功后才可以发送其他协议
	if (not GlobalGame.g_bIfLoginOk) and nMainId ~= Protocol.MAIN_ACCOUNT and nMainId ~= Protocol.MAIN_SYSTEM and nMainId ~= Protocol.MAIN_ERRORCODE then
		WZLog("---------------------------------------------------")
		WZLog(KLuaSocket:utfToGBK("协议发送失败：没有成功登录之前不能发送其他无关协议"))
		WZLog(KLuaSocket:utfToGBK("失败的协议："), nMainId, nSubId)
		WZLog("---------------------------------------------------")
		return nil
	end
	MsgBoxManager:createAutoLoadingBox(nMainId,nSubId)
	return KLuaProtocolSender:create(nMainId, nSubId)
end

--@brief 自动加载loading界面
function Protocol:isAutoLoadingMsgBox(nMainId, nSubId)
	if ProtocolLoadingList[nMainId] and ProtocolLoadingList[nMainId][nSubId] == 0 then
		return false
	end
	return true
end

-------------------------------------公有方法模块End--------------------------------------



--ProtocolProcessorDesignation
--@brief	称号相关协议
--@date  	2013/12/12
--@author 	liangguang_long
--@note 	称号相关协议


ProtocolProcessorDesignation = ProtocolProcessorBase:new()

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	注册协议组所有协议
--@note		注册协议组所有协议
function ProtocolProcessorDesignation:regAll()
	WZLog("ProtocolProcessorDesignation:regAll")
	--@brief	获取成就列表成功（ACHIEVEMENT_GetAchievementListOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACHIEVEMENT, Protocol.ACHIEVEMENT_GetAchievementListOk, "ProtocolProcessorDesignation:parse_ACHIEVEMENT_GetAchievementListOk", "ivivivivivi")

	--@brief	更新成就内容（ACHIEVEMENT_UpdateAchievement = 3）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACHIEVEMENT, Protocol.ACHIEVEMENT_UpdateAchievement, "ProtocolProcessorDesignation:parse_ACHIEVEMENT_UpdateAchievement", "vivivivivi")

	--@brief	领取成就奖励成功（ACHIEVEMENT_GetAchievementRewardOk = 6）
	self:regProtocolCallbackFunction( Protocol.MAIN_ACHIEVEMENT, Protocol.ACHIEVEMENT_GetAchievementRewardOk, "ProtocolProcessorDesignation:parse_ACHIEVEMENT_GetAchievementRewardOk", "si")

	--@brief	获取称号列表列表成功（TITLE_GetTitleListOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_TITLE, Protocol.TITLE_GetTitleListOk, "ProtocolProcessorDesignation:parse_TITLE_GetTitleListOk", "vivivsvivivs")
	
	--@brief	设置显示的称号成功（TITLE_SetTitleOk = 5）
	self:regProtocolCallbackFunction( Protocol.MAIN_TITLE, Protocol.TITLE_SetTitleOk, "ProtocolProcessorDesignation:parse_TITLE_SetTitleOk", "i")
	--@brief	更新玩家称号（TITLE_UpdateTitle = 3）
	self:regProtocolCallbackFunction( Protocol.MAIN_TITLE, Protocol.TITLE_UpdateTitle, "ProtocolProcessorDesignation:parse_TITLE_UpdateTitle", "iisii")

	--@brief	获取徽章列表成功（BADGE_GetBadgeListOk = 2）
	self:regProtocolCallbackFunction( Protocol.MAIN_BADGE, Protocol.BADGE_GetBadgeListOk, "ProtocolProcessorDesignation:parse_BADGE_GetBadgeListOk", "ivtvivivivivivi")

	--@brief	徽章升级成功（BADGE_UpgradeBadgeOK = 4）
	self:regProtocolCallbackFunction( Protocol.MAIN_BADGE, Protocol.BADGE_UpgradeBadgeOK, "ProtocolProcessorDesignation:parse_BADGE_UpgradeBadgeOK", "itiiivivi")

	--协议错误处理
	
	--@brief	获取成就列表（ACHIEVEMENT_GetAchievementList = 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACHIEVEMENT, Protocol.ACHIEVEMENT_GetAchievementList, "ProtocolProcessorDesignation:send_ACHIEVEMENT_GetAchievementList_ErrorProcess", "is" )

	--@brief	改变成就状态（ACHIEVEMENT_ChangeAchievement = 4）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACHIEVEMENT, Protocol.ACHIEVEMENT_ChangeAchievement, "ProtocolProcessorDesignation:send_ACHIEVEMENT_ChangeAchievement_ErrorProcess", "is" )

	--@brief	领取成就奖励（ACHIEVEMENT_GetAchievementReward = 5）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_ACHIEVEMENT, Protocol.ACHIEVEMENT_GetAchievementReward, "ProtocolProcessorDesignation:send_ACHIEVEMENT_GetAchievementReward_ErrorProcess", "is" )

	--@brief	获取称号列表列表（TITLE_GetTitleList = 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TITLE, Protocol.TITLE_GetTitleList, "ProtocolProcessorDesignation:send_TITLE_GetTitleList_ErrorProcess", "is" )

	--@brief	设置显示的称号（TITLE_SetTitle = 4）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_TITLE, Protocol.TITLE_SetTitle, "ProtocolProcessorDesignation:send_TITLE_SetTitle_ErrorProcess", "is" )

	--@brief	获取徽章列表（BADGE_GetBadgeList = 1）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BADGE, Protocol.BADGE_GetBadgeList, "ProtocolProcessorDesignation:send_BADGE_GetBadgeList_ErrorProcess", "is" )

	--@brief	徽章升级（BADGE_UpgradeBadge = 3）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_BADGE, Protocol.BADGE_UpgradeBadge, "ProtocolProcessorDesignation:send_BADGE_UpgradeBadge_ErrorProcess", "is" )

end

--@brief	反注册协议组所有协议
--@note		反注册协议组所有协议
function ProtocolProcessorDesignation:unregAll()
	self:clearReg()
end
  
-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取成就列表（ACHIEVEMENT_GetAchievementList = 1）
function ProtocolProcessorDesignation:send_ACHIEVEMENT_GetAchievementList( )
	WZLog("send_ACHIEVEMENT_GetAchievementList")
	local sender = Protocol:getSender( Protocol.MAIN_ACHIEVEMENT, Protocol.ACHIEVEMENT_GetAchievementList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end


--@brief	改变成就状态（ACHIEVEMENT_ChangeAchievement = 4）
function ProtocolProcessorDesignation:send_ACHIEVEMENT_ChangeAchievement(id )
	WZLog("send_ACHIEVEMENT_ChangeAchievement")
	local sender = Protocol:getSender( Protocol.MAIN_ACHIEVEMENT, Protocol.ACHIEVEMENT_ChangeAchievement )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 成就ID
	SendProtocol(sender,false) --true:showLoading
end


--@brief	领取成就奖励（ACHIEVEMENT_GetAchievementReward = 5）
function ProtocolProcessorDesignation:send_ACHIEVEMENT_GetAchievementReward(id )
	WZLog("send_ACHIEVEMENT_GetAchievementReward")
	local sender = Protocol:getSender( Protocol.MAIN_ACHIEVEMENT, Protocol.ACHIEVEMENT_GetAchievementReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 成就ID
	SendProtocol(sender,false) --true:showLoading
end


--@brief	获取称号列表列表（TITLE_GetTitleList = 1）
function ProtocolProcessorDesignation:send_TITLE_GetTitleList( )
	WZLog("send_TITLE_GetTitleList")
	local sender = Protocol:getSender( Protocol.MAIN_TITLE, Protocol.TITLE_GetTitleList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	设置显示的称号（TITLE_SetTitle = 4）
function ProtocolProcessorDesignation:send_TITLE_SetTitle(id)
	WZLog("send_TITLE_SetTitle")
	local sender = Protocol:getSender( Protocol.MAIN_TITLE, Protocol.TITLE_SetTitle )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 玩家称号id
	SendProtocol(sender,false) --true:showLoading
end


--@brief	获取徽章列表（BADGE_GetBadgeList = 1）
function ProtocolProcessorDesignation:send_BADGE_GetBadgeList( )
	WZLog("send_BADGE_GetBadgeList")
	local sender = Protocol:getSender( Protocol.MAIN_BADGE, Protocol.BADGE_GetBadgeList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	徽章升级（BADGE_UpgradeBadge = 3）
function ProtocolProcessorDesignation:send_BADGE_UpgradeBadge(id, level )
	WZLog("send_BADGE_UpgradeBadge")
	local sender = Protocol:getSender( Protocol.MAIN_BADGE, Protocol.BADGE_UpgradeBadge )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeByte( id )	-- 类型(1生命，2力量，3护甲)
	sender:writeInt( level )	-- 当前徽章等级
	SendProtocol(sender,false) --true:showLoading
end


-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	获取成就列表成功（ACHIEVEMENT_GetAchievementListOk = 2）
function ProtocolProcessorDesignation:parse_ACHIEVEMENT_GetAchievementListOk(achievementPort, id, status, count, target, complete)
	-- id : 成就ID
	-- status : 状态0未完成，1完成并未查看，2，查看但未领取，3，查看并领取
	-- count : 每个成就的目标数量（一个成就可能只有一个目标也可能有多个目标）
	-- target : 目标数量
	-- complete : 完成数量
	WZLog("ProtocolProcessorDesignation:parse_ACHIEVEMENT_GetAchievementListOk")
	CacheCenter:setAchieList(id, status, count, target, complete, achievementPort)
end

--@brief	更新成就内容（ACHIEVEMENT_UpdateAchievement = 3）
function ProtocolProcessorDesignation:parse_ACHIEVEMENT_UpdateAchievement(id, status, count, target, complete)
	-- id : 成就ID
	-- status : 状态0未完成，1完成并未查看，2，查看但未领取，3，查看并领取
	-- count : 该成就的目标数量（成就可能只有一个目标也可能有多个目标）
	-- target : 目标数量
	-- complete : 完成数量
	WZLog("ProtocolProcessorDesignation:parse_ACHIEVEMENT_UpdateAchievement")

	CacheCenter:updateAchieList(id, status, count, target, complete)
end

--@brief	领取成就奖励成功（ACHIEVEMENT_GetAchievementRewardOk = 6）
function ProtocolProcessorDesignation:parse_ACHIEVEMENT_GetAchievementRewardOk(reward, achievementPort)
	-- reward : 奖励内容
	WZLog("ProtocolProcessorDesignation:parse_ACHIEVEMENT_GetAchievementRewardOk")
	WndDesignationMain:acceptPrizeSucess(reward, achievementPort)
    local id,num = SplitItemString(reward)
    WndRewardShow:showById(id,num)
end

--@brief	获取称号列表列表成功（TITLE_GetTitleListOk = 2）
function ProtocolProcessorDesignation:parse_TITLE_GetTitleListOk(id, sort, name, remain, status, desc)
	-- id : 称号ID
	-- sort : 称号类别
	-- name : 称号名称
	-- remain : 剩余天数
	-- status : 状态，0.不可用；1.可用；2.使用中；3.新称号
	-- desc : 称号描述
	WZLog("ProtocolProcessorDesignation:parse_TITLE_GetTitleListOk")
	CacheCenter:setDesiList(id, sort, name, remain, status, desc)
end

--@brief	设置显示的称号成功（TITLE_SetTitleOk = 5）
function ProtocolProcessorDesignation:parse_TITLE_SetTitleOk(id)
	-- title : 称号
	WZLog("ProtocolProcessorDesignation:parse_TITLE_SetTitleOk")
	CacheCenter:updateShowDesi( id )
end

--@brief	更新玩家称号（TITLE_UpdateTitle = 3）
function ProtocolProcessorDesignation:parse_TITLE_UpdateTitle(id, sort, name, remain, status)
	-- id : 称号ID
	-- sort : 称号类别
	-- name : 称号名称
	-- remain : 剩余天数
	-- status : 状态，0不可用，1，可用，2，使用中
	WZLog("ProtocolProcessorDesignation:parse_TITLE_UpdateTitle")
	CacheCenter:updateDesiList(id, sort, name, remain, status)
end

--@brief	获取徽章列表成功（BADGE_GetBadgeListOk = 2）
function ProtocolProcessorDesignation:parse_BADGE_GetBadgeListOk(achievementPort, genre, level, maxLevel, attribute, itemCount, itemId, itemNum)
	-- achievementPort : 当前可用成就点
	-- genre : 类型(1生命，2力量，3护甲)
	-- level : 徽章当前等级
	-- maxLevel : 类型徽章最大等级
	-- attribute : 徽章当前属性加成
	-- itemCount : 每类型徽章升级消耗物品种类数量(成就点)
	-- itemId : 徽章升级消耗物品ID(成就点)
	-- itemNum : 徽章升级消耗物品数量(成就点)
	WZLog("ProtocolProcessorDesignation:parse_BADGE_GetBadgeListOk")
	WndDesignationMain:setBadgeData(achievementPort, genre, level, maxLevel, attribute, itemCount, itemId, itemNum)
end

--@brief	徽章升级成功（BADGE_UpgradeBadgeOK = 4）
function ProtocolProcessorDesignation:parse_BADGE_UpgradeBadgeOK(achievementPort, genre, level, maxLevel, attribute, itemId, itemNum)
	-- achievementPort : 当前可用成就点
	-- genre : 类型(1生命，2力量，3护甲)
	-- level : 当前等级
	-- maxLevel : 最大等级
	-- attribute : 属性加成
	-- itemId : 下一次成就点升级消耗物品ID(成就点id)
	-- itemNum : 下一次成就点升级消耗物品数量(成就点数量)
	WZLog("ProtocolProcessorDesignation:parse_BADGE_UpgradeBadgeOK")
	WndDesignationMain:onBadgeUpgradeOk(achievementPort, genre, level, maxLevel, attribute, itemId, itemNum)
end
-------------------------------------协议错误处理方法模块--------------------------------------
--@brief	获取成就列表（ACHIEVEMENT_GetAchievementList = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDesignation:send_ACHIEVEMENT_GetAchievementList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDesignation:send_ACHIEVEMENT_GetAchievementList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACHIEVEMENT, Protocol.ACHIEVEMENT_GetAchievementList, nflag, sMessage)
end


--@brief	改变成就状态（ACHIEVEMENT_ChangeAchievement = 4）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDesignation:send_ACHIEVEMENT_ChangeAchievement_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDesignation:send_ACHIEVEMENT_ChangeAchievement_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACHIEVEMENT, Protocol.ACHIEVEMENT_ChangeAchievement, nflag, sMessage)
end


--@brief	领取成就奖励（ACHIEVEMENT_GetAchievementReward = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDesignation:send_ACHIEVEMENT_GetAchievementReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDesignation:send_ACHIEVEMENT_GetAchievementReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_ACHIEVEMENT, Protocol.ACHIEVEMENT_GetAchievementReward, nflag, sMessage)
end

--@brief	获取称号列表列表（TITLE_GetTitleList = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDesignation:send_TITLE_GetTitleList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDesignation:send_TITLE_GetTitleList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TITLE, Protocol.TITLE_GetTitleList, nflag, sMessage)
end

--@brief	设置显示的称号（TITLE_SetTitle = 4）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDesignation:send_TITLE_SetTitle_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDesignation:send_TITLE_SetTitle_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_TITLE, Protocol.TITLE_SetTitle, nflag, sMessage)
end

--@brief	获取徽章列表（BADGE_GetBadgeList = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDesignation:send_BADGE_GetBadgeList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDesignation:send_BADGE_GetBadgeList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BADGE, Protocol.BADGE_GetBadgeList, nflag, sMessage)
end

--@brief	徽章升级（BADGE_UpgradeBadge = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorDesignation:send_BADGE_UpgradeBadge_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorDesignation:send_BADGE_UpgradeBadge_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_BADGE, Protocol.BADGE_UpgradeBadge, nflag, sMessage)
end


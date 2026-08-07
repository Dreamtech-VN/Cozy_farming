--ProtocolProcessorWndSkillProp.lua
--@brief	技能道具协议
--@date  	2013/12/10
--@author 	xiezemin
--@note 	技能道具协议


ProtocolProcessorWndSkillProp = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorWndSkillProp:regAll()
	--获取角色技能列表成功
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerSkillOk, "ProtocolProcessorWndSkillProp:parse_PLAYER_GetPlayerSkillOk", "vivs")
	--@brief	获取技能列表 PLAYER_GetSkillListOk = 74
	self:regProtocolCallbackFunction(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSkillListOk, "ProtocolProcessorWndSkillProp:parse_PLAYER_GetSkillListOk", "vivi")
	--@brief	获取技能列表 PLAYER_GetWeaponSkillListOk = 95
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetWeaponSkillListOk, "ProtocolProcessorWndSkillProp:parse_PLAYER_GetWeaponSkillListOk", "viivivivivivs")
	--@brief	重置武器技能 （PLAYER_ResetWeaponSkillOk = 99）
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_ResetWeaponSkillOk, "ProtocolProcessorWndSkillProp:parse_PLAYER_ResetWeaponSkillOk", "")


	--@brief	获取玩家技能错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerSkill, "ProtocolProcessorWndSkillProp:send_PLAYER_GetPlayerSkill_ErrorProcess", "is" )
	--@brief	选择技能错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_ChangeSkill, "ProtocolProcessorWndSkillProp:send_PLAYER_ChangeSkill_ErrorProcess", "is" )
    --@brief	获取技能列表（PLAYER_GetSkillList = 3）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSkillList , "ProtocolProcessorWndSkillProp:send_PLAYER_GetSkillList _ErrorProcess", "is" )
    --@brief	升级技能（PLAYER_UpgradeSkill = 75）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_UpgradeSkill , "ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeSkill_ErrorProcess", "is" )
    --@brief	购买技能栏（PLAYER_BuySkillBox = 79）错误处理(S->C)
    self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_BuySkillBox , "ProtocolProcessorWndSkillProp:send_PLAYER_BuySkillBox _ErrorProcess", "is" )

--@brief	获取武器技能列表（PLAYER_GetWeaponSkillList = 94）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetWeaponSkillList, "ProtocolProcessorWndSkillProp:send_PLAYER_GetWeaponSkillList_ErrorProcess", "is" )
--@brief	技能升级，没有获得该技能就激活（PLAYER_UpgradeWeaponSkill = 96）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_UpgradeWeaponSkill , "ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeWeaponSkill_ErrorProcess", "is" )
--@brief	技能更换（PLAYER_changeWeaponSkill = 97）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_changeWeaponSkill, "ProtocolProcessorWndSkillProp:send_PLAYER_changeWeaponSkill_ErrorProcess", "is" )
--@brief	重置武器技能（返回95,99协议）（PLAYER_ResetWeaponSkill = 98）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_ResetWeaponSkill, "ProtocolProcessorWndSkillProp:send_PLAYER_ResetWeaponSkill_ErrorProcess", "is" )
	
--@brief	获取幻化技能列表（PLAYER_GetShapeSkillList = 100）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetShapeSkillList, "ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList_ErrorProcess", "is" )
--@brief	切换幻化技能（PLAYER_ChangeShapeSkill = 102）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_ChangeShapeSkill, "ProtocolProcessorWndSkillProp:send_PLAYER_ChangeShapeSkill_ErrorProcess", "is" )
--@brief	获取幻化技能列表 （PLAYER_GetShapeSkillListOk = 101）
self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetShapeSkillListOk, "ProtocolProcessorWndSkillProp:parse_PLAYER_GetShapeSkillListOk", "ivi")
	--@brief	获取技能列表 PLAYER_UpAwakeSkillOk = 103
	self:regProtocolCallbackFunction( Protocol.MAIN_PLAYER, Protocol.PLAYER_UpAwakeSkillOk, "ProtocolProcessorWndSkillProp:parse_PLAYER_UpAwakeSkillOk", "i")
end

--@brief	反注册协议组所有协议
function ProtocolProcessorWndSkillProp:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取技能列表（PLAYER_GetSkillList = 73）
function ProtocolProcessorWndSkillProp:send_PLAYER_GetSkillList()
	WZLog("send_PLAYER_GetSkillList ")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSkillList  )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	升级技能（PLAYER_UpgradeSkill = 75）
function ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeSkill(skillId,consumeId)
	WZLog("send_PLAYER_UpgradeSkill ")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_UpgradeSkill  )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt(skillId)	-- 技能ID
	sender:writeInt(consumeId)  --消耗物品ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取玩家技能
function ProtocolProcessorWndSkillProp:send_PLAYER_GetPlayerSkill()
	WZLog("send_PLAYER_GetPlayerSkill")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerSkill )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	选择技能
function ProtocolProcessorWndSkillProp:send_PLAYER_ChangeSkill(itemId,index )
	WZLog("send_PLAYER_ChangeSkill", itemId, skillType ,index)
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_ChangeSkill )
	if sender==nil then WZLog("sender == nil") return end
	sender:writeInt( itemId )	-- 技能ID,如果为0，则删除索引的技能
	sender:writeInt( index )	-- 玩家技能索引
	SendProtocol(sender,false) --true:showLoading
end

--@brief	购买技能栏（PLAYER_BuySkillBox = 79）
function ProtocolProcessorWndSkillProp:send_PLAYER_BuySkillBox (index )
	WZLog("send_PLAYER_BuySkillBox")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_BuySkillBox  )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( index )	-- 购买的栏位索引
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取武器技能列表（PLAYER_GetWeaponSkillList = 94）
function ProtocolProcessorWndSkillProp:send_PLAYER_GetWeaponSkillList( )
	WZLog("send_PLAYER_GetWeaponSkillList")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetWeaponSkillList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	技能升级，没有获得该技能就激活（PLAYER_UpgradeWeaponSkill = 96）
function ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeWeaponSkill(skillId )
	WZLog("send_PLAYER_UpgradeWeaponSkill")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_UpgradeWeaponSkill  )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( skillId )	-- 技能ID
	SendProtocol(sender,false) --true:showLoading
end

--@brief	技能更换（PLAYER_changeWeaponSkill = 97）
function ProtocolProcessorWndSkillProp:send_PLAYER_changeWeaponSkill(skillId, index )
	WZLog("send_PLAYER_changeWeaponSkill",skillId, index)
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_changeWeaponSkill )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( skillId )	-- 技能ID,如果为0，则删除索引的技能
	sender:writeInt( index )	-- 玩家技能索引（下标冲0开始）
	SendProtocol(sender,false) --true:showLoading
end

--@brief	重置武器技能（返回95,99协议）（PLAYER_ResetWeaponSkill = 98）
function ProtocolProcessorWndSkillProp:send_PLAYER_ResetWeaponSkill( )
	WZLog("send_PLAYER_ResetWeaponSkill")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_ResetWeaponSkill )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取幻化技能列表（PLAYER_GetShapeSkillList = 100）
function ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList( )
	WZLog("send_PLAYER_GetShapeSkillList")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_GetShapeSkillList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	切换幻化技能（PLAYER_ChangeShapeSkill = 102）
function ProtocolProcessorWndSkillProp:send_PLAYER_ChangeShapeSkill(skillId )
	WZLog("send_PLAYER_ChangeShapeSkill")
	local sender = Protocol:getSender( Protocol.MAIN_PLAYER, Protocol.PLAYER_ChangeShapeSkill )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( skillId )	-- 技能ID
	SendProtocol(sender,false) --true:showLoading
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------

-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	获取技能列表 PLAYER_GetSkillListOk = 74
function ProtocolProcessorWndSkillProp:parse_PLAYER_GetSkillListOk(itemId, unlock)
	-- itemId : 技能id
	-- unlock : 是否已解锁
	WZLog("ProtocolProcessorWndSkillProp:parse_PLAYER_GetSkillListOk")
	CacheCenter:updateSkillList(VectorToTable(itemId),VectorToTable(unlock))
	if WndSkillProp.m_root ~= nil and WndSkillProp.m_nWinType == 2 then
		WndSkillProp:showSkillProps(VectorToTable(itemId),VectorToTable(unlock))
	end
	--更新红点
	WndSkillContainer:_bShowRed()
end

--@brief	获取角色技能列表成功
function ProtocolProcessorWndSkillProp:parse_PLAYER_GetPlayerSkillOk(itemId,skillExplain)
	-- count : 数量
	-- id : 道具序号
	WZLog("ProtocolProcessorWndSkillProp:parse_PLAYER_GetPlayerSkillOk ")
	CacheCenter:updatePlayerSkill(VectorToTable(itemId),VectorToTable(skillExplain))
	if WndSkillProp.m_root ~= nil and WndSkillProp.m_nWinType == 2 then
		WndSkillProp:receiveGetPlayerSkillOk(VectorToTable(itemId),VectorToTable(skillExplain))
	end
end

--@brief	获取技能列表 PLAYER_GetWeaponSkillListOk = 95
function ProtocolProcessorWndSkillProp:parse_PLAYER_GetWeaponSkillListOk(unlockSkill, skillNum, useSkill, openLevel, logtype, logskillId, mes)
	-- unlockSkill : 获得技能id
	-- skillNum : 技能点
	-- useSkill : 使用中技能id
	-- openLevel : 开启技能孔等级
	WZLog("ProtocolProcessorWndSkillProp:parse_PLAYER_GetWeaponSkillListOk", USESKILLBOOK)
	--用技能书
	if USESKILLBOOK then
		WZLog("用技能书")
		USESKILLBOOK = false
		MsgBoxManager:showTipBox(LocalStrings.NEWSKILL25)
	end
	CacheCenter:setSkill(VectorToTable(unlockSkill), skillNum, VectorToTable(useSkill), VectorToTable(openLevel), VectorToTable(logtype), VectorToTable(logskillId), VectorToTable(mes))
	GlobalGame:getBtnRedPointEvent():dispatcher()
end

--@brief	重置武器技能 （PLAYER_ResetWeaponSkillOk = 99）
function ProtocolProcessorWndSkillProp:parse_PLAYER_ResetWeaponSkillOk()
	WZLog("ProtocolProcessorWndSkillProp:parse_PLAYER_ResetWeaponSkillOk")
	MsgBoxManager:showTipBox(LocalStrings.NEWSKILL21)
	if WndSkillProp.m_root ~= nil and WndSkillProp.m_nWinType == 1 then
		WndSkillProp:selectFirst()
	end
end

--@brief	获取幻化技能列表 （PLAYER_GetShapeSkillListOk = 101）
function ProtocolProcessorWndSkillProp:parse_PLAYER_GetShapeSkillListOk(useSkill, skillList)
	-- useSkill : 使用中技能id
	-- skillList : 拥有的所有技能
	WZLog("ProtocolProcessorWndSkillProp:parse_PLAYER_GetShapeSkillListOk", useSkill)
	WndSkinSkill:setData(useSkill, skillList)
end

--@brief	升级觉醒技能 （PLAYER_UpAwakeSkillOk = 103）
function ProtocolProcessorWndSkillProp:parse_PLAYER_UpAwakeSkillOk(awakeSkillId)
	-- awakeSkillId : 升级后的觉醒技能id
	WZLog("ProtocolProcessorWndSkillProp:parse_PLAYER_UpAwakeSkillOk", awakeSkillId)
	CellWakeupDetail:upgradeSubSkillOK(awakeSkillId)
end
-------------------------------------服务器到客户端协议回调方法模块--------------------------------------

--@brief	购买技能栏（PLAYER_BuySkillBox = 79）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_BuySkillBox_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_BuySkillBox _ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_BuySkillBox , nflag, sMessage)
end


--@brief	获取玩家技能错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_GetPlayerSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_GetPlayerSkill_ErrorProcess")
	MsgBoxManager:showTipBox(sMessage)
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetPlayerSkill, nflag, sMessage)
end

--@brief	选择技能错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_ChangeSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_ChangeSkill_ErrorProcess")
	if WndSkillProp.m_root ~= nil and WndSkillProp.m_nWinType == 2 then
	WndSkillProp:changeSkillError(nFlag,sMessage)
	end
	--ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_ChangeSkill, nflag, sMessage)
end

--@brief	获取技能列表（PLAYER_GetSkillList = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_GetSkillList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_GetSkillList _ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetSkillList , nflag, sMessage)
end

--@brief	升级技能（PLAYER_BuySkill = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeSkill_ErrorProcess")
	if WndSkillProp.m_root ~= nil and WndSkillProp.m_nWinType == 2 then
	WndSkillProp:resertCurSelectId()
		WndSkillProp.m_bClickUpgrade = false
        WndSkillProp.m_bIsVisitNet = false
	end
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_UpgradeSkill , nflag, sMessage)
end

--@brief	获取武器技能列表（PLAYER_GetWeaponSkillList = 94）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_GetWeaponSkillList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_GetWeaponSkillList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetWeaponSkillList, nflag, sMessage)
end

--@brief	技能升级，没有获得该技能就激活（PLAYER_UpgradeWeaponSkill = 96）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeWeaponSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_UpgradeWeaponSkill_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_UpgradeWeaponSkill , nflag, sMessage)
end

--@brief	技能更换（PLAYER_changeWeaponSkill = 97）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_changeWeaponSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_changeWeaponSkill_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_changeWeaponSkill, nflag, sMessage)
end

--@brief	重置武器技能（返回95,99协议）（PLAYER_ResetWeaponSkill = 98）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_ResetWeaponSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_ResetWeaponSkill_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_ResetWeaponSkill, nflag, sMessage)
end

--@brief	获取幻化技能列表（PLAYER_GetShapeSkillList = 100）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_GetShapeSkillList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_GetShapeSkillList, nflag, sMessage)
end

--@brief	切换幻化技能（PLAYER_ChangeShapeSkill = 102）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndSkillProp:send_PLAYER_ChangeShapeSkill_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndSkillProp:send_PLAYER_ChangeShapeSkill_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_PLAYER, Protocol.PLAYER_ChangeShapeSkill, nflag, sMessage)
end


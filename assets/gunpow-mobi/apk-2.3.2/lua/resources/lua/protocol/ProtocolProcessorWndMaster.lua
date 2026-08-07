--ProtocolProcessorWndMaster.lua
--@brief	背包模块协议
--@date  	2014/02/18
--@author 	xiaoyu_wu
--@note 	背包模块所使用协议


ProtocolProcessorWndMaster = ProtocolProcessorBase:new()

-------------------------------------公有方法模块--------------------------------------

--@brief	注册协议组所有协议
function ProtocolProcessorWndMaster:regAll()
	WZLog("ProtocolProcessorWndMaster:regAll")
--@brief	获取师徒圣殿（MENTORING_GetTemple = 1）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetTemple, "ProtocolProcessorWndMaster:send_MENTORING_GetTemple_ErrorProcess", "is" )
--@brief	师徒大厅（MENTORING_GetMentoring = 3）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMentoring, "ProtocolProcessorWndMaster:send_MENTORING_GetMentoring_ErrorProcess", "is" )
--@brief	我的师博（MENTORING_GetMyMaster = 5）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyMaster, "ProtocolProcessorWndMaster:send_MENTORING_GetMyMaster_ErrorProcess", "is" )
--@brief	我的徒弟（MENTORING_GetMyPupils = 7）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyPupils, "ProtocolProcessorWndMaster:send_MENTORING_GetMyPupils_ErrorProcess", "is" )
--@brief	拜师（MENTORING_Baishi = 9）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_Baishi, "ProtocolProcessorWndMaster:send_MENTORING_Baishi_ErrorProcess", "is" )
--@brief	收徒（MENTORING_Shoutu = 11）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_Shoutu, "ProtocolProcessorWndMaster:send_MENTORING_Shoutu_ErrorProcess", "is" )
--@brief	获取消息列表（MENTORING_GetMentoringMessage = 13）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMentoringMessage, "ProtocolProcessorWndMaster:send_MENTORING_GetMentoringMessage_ErrorProcess", "is" )
--@brief	处理拜师/收徒消息（MENTORING_Processing = 16）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_Processing, "ProtocolProcessorWndMaster:send_MENTORING_Processing_ErrorProcess", "is" )
--@brief	解除关系（MENTORING_Disassociate = 18）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_Disassociate, "ProtocolProcessorWndMaster:send_MENTORING_Disassociate_ErrorProcess", "is" )
--@brief	获取任务信息（MENTORING_GetTask = 23）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetTask, "ProtocolProcessorWndMaster:send_MENTORING_GetTask_ErrorProcess", "is" )
--@brief	领取任务奖励（MENTORING_GetReward = 25）错误处理(S->C)
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetReward, "ProtocolProcessorWndMaster:send_MENTORING_GetReward_ErrorProcess", "is" )

--@brief	获取师徒圣殿（MENTORING_GetTempleOk = 2）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetTempleOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetTempleOk", "biiiiibiiiiivi")
--@brief	师徒大厅（MENTORING_GetMentoringOk = 4）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMentoringOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetMentoringOk", "vivsvivsvivivivivivsvbvivivsvivivivivivi")
--@brief	我的师博（MENTORING_GetMyMasterOk = 6）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyMasterOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetMyMasterOk", "vivivsvivivivivivbviivivivsviviiviviiii")
--@brief	我的徒弟（MENTORING_GetMyPupilsOk = 8）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyPupilsOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetMyPupilsOk", "vivivsvivivivivivbvivivivsviviviviviiviviviivi")
--@brief	拜师（MENTORING_BaishiOk = 10）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_BaishiOk, "ProtocolProcessorWndMaster:parse_MENTORING_BaishiOk", "blbb")
--@brief	收徒（MENTORING_ShoutuOk = 12）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_ShoutuOk, "ProtocolProcessorWndMaster:parse_MENTORING_ShoutuOk", "blbb")
--@brief	申请列表（MENTORING_ApplerList = 14）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_ApplerList, "ProtocolProcessorWndMaster:parse_MENTORING_ApplerList", "vivivivsvivivivibvivi")
--@brief	师徒消息（MENTORING_LogList = 15）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_LogList, "ProtocolProcessorWndMaster:parse_MENTORING_LogList", "vsvlvivivivivi")
--@brief	处理拜师/收徒消息（MENTORING_ProcessingOk = 17）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_ProcessingOk, "ProtocolProcessorWndMaster:parse_MENTORING_ProcessingOk", "ii")
--@brief	解除关系（MENTORING_DisassociateOk = 19）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_DisassociateOk, "ProtocolProcessorWndMaster:parse_MENTORING_DisassociateOk", "")
--@brief	师德升级（MENTORING_MoralityUpLevel = 20）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_MoralityUpLevel, "ProtocolProcessorWndMaster:parse_MENTORING_MoralityUpLevel", "i")
--@brief	拜师消息弹窗（MENTORING_BaishiPopMsg = 21）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_BaishiPopMsg, "ProtocolProcessorWndMaster:parse_MENTORING_BaishiPopMsg", "issiiiivi")
--@brief	收徒消息弹窗（MENTORING_ShoutuPopMsg = 22）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_ShoutuPopMsg, "ProtocolProcessorWndMaster:parse_MENTORING_ShoutuPopMsg", "issiiiivi")
--@brief	获取任务信息（MENTORING_GetTaskOk = 24）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetTaskOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetTaskOk", "viviviiiviiivi")
--@brief	获取任务信息（MENTORING_XiaoJingOk = 27）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_XiaoJingOk, "ProtocolProcessorWndMaster:parse_MENTORING_XiaoJingOk", "viviviiiviiivi")
--@brief	获取任务信息（MENTORING_ShouYeOk = 29）
self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_ShouYeOk, "ProtocolProcessorWndMaster:parse_MENTORING_ShouYeOk", "viviviiiviiiivi")

end

--@brief	反注册协议组所有协议
function ProtocolProcessorWndMaster:unregAll()
	self:clearReg()
end

-------------------------------------客户端到服务器协议发送方法模块--------------------------------------
--@brief	获取师徒圣殿（MENTORING_GetTemple = 1）
function ProtocolProcessorWndMaster:send_MENTORING_GetTemple( )
	WZLog("send_MENTORING_GetTemple")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetTemple )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	师徒大厅（MENTORING_GetMentoring = 3）
function ProtocolProcessorWndMaster:send_MENTORING_GetMentoring(id )
	WZLog("send_MENTORING_GetMentoring")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMentoring )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 玩家ID，没有填-1
	SendProtocol(sender,false) --true:showLoading
end

--@brief	我的师博（MENTORING_GetMyMaster = 5）
function ProtocolProcessorWndMaster:send_MENTORING_GetMyMaster( )
	WZLog("send_MENTORING_GetMyMaster")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyMaster )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	我的徒弟（MENTORING_GetMyPupils = 7）
function ProtocolProcessorWndMaster:send_MENTORING_GetMyPupils( )
	WZLog("send_MENTORING_GetMyPupils")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyPupils )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	拜师（MENTORING_Baishi = 9）
function ProtocolProcessorWndMaster:send_MENTORING_Baishi(id, message )
	WZLog("send_MENTORING_Baishi")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_Baishi )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 师博ID
	sender:writeString( message )	-- 独白
	SendProtocol(sender,false) --true:showLoading
end

--@brief	收徒（MENTORING_Shoutu = 11）
function ProtocolProcessorWndMaster:send_MENTORING_Shoutu(id, message )
	WZLog("send_MENTORING_Shoutu")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_Shoutu )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 徒弟ID
	sender:writeString( message )	-- 独白
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取消息列表（MENTORING_GetMentoringMessage = 13）
function ProtocolProcessorWndMaster:send_MENTORING_GetMentoringMessage( )
	WZLog("send_MENTORING_GetMentoringMessage")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMentoringMessage )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	处理拜师/收徒消息（MENTORING_Processing = 16）
function ProtocolProcessorWndMaster:send_MENTORING_Processing(id, action, pType)
	WZLog("send_MENTORING_Processing")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_Processing )
	if sender==nil then WZLog("sender == nil") return end
	pType = pType or 1
	sender:writeInt( id )	-- 玩家ID
	sender:writeInt( action )	-- 0拒绝1接受
	sender:writeInt(pType)	-- 消息类型 1拜师 2收徒 165+
	SendProtocol(sender,false) --true:showLoading
end

--@brief	解除关系（MENTORING_Disassociate = 18）
function ProtocolProcessorWndMaster:send_MENTORING_Disassociate(id, mode )
	WZLog("send_MENTORING_Disassociate")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_Disassociate )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( id )	-- 玩家ID
	sender:writeInt( mode )	-- 0免费,1钻石
	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取任务信息（MENTORING_GetTask = 23）
function ProtocolProcessorWndMaster:send_MENTORING_GetTask( )
	WZLog("send_MENTORING_GetTask")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetTask )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	领取任务奖励（MENTORING_GetReward = 25）
function ProtocolProcessorWndMaster:send_MENTORING_GetReward(taskId )
	WZLog("send_MENTORING_GetReward")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetReward )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt( taskId )	-- 获取奖励的任务Id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	孝敬（MENTORING_XiaoJing = 26）
function ProtocolProcessorWndMaster:send_MENTORING_XiaoJing( )
	WZLog("send_MENTORING_XiaoJing")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_XiaoJing )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	授业（MENTORING_ShouYe = 28）
function ProtocolProcessorWndMaster:send_MENTORING_ShouYe(playerId)
	WZLog("send_MENTORING_ShouYe", playerId)
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_ShouYe )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(playerId)	-- 指定某个玩家授业 165+
	SendProtocol(sender,false) --true:showLoading
end
-------------------------------------服务器到客户端协议回调方法模块--------------------------------------
--@brief	获取师徒圣殿（MENTORING_GetTempleOk = 2）
function ProtocolProcessorWndMaster:parse_MENTORING_GetTempleOk(hasMaster, pupil, moralityLevel, moralityExp, baishiLevel, addVigor, message, num, 
	lastTime, taskfinsh, xjNum, lastXjTime, syids)
	-- hasMaster : 
	-- pupil : 
	-- moralityLevel : 
	-- moralityExp : 
	-- baishiLevel : 
	-- addVigor : 
	-- message : 
	-- num : 165废弃=0 孝敬和授业混在一起
	-- lastTime : 165废弃=0
	-- taskfinsh : 
	-- xjNum : 孝敬次数 165+
	-- lastXjTime : 上次孝敬时间 165+
	-- syids : 给谁授过业了，徒弟id 165+
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetTempleOk",message, taskfinish, pupil)
	if CacheCenter:getMasterInfo() then
		if moralityLevel > CacheCenter:getMasterInfo().moralityLevel then
			WndMaster:setMasterUpgrade(true)
		else
			WndMaster:setMasterUpgrade(nil)
		end
	end
	CacheCenter:setMasterInfo(hasMaster, pupil, moralityLevel, moralityExp, baishiLevel, addVigor, message, num, lastTime, taskfinish, lastXjTime)
end

--@brief	师徒大厅（MENTORING_GetMentoringOk = 4）
function ProtocolProcessorWndMaster:parse_MENTORING_GetMentoringOk(id, title, level, name, fighting, headId, faceId, bodyId, wingId, pet, isOnline, sex, itemId, extraInfo, headColor, bodyColor, vipLevel, moralityLevel, graduationNum, serverId)
	-- id : 玩家ID
	-- title : 称号
	-- level : 级别
	-- name : 名称
	-- fighting : 战力
	-- headId : 头ID
	-- faceId : 脸ID
	-- bodyId : 身ID
	-- wingId : 翅膀ID
	-- pet : 宠物动画
	-- isOnline : true在线
	-- moralityLevel : 师德等级
	-- graduationNum : 出师人数
	-- serverId : 服务器Id
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetMentoringOk",Serialize(VectorToTable(headColor)),Serialize(VectorToTable(name)),Serialize(VectorToTable(headId)))
	WndMasterHall:setMasterHall(VectorToTable(id), VectorToTable(title), VectorToTable(level), VectorToTable(name), VectorToTable(fighting), 
		VectorToTable(headId), VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(wingId), VectorToTable(pet), VectorToTable(isOnline), 
		VectorToTable(sex), VectorToTable(itemId), VectorToTable(extraInfo), VectorToTable(headColor), VectorToTable(bodyColor), VectorToTable(vipLevel), 
		VectorToTable(serverId))
end

--@brief	我的师博（MENTORING_GetMyMasterOk = 6）
function ProtocolProcessorWndMaster:parse_MENTORING_GetMyMasterOk(id, level, name, fighting, headId, faceId, bodyId, wingId, isOnline, loginTime, 
	moralityLevel, sex, itemId, extraInfo, headColor, bodyColor, graduationNum, vipLevel, serverId, mentorSkill, xjTime, mentorSkillReceiveStatus)
	-- id : 玩家ID
	-- level : 级别
	-- name : 名称
	-- fighting : 战力
	-- headId : 头ID
	-- faceId : 脸ID
	-- bodyId : 身ID
	-- wingId : 翅膀ID
	-- isOnline : true在线
	-- loginTime : 玩家登陆时间
	-- serverId : 服务器Id
	-- mentorSkill : 师父设置的技能 165+
	-- xjTime : 我上次孝敬时间 0未孝敬 165+
	-- mentorSkillReceiveStatus : 师门技能领取 0未领取 1已经领取
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetMyMasterOk")
	-- WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetMyMasterOk", 
	-- 	"id = "..Serialize(VectorToTable(id)), 
	-- 	"level = "..Serialize(VectorToTable(level)), 
	-- 	"name = "..Serialize(VectorToTable(name)), 
	-- 	"fighting = "..Serialize(VectorToTable(fighting)), 
	-- 	"headId = "..Serialize(VectorToTable(headId)), 
	-- 	"faceId = "..Serialize(VectorToTable(faceId)), 
	-- 	"bodyId = "..Serialize(VectorToTable(bodyId)), 
	-- 	"wingId = "..Serialize(VectorToTable(wingId)), 
	-- 	"isOnline = "..Serialize(VectorToTable(isOnline)), 
	-- 	"loginTime = "..Serialize(VectorToTable(loginTime)), 
	-- 	"sex = "..Serialize(VectorToTable(sex)),
	-- 	"")
	-- WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetMyMasterOk isOnline = ", type(isOnline), Serialize(VectorToTable(isOnline)))
	-- WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetMyMasterOk loginTime = ", type(loginTime), Serialize(VectorToTable(loginTime)))
	WndMasterMember1:setMyMaster(VectorToTable(id), VectorToTable(level), VectorToTable(name), VectorToTable(fighting), VectorToTable(headId), 
		VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(wingId), VectorToTable(isOnline), VectorToTable(loginTime), moralityLevel, VectorToTable(sex), VectorToTable(itemId), 
		VectorToTable(extraInfo), VectorToTable(headColor), VectorToTable(bodyColor), graduationNum, VectorToTable(vipLevel), VectorToTable(serverId),
		mentorSkill, mentorSkillReceiveStatus)
end

--@brief	我的徒弟（MENTORING_GetMyPupilsOk = 8）
function ProtocolProcessorWndMaster:parse_MENTORING_GetMyPupilsOk(id, level, name, fighting, headId, faceId, bodyId, wingId, isOnline, loginTime, sex, 
	itemId, extraInfo, headColor, bodyColor, vipLevel, masterVigor, pupilVigor, graduationNum, serverId, bagStatus, bagType, mentorSkill, syids)
	-- id : 玩家ID
	-- level : 级别
	-- name : 名称
	-- fighting : 战力
	-- headId : 头ID
	-- faceId : 脸ID
	-- bodyId : 身ID
	-- wingId : 翅膀ID
	-- isOnline : true在线
	-- loginTime : 玩家登陆时间
	-- masterVigor : 师父获取到的活力 
	-- pupilVigor : 徒弟消耗的活力值 
	-- graduationNum : 出师人数 
	-- serverId : 服务器Id
	-- bagStatus : 宝箱状态 -1不能领取 0可以打开  2已经领取了 165+
	-- bagType : 宝箱类型  0没有购买 1、2、3 165+
	-- mentorSkill : 我设置的师门技能id 165+
	-- syids : 给谁授过业了，徒弟id 165+
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetMyPupilsOk")
	-- WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetMyPupilsOk", 
	-- 	"id = "..Serialize(VectorToTable(id)), 
	-- 	"level = "..Serialize(VectorToTable(level)), 
	-- 	"name = "..Serialize(VectorToTable(name)), 
	-- 	"fighting = "..Serialize(VectorToTable(fighting)), 
	-- 	--"headId = "..Serialize(VectorToTable(headId)), 
	-- 	--"faceId = "..Serialize(VectorToTable(faceId)), 
	-- 	--"bodyId = "..Serialize(VectorToTable(bodyId)), 
	-- 	--"wingId = "..Serialize(VectorToTable(wingId)), 
	-- 	"isOnline = "..Serialize(VectorToTable(isOnline)), 
	-- 	"loginTime = "..Serialize(VectorToTable(loginTime)), 
	-- 	--"sex = "..Serialize(VectorToTable(sex))
	-- 	"")
		
	WndMasterMember:setMyPupils(VectorToTable(id), VectorToTable(level), VectorToTable(name), VectorToTable(fighting), VectorToTable(headId), 
		VectorToTable(faceId), VectorToTable(bodyId), VectorToTable(wingId), VectorToTable(isOnline), VectorToTable(loginTime), VectorToTable(sex), 
		VectorToTable(itemId), VectorToTable(extraInfo), VectorToTable(headColor), VectorToTable(bodyColor), VectorToTable(vipLevel), 
		VectorToTable(serverId),VectorToTable(bagStatus),VectorToTable(bagType),VectorToTable(syids),mentorSkill)
end

--@brief	拜师（MENTORING_BaishiOk = 10）
function ProtocolProcessorWndMaster:parse_MENTORING_BaishiOk(result, cdtime, isFull, applied)
	-- result : true成功
	-- cdtime : 正数为解除限制拜师时间；负数为对方解除限收徒时间
	-- isFull : true对方收徒人满了
	-- applied : true已拜过
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_BaishiOk",Serialize(WndMasterTip.m_tChatInfo))
	if applied == true then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO50) 
		return
	end
	if result == true then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO51) 
		--发送私聊
		if WndMasterMember.m_tSendMsg == nil then WndMasterMember.m_tSendMsg = {} end
		local chatInfo = WndMasterTip.m_tChatInfo
		if chatInfo then
			local nType = 1
			if WndMasterTip:valInTable(WndMasterTip.m_tCurID, WndMasterMember.m_tSendMsg) == false then
				local special_str = g_MasterMsgPrivate..nType
				WndChat:sendChat(CHANNEL_WHISPER,chatInfo.chatMsg..special_str,chatInfo.receivePlayerId,chatInfo.receivePlayerName,chatInfo.receivePlayerSex,
					chatInfo.receivePlayerLevel,chatInfo.receivePlayerVipLevel,chatInfo.receivePlayerHead,chatInfo.receivePlayerFace,
					chatInfo.receivePlayerHeadColor, chatInfo.receivePlayerHeadEffectId)
				table.insert(WndMasterMember.m_tSendMsg,WndMasterTip.m_tCurID)
			end
		end
	elseif cdtime > 0 then
		local hours = math.ceil((cdtime - os.time())/3600)
		MsgBoxManager:showTipBox(string.format(LocalStrings.MASTERINFO52,hours)) 
	elseif cdtime < 0 then
		if cdtime == -1 then
			MsgBoxManager:showTipBox(LocalStrings.MASTERINFO57)
		elseif cdtime == -2 then
			MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT93)
		elseif cdtime == -3 then
			MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT94)
		elseif cdtime == -5 then
			MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT98)
		elseif cdtime == -6 then
			MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT96)
		else
			local hours = math.ceil(((0-cdtime) - os.time())/3600)
			MsgBoxManager:showTipBox(string.format(LocalStrings.MASTERINFO53,hours)) 
		end
	elseif isFull == true then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO54) 
	end
end

--@brief	收徒（MENTORING_ShoutuOk = 12）
function ProtocolProcessorWndMaster:parse_MENTORING_ShoutuOk(result, cdtime, hasMaster, applied)
	-- result : true成功
	-- cdtime : 正数为解除限制收徒时间；负数为对方解除限拜师时间
	-- hasMaster : true对方已有师博了
	-- applied : true已收过
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_ShoutuOk",Serialize(WndMasterTip.m_tChatInfo))
	if applied == true then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO45) 
		return
	end
	if result == true then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO46) 
		--发送私聊
		if WndMasterMember.m_tSendMsg == nil then WndMasterMember.m_tSendMsg = {} end
		local chatInfo = WndMasterTip.m_tChatInfo
		if chatInfo then
			local nType = 2
			if WndMasterTip:valInTable(WndMasterTip.m_tCurID, WndMasterMember.m_tSendMsg) == false then
				local special_str = g_MasterMsgPrivate..nType
				WndChat:sendChat(CHANNEL_WHISPER, chatInfo.chatMsg..special_str, chatInfo.receivePlayerId, chatInfo.receivePlayerName, chatInfo.receivePlayerSex,
					chatInfo.receivePlayerLevel, chatInfo.receivePlayerVipLevel, chatInfo.receivePlayerHead, chatInfo.receivePlayerFace,
					chatInfo.receivePlayerHeadColor, chatInfo.receivePlayerHeadEffectId)
				table.insert(WndMasterMember.m_tSendMsg,WndMasterTip.m_tCurID)
			end
		end
	elseif cdtime > 0 then
		local hours = math.ceil((cdtime - os.time())/3600)
		MsgBoxManager:showTipBox(string.format(LocalStrings.MASTERINFO47,hours)) 
	elseif cdtime < 0 then
		if cdtime == -1 then
			MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT97)
		elseif cdtime == -5 then
			MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT98)
		elseif cdtime == -6 then
			MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT99)
		else
			local hours = math.ceil(((0-cdtime) - os.time())/3600)
			MsgBoxManager:showTipBox(string.format(LocalStrings.MASTERINFO48,hours)) 
		end
	elseif isFull == true then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO49) 
	end
end

--@brief	申请列表（MENTORING_ApplerList = 14）
function ProtocolProcessorWndMaster:parse_MENTORING_ApplerList(playerId, headId, faceId, message, sex, headColor, vipLevel, level, applerState, serverId, pType)
	-- playerId : 玩家ID
	-- headId : 头ID
	-- faceId : 脸ID
	-- message : 独白
	-- applerState : true屏蔽申请
	-- serverId : 玩家服务器Id
	-- pType : 申请类型 1拜师 2收徒 165+
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_ApplerList",Serialize(VectorToTable(headColor)))
	WndMasterLog:setMasterLog1(VectorToTable(playerId), VectorToTable(headId), VectorToTable(faceId), VectorToTable(message), VectorToTable(sex), 
		VectorToTable(headColor), VectorToTable(serverId), VectorToTable(pType))
end

--@brief	师徒消息（MENTORING_LogList = 15）
function ProtocolProcessorWndMaster:parse_MENTORING_LogList(message, createTime, playerId, headId, faceId, sex, headColor)
	-- message : 消息
	-- createTime : 创建时间
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_LogList",Serialize(VectorToTable(playerId)),Serialize(VectorToTable(headId)),Serialize(VectorToTable(faceId)),Serialize(VectorToTable(sex)))
	WndMasterLog:setMasterLog2(VectorToTable(message), VectorToTable(createTime), VectorToTable(playerId), VectorToTable(headId), VectorToTable(faceId), VectorToTable(sex), VectorToTable(headColor))
end

--@brief	处理拜师/收徒消息（MENTORING_ProcessingOk = 17）
function ProtocolProcessorWndMaster:parse_MENTORING_ProcessingOk(result, action)
	-- result : 0成功。1对方有师博，2对方徒弟数满了
	-- action : 0拒绝1接受
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_ProcessingOk")
	--在战斗中直接返回
	if GlobalGame.g_bIfInBattle == true then return end    

	if result == 0 then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO55) 
	elseif result == 1 then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO56) 
	elseif result == 2 then
		MsgBoxManager:showTipBox(LocalStrings.MASTERINFO57) 
	elseif result == -1 then
		MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT103)
	else
		MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT77[result-2])
	end
	--修改私聊中的数据
	CacheCenter:dealwithMasterMessageAfterOperate()
	WndChat:dealwithMsgAfterOperate()
	if WndMaster and WndMaster.m_root ~= nil then
		--获得消息列表
		ProtocolProcessorWndMaster:send_MENTORING_GetMentoringMessage()
		--获取师徒信息 
		ProtocolProcessorWndMaster:send_MENTORING_GetTemple()
	end
end

--@brief	解除关系（MENTORING_DisassociateOk = 19）
function ProtocolProcessorWndMaster:parse_MENTORING_DisassociateOk()
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_DisassociateOk")
	MsgBoxManager:showTipBox(LocalStrings.MASTERINFO58) 
	GlobalGame:getGameEventDispathcer():Dispatch(FriendEvent.FriendEvent_RemoveTeachRelation)
end

--@brief	师德升级（MENTORING_MoralityUpLevel = 20）
function ProtocolProcessorWndMaster:parse_MENTORING_MoralityUpLevel(level)
	-- level : 最新等级
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_MoralityUpLevel",level)
	if GlobalGame.g_bIfInBattle == false then
		local tData = {level=level}
		WndMasterTip:showByType(tData,4)
	end
end

--@brief	拜师消息弹窗（MENTORING_BaishiPopMsg = 21）
function ProtocolProcessorWndMaster:parse_MENTORING_BaishiPopMsg(playerId, playerName, message, level, headId, faceId, sex, headColor)
	-- playerId : 徒弟玩家ID
	-- playerName : 徒弟名称
	-- message : 消息
	-- level : 徒弟等级
	-- headId : 徒弟头
	-- faceId : 徒弟脸
	-- sex : 徒弟性别
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_BaishiPopMsg")
    if WindowManager:getTeachShelterLayer() or WndTeachTalk.m_root then return end
	--if GlobalGame.g_bIfInBattle == false then
	--	local tData = {id=playerId,message=message,name=playerName,level=level,headId=headId,faceId=faceId,sex=sex}
	--	WndMasterTip:receivedRequest(tData,2)
	--end
end

--@brief	收徒消息弹窗（MENTORING_ShoutuPopMsg = 22）
function ProtocolProcessorWndMaster:parse_MENTORING_ShoutuPopMsg(playerId, playerName, message, level, headId, faceId, sex, headColor)
	-- playerId : 师傅玩家ID
	-- playerName : 师傅名称
	-- message : 消息
	-- level : 师博等级
	-- headId : 师博头
	-- faceId : 师博脸
	-- sex : 师博性别
end

--@brief	获取任务信息（MENTORING_GetTaskOk = 24）
function ProtocolProcessorWndMaster:parse_MENTORING_GetTaskOk(taskId, progress, giveTaskId, num, lastTeme, alltaskId, xjNum, lastXjTime, syids)
	-- taskId : 任务Id
	-- progress : 任务进度
	-- giveTaskId : 获取奖励的任务Id
	-- num : 孝敬或授业次数
	-- lastTime : 上一次孝敬或授业的时间（秒）
	-- xjNum : 孝敬次数 165+
	-- lastXjTime : 上次孝敬时间 165+
	-- syids : 给谁授过业了，徒弟id 165+
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetTaskOk")
	WndMasterTask:setData( VectorToTable(taskId), VectorToTable(progress), VectorToTable(giveTaskId), num, lastTime, VectorToTable(alltaskId))
	local masterInfo = CacheCenter:getMasterInfo()
	if masterInfo == nil then return end
	masterInfo.lastTime = lastTime
	masterInfo.honorTime = num
end

--@brief	孝敬完成（MENTORING_XiaoJingOk = 27）
function ProtocolProcessorWndMaster:parse_MENTORING_XiaoJingOk(taskId, progress, giveTaskId, num, lastTeme, alltaskId, xjNum, lastXjTime, syids)
	-- taskId : 任务Id
	-- progress : 任务进度
	-- giveTaskId : 获取奖励的任务Id
	-- num : 孝敬或授业次数
	-- lastTime : 上一次孝敬或授业的时间（秒）
	-- itemId : 孝敬奖励Id
	-- itemNum : 孝敬奖励数量
	-- xjNum : 孝敬次数 165+
	-- lastXjTime : 上次孝敬时间 165+
	-- syids : 给谁授过业了，徒弟id 165+
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_XiaoJingOk")
	MsgBoxManager:showTipBox(LocalStrings.MASTERINFO68)
	local masterInfo = CacheCenter:getMasterInfo()
	if masterInfo == nil then return end
	masterInfo.lastTime = lastTime
	masterInfo.honorTime = num
	masterInfo.lastXjTime = lastXjTime
	GlobalGame:getGameEventDispathcer():Dispatch(FriendEvent.FriendEvent_GivePresents)
end

--@brief	授业完成（MENTORING_ShouYeOk = 29）
function ProtocolProcessorWndMaster:parse_MENTORING_ShouYeOk(taskId, progress, giveTaskId, num, lastTeme, alltaskId, xjNum, lastXjTime, playerId, syids)
	-- taskId : 任务Id
	-- progress : 任务进度
	-- giveTaskId : 获取奖励的任务Id
	-- num : 孝敬或授业次数
	-- lastTime : 上一次孝敬或授业的时间（秒）
	-- playerId : 指定某个玩家授业 165+
	-- syids : 给谁授过业了，徒弟id 165+
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_ShouYeOk")
	ProtocolProcessorWndMaster:send_MENTORING_GetTemple() --刷新师德等级和经验
	GlobalGame:getGameEventDispathcer():Dispatch(FriendEvent.FriendEvent_GiveMasterTeach, playerId)
end
-------------------------------------协议错误处理方法模块--------------------------------------

--@brief	获取师徒圣殿（MENTORING_GetTemple = 1）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_GetTemple_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_GetTemple_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetTemple, nflag, sMessage)
end

--@brief	师徒大厅（MENTORING_GetMentoring = 3）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_GetMentoring_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_GetMentoring_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMentoring, nflag, sMessage)
end

--@brief	我的师博（MENTORING_GetMyMaster = 5）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_GetMyMaster_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_GetMyMaster_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyMaster, nflag, sMessage)
end

--@brief	我的徒弟（MENTORING_GetMyPupils = 7）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_GetMyPupils_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_GetMyPupils_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyPupils, nflag, sMessage)
end

--@brief	拜师（MENTORING_Baishi = 9）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_Baishi_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_Baishi_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_Baishi, nflag, sMessage)
end

--@brief	收徒（MENTORING_Shoutu = 11）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_Shoutu_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_Shoutu_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_Shoutu, nflag, sMessage)
end

--@brief	获取消息列表（MENTORING_GetMentoringMessage = 13）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_GetMentoringMessage_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_GetMentoringMessage_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMentoringMessage, nflag, sMessage)
end

--@brief	处理拜师/收徒消息（MENTORING_Processing = 16）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_Processing_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_Processing_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_Processing, nflag, sMessage)
end

--@brief	解除关系（MENTORING_Disassociate = 18）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_Disassociate_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_Disassociate_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_Disassociate, nflag, sMessage)
end

--@brief	获取任务信息（MENTORING_GetTask = 23）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_GetTask_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_GetTask_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetTask, nflag, sMessage)
end

--@brief	领取任务奖励（MENTORING_GetReward = 25）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_GetReward_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:send_MENTORING_GetReward_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetReward, nflag, sMessage)
end

--************************************************************--
function ProtocolProcessorWndMaster:regAll1()
	--@brief	获取我的宝箱信息（MENTORING_GetMyBagInfoOk = 44）
	self:regProtocolCallbackFunction(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyBagInfoOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetMyBagInfoOk", "ii")
	--@brief	获取宝箱详情信息（MENTORING_GetBagInfoOk = 54）
	self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetBagInfoOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetBagInfoOk", "iiiivivi")
	--@brief	领取宝箱（MENTORING_ReceiveBagOk = 52）
	self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_ReceiveBagOk, "ProtocolProcessorWndMaster:parse_MENTORING_ReceiveBagOk", "iivivi")
	--@brief	购买宝箱（MENTORING_BuyBagOk = 50）
	self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_BuyBagOk, "ProtocolProcessorWndMaster:parse_MENTORING_BuyBagOk", "i")
	--@brief	领取师门技能（MENTORING_ReceiveMentorSkillOk = 48）
	self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_ReceiveMentorSkillOk, "ProtocolProcessorWndMaster:parse_MENTORING_ReceiveMentorSkillOk", "ii")
	--@brief	设置师门技能（MENTORING_SetMentorSkillOk = 46）
	self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_SetMentorSkillOk, "ProtocolProcessorWndMaster:parse_MENTORING_SetMentorSkillOk", "ii")

	--181-1加
	--@brief	获取宗门信息（MENTORING_GetZmInfo = 58）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetZmInfo, "ProtocolProcessorWndMaster:send_MENTORING_GetZmInfo_ErrorProcess", "is")
	--@brief	升级宗门等级（MENTORING_UpgradeZm = 60）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_UpgradeZm, "ProtocolProcessorWndMaster:send_MENTORING_UpgradeZm_ErrorProcess", "is")
	--@brief	升级门徒等级（MENTORING_UpgradeTudi = 62）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_UpgradeTudi, "ProtocolProcessorWndMaster:send_MENTORING_UpgradeTudi_ErrorProcess", "is")
	--@brief	获取我的宗门任务列表（MENTORING_GetZmTaskList = 64）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetZmTaskList, "ProtocolProcessorWndMaster:send_MENTORING_GetZmTaskList_ErrorProcess", "is")
	--@brief	刷新宗门任务（MENTORING_FlushZmTask = 70）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_FlushZmTask, "ProtocolProcessorWndMaster:send_MENTORING_FlushZmTask_ErrorProcess", "is")
	--@brief	发布宗门任务（MENTORING_PublishZmTask = 72）错误处理(S->C)
	self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_PublishZmTask, "ProtocolProcessorWndMaster:send_MENTORING_PublishZmTask_ErrorProcess", "is")

	--@brief	获取宗门信息OK（MENTORING_GetZmInfoOk = 59）
	self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetZmInfoOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetZmInfoOk", "iiiii")
	--@brief	升级宗门等级OK（MENTORING_UpgradeZmOk = 61）
	self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_UpgradeZmOk, "ProtocolProcessorWndMaster:parse_MENTORING_UpgradeZmOk", "iii")
	--@brief	升级门徒等级OK（MENTORING_UpgradeTudiOk = 63）
	self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_UpgradeTudiOk, "ProtocolProcessorWndMaster:parse_MENTORING_UpgradeTudiOk", "iii")
	--@brief	获取宗门任务列表OK（MENTORING_GetZmTaskListOk = 65）
	self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetZmTaskListOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetZmTaskListOk", "vivivivi")
	--@brief	获取我的师门任务列表OK【触发24-64协议时会同步推送此协议】（MENTORING_GetShifuZmTaskListOk = 67）
	self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetShifuZmTaskListOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetShifuZmTaskListOk", "vivivivi")
	--@brief	协议号名字（MENTORING_FlushZmTaskOk = 71）
	self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_FlushZmTaskOk, "ProtocolProcessorWndMaster:parse_MENTORING_FlushZmTaskOk", "ivivi")
	--@brief	发布宗门任务OK（MENTORING_PublishZmTaskOk = 73）
	self:regProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_PublishZmTaskOk, "ProtocolProcessorWndMaster:parse_MENTORING_PublishZmTaskOk", "i")

end
function ProtocolProcessorWndMaster:unregAll1()
	self:unregProtocolCallbackFunction(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyBagInfoOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetMyBagInfoOk", "ii")
	self:unregProtocolCallbackFunction(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetBagInfoOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetBagInfoOk", "iiiivivi")
	self:unregProtocolCallbackFunction(Protocol.MAIN_MENTORING, Protocol.MENTORING_ReceiveBagOk, "ProtocolProcessorWndMaster:parse_MENTORING_ReceiveBagOk", "iivivi")
	self:unregProtocolCallbackFunction(Protocol.MAIN_MENTORING, Protocol.MENTORING_BuyBagOk, "ProtocolProcessorWndMaster:parse_MENTORING_BuyBagOk", "i")
	self:unregProtocolCallbackFunction(Protocol.MAIN_MENTORING, Protocol.MENTORING_ReceiveMentorSkillOk, "ProtocolProcessorWndMaster:parse_MENTORING_ReceiveMentorSkillOk", "ii")
	self:unregProtocolCallbackFunction(Protocol.MAIN_MENTORING, Protocol.MENTORING_SetMentorSkillOk, "ProtocolProcessorWndMaster:parse_MENTORING_SetMentorSkillOk", "ii")

	self:unregProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetZmInfo, "ProtocolProcessorWndMaster:send_MENTORING_GetZmInfo_ErrorProcess", "is")
	self:unregProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_UpgradeZm, "ProtocolProcessorWndMaster:send_MENTORING_UpgradeZm_ErrorProcess", "is")
	self:unregProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_UpgradeTudi, "ProtocolProcessorWndMaster:send_MENTORING_UpgradeTudi_ErrorProcess", "is")
	self:unregProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetZmTaskList, "ProtocolProcessorWndMaster:send_MENTORING_GetZmTaskList_ErrorProcess", "is")
	self:unregProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_FlushZmTask, "ProtocolProcessorWndMaster:send_MENTORING_FlushZmTask_ErrorProcess", "is")
	self:unregProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_PublishZmTask, "ProtocolProcessorWndMaster:send_MENTORING_PublishZmTask_ErrorProcess", "is")
	self:unregProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetZmInfoOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetZmInfoOk", "iiiii")
	self:unregProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_UpgradeZmOk, "ProtocolProcessorWndMaster:parse_MENTORING_UpgradeZmOk", "iii")
	self:unregProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_UpgradeTudiOk, "ProtocolProcessorWndMaster:parse_MENTORING_UpgradeTudiOk", "iii")
	self:unregProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetZmTaskListOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetZmTaskListOk", "vivivivi")
	self:unregProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetShifuZmTaskListOk, "ProtocolProcessorWndMaster:parse_MENTORING_GetShifuZmTaskListOk", "vivivivi")
	self:unregProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_FlushZmTaskOk, "ProtocolProcessorWndMaster:parse_MENTORING_FlushZmTaskOk", "ivivi")
	self:unregProtocolCallbackFunction( Protocol.MAIN_MENTORING, Protocol.MENTORING_PublishZmTaskOk, "ProtocolProcessorWndMaster:parse_MENTORING_PublishZmTaskOk", "i")
end
--165版本新加的协议
--@brief	获取我的宝箱信息（MENTORING_GetMyBagInfo = 43）
function ProtocolProcessorWndMaster:send_MENTORING_GetMyBagInfo()
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetMyBagInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	获取我的宝箱信息（MENTORING_GetMyBagInfoOk = 44）
function ProtocolProcessorWndMaster:parse_MENTORING_GetMyBagInfoOk(status, bagType)
	-- status : 宝箱状态 <br> -1不能领取 0可以打开   2今日已经购买了--（目前没用到）
	-- bagType : 宝箱类型 -2师门服务器关闭 -1没有师父不能购买 0是没有购买 1、2、3
	GlobalGame:getGameEventDispathcer():Dispatch(FriendEvent.FriendEvent_TeachBox, bagType)
end
--@brief	获取宝箱详情信息（MENTORING_GetBagInfo = 53）
function ProtocolProcessorWndMaster:send_MENTORING_GetBagInfo(playerId)
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetBagInfo )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(playerId)	-- 宝箱对应的购买的玩家id，如果=0就是自己买的宝箱
	SendProtocol(sender,false) --true:showLoading
end
--@brief	获取宝箱详情信息（MENTORING_GetBagInfoOk = 54）
function ProtocolProcessorWndMaster:parse_MENTORING_GetBagInfoOk(playerId, progress, bagType, status, rewardLevel, rewardStatus)
	-- playerId : 宝箱对应的购买的玩家id，如果=0就是自己买的宝箱
	-- progress : 活跃值
	-- bagType : 宝箱类型
	-- status : 领取状态 -1不可领取 0可领取 1已经领取了
	-- rewardLevel : 奖励等级
	-- rewardStatus : 奖励领取状态
	GlobalGame:getGameEventDispathcer():Dispatch(FriendEvent.FriendEvent_TeachActivityBox, playerId, progress, bagType, status)
end
--@brief	领取宝箱（MENTORING_ReceiveBag = 51）
function ProtocolProcessorWndMaster:send_MENTORING_ReceiveBag(playerId)
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_ReceiveBag )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(playerId)	-- 宝箱对应的徒弟id，如果=0就是自己买的宝箱
	SendProtocol(sender,false) --true:showLoading
end
--@brief	领取宝箱（MENTORING_ReceiveBagOk = 52）
function ProtocolProcessorWndMaster:parse_MENTORING_ReceiveBagOk(playerId, result, itemIds, itemNums)
	-- playerId : 宝箱对应的徒弟id，如果=0就是自己买的宝箱
	-- result : 1 成功 2已经领取过了 3任务未完成不可领取 4师徒关系已经解除了 5领取失败 6今日已经领取够了 7宝箱未购买
	-- itemIds : 获得的物品id
	-- itemNums : 获得的物品数量
	GlobalGame:getGameEventDispathcer():Dispatch(FriendEvent.FriendEvent_GetTeachBox, playerId, result, VectorToTable(itemIds), VectorToTable(itemNums))
end
--@brief	购买宝箱（MENTORING_BuyBag = 49）
function ProtocolProcessorWndMaster:send_MENTORING_BuyBag(bagType)
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_BuyBag )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(bagType)	-- 购买的宝箱类型
	SendProtocol(sender,false) --true:showLoading
end
--@brief	购买宝箱（MENTORING_BuyBagOk = 50）
function ProtocolProcessorWndMaster:parse_MENTORING_BuyBagOk(result)
	-- result : 1成功 2已经购买过了 3你还没有师父 4物品不足 5失败
	MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT74[result])
	if result == 1 then
		WindowManager:removeWindow(WndMasterBuyBox.m_root, WndMasterBuyBox, true)
	end
end
--@brief	领取师门技能（MENTORING_ReceiveMentorSkill = 47）
function ProtocolProcessorWndMaster:send_MENTORING_ReceiveMentorSkill()
	WZLog("send_MENTORING_ReceiveMentorSkill")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_ReceiveMentorSkill )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end
--@brief	领取师门技能（MENTORING_ReceiveMentorSkillOk = 48）
function ProtocolProcessorWndMaster:parse_MENTORING_ReceiveMentorSkillOk(skillId, result)
	-- skillId : 领取的技能id
	-- result : 1成功 2已经被逐出师门了 3已经领取过了 4失败
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_ReceiveMentorSkillOk")
	MsgBoxManager:showTipBox(LocalStrings.OPTIMIZE_TEXT78[result])
end
--@brief	设置师门技能（MENTORING_SetMentorSkill = 45）
function ProtocolProcessorWndMaster:send_MENTORING_SetMentorSkill(skillId)
	WZLog("send_MENTORING_SetMentorSkill")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_SetMentorSkill )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(skillId)	-- 设置的技能id
	SendProtocol(sender,false) --true:showLoading
end
--@brief	设置师门技能（MENTORING_SetMentorSkillOk = 46）
function ProtocolProcessorWndMaster:parse_MENTORING_SetMentorSkillOk(skillId, result)
	-- skillId : 设置的技能id
	-- result : 1成功 2失败
	GlobalGame:getGameEventDispathcer():Dispatch(FriendEvent.FriendEvent_SetMasterSkill, skillId, result)
end


-- send

--@brief	获取宗门信息（MENTORING_GetZmInfo = 58）
function ProtocolProcessorWndMaster:send_MENTORING_GetZmInfo()
	WZLog("send_MENTORING_GetZmInfo")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetZmInfo )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	升级宗门等级（MENTORING_UpgradeZm = 60）
function ProtocolProcessorWndMaster:send_MENTORING_UpgradeZm()
	WZLog("send_MENTORING_UpgradeZm")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_UpgradeZm )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	升级门徒等级（MENTORING_UpgradeTudi = 62）
function ProtocolProcessorWndMaster:send_MENTORING_UpgradeTudi()
	WZLog("send_MENTORING_UpgradeTudi")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_UpgradeTudi )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	获取我的宗门任务列表（MENTORING_GetZmTaskList = 64）
function ProtocolProcessorWndMaster:send_MENTORING_GetZmTaskList()
	WZLog("send_MENTORING_GetZmTaskList")
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_GetZmTaskList )
	if sender==nil then WZLog("sender == nil") return end

	SendProtocol(sender,false) --true:showLoading
end

--@brief	刷新宗门任务（MENTORING_FlushZmTask = 70）
function ProtocolProcessorWndMaster:send_MENTORING_FlushZmTask(lockIdList)
	WZLog("send_MENTORING_FlushZmTask", Serialize(VectorToTable(lockIdList)))
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_FlushZmTask )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInts(lockIdList)	-- 锁住的不刷新的任务id
	SendProtocol(sender,false) --true:showLoading
end

--@brief	发布宗门任务（MENTORING_PublishZmTask = 72）
function ProtocolProcessorWndMaster:send_MENTORING_PublishZmTask(dayNum, taskIds)
	WZLog("send_MENTORING_PublishZmTask", dayNum, Serialize(taskIds))
	local sender = Protocol:getSender( Protocol.MAIN_MENTORING, Protocol.MENTORING_PublishZmTask )
	if sender==nil then WZLog("sender == nil") return end

	sender:writeInt(dayNum)	-- 要刷新第几天的任务【0=今天|1=明天|以此类推】
	sender:writeInts(taskIds)	-- 任务ID
	SendProtocol(sender,false) --true:showLoading
end

-- parse

--@brief	获取宗门信息OK（MENTORING_GetZmInfoOk = 59）
function ProtocolProcessorWndMaster:parse_MENTORING_GetZmInfoOk(myZmLevel, myZmExp, shifuZmLevel, tudiLevel, tudiExp)
	-- myZmLevel : 我的宗门等级
	-- myZmExp : 我的宗门经验
	-- shifuZmLevel : 师门等级
	-- tudiLevel : 我在师门里的门徒等级
	-- tudiExp : 我在师门里的宗门贡献
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetZmInfoOk", myZmLevel, myZmExp, shifuZmLevel, tudiLevel, tudiExp)
	WndFactionMain:getZmInfoOk(myZmLevel, myZmExp, shifuZmLevel, tudiLevel, tudiExp)
end

--@brief	升级宗门等级OK（MENTORING_UpgradeZmOk = 61）
function ProtocolProcessorWndMaster:parse_MENTORING_UpgradeZmOk(result, myZmLevel, myZmExp)
	-- result : 升级结果【0=成功|1=经验道具不足|2=已满级】
	-- myZmLevel : 我的宗门等级【result=0时，此字段才有意义】
	-- myZmExp : 我的宗门经验【result=0时，此字段才有意义】
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_UpgradeZmOk", result, myZmLevel, myZmExp)
	WndFactionMain:getUpgradeZmOk(result, myZmLevel, myZmExp)
end

--@brief	升级门徒等级OK（MENTORING_UpgradeTudiOk = 63）
function ProtocolProcessorWndMaster:parse_MENTORING_UpgradeTudiOk(result, tudiLevel, tudiExp)
	-- result : 升级结果【0=成功|1=经验道具不足|2=已满级】
	-- tudiLevel : 我在师门里的门徒等级
	-- tudiExp : 我在师门里的宗门贡献
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_UpgradeTudiOk", result, tudiLevel, tudiExp)
	WndFactionMain:getUpgradeTudiOk(result, tudiLevel, tudiExp)
end

--@brief	获取宗门任务列表OK（MENTORING_GetZmTaskListOk = 65）
function ProtocolProcessorWndMaster:parse_MENTORING_GetZmTaskListOk(taskIds, taskTarget, taskProgress, taskType)
	-- taskIds : 任务ID
	-- taskTarget : 任务目标
	-- taskProgress : 任务进度
	-- taskType : 任务类型【-1=待上架任务|0=今日任务|1=明日任务|2=后日任务|...|X=第N天任务[X<=7]】
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetZmTaskListOk",
		"\n taskIds =",TableToString(VectorToTable(taskIds)), 
		"\n taskTarget =",TableToString(VectorToTable(taskTarget)), 
		"\n taskProgress =",TableToString(VectorToTable(taskProgress)), 
		"\n taskType =",TableToString(VectorToTable(taskType)))
	WndFactionTask:getZmTaskListOk(VectorToTable(taskIds), VectorToTable(taskTarget), VectorToTable(taskProgress), VectorToTable(taskType))
end

--@brief	获取我的师门任务列表OK【触发24-64协议时会同步推送此协议】（MENTORING_GetShifuZmTaskListOk = 67）
function ProtocolProcessorWndMaster:parse_MENTORING_GetShifuZmTaskListOk(taskIds, taskTarget, taskProgress, taskType)
	-- taskIds : 任务ID
	-- taskTarget : 任务目标
	-- taskProgress : 任务进度
	-- taskType : 任务类型【-1=待上架任务|0=今日任务|1=明日任务|2=后日任务|...|X=第N天任务[X<=7]】
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetShifuZmTaskListOk",
		"\n taskIds =",TableToString(VectorToTable(taskIds)), 
		"\n taskTarget =",TableToString(VectorToTable(taskTarget)), 
		"\n taskProgress =",TableToString(VectorToTable(taskProgress)), 
		"\n taskType =",TableToString(VectorToTable(taskType)))
	WndFactionTask:getShifuZmTaskListOk(VectorToTable(taskIds), VectorToTable(taskTarget), VectorToTable(taskProgress), VectorToTable(taskType))
end

--@brief	刷新宗门任务OK（MENTORING_FlushZmTaskOk = 71）
function ProtocolProcessorWndMaster:parse_MENTORING_FlushZmTaskOk(result, myZmTaskIds, myZmTaskTarget)
	-- result : 刷新结果【0=成功|1=dayNum参数错误(如：今天的任务未发布不能刷新明天的任务)|2=货币不足|3=锁定任务已过期】
	-- myZmTaskIds : 我的宗门任务ID
	-- myZmTaskTarget : 任务目标
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_FlushZmTaskOk", result, Serialize(VectorToTable(myZmTaskIds)), Serialize(VectorToTable(myZmTaskTarget)))
	WndFactionTask:getFlushZmTaskOk(result, VectorToTable(myZmTaskIds), VectorToTable(myZmTaskTarget))
end

--@brief	发布宗门任务OK（MENTORING_PublishZmTaskOk = 73）
function ProtocolProcessorWndMaster:parse_MENTORING_PublishZmTaskOk(result)
	-- result : 发布结果【0=成功|1=失败-全部任务都发布了|2=失败-选定的任务夸天过期】
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_PublishZmTaskOk")
	WndFactionTask:PublishZmTaskOk(result)
end


-- error

--@brief	获取宗门信息（MENTORING_GetZmInfo = 58）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_GetZmInfo_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetZmInfo_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetZmInfo, nflag, sMessage)
end

--@brief	升级宗门等级（MENTORING_UpgradeZm = 60）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_UpgradeZm_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_UpgradeZm_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_UpgradeZm, nflag, sMessage)
end

--@brief	升级门徒等级（MENTORING_UpgradeTudi = 62）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_UpgradeTudi_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_UpgradeTudi_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_UpgradeTudi, nflag, sMessage)
end

--@brief	获取我的宗门任务列表（MENTORING_GetZmTaskList = 64）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_GetZmTaskList_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_GetZmTaskList_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_GetZmTaskList, nflag, sMessage)
end

--@brief	刷新宗门任务（MENTORING_FlushZmTask = 70）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_FlushZmTask_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_FlushZmTask_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_FlushZmTask, nflag, sMessage)
end

--@brief	发布宗门任务（MENTORING_PublishZmTask = 72）错误处理函数(S->C)
--@param	nFlag:标志位
--@param	sMessage:错误信息
--@note	在此对协议错误进行相应处理
function ProtocolProcessorWndMaster:send_MENTORING_PublishZmTask_ErrorProcess(nFlag, sMessage)
	WZLog("ProtocolProcessorWndMaster:parse_MENTORING_PublishZmTask_ErrorProcess")
	ProtocolErrorProcessor:errorProcess(Protocol.MAIN_MENTORING, Protocol.MENTORING_PublishZmTask, nflag, sMessage)
end
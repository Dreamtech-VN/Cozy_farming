--CellLeagueRecruit.lua
--@brief	CellLeagueRecruit的UI模块
--@date		2016/06/14
--@author	zsq
--@note		审批Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLeagueRecruit:onEnter(element)
	self.m_root = element
end

function CellLeagueRecruit:onEnterTransitionDidFinish(element)
	GetElement(self.m_root,"txtFight1",WZUILabelTTF):setText(LocalStrings.COMBAT..":")
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLeagueRecruit:onExit(element)
	self:_unInit()
end

function CellLeagueRecruit:setData(tData)
	self.m_tData = tData
    self:update()
end

function CellLeagueRecruit:onCheck(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if WndLeagueRecruit.m_tID == nil then WndLeagueRecruit.m_tID = {} end
	local checkBox = GetElement(self.m_root,"checkBox",WZUICheckBox)
	local checked = checkBox:getCheckIndex()
	if checked == 1 then
		checkBox:setCheckIndex(0)
		for i=1,#WndLeagueRecruit.m_tID do
			if WndLeagueRecruit.m_tID[i] == self.m_tData.playerId then
				table.remove(WndLeagueRecruit.m_tID,i)
			end
		end
	elseif checked == 0 then
		--战队人数加审批人数大于4个，弹出提示，不能选中
		if #WndLeagueTeamDetail.m_tDataList + #WndLeagueRecruit.m_tID >= 4 then
			MsgBoxManager:showTipBox(LocalStrings.LEAGUE56)
			return
		end
		checkBox:setCheckIndex(1)
		table.insert(WndLeagueRecruit.m_tID,self.m_tData.playerId)
	end
	GetElement(WndLeagueRecruit.m_root,"ttfNumber",WZUILabelTTF):setText((#WndLeagueTeamDetail.m_tDataList + #WndLeagueRecruit.m_tID).."/4")
	WZLog("CellLeagueRecruit:onCheck",checkBox:getCheckIndex(),Serialize(WndLeagueRecruit.m_tID))
end

--@brief	点击头像
function CellLeagueRecruit:onHead()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCheckOther:show(self.m_tData.playerId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellLeagueRecruit:update()
	WZLog("CellLeagueRecruit:update",self.m_tData.faceId,self.m_tData.headId,self.m_tData.headColor)
	--头像
	local conHead = GetElement(self.m_root,"conHead_Cell",WZUIContainer)
	local imgHead = CellHead:show(conHead,self.m_tData.headId,self.m_tData.faceId,self.m_tData.sex,false,GlobalMethod:ccp(0.5,0.29),self.m_tData.vip, self.m_tData.headColor)
	imgHead:setRelativePosition(GlobalMethod:ccp(0.52,0.5))
	imgHead:setScale(1.2)	
	--名字
	GetElement(self.m_root,"txtName_CellLeagueRecruit",WZUILabelTTF):setText(self.m_tData.playerName)
	--等级
	--GetElement(self.m_root,"txtLv_CellLeagueRecruit",WZUILabelAtlasFont):setText(self.m_tData.level)
	GetElement(self.m_root,"txtLv1_CellLeagueRecruit",WZUILabelTTF):setText(self.m_tData.level)
	--战斗力
	GetElement(self.m_root,"txtFight_CellLeagueRecruit",WZUILabelTTF):setText(self.m_tData.fight)
	--退出次数
	GetElement(self.m_root,"txtExit_CellLeagueRecruit",WZUILabelTTF):setText(string.format(LocalStrings.LEAGUE_LEAVETEAM_TIMES,self.m_tData.outTeamNum))
end




-------------------------------------私有方法模块End----------------------------------------

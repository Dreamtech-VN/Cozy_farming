--CellMasterInfo1.lua
--@brief	CellMasterInfo1的UI模块
--@date		2015/05/29
--@author	zsq
--@note		类型1师徒消息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellMasterInfo1:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellMasterInfo1:onExit(element)
	self:_unInit()
end

--@brief	查看人物信息
function CellMasterInfo1:onCheck(element)
	WZLog("CellMasterInfo1:onCheck",self.m_tData.playerId)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)  --点击音效
	WndCheckOther:show(self.m_tData.playerId)
end

--@brief	接受请求
function CellMasterInfo1:onAccept(element)
	if not self.m_tData then
		return
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)  --点击音效
	g_nOperatePlayerId = tonumber(self.m_tData.playerId)
	ProtocolProcessorWndMaster:send_MENTORING_Processing(tonumber(self.m_tData.playerId), 1, self.m_tData.pType)
end

--@brief	拒绝请求
function CellMasterInfo1:onRefuse(element)
	if not self.m_tData then
		return
	end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)  --点击音效
	g_nOperatePlayerId = tonumber(self.m_tData.playerId)
	ProtocolProcessorWndMaster:send_MENTORING_Processing(tonumber(self.m_tData.playerId), 0, self.m_tData.pType)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置消息
function CellMasterInfo1:setMasterInfo1(tData)
	self.m_tData = tData
	local text = tData.message
	local textTable = json.decode(text)
	WZLog("CellMasterInfo1:setMasterInfo1",text,Serialize(textTable))

	if textTable.lv ~= nil then
		GetElement(self.m_root,"ttfLevel_CellMasterInfo1",WZUILabelTTF):setText(textTable.lv)
	end
	if textTable.name ~= nil then
		local ttfName = GetElement(self.m_root,"ttfName_CellMasterInfo1",WZUILabelTTF)
		ttfName:setText(textTable.name)
		if tData.serverId and tData.serverId ~= CacheCenter:getPlayerInfo().serverId then 
			GetElement(self.m_root, "imgKuafu_CellMasterInfo1", WZUIImage):setVisible(true)
			ttfName:setRelativePosition(GlobalMethod:ccp(0.217, 0.61))
		end
	end
	if textTable.info ~= nil then
		GetElement(self.m_root,"ttfInfo_CellMasterInfo1",WZUILabelTTF):setText(textTable.info)
	end
	if textTable.date ~= nil then
		GetElement(self.m_root,"ttfTime_CellMasterInfo1",WZUILabelTTF):setText(textTable.date)
	end

	CellHead:show(GetElement(self.m_root,"conHead_CellMasterInfo1",WZUIContainer),tData.headId,tData.faceId,tData.sex,nil,nil,nil,tData.headColor)
end

function CellMasterInfo1:onClickHead()
	WZLog("CellMasterInfo1:onClickHead")

end

--@brief   玩家人物
function CellMasterInfo1:_addHead(headId,faceId,sex)
	WZLog("CellMasterInfo1:_addHead",headId,faceId,sex)
	local sex = sex or 0--玩家性别
	local tEquip = {}
	table.insert(tEquip,headId)
	table.insert(tEquip,faceId)

	local conPlayerAni = GetElement(self.m_root,"conHead_CellMasterInfo1",WZUIContainer)
	conPlayerAni:removeChildByTag(50,true)

	local conPlayer = CreatePlayerFigure(sex, tEquip, "avatar")
	conPlayer:getAnimNode():setTag(50)
	conPlayerAni:addChild(conPlayer:getAnimNode())
	conPlayer:getAnimNode():setTouchEnable(false)
	conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.35,-0.1))
	conPlayer:getAnimNode():setScale(0.5)
end


-------------------------------------私有方法模块End----------------------------------------

------------------------------------------------语言适配Begin----------------------------------
function CellMasterInfo1:_adaptLanguage_en(  )
	local ttfInfo = GetElement(self.m_root,"ttfInfo_CellMasterInfo1",WZUILabelTTF)
	ttfInfo:setScale(0.8)
	ttfInfo:setMaxLength(300)
end

function CellMasterInfo1:_adaptLanguage_es(  )
	local ttfInfo = GetElement(self.m_root,"ttfInfo_CellMasterInfo1",WZUILabelTTF)
	ttfInfo:setScale(0.8)
	ttfInfo:setMaxLength(300)
end

function CellMasterInfo1:_adaptLanguage_pt(  )
	local ttfInfo = GetElement(self.m_root,"ttfInfo_CellMasterInfo1",WZUILabelTTF)
	ttfInfo:setScale(0.8)
	ttfInfo:setMaxLength(300)
end

function CellMasterInfo1:_adaptLanguage_th(  )
	WZLog("--CellMasterInfo1:_adaptLanguage_en--")
	GetElement(self.m_root,"ttfInfo_CellMasterInfo1",WZUILabelTTF):setMaxLength(300)
end

function CellMasterInfo1:_adaptLanguage_vn(  )
	local ttfInfo = GetElement(self.m_root,"ttfInfo_CellMasterInfo1",WZUILabelTTF)
	ttfInfo:setScale(0.8)
	ttfInfo:setMaxLength(300)
end
------------------------------------------------语言适配End-------------------------------------
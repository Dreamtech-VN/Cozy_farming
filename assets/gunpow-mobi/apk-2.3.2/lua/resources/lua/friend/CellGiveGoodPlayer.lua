--CellGiveGoodPlayer.lua
--@brief	CellGiveGoodPlayer的UI模块
--@date		2020/07/02
--@author	XTX
--@note		点赞玩家界面Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGiveGoodPlayer:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGiveGoodPlayer:onExit(element)
	self:_unInit()
end

--@brief 	点击空间按钮回调
function CellGiveGoodPlayer:onCheckInfo(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local playerInfo = CacheCenter:getPlayerInfo()
    if GlobalMethod:crossServiceOpen() == 0 and self.m_tData.serverId ~= playerInfo.serverId then
        MsgBoxManager:showTipBox(LocalStrings.CROSS_SERVICE_TIP2)
        return
    end
    WndCheckOther:show(self.m_tData.playerId)
end

--@brief 	加载
function CellGiveGoodPlayer:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellGiveGoodPlayer")
    self.m_root:addChild(celElement)

    self.m_bIsLoad = true
    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellGiveGoodPlayer:_update()
	-- body
	local txtPlayerName = GetElement(self.m_root, "txtPlayerName_WndGiveGoodPlayer", WZUILabelTTF)
	if txtPlayerName then 
		txtPlayerName:setText(self.m_tData.playerName)
	end
	SetQQHallBlueIcon(self.m_root, self.m_tData.qqHallData, {"imgBluePri_CellGiveGoodPlayer", "imgBlueYear_CellGiveGoodPlayer"}, {"txtPlayerName_WndGiveGoodPlayer"}, {WZUILabelTTF}, 0.075)
	--玩家头像
	local conHead = GetElement(self.m_root, "conHead_CellGiveGoodPlayer", WZUIContainer)
	local cellElement =  CellHead:show(conHead, self.m_tData.headId, self.m_tData.faceId, self.m_tData.sex, false, nil, self.m_tData.vipLevel, self.m_tData.headColor, nil, nil, nil, nil, self.m_tData.headEffectId)
end




-------------------------------------私有方法模块End----------------------------------------

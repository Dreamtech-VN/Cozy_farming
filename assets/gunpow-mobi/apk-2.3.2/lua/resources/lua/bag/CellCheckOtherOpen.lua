--CellCheckOtherOpen.lua
--@brief	CellCheckOtherOpen的UI模块
--@date		2022/11/01
--@author	yrd
--@note		玩家信息展开栏


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCheckOtherOpen:onEnter(element)
	self.m_root = element
	self:update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCheckOtherOpen:onExit(element)
	self:_unInit()
end

--@brief	刷新
function CellCheckOtherOpen:update()
	local imgArrow = GetElement(self.m_root,"imgArrow_CellCheckOtherOpen",WZUIImage)
	local txtExpand = GetElement(self.m_root,"txtExpand_CellCheckOtherOpen",WZUILabelTTF)

	local bExpand = true
	if WndCheckOther.m_nPlayerId == CacheCenter:getPlayerInfo().id then
		local data = WZDataFile:getInstance():getUserData()
		if data then
			local expandStatus = data:getStringValue("PlayerSpace", "expand")
			if expandStatus == "0" then
				bExpand = false
			end
		end
	else
		bExpand = WndCheckOther.m_bOtherPlayerExpand
	end
	if bExpand == false then
		imgArrow:setFlipY(false)
		txtExpand:setText(LocalStrings.CHECK_OTHER_EXPAND[2])
	else
		imgArrow:setFlipY(true)
		txtExpand:setText(LocalStrings.CHECK_OTHER_EXPAND[1])
	end


end

--@brief	点击展开按钮
function CellCheckOtherOpen:onClickOpen(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if WndCheckOther.m_nPlayerId == CacheCenter:getPlayerInfo().id then
		local data = WZDataFile:getInstance():getUserData()
		if data then
			local changeExpand
			local expandStatus = data:getStringValue("PlayerSpace", "expand")
			if expandStatus == "0" then
				changeExpand = "1"
			else
				changeExpand = "0"
			end
		    data:setStringValue("PlayerSpace", "expand", changeExpand)
		    data:flush()
		end
	else
		WndCheckOther.m_bOtherPlayerExpand = not WndCheckOther.m_bOtherPlayerExpand
	end

	--刷新
	WndCheckOther.m_bIsLoadCell = false
	WndCheckOther:updateInfo()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

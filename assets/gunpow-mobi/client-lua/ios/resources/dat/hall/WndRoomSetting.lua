--WndRoomSetting.lua
--@brief	WndRoomSetting的UI模块
--@date		2015/06/03
--@author	qixiang_xie
--@note		竞技房间设置


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndRoomSetting:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	
end

--@brief  动画播放结束
function WndRoomSetting:onEnterTransitionDidFinish()
	WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndRoomSetting:onExit(element)
	self:_unInit()
end

--@brief   sortById
function sortById(a,b)
	if a < b then
		return true
	else
		return false
	end
end 

--@brief  展示房间信息
function WndRoomSetting:updateRoomInfo()
	WZLog("WndRoomSetting:updateRoomInfo",self.m_iStartMode)
	if self.m_root == nil then
		return
	end
	
	local editRoomName = WZUIEditBox:luaTo(self.m_root:getChildElement("editRoomName_WndRoomSetting"))
	local editRoomPass = WZUIEditBox:luaTo(self.m_root:getChildElement("editRoomPass_WndRoomSetting"))

	if self.m_sRoomName ~= nil then
		editRoomName:setText(self.m_sRoomName)
	else
		editRoomName:setPlaceHolder(LocalStrings.ROOM_NAME_RANDOM[1])
	end

	if self.m_sRoomPass ~= "-1" and self.m_sRoomPass ~= "" then
		editRoomPass:setText(self.m_sRoomPass)
	else
		editRoomPass:setText(LocalStrings.NO_PASSWORD)
	end

	local tableMapList = WZUITableContainer:luaTo(self.m_root:getChildElement("tableMapList_WndRoomSetting"))
	tableMapList:cleanTable()
    local mapName = LocalStrings.RANDOM_MAP
    self.m_iMapChannel = tonumber(self.m_iMapChannel)
    self.m_tData = nil
	if self.m_tData == nil then
    	self.m_tData = {}
    	if self.m_iStartMode == 1 or self.m_iStartMode == 2 then
    		for k,v in pairs(GDatatab_battle_map) do
		    	table.insert(self.m_tData,v.id)
            end
        else
        	for k,v in pairs(GDatatab_battle_map) do
		    	if v.channel == self.m_iMapChannel or v.name == mapName then
		    		table.insert(self.m_tData,v.id)
		    	end
            end
    	end
    	
        table.sort(self.m_tData,sortById)
    end

    for i=1,#self.m_tData do
		local mKey = self.m_tData[i]
		local element = self:_createAMapCell(mKey)
		if i == 1 then
			self.m_tDefaultCell = element
		end
		element:setTag(i-1)
		GetElement(element,"btnCell_WndRoomSetting"):setTag(mKey)
	    tableMapList:setCellElement(element)
	end
end

--@brief 点击编辑房间名字输入框回调
function WndRoomSetting:onEditBeginRName(element)
	WZLog("WndRoomSetting:onEditBegin")
	element:setText("")
end

--@brief 结束编辑回调
function WndRoomSetting:onEditEndRName(element)
	WZLog("WndRoomSetting:onEditEnd --------------",element)
	element = WZUIEditBox:luaTo(element)
	if element:getText() == "" or string.len(element:getText()) == 0 then element:setText(self.m_sRoomName) end
    local tempStr = CheckYellow(element:getText())
	element:setText(tempStr)
end

--@brief 点击编辑房间名字输入框回调
function WndRoomSetting:onEditBeginRP(element)
	WZLog("WndRoomSetting:onEditBegin")
	element = WZUIEditBox:luaTo(element)
	element:setText("")
end

--@brief 结束编辑回调
function WndRoomSetting:onEditEndRP(element)
	WZLog("WndRoomSetting:onEditEnd --------------",element)
	element = WZUIEditBox:luaTo(element)
	if element:getText() == "" or string.len(element:getText()) == 0 then element:setText(LocalStrings.NO_PASSWORD) return end
	
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------回调方法模块Begin----------------------------------------

--@brief  保存房间设置
function WndRoomSetting:onClickSure(element)
	WZLog("WndRoomSetting:onClickSure")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tBack and self.m_tBack[1] and self.m_tBack[2] then
		self.m_sRoomName =WZUIEditBox:luaTo(self.m_root:getChildElement("editRoomName_WndRoomSetting")):getText()
		self.m_sRoomPass =WZUIEditBox:luaTo(self.m_root:getChildElement("editRoomPass_WndRoomSetting")):getText()
		
		if self.m_sRoomPass == "" or self.m_sRoomPass == LocalStrings.NO_PASSWORD then
			self.m_sRoomPass = "-1"
		else
			local passLength = ChineseStringLen(self.m_sRoomPass)
			local matchPass = string.match(self.m_sRoomPass,"%w+")
			local matchLength =0

			if matchPass ~= nil then
				matchLength = ChineseStringLen(matchPass)
			end
			if passLength ~= matchLength then
				MsgBoxManager:showTipBox(LocalStrings.ROOM_PASS_ERROR)
				return
			elseif matchLength > 8 then
				MsgBoxManager:showTipBox(LocalStrings.ROOM_PASS_ERROR2)
				return
			end
		end
		if self.m_sRoomName == "" then
			self.m_sRoomName = LocalStrings.ROOM_NAME_RANDOM[1]
		else
			local isSystem = false
			for i,v in ipairs(LocalStrings.ROOM_NAME_RANDOM) do
				if v == self.m_sRoomName then
					isSystem = true
					break
				end
			end

			if isSystem== false then
				local roomName = string.match(self.m_sRoomName," ")
				local passLength = ChineseStringLen(self.m_sRoomName)
				local roomNameLen = 0
				if roomName ~= nil then
					roomNameLen = ChineseStringLen(roomName)
				end
				if roomNameLen > 0 then
					MsgBoxManager:showTipBox(LocalStrings.ROOM_NAME_ERROR2)
					return
				elseif passLength > 8 then
					MsgBoxManager:showTipBox(LocalStrings.ROOM_NAME_ERROR)
					return
				end
			end
		end
		
		self.m_tBack[2](self.m_tBack[1],self.m_sRoomName,self.m_sRoomPass,self.m_iRoomMap,self.m_iStartMode,self.m_iBattleMode)
	end
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief  关闭房间设置UI
function WndRoomSetting:onCloseClick(element)
	WZLog("WndRoomSetting:onCloseClick")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief  点击地图
function WndRoomSetting:onClickMap(element)
	WZLog("WndRoomSetting:onClickMap")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_iStartMode == 1 then
		MsgBoxManager:showTipBox(LocalStrings.SELECT_MAP_TIPS)
		return
	end
	local parent = element:getParentElement()        
	
	self.m_iRoomMap = element:getTag()
	self.m_tSelectMap:getChildElement("imgSelect_WndRoomSetting"):setVisible(false)
	self.m_tSelectMap:getChildElement("imgMapHightL_WndRoomSetting"):setVisible(false)
	self.m_tSelectMap = parent

	local imgSel  = WZUIImage:luaTo(parent:getChildElement("imgSelect_WndRoomSetting"))
	imgSel:setVisible(true)
	local imgMapHightL  = WZUI9Image:luaTo(parent:getChildElement("imgMapHightL_WndRoomSetting"))
	imgMapHightL:setVisible(true)
end

-------------------------------------回调方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	创建一个地图列表项
--@return	#1:创建出来的cell引用
function WndRoomSetting:_createAMapCell(mKey)
	WZLog("WndSelectMap:_createAMapCell")
    local mapName = GDatatab_battle_map["id_"..mKey].animationIndexCode
	mapName = RESOURCE_MAP_TITLE_PATH..mapName..".png"
    
	local mapImage = GDatatab_battle_map["id_"..mKey].icon
	mapImage = RESOURCE_MAP_PATH..mapImage
	
	local element = WZUISystem:getInstance():createElement("conMap_WndRoomSetting")
	WZUIImage:luaTo(GetElement(element,"imgMap_WndRoomSetting")):setFile(mapImage)
	WZUIImage:luaTo(GetElement(element,"imgMapTitle_WndRoomSetting")):setFile(mapName)
	if mKey == self.m_iRoomMap then
		self.m_fImageMap = WZUIImage:luaTo(GetElement(element,"imgSelect_WndRoomSetting"))
		self.m_fImageMap:setVisible(true)
		WZUI9Image:luaTo(GetElement(element,"imgMapHightL_WndRoomSetting")):setVisible(true)
		self.m_tSelectMap = element
	else
		WZUIImage:luaTo(GetElement(element,"imgSelect_WndRoomSetting")):setVisible(false)
		WZUI9Image:luaTo(GetElement(element,"imgMapHightL_WndRoomSetting")):setVisible(false)
	end
	element:setVisible(true)
	if ProjConfig.LANGUAGE == "pt" then
		WZUIImage:luaTo(GetElement(element,"imgMapTitle_WndRoomSetting")):setScale(0.6)
	end
	return element
end




-------------------------------------私有方法模块End----------------------------------------
---------------------------------------------语言适配Begin----------------------------------
function WndRoomSetting:_adaptLanguage_vn(  )
end

function WndRoomSetting:_adaptLanguage_es(  )
	local txtRoomName = GetElement(self.m_root,"txtRoomName_WndRoomSetting",WZUILabelTTF)
	txtRoomName:setScale(0.7)
	txtRoomName:setRelativePosition(GlobalMethod:ccp(0.200353,0.84404))
	local txtRommPass = GetElement(self.m_root,"txtRommPass_WndRoomSetting",WZUILabelTTF)
	txtRommPass:setScale(0.7)
	txtRommPass:setRelativePosition(GlobalMethod:ccp(0.200353,0.289318))
end

---------------------------------------------语言适配End-----------------------------------
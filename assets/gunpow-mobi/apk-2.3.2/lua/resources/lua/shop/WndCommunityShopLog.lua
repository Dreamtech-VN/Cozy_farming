--WndCommunityShopLog.lua
--@brief	WndCommunityShopLog的UI模块
--@date		2017/02/16
--@author	qixiang
--@note		公会商店日志


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCommunityShopLog:onEnter(element)
	WZLog("WndCommunityShopLog:onEnter")
	self.m_root = element
	AdaptLanguage(self)
	ProtocolProcessorStore:send_GUILD_GetGuildStoreLog()
	self:initUI()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCommunityShopLog:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮
function WndCommunityShopLog:onClose(element)
	WZLog("WndCommunityShopLog:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_callbackLua and self.m_callbackFun then
		self.m_callbackFun(self.m_callbackLua)
	end
	WindowManager:removeWindow(self.m_root, WndCommunityShopLog, true)
	
end


function WndCommunityShopLog:initUI( ... )
	WZLog("WndCommunityShopLog:initUI")
	local txtTitle = GetElement(self.m_root,"txtTitle_WndCommunityShopLog",WZUILabelTTF)
	local temp  = LocalStrings.COMMUNITY_STORE .. LocalStrings.LOG
	txtTitle:setText(temp)
end

function WndCommunityShopLog:updateLog()
	WZLog("WndCommunityShopLog:updateLog")
	local freeconText = GetElement(self.m_root,"freeconText_WndCommunityShopLog",WZUIFreeListContainer)
	freeconText:removeAll()
	local conForLog = GetElement(self.m_root, "conForLog_WndCommunityShopLog", WZUIContainer)
	if (self.m_tStorageLog == nil or #self.m_tStorageLog <= 0) and  self.m_nCurLogType == 0 then 
		--暂无数据
		ShowPanelNullTip(conForLog)
		return 
	elseif  (self.m_tCommunityShopLog == nil or #self.m_tCommunityShopLog <= 0) and  self.m_nCurLogType == 1 then
		--暂无数据
		ShowPanelNullTip(conForLog)
		return 
	end
	removeShowPanelNullTip(conForLog)


	local tabStorageLog = {}
	for i,v in ipairs(self.m_tStorageLog) do
		if tabStorageLog[v[1]] == nil then
			tabStorageLog[v[1]] = {}
		end
		if tabStorageLog[v[1]][v[2]] == nil then
			tabStorageLog[v[1]][v[2]] = {}
		end
		if tabStorageLog[v[1]][v[2]][v[4]] == nil then
			tabStorageLog[v[1]][v[2]][v[4]] = v[5]
		else
			tabStorageLog[v[1]][v[2]][v[4]] = tabStorageLog[v[1]][v[2]][v[4]] + v[5]
		end
	end
	WZLog("tabStorageLog",Serialize(tabStorageLog))
	local tabGuildShopLog = {}
	for i,v in ipairs(self.m_tCommunityShopLog) do
		if tabGuildShopLog[v[1]] == nil then
			tabGuildShopLog[v[1]] = {}
		end
		if tabGuildShopLog[v[1]][v[3]] == nil then
			tabGuildShopLog[v[1]][v[3]] = {}
		end
		if tabGuildShopLog[v[1]][v[3]][v[4]] == nil then
			tabGuildShopLog[v[1]][v[3]][v[4]] = v[5]
		else
			tabGuildShopLog[v[1]][v[3]][v[4]] = tabGuildShopLog[v[1]][v[3]][v[4]] + v[5]
		end
	end
	WZLog("tabGuildShopLog",Serialize(tabGuildShopLog))

	if self.m_nCurLogType == 0 then
		local storageLogTag = 0
		for time, valueT in pairs(tabStorageLog) do
			for player, valueP in pairs(valueT) do
				local celElement,tFreeCell = CellCommunityInfoList:createElement(GlobalMethod:CCSize(878,65))
				celElement = WZUIContainer:luaTo(celElement)
				celElement:setTag(storageLogTag)
				storageLogTag = storageLogTag + 1
				local monsterName = GDatatab_monster["id_" .. player].name
				local strReward = ""
				local count = 1
				for item, valueI in pairs(valueP) do
					local itemName = GDatatab_item["id_" .. item].name
					local temp = itemName .. "*" .. valueI
					if count == 1 then
						strReward = strReward..temp
					else
						strReward = strReward..","..temp
					end
					count = count + 1
				end
				count = nil
				local log = string.format(LocalStrings.STORAGE_LOG_TIP,monsterName,strReward)
				tFreeCell:setLog(log,time)
				freeconText:pushBack(celElement)
			end
		end
		storageLogTag = nil
	else
		local guildShopLogTag = 0
		for time, valueT in pairs(tabGuildShopLog) do
			for player, valueP in pairs(valueT) do
				local celElement,tFreeCell = CellCommunityInfoList:createElement()
				celElement = WZUIContainer:luaTo(celElement)
				celElement:setTag(guildShopLogTag)
				guildShopLogTag = guildShopLogTag + 1
				local strReward = ""
				local count = 1
				for item, valueI in pairs(valueP) do
					local itemName = GDatatab_item["id_" .. item].name
					local temp = itemName .. "*" .. valueI
					if count == 1 then
						strReward = strReward..temp
					else
						strReward = strReward..","..temp
					end
					count = count + 1
				end
				count = nil
				local log = string.format(LocalStrings.COMMUNITY_SHOP_LOG_TIP,player,strReward)
				tFreeCell:setLog(log,time)
				freeconText:pushBack(celElement)
			end
		end
		guildShopLogTag = nil
	end

	local minY = freeconText:getMinPosition().y
	freeconText:getMoveElement():setPositionY(minY)
end

function WndCommunityShopLog:onCheckBack(element)
	-- body
	WZLog("WndCommunityShopLog:onCheckBack")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag =  element:getTag()
	if self.m_nCurLogType == tag then return end
	self.m_nCurLogType = tag
	self:updateLog()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function WndCommunityShopLog:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtCheck1_WndCommunityShopLog",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCheckSel1_WndCommunityShopLog",WZUILabelTTF):setScale(0.8)
end

function WndCommunityShopLog:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtCheck1_WndCommunityShopLog",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtCheckSel1_WndCommunityShopLog",WZUILabelTTF):setScale(0.8)
	local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndCommunityShopLog",WZUILabelTTF)
	txtCheck2:setScale(0.8)
	txtCheck2:setDimensions(GlobalMethod:CCSize(80,0))
	local txtCheckSel2 = GetElement(self.m_root,"txtCheckSel2_WndCommunityShopLog",WZUILabelTTF)
	txtCheckSel2:setScale(0.8)
	txtCheckSel2:setDimensions(GlobalMethod:CCSize(80,0))
end

function WndCommunityShopLog:_adaptLanguage_pt(  )
	local txtCheck1 = GetElement(self.m_root,"txtCheck1_WndCommunityShopLog",WZUILabelTTF)
	txtCheck1:setScale(0.9)
	txtCheck1:setDimensions(GlobalMethod:CCSize(90))
	local txtCheckSel1 = GetElement(self.m_root,"txtCheckSel1_WndCommunityShopLog",WZUILabelTTF)
	txtCheckSel1:setScale(0.9)
	txtCheckSel1:setDimensions(GlobalMethod:CCSize(90))
	local txtCheck2 = GetElement(self.m_root,"txtCheck2_WndCommunityShopLog",WZUILabelTTF)
	txtCheck2:setScale(0.9)
	txtCheck2:setDimensions(GlobalMethod:CCSize(90))
	local txtCheckSel2 = GetElement(self.m_root,"txtCheckSel2_WndCommunityShopLog",WZUILabelTTF)
	txtCheckSel2:setScale(0.9)
	txtCheckSel2:setDimensions(GlobalMethod:CCSize(90))
end

function WndCommunityShopLog:_adaptLanguage_es(  )
	for i=1,2 do
		local txtCheck = GetElement(self.m_root,"txtCheck"..i.."_WndCommunityShopLog",WZUILabelTTF)
		txtCheck:setDimensions(GlobalMethod:CCSize(110,0))
		txtCheck:setScale(0.8)
		local txtCheckSel = GetElement(self.m_root,"txtCheckSel"..i.."_WndCommunityShopLog",WZUILabelTTF)
		txtCheckSel:setDimensions(GlobalMethod:CCSize(110,0))
		txtCheckSel:setScale(0.8)
	end
end

function WndCommunityShopLog:_adaptLanguage_tr(  )
	for i=1,2 do
		local txtCheck = GetElement(self.m_root,"txtCheck"..i.."_WndCommunityShopLog",WZUILabelTTF)
		txtCheck:setDimensions(GlobalMethod:CCSize(110,0))
		txtCheck:setScale(0.8)
		local txtCheckSel = GetElement(self.m_root,"txtCheckSel"..i.."_WndCommunityShopLog",WZUILabelTTF)
		txtCheckSel:setDimensions(GlobalMethod:CCSize(110,0))
		txtCheckSel:setScale(0.8)
	end
end
-------------------------------------语言适配End--------------------------------------------
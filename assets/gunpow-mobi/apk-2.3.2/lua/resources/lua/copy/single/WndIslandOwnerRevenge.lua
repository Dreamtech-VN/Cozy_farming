--WndIslandOwnerRevenge.lua
--@brief	WndIslandOwnerRevenge的UI模块
--@date		2021/08/31
--@author	yrd
--@note		岛主复仇


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndIslandOwnerRevenge:onEnter(element)
	self.m_root = element

    --@brief    指定副本的岛主数据（MAP_GetMapLandlordData = 45）错误处理(S->C)
    ProtocolProcessorSingleMap:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetMapLandlordData, "ProtocolProcessorSingleMap:send_MAP_GetMapLandlordData_ErrorProcess", "is" )
    --@brief    获取指定岛主副本数据（MAP_GetMapLandlordDataOk = 46）
    ProtocolProcessorSingleMap:regProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetMapLandlordDataOk, "ProtocolProcessorSingleMap:parse_MAP_GetMapLandlordDataOk", "iiiiivivivsvivivivivivivivi")

    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndIslandOwnerRevenge:onExit(element)
	self:_unInit()

    --@brief    指定副本的岛主数据（MAP_GetMapLandlordData = 45）错误处理(S->C)
    ProtocolProcessorSingleMap:unregProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetMapLandlordData, "ProtocolProcessorSingleMap:send_MAP_GetMapLandlordData_ErrorProcess", "is" )
    --@brief    获取指定岛主副本数据（MAP_GetMapLandlordDataOk = 46）
    ProtocolProcessorSingleMap:unregProtocolCallbackFunction( Protocol.MAIN_SINGLEMAP, Protocol.MAP_GetMapLandlordDataOk, "ProtocolProcessorSingleMap:parse_MAP_GetMapLandlordDataOk", "iiiiivivivsvivivivivivivivi")
end

--@brief	onEnter函数执行完成回调
function WndIslandOwnerRevenge:onEnterTransitionDidFinish(element)
	self.m_tData = CacheCenter:getIslandOwnerData()
	if self.m_tData == nil or self.m_tData == {} then
		WindowManager:removeWindow(self.m_root, self, true)
		return
	end

	self:updateUI()
end

--@brief	点击关闭按钮回调
function WndIslandOwnerRevenge:onClickClose(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	更新界面
function WndIslandOwnerRevenge:updateUI()
	self:showPage(self.m_nCurPageIndex)
end

--@brief	显示页面内容
function WndIslandOwnerRevenge:showPage(nPageIndex)
	local tCurPage = self.m_tData[nPageIndex]

	local strDifficulty = {LocalStrings.COMMON,LocalStrings.DIFFICULTY,LocalStrings.HELL}
	local tSingleCopyInfo = GDatatab_single_map["id_"..tCurPage.mapId]

	--副本名
	local txtMapName = GetElement(self.m_root,"txtMapName_WndIslandOwnerRevenge",WZUILabelTTF)
	txtMapName:setText(tSingleCopyInfo.map_name.."("..strDifficulty[tSingleCopyInfo.map_type]..")")
	--占领时间
	local strDate = os.date("%Y-%m-%d %H:%M %S", tCurPage.createTime)
	local txtSnatchTime = GetElement(self.m_root,"txtSnatchTime_WndIslandOwnerRevenge",WZUILabelTTF)
	txtSnatchTime:setText(strDate)
	--奖励内容
	local strName = ""
	for i=1,#tCurPage.playerData do
		if i ~= 1 then
			strName = strName .. ","
		end
		strName = strName .. tCurPage.playerData[i].name
	end
	local strItem = ""
	if tCurPage.reward == "" then
		strItem = LocalStrings.NONE
	else
		local ids,nums = SplitItemString(tCurPage.reward)
		for i=1,#ids do
	        local tItemInfo = GDatatab_item["id_" .. ids[i]]
			if i ~= 1 then
				strItem = strItem .. ","
			end
			strItem = strItem .. tItemInfo.name .. "*" .. nums[i]
		end
	end
	local txtSnatchContent = GetElement(self.m_root,"txtSnatchContent_WndIslandOwnerRevenge",WZUILabelTTF)
	txtSnatchContent:setText(string.format(LocalStrings.ISLAND_OWNER_TEXT12,strName,#tCurPage.playerData,strItem))
	--玩家信息
	for i=1,3 do
		local conPlayer = GetElement(self.m_root,"conPlayer"..i.."_WndIslandOwnerRevenge",WZUIContainer)
		conPlayer:setVisible(false)
		if tCurPage.playerData[i] then
			conPlayer:setVisible(true)
			local conPlayerHead = GetElement(self.m_root,"conPlayerHead"..i.."_WndIslandOwnerRevenge",WZUIContainer)
			local cell,tcell = CellHead:show(conPlayerHead,tCurPage.playerData[i].headId,tCurPage.playerData[i].faceId,tCurPage.playerData[i].sex,nil,nil,tCurPage.playerData[i].vipLevel,tCurPage.playerData[i].headColor)
			local txtPlayerName = GetElement(self.m_root,"txtPlayerName"..i.."_WndIslandOwnerRevenge",WZUILabelTTF)
			txtPlayerName:setText(tCurPage.playerData[i].name)
			local txtFightingWord = GetElement(self.m_root,"txtFightingWord"..i.."_WndIslandOwnerRevenge",WZUILabelTTF)
			txtFightingWord:setText(LocalStrings.BATTLE..":")
			local txtFightingValue = GetElement(self.m_root,"txtFightingValue"..i.."_WndIslandOwnerRevenge",WZUILabelTTF)
			txtFightingValue:setText(tCurPage.playerData[i].fight)
		end
	end
	--剩余时间
	local nLeftTime = tCurPage.leaveTime - SystemTime:getServerTime()
    local hours = math.floor(nLeftTime/3600)
    local minutes = math.floor((nLeftTime%3600)/60)
	local strLeftTime = hours .. LocalStrings.HOUR1 .. minutes .. LocalStrings.MINUTE1
	local strTimeFormat = [[<T S="18" C="127,70,29" P="0">%s: </T><T S="18" C="229,105,22" P="0">%s</T>]]
	local ftbLeftTime = GetElement(self.m_root,"ftbLeftTime_WndIslandOwnerRevenge",WZUIFreeTextBox)
	ftbLeftTime:setShowText(string.format(strTimeFormat,LocalStrings.SHOP_GOODSSHEGN,strLeftTime))
	--翻页按钮
	local btnPrevious = GetElement(self.m_root,"btnPrevious_WndIslandOwnerRevenge",WZUIButton)
	local btnNext = GetElement(self.m_root,"btnNext_WndIslandOwnerRevenge",WZUIButton)
	btnPrevious:setVisible(nPageIndex ~= 1)
	btnNext:setVisible(nPageIndex ~= #self.m_tData)

end

--@brief	点击上一个
function WndIslandOwnerRevenge:onClickPrevious(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nCurPageIndex = self.m_nCurPageIndex - 1
	self:showPage(self.m_nCurPageIndex)
end

--@brief	点击下一个
function WndIslandOwnerRevenge:onClickNext(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nCurPageIndex = self.m_nCurPageIndex + 1
	self:showPage(self.m_nCurPageIndex)
end

--@brief	点击复仇
function WndIslandOwnerRevenge:onClickCounterattack(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tNewData = CacheCenter:getIslandOwnerData()
	if tNewData == nil or tNewData == {} then
        MsgBoxManager:showTipBox(LocalStrings.ISLAND_OWNER_TEXT25)
		WindowManager:removeWindow(self.m_root, self, true)
		return
	end
	local bIsExist = false
	for j=1,#tNewData do
		if self.m_tData[self.m_nCurPageIndex].createTime == tNewData[j].createTime and self.m_tData[self.m_nCurPageIndex].mapId == tNewData[j].mapId then
			self.m_nCurPageIndex = j
			self.m_tData = tNewData
			self:updateUI()
			bIsExist = true
			break
		end
	end
	if bIsExist ~= true then
        MsgBoxManager:showTipBox(LocalStrings.ISLAND_OWNER_TEXT15)
		return
	end

	local mapId = self.m_tData[self.m_nCurPageIndex].mapId
	ProtocolProcessorSingleMap:send_MAP_GetMapLandlordData(mapId)
end

function WndIslandOwnerRevenge:counterattackCallback(mapId, landlordId, time, protectTime, revenge, playerId, serverId, name, sex, vipLevel, headId, headColor, faceId, fight, level, landlordMapId)
	local mapId = self.m_tData[self.m_nCurPageIndex].mapId
	if revenge > 0 then
		SceneCopy:showScene(1, nil, mapId, false, nil, nil, nil, 1)
		WindowManager:removeWindow(self.m_root, self, true)
	else
        MsgBoxManager:showTipBox(LocalStrings.ISLAND_OWNER_TEXT15)
        CacheCenter:removeIslandOwnerData(mapId)
	end
end

--@brief	点击玩家头像
function WndIslandOwnerRevenge:onClickPlayer(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	local playerData = self.m_tData[self.m_nCurPageIndex].playerData
	WndCheckOther:show(playerData[tag].playerId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配begin----------------------------------------
function WndIslandOwnerRevenge:_adaptLanguage_vn()
    GetElement(self.m_root,"txtPlayerName1_WndIslandOwnerRevenge",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtFightingWord1_WndIslandOwnerRevenge",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtPlayerName2_WndIslandOwnerRevenge",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtFightingWord2_WndIslandOwnerRevenge",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtPlayerName3_WndIslandOwnerRevenge",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtFightingWord3_WndIslandOwnerRevenge",WZUILabelTTF):setScale(0.8)
end
-------------------------------------语言适配End----------------------------------------


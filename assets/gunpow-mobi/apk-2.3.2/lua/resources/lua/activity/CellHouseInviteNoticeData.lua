--CellHouseInviteNoticeData.lua
--@brief	CellHouseInviteNotice的数据模块
--@date		2021/09/27
--@author	hyx
--@note		房产主界面

CellHouseInviteNotice = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellHouseInviteNotice:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tNoticeItem = {}
	self.m_tNoticeData = {}
	self.m_nWinType = nil   --1:默认；2:张灯结彩-代收礼品卡
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellHouseInviteNotice:_unInit()
	self.m_root = nil
	self.m_tNoticeItem = nil
	self.m_tNoticeData = nil
	self.m_nWinType = nil
end

function CellHouseInviteNotice:setHouseNoticeData(_type, name, playerid, headIds, faceIds, sexs, vipLevels, headColors, levels, serverIds, activityId, descRandom)
	local data = {}
	for i=1, #_type do
		local tab = {}
		tab._type = _type[i]
		tab.name = name[i]
		tab.playerid = playerid[i]
		tab.headId = headIds[i]
		tab.faceId = faceIds[i]
		tab.sex = sexs[i]
		tab.vipLevel = vipLevels[i]
		tab.headColor = headColors[i]
		tab.level = levels[i]
		tab.serverId = serverIds[i]
		tab.activityId = activityId
		if descRandom then 
			tab.descRandom = descRandom[i]
		else
			tab.descRandom = playerid[i]
		end

		data[i] = tab
	end
	return data
end

--@brief 	设置待领取礼品卡数据
function CellHouseInviteNotice:setCardNoticeData(uncheckedIndexes, name, playerid, headIds, faceIds, sexs, vipLevels, headColors, levels, serverIds, headEffectId)
	local data = {}
	for i=1, #playerid do
		local tab = {}
		tab._type = 4
		tab.uncheckedIndexes = uncheckedIndexes[i]
		tab.name = name[i]
		tab.playerid = playerid[i]
		tab.headId = headIds[i]
		tab.faceId = faceIds[i]
		tab.sex = sexs[i]
		tab.vipLevel = vipLevels[i]
		tab.headColor = headColors[i]
		tab.level = levels[i]
		tab.serverId = serverIds[i]
		tab.headEffectId = headEffectId[i]

		data[i] = tab
	end

	return data
end

--@brief 	更新收礼剩余次数
function CellHouseInviteNotice:updateLeftNum()
	if self.m_root == nil then return end 

	local desc = string.format(LocalStrings.DECORATIONS_TEXT4, WndDecorations.m_tContent.takeCardLeftNum .. "/" .. WndDecorations.m_tContent.takeCardLimit)
	local ftxtBottomDesc = GetElement(self.m_root, "ftxtBottomDesc_CellHouseInviteNotice", WZUIFreeTextBox):setShowText(desc)
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function CellHouseInviteNotice:createElement()
	if CellHouseInviteNotice.m_root ~= nil then
		WindowManager:removeWindow(CellHouseInviteNotice.m_root, CellHouseInviteNotice, true)
	end
	local tNewObj = self:_new()
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellHouseInviteNotice")
	assert(element, "CellHouseInviteNotice create element failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element, tNewObj
end

--@brief 	设置窗口类型
function CellHouseInviteNotice:setWinType(nWinType)
	self.m_nWinType = nWinType or 1
end

function CellHouseInviteNotice:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--======= 通知 ========
NoticeItem = {}
function NoticeItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tNoticeItemData = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function NoticeItem:_unInit()
	self.m_root = nil
	self.m_tNoticeItemData = nil
end

--@brief	创建控件
function NoticeItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(822,92))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function NoticeItem:setNoticeData(data)
	self.m_tNoticeItemData = data
end

--@brief 	开始加载
function NoticeItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("NoticeItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setNoticeItemData(self.m_tNoticeItemData)
end
function NoticeItem:setNoticeItemData(data)
	if not data or not self.m_root then
		return
	end

	local btnRefuse = GetElement(self.m_root,"btnRefuse",WZUIButton)
	btnRefuse:setVisible(false)
	local btnAgree = GetElement(self.m_root,"btnAgree",WZUIButton)
	btnAgree:setVisible(false)
	local img_bg = GetElement(self.m_root,"img_bg",WZUI9Image)
	local richNoticeResult = GetElement(self.m_root,"richNoticeResult",WZUIFreeTextBox)
	richNoticeResult:setVisible(false)
	local head_con = GetElement(self.m_root,"head_con",WZUIContainer)
	head_con:setVisible(false)
	if data._type == 1 or data._type == 4 then
		btnRefuse:setVisible(true)
		btnAgree:setVisible(true)
		local txtDesc = GetElement(self.m_root, "txtDesc_NoticeItem", WZUILabelTTF)
		if data._type == 4 then 
			btnRefuse:setVisible(false)
			txtDesc:setTextKey("")
			txtDesc:setText(LocalStrings.DECORATIONS_TEXT1[16])
			GetElement(self.m_root, "txtAgree_NoticeItem", WZUILabelTTF):setTextKey("NEWYEAR_TEXT8")
			GetElement(self.m_root, "txtAgreeSel_NoticeItem", WZUILabelTTF):setTextKey("NEWYEAR_TEXT8")
		else
			if data.activityId == g_cityExtenInfo.activity7058 then 
				txtDesc:setTextKey("")
				local nCount = #LocalStrings.MIDNIGHTDINER_TEXT3
				local tempRand = math.random(1, 10)
				local strIndex = math.fmod(tempRand, nCount) + 1
				txtDesc:setText(LocalStrings.MIDNIGHTDINER_TEXT3[strIndex])
			elseif data.activityId == g_cityExtenInfo.activity7074 then 
				txtDesc:setTextKey("")
				local nCount = #LocalStrings.TEAMCONSUME_TEXT1[18]
				local tempRand = math.random(1, 10)
				local strIndex = math.fmod(tempRand, nCount) + 1
				txtDesc:setText(LocalStrings.TEAMCONSUME_TEXT1[18][strIndex])
			elseif data.activityId == g_cityExtenInfo.activity7082 then 
				txtDesc:setTextKey("")
				local nCount = #LocalStrings.GOLFBALL_TEXT1[28]
				local tempRand = data.descRandom
				local strIndex = math.fmod(tempRand, nCount) + 1
				txtDesc:setText(LocalStrings.GOLFBALL_TEXT1[28][strIndex])
			elseif data.activityId == g_cityExtenInfo.activity7087 then 
				txtDesc:setTextKey("")
				local nCount = #LocalStrings.GOLD_MINER_TEXT3
				local tempRand = data.descRandom
				local strIndex = math.fmod(tempRand, nCount) + 1
				txtDesc:setText(LocalStrings.GOLD_MINER_TEXT3[strIndex])
			elseif data.activityId == g_cityExtenInfo.activity7130 then 
				txtDesc:setTextKey("")
				local nCount = #LocalStrings.KINGOFMINING_TEXT3
				local tempRand = data.descRandom
				local strIndex = math.fmod(tempRand, nCount) + 1
				txtDesc:setText(LocalStrings.KINGOFMINING_TEXT3[strIndex])
			end
		end
		if data.activityId == g_cityExtenInfo.activity7074 then 
			img_bg:setFile("ui/common/frame_lieb_03.png")
		else
			img_bg:setFile("ui/common/frame_lieb.png")
		end
		GetElement(self.m_root,"txtLevel",WZUILabelTTF):setText(data.level)
		local txtName = GetElement(self.m_root,"txtName",WZUIFreeTextBox)
		if data.serverId == CacheCenter:getPlayerInfo().serverId then
			txtName:setShowText(string.format([[<T C="127,70,26" S="20" P="1">%s</T>]],data.name))
		else
			txtName:setShowText(string.format([[<I Z="1">ui/common/common_icon_kuafu.png</I><T C="127,70,26" S="20" P="1">%s</T>]],data.name))
		end
		head_con:setVisible(true)
		CellHead:show(head_con, data.headId, data.faceId, data.sex, false, nil, data.vipLevel, data.headColor, nil, nil, nil, nil, data.headEffectId)
	else
		img_bg:setFile("ui/common/frame_lieb_01.png")
		richNoticeResult:setVisible(true)
		if data._type == 2 then
			richNoticeResult:setShowText(string.format(LocalStrings.ACTIVITY_TEXT188,data.name))
		elseif data._type == 3 then
			richNoticeResult:setShowText(string.format(LocalStrings.ACTIVITY_TEXT189,data.name))
		end
	end
end
function NoticeItem:onBtnAgreeRefuse(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tNoticeItemData.playerid then
		if self.m_tNoticeItemData._type == 4 then 
			local tData = {}
			tData.index = self.m_tNoticeItemData.uncheckedIndexes
			local stringData = json.encode(tData)
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(g_cityExtenInfo.activity7030, 5, stringData)
		else
			local tab = {}
			tab.id = self.m_tNoticeItemData.playerid
			tab = json.encode(tab)
			local tag = element:getTag()
			local num = 4
			if tag == 2 then
				num = 5
			end
			if self.m_tNoticeItemData.activityId == g_cityExtenInfo.activity7074 then 
				num = 6 
				if tag == 2 then 
					num = 7
				end
			elseif self.m_tNoticeItemData.activityId == g_cityExtenInfo.activity7082 then 
				num = 9
				if tag == 2 then 
					num = 10
				end
			elseif self.m_tNoticeItemData.activityId == g_cityExtenInfo.activity7087 then 
				num = 9
				if tag == 2 then 
					num = 10
				end
			elseif self.m_tNoticeItemData.activityId == g_cityExtenInfo.activity7130 then 
				num = 11
				if tag == 2 then 
					num = 12
				end
			end
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ActivityDo(self.m_tNoticeItemData.activityId, num, tab)
		end
	end
end

--@brief    查看玩家信息
function NoticeItem:onCheckInfo(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndCheckOther:show(self.m_tNoticeItemData.playerid)
end

--@brief 	获取唯一Id
function NoticeItem:getUniqueId()
	-- body
	return self.m_tNoticeItemData.uncheckedIndexes
end
-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------
--@return	新建的表实例对象
function NoticeItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------

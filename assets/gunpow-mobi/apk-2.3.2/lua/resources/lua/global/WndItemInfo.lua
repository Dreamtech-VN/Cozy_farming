--WndItemInfo.lua
--@brief	WndItemInfo的UI模块
--@date		2014/09/01
--@author	zsq
--@note		物品tip信息

--[[
--外部调用接口
WndItemInfo:showInfo()
--@brief	通过类型设置tip数据列表
WndItemInfo:_setTipDataByType()
--设置self.m_tEquip
WndItemInfo:setEquipData(tData,pt)
--调用
self:_updateInfo()
]]

local DIRX = 0.07
local DIRY = 0.9
local NSPACE = 1.2
local MOTH_NUM = 4
local SUN_NUM = 4
local DESCROWLEN = 9   		--描述每行的长度
local stateWidth = {650,420,390}
local stateDescLen = {530,280,250}

MAIN_PROPS_TYPE = 2 --道具
MAIN_CHEST_TYPE = 3 --宝箱
MAIN_EQUIT_TYPE = 4 --装备
MAIN_DRESS_TYPE = 5 --时装
MAIN_MATERIAL_TYPE = 7--材料
MAIN_MONTHCARD_TYPE = 13 --月卡
INTERFACE_BAG = 1 --背包界面
INTERFACE_SHOP = 2
NTIME = 60
KID_MAIN_DRESS_TYPE = 31 --时装
MAIN_PHANTOM_EQUIPMENT = 37 --幻化装备
MAIN_PET_EQUIPMENT = 43 -- 宠物装备
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndItemInfo:onEnter(element)
	self.m_root = element
	self.m_root:retain()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndItemInfo:onExit(element)
    if self.m_root then
		self.m_root:release()
	end
    self.m_root = nil
	self:_unInit()
    Teach:isStartTeach("WndItemInfo:onExit")
end

--@brief	关闭回调函数
function WndItemInfo:onCloseClick()
	WZLog("WndItemInfo:onCloseClick",bPoint)
end

function WndItemInfo:_onCloseClick()
	WZLog("WndItemInfo:_onCloseClick",bPoint)
	if self.m_root == nil then return end
	--如果格子有高亮方法，设置格子高亮
	if self.m_tCell and self.m_tCell.setHighLight then
		self.m_tCell:setHighLight(false)
	end
	self.m_root:removeFromParentAndCleanup(true)
end

--@brief	续费按钮回调
function WndItemInfo:onExpired()
	if self.m_root == nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("续费按钮回调:", Serialize(self.m_tEquip))
	local nType = {[0]=2,[1]=3,[2]=4,[3]=5}
	WndPurchase:showBuyInterface(nType[self.m_tEquip.basicInfo.sub_type],self.m_tEquip.basicInfo.id,nil,nil, nil, nil, nil, nil, nil, nil, nil, self.m_tEquip.ownerId)
	--if self.m_tExpired then
	--	self.m_tExpired[2](self.m_tExpired[1],self,self.m_tEquip)
	--end
	self:_onCloseClick()
end

function WndItemInfo:tryOn()
    WZLog("----------------------try on------------------")
    local tcell = self.m_tOther.tcell
    tcell:onClickbgBtn()
    self:_onCloseClick()
end

function WndItemInfo:buyIt()
    WZLog("----------------------buy it------------------")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tcell = self.m_tOther.tcell
    tcell:onClickbuyBtn(self.m_tEquip)
    self:_onCloseClick()
end

--@brief	强化
function WndItemInfo:onStrengthen()
	WZLog("WndItemInfo:onStrengthen强化",self.m_tStreng)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then return end
	local openLv = GDatatab_button_info["id_26"].open_level
	local msg = GDatatab_button_info["id_26"].feedback_info

	if CacheCenter:getPlayerInfo().level >= openLv then
    	
	else
		MsgBoxManager:showTipBox(msg)
		return
	end

	if self.m_tStreng then
		self.m_tStreng[2](self.m_tStreng[1],self,self.m_tEquip)
		WndStrengthen:jumpToAddEquip(1,self.m_tEquip.playerItemId,self.m_tStreng[1],self.m_tStreng[3])
	end
	if WndBag then WndBag.m_bOpenStrengthen = true end
	self:_onCloseClick()
end

--@brief	升阶
function WndItemInfo:onAscending()
	WZLog("WndItemInfo:onAscending")
	--SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then return end
	--MsgBoxManager:showTipBox("升阶")
	WndAscending:jumpToAddEquip(self.m_tEquip, 1)
	self:_onCloseClick()
end

--@brief	调品
function WndItemInfo:onAscending2()
	WZLog("WndItemInfo:onAscending")
	--SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then return end
	--MsgBoxManager:showTipBox("升阶")
	WndStrengthen:jumpTo(4)
	self:_onCloseClick()
end

--@brief	穿上
function WndItemInfo:onWear()
    WZLog("WndItemInfo:onWear")
	if self.m_root == nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tWear then
		self.m_tWear[2](self.m_tWear[1],self,self.m_tEquip)
	end
	self:_onCloseClick()
end

--@brief	穿上时装
function WndItemInfo:onDress()
	WZLog("WndItemInfo:onDress")
	if self.m_root == nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local id = WZLuaVector_int_:create()
	local transferState = WZLuaVector_int_:create()
	id:push(self.m_tEquip.playerItemId)
	transferState:push(0)
	--如果相同位置有试穿时装，删除记录
	if WndDressList.m_tTryWearList ~= nil and WndDressList.m_tTryWearList[self.m_tEquip.basicInfo.sub_type+1] ~= nil then
		WndDressList.m_tTryWearList[self.m_tEquip.basicInfo.sub_type+1] = nil
	end
	ProtocolProcessorRecycling:send_PLAYERITEM_ChangeEquipment(id, transferState)
	self:_onCloseClick()
end

--@brief	穿上小孩时装
function WndItemInfo:onKidDress()
	WZLog("WndItemInfo:onKidDress")
	if self.m_root == nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local id = WZLuaVector_int_:create()
	id:push(self.m_tEquip.playerItemId)
	--如果相同位置有试穿时装，删除记录
	if WndKidDress.m_tTryWearList ~= nil and WndKidDress.m_tTryWearList[self.m_tEquip.basicInfo.sub_type] ~= nil then
		WndKidDress.m_tTryWearList[self.m_tEquip.basicInfo.sub_type] = nil
	end
	local tCurKidData = SceneKidHome.m_tKidData[WndKidDress.m_nKidIndex]
	ProtocolProcessorKid:send_WEDDING_ChangeChildFashion(tCurKidData.id, id)
	self:_onCloseClick()
end

--@brief	穿上小孩时装
function WndItemInfo:onKidHeadEffectDress()
	WZLog("WndItemInfo:onKidHeadEffectDress")
	if self.m_root == nil then return end
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local id = WZLuaVector_int_:create()
	id:push(self.m_tEquip.playerItemId)
	
	local tCurKidData = SceneKidHome.m_tKidData[WndKidDress.m_nKidIndex]
	ProtocolProcessorKid:send_WEDDING_ChangeChildFashion(tCurKidData.id, id)
	self:_onCloseClick()
end

--@brief	试穿
function WndItemInfo:onTryWear()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("试穿:")
	if self.m_root == nil then return end
	if self.m_tTryWear then
		self.m_tTryWear[2](self.m_tTryWear[1],self,self.m_tEquip)
	end
	self:_onCloseClick()
end

--@brief	点击套装图标
function WndItemInfo:onSuitIcon(element)
	WZLog("WndItemInfo:onSuitIcon",element:getTag())
	--战斗中不能点击
	if GlobalGame.g_bIfInBattle == true then return end    
	self:_onCloseClick()
	WndFastGetItems:show(element:getTag())
end

--获取途径
function WndItemInfo:getGotoChannel(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tEquip.basicInfo and self.m_tEquip.basicInfo.id then
		WndFastGetItems:show(self.m_tEquip.basicInfo.id)
	end
end
--@brief	适配大小
function WndItemInfo:adaptationOpenGLView(bShowAll)
	if self.m_root == nil then
		return
	end
	--默认配置
	if bShowAll == nil then
		bShowAll = true
	end
	self.m_root:setShowAll(bShowAll)
end

--@brief	显示装备信息
--@param	element:表绑定的UI节点引用
--@param	parentElement:表绑定的UI的父类节点引用(废弃，直接加到根场景上)
--@param	nType:tip信息的类型:1背包,3单行文字tips
--@param	tData:tip信息的数据列表
--@param	bButton:是否存在按钮
--@param	pt:窗口位置偏移
--@param	maxLineWin:单行的最小窗口,但该值即使比要显示的单行文本最大长度300大，还是以300为标准
--@param    :自定义按钮列表tData.tBtnList={"a","b"}
--@param    tOther其它数据,是扩展数据列表tOther.interface = 1 表示背包
function WndItemInfo:showInfo(element,parentElement,nType,tData,bButton,pt,bShowAll,tOther,nTag, nbHightLight)
	WZLog("WndItemInfo:showInfo", parentElement:getShowAll())
	--if self.m_root ~= nil then
	--	self:_onCloseClick()
	--	self.m_root = nil
	--end
	if self.m_root == nil and element then
		local itemInfo = WndItemInfo:createElement()
		itemInfo:setTag(-8)
		--local parentElement = GetSceneRoot()
		parentElement:setTouchSwallow(true)
		parentElement:addChild(itemInfo ,9999)

		self:adaptationOpenGLView(bShowAll)--适配大小
		self.m_tLua = {}
		self.m_tLua[1] = element
		self.m_tLua[2] = parentElement
		self.m_bButton = true
		self.m_nTag = nTag
		if bButton == false then
			self.m_bButton = false
		end
		WZLog("self.m_bButton:bButton",bButton,self.m_bButton)
       	self:_setTipDataByType(nType,tData,pt,tOther)

		--如果格子有高亮方法，设置格子高亮
		local tObj = element:getLuaObjectIndex()
		if tObj and tObj.setHighLight then
			if nil == nbHightLight or true == nbHightLight then
				self.m_tCell = tObj
				tObj:setHighLight(true)
			end
		end
	else
		--self:_onCloseClick()
		--self.m_root = nil
		--if not self:checkPoint(pt) then
		--	self:_onCloseClick()
		--	self.m_root = nil
		--end
	end
end

function WndItemInfo:onTouchBegan(element,pt)
	WZLog("WndItemInfo:onTouchBegan")
	if WndCheckOther.m_root then return end --玩家信息界面添加限制，针对背景设置界面，防止同时关掉背景设置界面
	if not self:checkPoint(pt) then
		self:_onCloseClick()
	end
end

function WndItemInfo:closeWin(element,pt)
	WZLog("WndItemInfo:closeWin")
	self:_onCloseClick()
end

--@brief	检查是否按下tip窗口
--return 	true:表示按下按钮，false：表示不在窗口范围内
function WndItemInfo:checkPoint(pt,dir)
	if self.m_root == nil or pt == nil then
		return
	end
	dir = dir or ccp(0,0)
	local bPointBtn = self:_checkBtnPoint(pt,dir)--检查是否按下在按钮下
	if bPointBtn == true then
		return true
	elseif bPointBtn == false then
		return false
	end
	return false--表示在窗口范围内还是关闭窗口
end


--@brief    点击按钮的回调
function WndItemInfo:onCustomFun(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then return end
	if self.m_fClickButton then
		self.m_fClickButton[2](self.m_fClickButton[1],element:getTag(),self.m_tEquip)
    end
	self:_onCloseClick()
end

--@brief	御下
function WndItemInfo:onUnderRoyal()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("卸下:")
	if self.m_root == nil then return end
	if self.m_tRoyal then
		self.m_tRoyal[2](self.m_tRoyal[1],self,self.m_tEquip)
	end
	self:_onCloseClick()
end

--@brief	用皮肤体验卡
function WndItemInfo:onPhantom() 
	WZLog("WndItemInfo:onPhantom")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	g_UsingPhantomData = CopyTable(self.m_tEquip)
	local wndOpenChest = WndOpenChest:createElement()
	WindowManager:addWindow(wndOpenChest,WndOpenChest,nil,nil,nil,true)
	WndOpenChest:setData(self.m_tEquip)
	self:_onCloseClick()
end

--@brief	使用足迹卡
function WndItemInfo:onFootMark() 
	WZLog("WndItemInfo:onFootMark", self.m_tEquip.id)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if self.m_tEquip.basicInfo.use_level <= CacheCenter:getPlayerInfo().level then 
		g_nUseFootMarkId = self.m_tEquip.basicInfo.id
		ProtocolProcessorFootMark:send_FOOTMARK_UseFootmark(self.m_tEquip.basicInfo.id)
	else
		MsgBoxManager:showTipBox(LocalStrings.OPENGIFTLEVEL)
	end
	self:_onCloseClick()
end

function WndItemInfo:onChangeSex()
	WZLog("WndItemInfo:onChangeSex")
	WndChangeSex:show(childChangeSex)
	self:_onCloseClick()
end

function WndItemInfo:onChangeChildSex()
 	-- body
	WZLog("WndItemInfo:onChangeChildSex")
	local kidMes = CacheCenter:getPlayerInfo().childMes
	if kidMes == nil or kidMes == "[]" then
		MsgBoxManager:showTipBox(LocalStrings.KID_TEXT62)
		return 
	end

	local main_type = self.m_tEquip.basicInfo.main_type
	local sub_type = self.m_tEquip.basicInfo.sub_type
	--小孩变性
	local childChangeSex = nil
	if main_type == 24 and sub_type == 1 then
		childChangeSex = true
	end
	WndChangeSex:show(childChangeSex)
	self:_onCloseClick() 	
 end 

--@自选礼包选择奖励
function WndItemInfo:onChooseReward()
	WZLog("WndItemInfo:onChooseReward")
	WZLog("自选礼包选择奖励",Serialize(self.m_tEquip))
	local wndChooseReward = WndChooseReward:createElement()
	WindowManager:addWindow(wndChooseReward,WndChooseReward,nil,nil,nil,true)
	WndChooseReward:setData(self.m_tEquip)
	self:_onCloseClick()
	return
end

--激活气泡卡
function WndItemInfo:onActivateBubble()
	WZLog("WndItemInfo:onActivateBubble")
	local bubbleId = self.m_tEquip.basicInfo.id
	WZLog("bubbleId =",bubbleId)
	ProtocolProcessorGlobal:send_CHAT_Activate(bubbleId)
	self:_onCloseClick()
end

--@brief	使用
function WndItemInfo:onApply()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--167
	if self.m_root == nil then return end
	local main_type = self.m_tEquip.basicInfo.main_type
	local sub_type = self.m_tEquip.basicInfo.sub_type
	--用技能书，打开宝箱界面
	if main_type == MAIN_PROPS_TYPE and sub_type == 14 then
		local wndOpenChest = WndOpenChest:createElement()
		WindowManager:addWindow(wndOpenChest,WndOpenChest,nil,nil,nil,true)
		WndOpenChest:setData(self.m_tEquip)
		self:_onCloseClick()
		return
	end
	--排位赛的时候
	if main_type == 2 then
		local id = self.m_tEquip.playerItemId
		if sub_type == 23 then
			local value = self.m_tEquip.basicInfo.value
			MsgBoxManager:showTipBox(string.format(LocalStrings.RANK_CARD_TIP,value))
			ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(id, value, "" )
			if ScenePvpRank.m_root then
				ScenePvpRank:refreshMatchInfo()
			end			
			self:_onCloseClick()
			return
		elseif sub_type == 52 then --战略赛段位保护卡
			local value = self.m_tEquip.basicInfo.value
			MsgBoxManager:showTipBox(string.format(LocalStrings.PVP_STRATEGIC_TEXT1[27],value))
			ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(id, 1, "" )	
			self:_onCloseClick()
			return
		elseif sub_type == 26 then
			ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(id, 1, "" )
			self:_onCloseClick()
			return
		elseif sub_type == 45 then	
			ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(id, self.m_tEquip.lastNum, "" )
			self:_onCloseClick()
			return
		elseif sub_type == 46 then
			local wndOpenChest = WndOpenChest:createElement()
			WindowManager:addWindow(wndOpenChest,WndOpenChest,nil,nil,nil,true)
			WndOpenChest:setData(self.m_tEquip)
			self:_onCloseClick()
			return
		elseif sub_type == 10 then
			local kidMes = CacheCenter:getPlayerInfo().childMes
			if kidMes == nil or kidMes == "[]" then
				MsgBoxManager:showTipBox(LocalStrings.KID_TEXT62)
				return
			else 
				SceneKidHome:showInterface(nil,true)
				self:_onCloseClick()
				return
			end
		elseif sub_type == 49 then 
			ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(id, 1, "" )
			self:_onCloseClick()
			return 
		end
	elseif main_type == 40 then 
		local id = self.m_tEquip.playerItemId
		if sub_type == 1 then 
			ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(id, 1, "" )
			self:_onCloseClick()
		elseif sub_type == 2 then 
			self:onKidHeadEffectDress()
		end
		return 
	end
	--丰收沙漏
	if main_type == 39 and sub_type == 1 then
		if CacheCenter:getPlayerInfo().pastureId <= 0 then
			MsgBoxManager:showTipBox(LocalStrings.PASTURE_TEXT58)
			return
		else
			WndBagMain:setUseSaveItemId(self.m_tEquip.basicInfo.id)
			ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(self.m_tEquip.playerItemId, 1, "" )
			self:_onCloseClick()
			return
		end
	end
	--活力满时不能用加活力物品
	local id = self.m_tEquip.basicInfo.id
	if tonumber(CacheCenter:getPlayerInfo().vigor) >= 1000 then
		if id == 102 or id == 167 or id == 390 or id == 385 or id == 389 or id == 450 then
			MsgBoxManager:showTipBox(LocalStrings.TIPS10)
			self:_onCloseClick()
			return
		end
	end
	
	if self.m_tUse then
		self.m_tUse[2](self.m_tUse[1],self,self.m_tEquip,tOther)
	end
	self:_onCloseClick()
end
-- 1、镶嵌副石
function WndItemInfo:onPutOn()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then return end
	GlobalGame:getGameEventDispathcer():Dispatch(PetMountEvent.PetMountEvent_StoneSlotPutonResult,self.m_tEquip)
	self:_onCloseClick()
end
--拆卸副石
function WndItemInfo:onStoneRemove()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then return end
	GlobalGame:getGameEventDispathcer():Dispatch(PetMountEvent.PetMountEvent_StoneSlotRemoveResult,self.m_tEquip)
	self:_onCloseClick()
end
--@brief	打开宝箱
function WndItemInfo:onChest()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("打开宝箱")
	local wndOpenChest = WndOpenChest:createElement()
	WindowManager:addWindow(wndOpenChest,WndOpenChest,nil,nil,nil,true)
	WndOpenChest:setData(self.m_tEquip)
	self:_onCloseClick()
end

--@brief	竞技加速
function WndItemInfo:onCompetitiveAcceleration()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local id = self.m_tEquip.basicInfo.id
	local count = CacheCenter:getPlayerItemCountById(id)
	WZLog("WndItemInfo:onCompetitiveAcceleration", id, count)

	if count > 1 then
		local wndOpenChest = WndOpenChest:createElement()
		WindowManager:addWindow(wndOpenChest,WndOpenChest,nil,nil,nil,true)
		WndOpenChest:setData(self.m_tEquip)
	elseif count == 1 then
		ProtocolProcessorRecycling:send_PLAYERITEM_UseItem(self.m_tEquip.playerItemId, 1, "" )

		local tData = self.m_tEquip
		local exp = tData.basicInfo.property[1][2]
		local count = tData.basicInfo.value
		local str = LocalStrings.ARENA_CARD_TIME_TIP
		if tData.basicInfo.sub_type == 12 then
			str = LocalStrings.ARENA_CARD_DAY_TIP
			count = math.ceil(count / 1440)
		end

		MsgBoxManager:showTipBox(string.format(str,exp,count), nil, nil, nil, nil)
	end

	self:_onCloseClick()
end

--@brief	用公会月卡
function WndItemInfo:onMonthCard()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("用公会月卡")
	--无公会不能用
	if CacheCenter:getPlayerInfo().guildId == nil or CacheCenter:getPlayerInfo().guildId < 1 then 
		MsgBoxManager:showTipBox(LocalStrings.MONTHCARDINFO1)
		return
	end 

	local wnd = WndCommunityMonthCard:createElement()
	WindowManager:addWindow(wnd,WndCommunityMonthCard,nil,nil,nil,true)
	self:_onCloseClick()
end

--@brief	获得装备
function WndItemInfo:onGetEquip()
	WZLog("WndItemInfo:onGetEquip")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local id = self.m_tEquip.basicInfo.id
	--装备碎片取合成的装备的属性
	if self.m_tEquip.basicInfo.main_type == 9 then
		id = GDatatab_item["id_"..GDatatab_itemmerge["id_"..self.m_tEquip.basicInfo.id].items[1][1]].id 
	end
	WndFastGetItems:show(id)
	self:_onCloseClick()
end

--@brief	更新基本信息列表
function WndItemInfo:_updateInfo()
	WZLog("WndItemInfo:_updateInfo")
	self:setState()--设置状态
	self:_showItem()--创建装备
	self:_showItemName()--名称
	self:_showItemExplain()--说明
	self:_showPacks()
	self:_showGreatSkill()
	self:_showStar()--创建星星
	self:_showItemPro()--物品属性
	self:_showItemExtraPro()--宠物装备额外属性
	self:_showWingExtraPro()--翅膀额外属性
	self:_showStone()--石头
	self:_showPowerSkill()--武器技能
	self:_showSuit()--套装
	self:_showPhantomSuit()--幻化套装
	self:_showDressSuit()--时装套装
	self:_showKidDressSuit() --小孩时装套装
	self:_showDressDesc()--时装过期描述
	self:_showEquipTimeOut()--时效装备倒计时
	self:_showDress999Att() --提示时效时装999天后自动转为永久
	self:_showLvLimit()--物品使用等级
	self:_showBtn()--按钮
	self:_showBackground()--背景图
	self:_setWinPos()--设置新窗口的位置
	self:_setNewWinSize()--设置新窗口大小
	self:_showFootMarkEffect()--足迹效果

	if WndBattleHud.m_root then return end --战斗中点击购买气泡时候会触发新手造成卡流程

    -- local isEndTeach, step = TeachGroup1:isTeachFinish(8)
    -- if isEndTeach ~= true and step > 0 then
    --     TeachGroup1:endTeachStep({8,4})
    --     TeachGroup1:startGroup({8,5,WndItemInfo.m_root})
    -- end

end

--@brief	设置tips的状态
function WndItemInfo:setState()
	--有技能
	if self.m_tEquip ~= nil and self.m_tEquip.basicInfo ~= nil and self.m_tEquip.basicInfo.power_skill ~= nil and self.m_tEquip.basicInfo.power_skill ~= -1 then
		self.m_nState = 1
		DESCROWLEN = 16
	end
	--套装部件
	if self.m_tEquip ~= nil and self.m_tEquip.basicInfo ~= nil and self:checkIsSuit(self.m_tEquip.basicInfo.id) == true then
		self.m_nState = 1
		DESCROWLEN = 16
	end
	--装备碎片
	if self.m_tEquip ~= nil and self.m_tEquip.basicInfo ~= nil and self.m_tEquip.basicInfo.main_type == 9 then
		local basicInfo = GDatatab_item["id_"..GDatatab_itemmerge["id_"..self.m_tEquip.basicInfo.id].items[1][1]]
		if basicInfo == nil then return end
		if (basicInfo.power_skill ~= nil and basicInfo.power_skill ~= -1) or self:checkIsSuit(basicInfo.id) == true then
			self.m_nState = 1
			DESCROWLEN = 16
		end
	end
	--宝箱
	if self.m_tEquip ~= nil and self.m_tEquip.basicInfo ~= nil and self.m_tEquip.basicInfo.main_type == 3 then
		self.m_nState = 1
		DESCROWLEN = 12
	end
	if self.m_nState == 1 then return end
	--有三个按钮
	if self.m_tEquip ~= nil and self.m_tEquip.basicInfo ~= nil and self.m_tEquip.tBtnList ~= nil and #self.m_tEquip.tBtnList > 2 then
		self.m_nState = 2
		DESCROWLEN = 10
	end
	--可进入升阶系统
	local playerLevel = CacheCenter:getPlayerInfo().level
	local bIsConfigAdvance, suitId, bIsAdvance = GetDressAdvanceData(self.m_tEquip.basicInfo.id)
	if playerLevel >= 35 and self.m_tEquip ~= nil and self.m_tEquip.basicInfo ~= nil and self.m_tEquip.basicInfo.quality >= 2 then
		self.m_nState = 2
		DESCROWLEN = 10
	end
	--可进阶
	if bIsConfigAdvance then 
		self.m_nState = 2
		DESCROWLEN = 10
	end
	--蓝装可以升阶
	if self.m_tEquip ~= nil and self.m_tEquip.basicInfo ~= nil and self.m_tEquip.extraInfo ~= nil and self.m_tEquip.basicInfo.quality == 2 and self.m_tEquip.extraInfo.strongLevel ~= nil and self.m_tEquip.extraInfo.strongLevel >= LANASCENDINGSTRONG and self.m_tEquip.extraInfo.starLevel ~= nil and self.m_tEquip.extraInfo.starLevel >= LANASCENDINGSTAR then
		self.m_nState = 2
		DESCROWLEN = 10
	end
	--紫装可以升阶
	if self.m_tEquip ~= nil and self.m_tEquip.basicInfo ~= nil and self.m_tEquip.extraInfo ~= nil and self.m_tEquip.basicInfo.quality == 3 and self.m_tEquip.extraInfo.strongLevel ~= nil and self.m_tEquip.extraInfo.strongLevel >= ZIASCENDINGSTRONG and self.m_tEquip.extraInfo.starLevel ~= nil and self.m_tEquip.extraInfo.starLevel >= ZIASCENDINGSTAR then
		self.m_nState = 2
		DESCROWLEN = 10
	end
end

--@brief	单行信息
function WndItemInfo:updateExplain(desc,ptDir)
	WZLog("单行信息",desc)
	local maxLineWin = 120
	local icon = "ui/common/common_scale9_di24.png"
	ptDir = ptDir or ccp(0,0)
	local txt = WZUILabelTTF:create()
	txt:setText(desc)
	txt:setFontSize(20)
	txt:setVisible(false)
	txt:setAlignment(kCCTextAlignmentLeft)
	self.m_root:addChild(txt)
	local size = txt:getContentSize()
	local wx = size.width+20
	local dimeW = 300
	if size.width > dimeW then
		txt:setDimensions(CCSize(dimeW,0))
		txt:setText(desc)
		wx = 320
	end
	local w = math.max(maxLineWin,wx)
	local h = size.height + 20
	local strLen = ChineseStringLen(desc)
	local rowNum = math.ceil(strLen / 14)
	if rowNum > 1 then
		--行数大于1时增加高度
		h = h + (rowNum - 1) * 20
	end
	local scale = 1
	local winElement = WZUIElementContainer:luaTo(self.m_root)
	winElement:setContentSize(CCSize(w,h))
	--pt1:世界坐标  pt:父节点中的坐标
	local pt,pt1 = self:_gettToNodePt()--获取位置
	local itemSize = self.m_tLua[1]:getContentSize()
	pt.x = pt.x + itemSize.width/2 + ptDir.x
	pt.y = pt.y + itemSize.height/2 - h/2 + ptDir.y
	if self:_checkRightWin(pt1,w) == true then--检查右边超框
		WZLog("检查右边超框")
		pt.x = pt.x - 96 - w
	end
	WZLog("pt,pt1::pt,pt1::",pt.x,pt.y,pt1.x,pt1.y,itemSize.width,itemSize.height)
	winElement:setAbsPosition(pt)
	local scaleCon = WZUIContainer:create()
	scaleCon:setAbsContentSize(CCSize(w*scale,h*scale))
	scaleCon:setUseAbsSize(true)
	winElement:addChild(scaleCon)
	local bkImg = WZUI9Image:create()
	bkImg:setFile(icon)
	bkImg:setScale(1/scale)
	scaleCon:addChild(bkImg)
	txt:removeFromParentAndCleanup(true)
	txt = WZUILabelTTF:create()
	txt:setText(desc)
	txt:setColor(ccc3(127,70,26))
	txt:setFontSize(20)
	txt:setName("txtEmptyItem1_WndItemInfo")
	txt:setAlignment(kCCTextAlignmentLeft)
	if size.width > dimeW then
		txt:setDimensions(CCSize(dimeW,0))
	end
	winElement:addChild(txt)

	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
		WZLog("--winElement--")
		pt.y = pt.y + 50
		pt.y = math.max(pt.y,350)
		winElement:setAbsPosition(pt)
	elseif ProjConfig.LANGUAGE == "ug" then
		WZLog("--winElement--")
		pt.y = pt.y + 50
		pt.y = math.max(pt.y,350)
		winElement:setAbsPosition(pt)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	创建图片
function WndItemInfo:_createImage(file,pt,sName,anchor,size,bOrigin)
	file = file or "common/Jigsaw/n_items01_sel.png"
	size = size or CCSize(1,1)
	pt = pt or ccp(0.5,0.5)
	anchor = anchor or ccp(0.5,0.5)
	bOrigin = bOrigin or true
	sName = sName or ""
	local img = WZUIImage:create()
	img:setRelativePosition(pt)
	img:setRelativeSize(size)
	img:setName(sName)
	img:setFile(file)
	img:setAnchorPoint(anchor)
	img:setUseOriginSize(bOrigin)
	return img
end

--@brief	创建按钮文本Label
function WndItemInfo:_createLabel(desc)
	local txt = WZUILabelTTF:create()
	txt:setFontSize(24)
	
	if ProjConfig.LANGUAGE == "vn" and desc == LocalStrings.ASCENDING9 then
		txt:setFontSize(18)
	elseif ProjConfig.LANGUAGE == "vn" then
		txt:setFontSize(22)
	end

	if ProjConfig.LANGUAGE == "en" then
		txt:setScale(0.7)
	end
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "tr" then
		txt:setFontSize(18)
	end
	if ProjConfig.LANGUAGE == "es" then
		txt:setFontSize(18)
		txt:setDimensions(GlobalMethod:CCSize(100,0))
	end
	
	if ProjConfig.LANGUAGE == "ug" then
		txt:setScale(0.7)
		txt:setDimensions(GlobalMethod:CCSize(140,0))
	end

	txt:setColor(ccc3(255,255,255))
	txt:setText(desc)
	txt:setTouchEnable(false)
	txt:setEnableStroke(true)
	txt:setStrokeColor(ccc3(0,108,3))
	txt:setStrokeSize(4)
	txt:setBoldFont(true)
	return txt
end

--@brief	创建按钮
function WndItemInfo:_createBtn(btnName,txt,pt,anchor,funName,tag)
	btnName = btnName or ""
	txt = txt or ""
	tag = tag or 0
	anchor = anchor or ccp(0.5,0.5)
	pt = pt or ccp(0.5,0.5)
	local con = WZUIContainer:create()
	con:setTouchSwallow(true)
	con:setUseAbsSize(true)
	con:setAbsContentSize(CCSize(100,50))
	con:setRelativePosition(pt)
	con:setAnchorPoint(anchor)
	local btn = WZUIButton:create()
    btn:setLuaActionName("Normal")
	local imgNor = WZUI9Image:create()
	imgNor:setFile("ui/common/common_btn_anniu4.png")
	imgNor:setUseOriginSize(true)
	local imgSel = WZUI9Image:create()
	imgSel:setFile("ui/common/common_btn_anniu4_sel.png")
	imgSel:setUseOriginSize(true)
	local imgNot = WZUI9Image:create()
	imgNot:setFile("ui/common/common_btn_anniu4.png")
	imgNot:setUseOriginSize(true)
	btn:setNormalElement(imgNor)
	btn:setSelectElement(imgSel)
	btn:setDisableElement(imgNot)
    if funName then
        btn:setLuaDoneFunctionName(funName)
    end
	btn:setTag(tag)
	btn:setName(btnName)
	btn:setTouchSwallow(true)
	con:addChild(btn)
	local txtBtn = self:_createLabel(txt)
	btn:addChild(txtBtn)
	return con,btn
end

--@brief	创建套装按钮
function WndItemInfo:_createSuitBtn(btnName,pt,funName,tag)
	btnName = btnName or ""
	tag = tag or 0
	local con = WZUIContainer:create()
	con:setUseAbsSize(true)
	con:setAbsContentSize(GlobalMethod:CCSize(65,65))
	con:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
	if pt ~= nil then
		con:setRelativePosition(pt)
	end
	local btn = WZUIButton:create()
	--local imgNor = WZUI9Image:create()
	--imgNor:setFile("ui/common/common_btn_anniu4.png")
	--imgNor:setUseOriginSize(true)
	--btn:setNormalElement(imgNor)
    if funName then
        btn:setLuaDoneFunctionName(funName)
    end
	btn:setTag(tag)
	btn:setName(btnName)
	con:addChild(btn)

	return con,btn
end

--@brief	创建装备
function WndItemInfo:_showItem(pt)
	if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil or self.m_tEquip.basicInfo.icon == nil then
		return
	end
	if self.m_root == nil then return end
	WZLog("创建装备")
	if self.m_root:getChildByTag(1059) then
		self.m_root:removeChildByTag(1059,true)
	end
	local maintype = self.m_tEquip.basicInfo.main_type
	local subtype = self.m_tEquip.basicInfo.sub_type
	local pt = pt or ccp(DIRX,DIRY)
	local sName = "conItem1_WndItemInfo"
	local con = WZUIContainer:create()
	con:setUseAbsSize(true)
	con:setAbsContentSize(CCSize(80,80))
	con:setAnchorPoint(ccp(0, 1))
	con:setTouchEnable(false)
	con:setName(sName)
	con:setRelativePosition(pt)
	con:setTag(1059)
	self.m_root:addChild(con)

	local bShow = true
	--创建物品底图
	local imgBg = self:_createImage("ui/common/common_scale9_beibaodi2.png")
	imgBg:setScale(0.9)
	con:addChild(imgBg)
	--遮罩
	 local clipCon = WZUIClippingContainer:create()
    local subCon = WZUIContainer:create()
    subCon:setUseAbsSize(true)
    subCon:setAbsContentSize(CCSizeMake(75,75))
    local img1 = WZUIImage:create()
    img1:setFile("ui/bag/common_shade_touxiang2.png")
    clipCon:setStencil(subCon)
    subCon:addChild(img1)
    con:addChild(clipCon)

	--创建物品图片
	local img
	if self.m_tEquip.basicInfo.id >= 2001 and self.m_tEquip.basicInfo.id <= 2154 or self.m_tEquip.basicInfo.id >= 2161 and self.m_tEquip.basicInfo.id <= 2162 then
		img = WZUISpine:create()
        img:setLoop(true)
        img:setTouchEnable(false)
        img:setFileJson("ui/ui_qifu.json")
        img:setFileAtlas("ui/ui_qifu.atlas")
        img:setAnimationName(self.m_tEquip.basicInfo.icon)
	else
		img = self:_createImage(self.m_tEquip.basicInfo.icon,nil,"imgItem_WndItemInfo")
	end
	img:setUseOriginSize(true)
	self.m_nSacleItem = 1
	img:setScale(self.m_nSacleItem)
	if maintype == 12 then
		img:setUseOriginSize(true)
		img:setScale(0.8)
	end
	if self.m_tEquip.basicInfo.id >= 1135 and self.m_tEquip.basicInfo.id <= 1146 or self.m_tEquip.basicInfo.id == 161085 then
		img:setScale(0.6)
	end
	if self.m_tEquip.basicInfo.id >= 1548 and self.m_tEquip.basicInfo.id <= 1550 then
		img:setScale(0.6)
	end
	if self.m_tEquip.basicInfo.id >= 160592 and self.m_tEquip.basicInfo.id <= 160596 then
		img:setScale(0.2)
	end
	if self.m_tEquip.basicInfo.main_type == 19 then
		img:setScale(0.4)
	end
	if maintype == 25 and subtype == 3 then
		img:setUseOriginSize(false)
		img:setScale(0.8)
	elseif maintype == 25 and subtype == 1 or maintype == 9 and subtype == 5 then
		img:setScale(0.5)
		--img:setRotation(45)
	elseif maintype == 38 and (subtype >= 1 and subtype <= 8) then
	 	img:setScale(0.56)
	elseif maintype == 1 and subtype == 59 then
	 	img:setScale(0.65)
	end
	clipCon:addChild(img)
	--语言适配
	local language = ProjConfig.LANGUAGE
	if "en" == language and self.m_tEquip.basicInfo.icon == "shopitems/month_card_blue.png" then
		img:setScale(0.8)
	end
	if "pt" == language and self.m_tEquip.basicInfo.icon == "shopitems/month_card_blue.png" then
		img:setScale(0.8)
	end
	--创建品质框
	local imgQuality = self:_createImage(self:_getItemQuality())
	con:addChild(imgQuality)
	--橙装显示橙装特效
	local quality = self.m_tEquip.basicInfo.quality
	if maintype == 4 and quality == 4 then
   		local spine = WZUISpine:create()
   		spine:setTouchEnable(false)
   		spine:setFileJson("ui/ui_icon_effect.json")
   		spine:setFileAtlas("ui/ui_icon_effect.atlas")
   		spine:setAnimationName("cheng")
   		spine:setUseOriginSize(true)
   		spine:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
		spine:play("cheng",true)
		spine:setScale(0.8)
   		con:addChild(spine,421,421)
	end

	--限时装备角标
	if (maintype == 4) and self.m_tEquip.showTimeLimit == true then
		local imgBk = self:_createImage("ui/common/common_icon_xbth.png",ccp(0.16,0.8))--添加背景
		con:addChild(imgBk,9)
		local txt = WZUILabelTTF:create()
		txt:setFontSize(20)
		txt:setColor(ccc3(255,255,255))
		txt:setText(LocalStrings.AGING)
		txt:setTouchEnable(false)
		txt:setEnableStroke(true)
		txt:setStrokeColor(ccc3(128,54,13))
		txt:setStrokeSize(4)
		txt:setBoldFont(true)
		txt:setRotation(-45)
		txt:setRelativePosition(ccp(0.06,0.92))
		con:addChild(txt,10)
	end

	--已拥有的武器添加角标
	if (maintype == 4 and (subtype == 0 or subtype == 1)) and CacheCenter:getPlayerItemCountById(self.m_tEquip.basicInfo.id) ~= 0 then
		local imgBk = self:_createImage("ui/common/common_icon_xbth.png",ccp(0.16,0.8))--添加背景
		con:addChild(imgBk,9)
		local txt = WZUILabelTTF:create()
		txt:setFontSize(20)
		txt:setColor(ccc3(255,255,255))
		txt:setText(LocalStrings.HAVE)
		txt:setTouchEnable(false)
		txt:setEnableStroke(true)
		txt:setStrokeColor(ccc3(128,54,13))
		txt:setStrokeSize(4)
		txt:setBoldFont(true)
		txt:setRotation(-45)
		txt:setRelativePosition(ccp(0.06,0.92))
		con:addChild(txt,10)
	end

	--皮肤体验卡添加角标
	if (maintype == 20) and self.m_tEquip.basicInfo.property[1][2] ~= -1 then
		--local imgBk = self:_createImage("ui/common/common_icon_tiyan.png",ccp(0.67,0.62))--添加背景
		local imgBk = self:_createImage("ui/common/common_icon_tiyan1.png",ccp(0.39,0.78))--添加背景
		con:addChild(imgBk,9)
	end

	--显示时装天数
	local hasItem = CacheCenter:getPlayerItemById(self.m_tEquip.basicInfo.id)
	if ( maintype == 5 ) and (hasItem ~= nil or self.m_tEquip.customizeLastTime ~= nil) then
		local conItem = con

		if hasItem ~= nil then
			countdown = hasItem.lastTime
		end

		if self.m_tEquip.customizeLastTime ~= nil then
			countdown = self.m_tEquip.customizeLastTime
		end

		if countdown == -86400 then countdown = -1 end


		if countdown == nil then return end
		if countdown == 0 then return end

		--无限期时装
		if countdown == -1 then
			local cornerIcon = WZUIImage:create()
    		cornerIcon:setAnchorPoint(ccp(0,1))
    		cornerIcon:setRelativePosition(ccp(-0.03,1.03))
    		cornerIcon:setUseOriginSize(true)
    		cornerIcon:setFile("ui/common/common_icon_yongjiu.png")
    		conItem:addChild(cornerIcon, 2000)
			return
    	end

		local desc = ""

		if tonumber(countdown) > 86400 then
			count = math.ceil(countdown/86400)
		else
			count = 1
		end

		local cornerIcon = WZUIImage:create()
    	cornerIcon:setAnchorPoint(ccp(0,1))
    	cornerIcon:setRelativePosition(ccp(-0.03,1.03))
    	cornerIcon:setUseOriginSize(true)
    	cornerIcon:setFile("ui/common/common_icon_ts.png")
    	conItem:addChild(cornerIcon, 2000)
    	--天
    	local imgDay = WZUIImage:create()
    	imgDay:setRelativePosition(ccp(0.483333,0.784848))
    	imgDay:setFile("ui/common/common_icon_ts2.png")
    	imgDay:setUseOriginSize(true)
    	imgDay:setRotation(-45)
    	cornerIcon:addChild(imgDay,1)
    	--天数
    	local txtDayNum = WZUILabelAtlasFont:create()
    	txtDayNum:setRelativePosition(ccp(0.266667,0.569697))
    	txtDayNum:setCharMapFileName("ui/common_num/common_num_ts.png")
    	txtDayNum:setHeight(18)
    	txtDayNum:setWidth(12)
    	txtDayNum:setText(count)
    	txtDayNum:setRotation(-45)
    	txtDayNum:setUseOriginSize(true)
    	cornerIcon:addChild(txtDayNum,1)
	end

	--显示倍率卡倍率
	local magnification = self.m_tEquip.magnification
	--magnification = 8
	if magnification ~= nil then
		if magnification == -1 then
			local magnification1 = WZUIImage:create()
    		magnification1:setAnchorPoint(ccp(0,1))
    		magnification1:setRelativePosition(ccp(0.49,0.53))
    		magnification1:setUseOriginSize(true)
			magnification1:setRotation(-30)
    		magnification1:setFile("ui/common_num/common_num_blk_wen.png")
    		con:addChild(magnification1, 2000)
		else
			local magnification1 = WZUIImage:create()
    		magnification1:setAnchorPoint(ccp(0,1))
    		magnification1:setRelativePosition(ccp(0.47,0.52))
    		magnification1:setUseOriginSize(true)
			magnification1:setRotation(-30)
    		magnification1:setFile("ui/common_num/common_num_blk_dian.png")
    		con:addChild(magnification1, 2000)

			local magnification2 = WZUILabelAtlasFont:create()
    		magnification2:setRelativePosition(ccp(0.54,0.45))
    		magnification2:setUseOriginSize(true)
			magnification2:setRotation(-30)
		    magnification2:setCharMapFileName("ui/common_num/common_num_blk.png")
    		magnification2:setHeight(16)
    		magnification2:setWidth(14)
    		magnification2:setText(1)
			if magnification < 10 then
    			magnification2:setText(0)
			end
    		con:addChild(magnification2, 2000)

			local magnification3 = WZUILabelAtlasFont:create()
    		magnification3:setRelativePosition(ccp(0.7,0.53))
    		magnification3:setUseOriginSize(true)
			magnification3:setRotation(-30)
		    magnification3:setCharMapFileName("ui/common_num/common_num_blk.png")
    		magnification3:setHeight(16)
    		magnification3:setWidth(14)
    		magnification3:setText(magnification%10)
    		con:addChild(magnification3, 2000)
		end
	end

	self:_addSynthesisIcon(con)
	self.m_showLock = bShow
	con:disableSchedule()
	con:enableSchedule("onExpiredAndLock")
end

function WndItemInfo:_addSynthesisIcon(con)
	if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil or self.m_tEquip.basicInfo.main_type ~= 9 then
		return
	end
	local img = WZUIImage:create()
	img:setFile("ui/common/common_icon_suipian.png")
	img:setUseOriginSize(true)
	img:setRelativePosition(ccp(0.72,0.7))
	con:addChild(img)
	WZLog("WndItemInfo:_addSynthesisIcon(con):::")
end

function WndItemInfo:onExpiredAndLock(element)
	element:disableSchedule()
	self:_showCount(element,self.m_showLock)
	self:_showExpired(element)--物品过期
end

--@brief	时间,数量
function WndItemInfo:_showCount(con,bShow)
	if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil and (self.m_tEquip.lastTime == nil or self.m_tEquip.lastNum == nil) then
		return
	elseif bShow == false then
		return
	end
	local lock = self:_checkLock()
	WZLog("WndItemInfo:lock",lock)
	if lock == 0 then
		return
	end
	local layer = WZUIContainer:create()
	layer:setAnchorPoint(ccp(0.5,0))
	layer:setUseAbsSize(true)
	layer:setAbsContentSize(CCSize(96,24))
	layer:setRelativePosition(ccp(0.5,-0.125))
	con:addChild(layer)
	--显示时间
	if lock == 2 then
		local desc = LocalStrings.NOLIMIT
		local num = tonumber(self.m_tEquip.lastTime)
		if self.m_tEquip.lastTimeBak and self.m_tEquip.lastTimeBak ~= 0 then
			num = self.m_tEquip.lastTimeBak
		else
			if self.m_tEquip.basicInfo.use_type == 0 or num == nil then
				num = tonumber(self.m_tEquip.lastNum)
			end
		end
		WZLog("lock num:",num,self.m_tEquip.lastTimeBak,self.m_tEquip.basicInfo.use_type)
		if num == 0 then
			return
		elseif num ~= -1 then
			desc = "x"..tostring(num)
		end

		local img = WZUIImage:create()
		img:setOpacity(180)
		img:setFile("common/Jigsaw/n_08.png")
		layer:addChild(img)
		local txt = WZUILabelTTF:create()
		txt:setAnchorPoint(ccp(1,0.5))
		txt:setAlignment(kCCTextAlignmentRight)
		txt:setRelativePosition(ccp(1,0.5))
		txt:setText(desc)
		txt:setColor(ccc3(255,255,255))
		txt:setFontSize(18)
		layer:addChild(txt)
	end
	--物品加锁
	self:_showLock(layer)
end

--@brief	物品加锁
function WndItemInfo:_showLock(con)
	if self:_checkLockTip() ~= 2 then
		return
	end
	local img = self:_createImage("ui/hall/roomlist_lock.png")
	img:setAnchorPoint(ccp(0,0))
	img:setRelativePosition(ccp(0,0.05))
	img:setUseOriginSize(true)
	img:setTag(1058)
	img:setScale(0.6)
	con:addChild(img)
	WZLog("lock:end:")
end

--@brief	物品过期
function WndItemInfo:_showExpired(con)
	if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil then
		return
	end
	local u_type = self.m_tEquip.basicInfo.use_type
	local value = self.m_tEquip.lastTime
	if u_type == 0 then--num
		value = self.m_tEquip.lastNum
		return
	end
	if value ~= 0 then
		return
	end
end

--@brief 创建物品的使用等级
function WndItemInfo:_showLvLimit()
	WZLog("创建物品的使用等级")
	if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil then return end
	local level = CacheCenter:getPlayerInfo().level
	if tonumber(level) >= self.m_tEquip.basicInfo.use_level then return end
	--判断是否达到等级
	-- if tonumber(level) < tonumber(self.m_tEquip.basicInfo.use_level) and (self.m_tEquip.main_type == 10 or self.m_tEquip.main_type == 23 or self.m_tEquip.main_type == 30) then
		-- h = h + self.m_addHigh
	-- end
	
	if tonumber(level) < tonumber(self.m_tEquip.basicInfo.use_level) and (self.m_tEquip.basicInfo.main_type == 11 or self.m_tEquip.basicInfo.main_type == 20 or self.m_tEquip.basicInfo.main_type == 23) then
		local x = self:_getItemIconX()
		local y,h = self:_getAllHeight()
		local txt =  WZUILabelTTF:create()
		txt:setName("txtUseLvel_WndItemInfo")
		txt:setText(LocalStrings.USE_LEVEL)
		txt:setFontSize(20)
		txt:setColor(ccc3(0,0,0))
		txt:setAnchorPoint(ccp(0,1))
		txt:setRelativePosition(ccp(x-0.3,y))
		self.m_root:addChild(txt)
		self.m_x,self.m_y = txt:getPosition()

		local num = WZUILabelTTF:create()
		num:setName("txtUseNum_wndItemInfo")
		num:setText(self.m_tEquip.basicInfo.use_level)
		num:setFontSize(20)
		num:setColor(ccc3(255,0,0))
		num:setAnchorPoint(ccp(0,1))
		num:setRelativePosition(ccp(x,y))
		self.m_root:addChild(num)
	end
end

--@brief	创建装备名字
function WndItemInfo:_showItemName()
	if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil then
		return
	end
	local x = self:_getItemIconX()
	local y,h = self:_getAllHeight()
	y = y - 0.13

	local value1,value2,value3,tData,sName
	if self.m_tEquip.basicInfo.main_type == 5 then
		local prefix = {LocalStrings.LEVELSTATE1,LocalStrings.LEVELSTATE2,LocalStrings.LEVELSTATE3,LocalStrings.LEVELSTATE4,LocalStrings.LEVELSTATE5}
		--时装的名字
		local u_type = self.m_tEquip.basicInfo.use_type
		local value = self.m_tEquip.lastTime
		if u_type == 0 then--num
			value = self.m_tEquip.lastNum
			return
		end
		value1 = "["..prefix[self.m_tEquip.basicInfo.quality].."]"..self.m_tEquip.basicInfo.name
		value2 = ""
		value3 = self.m_tEquip.extraInfo.strongLevel or "0"
		tData = self:_checkExp(value1,value2,value3,self:_getItemNameColor(2),nil,ccc3(55,236,237))
		sName = "txtItemName_WndItemInfo"
		local ownNum = CacheCenter:getPlayerItemCountById(self.m_tEquip.basicInfo.id) 
		if ownNum ~= 0 then 
			tData.value1_1 = LocalStrings.ASCENDING_FUSE12
			tData.color1_1 = ccc3(5,180,0)
		else
			tData.value1_1 = "(" .. LocalStrings.NO_GET_WORDS .. ")"
			tData.color1_1 = ccc3(255,89,74)
		end
		if WndCheckOther and WndCheckOther.m_root and not WndCheckOther.m_bIsHost then 
			tData.value1_1 = LocalStrings.ASCENDING_FUSE12
			tData.color1_1 = ccc3(5,180,0)
		end
		local bIsConfigAdvance, suitId, bIsAdvance = GetDressAdvanceData(self.m_tEquip.basicInfo.id)
		if bIsConfigAdvance and suitId ~= nil then 
			tData.value1_2 = LocalStrings.DRESS_SUIT_TEXT1[5]
			tData.color1_2 = ccc3(255,89,74)
			if bIsAdvance then 
				if self.m_tEquip.basicInfo.quality == 4 then
					tData.value1_2 = LocalStrings.DRESS_SUIT_TEXT1[6]
					tData.color1_2 = ccc3(5,180,0)
				elseif self.m_tEquip.basicInfo.quality == 5 then
					tData.value1_2 = LocalStrings.DRESS_SUIT_TEXT1[6]
					tData.color1_2 = ccc3(255,255,255)
				end
			end
		end
		-- sName = name or string.format(sName,i)
	elseif self.m_tEquip.basicInfo.level == nil then
		--普通物品的名字
		value1 = self.m_tEquip.basicInfo.name
		local value2 = ""
		value3 = self.m_tEquip.extraInfo.strongLevel or "0"
		local c2
		if self.m_tEquip.basicInfo.quality == 4 and self.m_tEquip.extraInfo ~= nil and self.m_tEquip.extraInfo.orangeEquiGrade ~= nil and self.m_tEquip.extraInfo.orangeEquiGrade ~= "" then
			local grade = SplitStringWithSeparator(self.m_tEquip.extraInfo.orangeEquiGrade,"|")
			value2 = GDatatab_item_orange_equi_grade["id_"..grade[1]].name
			c2 = ccc3(229,105,22)
		end
		tData = self:_checkExp(value1,value2,value3,self:_getItemNameColor(2),c2,ccc3(55,236,237))
		if self.m_tEquip.basicInfo.main_type == 2 and self.m_tEquip.basicInfo.sub_type == 49 or self.m_tEquip.basicInfo.main_type == 40 or self.m_tEquip.basicInfo.main_type == 25 or self.m_tEquip.basicInfo.main_type == 31 or (self.m_tEquip.basicInfo.main_type == 2 and self.m_tEquip.basicInfo.sub_type == 11) or self.m_tEquip.basicInfo.main_type == 20 or self.m_tEquip.basicInfo.main_type == 23 then 
			local tTempList = {}
			local bIsOwn = false 
			if self.m_tEquip.basicInfo.main_type == 2 and self.m_tEquip.basicInfo.sub_type == 49 then 
				tTempList = CacheCenter:getPlayerOwnInfoRectEffect() 
			elseif self.m_tEquip.basicInfo.main_type == 40 and self.m_tEquip.basicInfo.sub_type == 1 then 
				tTempList = CacheCenter:getPlayerOwnHeadEffect()
			elseif self.m_tEquip.basicInfo.main_type == 40 and self.m_tEquip.basicInfo.sub_type == 2 then 
				tTempList = CacheCenter:getPlayerOwnKidHeadEffect()
			elseif self.m_tEquip.basicInfo.main_type == 2 and self.m_tEquip.basicInfo.sub_type == 11 then --坐骑
				bIsOwn = checkOwnMount(self.m_tEquip.basicInfo.id) 
			elseif self.m_tEquip.basicInfo.main_type == 23 then --足迹
				bIsOwn = checkOwnFootMark(self.m_tEquip.basicInfo.id)
			elseif self.m_tEquip.basicInfo.main_type == 25 then 
				local ownNum = CacheCenter:getPlayerItemCountById(self.m_tEquip.basicInfo.id) 
				if ownNum > 0 then 
					bIsOwn = true 
				end
				if self.m_tEquip.basicInfo.id == 830 then --默认资料卡背景为拥有
					bIsOwn = true 
				end
				if self.m_tEquip.basicInfo.sub_type == 3 then 
					if self.m_tEquip.basicInfo.property[1][1] == -2 then 
						local vipMedal	
						local playerInfo = CacheCenter:getPlayerInfo()
						if playerInfo.vipMedal and playerInfo.vipMedal ~= "" then
							vipMedal = json.decode(playerInfo.vipMedal)
						end
						if vipMedal and vipMedal.level >= self.m_tEquip.basicInfo.property[1][2] then 
							bIsOwn = true 
						end
					end
				end
			elseif self.m_tEquip.basicInfo.main_type == 20 then --皮肤
				bIsOwn = checkOwnPhantom(self.m_tEquip.basicInfo.id)
			elseif self.m_tEquip.basicInfo.main_type == 31 then 
				local ownNum = CacheCenter:getPlayerHomeItemCountById(self.m_tEquip.basicInfo.id) 
				if ownNum ~= 0 then 
					bIsOwn = true 
				end
			end
			for i = 1, #tTempList do
				if tTempList[i].id == self.m_tEquip.basicInfo.id then 
					bIsOwn = true 
					break 
				end
			end
			if bIsOwn then 
				tData.value1_1 = LocalStrings.ASCENDING_FUSE12
				tData.color1_1 = ccc3(5,180,0)
			else
				tData.value1_1 = "(" .. LocalStrings.NO_GET_WORDS .. ")"
				tData.color1_1 = ccc3(255,89,74)
			end
		end
		sName = "txtItemName_WndItemInfo"
		-- sName = name or string.format(sName,i)
	else
		--如果物品的等级不为空,如显示怪物tips
		value1 = "Lv "..self.m_tEquip.basicInfo.level
		value2 = self.m_tEquip.basicInfo.name
		value3 = ""
		tData = self:_checkExp(value1,value2,value3,ccc3(127,70,26),ccc3(255,255,255),nil)
		sName = "txtItemName_WndItemInfo"
	end
	local txtA,_,_,_ = self:_createColorTxt(tData,sName,ccp(x,y)) 
	self:setAddTitleStroke(txtA,true)
end
--字体增加描边
function WndItemInfo:setAddTitleStroke(txt,_bool)
	_bool = _bool or nil
	if _bool == true then
		txt:setEnableStroke(true)
		txt:setStrokeColor(ccc3(132,66,29))
		txt:setStrokeSize(4)
	end
end
--时装过期描述
function WndItemInfo:_showDressDesc()
	WZLog("WndItemInfo:_showDressDesc::",os.time())
	if self.m_root == nil or self.m_tEquip == nil or self.m_tOther == nil then return end
	local main_type = self.m_tEquip.main_type
	if main_type ~= MAIN_DRESS_TYPE then
		return
	end
	self:_showLineOne()--创建线条
	self.m_nLineH = self.m_nLineH + 3
	local desc , isUpdate = self:_getDressUpdateData()
	local x = DIRX
	local y,h = self:_getAllHeight()
	--时效:
	if desc ~= nil and desc ~= "" then
		local txt =  WZUILabelTTF:create()
		txt:setText(LocalStrings.AGING..":")
		txt:setFontSize(22)
		txt:setColor(ccc3(127,70,26))
		txt:setAlignment(kCCTextAlignmentLeft)
		txt:setAnchorPoint(ccp(0,1))
		txt:setRelativePosition(ccp(x,y))
		self.m_root:addChild(txt)

	    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or 
	    	ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "tr" or 
	    	ProjConfig.LANGUAGE == "es" then
		   txt:setFontSize(16)
	    end
	end
	--具体时间
	local txt =  WZUILabelTTF:create()
	txt:setName("txtDress_WndItemInfo")
	txt:setText(desc)
	txt:setFontSize(20)
	txt:setColor(ccc3(0,255,100))
	txt:setColor(ccc3(255,89,74))
	txt:setAlignment(kCCTextAlignmentLeft)
	txt:setAnchorPoint(ccp(0,1))
	txt:setRelativePosition(ccp(x+0.2,y-0.01))
	self.m_root:addChild(txt)
	self.m_x,self.m_y = txt:getPosition()
	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "tr" or 
		ProjConfig.LANGUAGE == "es" then
		txt:setRelativePosition(ccp(x+0.3,y-0.01))
		txt:setFontSize(16)
	end
	
	if isUpdate then
		txt:enableSchedule("onAlterTime",1)
	end
	
end

function WndItemInfo:onAlterTime(element)
	if self.m_root == nil or element == nil then
		element:disableSchedule()
	end
	element = WZUILabelTTF:luaTo(element)	
	local desc,isUpdate = self:_getDressUpdateData()
	
	local rePt = element:getRelativePosition()
	local xx,yy = element:getPosition()	
	if isUpdate == false then
		element:disableSchedule()
	end
	element:setText(desc)
	element:setPosition(ccp(self.m_x,self.m_y))
end

function WndItemInfo:_getDressUpdateData()
	WZLog("WndItemInfo:_getDressUpdateData")
	local t = self.m_tEquip.lastTime
	local NTIME = 60
	if t == nil then return end
	local desc = ""
	local isUpdate = false 
	local tt = t - (os.time() - SETITEMSTIME)
	if tt == 0 then
		isUpdate = false 
		desc = "REMAIN_TIME:0"..LocalStrings.SECOND
	elseif tt < 0 then
		isUpdate = false 
		--desc = LocalStrings.NOLIMIT
		if self.m_tEquip.lastTime == -1 then
			desc = LocalStrings.NOLIMIT
		else
			desc = LocalStrings.MONTH_CARDS_TIP6
		end
	else
		s = tt % NTIME--s
		tt = math.ceil(tt/NTIME)
		m = tt % NTIME--m
		tt = math.ceil(tt/NTIME)
		h = tt % 24--h
		tt = math.ceil(tt/24)
		d = tt --d
		local tip = LocalStrings.REMAIN_TIME--剩余时间:
		if t == 0 then
			tip = LocalStrings.AGING--"时效:"--时效
		end
		tip = ""
		if d > 0 then
			isUpdate = false 
			desc = string.format(tip.."%d"..LocalStrings.DAY,d)
		else
			isUpdate = true 
			if h > 0 then 
				local ds = tip.."%d%s%d%s%d%s"
				desc = string.format(ds,h,LocalStrings.HOUR,m,LocalStrings.MINUTE,s,LocalStrings.SECOND)
			elseif m > 0 then
				local ds = tip.."%d%s%d%s"
				desc = string.format(ds,m,LocalStrings.MINUTE,s,LocalStrings.SECOND)
			else 
				local ds = tip.."%d%s"
				desc = string.format(ds,s,LocalStrings.SECOND)
			end
		end
	end
	return desc,isUpdate
end

--时效装备倒计时
function WndItemInfo:_showEquipTimeOut()
	WZLog("WndItemInfo:_showEquipTimeOut:")
	if self.m_root == nil or self.m_tEquip == nil then return end
	local main_type = self.m_tEquip.main_type
	if main_type ~= MAIN_EQUIT_TYPE then return end
	if self.m_tEquip.basicInfo.time_limit == -1 then return end

	self.m_nLineH = self.m_nLineH + 10
	local desc , isUpdate = self:_getEquipUpdateData()
	local x = DIRX
	local y,h = self:_getAllHeight()
	--时效:
	if desc ~= nil and desc ~= "" then
		local txt =  WZUILabelTTF:create()
		txt:setText(LocalStrings.AGING..":")
		txt:setFontSize(22)
		txt:setColor(ccc3(127,70,26))
		txt:setAlignment(kCCTextAlignmentLeft)
		txt:setAnchorPoint(ccp(0,1))
		txt:setRelativePosition(ccp(x,y))
		self.m_root:addChild(txt)
	end
	--具体时间
	local txt =  WZUILabelTTF:create()
	txt:setName("txtDress_WndItemInfo")
	txt:setText(desc)
	txt:setFontSize(20)
	txt:setColor(ccc3(0,255,100))
	txt:setColor(ccc3(255,89,74))
	txt:setAlignment(kCCTextAlignmentLeft)
	txt:setAnchorPoint(ccp(0,1))
	txt:setRelativePosition(ccp(x+0.2,y-0.01))
	self.m_root:addChild(txt)
	self.m_x,self.m_y = txt:getPosition()
	
	
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "vn" then
		txt:setRelativePosition(ccp(x+0.3,y-0.01))
	end
	if isUpdate then
		txt:enableSchedule("onAlterEquipTime",1)
	end
end

function WndItemInfo:onAlterEquipTime(element)
	if self.m_root == nil or element == nil then
		element:disableSchedule()
	end
	element = WZUILabelTTF:luaTo(element)	
	local desc,isUpdate = self:_getEquipUpdateData()
	
	local rePt = element:getRelativePosition()
	local xx,yy = element:getPosition()	
	if isUpdate == false then
		element:disableSchedule()
		self.m_root:removeFromParentAndCleanup(true)
	end
	element:setText(desc)
	element:setPosition(ccp(self.m_x,self.m_y))
end

function WndItemInfo:_getEquipUpdateData()
	local t = self.m_tEquip.lastTime
	local receiveTime = self.m_tEquip.receiveTime
	local NTIME = 60
	if t == nil then return end
	local desc = ""
	local isUpdate = false 
	local tt = t - (SystemTime:getServerTime() - receiveTime)
	WZLog("WndItemInfo:_getEquipUpdateData", t, tt)
	if tt == 0 then
		isUpdate = false 
		desc = "REMAIN_TIME:0"..LocalStrings.SECOND
	elseif tt < 0 then
		isUpdate = false 
		--desc = LocalStrings.NOLIMIT
		if self.m_tEquip.lastTime == -1 then
			desc = LocalStrings.NOLIMIT
		end
	else
		s = tt % NTIME--s
		tt = math.floor(tt/NTIME)
		m = tt % NTIME--m
		tt = math.floor(tt/NTIME)
		h = tt % 24--h
		tt = math.floor(tt/24)
		d = tt --d
		local tip = LocalStrings.REMAIN_TIME--剩余时间:
		if t == 0 then
			tip = LocalStrings.AGING--"时效:"--时效
		end
		tip = ""
		if d > 0 then
			isUpdate = false 
			desc = string.format(tip.."%d"..LocalStrings.DAY,d)
		else
			isUpdate = true 
			if h > 0 then 
				local ds = tip.."%d%s%d%s%d%s"
				desc = string.format(ds,h,LocalStrings.HOUR,m,LocalStrings.MINUTE,s,LocalStrings.SECOND)
			elseif m > 0 then
				local ds = tip.."%d%s%d%s"
				desc = string.format(ds,m,LocalStrings.MINUTE,s,LocalStrings.SECOND)
			else 
				local ds = tip.."%d%s"
				desc = string.format(ds,s,LocalStrings.SECOND)
			end
		end
	end
	WZLog("装备时效", desc, isUpdate)
	return desc,isUpdate
end

--@brief	物品说明
function WndItemInfo:_showItemExplain()
	if self.m_root == nil or self.m_tEquip == nil or self.m_tEquip.basicInfo == nil then
		return
	end

	local x = self:_getItemIconX()
	local y = self:_getAllHeight() - 0.13
	local dir = 2
	local con = WZUIContainer:create()
	con:setName("conItemExplain_WndItemInfo")
	con:setUseAbsSize(true)
	con:setAbsContentSize(self.m_ItemExpSize)
	con:setAnchorPoint(ccp(0,1))
	con:setRelativePosition(ccp(x-0.008,y))
	self.m_root:addChild(con)
	x = dir/self.m_ItemExpSize.width
	y = 1-dir/self.m_ItemExpSize.height
	local txtDesc = WZUILabelTTF:create()
	txtDesc:setText(self.m_tEquip.basicInfo.desc or "")
	txtDesc:setAnchorPoint(ccp(0,1))
	txtDesc:setRelativePosition(ccp(x,y))
	txtDesc:setAlignment(kCCTextAlignmentLeft)
	txtDesc:setFontSize(20)
	txtDesc:setBoldFont(true)
	txtDesc:setColor(ccc3(127,70,26))
	txtDesc:setDimensions(CCSize(self.m_ItemExpSize.width-dir,0))
	if self.m_nState ~= nil and self.m_nState > 0 then
		txtDesc:setDimensions(CCSize(stateDescLen[self.m_nState],0))
	end
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "tr" or 
		ProjConfig.LANGUAGE == "es" then
		txtDesc:setFontSize(16)
	elseif ProjConfig.LANGUAGE == "en" then
		txtDesc:setFontSize(18)
	end
	con:addChild(txtDesc)
	self.m_nLineExitH = 1

	--描述超过2行时增加总高度
	local conSize = txtDesc:getContentSize()
	local nTempRow = 3
	if conSize.height > 130 then 
		nTempRow = 5
	end
	local extraHeight = conSize.height > 16*nTempRow and conSize.height - 16*nTempRow or 0--(math.ceil(ChineseStringLen(self.m_tEquip.basicInfo.desc)/DESCROWLEN) - 2) * 16
--	WZLog("WndItemInfo:_showItemExplain", nTempRow, extraHeight, conSize.height, tostring(self.m_nState), self.m_ItemExpSize.width-dir)
	if extraHeight > 0 then
		self.m_nLineH = self.m_nLineH + extraHeight 
	end
	
	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" then
		if extraHeight > 0 then
			self.m_nLineH = self.m_nLineH - extraHeight*0.66
		end
		if self.m_tEquip.basicInfo.id == 51 then self.m_nLineH = self.m_nLineH + 15 end
	end
	if ProjConfig.LANGUAGE == "th" then
		txtDesc:setFontSize(18)
	end
end

--@brief	礼包可获得物品
function WndItemInfo:_showPacks()
	if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil or self.m_tEquip.basicInfo.main_type ~= 3 and self.m_tEquip.basicInfo.main_type ~= 17 then return end
	if self.m_tEquip.basicInfo.main_type == 17 and self.m_tEquip.basicInfo.sub_type ~= 5 then return end
	if self.m_tEquip.basicInfo.main_type == 3 and self.m_tEquip.basicInfo.sub_type == 4 then return end
	local x = DIRX
	local y = self:_getAllHeight()
	local desc = {LocalStrings.BAGTIP7,LocalStrings.BAGTIP8,LocalStrings.BAGTIP7,LocalStrings.BAGTIP8}
	local sub_type = self.m_tEquip.basicInfo.sub_type
	local txt = self:_createTTF(desc[sub_type+1],GlobalMethod:ccp(x,y),nil,GlobalMethod:ccc3(127,70,26),20,nil,GlobalMethod:CCSize(365,0))
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "en" then
		txt:setFontSize(16)
	end
	self.m_root:addChild(txt)
	self.m_nLineH = self.m_nLineH + 35
	
	self:_showLineOne()--创建线条
	
	self.m_nLineH = self.m_nLineH + 14

	local y = self:_getAllHeight()
	local sex = CacheCenter:getPlayerInfo().sex
	local giftList = {}
	local sexIndex = {"man_item_id","woman_item_id"}
	local quality = g_tQualityRect
	local countLimit = {}
	for k,v in pairs(GDatatab_gifts) do
		if v.item_id ==  self.m_tEquip.basicInfo.id then
			local temp = {}
			temp.id = v[sexIndex[sex+1]]
			temp.count = v["count"]
			temp.quality = GDatatab_item["id_"..v[sexIndex[sex+1]]].quality
			temp.main_type = GDatatab_item["id_"..v[sexIndex[sex+1]]].main_type
			temp.sub_type = GDatatab_item["id_"..v[sexIndex[sex+1]]].sub_type
			if sub_type == 0 or sub_type == 2 and temp.id ~= 1 and temp.id ~= 2 then
				WZLog("显示礼包",v.id,temp.id)
				table.insert(giftList,temp)
			else
				-- --如果礼包没重复才显示
				local reapeat = false
				for k=1,#giftList do
					if giftList[k].id == temp.id then
						giftList[k].count = 0
						reapeat = true
						break
					end
				end
				if reapeat == false then
					table.insert(giftList,temp)
				end
			end
		end
	end
	table.sort(giftList,sortGift)
	if #giftList == 0 then return end
	local column = 9
	local gridScale = 0.7
	local rowCount = math.ceil(#giftList/column)
	self.m_nGiftNum = #giftList
	for i=1,#giftList do
		gridScale = 0.75
		local isUse = false
		local tData = GDatatab_item["id_"..giftList[i].id]
		local relativePosition = GlobalMethod:ccp(0.196*((i-1)%column)+0.126,y-0.12-math.floor((i-1)/column)*0.3)
		--创建底图
		local imgBg = self:_createImage("ui/common/common_scale9_beibaodi2.png",relativePosition)--添加背景
		imgBg:setScale(gridScale*0.9)
		self.m_root:addChild(imgBg)
		--创建品质框
		local imgQuality = self:_createImage(quality[tData.quality],relativePosition)--添加背景
		imgQuality:setScale(gridScale)
		self.m_root:addChild(imgQuality)
		--创建物品图片
		local img
		
		if tData.id >= 2001 and tData.id <= 2162 then
			img = WZUIContainer:create()
			img:setUseAbsSize(true)
			img:setAbsContentSize(CCSize(80,80))
	        img:setRelativePosition(relativePosition)
			spine = WZUISpine:create()
	        spine:setLoop(true)
	        spine:setTouchEnable(false)
	        spine:setFileJson("ui/ui_qifu.json")
	        spine:setFileAtlas("ui/ui_qifu.atlas")
	        spine:setAnimationName(tData.icon)
			spine:setUseOriginSize(true)
	        img:addChild(spine)
		else
			img = self:_createImage(tData.icon,relativePosition,"imgItem_WndItemInfo")
			img:setUseOriginSize(true)
		end
		if tData.id >= 1135 and tData.id <= 1146 and tData.id ~= 1140 then
			gridScale = 0.45
		end
		if tData.main_type == 38 and tData.sub_type <= 8 then
			gridScale = 0.4
		end
		img:setUseOriginSize(true)
		img:setScale(gridScale)
		if tData.main_type == 25 and (tData.sub_type == 3 or tData.sub_type == 4) then 
			img:setScaleY(0.58)
			img:setScaleX(0.35)
		elseif tData.main_type == 25 and tData.sub_type == 1 then 
			img:setScaleY(0.5)
			img:setScaleX(0.4)
		end
		self.m_root:addChild(img)
		--创建套装按钮
		local btn = self:_createSuitBtn("giftBtn"..i,relativePosition,"clickGift",tData.id)
		self.m_root:addChild(btn)

		--装备碎片加碎片标志
		if tData.main_type == 9 then
			WZLog("礼包里的碎片", tData.name)
			local relativePosition = GlobalMethod:ccp(0.196*((i-1)%column)+0.18,y-0.05-math.floor((i-1)/column)*0.32)
			local img = self:_createImage("ui/common/common_icon_suipian.png",relativePosition)
			img:setUseOriginSize(true)
			img:setScale(0.7)
			self.m_root:addChild(img)
		end
		--数字
		local main_type = tData.main_type
		if giftList[i].count ~= 0 then
			if main_type ~= 5 and main_type ~= 31 then
				local ttf = WZUILabelTTF:create()
				ttf:setText(giftList[i].count)
				ttf:setAnchorPoint(ccp(1,0))
				ttf:setRelativePosition(ccp(0.92,0.02))
				ttf:setColor(ccc3(255,255,255))
				ttf:setFontSize(24)
				ttf:setAlignment(kCCTextAlignmentRight)
				ttf:setEnableStroke(true)
				ttf:setStrokeColor(ccc3(79,60,48))
				ttf:setStrokeSize(2)
				ttf:setBoldFont(true)
				
				ttf:setScale(0.75)
				btn:addChild(ttf,100,0)
				if main_type == 25 then 
					ttf:setScale(1.2)
				end
			end
		end
		--显示
		if giftList[i].count ~= 0 then
			if main_type == 5 or main_type == 31 then
				--计算剩余天数
				local countdown = tonumber(giftList[i].count)
				local count

				if countdown ~= nil and countdown ~= 0 then
					if countdown == -1 then
						local cornerIcon = WZUIImage:create()
						cornerIcon:setAnchorPoint(ccp(0,1))
						cornerIcon:setRelativePosition(ccp(-0.03,1.03))
						cornerIcon:setUseOriginSize(true)
						cornerIcon:setFile("ui/common/common_icon_yongjiu.png")
						img:addChild(cornerIcon, 2000)
					elseif tonumber(countdown) > 86400 then
						count = math.ceil(countdown/86400)
					--elseif tonumber(countdown) < 40 then
					--	count = 1
					else 
						count = countdown
					end

					if countdown ~= -1 then
						count = giftList[i].count
						local cornerIcon = WZUIImage:create()
						cornerIcon:setAnchorPoint(ccp(0,1))
						cornerIcon:setRelativePosition(ccp(-0.03,1.03))
						cornerIcon:setUseOriginSize(true)
						cornerIcon:setFile("ui/common/common_icon_ts.png")
						img:addChild(cornerIcon, 2000)
						--天
						local imgDay = WZUIImage:create()
						imgDay:setRelativePosition(ccp(0.483333,0.784848))
						imgDay:setFile("ui/common/common_icon_ts2.png")
						imgDay:setUseOriginSize(true)
						imgDay:setRotation(-45)
						cornerIcon:addChild(imgDay,1)
						--天数
						local txtDayNum = WZUILabelAtlasFont:create()
						txtDayNum:setRelativePosition(ccp(0.266667,0.569697))
						txtDayNum:setCharMapFileName("ui/common_num/common_num_ts.png")
						txtDayNum:setHeight(18)
						txtDayNum:setWidth(12)
						txtDayNum:setText(count)
						txtDayNum:setRotation(-45)
						txtDayNum:setUseOriginSize(true)
						cornerIcon:addChild(txtDayNum,1)
					end
				end
			end
		end
	end

	self.m_nLineH = self.m_nLineH + 60.5*rowCount
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "es" then
		self.m_nLineH = self.m_nLineH + 40
	end
end

function WndItemInfo:clickGift(element)
	WZLog("WndItemInfo:clickGift", element:getTag())
	local itemId = tonumber(element:getTag())
	local tData = {id=itemId,basicInfo=GDatatab_item["id_"..itemId]}
	if tData.basicInfo.main_type == 43 then 
		tData.origin = 51007
	end
	WndItemInfo:_onCloseClick()
	WndItemInfo.m_root = nil

	WndItemInfo:showInfo(self.m_tLua[1],self.m_tLua[2],1, tData, false)
end

--@brief  礼包按品质排序
function sortGift(a,b)
	if type(a) == "number" then return false end
	if a.quality ~= b.quality then
		return a.quality >= b.quality
	elseif a.count ~= b.count then
		return a.count < b.count
	else
		return a.id < b.id 
	end
end

--@brief	物品属性
function WndItemInfo:_showItemPro()
	local main_type = self.m_tEquip.basicInfo.main_type
	local sub_type = self.m_tEquip.basicInfo.sub_type
	if main_type == 3 and sub_type == 4 then return end
	if main_type == 9 and sub_type == 3 then return end
	if main_type == 9 and sub_type == 0 then return end
	if main_type == 9 and sub_type == 4 then return end
	if main_type == 9 and sub_type == 5 then return end
	if main_type == 25 and (sub_type ~= 1 and sub_type ~= 3) then return end
	local x = DIRX
	--时装显示当前颜色
	if self.m_tEquip.basicInfo.main_type == 5 and self.m_tEquip.color ~= nil then
		local value1 = LocalStrings.BAGTIP42
		local value2 = LocalStrings.BAGTIP25..self.m_tEquip.color
		local value3 = ""
		if tonumber(self.m_tEquip.color) == 0 then value2 = LocalStrings.BAGTIP18 end
		local color1 = ccc3(127,70,26)
		local color2 = ccc3(127,70,26)
		local color3 = ccc3(5,180,0)
		local font1,font2,font3 = 20,20,20
		self:_showLineOne()--创建线条
		self.m_nLineH = self.m_nLineH + 6
		local y = self:_getAllHeight()
		self:_createColorTxt(self:_checkExp(value1,value2,value3,color1,color2,color3,font1,font2,font3),sName,ccp(x,y))
		self.m_nLineH = self.m_nLineH + 20
	end

	if main_type == MAIN_PROPS_TYPE and (sub_type == 12 or sub_type == 13) then
		return
	end 
	local tData, tData2 = self:_getPropertyData()
	if tData == nil then return end
	if #tData ~= 0 then
		self:_showLineOne()--创建线条
		self.m_nLineH = self.m_nLineH + 5
	end
	WZLog("WndItemInfo:_showItemPro", Serialize(tData))
	local y = self:_getAllHeight()
	self.m_nItemProHeight = 0
	local h = 0 
	local proCount = math.ceil(#tData/2)
	local nIndex = 1
	for i = 1, proCount do
		local data = tData[nIndex]
		if data then 
			local sName = string.format("txtItemPro%d_WndItemInfo",i)
			self:_createColorTxt(data,sName,ccp(x,y))

			nIndex = nIndex + 1
		end

		data = tData[nIndex]
		if data then 
			local sName = string.format("txtItemPro%d_WndItemInfo",i)
			self:_createColorTxt(data,sName,ccp(x + 0.6, y))

			nIndex = nIndex + 1
		end
		h = 20
		y = y - h/self:_getWinSize().height
		self.m_nItemProHeight = self.m_nItemProHeight + h 
	end
	--花盆土坑属性
	local proNameIndex = #tData
	if tData2 and #tData2 > 0 then 
		self:_showLineOne()--创建线条
		self.m_nLineH = self.m_nLineH + 5
		local y2 = self:_getAllHeight()
		local h2 = 0 
		local proCount2 = math.ceil(#tData2/2)
		local nIndex2 = 1
		for i = 1, proCount2 do
			proNameIndex = proNameIndex + 1
			local data = tData2[nIndex2]
			if data then 
				local sName = string.format("txtItemPro%d_WndItemInfo", proNameIndex)
				self:_createColorTxt(data,sName,ccp(x,y2))

				nIndex2 = nIndex2 + 1
			end

			proNameIndex = proNameIndex + 1
			data = tData2[nIndex2]
			if data then 
				local sName = string.format("txtItemPro%d_WndItemInfo", proNameIndex)
				self:_createColorTxt(data,sName,ccp(x + 0.6, y2))

				nIndex2 = nIndex2 + 1
			end
			h2 = 20
			y2 = y2 - h2/self:_getWinSize().height
			self.m_nItemProHeight = self.m_nItemProHeight + h2 
		end
	end
	self.m_nLineH = self.m_nLineH + 0

	--宠物显示资质
	if main_type == 10 and sub_type == 1 then 
		local minGift, maxGift
  		for k,v in pairs(GDatatab_pet) do
    		if v.item_id == self.m_tEquip.basicInfo.id then
    	   	 	minGift = v.gift[1][1]
    	    	maxGift = v.gift[1][2]
    	    	break
    		end
  		end
		if minGift ~= nil and maxGift ~= nil then
			local value1 = LocalStrings.PET_1..":"
			local value2 = "("..minGift.."-"..maxGift..")"
			local value3 = ""
			local color1 = ccc3(127,70,26)
			local color2 = ccc3(127,70,26)
			local color3 = ccc3(5,180,0)
			local font1,font2,font3 = 20,20,20
			local y = self:_getAllHeight()
			self:_createColorTxt(self:_checkExp(value1,value2,value3,color1,color2,color3,font1,font2,font3),sName,ccp(x,y))
			self.m_nLineH = self.m_nLineH + 20
		end
	end
end

--@brief	翅膀物品额外属性
function WndItemInfo:_showWingExtraPro()
	local main_type = self.m_tEquip.basicInfo.main_type
	local sub_type = self.m_tEquip.basicInfo.sub_type
	if main_type == 3 and sub_type == 4 then return end
	if main_type == 9 and sub_type == 3 then return end
	if main_type == 9 and sub_type == 0 then return end
	if main_type == 25 and (sub_type ~= 1 and sub_type ~= 3) then return end
	if main_type == MAIN_PROPS_TYPE and (sub_type == 12 or sub_type == 13) then	return end 


	local tPro = -1
	local itemId = self.m_tEquip.basicInfo.id
	if main_type == 9 and sub_type == 2 then 
		local mergeInfo = GDatatab_itemmerge["id_" .. itemId]
		if mergeInfo then 
			local tempInfo = GDatatab_item["id_" .. mergeInfo.items[1][1]]
			if tempInfo.main_type == 5 and tempInfo.sub_type == 3 then  
				itemId = mergeInfo.items[1][1]
			end
		end
	end
	local suitId = nil 
	for i, v in pairs(GDatatab_enchanting) do
		if v.item_id3 == itemId then
			tPro = v.property2
			suitId = v.id
			break
		end
	end
	local bIsHost = true --是否是自己
	--获取已进阶的套装Id
	local havedAdvanceIds = CacheCenter:getWingAdvanceId()
	--如果是在玩家信息界面，需要显示当前玩家的相应状态
	if WndCheckOther.m_root and not WndCheckOther.m_bIsHost then 
		bIsHost = false 
		havedAdvanceIds = WndCheckOther:getWingAdvanceId()
	end
	--进阶属性
	local afterPro = {}
	if suitId and utilsValueInTable(suitId, havedAdvanceIds) then 
		local tData = GDatatab_enchanting["id_" .. suitId]
		if tPro ~= -1 then 
			afterPro = CopyTable(tPro)
		end
		for i = 1, #tData.wing_property do
			local bIsExist = false 
			for j = 1, #afterPro do
				if afterPro[j][1] == tData.wing_property[i][1] then 
					afterPro[j][2] = afterPro[j][2] + tData.wing_property[i][2]
					bIsExist = true
					break 
				end
			end
			if not bIsExist then 
				table.insert(afterPro, tData.wing_property[i])
			end
		end
	else
		afterPro = tPro
	end

	local tData = {}
	if type(afterPro) == "table" then
		for i,data in pairs(afterPro) do
			if data[1] <= 20 then
				local value1 = ATTR_TITLE[tonumber(data[1])]..":"
				local value2 = data[2]
				local value3 = ""
				local color1 = ccc3(127,70,26)
				local color2 = ccc3(127,70,26)
				local color3 = ccc3(5,180,0)
				local font1 = 20
				local font2 = 20
				local font3 = 20
				table.insert(tData,self:_checkExp(value1,value2,value3,color1,color2,color3,font1,font2,font3))
			end
		end
	end

	if #tData ~= 0 then
		self:_showLineOne()--创建线条
		self.m_nLineH = self.m_nLineH + 5

		local value1 = LocalStrings.ADDITIONAL_ATTRIBUTE2..":"
		local value2 = ""
		local value3 = ""
		local color1 = ccc3(127,70,26)
		local color2 = ccc3(127,70,26)
		local color3 = ccc3(5,180,0)
		local font1,font2,font3 = 20,20,20
		local x = DIRX
		local y = self:_getAllHeight()
		self:_createColorTxt(self:_checkExp(value1,value2,value3,color1,color2,color3,font1,font2,font3),sName,ccp(x,y))
		self.m_nLineH = self.m_nLineH + 20

		local y = self:_getAllHeight()
		self.m_nItemProHeight = self.m_nItemProHeight or 0
		local h = 0
		local proCount = math.ceil(#tData/2)
		local nIndex = 1
		for i = 1, proCount do
			local data = tData[nIndex]
			if data then
				local sName = string.format("txtWingPro%d_WndItemInfo",i)
				self:_createColorTxt(data,sName,ccp(x,y))

				nIndex = nIndex + 1
			end

			data = tData[nIndex]
			if data then
				local sName = string.format("txtWingPro%d_WndItemInfo",i)
				self:_createColorTxt(data,sName,ccp(x + 0.6, y))

				nIndex = nIndex + 1
			end
			h = 20
			y = y - h/self:_getWinSize().height
			self.m_nItemProHeight = self.m_nItemProHeight + h
		end
	end
end

--@brief	宠物武器技能
function WndItemInfo:_showItemExtraPro()
	local main_type = self.m_tEquip.basicInfo.main_type
	local sub_type = self.m_tEquip.basicInfo.sub_type
	if main_type ~= 43 then return end

	local x = DIRX
	local y = self:_getAllHeight()
	local h = 0
	h = 20
	y = y - h/self:_getWinSize().height


	-- 1 : 生命+%s
	-- 3 : 攻击+%s
	-- 4 : 防御+%s
	-- 1001 : 宠物生命增加+%s%%
	-- 1003 : 宠物攻击增加+%s%%
	-- 1004 : 宠物防御增加+%s%%
	-- 102 : 宠物攻击时获得%s怒气
	-- 103 : 宠物攻击时减少敌人%s怒气
	-- 106 : 宠物资质+%s
	-- 104 : %s%%概率抵抗中毒
	-- 105 : %s%%概率抵抗流血

	--宠物装备数据属性
	local strRandAttr = LocalStrings.PET_EQUIPMENT_8
	local randAttr = self.m_tEquip.extraInfo.randAttr
	if not randAttr and self.m_tEquip.playerItemId and self.m_tEquip.playerItemId > 0 then
		local itemData = CacheCenter:getPlayerItemByPlayerItemId(self.m_tEquip.playerItemId)	

		if itemData then 
			randAttr = itemData.extraInfo.randAttr
		end
	end
	if randAttr then 
		for k,v in pairs(randAttr) do
			local tPetRandom = WndItemInfo:getPetEquipDescByType(k)
			if tPetRandom then
				local nValue = v
				if tonumber(k) == 106 or tonumber(k) == 105 or tonumber(k) == 104 or (tonumber(k) >= 110 and tonumber(k) <= 132 and tonumber(k) ~= 118) then
					nValue = nValue / 100
				end
				strRandAttr = string.format(tPetRandom,nValue)
			end
		end
	end
	local content = {value1=strRandAttr,font1=20,color1=ccc3(127,70,26)}
	local sName = "txtItemExtraPro_WndItemInfo"
	local txtA = self:_createColorTxt(content,sName,ccp(x,y), 370)
	if self.m_nState and self.m_nState > 0 then 
		txtA:setDimensions(GlobalMethod:CCSize(370, 0))
	else
		txtA:setDimensions(GlobalMethod:CCSize(305, 0))
	end
	local nTempH = txtA:getContentSize().height
	if not randAttr then 
		local pos = txtA:getRelativePosition()

		local btn = WZUIButton:create()
		local imgNor = WZUI9Image:create()
		imgNor:setFile("ui/common/common_icon_bz.png")
		imgNor:setScale(0.7)
		imgNor:setUseOriginSize(true)
		local imgSel = WZUI9Image:create()
		imgSel:setScale(0.75)
		imgSel:setFile("ui/common/common_icon_bz.png")
		imgSel:setUseOriginSize(true)
		btn:setNormalElement(imgNor)
		btn:setSelectElement(imgSel)
		btn:setName("btnRandomPro_WndItemInfo")
        btn:setLuaDoneFunctionName("onRandomTip")
		btn:setRelativePosition(GlobalMethod:ccp(pos.x + 0.7, pos.y - 0.05))
		btn:setUseAbsSize(true)
		btn:setAbsContentSize(GlobalMethod:CCSize(40,40))
		self.m_root:addChild(btn)
		WZLog("WndItemInfo:_showItemExtraPro", tostring(self.m_tEquip.randomBtnVisible))
		if self.m_tEquip.randomBtnVisible ~= nil then 
			btn:setVisible(self.m_tEquip.randomBtnVisible)
		end 
	end

	self:_showLineOne()
	self.m_nLineH = self.m_nLineH + nTempH + 10

	self:_showLineOne()

end

--@brief	获取描述
function WndItemInfo:getPetEquipDescByType(nType)
	local strWord = ""
	for k,v in pairs(GDatatab_pet_random) do
		if v.type == tonumber(nType) then
			return v.desc
		end
	end
end

--@brief	武器技能
function WndItemInfo:_showPowerSkill()
	local power_skill
	if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil then
		return
	elseif self.m_tEquip.extraInfo.weaponskill == nil or self.m_tEquip.extraInfo.weaponskill == "" then
		return
	elseif self.m_tEquip.basicInfo.power_skill ~= nil and self.m_tEquip.basicInfo.power_skill ~= -1 then
		if self.m_tEquip.extraInfo.weaponskill == nil then
			power_skill = self.m_tEquip.basicInfo.power_skill
		else
			local weaponskill = SplitStringWithSeparator(self.m_tEquip.extraInfo.weaponskill,"|")
			power_skill = {weaponskill}
		end
	elseif self.m_tEquip.basicInfo.main_type == 9 then --装备碎片
	--装备碎片取合成的装备的属性
		power_skill = GDatatab_item["id_"..GDatatab_itemmerge["id_"..self.m_tEquip.basicInfo.id].items[1][1]].power_skill
	elseif self.m_tEquip.basicInfo.power_skill == nil or self.m_tEquip.basicInfo.power_skill == -1 then
		return
	end
	if power_skill == nil or type(power_skill) == "number" then return end
	self:_addBlankHeight(15)
	self.m_nPowerSkillH = 0
	local x = DIRX - 0.01
	local y = self:_getAllHeight()
	local tSkill = {}
	WZLog("WndItemInfo:_showPowerSkill()::",self:_getWinSize().height,self:_getWinSize().width)
	for i,data in pairs(power_skill) do
		for k,v in pairs(data) do 
			WZLog("技能:k,v:",k,v)
			if GDatatab_skill["id_"..v] then 
				table.insert(tSkill,GDatatab_skill["id_"..v].icon)
				table.insert(tSkill,GDatatab_skill["id_"..v].lv_icon)
				table.insert(tSkill,GDatatab_skill["id_"..v].tool_desc)
			end
		end
	end
	local h = 0 
	for i,data in pairs(tSkill) do 
		if i%3 == 1 then
			local img = self:_createImage(data,ccp(x,y-0.12),string.format("skillIcon%d_WndItemInfo",i),ccp(0,0),nil,true)
			img:setScale(0.48)
			self.m_root:addChild(img)
		end
		if i%3 == 2 then
			local img = self:_createImage(data,ccp(x+0.04,y-0.106),string.format("skillLvIcon%d_WndItemInfo",i),ccp(0,0),nil,true)
			img:setScale(0.48)
			self.m_root:addChild(img)
		end
		local font = 18
		local color = ccc3(0,246,34)
		if i%3 == 0 then
			color = ccc3(127,70,26)
			font = 18
			
			if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or 
				ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "tr" or 
				ProjConfig.LANGUAGE == "es" then
				font = 16
			end
			
			local txt = self:_createTTF(data,ccp(x+0.12,y),ccp(0,1),color,font,string.format("powerskill%d_WndItemInfo",i),CCSize(420,0))
			self.m_root:addChild(txt)
			h = txt:getContentSize().height + 4
			self.m_nPowerSkillH = self.m_nPowerSkillH + h
			y = y - h/self:_getWinSize().height
		end
	end
end

--@brief	显示装备套装
function WndItemInfo:_showSuit()
	if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil or self.m_tEquip.basicInfo.icon == nil then
		return
	end
	WZLog("创建套装图标")
	local id = self.m_tEquip.basicInfo.id
	local showQuality = self.m_tEquip.basicInfo.quality
	--装备碎片取合成的装备的属性
	if self.m_tEquip.basicInfo.main_type == 9 then
		id = GDatatab_item["id_"..GDatatab_itemmerge["id_"..self.m_tEquip.basicInfo.id].items[1][1]].id 
	end
	local tempInfo = GDatatab_item["id_"..id]
	local isSuit = false
	local suitID = {}
	if tempInfo.main_type == 4 then
		for k,v in pairs(GDatatab_item_suit) do
			for i=1,7 do
				if tonumber(id) % 10000 == tonumber(v.item_list[1][i]) then
					isSuit = true
					suitID = v
				end
			end
		end
	end
	if isSuit == false then return end

	self:_showLineOne()--创建线条

	if self.m_root:getChildByTag(1060) then
		self.m_root:removeChildByTag(1060,true)
	end

	local position = {"bracelet_id","talisman_id","medal_id","ring_id","necklace_id","eardrop_id"}
	local quality = {"ui/common/frame_green.png","ui/common/frame_bule.png","ui/common/frame_violet.png","ui/common/frame_orange.png","ui/common/frame_red.png"}
	local equipList
	local itemSuitNum = 0
	local strong_demand = nil
	local star_demand = nil 
	local strongNum = 0
	local starNum = 0

	if WndCheckOther and WndCheckOther.m_root ~= nil then
		equipList = WndCheckOther.m_tPlayerInfo.item
	else
		equipList = CacheCenter:getEquipList()
	end

	--获得套装数量
	for i=1,6 do
		local tData = GDatatab_item["id_"..suitID[position[i]]]

		for k,v in pairs(equipList) do
			if v.id % 10000 == tData.id and v.isUse == true then
				itemSuitNum = itemSuitNum + 1
				if suitID.strong_demand ~= -1 then
					strong_demand = suitID.strong_demand[1]
					if v.extraInfo.strongLevel >= suitID.strong_demand[1][2] and v.basicInfo.quality == 4 then
						strongNum = strongNum + 1
					end
				end
				if suitID.star_demand ~= -1 and v.basicInfo.quality == 4 then
					star_demand = suitID.star_demand[1]
					if v.extraInfo.starLevel >= suitID.star_demand[1][2] and v.basicInfo.quality == 4 then
						starNum = starNum + 1
					end
				end	
			end
		end
	end


	--套装属性
	local x = DIRX

	self.m_nLineH = self.m_nLineH + 16 
	local y = self:_getAllHeight()
    local freeLabel = WZUIFreeTextBox:create()
    freeLabel:setAnchorPoint(GlobalMethod:ccp(0,0.5))
    freeLabel:setRelativePosition(GlobalMethod:ccp(x,y))
    freeLabel:setMaxWidth(340)

    local BAGTIP5 = [[<T C="255,89,74" S="20" P="0">%d件套属性加成(</T><T C="5,180,0" S="20" P="0">%d</T><T C="255,89,74" S="20" P="0">/%d)</T>]]
	local attrList = "suit_3"
	local BAGTIP5 = [[<T C="255,89,74" S="20" P="0">%d món tăng thêm (</T><T C="5,180,0" S="20" P="0">%d</T><T C="255,89,74" S="20" P="0">/%d)</T>]]
	if itemSuitNum < 3 then
    	freeLabel:setShowText(string.format(BAGTIP5,3,itemSuitNum,3))
		attrList = "suit_3"
	elseif itemSuitNum < 5 then
    	freeLabel:setShowText(string.format(LocalStrings.BAGTIP6,3,3,3))
		attrList = "suit_3"
	elseif itemSuitNum < 6 then
		freeLabel:setShowText(string.format(LocalStrings.BAGTIP6,5,5,5))
		attrList = "suit_5"
	else 
		if strong_demand ~= nil and strong_demand ~= -1 then
			WZLog("有强化属性显示",Serialize(star_demand),strongNum,strong_demand[1])
			freeLabel:setShowText(string.format(LocalStrings.BAGTIP6,6,6,6))
			attrList = "suit_6"	
		else 
			freeLabel:setShowText(string.format(LocalStrings.BAGTIP6,5,5,5))
			attrList = "suit_5"		
		end 
		if star_demand ~= nil and star_demand ~= -1 and strongNum == strong_demand[1] then
			WZLog("有升星属性显示")
			freeLabel:setShowText(string.format(LocalStrings.BAGTIP50,6,strong_demand[2],strongNum,strong_demand[1]))
			attrList = "strong_attr"	
		end 	
	end
    self.m_root:addChild(freeLabel)

	self.m_nLineH = self.m_nLineH + 16 
	local y = self:_getAllHeight()
	local fontSize = 20

	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or 
		ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "tr" or 
		ProjConfig.LANGUAGE == "es" then
		fontSize = 16
	end
	if ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "vn" then
		freeLabel:setMaxWidth(680)
	end

	for i,data in pairs(suitID[attrList]) do
		local sName = string.format("txtSuitPro%d_WndItemInfo",i)
		self:_createColorTxt({value1=ATTR_TITLE[data[1]]..":",font1=fontSize,color1=ccc3(127,70,26),value2=data[2],font2=fontSize,color2=ccc3(127,70,26)},sName,ccp(x,y),360)
		y = y - 25/self:_getWinSize().height
		self.m_nLineH = self.m_nLineH + 23 
	end

	self.m_nLineH = self.m_nLineH + 14 
	local y = self:_getAllHeight()
    local freeLabel = WZUIFreeTextBox:create()
    freeLabel:setAnchorPoint(GlobalMethod:ccp(0,0.5))
    freeLabel:setRelativePosition(GlobalMethod:ccp(x,y))
    freeLabel:setMaxWidth(340)

    if ProjConfig.LANGUAGE == "th" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "vn" then
		freeLabel:setMaxWidth(680)
	end
	
	if itemSuitNum < 3 then
    	freeLabel:setShowText(string.format(BAGTIP5,5,itemSuitNum,5))
		attrList = "suit_5"
	elseif itemSuitNum < 5 then
    	freeLabel:setShowText(string.format(BAGTIP5,5,itemSuitNum,5))
		attrList = "suit_5"
	elseif itemSuitNum < 6 then
    	freeLabel:setShowText(string.format(BAGTIP5,6,itemSuitNum,6))
		attrList = "suit_6"
	else
		if  strong_demand ~= nil and strong_demand ~= -1 then
			freeLabel:setShowText(string.format(LocalStrings.BAGTIP50,6,strong_demand[2],strongNum,strong_demand[1]))
			attrList = "strong_attr"
		else
		    freeLabel:setShowText(string.format(LocalStrings.BAGTIP6,6,6,6))
			attrList = "suit_6" 
		end
		if star_demand ~= nil and star_demand ~= -1 and strongNum >= strong_demand[1] then
			freeLabel:setShowText(string.format(LocalStrings.BAGTIP51,6,star_demand[2],starNum,strong_demand[1]))
			attrList = "star_attr"
		end
	end
    self.m_root:addChild(freeLabel)

	self.m_nLineH = self.m_nLineH + 16 
	local y = self:_getAllHeight()
	for i,data in pairs(suitID[attrList]) do
		local sName = string.format("txtSuitPro%d_WndItemInfo",i)
		self:_createColorTxt({value1=ATTR_TITLE[data[1]]..":",font1=fontSize,color1=ccc3(127,70,26),value2=data[2],font2=fontSize,color2=ccc3(127,70,26)},sName,ccp(x,y))
		y = y - 25/self:_getWinSize().height
		self.m_nLineH = self.m_nLineH + 23 
	end

	--套装装备图片容器
	y = self:_getAllHeight()
	local sName = "conSuit_WndItemInfo"
	local con = WZUIContainer:create()
	con:setUseAbsSize(true)
	con:setAbsContentSize(CCSize(460,80))
	con:setAnchorPoint(GlobalMethod:ccp(0 ,1))
	con:setTouchEnable(true)
	con:setName(sName)
	con:setRelativePosition(GlobalMethod:ccp(x,y))
	con:setTag(1060)
	self.m_root:addChild(con)

	for i=1,6 do
		local isUse = false
		local tData = GDatatab_item["id_"..suitID[position[i]]]
		local relativePosition = GlobalMethod:ccp(0.155*i-0.083,0.5)
		--创建底图
		local imgBg = self:_createImage("ui/common/common_scale9_beibaodi2.png",relativePosition)--添加背景
		imgBg:setScale(0.79*0.9)
		con:addChild(imgBg)
		--创建品质框
		--local imgQuality = self:_createImage(quality[tData.quality],relativePosition)--添加背景
		local imgQuality = self:_createImage(quality[showQuality],relativePosition)--添加背景
		imgQuality:setScale(0.79)
		con:addChild(imgQuality)
		--创建物品图片
		local img = self:_createImage(tData.icon,relativePosition,"imgItem_WndItemInfo")
		img:setUseOriginSize(true)
		img:setScale(0.79)
		con:addChild(img)
		--创建套装按钮
		local btn = self:_createSuitBtn("suitBtn"..i,relativePosition,"onSuitIcon",tData.id)
		con:addChild(btn)
		for k,v in pairs(equipList) do
			if v.id % 10000 == tData.id and v.isUse == true then
				imgQuality:setFile(quality[v.basicInfo.quality])
				isUse = true
			end
		end
		if isUse and itemSuitNum >= 3 then
			--local ani = BattleAnimation:createAnimation("ui_icon_effect",false,"ui")
    	    --ani:getAnimNode():setUseAbsCoordinate(true)
    	    --ani:getAnimNode():setAbsPosition(GlobalMethod:ccp(-37+71*i,80))
    	    --ani:getAnimNode():setLoop(true)
    	    --ani:getAnimNode():setScale(0.79)
    	    --con:addChild(ani:getAnimNode(),9)

			--local aniName = {"taozhuang_lv","taozhuang_lan","taozhuang_zi","taozhuang_cheng"}
			--ani:play(aniName[tData.quality],true)	
		end
		if isUse == false then
			img:setGrayRender(true)
			imgQuality:setGrayRender(true)
			imgBg:setGrayRender(true)
		end
	end
	self.m_nLineH = self.m_nLineH + 75
end

--@brief	幻化套装
function WndItemInfo:_showPhantomSuit()
	if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil or self.m_tEquip.basicInfo.icon == nil then
		return
	end
	if WndPhantomEquipment:getEquipmentList() == nil then
		return
	end

	if self.m_tEquip.basicInfo.main_type ~= 37 then
		return
	end
	if self.m_tEquip.basicInfo.main_type == 37 and self.m_tEquip.basicInfo.sub_type == 6 then
		return
	end

	local nIndex1 = 0 --套装表id 记录品质
	local nIndex2 = 0 --套装表id 记录类型
	local tSuit = GDatatab_skinequip_suit
	for i=1,GetTableLen(tSuit) do
		if tSuit["id_"..i].type == 0 and tSuit["id_"..i].quality <= self.m_tEquip.basicInfo.quality then
			if i > nIndex1 then
				nIndex1 = i
			end
		end
		if tSuit["id_"..i].type == 1 and tSuit["id_"..i].quality == self.m_tEquip.basicInfo.value then
			nIndex2 = i
		end
	end

	local nMaxQualityCount = 6	--套装品质最大数量
	local nMaxValueCount = 6	--套装类型最大数量
	local nQualityCount = 0		--装备中相同品质数量
	local nValueCount = 0		--装备中相同类型数量
	local tEquipmentList = WndPhantomEquipment:getEquipmentList()
	for i=1,#tEquipmentList do
		if tEquipmentList[i].basicInfo then
			if tEquipmentList[i].basicInfo.quality >= self.m_tEquip.basicInfo.quality then
				nQualityCount = nQualityCount + 1
			end
			if tEquipmentList[i].basicInfo.value == self.m_tEquip.basicInfo.value then
				nValueCount = nValueCount + 1
			end
		end
	end

	self:_showLineOne()--创建线条

	--套装2
	local x = DIRX

	self.m_nLineH = self.m_nLineH + 16
	local y = self:_getAllHeight()
    local freeLabel = WZUIFreeTextBox:create()
    freeLabel:setAnchorPoint(GlobalMethod:ccp(0,0.5))
    freeLabel:setRelativePosition(GlobalMethod:ccp(x,y))
    freeLabel:setMaxWidth(340)

	local color = "5,180,0"
	if nQualityCount == 6 then
		color = "255,89,74"
	end
	local str1 = string.format(LocalStrings.PHANTOM_EQUIPMENT18,tSuit["id_"..nIndex1].name,color,nQualityCount,nMaxQualityCount)
    freeLabel:setShowText(str1)

	if ProjConfig.LANGUAGE == "vn" then
		freeLabel:setScale(0.7)
		freeLabel:setMaxWidth(400)
	end

    self.m_root:addChild(freeLabel)

	--属性1
	self.m_nLineH = self.m_nLineH + 16 
	local y = self:_getAllHeight()
	local fontSize = 20

	local tProperty = tSuit["id_"..nIndex1].property
	for i=1,#tProperty do
		local sName = string.format("txtPhantomSuitPro1_%d_WndItemInfo",i)
		local attrWord = ATTR_TITLE[tProperty[i][2]]
		if tProperty[i][2] == -1 then
			attrWord = LocalStrings.PHANTOM_EQUIPMENT19
		end
		local attrValue = "+"..tProperty[i][3]
		if tProperty[i][1] == 1 then
			attrValue = attrValue.."%"
		end

		self:_createColorTxt({value1=attrWord..":",font1=fontSize,color1=ccc3(127,70,26),value2=attrValue,font2=fontSize,color2=ccc3(127,70,26)},sName,ccp(x,y),360)
		y = y - 25/self:_getWinSize().height
		self.m_nLineH = self.m_nLineH + 23
	end

	if nIndex2 ~= 0 then
		--套装2
		self.m_nLineH = self.m_nLineH + 14 
		local y = self:_getAllHeight()
	    local freeLabel = WZUIFreeTextBox:create()
	    freeLabel:setAnchorPoint(GlobalMethod:ccp(0,0.5))
	    freeLabel:setRelativePosition(GlobalMethod:ccp(x,y))
	    freeLabel:setMaxWidth(340)

		local color = "5,180,0"
		if nValueCount == 6 then
			color = "255,89,74"
		end
		local str1 = string.format(LocalStrings.PHANTOM_EQUIPMENT18,tSuit["id_"..nIndex2].name,color,nValueCount,nMaxValueCount)
	    freeLabel:setShowText(str1)

		if ProjConfig.LANGUAGE == "vn" then
			freeLabel:setScale(0.7)
			freeLabel:setMaxWidth(400)
		end

	    self.m_root:addChild(freeLabel)

		--属性1
		self.m_nLineH = self.m_nLineH + 16 
		local y = self:_getAllHeight()
		local fontSize = 20

		local tProperty = tSuit["id_"..nIndex2].property
		for i=1,#tProperty do
			local sName = string.format("txtPhantomSuitPro2_%d_WndItemInfo",i)
			local attrWord = ATTR_TITLE[tProperty[i][2]]
			if tProperty[i][2] == -1 then
				attrWord = LocalStrings.PHANTOM_EQUIPMENT19
			end
			local attrValue = "+"..tProperty[i][3]
			if tProperty[i][1] == 1 then
				attrValue = attrValue.."%"
			end

			self:_createColorTxt({value1=attrWord..":",font1=fontSize,color1=ccc3(127,70,26),value2=attrValue,font2=fontSize,color2=ccc3(127,70,26)},sName,ccp(x,y),360)
			y = y - 25/self:_getWinSize().height
			self.m_nLineH = self.m_nLineH + 23
		end

	end

end

--@brief	显示时装套装
function WndItemInfo:_showDressSuit()
	if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil or self.m_tEquip.basicInfo.icon == nil then
		return
	end

	local maintype = self.m_tEquip.basicInfo.main_type
	local subtype = self.m_tEquip.basicInfo.sub_type
	if not (maintype == 5 and (subtype == 0 or subtype == 1 or subtype == 2)) then
		return
	end


	local bIsSuit = false --当前时装是否有套装
	local nOwnCount = 0 --套装部件拥有数量
	local nMaxCount = 0 --套装部件最大数量
	local tProperty = nil
	local suitId = nil 
	local bIsFind = false 
	local sex = CacheCenter:getPlayerInfo().sex
	local bIsHost = true --是否是自己
	--获取已进阶的套装Id
	local havedAdvanceIds = CacheCenter:getDressAdvanceId()
	--如果是在玩家信息界面，需要显示当前玩家的相应状态
	if WndCheckOther.m_root and not WndCheckOther.m_bIsHost then 
		sex = WndCheckOther.m_tPlayerInfo.sex
		bIsHost = false 
		havedAdvanceIds = WndCheckOther:getDressAdvanceId()
	end

	for i, v in pairs(GDatatab_enchanting) do

		if v.display ~= -1 then
			local tSuit
			if sex == 0 then 
				tSuit = v.item_id1[1]
			else
				tSuit = v.item_id2[1]
			end
			nOwnCount = 0
			for j = 1, #tSuit do
				if tSuit[j] == self.m_tEquip.basicInfo.id and v.property then
					bIsFind = true 
					if v.property ~= -1 then 
						bIsSuit = true
					end
				end
				local lastTime = CacheCenter:getPlayerItemCountById(tSuit[j])
				if lastTime == -1 or lastTime > 0 then 
					nOwnCount = nOwnCount + 1
				end
			end

			if bIsFind == true then
				nMaxCount = #tSuit
				tProperty = v.property
				suitId = v.id
				break
			end
		end
	end

	local afterPro = {}
	if utilsValueInTable(suitId, havedAdvanceIds) then 
		bIsSuit = true
		local tData = GDatatab_enchanting["id_" .. suitId]
		if tProperty ~= -1 then 
			afterPro = CopyTable(tProperty)
		end
		for i = 1, #tData.property3 do
			local bIsExist = false 
			for j = 1, #afterPro do
				if afterPro[j][1] == tData.property3[i][1] then 
					afterPro[j][2] = afterPro[j][2] + tData.property3[i][2]
					bIsExist = true
					break 
				end
			end
			if not bIsExist then 
				table.insert(afterPro, tData.property3[i])
			end
		end
	else
		afterPro = tProperty
	end
	--WZLog("WndItemInfo:_showDressSuit 333", bIsSuit)
	if bIsSuit == true then
		self:_showLineOne()--创建线条

		local x = DIRX

		self.m_nLineH = self.m_nLineH + 16
		local y = self:_getAllHeight()
		local freeLabel = WZUIFreeTextBox:create()
		freeLabel:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		freeLabel:setRelativePosition(GlobalMethod:ccp(x,y))
		freeLabel:setMaxWidth(340)
		local color = "5,180,0"
		if nOwnCount >= nMaxCount then
			color = "255,89,74"
		end
		local str1 = string.format(LocalStrings.DRESS_SUIT_TEXT1[1],nMaxCount,color,nOwnCount,nMaxCount)
		if not bIsHost then 
			str1 = string.format(LocalStrings.DRESS_SUIT_TEXT1[7], nMaxCount)
		end
		freeLabel:setShowText(str1)
	    self.m_root:addChild(freeLabel)

		self.m_nLineH = self.m_nLineH + 16
		local h = 0 
		local proCount = math.ceil(#afterPro/2)
		local nIndex = 1
		for i = 1, proCount do
			local y = self:_getAllHeight()

			local data = afterPro[nIndex]
			if data then 
				local sName = string.format("txtDressSuitPro%d_WndItemInfo",i)
				self:_createColorTxt({value1=ATTR_TITLE[tonumber(data[1])]..":",font1=fontSize,color1=ccc3(127,70,26),value2=data[2],font2=fontSize,color2=ccc3(127,70,26)},sName,ccp(x,y))

				nIndex = nIndex + 1
			end

			data = afterPro[nIndex]
			if data then 
				local sName = string.format("txtDressSuitPro%d_WndItemInfo",i)
				self:_createColorTxt({value1=ATTR_TITLE[tonumber(data[1])]..":",font1=fontSize,color1=ccc3(127,70,26),value2=data[2],font2=fontSize,color2=ccc3(127,70,26)},sName,ccp(x + 0.6, y))

				nIndex = nIndex + 1
			end

			self.m_nLineH = self.m_nLineH + 20
		end
    end
end

--@brief	物品说明
function WndItemInfo:_showItemDesc(tData)
	WZLog("物品说明")
	local x = DIRX
	if self.m_tEquip and self.m_tEquip.basicInfo and self.m_tEquip.basicInfo.icon ~= nil then
		x = x + (101+ 5*NSPACE) /self:_getWindowsW()
	end
	for i,data in pairs(tData) do
		local y = 0.96
		local txtSize,txtPt = self:_getTextElement(i-1)--获取上一个文本的高度
		if txtSize then
			y = txtPt.y - txtSize.height/200
		end
		local sName = "txtItem%d_WndItemInfo"
		sName = name or string.format(sName,i)
		self:_createColorTxt(data,sName,ccp(x,y))
		data = nil
	end
	tData = nil
end

--@brief	增加空白高度
function WndItemInfo:_addBlankHeight(h)
	h = h or 0
	self.m_nBlankHeight = self.m_nBlankHeight + h
end

--@brief	线条
function WndItemInfo:_showLineOne(h)
	WZLog("创建线条",self.m_nState)
	h = h or 0
	self.m_nLineExitH = 2
	local y = self:_getAllHeight() - 5/self:_getWindowsW() + h
	local pt
	if self.m_nState == 1 then
		pt = ccp(0.77,y)
	elseif self.m_nState == 2 then
		pt = ccp(0.59,y)
	elseif self.m_nState == 3 then
		pt = ccp(0.595,y)
	else
		pt = ccp(0.5,y)
	end
	self:_createLine(pt)
	self.m_nLineH = self.m_nLineH + 10
end

--@brief	创建线条
function WndItemInfo:_createLine(pt)
	local file = "ui/common/common_scale9_fengexian.png"
	local con = WZUIContainer:create()
	con:setUseAbsSize(true)
	con:setAbsContentSize(CCSize(600,6))
	con:setAnchorPoint(ccp(0.5 ,1))
	con:setTouchEnable(false)
	con:setRelativePosition(pt)
	con:setScaleX(1.5)
	self.m_root:addChild(con)
	local img = self:_createImage(file)
	con:addChild(img)
	if self.m_nState == 1 then
		con:setScaleX(2.3)
	elseif self.m_nState == 2 then
		con:setScaleX(1.7)
	elseif self.m_nState == 3 then
		con:setScaleX(1.8)
	end
	pt = nil
end

--@brief	武器大招
function WndItemInfo:_showGreatSkill()
	WZLog("WndItemInfo:_showGreatSkill")
	if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil or self.m_tEquip.basicInfo.main_type == nil then
		return false
	elseif (self.m_tEquip.basicInfo.main_type == 4 and 
			(self.m_tEquip.basicInfo.sub_type == 0 or self.m_tEquip.basicInfo.sub_type == 1) ) or --武器
			(self.m_tEquip.basicInfo.main_type == 9 and self.m_tEquip.basicInfo.sub_type == 1) then --装备碎片
	else
		return false
	end

	--大招技能id
	local value
	if self.m_tEquip.basicInfo.main_type == 4 then
		value = self.m_tEquip.basicInfo.value
	elseif self.m_tEquip.basicInfo.main_type == 9 then
		value = GDatatab_item["id_"..GDatatab_itemmerge["id_"..self.m_tEquip.basicInfo.id].items[1][1]].value 
	end

	WZLog("sdjglasdgl  ",value)

	if value == 0 then
		return
	end

	local x = DIRX
	local y = self:_getAllHeight() + 0.06
	local skillInfo = GDatatab_skill["id_"..value]
	local txtDesc = WZUILabelTTF:create()
	if tonumber(skillInfo.tool_desc) ~= -1 then
	    txtDesc:setText(LocalStrings.WEAPON..LocalStrings.SKAT..":"..skillInfo.name.."("..skillInfo.tool_desc..")")
	else
	    txtDesc:setText(LocalStrings.WEAPON..LocalStrings.SKAT..":"..skillInfo.name)
	end

	txtDesc:setAnchorPoint(ccp(0,1))
	txtDesc:setRelativePosition(ccp(x,y))
	txtDesc:setAlignment(kCCTextAlignmentLeft)
	txtDesc:setFontSize(18)
	if ProjConfig.LANGUAGE == "vn" then
		txtDesc:setFontSize(14)
		if tonumber(skillInfo.tool_desc) ~= -1 then
	        txtDesc:setText(LocalStrings.SKAT..":"..skillInfo.name.."("..skillInfo.tool_desc..")")
		else
		    txtDesc:setText(LocalStrings.SKAT..":"..skillInfo.name)
		end
	end
	
	if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "en" or 
		ProjConfig.LANGUAGE == "tr" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "th" then
		txtDesc:setFontSize(16)
	end
	txtDesc:setBoldFont(true)
	txtDesc:setColor(ccc3(5,180,0))
	txtDesc:setColor(ccc3(255,89,74))
	txtDesc:setDimensions(CCSize(450,0))
	--txtDesc:setScaleX(0.8)
	self.m_root:addChild(txtDesc)
	local descSize = txtDesc:getContentSize()
	self.m_nLineH = self.m_nLineH + descSize.height
end

--@brief	创建星星
function WndItemInfo:_showStar()
	if self.m_tEquip == nil or self:_checkEquipType() == false then
		return
	elseif self.m_tEquip.extraInfo == nil or self.m_tEquip.extraInfo.starLevel == nil or self.m_tEquip.extraInfo.starLevel == 0 then
		return
	end

	self:_showLineOne()--创建线条
	self.m_nLineH = self.m_nLineH + 3
	local starLevel = self.m_tEquip.extraInfo.starLevel
	local winWidth = self:_getWindowsW()
	local dir = 8
	local x = DIRX
	local y = self:_getAllHeight()
	WZLog("starLevel,mothNum,sunNum:A::",starLevel,moonNum,sunNum,MOTH_NUM,SUN_NUM)

	if self.m_tEquip.basicInfo.quality == 4 then
		if starLevel >= 13 then
			for i=1,starLevel-12 do
				local icon = "ui/common/common_icon_xingxing2_h.png"
				local name = string.format("imgStar%d_WndItemInfo",i)
				local imgStar = self:_createImage(icon,ccp(x,y),name,ccp(0,1),nil,true)
				imgStar:setScale(0.6)
				self.m_root:addChild(imgStar)
				local size = imgStar:getContentSize()
				size.width = size.width * 0.6
				size.height = size.height * 0.6
				x = x + (size.width*0.75+dir)/winWidth--32是星星的宽+间距  28X31
			end
		else
			for i=1,starLevel do
	    		local spine = WZUISpine:create()
	    		spine:setTouchEnable(false)
	    		spine:setFileJson("ui/ui_sg_star.json")
	    		spine:setFileAtlas("ui/ui_sg_star.atlas")
	    		spine:setAnimationName("1")
	    		spine:setUseOriginSize(true)
	    		spine:setRelativePosition(GlobalMethod:ccp(x+0.055,y-0.01))
	    		spine:setTag(1102)
				spine:setScale(0.55)
				spine:setRotation(45)
	    	    spine:setLoop(true)
				spine:play("1", true)
	    		self.m_root:addChild(spine)
				x = x + (16+dir)/winWidth--32是星星的宽+间距  28X31
			end
			self.m_nLineH = self.m_nLineH + 35
		end
	else
		for i=1,starLevel do
			local icon = "ui/common/common_icon_xingxing2.png"
			local name = string.format("imgStar%d_WndItemInfo",i)
			local imgStar = self:_createImage(icon,ccp(x,y),name,ccp(0,1),nil,true)
			imgStar:setScale(0.6)
			self.m_root:addChild(imgStar)
			local size = imgStar:getContentSize()
			size.width = size.width * 0.6
			size.height = size.height * 0.6
			x = x + (size.width*0.75+dir)/winWidth--32是星星的宽+间距  28X31
		end
	end

	--星星图片比较大,缩小间距
	self.m_nLineH = self.m_nLineH - 15
end

--@brief	石头
function WndItemInfo:_showStone()
	if self.m_tEquip.basicInfo.main_type == 9 then
		return
	end
	local tData = self:_getStoneData()--获取石头数据列表
	if tData == nil or #tData == 0 then
		return
	end
	WZLog("石头 = ",Serialize(tData))
	self:_addBlankHeight(6)
	local x = DIRX
	local y = self:_getAllHeight()
	self.m_nStone = 0 
	local h = 0 
	local addPercent = 0
	for i,data in pairs(tData) do
		if data.itemId ~= nil then
			local tItem = GDatatab_item["id_"..data.itemId]
			if (tItem.main_type == 6 or tItem.main_type == 44) and tItem.sub_type == 5 then
				addPercent = tItem.property[1][2]/100
			end
		end
	end
	for i,data in pairs(tData) do
		local sName = "txtStone%d_WndItemInfo"
		local sNameB = "txtStoneB%d_WndItemInfo"
		sName = string.format(sName,i)
		sNameB = string.format(sNameB,i)
		if tData[i - 1] and tData[i - 1].bIsMagicStone then 
			y = y - 20/200
		else
			local stoneSize,stonePt = self:_getStoneSizePos(i-1)--通过索引获取石头的大小位置
			if stoneSize then
				y = stonePt.y - stoneSize.height/200
			end
		end
		data.font1 = 20
		data.font2 = 20
		data.font3 = 20
	
		if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" or 
			ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "tr" or
			ProjConfig.LANGUAGE == "es" then
			data.font1 = 16
		    data.font2 = 16
		    data.font3 = 16
		end
		if data.itemId ~= nil then
			local tItem = GDatatab_item["id_"..data.itemId]
			if (tItem.main_type == 6 or tItem.main_type == 44) and tItem.sub_type == 5 then
				data.value4 = "("..tItem.property[1][2].."%)"
			else
				if addPercent ~= 0 then
					data.value4 = "+".. tostring(math.floor(tItem.property[1][2]*addPercent))
				end
			end
		end
		if data.bIsMagicStone then 
			local txtA = self:_createFreeText(data.value1, ccp(x,y), sName)
			h = 20
		else
			local txtA,_,_,_ = self:_createColorTxt(data,sName,ccp(x,y),nil,nil,sNameB)
			h = txtA:getContentSize().height
		end
		self.m_nStone = self.m_nStone + h
		data = nil
	end
end

--@brief	解冻锁
function WndItemInfo:_showLockTip()
	WZLog("WndItemInfo:_showLockTip")
	if self.m_root == nil then
		return
	end
	local lockType = self:_checkLockTip()
	if lockType == 0 then
		return
	end
	local desc = LocalStrings.LOCKTIPGREEN
	local color = ccc3(0,246,34)
	if lockType == 1 then
		desc = LocalStrings.LOCKTIPBLUE
		color = ccc3(0,180,255)
	end
	self:_showLineOne()--创建线条
	local x = DIRX - 0.02
	local y = self:_getAllHeight() + 0.01
	local txt = self:_createTTF(desc,ccp(x,y),nil,color,22,"txtLock_WndItemInfo",CCSize(360,0))
	self.m_root:addChild(txt)
end

--@brief	按钮,优先自定义按钮,再到配置类型上的按钮
function WndItemInfo:_showBtn()
	WZLog("WndItemInfo:_showBtn",self.m_bButton)
	if self.m_bButton == false then
		return
	end
	WZLog("按钮")
	if self.m_nLineExitH ~= 2 then
		self.m_nLineExitH = 3
	end
	local y = self:_getAllHeight()
	self.m_tBtnData = nil
	self.m_tBtnData = self:_getMoreTypeBtnData()
	if self.m_tBtnData == nil or #self.m_tBtnData == 0 then
		return
	end
	self:_showLineOne()--创建线条

	local w = 325
	if self.m_nState ~= nil and self.m_nState > 0 then
		w = stateWidth[self.m_nState]
	end
	if self.m_tBtnData and #self.m_tBtnData >= 3 and w < 490 then
		w = 490
	end
	WZUIContainer:luaTo(self.m_root):setContentSize(CCSize(w,WZUIContainer:luaTo(self.m_root):getAbsContentSize().height))

	local con = WZUIContainer:create()
	local maxCount = #self.m_tBtnData
	con:setUseAbsSize(true)
	con:setAbsContentSize(self:_getBtnConSize(maxCount))
	con:setAnchorPoint(ccp(0.5,1))
	con:setRelativePosition(ccp(0.5,y))
	self.m_root:addChild(con)
	for i,data in pairs(self.m_tBtnData) do
		local sName = "btn%d_WndItemInfo"
		sName = string.format(sName,i)
		local pt,an = self:_checkBtnPtAn(maxCount,i)
		local btn = self:_createBtn(sName,data.desc,pt,an,data.clickFun,i)
		con:addChild(btn,i,i)
	end
end

--@brief	背景图
function WndItemInfo:_showBackground(w,hh,file)
	file = file or "ui/common/common_scale9_di24.png"
	w = w or self:_getWindowsW()--窗口大小
	if self.m_nState ~= nil and self.m_nState > 0 then
		w = stateWidth[self.m_nState]
	end
	if self.m_tBtnData and #self.m_tBtnData >= 3 and w < 490 then
		w = 490
	end
	hh = hh or 0
	local y,h = self:_getAllHeight()--获取总高
	local con = WZUIContainer:create()
	con:setUseAbsSize(true)
	con:setAbsContentSize(CCSize(w,h+4+hh))
	con:setAnchorPoint(ccp(0 ,1))
	con:setTouchEnable(true)
	con:setTouchSwallow(true)
	con:setRelativePosition(ccp(0,1))
	con:setZOrder(-2)
	con:setTag(222)
	self.m_root:addChild(con)
	local bkImg = WZUI9Image:create()
	bkImg:setFile(file)
	con:addChild(bkImg)
end

--@brief	获取新窗口大小
function WndItemInfo:_getNewWinSize()
	local w = self:_getWindowsW()
	local y,h = self:_getAllHeight()
	return w,h
end

--@brief	设置新窗口大小
function WndItemInfo:_setNewWinSize()
	local w = self:_getWindowsW()
	if self.m_nState ~= nil and self.m_nState > 0 then
		w = stateWidth[self.m_nState]
	end
	if self.m_tBtnData and #self.m_tBtnData >= 3 and w < 490 then
		w = 490
	end
	local h = self:_getAllHeight()
	WZUIContainer:luaTo(self.m_root):setContentSize(CCSize(w,h))
end

--@brief	设置新窗口的位置
function WndItemInfo:_setWinPos()
	if self.m_tLua == nil then return end
	local winPt = self.m_tEquip.pt or ccp(0,0)
	--pt1:世界坐标  pt:父节点中的坐标
	local pt,pt1 = self:_gettToNodePt()--获取位置
	local w,h = self:_getNewWinSize()--获取新窗口大小
	if self.m_nState ~= nil and self.m_nState > 0 then
		w = stateWidth[self.m_nState]
	end
	pt.x = pt.x + 48 + winPt.x
	pt.y = pt.y - 48 + h - 200 + winPt.y
	local directorSize = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
	if self:_checkRightWin(pt1,w) == true then--检查右边超框
		WZLog("检查右边超框",pt1.x,pt.x,w)
		pt.x = pt.x - 96 - w
	end
	--检查左边超框
	if self:_checkRightWin(pt1,w) and (pt1.x - w - 45) < 0 then pt.x = pt.x + (w - pt1.x + 100) end

	--检查上超框
	local dir = self:_checkUpWin(pt1,h)
	if dir > 0 then
		pt.y = pt.y - dir
		--if self.m_tEquip ~= nil and self.m_tEquip.basicInfo.id == 192 then
		--	self.m_root:setScaleY(0.95)
		--	pt.y = pt.y - 14
		--end
	end
	--检查下超框
	if h > 610 and pt.y - 430 < 0 then
		pt.y = pt.y + 30
	end


	WZLog("窗口位置",pt.x,pt.y,h)
	--设置窗口的位置
	local windowElement = WZUIElementContainer:luaTo(self.m_root)
	windowElement:setAbsPosition( pt )
	winPt = nil
end

--@brief	检查右边超框
function WndItemInfo:_checkRightWin(pt1,w)
	WZLog("WndItemInfo:_checkRightWin",pt1.x,w)
	--if pt1.x + 48 + w > 956 then--956
	if pt1.x + 105 + w > 1136 then
		return true
	else
		return false
	end
end

--@brief	检查上超框
function WndItemInfo:_checkUpWin(pt1,h)
	if self.m_nState == 1 then
		return pt1.y - 48 + h - 610
	else
		return pt1.y - 48 + h - 635
	end
end

function WndItemInfo:_getSingleline(h)
	if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "pt" then
		h = h + 24
	end
	return h
end

function WndItemInfo:_getCustomBtn()
	if self.m_tEquip.tBtnList == nil then
		return
	end
	local tItem = {}
	for i,data in pairs(self.m_tEquip.tBtnList) do
		local temp = {}
		temp.desc = data
		temp.clickFun = "onCustomFun"
		table.insert(tItem,temp)
	end
	return tItem
end

--通过不同类型获取按钮，以自定义，和默认类型判断
function WndItemInfo:_getMoreTypeBtnData()
	if self.m_tEquip.tBtnList then
		return self:_getCustomBtn()
	else
		local pokedex = nil
		if self.m_tEquip.basicInfo and self.m_tEquip.basicInfo.pokedex then
			pokedex = self.m_tEquip.basicInfo.pokedex
		end
		local b_data = self:_getBtnData()
		b_data = b_data or {}
		if pokedex and type(pokedex) == "table" and (tonumber(pokedex) ~= 0 or tonumber(pokedex) ~= -1) then
			local temp = {}
			temp.desc = LocalStrings.SKINSKILL4
			temp.clickFun = "getGotoChannel"--强化
			table.insert(b_data,temp)
		end
		return b_data
	end
end

--按钮数据列表
function WndItemInfo:_getBtnData()
	if self.m_tEquip.lastTime == 0 and self.m_tEquip.maintype == MAIN_DRESS_TYPE and self.m_tEquip.basicInfo.sale_again == 1 then--过期
		local tData = {}
		local temp = {}
		temp.desc = LocalStrings.RENEWALS
		temp.clickFun = "onExpired"
		table.insert(tData,temp)
		return tData
	end
	local sale = tonumber(self.m_tEquip.basicInfo.sale_again) or 1
	local main_type = self.m_tEquip.basicInfo.main_type
	local sub_type = self.m_tEquip.basicInfo.sub_type
    -- 针对商城
    if self.m_tOther and self.m_tOther.interface == INTERFACE_SHOP then
        local tData = {}--7
        local temp = {}
        if CacheCenter:getPlayerItemCountById(itemId) then
        end
		--无限期没有按钮
		local tItem = CacheCenter:getPlayerItemById(self.m_tEquip.basicInfo.id)
		if tItem ~= nil and tItem.lastTime == -1 then
			return
		end

        local have = false
        local list = CacheCenter:getDecorationList()
        for i = 1, #list do
            if list[i].basicInfo.id == self.m_tEquip.basicInfo.id then  have = true  end
        end
        local desc = have and LocalStrings.RENEWALS or LocalStrings.BUY
        temp.desc = desc
        temp.clickFun = "buyIt"
        table.insert(tData,temp)
        return tData
    end
    --灵石的拆卸时候
    if self.m_tOther and self.m_tOther.mountStone == true then
    	local tData = {}
    	local temp2 = {}
		temp2.desc = LocalStrings.REMOVE_STONE
		temp2.clickFun = "onStoneRemove"
		table.insert(tData,temp2)
		return tData
    end

	if main_type == MAIN_EQUIT_TYPE then--4
		local notTimeLimit = (self.m_tEquip.basicInfo.time_limit == -1)
		local tData = {}

		if notTimeLimit then

		if CheckButtonOpen(26,false) then
			local temp = {}
			temp.desc = LocalStrings.STRENGTEN
			temp.clickFun = "onStrengthen"--强化
			table.insert(tData,temp)
		end

		local playerLevel = CacheCenter:getPlayerInfo().level
		--蓝装可以升阶
		if playerLevel >= 35 and self.m_tEquip ~= nil and self.m_tEquip.basicInfo ~= nil and self.m_tEquip.basicInfo.quality == 2 then
			local temp = {}
			temp.desc = LocalStrings.ASCENDING9
			temp.clickFun = "onAscending"--升阶
			table.insert(tData,temp)
		end
		--紫装可以升阶
		if playerLevel >= 35 and self.m_tEquip ~= nil and self.m_tEquip.basicInfo ~= nil and self.m_tEquip.basicInfo.quality == 3 then
			local temp = {}
			temp.desc = LocalStrings.ASCENDING9
			temp.clickFun = "onAscending"--升阶
			table.insert(tData,temp)
		end
		--橙装可以调品
		if playerLevel >= 35 and self.m_tEquip ~= nil and self.m_tEquip.basicInfo ~= nil and self.m_tEquip.basicInfo.quality == 4 then
			local temp = {}
			temp.desc = LocalStrings.ASCENDING2
			temp.clickFun = "onAscending2"--调品
			table.insert(tData,temp)
		end

		end

		if self.m_tEquip.isUse  or self.m_tEquip.isUse == 1 then
			if main_type == 4 and (sub_type == 0 or sub_type == 1) then
			else
				local temp = {}
				temp.desc = LocalStrings.UNROYAL
				temp.clickFun = "onUnderRoyal"--卸下
				table.insert(tData,temp)
			end
		else
			local temp = {}
			temp.desc = LocalStrings.WEAR
			temp.clickFun = "onWear"--装备
			table.insert(tData,temp)
		end
		return tData
	elseif main_type == MAIN_DRESS_TYPE then--5
		local tData = {}
		--时装不是无限期并且配置可续费，显示续费按钮
		if self.m_tEquip.lastTime ~= -1 and self.m_tEquip.basicInfo.sale_again == 1 then
			local temp = {}
			temp.desc = LocalStrings.RENEWALS
			temp.clickFun = "onExpired"--续费
			--self:setExpiredFun(t,t.onExpired)
			table.insert(tData,temp)
		end
		if self.m_tEquip.isUse or self.m_tEquip.isUse == 1 then
			if main_type == 4 and (sub_type == 0 or sub_type == 1) then
			else
				local temp = {}
				temp.desc = LocalStrings.UNROYAL
				temp.clickFun = "onUnderRoyal"--卸下
				self:setRoyalFun(WndPlayer,WndPlayer.onUnderRoyal)
				table.insert(tData,temp)
			end
		else
			if self.m_tEquip.lastTime ~= 0 then
				local temp = {}
				temp.desc = LocalStrings.WEAR
				temp.clickFun = "onDress"--装备
				table.insert(tData,temp)
			end
		end
		return tData
	elseif main_type == KID_MAIN_DRESS_TYPE then --小孩时装
		local tData = {}
		--时装不是无限期并且配置可续费，显示续费按钮
		if self.m_tEquip.lastTime ~= -1 and self.m_tEquip.basicInfo.sale_again == 1 then
			local temp = {}
			temp.desc = LocalStrings.RENEWALS
			temp.clickFun = "onExpired"--续费
			--self:setExpiredFun(t,t.onExpired)
			table.insert(tData,temp)
		end
		if self.m_tEquip.isUse or self.m_tEquip.isUse == 1 then
			if main_type == 4 and (sub_type == 0 or sub_type == 1) then
			else
				local temp = {}
				temp.desc = LocalStrings.UNROYAL
				temp.clickFun = "onUnderRoyal"--卸下
				self:setRoyalFun(WndKidDress, WndKidDress.onUnderRoyal)
				table.insert(tData,temp)
			end
		else
			if self.m_tEquip.lastTime ~= 0 then
				local temp = {}
				temp.desc = LocalStrings.WEAR
				temp.clickFun = "onKidDress"--装备
				table.insert(tData,temp)
			end
		end
		return tData
	elseif main_type == MAIN_MATERIAL_TYPE and self.m_tOther and self.m_tOther.interface == INTERFACE_BAG then
		local tData = {}
		local temp = {}
		temp.desc = LocalStrings.USE
		temp.clickFun = "onApply"
		table.insert(tData,temp)
		return tData
	elseif main_type == MAIN_PROPS_TYPE and (sub_type == 0 or sub_type == 1 or sub_type == 2 or sub_type == 14 or sub_type == 15 or sub_type == 22 
		or sub_type == 23 or sub_type == 25 or sub_type == 26 or sub_type == 45 or sub_type == 46 or sub_type == 51 or sub_type == 10 or sub_type == 52) then--2使用
		local tData = {}
		local temp = {}
		temp.desc = LocalStrings.USE
		temp.clickFun = "onApply"
		table.insert(tData,temp)
		return tData
	elseif main_type == 20 then--20皮肤体验卡
		local tData = {}
		local temp = {}
		temp.desc = LocalStrings.USE
		temp.clickFun = "onPhantom"
		table.insert(tData,temp)
		return tData
	elseif main_type == MAIN_CHEST_TYPE then--3宝箱
		local tData = {}
		local temp = {}
		temp.desc = LocalStrings.USE
		if sub_type == 7 then
			temp.clickFun = "onChooseReward"
		else 
			temp.clickFun = "onChest"
		end
		table.insert(tData,temp)
		return tData
	elseif main_type == MAIN_MONTHCARD_TYPE and sub_type == 2 then--13公会月卡
		local tData = {}
		local temp = {}
		temp.desc = LocalStrings.USE
		temp.clickFun = "onMonthCard"
		table.insert(tData,temp)
		return tData
	elseif main_type == 9 and sub_type == 1 then
		local tData = {}
		local temp = {}
		temp.desc = LocalStrings.GET
		temp.clickFun = "onGetEquip"
		table.insert(tData,temp)
		return tData
	elseif main_type == MAIN_PROPS_TYPE and (sub_type == 12 or sub_type == 13) then--2竞技加速
		local tData = {}
		local temp = {}
		temp.desc = LocalStrings.USE
		temp.clickFun = "onCompetitiveAcceleration"
		table.insert(tData,temp)
		return tData
	elseif main_type == 23 then--23足迹
		local tData = {}
		local temp = {}
		temp.desc = LocalStrings.USE
		temp.clickFun = "onFootMark"
		table.insert(tData,temp)
		return tData
	elseif main_type == 24 and sub_type == 0 then--24-0变性卡
		local tData = {}
		local temp = {}
		temp.desc = LocalStrings.USE
		temp.clickFun = "onChangeSex"
		table.insert(tData,temp)
		return tData
	elseif main_type == 24 and sub_type == 1 then--24-1孩子变性卡
		local tData = {}
		local temp = {}
		temp.desc = LocalStrings.USE
		temp.clickFun = "onChangeChildSex"
		table.insert(tData,temp)
		return tData
	elseif main_type == 25 and sub_type == 2 then --气泡卡
		local tData = {}
		local temp = {}
		temp.desc = LocalStrings.ACTIVATION
		temp.clickFun = "onActivateBubble"
		table.insert(tData,temp)
		return tData
	elseif main_type == MAIN_PHANTOM_EQUIPMENT then --幻化装备
		local tData = {}
		if self.m_tEquip.type == 1 then
			if sub_type ~= 6 then
				if self.m_tEquip.isUse == true or self.m_tEquip.isUse == 1 then
					local temp = {}
					temp.desc = LocalStrings.UNROYAL
					temp.clickFun = "onApply"--卸下
					table.insert(tData,temp)
				else
					local temp = {}
					temp.desc = LocalStrings.WEAR
					temp.clickFun = "onApply"--装备
					table.insert(tData,temp)
				end
			end
		end
		return tData
	elseif main_type == 38 and (sub_type >= 9 and sub_type <= 13) then --坐骑灵石之源
		local tData = {}
		local temp1 = {}
		temp1.desc = LocalStrings.GEMMOUNTING
		temp1.clickFun = "onPutOn"
		table.insert(tData,temp1)
		return tData
	elseif main_type == 39 and sub_type == 1 then --丰收沙漏
		local tData = {}
		local temp = {}
		temp.desc = LocalStrings.USE
		temp.clickFun = "onApply"
		table.insert(tData,temp)
		return tData
	elseif main_type == MAIN_PROPS_TYPE and sub_type == 49 or main_type == 40 then--2玩家信息框特效、头像框
		local tData = {}
		local temp = {}
		if self.m_tEquip.isUse or self.m_tEquip.isUse == 1 then
			temp.desc = LocalStrings.UNROYAL
		else
			temp.desc = LocalStrings.FAMILYSHOP2
		end
		temp.clickFun = "onApply"
		table.insert(tData,temp)
		return tData
	elseif main_type == MAIN_PET_EQUIPMENT then --宠物装备
		local tData = {}
		if WndPetsEquipment.m_root and WndPetsEquipment.m_nInterfaceType == 2 then --继承界面
			local temp = {}
			temp.desc = LocalStrings.TRANSFER
			temp.clickFun = "onApply"--继承
			table.insert(tData,temp)
		else
			if self.m_tEquip.isUse == true or self.m_tEquip.isUse == 1 then
				local temp = {}
				temp.desc = LocalStrings.UNROYAL
				temp.clickFun = "onUnderRoyal"--卸下
				table.insert(tData,temp)
			else
				local temp = {}
				temp.desc = LocalStrings.WEAR
				temp.clickFun = "onApply"--装备
				table.insert(tData,temp)
			end
		end
		return tData
	end
end

--@brief	检查装备上按钮的位置和锚点
function WndItemInfo:_checkBtnPtAn(maxCount,index,y)
	local mainType = self.m_tEquip.basicInfo.main_type
	WZLog("按钮信息",mainType,maxCount)
	if maxCount == 1 then
		return ccp(0.5,0.15),ccp(0.5,0.5)
	elseif maxCount == 3 then
		return ccp(-0.14 + index*0.32,0.15),ccp(0.5,0.5)
	elseif maxCount == 4 then
		return ccp(-0.3 + index*0.32,0.15),ccp(0.5,0.5)
	else
		local tag = (index-1)/(maxCount-1)
		if self.m_tEquip.basicInfo.main_type == 5 then
			return ccp(tag,0.15),ccp(tag,0.5)
		end
		return ccp(tag,0.15),ccp(tag,0.5)
	end
end

--@brief	根据按钮的数量获取父类容器的大小
function WndItemInfo:_getBtnConSize(maxCount)
	if maxCount == 2 then
		return CCSize(250,50)
	else
		return CCSize(376,50)
	end
end

--@brief	创建文本TTF
function WndItemInfo:_createTTF(desc,pt,anchor,color,font,sName,dimen)
	desc = desc or ""
	pt = pt or ccp(0.5,0.5)
	anchor = anchor or ccp(0,1)
	color = color or ccc3(255,255,255)
	font = font or 20
	dimen = dimen or CCSize(0,0)
	sName = sName or "txt_WndItemInfo"
	local txt = WZUILabelTTF:create()
	txt:setText(desc)
	txt:setAlignment(kCCTextAlignmentLeft)
	txt:setRelativePosition(pt)
	txt:setAnchorPoint(anchor)
	txt:setColor(color)
	txt:setFontSize(font)
	txt:setName(sName)
	txt:setDimensions(dimen)
	return txt
end

--@brief 	时效时装显示天数满999转为永久时装提示语
function WndItemInfo:_showDress999Att()
	-- body
	if self.m_tEquip.main_type ~= 5 then return end 
	if self.m_tEquip.lastTime and tonumber(self.m_tEquip.lastTime) > 0 then 
		self:_showLineOne()--创建线条
		local x = DIRX
		local y = self:_getAllHeight()
		WZLog("WndItemInfo:_showDress999Att", x, y)
		local txt = self:_createTTF(LocalStrings.DRESS_DAYTIPS, GlobalMethod:ccp(x,y), GlobalMethod:ccp(0, 1), GlobalMethod:ccc3(189,132,107), 20, "txtDressAtt999_WndItemInfo", GlobalMethod:CCSize(365,0))
		if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" or ProjConfig.LANGUAGE == "vn" then
			txt:setFontSize(16)
			txt:setDimensions(GlobalMethod:CCSize(300,0))
		end
		self.m_root:addChild(txt)
		local nTempH = txt:getContentSize().height
		WZLog("WndItemInfo:_showDress999Att  jjj", nTempH)
	end
end

--@brief 	宠物装备随机属性查看按钮回调
function WndItemInfo:onRandomTip(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local tData = {}
	tData.quality = self.m_tEquip.basicInfo.quality
	tData.subType = self.m_tEquip.basicInfo.sub_type
	tData.origin = self.m_tEquip.origin
	WndTips:show(element,self.m_root, 91, tData)
end

--@brief	显示小孩时装套装
function WndItemInfo:_showKidDressSuit()
	if self.m_tEquip == nil or self.m_tEquip.basicInfo == nil or self.m_tEquip.basicInfo.icon == nil then
		return
	end

	local maintype = self.m_tEquip.basicInfo.main_type
	local subtype = self.m_tEquip.basicInfo.sub_type
	if not (maintype == 31 and (subtype == 1 or subtype == 2 or subtype == 3)) then
		return
	end

	local bIsSuit = false --当前时装是否有套装
	local nOwnCount = 0 --套装部件拥有数量
	local nMaxCount = 0 --套装部件最大数量
	local tSuit = nil 
	local tSuitNum = {}
	for i, v in pairs(g_tKidDressSuitData) do
		bIsSuit = false
		nOwnCount = 0
		nMaxCount = #v
		tSuitNum = {}
		for j = 1, #v do
			if v[j] == self.m_tEquip.basicInfo.id then
				tSuit = v
				bIsSuit = true
			end
			local lastTime = CacheCenter:getPlayerHomeItemCountById(v[j])
			if lastTime == -1 or lastTime > 0 then 
				nOwnCount = nOwnCount + 1
			end
			tSuitNum[j] = lastTime
		end

		if bIsSuit == true then
			break
		end
	end

	if bIsSuit == true then
		self:_showLineOne()--创建线条

		local x = DIRX
		self.m_nLineH = self.m_nLineH + 16
		local y = self:_getAllHeight()
		local freeLabel = WZUIFreeTextBox:create()
		freeLabel:setAnchorPoint(GlobalMethod:ccp(0,0.5))
		freeLabel:setRelativePosition(GlobalMethod:ccp(x,y))
		freeLabel:setMaxWidth(340)
		local color = "5,180,0"
		if nOwnCount >= nMaxCount then
			color = "255,89,74"
		end
		local str1 = string.format(LocalStrings.DRESS_SUIT_TEXT1[2],color,nOwnCount,nMaxCount)
		freeLabel:setShowText(str1)
	    self.m_root:addChild(freeLabel)

		self.m_nLineH = self.m_nLineH + 16
		local column = 9
		local gridScale = 0.7
		self.m_nGiftNum = nMaxCount
		for i = 1, nMaxCount do
			local isUse = false
			local tData = GDatatab_item["id_"..tSuit[i]]
			local relativePosition = GlobalMethod:ccp(0.196*(i-1)+0.132, y - 0.25)
			--创建底图
			local imgBg = self:_createImage("ui/common/common_scale9_beibaodi2.png",relativePosition)--添加背景
			imgBg:setScale(gridScale*0.9)
			self.m_root:addChild(imgBg)
			--创建品质框
			local imgQuality = self:_createImage(g_tQualityRect[tData.quality],relativePosition)--添加背景
			imgQuality:setScale(gridScale)
			self.m_root:addChild(imgQuality)
			--创建物品图片
			local img = self:_createImage(tData.icon,relativePosition,"imgItem_WndItemInfo")
			img:setUseOriginSize(true)
			img:setScale(gridScale)
			self.m_root:addChild(img)
			--创建套装按钮
			local btn = self:_createSuitBtn("giftBtn"..i,relativePosition,"clickKidDress",tData.id)
			self.m_root:addChild(btn)
			local lastTime = tSuitNum[i]
			if lastTime == 0 then 
				imgBg:setGrayRender(true)
				imgQuality:setGrayRender(true)
				img:setGrayRender(true)
			end
		end
		self.m_nLineH = self.m_nLineH + 70
    end

end

--@brief 	tips中点击小孩其他时装图标回调
function WndItemInfo:clickKidDress(element)
	WZLog("WndItemInfo:clickKidDress", element:getTag())
	local itemId = tonumber(element:getTag())
	if itemId == self.m_tEquip.basicInfo.id then return end 

	local lastTime = CacheCenter:getPlayerHomeItemCountById(itemId)
	local tempList = {}
	local bButton = false 
	local tCurKidData = SceneKidHome.m_tKidData[WndKidDress.m_nKidIndex]
	if lastTime == 0 then 
		CacheCenter:getShopItems(function(t,shopItemList) 
			local dataList = shopItemList

			if dataList ~= nil then
				for i = 1, #dataList do
					if dataList[i].basicInfo.main_type == 31 and dataList[i].isOnSale == true 
						and dataList[i].mainType ~= [[{"5":"1"}]]
						and dataList[i].basicInfo.id == itemId then
						dataList[i].showType = 2
						tempList = CopyTable(dataList[i])
					end
				end
			end
		end)
		tempList.tBtnList = {LocalStrings.BUY}
		bButton = true
	elseif lastTime > 0 or lastTime == -1 then 
		local equipmentList = CacheCenter:getKidDecorationListBySex(GDatatab_item["id_" .. itemId].sex)

		for i = 1, #equipmentList do
			if equipmentList[i].basicInfo.id == itemId then
				equipmentList[i].showType = 1
				tempList = CopyTable(equipmentList[i])
				break
			end
		end
		if (not tempList.isUse or tempList.isUse ~= 1 or tempList.childId == 0 or tempList.childId == tCurKidData.id) then 
		    bButton = true
		end
	end
	
--	WZLog("WndItemInfo:clickKidDress 00", Serialize(tempList))
	WndItemInfo:_onCloseClick()
	WndItemInfo.m_root = nil

	WndItemInfo:showInfo(self.m_tLua[1], self.m_tLua[2], 1, tempList, bButton)
	if lastTime == 0 then 
		WndItemInfo:setClickButtonCallback(self, self.onBuyBtn)
	end
end

function WndItemInfo:onBuyBtn(nTag, tData)
	WZLog("WndItemInfo:onBuyBtn", tData.shopItemId)
	local nType = {[0]=2,[1]=3,[2]=4,[3]=5}
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	if tData.basicInfo.main_type == 31 then
		WndPurchase:showBuyInterface(tData.basicInfo.sub_type + 1, tData.shopItemId)
	end
end
-------------------------------------私有方法模块End----------------------------------------

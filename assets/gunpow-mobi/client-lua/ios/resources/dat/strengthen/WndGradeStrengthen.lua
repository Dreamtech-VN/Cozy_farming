--WndGradeStrengthen.lua
--@brief	WndGradeStrengthen的UI模块
--@date		2017/05/16
--@author	zsq
--@note		调品


local blueprintIDList = {DRAWINGPURPLEWEAPON,DRAWINGPURPLEWEAPON,DRAWINGPURPLERING,DRAWINGPURPLENECKLACE,DRAWINGPURPLEWRISTER,DRAWINGPURPLETREASURE,DRAWINGPURPLEBADGE,DRAWINGPURPLE7,DRAWINGPURPLE8}
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGradeStrengthen:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGradeStrengthen:onExit(element)
	self:_unInit()
end

function WndGradeStrengthen:addEquipToCell(tEquip)
    if self.m_root == nil then return end

	if self.m_tEquipBefore == nil and tEquip ~= nil then
		self:updateLucky(tEquip)
	end
	if self.first and tEquip ~= nil then
		self:updateLucky(tEquip)
	end

    --添加装备到cell
    if tEquip ~= nil then
		self.m_tEquipBefore = tEquip
		self:updateMNum() 
    else
		self.m_tEquipBefore = nil
		self:cleanWnd()
    end
end

function WndGradeStrengthen:cleanWnd()
	GetElement(self.m_root,"txtGrade",WZUILabelTTF):setText("")
end

function WndGradeStrengthen:updateLucky(tEquip) 
	if self.m_root == nil then return end
	self.first = false
	--显示幸运值
	GetElement(self.m_root,"progrExpProgress_Wnd",WZUIProgress):setPercentage(0)
	GetElement(self.m_root,"ttfLucky",WZUILabelTTF):setText(LocalStrings.LUCKVALUE..":".."0%")
	local lucky = tEquip.extraInfo.organeEquiGradeBlessing
	if lucky == nil then lucky = 0 end
	if type(lucky) == "number" and lucky > 10000 then
		lucky = 10000
	end
	if lucky ~= nil and lucky ~= 0 then
		GetElement(self.m_root,"progrExpProgress_Wnd",WZUIProgress):setPercentage(lucky/100)
		GetElement(self.m_root,"ttfLucky",WZUILabelTTF):setText(LocalStrings.LUCKVALUE..":"..(lucky/100).."%")
	end	
end

function WndGradeStrengthen:popTip0() 
	PopupResult("ui/common/common_icon_tpwbh.png")
end

function WndGradeStrengthen:popTip() 
	local original = self.original
	local changed = GetElement(self.m_root,"txtGrade",WZUILabelTTF):getText()
	WZLog("WndGradeStrengthen:updateLucky", original, changed)
	if original ~= nil and original ~= "" then
		if original == changed then
			PopupResult("ui/common/common_icon_sxts.png")
		else
			PopupResult("ui/common/common_icon_zbsp.png")
		end
	end
end

function WndGradeStrengthen:updateMNum()
	--WZLog("WndGradeStrengthen:updateMNum", debug.traceback())
		--显示调品箱图片
		GetElement(self.m_root,"imgAdd4",WZUIImage):setFile(GDatatab_item["id_"..ORANGECHANGEGRADEMATERIAL].icon)
		--拥有调品箱数量
		local num1 = CacheCenter:getPlayerItemCountById(ORANGECHANGEGRADEMATERIAL)
		--设置调品箱数量
		GetElement(self.m_root,"txtHolyStoneNum",WZUILabelTTF):setText(num1.."/1")
		if num1 < 1 then
			GetElement(self.m_root,"txtHolyStoneNum",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,89,74))
		else
			GetElement(self.m_root,"txtHolyStoneNum",WZUILabelTTF):setColor(GlobalMethod:ccc3(255,255,255))
		end

		if self.m_tEquipBefore == nil then return end
		--显示品级

		local items = CacheCenter:getPlayerItems()
		local tEquip
		for i=1,#items do
			if items[i].playerItemId == self.m_tEquipBefore.playerItemId then
				tEquip = items[i]
				break
			end
		end
		if tEquip.extraInfo.orangeEquiGrade == nil or tEquip.extraInfo.orangeEquiGrade == "" then
			GetElement(self.m_root,"txtGrade",WZUILabelTTF):setText(GDatatab_item_orange_equi_grade["id_1"].name)
		else
			local grade = SplitStringWithSeparator(tEquip.extraInfo.orangeEquiGrade, "|")
			GetElement(self.m_root,"txtGrade",WZUILabelTTF):setText(GDatatab_item_orange_equi_grade["id_"..grade[1]].name)
			if tonumber(grade[1]) == 5 then
				GetElement(self.m_root,"btnSure",WZUIButton):setTouchEnable(false)
			else
				GetElement(self.m_root,"btnSure",WZUIButton):setTouchEnable(true)
			end
		end
		if self.m_bUpdateLucky == true then
			self.m_bUpdateLucky = false
			self:updateLucky(tEquip)
		end

		--显示消耗材料
		GetElement(self.m_root,"cost",WZUILabelTTF):setText(1)
		local blueprintID = blueprintIDList[self.m_tEquipBefore.basicInfo.sub_type+1]
		GetElement(self.m_root,"imgCost",WZUIImage):setFile(GDatatab_item["id_"..blueprintID].icon)
		--拥有图纸数量
		GetElement(self.m_root,"has",WZUILabelTTF):setText("("..LocalStrings.OWN..":"..CacheCenter:getPlayerItemCountById(blueprintID)..")")
		self.m_nOwnM = CacheCenter:getPlayerItemCountById(blueprintID)
end

--@brief	点击调品箱
function WndGradeStrengthen:onTip1()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local node = GetElement(self.m_root,"imgAdd4",WZUIImage)
	local tData = GDatatab_item["id_"..ORANGECHANGEGRADEMATERIAL]
    local name = tData.name
    local path = tData.icon
    local quality = tData.quality
    local itemInfo = {name=name,icon=path,quality=quality,basicInfo=CopyTable(tData)}
	itemInfo.tBtnList = {LocalStrings.GET}
	local par = GetElement(WndStrengthen.m_root,"conMid_WndStrengthen",WZUIContainer)
    WndItemInfo:showInfo(node, par, 1, itemInfo, false)
	WndItemInfo:setClickButtonCallback(self,self.getM)
    ChangeChatChannel(Chat_Channel_WndAscending_Tab2)
end

--@brief	点击材料
function WndGradeStrengthen:onMClicked(tLua, tag, tData)
	WZLog("WndGradeStrengthen:onMClicked")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	tData.tBtnList = {LocalStrings.GET}
    WndItemInfo:showInfo(tLua.m_root, GetElement(self.m_root,"conMid",WZUIContainer), 1, tData, true)
	WndItemInfo:setClickButtonCallback(self,self.getM)
    ChangeChatChannel(Chat_Channel_WndAscending_Tab1)
end

--@brief	获得材料
function WndGradeStrengthen:getM(tag, tData)
	WZLog("WndGradeStrengthen:getM")
	WndFastGetItems:show(tData.basicInfo.id)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	点击调品按钮
function WndGradeStrengthen:onSure()
	WZLog("WndGradeStrengthen:onSure", WndGradeStrengthen.m_bRunning)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--是否选中装备
	if self.m_tEquipBefore == nil then
		MsgBoxManager:showTipBox(LocalStrings.PLEASE_ADD_WEAPON_FIRST)
		return
	end
	--材料是否足够
	local needNum = tonumber(GetElement(self.m_root,"cost",WZUILabelTTF):getText())
	local ownNum = self.m_nOwnM or 0
	if ownNum < needNum then
		MsgBoxManager:showTipBox(LocalStrings.ASCENDING19)
		return
	end
	--调品箱是否足够
	local num1 = CacheCenter:getPlayerItemCountById(ORANGECHANGEGRADEMATERIAL)
	if num1 < 1 then
        MsgBoxManager:showConfirmBox(LocalStrings.ASCENDING21, self, self.buy, nil, nil)
		return
	end

	if WndGradeStrengthen.m_bRunning == true then return end
	WndGradeStrengthen.m_bRunning = true
	self.m_root:enableSchedule("sendProtocol2", 1.5)
	GetElement(self.m_root,"ani2",WZUISpine):setVisible(true)
	GetElement(self.m_root,"ani2",WZUISpine):play("1", false)
end

--@brief	购买调品箱
function WndGradeStrengthen:buy(btnTag)
	WZLog("WndGradeStrengthen:buy",btnTag == MSGBOXTYPE_CONFIRM)
    --if btnTag == MSGBOXTYPE_CONFIRM then
        checkIsOnSale(ORANGECHANGEGRADEMATERIAL)
    --end
end

--@brief	发送协议
function WndGradeStrengthen:sendProtocol2()
	self.m_root:disableSchedule()
	GetElement(self.m_root,"ani2",WZUISpine):setVisible(false)
	self.original = GetElement(self.m_root,"txtGrade",WZUILabelTTF):getText()
	ProtocolProcessorWndAscending:send_ADVANCED_AdjustQuality(self.m_tEquipBefore.playerItemId )
end

function WndGradeStrengthen:playSound()
    SoundManager:playEffectSound(SoundDefine.E_S_STRENGTHEN_SUCCESS)
end

--@brief	调品完成
function WndGradeStrengthen:onSureFinish()
	--self:cleanWnd()
	PopupResult("ui/common/common_icon_tpsb.png")

    local wnd = WndAscendingTip:createElement()
    WindowManager:addWindow(wnd, WndAscendingTip, false)
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndGradeStrengthen:_adaptLanguage_vn(  )
	GetElement(self.m_root,"has",WZUILabelTTF):setText("("..LocalStrings.OWN..":"..CacheCenter:getPlayerItemCountById(blueprintID)..")")
end

function WndGradeStrengthen:_adaptLanguage_en(  )
	GetElement(self.m_root,"has",WZUILabelTTF):setText("("..LocalStrings.OWN..":"..CacheCenter:getPlayerItemCountById(blueprintID)..")")
	GetElement(self.m_root,"txtGrade",WZUILabelTTF):setScale(0.7)

	GetElement(self.m_root,"txtTip_WndGradeStrengthen",WZUILabelTTF):setScale(0.8)
end

function WndGradeStrengthen:_adaptLanguage_th(  )
	GetElement(self.m_root,"has",WZUILabelTTF):setText("("..LocalStrings.OWN..":"..CacheCenter:getPlayerItemCountById(blueprintID)..")")
end

function WndGradeStrengthen:_adaptLanguage_pt(  )
	GetElement(self.m_root,"has",WZUILabelTTF):setText("("..LocalStrings.OWN..":"..CacheCenter:getPlayerItemCountById(blueprintID)..")")
	local txtGrade = GetElement(self.m_root,"txtGrade",WZUILabelTTF)
	txtGrade:setScale(0.7)
	txtGrade:setDimensions(GlobalMethod:CCSize(120))

	GetElement(self.m_root,"txtTip_WndGradeStrengthen",WZUILabelTTF):setScale(0.8)
end

function WndGradeStrengthen:_adaptLanguage_es(  )
	GetElement(self.m_root,"has",WZUILabelTTF):setText("("..LocalStrings.OWN..":"..CacheCenter:getPlayerItemCountById(blueprintID)..")")
	local txtGrade = GetElement(self.m_root,"txtGrade",WZUILabelTTF)
	txtGrade:setScale(0.7)
	txtGrade:setDimensions(GlobalMethod:CCSize(120))
	for i=1,3 do
		local txtSure = GetElement(self.m_root,"txtSure"..i.."_WndGradeStrengthen",WZUILabelTTF)
		txtSure:setDimensions(GlobalMethod:CCSize(130,0))
		txtSure:setScale(0.8)
	end
	GetElement(self.m_root,"txtCost",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.16,0.78))

	GetElement(self.m_root,"txtTip_WndGradeStrengthen",WZUILabelTTF):setScale(0.8)
end

function WndGradeStrengthen:_adaptLanguage_tr(  )
	GetElement(self.m_root,"has",WZUILabelTTF):setText("("..LocalStrings.OWN..":"..CacheCenter:getPlayerItemCountById(blueprintID)..")")
	GetElement(self.m_root,"txtCost",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.16,0.78))

	local txtGrade = GetElement(self.m_root,"txtGrade",WZUILabelTTF)
	txtGrade:setScale(0.7)
	txtGrade:setDimensions(GlobalMethod:CCSize(120))
end
-------------------------------------语言适配End--------------------------------------------
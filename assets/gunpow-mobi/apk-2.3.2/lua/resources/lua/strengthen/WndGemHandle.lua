--WndGemHandle.lua
--@brief	WndGemHandle的UI模块
--@date		2019/07/22
--@author	yrd
--@note		宝石融合


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGemHandle:onEnter(element)
	self.m_root = element

	-- self:_update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGemHandle:onExit(element)
	self:_unInit()
end

function WndGemHandle:onCloseClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

function WndGemHandle:_updateFuse()	
	GetElement(self.m_root,"btnFuse_WndGemHandle",WZUIButton):setVisible(true)

	local gem_info = {}
	for _, value in pairs(GDatatab_dig_change) do
		if value.id == self.m_tGemData.id then
			gem_info = value
			break
		end
	end

	-- 左边宝石
	local pre_id = gem_info.id
	local conLeftItem = GetElement(self.m_root,"conLeftItem_WndGemHandle",WZUIContainer)
	local celElement,tLuaObj = CellGoodItem:createElement()
	if celElement ~= nil and tLuaObj ~= nil then
		tLuaObj:setCellGoodLocalId(pre_id, 4)
		tLuaObj:setItemClickFun(self,self.onClickLeftItem)
		conLeftItem:addChild(celElement)
	end

	local leftItemInfo = GDatatab_item["id_"..pre_id]
	for i=1, #leftItemInfo.property do
		local txtLeftExtra = GetElement(self.m_root,"txtLeftExtra"..i.."_WndGemHandle",WZUILabelTTF)
		txtLeftExtra:setText(ATTR_TITLE[leftItemInfo.property[i][1]])
		local txtLeftExtraNum = GetElement(self.m_root,"txtLeftExtraNum"..i.."_WndGemHandle",WZUILabelTTF)
		txtLeftExtraNum:setText(leftItemInfo.property[i][2])
	end

	-- 右边宝石
	local post_id = gem_info.post_id
	local conRightItem = GetElement(self.m_root,"conRightItem_WndGemHandle",WZUIContainer)
	local celElement,tLuaObj = CellGoodItem:createElement()
	if celElement ~= nil and tLuaObj ~= nil then
		tLuaObj:setCellGoodLocalId(post_id, 4)
		tLuaObj:setItemClickFun(self,self.onClickRightItem)
		conRightItem:addChild(celElement)
	end

	local rightItemInfo = GDatatab_item["id_"..post_id]
	for i=1, #rightItemInfo.property do
		local txtRightExtra = GetElement(self.m_root,"txtRightExtra"..i.."_WndGemHandle",WZUILabelTTF)
		txtRightExtra:setText(ATTR_TITLE[rightItemInfo.property[i][1]])
		local txtRightExtraNum = GetElement(self.m_root,"txtRightExtraNum"..i.."_WndGemHandle",WZUILabelTTF)
		txtRightExtraNum:setText(rightItemInfo.property[i][2])
		GetElement(self.m_root, "imgArrow" .. i .. "_WndGemHandle", WZUIImage):setVisible(true)
	end

	-- 消耗
	for i=1, #gem_info.fuse_up do
		local imgCost = GetElement(self.m_root,"imgCost"..i.."_WndGemHandle",WZUIImage)
		imgCost:setFile(GDatatab_item["id_"..gem_info.fuse_up[i][1]].icon)
		local txtCost = GetElement(self.m_root,"txtCost"..i.."_WndGemHandle",WZUILabelTTF)
		txtCost:setText(gem_info.fuse_up[i][2])
	end
	local tmpnum = CacheCenter:getPlayerItemCountById(gem_info.fuse_up[2][1])
	GetElement(self.m_root, "txtCost2N_WndGemHandle", WZUILabelTTF):setText(string.format(LocalStrings.GEM_MOUNTING_11, tmpnum))
end

function WndGemHandle:_updateAscending()
	GetElement(self.m_root,"btnAscending_WndGemHandle",WZUIButton):setVisible(true)

	local gem_info = {}
	for _, value in pairs(GDatatab_dig_up) do
		if value.id == self.m_tGemData.id then
			gem_info = value
			break
		end
	end

	-- 左边宝石
	local pre_id = gem_info.id
	local conLeftItem = GetElement(self.m_root,"conLeftItem_WndGemHandle",WZUIContainer)
	local celElement,tLuaObj = CellGoodItem:createElement()
	if celElement ~= nil and tLuaObj ~= nil then
		tLuaObj:setCellGoodLocalId(pre_id, 4)
		tLuaObj:setItemClickFun(self,self.onClickLeftItem)
		conLeftItem:addChild(celElement)
	end

	local leftItemInfo = GDatatab_item["id_"..pre_id]
	for i=1, #leftItemInfo.property do
		local txtLeftExtra = GetElement(self.m_root,"txtLeftExtra"..i.."_WndGemHandle",WZUILabelTTF)
		txtLeftExtra:setText(ATTR_TITLE[leftItemInfo.property[i][1]])
		local txtLeftExtraNum = GetElement(self.m_root,"txtLeftExtraNum"..i.."_WndGemHandle",WZUILabelTTF)
		txtLeftExtraNum:setText(leftItemInfo.property[i][2])
	end
	
	-- 右边宝石
	local post_id = gem_info.behind_id
	local conRightItem = GetElement(self.m_root,"conRightItem_WndGemHandle",WZUIContainer)
	local celElement,tLuaObj = CellGoodItem:createElement()
	if celElement ~= nil and tLuaObj ~= nil then
		tLuaObj:setCellGoodLocalId(post_id, 4)
		tLuaObj:setItemClickFun(self,self.onClickRightItem)
		conRightItem:addChild(celElement)
	end

	local rightItemInfo = GDatatab_item["id_"..post_id]
	for i=1, #rightItemInfo.property do
		local txtRightExtra = GetElement(self.m_root,"txtRightExtra"..i.."_WndGemHandle",WZUILabelTTF)
		txtRightExtra:setText(ATTR_TITLE[rightItemInfo.property[i][1]])
		local txtRightExtraNum = GetElement(self.m_root,"txtRightExtraNum"..i.."_WndGemHandle",WZUILabelTTF)
		txtRightExtraNum:setText(rightItemInfo.property[i][2])
	end

	-- 消耗
	for i=1, #gem_info.ad_up do
		local imgCost = GetElement(self.m_root,"imgCost"..i.."_WndGemHandle",WZUIImage)
		imgCost:setFile(GDatatab_item["id_"..gem_info.ad_up[i][1]].icon)
		local txtCost = GetElement(self.m_root,"txtCost"..i.."_WndGemHandle",WZUILabelTTF)
		txtCost:setText(gem_info.ad_up[i][2])
	end
	local tmpnum = CacheCenter:getPlayerItemCountById(gem_info.ad_up[2][1])
	GetElement(self.m_root, "txtCost2N_WndGemHandle", WZUILabelTTF):setText(string.format(LocalStrings.GEM_MOUNTING_11, tmpnum))
end

--@brief 主槽宝石点击回调
function WndGemHandle:onClickLeftItem(tItem, nTag, tData)
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

--@brief 副槽宝石点击回调
function WndGemHandle:onClickRightItem(tItem, nTag, tData)
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

function WndGemHandle:onAscending(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local gem_info = {}
	for _, value in pairs(GDatatab_dig_up) do
		if value.id == self.m_tGemData.id then
			gem_info = value
			break
		end
	end

    local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.REWARD_BTN_GET}
    if not JudgeMoneyIsEnough(gem_info.ad_up[1][1], gem_info.ad_up[1][2]) then 
        return 
    end

    if CacheCenter:getPlayerItemCountById(gem_info.ad_up[2][1]) < gem_info.ad_up[2][2] then
    	WndFastGetItems:show(gem_info.ad_up[2][1])
    	return
    end

	local stoneType = nil
	if self.m_tGemData.basicInfo.sub_type == 1 then
		stoneType = 1
	elseif self.m_tGemData.basicInfo.sub_type == 2 then
		stoneType = 2
	elseif self.m_tGemData.basicInfo.sub_type == 0 then
		stoneType = 3
	elseif self.m_tGemData.basicInfo.sub_type == 5 then
		stoneType = 4
	end
	local pItemId = WZLuaVector_int_:create()
	local pNum = WZLuaVector_int_:create()
	if stoneType then
		ProtocolProcessorStrengthen:send_FORGING_GemOperate(3, self.m_tCurSelectedEquip.playerItemId, stoneType, pItemId, pNum)
	end
end

function WndGemHandle:onFuse(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	local gem_info = {}
	for _, value in pairs(GDatatab_dig_change) do
		if value.id == self.m_tGemData.id then
			gem_info = value
			break
		end
	end

    local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = LocalStrings.REWARD_BTN_GET}
    WZLog("WndGemHandle:onFuse one")
    if not JudgeMoneyIsEnough(gem_info.fuse_up[1][1], gem_info.fuse_up[1][2]) then 
        return 
    end

    WZLog("WndGemHandle:onFuse two")
    if CacheCenter:getPlayerItemCountById(gem_info.fuse_up[2][1]) < gem_info.fuse_up[2][2] then
    	WndFastGetItems:show(gem_info.fuse_up[2][1])
    	return
    end

	local stoneType = nil
	if self.m_tGemData.basicInfo.sub_type == 1 then
		stoneType = 1
	elseif self.m_tGemData.basicInfo.sub_type == 2 then
		stoneType = 2
	elseif self.m_tGemData.basicInfo.sub_type == 0 then
		stoneType = 3
	elseif self.m_tGemData.basicInfo.sub_type == 5 then
		stoneType = 4
	end
	local pItemId = WZLuaVector_int_:create()
	local pNum = WZLuaVector_int_:create()
    WZLog("WndGemHandle:onFuse three", stoneType)
	if stoneType then
		ProtocolProcessorStrengthen:send_FORGING_GemOperate(1, self.m_tCurSelectedEquip.playerItemId, stoneType, pItemId, pNum)
	end
end


function WndGemHandle:_showAnimal( )
	if self.m_root == nil then return end 
	
	GetElement(self.m_root,"btnAscending_WndGemHandle",WZUIButton):setTouchContainerEnable(false)
	local spUp = GetElement(self.m_root,"spUp_WndGemHandle",WZUISpine)
	local spinePath = "ui/otherUI/ui_diamond_up"
	local existSpine = CheckEffectFile(spinePath)
	if existSpine then 
		spUp:setFileJson(spinePath .. ".json")
		spUp:setFileAtlas(spinePath .. ".atlas")
		spUp:play("wait",false)
		spUp:enableSchedule("_upCountDown",2)
	else
		spUp:enableSchedule("_upCountDown",0)
	end
end

function WndGemHandle:_upCountDown(element)
	element:disableSchedule()
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

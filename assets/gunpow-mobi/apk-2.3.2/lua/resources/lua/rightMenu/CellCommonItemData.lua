CellCommonItem = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellCommonItem:_init()
	self.m_root = nil
	self.m_tCommonData = nil
end

function CellCommonItem:_unInit()
	self.m_root = nil
	self.m_tCommonData = nil
end
--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellCommonItem:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellCommonItem table create failed!")
	tNewObj:_init()
	
	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setAbsContentSize(GlobalMethod:CCSize(626,122))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end
function CellCommonItem:setMessageData(data)
	self.m_tCommonData = data
end
--@brief    加载cell数据信息
function CellCommonItem:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellTotalRechargeItem")
    self.m_root:addChild(cellElement)

    AdaptLanguage(self)

    self:setData()
end
function CellCommonItem:setData( )
	if not self.m_tCommonData then return end

	local btn_getReward_item = GetElement(self.m_root,"btn_getReward_item",WZUIButton)
	local txt_button_item = GetElement(btn_getReward_item,"txt_button_item",WZUILabelTTF)
	local img_get = GetElement(self.m_root,"img_get",WZUIImage)
	img_get:setVisible(false)
	local txtOverdue = GetElement(self.m_root,"txtOverdue",WZUILabelTTF)
	txtOverdue:setVisible(false)
	if self.m_tCommonData.status == -1 then --未领取
		btn_getReward_item:setVisible(true)
		btn_getReward_item:setTouchEnable(false)
		if self.m_tCommonData.activityType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_BIGSEND then 
			txt_button_item:setText(LocalStrings.INVITE_RECEIVE)
		else
			txt_button_item:setText(LocalStrings.NEWFIRSTCHARGE_TEXT5)
		end
		txt_button_item:setStrokeColor(GlobalMethod:ccc3(80,61,50))
        txt_button_item:setColor(GlobalMethod:ccc3(255,255,255))
	elseif self.m_tCommonData.status == 0 then --可领取
		btn_getReward_item:setVisible(true)
		btn_getReward_item:setTouchEnable(true)
		if self.m_tCommonData.activityType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_BIGSEND then 
			txt_button_item:setText(LocalStrings.INVITE_RECEIVE)
		else
			txt_button_item:setText(LocalStrings.CAN_GET)
		end
		txt_button_item:setStrokeColor(GlobalMethod:ccc3(0,108,3))
        txt_button_item:setColor(GlobalMethod:ccc3(255,250,236))
	elseif self.m_tCommonData.status == 1 then --已领取
		btn_getReward_item:setVisible(false)
		img_get:setVisible(true)
	elseif self.m_tCommonData.status == 2 then --已过期
		btn_getReward_item:setVisible(false)
		txtOverdue:setVisible(true)
	end

	local descFreeText = GetElement(self.m_root,"descFreeText",WZUIFreeTextBox)
	if self.m_tCommonData.activityType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_BIGSEND then 
		descFreeText:setShowText(self.m_tCommonData.desc)
	else
		descFreeText:setShowText(string.format(LocalStrings.NEW_ACTIVITY_TEXT_9, self.m_tCommonData.chargeNum, self.m_tCommonData.reward_id))
	end
	for i = 1, #self.m_tCommonData.id do
        local img_con_Item = GetElement(self.m_root,"img_con_"..i.."_Item",WZUIContainer)
        local basicInfo = GDatatab_item["id_"..self.m_tCommonData.id[i]]
        if basicInfo then 
        	local celElement,tLuaObj = CellGoodItem:createElement()
            celElement = WZUIContainer:luaTo(celElement)
            local itemInfo = {id = self.m_tCommonData.id[i], name = basicInfo.name, icon = basicInfo.icon, lastTime = self.m_tCommonData.num[i], lastNum = self.m_tCommonData.num[i], quality = basicInfo.quality, basicInfo = CopyTable(basicInfo)}
            tLuaObj:setCellGoodItem(itemInfo,17)
            celElement:setScale(0.90)
            tLuaObj:setItemClickFun(self,self.onOthersClick)
            img_con_Item:addChild(celElement)
        end
    end
end
--@brief    其它Item点击回调
function CellCommonItem:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,WndActivityIntegrate.m_root,1,tData,false, nil, true)
end

function CellCommonItem:event_getReward()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tCommonData then
		if self.m_tCommonData.activityType == g_tGameActivityTypes.ACTIVITY_NEWSERVER_BIGSEND then 
			ProtocolProcessorFestivalActivity:send_ACTIVITY2_ReceiveTaskReward(self.m_tCommonData.activityId, self.m_tCommonData.reward_id)
		else
			ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.m_tCommonData.activityId,self.m_tCommonData.reward_id)
		end
	end
end
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellCommonItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end


--------------------------------------语言适配Begin-----------------------------------------

function CellCommonItem:_adaptLanguage_vn(  )
	local btn_getReward_item = GetElement(self.m_root,"btn_getReward_item",WZUIButton)
	local txt_button_item = GetElement(btn_getReward_item,"txt_button_item",WZUILabelTTF)
	txt_button_item:setScale(0.7)
end

---------------------------------------语言适配End------------------------------------------
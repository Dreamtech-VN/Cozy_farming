--WndDoubleSevenPropData.lua
--@brief	WndDoubleSevenProp的数据模块
--@date		2020/08/04
--@author	hyx
--@note		告白道具

WndDoubleSevenProp = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDoubleSevenProp:_init()
	self.m_root = nil	 	  			--场景根节点
	self.propIndex = 1
	self.m_sPropGiveName = ""
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDoubleSevenProp:_unInit()
	self.m_root = nil
	self.propIndex = 1
	self.m_sPropGiveName = ""
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDoubleSevenProp:createElement(index, name)
	if WndDoubleSevenProp.m_root ~= nil then
		WindowManager:removeWindow(WndDoubleSevenProp.m_root, WndDoubleSevenProp, true)
	end
	local element = WZUISystem:getInstance():createElement("WndDoubleSevenProp")
	assert(element, "WndDoubleSevenProp create element failed!")
	self:_init()
	self.propIndex = index
	self.m_sPropGiveName = name
	return element
end

--*************** 告白子项 *****************
CellDoubleSevenPropItem = {}
function CellDoubleSevenPropItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellDoubleSevenPropItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellDoubleSevenPropItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(822,110))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function CellDoubleSevenPropItem:setPropInitMessage(sendID,ids, nums, iten_num)
	self.m_nSendID = sendID
	self.prop_ids = ids
	self.prop_nums = nums
	self.iten_num = iten_num --物品id
end
--@brief 	开始加载
function CellDoubleSevenPropItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("prop_item")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:upDatePropItem()
end

function CellDoubleSevenPropItem:upDatePropItem()
	GetElement(self.m_root,"other_desc",WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT9)
	GetElement(self.m_root,"my_desc",WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT8)
	local btnProp = GetElement(self.m_root,"btnProp",WZUIButton)
	local iten_num = 70
	if ProjConfig.LANGUAGE == "vn" then
		iten_num = 1
	end
	if self.iten_num == iten_num then
	else
		btnProp:setRelativePosition(GlobalMethod:ccp(0.907,0.50))
	end
	GetElement(btnProp,"btnPropLabel",WZUILabelTTF):setText(LocalStrings.DOUBLE_SEVEN_TEXT6)

	self.prop_nums = tonumber(self.prop_nums)
	local price = WndDoubleSeven:getFlowerPriceValue()
	local other_value = GetElement(self.m_root,"other_value",WZUILabelTTF)
	local other_num = WndDoubleSeven:getConfreeOtherValue(tonumber(self.prop_ids))
	other_value:setText(other_num*self.prop_nums)

	local my_value = GetElement(self.m_root,"my_value",WZUILabelTTF)
	local my_num = WndDoubleSeven:getConfreeMyValue(tonumber(self.prop_ids))
	my_value:setText(my_num*self.prop_nums)
	if ProjConfig.LANGUAGE == "vn" then
		other_value:setRelativePosition(GlobalMethod:ccp(0.4,0.613))
		my_value:setRelativePosition(GlobalMethod:ccp(0.42,0.307))
	end

	local consume_freetext = GetElement(self.m_root,"consume_freetext",WZUIFreeTextBox)
	consume_freetext:setVisible(false)
    local tTempItem = GDatatab_item["id_"..self.prop_ids]
    if ProjConfig.LANGUAGE == "vn" and tonumber(self.prop_ids) == 1 then
		tTempItem = GDatatab_item["id_1"]
	end
    if tTempItem ~= nil then
    	if self.iten_num == iten_num then
    		consume_freetext:setVisible(true)
    	end
    	local str = string.format([[<I Z="0.5" P="1">%s</I><T C="127,70,26" S="20" P="1">%d</T>]],tTempItem.icon,self.prop_nums*WndDoubleSeven:getFlowerPriceValue())
		consume_freetext:setShowText(str)

        local item_container = GetElement(self.m_root,"item_container",WZUIContainer)
        local itemImage = GetElement(item_container,"itemImage",WZUIImage)
        local icon_str = tTempItem.icon
        if tonumber(self.prop_ids) == iten_num then
        	icon_str = "ui/doubleSeven/hd_qx_hua.png"
        end
        itemImage:setFile(icon_str)
        item_container:setScale(0.80)
        local itemCount = GetElement(item_container,"itemCount",WZUILabelTTF)
        itemCount:setText(self.prop_nums)
    end
end

function CellDoubleSevenPropItem:onClickProp()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if not self.prop_nums then return end
	local is_bind = WndDoubleSeven:getBindFriend()
	if is_bind == 0 then
		MsgBoxManager:showTipBox(LocalStrings.DOUBLE_SEVEN_TEXT29)
		return
	end
	local iten_num = 70
	if self.iten_num == 70 and ProjConfig.LANGUAGE == "vn" then
		iten_num = 1
	else
		iten_num = self.iten_num
	end
	local monNum =  CacheCenter:getPlayerItemCountById(iten_num)
	if self.iten_num == iten_num then
		if monNum >= self.prop_nums then
			ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiGiveGift(tonumber(self.m_nSendID))
		else
			JudgeMoneyIsEnough(iten_num, self.prop_nums, nil, nil, 266, nil, nil, nil, nil, self, self.sureUseDiamondInstead)
		end
	else
		if monNum >= self.prop_nums then
			ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiGiveGift(tonumber(self.m_nSendID))
		else
			MsgBoxManager:showTipBox(LocalStrings.DOUBLE_SEVEN_TEXT31)
		end
	end
end
function CellDoubleSevenPropItem:sureUseDiamondInstead()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_nSendID then
		ProtocolProcessorNewActivity:send_ACTIVITY2_QiXiGiveGift(tonumber(self.m_nSendID))
	end
end
--@return	新建的表实例对象
function CellDoubleSevenPropItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

--CellOneRechargeAct.lua
--@brief	CellOneRechargeAct的UI模块
--@date		2020/07/02
--@author	yrd
--@note		幸运一元冲活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellOneRechargeAct:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellOneRechargeAct:onExit(element)
	self:_unInit()
end

--@brief    显示窗口
function CellOneRechargeAct:showWindow()
	self:_initUI()
end

--@brief    初始化
function CellOneRechargeAct:_initUI()
	self:_showTime()
	self:_initStaticText()
	self:_showReward()
end

--@brief    点击"去充值"按钮
function CellOneRechargeAct:onRecharge(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndOneRechargeActivity:showInterface()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief    设置活动时间
function CellOneRechargeAct:_showTime()
    --字“活动时间”
    local txtTimeKey = GetElement(self.m_root,"txtTimeKey_CellOneRechargeAct",WZUILabelTTF)
    if txtTimeKey then
        txtTimeKey:setText(LocalStrings.ACTIVE_TIME .. ":")
    end
    --活动具体日期
    local txtTimeValue = GetElement(self.m_root, "txtTimeValue_CellOneRechargeAct", WZUILabelTTF)
    if txtTimeValue then
        local startDate = os.date("*t", self.startTime)
        local endDate = os.date("*t", self.endTime)
        local sTimeContent = string.format(LocalStrings.ACTIVITYTIME_FORMAT, startDate.month, startDate.day, startDate.hour, startDate.min, endDate.month, endDate.day, endDate.hour, endDate.min)
        txtTimeValue:setText(sTimeContent)
    end
end

--@brief    设置静态文本
function CellOneRechargeAct:_initStaticText()
    local ftbDesc = GetElement(self.m_root,"ftbDesc_CellOneRechargeAct",WZUIFreeTextBox)
    ftbDesc:setShowText(LocalStrings.ACTIVITY_TEXT_DESC_1)
end

--@brief    设置奖励
function CellOneRechargeAct:_showReward()
	local tconReward = GetElement(self.m_root,"tconReward_CellOneRechargeAct",WZUITableContainer)
	tconReward:cleanTable()
    local index = 0 
	for i=1,#self.rewardItems do
        if self.rewardItems[i] > 0 and GDatatab_item["id_" .. self.rewardItems[i]] and (GDatatab_item["id_" .. self.rewardItems[i]].sex == 2 or GDatatab_item["id_" .. self.rewardItems[i]].sex == CacheCenter:getPlayerInfo().sex) then 
    		local cell,tCell = CellGoodItem:createElement()
        	cell:setTag(index)
        	cell = WZUIContainer:luaTo(cell)
        	tconReward:setCellElement(cell)
        	tCell:setCellGoodLocalId(self.rewardItems[i], self.rewardItemsParamCount[i], 4)
        	tCell:setItemClickFun(self, self.onItemClick)
            tCell:clearItemQualityPic(true)

            index = index + 1
        end
	end
end

--@brief    点击奖励回调
function CellOneRechargeAct:onItemClick(tItem, nTag, tData)
	WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData,false)
end
-------------------------------------私有方法模块End----------------------------------------

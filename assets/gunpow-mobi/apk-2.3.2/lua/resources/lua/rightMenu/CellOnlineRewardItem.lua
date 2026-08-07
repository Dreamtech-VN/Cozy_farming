--CellOnlineRewardItem.lua
--@brief	CellOnlineRewardItem的UI模块
--@date		2017/06/23
--@author	peiting_mao
--@note		在线奖励物品item


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellOnlineRewardItem:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellOnlineRewardItem:onExit(element)
	self:_unInit()
end

--@brief	更新内容
function CellOnlineRewardItem:_update(  )
	GetElement(self.m_root,"txtTime_CellOnlineRewardItem",WZUILabelTTF):setText(self.desc)
	local btn = GetElement(self.m_root,"btn_CellOnlineRewardItem",WZUIButton)
	local imgReceived = GetElement(self.m_root,"imgReceived_CellOnlineRewardItem",WZUIImage)
	local txtIsReceive = GetElement(self.m_root,"txtIsReceive_CellOnlineRewardItem",WZUILabelTTF)

	for i=1,#self.reward do
		local con = GetElement(self.m_root,"con"..i.."_CellOnlineRewardItem",WZUIContainer)
		local itemId = self.reward[i][1]
		local celElement,tCell = CellGoodItem:createElement()
		local showTimeLimit = false
		if WndGameActivity.m_root ~= nil then
			showTimeLimit = true
		end
		if celElement ~= nil then 
            celElement = WZUIContainer:luaTo(celElement)
            local itemInfo = {id = GDatatab_item["id_"..itemId].id, name=GDatatab_item["id_"..itemId].name,icon=GDatatab_item["id_"..itemId].icon,lastTime=self.reward[i][2],quality=GDatatab_item["id_"..itemId].quality,basicInfo=CopyTable(GDatatab_item["id_"..itemId]),showTimeLimit=showTimeLimit}
            tCell:setCellGoodItem(itemInfo,16)
            tCell:clearItemQualityPic()
			celElement:setScale(0.90)
			tCell:_addSidebarTimeLimit()
           	celElement:setTag(i-1)
            con:addChild(celElement)
            tCell:setItemClickFun(self,self.onOthersClick)
        end
	end
	
	if self.state == 0 then
		btn:setVisible(true)
		btn:setTouchEnable(true)
		imgReceived:setVisible(false)
        txtIsReceive:setStrokeColor(GlobalMethod:ccc3(0,108,3))
        txtIsReceive:setColor(GlobalMethod:ccc3(255,250,236))
	elseif self.state == 1 then
		WZLog("--^^^^^^^^^^1111--")
		btn:setVisible(true)
		btn:setTouchEnable(false)
		imgReceived:setVisible(false)
        txtIsReceive:setStrokeColor(GlobalMethod:ccc3(80,61,50))
        txtIsReceive:setColor(GlobalMethod:ccc3(255,255,255))
	elseif self.state == 2 then
		btn:setVisible(false)
		imgReceived:setVisible(true)
	end
end

--@brief	更新按钮状态
function CellOnlineRewardItem:_updateBtnState()
	local btn = GetElement(self.m_root,"btn_CellOnlineRewardItem",WZUIButton)
	local imgReceived = GetElement(self.m_root,"imgReceived_CellOnlineRewardItem",WZUIImage)
	local txtIsReceive = GetElement(self.m_root,"txtIsReceive_CellOnlineRewardItem",WZUILabelTTF)

	if self.state == 0 then
		btn:setVisible(true)
		btn:setTouchEnable(true)
		imgReceived:setVisible(false)
        txtIsReceive:setStrokeColor(GlobalMethod:ccc3(0,108,3))
        txtIsReceive:setColor(GlobalMethod:ccc3(255,250,236))
	elseif self.state == 1 then
		WZLog("--$$$$$$$$$111--")
		btn:setVisible(true)
		btn:setTouchEnable(false)
		imgReceived:setVisible(false)
        txtIsReceive:setStrokeColor(GlobalMethod:ccc3(80,61,50))
        txtIsReceive:setColor(GlobalMethod:ccc3(255,255,255))
	elseif self.state == 2 then
		btn:setVisible(false)
		imgReceived:setVisible(true)
	end
end

--@brief	点击物品弹出对应的tips
function CellOnlineRewardItem:onOthersClick(tCell,tag,tData)
    if tData == nil then
       return
    end
    WndItemInfo:onCloseClick()
   	--WndItemInfo:showInfo(tCell.m_root,CellOnLineReward.m_current.m_root,1,tData,false)
	if WndGameActivity.m_root ~= nil then
		WZLog("点击新在线物品")
    	WndItemInfo:showInfo(tCell.m_root,WndActivityIntegrate.m_root,1,tData,false, nil, true)
	else
    	WndItemInfo:showInfo(tCell.m_root,WndActivityIntegrate.m_root,1,tData,false, nil, true)
	end
end

--@brief	按钮点击事件
function CellOnlineRewardItem:onFunctionClick( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    ProtocolProcessorWndOnLineReward:send_ONLINEREWARD_GetReward(self.id)
   	GetElement(self.m_root,"btn_CellOnlineRewardItem",WZUIButton):setVisible(false)
	GetElement(self.m_root,"imgReceived_CellOnlineRewardItem",WZUIImage):setVisible(true)
end

--@brief	新服在线奖励
function CellOnlineRewardItem:onNewClick( element )
	WZLog("CellOnlineRewardItem:onNewClick", self.activityId, self.id)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.activityId, self.id )
   	GetElement(self.m_root,"btn_CellOnlineRewardItem",WZUIButton):setVisible(false)
	GetElement(self.m_root,"imgReceived_CellOnlineRewardItem",WZUIImage):setVisible(true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------




-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-----------------------------------------
function CellOnlineRewardItem:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtTime_CellOnlineRewardItem",WZUILabelTTF):setScale(0.7)
end

function CellOnlineRewardItem:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtTime_CellOnlineRewardItem",WZUILabelTTF):setScale(0.7)
end

function CellOnlineRewardItem:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtTime_CellOnlineRewardItem",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100))
end

function CellOnlineRewardItem:_adaptLanguage_tr(  )
	GetElement(self.m_root,"txtTime_CellOnlineRewardItem",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(100))
end

function CellOnlineRewardItem:_adaptLanguage_es(  )
	local txtTime = GetElement(self.m_root,"txtTime_CellOnlineRewardItem",WZUILabelTTF)
	txtTime:setScale(0.7)
	txtTime:setDimensions(GlobalMethod:CCSize(100))
end

function CellOnlineRewardItem:_adaptLanguage_th(  )
	GetElement(self.m_root,"txtTime_CellOnlineRewardItem",WZUILabelTTF):setScale(0.9)
end

function CellOnlineRewardItem:_adaptLanguage_ug(  )
	local txtTime = GetElement(self.m_root,"txtTime_CellOnlineRewardItem",WZUILabelTTF)
	txtTime:setScale(0.65)
	txtTime:setDimensions(GlobalMethod:CCSize(100))
end
---------------------------------------语言适配End------------------------------------------
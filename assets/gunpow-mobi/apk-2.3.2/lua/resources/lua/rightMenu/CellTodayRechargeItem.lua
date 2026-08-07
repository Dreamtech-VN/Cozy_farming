--CellTodayRechargeItem.lua
--@brief	CellTodayRechargeItem的UI模块
--@date		2016/07/18
--@author	maopeiting
--@note		每日充值奖励


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTodayRechargeItem:onEnter(element)
	self.m_root = element
	CellTodayRechargeItem.m_click_current = self
    
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTodayRechargeItem:onExit(element)
	self:_unInit()
end

--@brief    加载item
function CellTodayRechargeItem:ShowCellItem(  )
    self:_initItemMsg()
    self:_setRewardList()
end

--@brief	领取按钮的回调方法
function CellTodayRechargeItem:onReceive(  )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    self.m_nloadingId = MsgBoxManager:showLoadingBox()
    WZLog("CellTodayRechargeItem:self.m_nloadingId",self.m_nloadingId)
    CellTodayRechargeItem.m_current_click = self
    --发送领取奖励协议
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.typeIndex,self.rewardId)
    WZLog("*****CellTodayRechargeItem:send_ACTIVITY_ReceiveActivityReward*****")
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@breif    设置Item显示的信息
function CellTodayRechargeItem:_initItemMsg(  )

	--WZLog("CellTodayRechargeItem:self.count",self.count)
    local txtNum = GetElement(self.m_root,"txtNum_CellTodayRechargeItem",WZUILabelTTF)
    txtNum:setText(self.target)
    --WZLog("CellTodayRechargeItem:self.num",self.num)

    local txtReward = GetElement(self.m_root,"txtGet_CellTodayRechargeItem",WZUILabelTTF)
    local txtNo = GetElement(self.m_root,"txt_CellTodayRechargeItem",WZUILabelTTF)

    --local getReward = GetElement(self.m_root,"btnGetReward_CellTodayRechargeItem",WZUIButton)
    --if getReward == nil then
        --return
   -- end
    WZLog("----CellTodayRechargeItem:self.status----",self.status)
    if -1==tonumber(self.status) then
        --getReward:setTouchEnable(false)
        txtReward:setVisible(false)
        txtNo:setVisible(true)
        txtNo:setText(LocalStrings.LEAGUE_REWARD_TEXT9)
        --txtGetReward:setStrokeSize(4)
        --txtGetReward:setStrokeColor(GlobalMethod:ccc3(79,60,48))0
        --txtGetReward:setColor(GlobalMethod:ccc3(255,255,255))
        -- if tonumber(self.status)==1 then 
        --     txtGetReward:setVisible(true)
        --     --getReward:setVisible(false)
        --     --已领取
        --     --self:_ShowGetRewarded()
        -- end
    elseif tonumber(self.status)==1 then
        --getReward:setTouchEnable(true)
        txtReward:setVisible(true)
        txtReward:setText(LocalStrings.LEAGUE_REWARD_TEXT7)
        txtNo:setVisible(false)
    end
    AdaptLanguage(self)
end

--@brief    奖励获取成功回调  
-- function CellTodayRechargeItem:_GetRewardOk(  )
--     WZLog("CellTodayRechargeItem:_GetRewardOk")
--     local getReward = GetElement(self.m_root,"btnGetReward_CellTodayRechargeItem",WZUIButton)
--     if getReward == nil then
--         WZLog("getReward is nil")
--         return
--     end

--     local txtGetReward = GetElement(self.m_root,"txtGet_CellTodayRechargeItem",WZUILabelTTF)

--     txtGetReward:setVisible(false)
--     getReward:setVisible(false)

--     self:_ShowGetRewarded()

--     -- if self.m_FuncCallback ~= nil then 
--     --     local tluaObj = self.m_tCallBackLuaObjMap[self.m_FuncCallback]
--     --     self.m_FuncCallback(tluaObj,self.rewardId)
--     -- end
-- end


--@brief    显示奖励图标
function CellTodayRechargeItem:_setRewardList(  )
    local ItemCount = #self.m_tData
    for i=1,ItemCount do
        local con = GetElement(self.m_root,"con"..i.."_CellTodayRechargeItem",WZUIContainer)
        local key = "id_"..self.m_tData[i].id
        WZLog("------"..key)
        local celElement,tLuaObj = CellGoodItem:createElement()
        if celElement and tLuaObj then 
            
            local itemInfo = {id = self.m_tData[i].id, name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=self.m_tData[i].num,quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
            tLuaObj:setCellGoodItem(itemInfo,4)
 
            celElement:setTag(i-1)
            tLuaObj:setItemClickFun(self,self.onOthersClick)
        end
        con:addChild(celElement)
    end
end

--@brief    点击Item时回调tips
function CellTodayRechargeItem:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,CellTodayRechargePanel.m_current.m_root,1,tData,false)
end

--@brief 	顯示已領取獎勵圖標
-- function CellTodayRechargeItem:_ShowGetRewarded(  )
--     local txtGetReward = WZUILabelTTF:create()
--     txtGetReward:setText(LocalStrings.ACTIVE_GET)
--     txtGetReward:setRelativePosition(GlobalMethod:ccp(0.6,0.5))
--     txtGetReward:setColor(GlobalMethod:ccc3(138,122,106))
--     txtGetReward:setFontSize(22)
--     local con = GetElement(self.m_root,"conBtn_CellTodayRechargeItem",WZUIContainer)
--     con:addChild(txtGetReward)
   
-- end



-------------------------------------私有方法模块End----------------------------------------


--------------------------------------语言适配Begin-----------------------------------------
function CellTodayRechargeItem:_adaptLanguage_es(  )
    GetElement(self.m_root,"txt_CellTodayRechargeItem",WZUILabelTTF):setScale(0.8)
end

function CellTodayRechargeItem:_adaptLanguage_tr(  )
    local txt = GetElement(self.m_root,"txt_CellTodayRechargeItem",WZUILabelTTF)
    txt:setColor(GlobalMethod:ccc3(105,65,46))
    txt:setFontSize(16)
    txt:setStrokeSize(0)
    txt:setStrokeColor(GlobalMethod:ccc3(0,255,0))
end

function CellTodayRechargeItem:_adaptLanguage_en(  )
    local txt = GetElement(self.m_root,"txt_CellTodayRechargeItem",WZUILabelTTF)
    txt:setColor(GlobalMethod:ccc3(105,65,46))
    txt:setFontSize(20)
    txt:setStrokeSize(0)
    txt:setStrokeColor(GlobalMethod:ccc3(0,255,0))
end
---------------------------------------语言适配End------------------------------------------
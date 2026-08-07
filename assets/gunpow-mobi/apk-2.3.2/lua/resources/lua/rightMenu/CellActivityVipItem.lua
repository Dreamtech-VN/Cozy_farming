--CellActivityVipItem.lua
--@brief	CellActivityVipItem的UI模块
--@date		2015/07/04
--@author	weidong_wu
--@note		vip奖励物品列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellActivityVipItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellActivityVipItem:onExit(element)
	self:_unInit()
end

--@brief    其它Item点击回调
function CellActivityVipItem:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,CellActivityVipPanel.m_current.m_root,1,tData,false)
end


function CellActivityVipItem:event_getReward( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.status == 0 then 
        --背包已满提示
        if CacheCenter:getRemainAmount() <= 0 then
            MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
            return
        end
        
		CellActivityVipItem.m_current_click = self
		self.m_nloadingId = MsgBoxManager:showLoadingBox()
		ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.activityId, self.rewardId )
	elseif self.status == -1 then 
        local sSureText = LocalStrings.ACTIVE_BTN_GO .. LocalStrings.REWARD_BTN_GET
        if ProjConfig.LANGUAGE ~= "cn" then
            sSureText = LocalStrings.ACTIVE_BTN_GO .. " " .. LocalStrings.REWARD_BTN_GET
        end
        local tCustomUIConfig = {[MSGBOXUICFG_CONFIRM] = sSureText }
        MsgBoxManager:showConfirmBox(LocalStrings.SELECT_VIP_GIFT_ATT, self, self.needMoreDiamondCallBack, nil, tCustomUIConfig)
	end 
end

function CellActivityVipItem:needMoreDiamondCallBack(nId, nResType)
    -- body
    if nResType == MSGBOXRESTYPE_CONFIRM then
        PassportSdkManager:gotoPaymentPage()
    end
end

function CellActivityVipItem:getIndex()
    -- body
    return self.index
end

function CellActivityVipItem:event_leftExPlain( element )
	WZLog("CellActivityGifPanel:event_leftExPlain")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
end

function CellActivityVipItem:event_rightExPlain( element )
	WZLog("CellActivityGifPanel:event_rightExPlain")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
end

--@brief    加载cell数据信息
function CellActivityVipItem:onLoadData(element)
    -- body
    WZLog("--CellActivityVipItem:onLoadData--")
    local cellElement = WZUISystem:getInstance():createElement("CellActivityVipItem")
    self.m_root:addChild(cellElement)
    self:_update()
    
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function CellActivityVipItem:_update()
    if self.m_root == nil then return end
    
    self:_setButtonTxt(LocalStrings.INVITE_RECEIVE)
    GetElement(self.m_root, "txtVipLevelNum_CellActivityVipItem", WZUILabelAtlasFont):setText(self.index)
	self:_setItems()
	self:_setButtonState(self.status)
    AdaptLanguage(self)
end


function CellActivityVipItem:_setItems()
	for i=1,#self.m_tData do
		local conItem_CellActivityVipItem = GetElement(self.m_root,"conItem_"..i.."_CellActivityVipItem",WZUIContainer)
        if conItem_CellActivityVipItem then
    		local celElement,tLuaObj = CellGoodItem:createElement()
            if celElement ~= nil then 
                celElement = WZUIContainer:luaTo(celElement)
                local key = "id_"..self.m_tData[i].id
                WZLog("CellActivityVipItem:_setItems",self.m_tData[i].id, self.m_tData[i].num)
                local itemInfo = {id = self.m_tData[i].id, name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=self.m_tData[i].num,quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
                tLuaObj:setCellGoodItem(itemInfo,16)
                celElement:setTag(i-1)
                tLuaObj:setItemClickFun(self,self.onOthersClick)

                conItem_CellActivityVipItem:addChild(celElement)
            end
        end
	end
end

function CellActivityVipItem:_setButtonTxt( txtBtnName )
	local txt_button_item = GetElement(self.m_root,"txt_button_item",WZUILabelTTF)
	if txt_button_item ~= nil then 
		txt_button_item:setText(txtBtnName)
	end
end


function CellActivityVipItem:_setButtonState( state )
    WZLog("***** CellActivityVipItem:_setButtonState *****", state,self.index)
    local btn_getReward_item = GetElement(self.m_root, "btn_getReward_item", WZUIButton)
    if state == 1 then
        btn_getReward_item:setTouchEnable(false)
    else
        btn_getReward_item:setTouchEnable(true)
    end
end

--@brief    奖励获取成功回调  
function CellActivityVipItem:_GetRewardOk()
    WZLog("CellActivityVipItem:_GetRewardOk")
    if self.m_FuncCallback ~= nil then 
    	local tluaObj = self.m_tCallBackLuaObjMap[self.m_FuncCallback]
    	self.m_FuncCallback(tluaObj,self.index)
    end
end
-------------------------------------私有方法模块End----------------------------------------

---------------------------------------语言适配Begin------------------------------------------
function CellActivityVipItem:_adaptLanguage_en()
    WZLog("CellActivityVipItem:_adaptLanguage_en")
    local txtVip = GetElement(self.m_root, "txtVipLevelNum_CellActivityVipItem", WZUILabelAtlasFont)
    if txtVip ~= nil then 
        txtVip:setRelativePosition(GlobalMethod:ccp(0.11875,0.5))
    end 

    local txtReward = GetElement(self.m_root,"txtCanGet_CellActivityVipItem",WZUILabelTTF)
    if txtReward ~= nil then 
        txtReward:setRelativePosition(GlobalMethod:ccp(0.375,0.5))
    end 
    local imgArrow = GetElement(self.m_root,"imgArrow_CellActivityVipItem",WZUIImage)
    if imgArrow ~= nil then 
        imgArrow:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
    end
    
end

function CellActivityVipItem:_adaptLanguage_pt(  )
    local txtVip = GetElement(self.m_root, "txtVipLevelNum_CellActivityVipItem", WZUILabelAtlasFont)
    if txtVip ~= nil then 
        txtVip:setRelativePosition(GlobalMethod:ccp(0.11875,0.5))
    end 

    local txtReward = GetElement(self.m_root,"txtCanGet_CellActivityVipItem",WZUILabelTTF)
    if txtReward ~= nil then 
        txtReward:setRelativePosition(GlobalMethod:ccp(0.33625,0.5))
    end 
end

function CellActivityVipItem:_adaptLanguage_th()
    WZLog("CellActivityVipItem:_adaptLanguage_th")
    local txtCanGet = GetElement(self.m_root,"txtCanGet_CellActivityVipItem",WZUILabelTTF)
    if txtCanGet then
        txtCanGet:setRelativePosition(GlobalMethod:ccp(0.325833,0.5))
    end
end

function CellActivityVipItem:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtCanGet_CellActivityVipItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.325833,0.5))
end

function CellActivityVipItem:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtCanGet_CellActivityVipItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.34,0.5))
end
---------------------------------------语言适配End--------------------------------------------
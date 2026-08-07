--CellFightingPanelItem.lua
--@brief	CellFightingPanelItem的UI模块
--@date		2015/05/13
--@author	weidong_wu
--@note		战力冲刺 等级列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFightingPanelItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFightingPanelItem:onExit(element)
	self:_unInit()
end

--@brief    加载item
function CellFightingPanelItem:ShowCellItem(  )
    self:_initItemMsg()
    self:_setRewardList()
end

--@brief    tips回调
function  CellFightingPanelItem:BtnDoneEvent()
    WZLog("CellGradePanelItem:BtnDoneEvent()::"..self.tag)
    local positionY,movepositionY = CellFightingPanel:getFreeListPositionY()
    WZLog("..."..positionY.."..."..movepositionY)
    local MoveDistance = math.abs((positionY-movepositionY))%125
    --ItemTag = math.abs(ItemTag)
    --ItemTag = self:_getIntPart(ItemTag)
    local reduceItem = math.abs((positionY-movepositionY))/125

    local  ItemTag = self.tag-1
    WZLog("ItemTag="..ItemTag)
    local CellIdx = self.tag-1-math.floor(reduceItem)
   	local moveCellItem = math.abs((positionY-movepositionY))/125

    --local moveCellItem = 0.1*(MoveDistance/12.5)

    if (MoveDistance > 40.0 and CellIdx == 0) then 
        return
    end    

    if (MoveDistance < 40.0 and CellIdx == 2 ) or (MoveDistance==0 and CellIdx==2) then
        return
    end

    if CellIdx > 2 then 
    	return 
    end 
end

--@brief    获取奖励
function CellFightingPanelItem:event_getReward(  )
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
    
    self.m_nloadingId = MsgBoxManager:showLoadingBox()
    CellFightingPanelItem.m_current_click = self
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.typeIndex,self.rewardId)
end

--@brief    加载cell信息数据
function CellFightingPanelItem:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellFightingPanelItem")
    self.m_root:addChild(cellElement)
    self:ShowCellItem()
    
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@breif    设置Item显示的信息
function CellFightingPanelItem:_initItemMsg(  )
    local descFreeText = GetElement(self.m_root,"descFreeText",WZUIFreeTextBox)
    local desc = string.format([[<T C="127,70,26" S="22" P="1">%s</T><T C="229,105,22" S="22" P="1">  %s</T>]],LocalStrings.FIGHTING_TO, tostring(self.target))
    descFreeText:setShowText(desc)

    local txtBtnItem = GetElement(self.m_root,"txtBtnItem_CellFightingPanel",WZUILabelTTF)
    txtBtnItem:setText(LocalStrings.ACTIVE_BTN_GET)

    local btnItemGetReward = GetElement(self.m_root,"btnItemGetReward_CellFightingPanel",WZUIButton)
    AdaptLanguage(self)
    if btnItemGetReward == nil then
        return
    end
    if -1==tonumber(self.status) or tonumber(self.status)==1 then
        btnItemGetReward:setTouchEnable(false)
        if tonumber(self.status)==1 then 
            txtBtnItem:setVisible(false)
            btnItemGetReward:setVisible(false)
            self:_setImageIcon()
        end
        txtBtnItem:setEnableStroke(true)
        txtBtnItem:setStrokeSize(4)
        txtBtnItem:setStrokeColor(GlobalMethod:ccc3(80,61,50))
        txtBtnItem:setColor(GlobalMethod:ccc3(255,255,255))
    elseif tonumber(self.status)==0 then
        btnItemGetReward:setTouchEnable(true)
    end

end

--@brief    奖励获取成功回调  
function CellFightingPanelItem:_GetRewardOk(  )
    WZLog("CellFightingPanelItem:_GetRewardOk")
    if self.m_root == nil then return end 
    
    local btnItemGetReward = GetElement(self.m_root,"btnItemGetReward_CellFightingPanel",WZUIButton)
    if btnItemGetReward == nil then
        WZLog("btnItemGetReward is nil")
        return
    end
    btnItemGetReward:setTouchEnable(false)
    btnItemGetReward:setVisible(false)
    local txtBtnItem = GetElement(self.m_root,"txtBtnItem_CellFightingPanel",WZUILabelTTF)
    txtBtnItem:setVisible(false)
    self:_setImageIcon()
    if self.m_FuncCallback ~= nil then 
        local tluaObj = self.m_tCallBackLuaObjMap[self.m_FuncCallback]
        self.m_FuncCallback(tluaObj,self.rewardId)
    end
end

function CellFightingPanelItem:_setImageIcon(  )
    local img_GetReward = WZUIImage:create()
    img_GetReward = WZUIImage:luaTo(img_GetReward)
    img_GetReward:setFile("ui/common/commom_icon_ylq.png")
    img_GetReward:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    img_GetReward:setUseOriginSize(true)
    img_GetReward:setRotation(28)
    local conBtn = GetElement(self.m_root,"conBtn_CellFightingPanel",WZUIContainer)
    conBtn:addChild(img_GetReward, 0, 888)
end

--@breif    取一个数的整数部分
function CellFightingPanelItem:_getIntPart(x)
    if x <= 0 then
        return math.ceil(x)
    end
    if math.ceil(x) == x then
        x = math.ceil(x)
    else
        x = math.ceil(x) - 1
    end
    return x
end


--@brief    显示奖励图标
function CellFightingPanelItem:_setRewardList(  )
    local ItemCount = #self.m_tData
    for i=1,ItemCount do
        local img_con_Item = GetElement(self.m_root,"ConItem_"..i,WZUIContainer)
        local key = "id_"..self.m_tData[i].id
        WZLog("------"..key)
        local celElement,tLuaObj = CellGoodItem:createElement()
        if celElement ~= nil then 
            celElement = WZUIContainer:luaTo(celElement)
            local itemInfo = {id = self.m_tData[i].id, name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=self.m_tData[i].num,quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
            tLuaObj:setCellGoodItem(itemInfo,4)
            tLuaObj:clearItemQualityPic()
            celElement:setScale(0.90)
            celElement:setTag(i-1)
            tLuaObj:setItemClickFun(self,self.onOthersClick)
        end
        img_con_Item:addChild(celElement)
    end
end


--@brief    其它Item点击回调
function CellFightingPanelItem:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,CellFightingPanel.m_current.m_root,1,tData,false)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin--------------------------------------------
function CellFightingPanelItem:_adaptLanguage_en(  )
   
end

function CellFightingPanelItem:_adaptLanguage_pt(  )

end

function CellFightingPanelItem:_adaptLanguage_vn(  )

end

function CellFightingPanelItem:_adaptLanguage_es(  )

end

function CellFightingPanelItem:_adaptLanguage_tr(  )

end

function CellFightingPanelItem:_adaptLanguage_ug(  )
    local txtFight = GetElement(self.m_root,"txtFight_CellFightingPanelItem",WZUILabelAtlasFont)
    if txtFight ~= nil then 
        txtFight:setRelativePosition(GlobalMethod:ccp(0.52,0.5))
        --txtFight:setScale(0.76)
    end 

    GetElement(self.m_root,"imgArrow_CellFightingPanelItem",WZUIImage):setRelativePosition(GlobalMethod:ccp(0.78,0.5))
end
-------------------------------------语言适配End----------------------------------------------
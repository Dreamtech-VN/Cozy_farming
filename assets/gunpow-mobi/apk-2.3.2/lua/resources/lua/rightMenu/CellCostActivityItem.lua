--CellCostActivityItem.lua
--@brief	CellCostActivityItem的UI模块
--@date		2015/02/04
--@author	weidong_wu
--@note		竞技积分活动


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCostActivityItem:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCostActivityItem:onExit(element)
	self:_unInit()
end


--@brief 设置目标描述
function CellCostActivityItem:setTargetInfo( txtMsg )
    if not txtMsg then return end
    
 	local m_tTargetArrays =LocalStrings.ACTIVITY_TARGET_ARRAYS --{"青铜","白银","黄金"}
 	local index = 1

	local TitleMsg = LocalStrings.ACTIVITY_TARGET_TYPE_1  --{"竞技等级达%s","段"}
	index = math.ceil(tonumber(txtMsg)/10) 
	txtMsg = txtMsg - (index-1) * 10
	local conTitle_CellCostActivityItem = GetElement(self.m_root, "conTitle_CellCostActivityItem",WZUIContainer)
	if conTitle_CellCostActivityItem~=nil then
		local start_pos = GlobalMethod:ccp(0.02,0.5)
		local str_info_1 = string.format(TitleMsg[1],m_tTargetArrays[index])
		local info_1_label = self:createTTF(str_info_1,start_pos,GlobalMethod:ccp(0,0.5),22,nil,GlobalMethod:ccc3(127,70,26))
		conTitle_CellCostActivityItem:addChild(info_1_label,0,90)
        local txtSize = info_1_label:getLabelContentSize().width
		local pos = txtSize + 4
		local info_2_label = self:createTTF(tostring(txtMsg),GlobalMethod:ccp(start_pos.x+pos/580,start_pos.y),GlobalMethod:ccp(0,0.5),22,nil,GlobalMethod:ccc3(229,105,22))
		conTitle_CellCostActivityItem:addChild(info_2_label,0,91)
        txtSize = info_2_label:getLabelContentSize().width + txtSize
		local pos_end =  txtSize + 20
        if ProjConfig.LANGUAGE ~= "pt" then
    		local info_3_label = self:createTTF(TitleMsg[2],GlobalMethod:ccp(pos_end/580,start_pos.y),GlobalMethod:ccp(0,0.5),22,nil,GlobalMethod:ccc3(127,70,26))
    		conTitle_CellCostActivityItem:addChild(info_3_label,0,91)
        end
	end
end

--@brief 设置按钮状态
function CellCostActivityItem:setButtonState( state )
    if self.m_root == nil then return end 
    
	local btn_GetReward = GetElement(self.m_root,"btn_GetReward",WZUIButton)
	if btn_GetReward == nil then 
		return 
	end 
	local txt_buttonName = GetElement(self.m_root,"txt_buttonName",WZUILabelTTF)
	if txt_buttonName == nil then 
		return 
	end 
	txt_buttonName:setText(LocalStrings.INVITE_RECEIVE)
	if state == -1 or state == 1 then 
		if state == 1 then 
			txt_buttonName:setVisible(false)
			btn_GetReward:setVisible(false)
            --已领取
            self:_ShowGetRewarded()
		end 
		btn_GetReward:setTouchEnable(false)
		txt_buttonName:setEnableStroke(true)
        txt_buttonName:setStrokeSize(4)
        txt_buttonName:setStrokeColor(GlobalMethod:ccc3(80,61,50))
		txt_buttonName:setColor(GlobalMethod:ccc3(255,255,255))
--        txt_buttonName:setLabelStyleKey(SMALL_GRAY_BTN)
	else 
		--btn_GetReward:setTouchEnable(true)
		btn_GetReward:setTouchEnable(true)
	end 
end

function CellCostActivityItem:setIdAndRewardId( ActivityId,RewardId )
	self.ActivityId = ActivityId
	self.RewardId = RewardId
end


function CellCostActivityItem:GetReward_Event( element )
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WZLog("CellCostActivityItem:GetReward_Event")
    --背包已满提示
    if CacheCenter:getRemainAmount() <= 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
        return
    end
	CellCostActivityItem.m_current_click = self
	self.m_nloadingId = MsgBoxManager:showLoadingBox()
	ProtocolProcessorWndActivityOnLine:send_ACTIVITY_ReceiveActivityReward(self.ActivityId ,self.RewardId)
end


function CellCostActivityItem:setItems( strItemsInfo )
	--WZLog("ITEMS:"..strItemsInfo)
	local Item_id_num_array_tab = SplitStringWithSeparator(strItemsInfo,",")
	for idx=1,#Item_id_num_array_tab do
        if Item_id_num_array_tab[idx] then
    		local Item_id_num_tab = SplitStringWithSeparator(Item_id_num_array_tab[idx],"|")
            if Item_id_num_tab and next(Item_id_num_tab) ~= nil then
        		local ConItem = GetElement(self.m_root,"ConItem_"..idx,WZUIContainer)
        		local celElement,tLuaObj = CellGoodItem:createElement()
                if celElement ~= nil then 
                    celElement = WZUIContainer:luaTo(celElement)
                    local key = "id_"..Item_id_num_tab[1]
                    --WZLog("key="..key)
                    local itemInfo = {id = tonumber(Item_id_num_tab[1]), name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=tonumber(Item_id_num_tab[2]),quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
                    tLuaObj:setCellGoodItem(itemInfo,4)
                    tLuaObj:clearItemQualityPic()
                    celElement:setScale(0.90)
                    celElement:setTag(idx-1)
                    tLuaObj:setItemClickFun(self,self.onOthersClick)
                end
                ConItem:addChild(celElement)
            end
        end
	end
end

--@brief    其它Item点击回调
function CellCostActivityItem:onOthersClick(luaTable,tag,tData)
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,CellCostActivityPanel.m_current.m_root,1,tData,false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    奖励获取成功回调  
function CellCostActivityItem:_GetRewardOk()
    WZLog("CellCostActivityItem:_GetRewardOk")
    self:setButtonState(1)
    if self.m_FuncCallback ~= nil then 
    	local tluaObj = self.m_tCallBackLuaObjMap[self.m_FuncCallback]
    	self.m_FuncCallback(tluaObj,self.RewardId)
    end
end

function CellCostActivityItem:createTTF(desc,pt,anchor,font,Align,color)
    desc = desc or ""
    font = font or 22
    color = color or GlobalMethod:ccc3(105,65,46)
    Align = Align or kCCTextAlignmentLeft
    anchor = anchor or GlobalMethod:ccp(0,0.5)
    pt = pt or GlobalMethod:ccp(0,0.5)
    local txt = WZUILabelTTF:create()
    txt:setFontSize(font)
    txt:setColor(color)
    txt:setText(desc)
    txt:setBoldFont(false)
    txt:setTouchEnable(false)
    txt:setAlignment(Align)
    txt:setAnchorPoint(anchor)
    txt:setRelativePosition(pt)
    if ProjConfig.LANGUAGE == "ug" then
        txt:setFontSize(18)
    end
    return txt
end

function CellCostActivityItem:_ShowGetRewarded(  )
    local img_GetReward = WZUIImage:create()
    img_GetReward = WZUIImage:luaTo(img_GetReward)
    img_GetReward:setFile("ui/common/commom_icon_ylq.png")
    img_GetReward:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    img_GetReward:setUseOriginSize(true)
    img_GetReward:setRotation(28)
    local conBtn_CellCostActivityItem = GetElement(self.m_root,"conBtn_CellCostActivityItem",WZUIContainer)
    conBtn_CellCostActivityItem:addChild(img_GetReward, 0, 888)
    -- local txt = WZUILabelTTF:create()
    -- txt:setFontSize(24)
    -- txt:setColor(GlobalMethod:ccc3(158,129,121))
    -- txt:setText(LocalStrings.ACTIVE_GET)
    -- txt:setBoldFont(false)
    -- txt:setEnableStroke(false)
    -- txt:setStrokeColor(GlobalMethod:ccc3(158,129,121))
    -- txt:setStrokeSize(4)
    -- txt:setTouchEnable(false)
    -- txt:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
    -- txt:setRelativePosition(GlobalMethod:ccp(0.55,0.5))
    -- local conBtn_CellCostActivityItem = GetElement(self.m_root,"conBtn_CellCostActivityItem",WZUIContainer)
    -- conBtn_CellCostActivityItem:addChild(txt, 0, 888)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellCostActivityItem:_adaptLanguage_pt(  )
end

function CellCostActivityItem:_adaptLanguage_th(  )
end

function CellCostActivityItem:_adaptLanguage_vn(  )
end
-------------------------------------语言适配End--------------------------------------------
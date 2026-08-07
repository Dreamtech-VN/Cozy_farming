--CellGameSingInItem.lua
--@brief	CellGameSingInItem的UI模块
--@date		2015/05/05
--@author	weidong_wu
--@note		签到列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellGameSingInItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellGameSingInItem:onExit(element)
	self:_unInit()
end

--@brief 
function CellGameSingInItem:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellGameSingInItem")
    self.m_root:addChild(cellElement)

    self:_InitTabMessage()  
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@breif 	设置奖励物品
function CellGameSingInItem:_InitTabMessage()  

    local nColumns = 4
	for i=1, nColumns do
        local conSingInItem = GetElement(self.m_root,"conSingInItem"..i,WZUIContainer) 
		local con_dayitem = GetElement(self.m_root,"con_dayitem_"..i,WZUIContainer)

        

		if i <= #self.m_tData then 
			local NowDay = i+(self.index-1)*nColumns
			local key = "id_"..self.m_tData[i].reward[1][1]
			local Num = self.m_tData[i].reward[1][2]
        	local celElement,tLuaObj = CellGoodItem:createElement()
       		if celElement ~= nil then 
            	celElement = WZUIContainer:luaTo(celElement)
            	local itemInfo = {id = self.m_tData[i].reward[1][1], name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=Num,quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
            	tLuaObj:setCellGoodItem(itemInfo,4)
            	celElement:setTag(i-1)
            	tLuaObj:setItemClickFun(self,self.onOthersClick)
        	end
            celElement:setScale(0.85)
            
            con_dayitem:addChild(celElement,0,i)

        	local vip_level = self.m_tData[i].vip_level 

            --签到的次数

			--NowDay = WndGameSingIn.todaySignNum
            if self.days==0 and NowDay==1 then 
                local AddConSingInItem = GetElement(self.m_root,string.format("conSignInBK%d_CellGameSingInItem", i),WZUIContainer) 
                local imgHight = WZUI9Image:create()
                imgHight = WZUI9Image:luaTo(imgHight)
                imgHight:setFile("ui/common/common_scale9_di62.png")
                imgHight:setCapInsets(CCRectMake(15,15,15,15))
                imgHight:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
                imgHight:setTouchSwallow(false)
                AddConSingInItem:addChild(imgHight,0,999)
            end 

			--WndGameSingIn.todaySignNum = 2
			--self.b_vipSign = false
        	if self.days >= NowDay or CacheCenter.m_bSignItemEnter then 
				WZLog("签到Cell", self.days, NowDay, WndGameSingIn.todaySignNum, vip_level, tonumber(NowDay) == tonumber(WndGameSingIn.todaySignNum))
                --if self.days == NowDay or CacheCenter.m_bSignItemEnter then 
                if (WndGameSingIn.todaySignNum > 0 and tonumber(NowDay) == tonumber(WndGameSingIn.todaySignNum)) 
					or (WndGameSingIn.todaySignNum == 0 and self.days == NowDay) or CacheCenter.m_bSignItemEnter then 
                   
                    local idx = i
                    local isShowHightImg = false 
                    if vip_level > -1 then 
						WZLog("路径1", self.b_sign, self.b_vipSign)
                        local vipLevel =  CacheCenter:getPlayerInfo().vipLevel
                        if self.b_vipSign == false and self.b_sign then 
							WZLog("领到一半", self.days, NowDay)
                            self:_AddMaskSingIn(conSingInItem,false,true)
                            isShowHightImg = true 
                        elseif self.b_vipSign and self.b_sign then 
							WZLog("领到", self.days, NowDay)
                            self:_AddMaskSingIn(conSingInItem,true,false)
                        elseif  self.b_vipSign==false and self.b_sign==false and CacheCenter.m_bSignItemEnter ==false then
                            self:_AddMaskSingIn(conSingInItem,true,false) 
                        elseif  self.b_vipSign==false and self.b_sign==false and CacheCenter.m_bSignItemEnter and self.days == NowDay  then
                            self:_AddMaskSingIn(conSingInItem,true,false)
                        end  
                    elseif CacheCenter.m_bSignItemEnter == false then  
                        self:_AddMaskSingIn(conSingInItem,true,false)
                    end 
                    if isShowHightImg == false and CacheCenter.m_bSignItemEnter==false then 
                        idx = idx + 1
                    end
                    if CacheCenter.m_bSignItemEnter then 
                        CacheCenter.m_bSignItemEnter = false 
                    end
                    if self.b_sign == false or (self.b_vipSign==false and self.b_sign and (vip_level > -1)) then
                        if idx < 5 then 
                            local AddConSingInItem = GetElement(self.m_root,string.format("conSignInBK%d_CellGameSingInItem", idx),WZUIContainer) 
                            local imgHight = WZUI9Image:create()
                            imgHight = WZUI9Image:luaTo(imgHight)
                            imgHight:setFile("ui/common/common_scale9_di62.png")
                            imgHight:setCapInsets(CCRectMake(15,15,15,15))
                            imgHight:setAnchorPoint(GlobalMethod:ccp(0.5,0.5))
                            imgHight:setTouchSwallow(false)
                            AddConSingInItem:addChild(imgHight,0,999)
                        else 
                            CacheCenter.m_bSignItemEnter = true 
                        end 
                    end 
                else 
                    self:_AddMaskSingIn(conSingInItem,true,false) 
                end 
        	end 

            if vip_level > -1 then 
                if vip_level < 10 then 
                    local CellVipIcon_WndGameSingIn = CreateElement("CellVipIcon_WndGameSingIn")
                    conSingInItem:addChild(CellVipIcon_WndGameSingIn,12)
                    local txtVipLevel_CellVipIcon = GetElement(CellVipIcon_WndGameSingIn,"txtVipLevel_CellVipIcon",WZUILabelAtlasFont)
                    txtVipLevel_CellVipIcon:setText(string.format("%d",vip_level))
                    if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "vn" or ProjConfig.LANGUAGE == "es" then
                        txtVipLevel_CellVipIcon:setScale(0.9)
                        GetElement(CellVipIcon_WndGameSingIn,"imgQD_CellGameSingInItem",WZUIImage):setScale(0.7)
                        GetElement(CellVipIcon_WndGameSingIn,"imgQDLv_CellGameSingInItem",WZUIImage):setScale(0.8)
                    end
                else 
                    local CellVipIcon_WndGameSingIn = CreateElement("CellVipIcon_WndGameSingIn")
                    conSingInItem:addChild(CellVipIcon_WndGameSingIn,12)
                    local conVipTip_CellGameSingInItem = GetElement(CellVipIcon_WndGameSingIn,"conVipTip_CellGameSingInItem",WZUIContainer)
                    conVipTip_CellGameSingInItem:setVisible(false)
                    local imgdoubleNum_CellGameSingInItem = GetElement(CellVipIcon_WndGameSingIn,"imgdoubleNum_CellGameSingInItem",WZUIImage)
                    imgdoubleNum_CellGameSingInItem:setVisible(true)
                    local vipIndex = string.format("ui/signInNum/commom_icon_qd%d.png",vip_level)
                    imgdoubleNum_CellGameSingInItem:setFile(vipIndex) 
                    if ProjConfig.LANGUAGE == "pt" then
                        imgdoubleNum_CellGameSingInItem:setScale(0.9)
                    end
                end 
            end 
		else 
			con_dayitem:setVisible(false)
            conSingInItem:setVisible(false)
		end 
	end
end

--@brief    其它Item点击回调
function CellGameSingInItem:onOthersClick(luaTable,tag,tData,conItem)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if tData == nil then
       return
    end
    
    CellGameSingInItem.m_current_click  = self 

    local tagindex = tag
    --self:_SingIned(tagindex)
    local isShowItemInfo =  self:_Operator(tagindex)
    if isShowItemInfo  then 
        WndItemInfo:onCloseClick()
        WndItemInfo:showInfo(luaTable.m_root,WndGameSingIn.m_root,1,tData,false,nil,true)
    end 
end



function CellGameSingInItem:_Operator( tagindex )
    local vip_level = self.m_tData[tagindex].vip_level 
    local nColumns = 4
    local idx = self.days %nColumns 
    
    local model = false 
    if idx==0 and self.days>0 then 
        model = true
    end 

    if self.b_sign == false then 
        idx = idx + 1 
    end 
     
    local CellItemIdx = math.ceil(self.days/nColumns) 
    WZLog("=============>"..CellItemIdx)
    if CellItemIdx == 0 then 
        CellItemIdx = 1 
    elseif model then 
        if vip_level > -1 and self.b_vipSign==false then 
            WZLog("VIP===="..tagindex)
            if self.b_sign == true and self.days == tagindex+(self.index-1)*nColumns then 
                idx = nColumns 
            elseif self.b_sign == false and self.days == tagindex+(self.index-1)*nColumns then 
                idx = idx + 1 
                CellItemIdx = CellItemIdx+1
            else 
                CellItemIdx = CellItemIdx+1
            end  
        end 
    end 
    WZLog("CellItemIdx="..CellItemIdx.."|"..self.days)

	WZLog("CellGameSingInItem:_Operator", tagindex, idx, self.index, CellItemIdx)
    --if tagindex == idx and self.index == CellItemIdx then
    if (WndGameSingIn.todaySignNum == 0 and tagindex == idx and self.index == CellItemIdx) or 
		(WndGameSingIn.todaySignNum > 0 and (tagindex+(self.index-1)*nColumns == WndGameSingIn.todaySignNum)) then
        WZLog("=========进入vip判断", tagindex, WndGameSingIn.todaySignNum)
        if self.b_sign then 
            --WZLog("今日已签到")
            --if vip_level > -1 and self.b_vipSign == false and tagindex <=self.days then 
            if vip_level > -1 and self.b_vipSign == false and tagindex <=WndGameSingIn.todaySignNum then 
                --WZLog("vip 条件!")
                local vipLevel =  CacheCenter:getPlayerInfo().vipLevel
                if vipLevel < vip_level then 
                    local tipString = LocalStrings.SingInVipTips
                    tipStirng = string.format(tipString,vip_level)
                    MsgBoxManager:showConfirmBox(tipStirng, self, self._EventToVIP, MSGBOXLEVEL_NORMAL, nil)
                    return false
                else 
                    --背包已满提示
                    if CacheCenter:getRemainAmount() <= 0 then
                        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
                        return false
                    end
                    --继续二次签到
                    self.b_vipTimes = true
                    self.m_clickItemIndex = tagindex
                    self:_startLoading()
                    ProtocolProcessorWndGameSingIn:send_TASK_Sign(1)
                    return false
                end 
            end
        else 
            --背包已满提示
            if CacheCenter:getRemainAmount() <= 0 then
                MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
                return false
            end
            --发送签到协议
            self.m_clickItemIndex = tagindex
            self:_startLoading()
            ProtocolProcessorWndGameSingIn:send_TASK_Sign(1)
            return false
        end 
    end 
    return true
end

function CellGameSingInItem:onItemClickEvent( element )
   WZLog("CellGameSingInItem:onItemClickEvent tag "..element:getTag())
   SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
   CellGameSingInItem.m_current_click  = self 
   self:_Operator(element:getTag())
end


--@brief 	前往vip充值
function CellGameSingInItem:_EventToVIP( nId, nResType )
	WZLog("CellGameSingInItem:_EventToVIP")
    if nResType == MSGBOXRESTYPE_CONFIRM then
	    CheckLuaLoad(LUAFILES_BLOCK_COMMON)
        CheckLuaLoad(Chat_Channel_vip)
        WndVip:showWndUI(0)
    end
end


--@brief    签到打勾
function CellGameSingInItem:_SingIned( index,beMask,b_needDraw)
    --WZLog("===index="..index)
    --local con_dayitem = GetElement(self.m_root,"con_dayitem_"..index,WZUIContainer)
    --local celElement = con_dayitem:getChildByTag(index) 
    local conSingInItem = GetElement(self.m_root,"conSingInItem"..index,WZUIContainer) 
    self:_AddMaskSingIn(conSingInItem,beMask,b_needDraw)
end


--@brief    添加遮罩和打过图片
function CellGameSingInItem:_AddMaskSingIn( celElement,beMask,b_needDraw)

    if beMask then 
        local img_mask_cellGameSingInItem = WZUI9Image:create()
        img_mask_cellGameSingInItem = WZUI9Image:luaTo(img_mask_cellGameSingInItem)
        img_mask_cellGameSingInItem:setFile("ui/common/common_scale9_di65.png")
        img_mask_cellGameSingInItem:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        img_mask_cellGameSingInItem:setTouchEnable(false)
        img_mask_cellGameSingInItem:setCapInsets(CCRectMake(1,1,1,1))
        img_mask_cellGameSingInItem:setOpacity(200)
        celElement:addChild(img_mask_cellGameSingInItem,20)

        local img_RewardGeted = WZUIImage:create()
        img_RewardGeted = WZUIImage:luaTo(img_RewardGeted)
        img_RewardGeted:setFile("ui/common/commom_icon_ylq.png")
        img_RewardGeted:setUseOriginSize(true)
        img_RewardGeted:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
        img_RewardGeted:setTouchEnable(false)
        celElement:addChild(img_RewardGeted,21)
        local tag = celElement:getTag()
        local AddConSingInItem = GetElement(self.m_root,string.format("conSignInBK%d_CellGameSingInItem", tag),WZUIContainer) 
        
        if AddConSingInItem:getChildByTag(999) then 
            AddConSingInItem:removeChildByTag(999, true)
        end 
    end 
     
    if  b_needDraw then 
        --[[local img_SingIn_cellGameSingInItem = WZUIImage:create()
        img_SingIn_cellGameSingInItem = WZUIImage:luaTo(img_SingIn_cellGameSingInItem)
        img_SingIn_cellGameSingInItem:setFile("ui/bag/gou.png")
        img_SingIn_cellGameSingInItem:setRelativePosition(GlobalMethod:ccp(0.5,0.29))
        img_SingIn_cellGameSingInItem:setUseOriginSize(true)
        img_SingIn_cellGameSingInItem:setTouchEnable(false)
        celElement:addChild(img_SingIn_cellGameSingInItem,10)]]
        --local tag = celElement:getTag()
        --local imgItemBg_CellSingInItem_WndGameSingIn = GetElement(self.m_root,"imgItemBg_"..tag.."_CellSingInItem_WndGameSingIn",WZUI9Image)
        --imgItemBg_CellSingInItem_WndGameSingIn:setFile("ui/common/common_icon_zisedi.png")
    else
        -- local tag = celElement:getTag()
        -- local imgItemBg_CellSingInItem_WndGameSingIn = GetElement(self.m_root,"imgItemBg_"..tag.."_CellSingIntem_WndGameSingIn",WZUI9Image)
        -- imgItemBg_CellSingInItem_WndGameSingIn:setFile("ui/common/common_scale9_di7.png")
    end 
end

--@brief    开始加载
--@note     开始（协议）信息的加载，显示加载框
function CellGameSingInItem:_startLoading()
    --弹出加载框
    self.m_nLoadingID = MsgBoxManager:showLoadingBox(nil, nil, nil, nil)
end

--@brief    完成加载
--@note     完成（协议）信息的加载，关闭加载框
function CellGameSingInItem:_finishedLoading()
    --关闭加载框
    MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingID)
end
-------------------------------------私有方法模块End----------------------------------------

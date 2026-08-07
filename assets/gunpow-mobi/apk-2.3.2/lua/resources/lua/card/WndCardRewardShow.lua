--WndCardRewardShow.lua
--@brief	WndCardRewardShow的UI模块
--@date		2016/08/01
--@author	Tianxiang_Xu
--@note		卡牌奖励界面


-------------------------------------公有方法模块Begin--------------------------------------
--@brief    进入场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景进入前的准备工作
function WndCardRewardShow:onEnter(element)
    GlobalGame.g_bIsRewardShow = true
    self.m_root = element
    self:_setInfo()
    
    --多语言版本界面适配
    AdaptLanguage(self)
end

--@brief onEnter函数执行完成回调
function WndCardRewardShow:onEnterTransitionDidFinish(element)
    --播放效果音效
    SoundManager:playEffectSound(SoundDefine.E_S_GET_DESIGNATION)

    GetElement(self.m_root,"ttf2_WndCardRewardShow",WZUILabelTTF):setText(LocalStrings.CLICKCONTINUE)
    
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief    弹窗动画完成后的回调
function WndCardRewardShow:actionCallback(element, data)

end

--@brief    退出场景时被调用的函数
--@param    element:表绑定的UI节点引用
--@note     在这里做场景退出前的清理工作
function WndCardRewardShow:onExit(element)
    self:_unInit()
end

--@brief    单击关闭按钮时被调用的函数
--@param   element:关闭按钮的节点
--@note     关闭后返回主界面
function WndCardRewardShow:onClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_root == nil then
        return
    end

    --调用设置的回调函数
    if self.backFunc then
        self.backFunc[2](self.backFunc[1],self)
        if self.backFunc[3] and self.backFunc[4] then
            self.backFunc[4](self.backFunc[3])
        end
    end

    self:onCloseCallback()
end

--@brief    关闭的回调函数
function WndCardRewardShow:onCloseCallback()
    WZLog("WndCardRewardShow:onCloseCallback")
    --关闭称号窗口
    WindowManagerAni:createDisappearAction(self.m_root,nil,self,true)
end

--@brief    窗口显示奖励内容
--@param    vnId:物品id数组
--@param    vnNum:物品数量数组  传入数量为0或者nil则不显示
--@param    nDisplayType:物品显示类型，不赋值时默认为16
function WndCardRewardShow:showById(vnId,vnNum,nDisplayType)
    --Add By Tianxiang_Xu
    --主要是当连续获取两个及以上的礼包时，打开，除了第一个，后面的礼包物品不能展示的问题
    if self.m_root ~= nil then 
        WZLog("WndCardRewardShow:showById")
        --调用设置的回调函数
        if self.backFunc then
            self.backFunc[2](self.backFunc[1],self)
        end

        self:onCloseCallback()
    end
    --End Add

    if self.m_root == nil then
        local Wnd = WndCardRewardShow:createElement()
        for i=1,#vnId do
            local key = "id_"..vnId[i]
            if GDatatab_item[key] ~= nil and vnId[i] ~= 26 then
                local name = GDatatab_item[key].name
                local path = GDatatab_item[key].icon
                local num --=  vnNum[i]
                local addNum = vnNum[i]
                local level = 1
                if WndCard.m_tActiveCardList then
                    for k = 1, #WndCard.m_tActiveCardList do
                        if vnId[i] == WndCard.m_tActiveCardList[k].item_id then
                            num = WndCard.m_tActiveCardList[k].curNum
                            level = WndCard.m_tActiveCardList[k].level
                            break
                        end
                    end
                end
                local quality = GDatatab_item[key].quality
                local itemInfo = {id=vnId[i],name=name,icon=path,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(GDatatab_item[key]),level=level,addNum =addNum}
                table.insert(self.info,itemInfo)
            else
                WZLog(key.."不在GDatatab_item")
            end
        end
        table.sort(self.info, sortRewardCard)
        self.m_nDisplayType = nDisplayType or 16
        WindowManager:addWindow(Wnd , WndCardRewardShow ,nil ,nil ,nil, false)
    end
end

--@brief    奖励卡牌的排序函数
function sortRewardCard(a, b)
    -- body
    if a.quality ~= b.quality then
        return a.quality > b.quality
    else
        return a.id > b.id
    end
end

--@brief    设置窗口标题图片
--@param    sImage:图片路径
function WndCardRewardShow:setTitleImage(sImage)
    if self.m_root == nil then
        WZLog(debug.traceback())
        return
    end
    local imgTitle = GetElement(self.m_root, "imgTitle_WndCardRewardShow", WZUIImage)
    imgTitle:setScale(1)
    imgTitle:setFile(sImage)
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------回调方法模块Begin----------------------------------------
--@brief    点击物品后的回调
--@param    tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function WndCardRewardShow:onClickItem(tItem, nTag, tData)
    WZLog("WndCardRewardShow:onClickItem ")
    local itemInfo = tData.basicInfo
    local itemId = itemInfo.id
    self.m_nSelectItemId = itemId
    if self.m_bIsShowBySendGift then
       tItem:setHightLightVisible(true)
       self.m_tSelectCell:setHightLightVisible(false)
    end
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
    self.m_tSelectCell = tItem
end

--@brief    开始点击窗口后的回调
--@param    element:窗口绑定的lua表
--@param    pt:坐标点
function WndCardRewardShow:onTouchBegan(element, pt)
    WndItemInfo:onCloseClick()
end
-------------------------------------回调方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief设置列表内容的函数
function WndCardRewardShow:_setInfo()
    WZLog(" WndCardRewardShow:_setInfo()")
    if self.m_root == nil then 
        WZLog(" WndCardRewardShow:setInfo() self.m_root is nil ")
    end 
        
    local tabCon = GetElement(self.m_root, "flconRewardList_WndCardRewardShow", WZUIFreeListContainer)
    if tabCon ~= nil then 
        for i = 1,#self.info do
           local celElement,tLuaObj = CellCardItem:createElementOther()
           if celElement ~= nil then 
                celElement = WZUIContainer:luaTo(celElement)
                local id = WndCard:_getCardId(self.info[i].id, self.info[i].level)
                local tItem = CopyTable(GDatatab_card_property["id_" .. id])
                tItem.item_id = self.info[i].id
                tItem.curNum = self.info[i].lastNum
                tItem.state = 1
                tItem.useType = 1 
                tItem.bIsNew = false
                tItem.basicInfo = CopyTable(GDatatab_item["id_" .. tItem.item_id])
                tItem.upgradeNum = tItem.cost[2][2]

                --增加的数量
                local txtAddNum = WZUILabelTTF:create()
                txtAddNum:setFontSize(20)
                txtAddNum:setAnchorPoint(GlobalMethod:ccp(0.5,1))
                txtAddNum:setRelativePosition(GlobalMethod:ccp(0.5,0.05))
                txtAddNum:setEnableStroke(true)
                txtAddNum:setStrokeSize(4)
                txtAddNum:setStrokeColor(GlobalMethod:ccc3(105,65,46))
                txtAddNum:setColor(GlobalMethod:ccc3(255,236,193))
                txtAddNum:setText("+"..self.info[i].addNum)
                celElement:addChild(txtAddNum)

                tLuaObj:setDataOther(tItem, GlobalMethod:ccp(0.5,0.46))
                celElement:setTag(i - 1)
                celElement:setUseAbsSize(true)
                celElement:setAbsContentSize(GlobalMethod:CCSize(114,170))
                celElement:setRelativeSize(GlobalMethod:CCSize(114/520, 0.74))
                
                tabCon:pushBack(celElement)
           end
        end 

        if #self.info <= 4 then
            tabCon:setTouchContainerEnable(false)
            tabCon:setTouchEnable(false)
        else
            tabCon:getMoveElement():setPositionX(tabCon:getMaxPosition().x)
        end
    end 
end

-------------------------------------私有方法模块End----------------------------------------

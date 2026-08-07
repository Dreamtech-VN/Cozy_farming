--WndShopGiven.lua
--@brief	WndShopGiven的UI模块
--@date		2016-4-21
--@author	binshao
--@note		物品赠送或索要模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndShopGiven:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief    弹窗动画完成后的回调
function WndShopGiven:actionCallback(element, data)
    self:update()
    self:createLoading()

    -- 获取好友列表（赠送或者索要类型+性别）
    WZLog("------------get friend list-----------",self.types,self.selSex)
    ProtocolProcessorWndShop:send_MALL_GetOperateFriend(self.types,self.selSex)
end

--@brief onEnter函数执行完成回调
function WndShopGiven:onEnterTransitionDidFinish(element)
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndShopGiven:onExit(element)
	self:_unInit()
end

-- 赠送或者索要
function WndShopGiven:onGive()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    -- editbox说明
    local edit =  GetElement(self.m_root,"editAsk_WndShopGiven", WZUIEditBox)
    local str = edit:getText()
    if str == LocalStrings.SHOP_DESC3 then str = "" end

    -- 选择对象
    if not self.selFriend then
        MsgBoxManager:showTipBox(LocalStrings.SHOP_DESC5)
        return
    end

    
    -- 赠送要走钻石流程
    local moneyType = self.data[1]["initData"]["moneyId"]
    if self.types == 1 then
        if moneyType == 1 then
            if JudgeMoneyIsEnough(1,self.price) == false then
                return
            end
        elseif moneyType == 2 then
            if JudgeMoneyIsEnough(2,self.price) == false then
                return
            end
        end
    end

    self:createLoading()

    -- 获取商品ID和商品数量
    local mallId,count
    if WndBuy.m_root then
        mallId,count = WndBuy:getPropIdAndIndex()
    elseif WndPurchase.m_root then
        mallId,count = WndPurchase:getPropIdAndIndex()
    end

    WZLog("--------OnGive--------------",self.types, mallId, count, self.selFriend.playerId, str)
    ProtocolProcessorWndShop:send_MALL_MallOperate(self.types, mallId, count, self.selFriend.playerId, str)
end

-- 创建加载框
function WndShopGiven:createLoading()
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(15,self,self.closeLoading)
    end
end

-- 关闭加载框
function WndShopGiven:closeLoading()
    if self.loadingId then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
        self.loadingId = nil
    end
end

-- 错误协议处理
function WndShopGiven:errorProHandle()
    if self.m_root then
        self:closeLoading()
    end
end

-- 显示当前窗口(赠送或者索要， 当前物品数据， 价格总数， 性别)
function WndShopGiven:showWnd(types,data,price,sex)
    local wndGiven = WndShopGiven:createElement()
    WindowManager:addWindow(wndGiven,WndShopGiven,true,nil,nil)
    self.types = types
    self.data = data
    self.price = price
    self.selSex = types == 1 and sex or 2       -- 只有赠送才有性别限制
end

-- 关闭界面
function WndShopGiven:onClose()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WindowManager:removeWindow(self.m_root, self, true)
end

-- 更新界面
function WndShopGiven:update()
    -- 更新标题
    self:_updateGivenText()

    -- 物品展示
    self:_updateGoodItems()
end


function WndShopGiven:onTouchBegin(element,pt)
    local point = self.m_root:getParentElement():convertToNodeSpace(pt)
    local bPoint = WndItemInfo:checkPoint(pt)
    if not bPoint then  WndItemInfo:onCloseClick() end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-- 更新界面的Text
function WndShopGiven:_updateGivenText()
    -- 标题
    local title =  GetElement(self.m_root, "txtGivenTitle_WndShopGiven", WZUILabelTTF)
    local str = {LocalStrings.GIVE ,LocalStrings.SHOP_BUY_DESC1}
    title:setText(str[self.types])

    
    local shopDesc = string.format(LocalStrings.SHOP_DESC2,self.price)
    local moneyType = self.data[1]["initData"]["moneyId"]
    if moneyType == 2 then
        shopDesc = string.gsub(shopDesc,"ui/common/common_icon_zuanshi.png","ui/common/common_icon_jinbi.png")
    end
    -- 购买信息
    local ftbBuy =  GetElement(self.m_root, "ftbBuyDesc_WndShopGiven", WZUIFreeTextBox)
    ftbBuy:setShowText(shopDesc)

    -- 按键说明
    local txtBtn =  GetElement(self.m_root, "txtBtn_WndShopGiven", WZUILabelTTF)
    txtBtn:setText(str[self.types])

    -- editbox说明
    local edit =  GetElement(self.m_root,"editAsk_WndShopGiven", WZUIEditBox)
    edit:setPlaceHolder(LocalStrings.SHOP_DESC3)

    -- 好友说明
    local txtDesc =  GetElement(self.m_root, "txtGivenDesc_WndShopGiven", WZUILabelTTF)
    local needVip = tonumber(CacheCenter:getGameParam().mallOperateVip)
    local needPoint = tonumber(CacheCenter:getGameParam().mallOperateFriend)
    if self.types == 1 then
        txtDesc:setText(string.format(LocalStrings.SHOP_DESC13,needPoint))
    else
        local needLv = tonumber(CacheCenter:getGameParam().mallOperatePlayerLevel)
        txtDesc:setText(string.format(LocalStrings.SHOP_DESC12,needLv,needVip,needPoint))
    end
end


--@brief    其它Item点击回调
function WndShopGiven:onItemClick(luaObject,tag)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndItemInfo:showInfo(luaObject.m_root,self.m_root,1,self.data[tag].initData,false)
end

-- 设置商品的图标
function WndShopGiven:_setPropIcon(con,data,tag)
    local celElement,tLuaObj = CellGoodItem:createElement()
    if celElement ~= nil then
        celElement = WZUIContainer:luaTo(celElement)
        tLuaObj:setSZBg()
        tLuaObj:setCellGoodItem(data,2)
        con:addChild(celElement)
        tLuaObj:setItemClickFun(self,self.onItemClick)
        celElement:setTag(tag)
    end
end

-- 显示物品
function WndShopGiven:_updateGoodItems()
    for i = 1, #self.data do
        local con = GetElement(self.m_root, "conItem"..i.."_WndShopGiven", WZUIContainer)
        self:_setPropIcon(con,self.data[i].initData,i)
    end
end

-- 显示好友列表
-- 判断列表是否为空，空列表显示空的提示语
function WndShopGiven:_judgeTabEmpty(dataTab,descTxt)
    local state = true
    if dataTab and #dataTab > 0 then
        state = false
    end
    if descTxt then
        descTxt:setVisible(state)
    end

    return state
end

---- 创建分页滑动提示
--function WndShopGiven:_createTTF(txt)
--    local ttf = WZUILabelTTF:create()
--    ttf:setText(txt)
--    ttf:setFontSize(22)
--    ttf:setUseOriginSize(true)
--    ttf:setColor(GlobalMethod:ccc3(255,236,193))
--
--    return ttf
--end

---- 更新表的设置信息
---- tab 当前的UITableContainer
---- needCnt 当前需要加载的cell个数
---- dataTab tab的数据表
---- bottomFunc 滑动到低端调用函数
---- scheduleFunc 每帧执行的创建cell的函数
--function WndShopGiven:_updateTabSetting(tab,needCnt,dataTab,bottomFunc,scheduleFunc)
--    if needCnt < #dataTab and needCnt < self.maxCnt then
--        tab:setEnableDagLoading(false)
--        local ttf = self:_createTTF(LocalStrings.NEXT_PAGE)
--        tab:setBottomNotice(LocalStrings.NEXT_PAGE, LocalStrings.NEXT_PAGE_TIP)
--        tab:setEnableBottomElement(true)
--        tab:setHideBottomElement(false)
--        tab:setBottomElement(ttf)
--        tab:setBottomElementFunction(bottomFunc)--设置BottomElement的Lua回调函数
--    else
--        tab:setEnableDagLoading(false)
--        tab:setEnableBottomElement(false)
--        tab:setHideBottomElement(true)
--    end
--
--    -- 设置每帧加载函数
--    tab:enableSchedule(scheduleFunc, 0.05)
--end


-- 初始化tab
function WndShopGiven:initFriendTab()
    if self.friendFlag then
        local txt = GetElement(self.m_root,"txtEmpty1_WndShopGiven",WZUILabelTTF)
        local empty = self:_judgeTabEmpty(self.friendInfo,txt)
        if empty then return end

--        -- 清空tab,初始化基本数据
--        local tab = GetElement(self.m_root,"tabFriend_WndShopGiven",WZUITableContainer)
--        tab:cleanTable()
--        self.friendIndex = 1
--        self.friendFlag = false
--        self.NeedCnt1 = self.initCnt
--        self:_updateTabSetting(tab,self.NeedCnt1,self.friendInfo,"onPageBottom","scheduleCreateCell1")

        self:createCellOnce()
    end
end

-- 动态创建好友列表
function WndShopGiven:createCellOnce()
    local tabR = GetElement(self.m_root,"tabFriend_WndShopGiven",WZUITableContainer)
    tabR:cleanTable()
    for i = 1, #self.friendInfo do
        local info = self.friendInfo[i]
        if info  then
            local cell,tcell = CellShopFriend:createElement()
            cell:setTag(i-1)
            tabR:setCellElement(cell)
            tcell:setData(info)
            self:setCellData(i-1, cell, tcell)
        end
    end
end

---- 动态创建好友列表
--function WndShopGiven:scheduleCreateCell1(element,time)
--    local tabR = GetElement(self.m_root,"tabFriend_WndShopGiven",WZUITableContainer)
--    local info = self.friendInfo[self.friendIndex]
--    if info and self.friendIndex <= self.NeedCnt1 then
--        local cell,tcell = CellShopFriend:createElement()
--        cell:setTag(self.friendIndex-1)
--        tabR:setCellElement(cell)
--        tcell:setData(info)
--        self:setCellData(self.friendIndex-1, cell, tcell)
--        --if self.friendIndex == 1 then tcell:setCellSel(true) end
--        self.friendIndex = self.friendIndex + 1
--    else
--        tabR:disableSchedule()
--    end
--end
--
---- 向下拉触发函数
--function WndShopGiven:onPageBottom()
--    local tab = GetElement(self.m_root,"tabFriend_WndShopGiven",WZUITableContainer)
--    tab:getMoveElement():setPositionY(tab:getMaxPosition().y)
--    self.NeedCnt1 = self.NeedCnt1 + self.eachCnt
--    self:_updateTabSetting(tab,self.NeedCnt1,self.friendInfo,"onPageBottom","scheduleCreateCell1")
--end

-- 更新好友列表cell的选中状态
function WndShopGiven:updateSelState(index,state)
    WZLog("------------updateSelState-------------",state)
    if not self.cellData then return end
    for k,v in pairs(self.cellData) do
        if v.index == index + 1 then
            v.tcell:setCellSel(state)
            -- 如果当前是选中，那么记录当前的好友index
            if state then
                self.selFriend = self.friendInfo[v.index]
            else
                self.selFriend = nil
            end
        else
            v.tcell:setCellSel(false)
        end
    end
end

-- 操作成功
function WndShopGiven:handleSuccess()
    self:closeLoading()
    if self.types == 1 then
        MsgBoxManager:showTipBox(LocalStrings.SHOP_DESC7)
    else
        MsgBoxManager:showTipBox(LocalStrings.SHOP_DESC6)
    end

    -- 关闭当前已打开的窗口
    if WndBuy.m_root then WndBuy:closeWndBuy() end
    if WndPurchase.m_root then WndPurchase:closeWndBuy() end
    WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------私有方法模块End----------------------------------------

---------------------------------------语言适配Begin---------------------------------------
function WndShopGiven:_adaptLanguage_en()
    WZLog("WndShopGiven:_adaptLanguage_en")
    local txt = GetElement(self.m_root,"txtGivenDesc_WndShopGiven",WZUILabelTTF)
    txt:setDimensions(GlobalMethod:CCSize(360,100))
    txt:setRelativePosition(GlobalMethod:ccp(0.5,0.825))
end

function WndShopGiven:_adaptLanguage_pt(  )
    local txt = GetElement(self.m_root,"txtGivenDesc_WndShopGiven",WZUILabelTTF)
    txt:setDimensions(GlobalMethod:CCSize(360,100))
    txt:setRelativePosition(GlobalMethod:ccp(0.5,0.825))
end

function WndShopGiven:_adaptLanguage_vn(  )
    local txt = GetElement(self.m_root,"txtGivenDesc_WndShopGiven",WZUILabelTTF)
    txt:setDimensions(GlobalMethod:CCSize(360,100))
end

function WndShopGiven:_adaptLanguage_tr(  )
    local txtGivenDesc = GetElement(self.m_root,"txtGivenDesc_WndShopGiven",WZUILabelTTF)
    txtGivenDesc:setDimensions(GlobalMethod:CCSize(360,100))
    txtGivenDesc:setFontSize(18)
end

function WndShopGiven:_adaptLanguage_es(  )
    local txtGivenDesc = GetElement(self.m_root,"txtGivenDesc_WndShopGiven",WZUILabelTTF)
    txtGivenDesc:setDimensions(GlobalMethod:CCSize(360,100))
    txtGivenDesc:setFontSize(18)
    txtGivenDesc:setRelativePosition(GlobalMethod:ccp(0.5,0.825))

    GetElement(self.m_root,"ftbBuyDesc_WndShopGiven",WZUIFreeTextBox):setScale(0.7)
end
------------------------------------语言适配End--------------------------------------------
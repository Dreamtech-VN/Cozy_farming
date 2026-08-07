--CellTopHandle.lua
--@brief	CellTopHandle的UI模块
--@date		2015-12-15
--@author	binshao
--@note		顶部菜单栏


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTopHandle:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTopHandle:onExit(element)
	self:_unInit()
end

--@brief    获取金币图标节点
function CellTopHandle:getGoldNode()
    -- body
    local goldNode = self.goldCellInfo.tcell:getGoldNode()

    return goldNode
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellTopHandle:onReturn()
    if self.m_bIsMatching then
        MsgBoxManager:showTipBox(LocalStrings.MATCHING_TEXT1)
        return 
    end
    if self.shieldClick then
        MsgBoxManager:showTipBox(LocalStrings.CANCEL_READY)
        return
    end
    local data = self.data
    if data.luaObj and data.cbFunc then
        data.cbFunc(data.luaObj)
    elseif data.cbFunc then
        data.cbFunc()
    else
        WZLog("------------------parament error-------------")
    end
end

function CellTopHandle:_update()
    self:_initUI()
    self:_addGold()
    self:addBottomBar()
    self:_setNetSignal()
end

-- 初始化UI
function CellTopHandle:_initUI()
    local img = GetElement(self.m_root,"imgTitle_CellTopHandle", WZUIImage)
    if self.data.imgPath then img:setFile(self.data.imgPath) end
end

-- 添加货币快捷键
function CellTopHandle:_addGold()
	local celElement,tCell
    if self.data.coinFlag then
        local conGold = GetElement(self.m_root,"conGold_CellTopHandle", WZUIContainer)
        if conGold then
            celElement,tCell = CellGold:createElement()
            tCell:setCellType(0)
            if celElement and tCell then
                conGold:addChild(celElement)
                self.goldCellInfo = {cell = celElement, tcell = tCell }
            end
        end
    end
	if self.data.tOther == nil then 
        if tCell then 
            tCell:showCoin({1,70,2,6},{1,1,1,1})
        end
        return 
    end
	--设置货币栏类型
	if self.data.tOther.goldType == 1 then
		tCell:showCoin({1,70,2},{1,1,1})
	elseif self.data.tOther.goldType == 2 then --宠物
        tCell:showCoin({1,70,107,163},{1,1,1,1})
    elseif self.data.tOther.goldType == 3 then --祈福
        tCell:showCoin({1,70,23,22},{1,1,1,1})
    elseif self.data.tOther.goldType == 4 then --召唤
        local equipLotteryPrice =  CacheCenter:getGameParam().equipLotteryPrice
        local m_tIds,m_tNums = SplitItemString(equipLotteryPrice)
        local keyId =  tonumber(m_tIds[4])
        local keyId2 =  tonumber(m_tIds[1])
        local tItemId = {}
        tItemId[1] = 1
        tItemId[2] = 70
        tItemId[3] = keyId
        tItemId[4] = keyId2
		tCell:showCoin(tItemId,{1,1,1,1})
    elseif self.data.tOther.goldType == 5 then --卡牌
        tCell:showCoin({1,70,26,79},{1,1,1,1})
    elseif self.data.tOther.goldType == 6 then --商城
        tCell:showCoin({1,70,2,57},{1,1,1,0})
    elseif self.data.tOther.goldType == 7 then--矿晶
        tCell:showCoin({1,70,2,58},{1,1,1,1})
    elseif self.data.tOther.goldType == 8 then --符文购买币
        tCell:showCoin({1,70,2,59},{1,1,1,1})
    elseif self.data.tOther.goldType == 9 then --幻化购买币
        tCell:showCoin({1,70,2,61},{1,1,1,1})
    elseif self.data.tOther.goldType == 10 then --骰子
        tCell:showCoin({1,70,2,60},{1,1,1,1})
    elseif self.data.tOther.goldType == 11 then --家园系统
        tCell:showCoin({1,70,66,67},{1,1,1,1})
    elseif self.data.tOther.goldType == 12 then --觉醒系统
        tCell:showCoin({1,70,2,62},{1,1,1,0})
        GetElement(self.m_root, "conNetSignal_CellTopHandle", WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.75, 0.5))
    elseif self.data.tOther.goldType == 13 then --小家（小孩）系统
        tCell:showCoin({1,70,2},{1,1,1})
	end
end

-- 添加下拉菜单
function CellTopHandle:addBottomBar()
    if self.data.bottomBarFlag == 1 then
        local con = GetElement(self.m_root,"conBottomBar_CellTopHandle", WZUIContainer)
        local wndBottomBar,wndBottomBarObj = WndBottomBar:createElement()
        con:addChild(wndBottomBar)
        self.bottomCell = wndBottomBar
        self.bottomTcell = wndBottomBarObj
        wndBottomBarObj:setNeedMoveVerticalBar(true)
        CacheCenter:updateRedPoint("right",wndBottomBar,nil,7)

        if self.data.bottomBarFlag == 1 then
            self.bottomTcell:setNeedMoveVerticalBar(false)
        end

        -- 处理红点
        if self.data.redPointObj and self.data.chatFlag then
            GlobalGame:getBtnRedPointEvent():regListenerBottomBar(self.data.redPointObj,wndBottomBarObj,"right")
        end

        -- 屏蔽聊天
        if not self.data.chatFlag then
            self.bottomTcell:setNeedChat(false)
            WndCurrentChat:hideButtomChat()
        end

        local conNetSignal = GetElement(self.m_root, "conNetSignal_CellTopHandle", WZUIContainer)
        CellNetSignal:showInterface(conNetSignal)
        return 
    end

    if self.data.bottomBarFlag then
        local con = GetElement(self.m_root,"conBottomBar_CellTopHandle", WZUIContainer)
        local wndBottomBar,wndBottomBarObj = WndBottomBar:createElement()
        con:addChild(wndBottomBar)
        self.bottomCell = wndBottomBar
        self.bottomTcell = wndBottomBarObj
        wndBottomBarObj:setNeedMoveVerticalBar(true)
        CacheCenter:updateRedPoint("right",wndBottomBar,nil,7)

        -- 处理红点
        if self.data.redPointObj then
            GlobalGame:getBtnRedPointEvent():regListenerBottomBar(self.data.redPointObj,wndBottomBarObj,"right")
        end

        -- 屏蔽聊天
        if not self.data.chatFlag then
            self.bottomTcell:setNeedChat(false)
            WndCurrentChat:hideButtomChat()
        end
    end
end

--@brief	设置聊天
function CellTopHandle:setChatShow(stat)
	if stat then
		WZLog("显示聊天")
        self.bottomTcell:setNeedChat(true)
        WndCurrentChat:showButtomChat()
	else
		WZLog("隐藏聊天")
        self.bottomTcell:setNeedChat(false)
        WndCurrentChat:hideButtomChat()
	end
end

--@brief  设置标题
function CellTopHandle:setTitleFile(titlePath)
    GetElement(self.m_root,"imgTitle_CellTopHandle",WZUIImage):setFile(titlePath)
end

--@brief  设置返回按钮是否可点
function CellTopHandle:setBackStats(stats)
    WZLog("CellTopHandle:setBackStats")
    GetElement(self.m_root,"btnBack_CellTopHandle",WZUIButton):setTouchEnable(stats)
end

--@brief 设置顶部导航栏是否可点
function CellTopHandle:setTopTouchEnable(status)
    WZLog("CellTopHandle:setTopTouchEnable")
    GetElement(self.m_root,"conTop_CellTopHandle",WZUIContainer):setTouchEnable(status)
end

--@brief    设置显示网络延迟信号
function CellTopHandle:_setNetSignal()
    -- body
    if not self.data.bottomBarFlag then
        local conNetSignal = GetElement(self.m_root, "conNetSignal_CellTopHandle", WZUIContainer)
        CellNetSignal:showInterface(conNetSignal)
    end
end

--@brief    设置聊天按钮大小
--@param    nScale: 缩放倍数
--@param    rPt: 相对位置
function CellTopHandle:setChatBtnSize(nScale, rPt)
    -- body
    if self.bottomTcell then 
        self.bottomTcell:setChatBtnScale(nScale, rPt)
    end
end
-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin-------------------------------------------
function CellTopHandle:_adaptLanguage_pt(  )
    GetElement(self.m_root,"conGold_CellTopHandle",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.6,0.6125))
end

function CellTopHandle:_adaptLanguage_es(  )
    GetElement(self.m_root,"conGold_CellTopHandle",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.6,0.6125))
end

function CellTopHandle:_adaptLanguage_en(  )
    GetElement(self.m_root,"conGold_CellTopHandle",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.6,0.6125))
end
--------------------------------------语言适配End----------------------------------------------
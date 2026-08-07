--CellTowerRewardTip.lua
--@brief	CellTowerRewardTip的UI模块
--@date		2015-7-4
--@author	binshao
--@note		爬塔副本宝箱弹框


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTowerRewardTip:onEnter(element)
	self.m_root = element
    --语言适配
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTowerRewardTip:onExit(element)
	self:_unInit()
end

--弹窗动画
function CellTowerRewardTip:onEnterTransitionDidFinish(element)
    WZLog("CellTowerRewardTip:onEnterTransitionDidFinish")
    self:_update2()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新界面
function CellTowerRewardTip:_update2()
    if self.m_root == nil then return end
    local data = self.m_tData
    local tabPrizeItemList = GetElement(self.m_root, "tabPrizeItemList_CellTowerRewardTip", WZUITableContainer)
    tabPrizeItemList:cleanTable()

    if self.m_bShowByTower then
        local tempReward = data.floor_reward
        if self.m_bFirstPass then
            tempReward = data.one_reward
        end
        if tempReward == -1 then return end

        local reward = {}
        for i = 1, #tempReward do
            local temp = {}
            temp.basicInfo = GDatatab_item["id_"..tempReward[i][1]]
            temp.lastNum = tempReward[i][2]
            table.insert(reward,temp)
        end

        for i = 1, #tempReward do
            local cell,tcell = CellGoodItem:createElement()
            cell:setTag(i-1)
            tcell:setFromTag(i-1)
            cell:setScale(0.78)
            tcell:setCellGoodItem(reward[i],2)
            tabPrizeItemList:setCellElement(cell)
        end
    else
        local conTab = GetElement(self.m_root,"conTab_CellTowerRewardTip",WZUIContainer)
        local count = #data
        if count > 5 then
            local lineCount = math.ceil(count / 5)
            local heightt = 118+((lineCount-1)*70)
            local root = WZUIContainer:luaTo(self.m_root)
            root:setAbsContentSize(GlobalMethod:CCSize(355,heightt))
            conTab:setAbsContentSize(GlobalMethod:CCSize(345,70*lineCount+5))
            tabPrizeItemList:setCellElementHeight(1/lineCount)

            self.m_root:updateRelativeSize()
        end
        
        for i,v in ipairs(data) do
            local temp = {}
            temp.basicInfo = GDatatab_item["id_"..v]
            temp.lastNum = 0

            local cell,tcell = CellGoodItem:createElement()
            cell:setTag(i-1)
            tcell:setFromTag(i-1)
            cell:setScale(0.75)
            tcell:setCellGoodItem(temp,2)
            tabPrizeItemList:setCellElement(cell)
            tcell:setItemClickFun(self, self.onClickListItem)
        end
    end

    if self.m_txtTip  then
        local txtGet = GetElement(self.m_root,"txtGet_CellTowerRewardTip",WZUILabelTTF)
        txtGet:setText(self.m_txtTip)
    end
end

--@brief    点击物品后的回调
--@param    tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function CellTowerRewardTip:onClickListItem(tItem, nTag, tData)
    WZLog("CellTowerRewardTip:onClickListItem")
    WndItemInfo:onCloseClick()
    local offset = GlobalMethod:ccp(0,0)
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData,false,offset)
end

--@brief 越南语适配函数
function CellTowerRewardTip:_adaptLanguage_vn()
    local imgArrow = GetElement(self.m_root, "imgArrow_CellTowerRewardTip",WZUIImage)
    if imgArrow then
        imgArrow:setRelativePosition(GlobalMethod:ccp(0.625385,0.782496))
    end
end
-------------------------------------私有方法模块End----------------------------------------
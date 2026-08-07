--CellTowerPreview.lua
--@brief	CellTowerPreview的UI模块
--@date		2015/04/28
--@author	xiaoyu_wu
--@note		爬塔副本奖励预览单元格


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTowerPreview:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTowerPreview:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新界面
function CellTowerPreview:_update()
	if self.m_root == nil or self.m_tData == nil then
        return
    end
    local txtLevel = GetElement(self.m_root, "txtLevel_CellTowerPreview", WZUILabelTTF)
    local imgRank = GetElement(self.m_root,"imgRank_CellTowerPreview",WZUIImage)
    local bSame = false
    
    if self.m_tData.rank[1][1] == self.m_tData.rank[1][2] then
        bSame = true
    end
    if bSame then
        txtLevel:setText(self.m_tData.rank[1][1])
    elseif self.m_tData.rank[1][2] == -1 then
        txtLevel:setText(self.m_tData.rank[1][1] .. "+")
    else
        txtLevel:setText(self.m_tData.rank[1][1] .. "-" ..self.m_tData.rank[1][2])
    end

    if self.m_tData.rank[1][1] ==1 then
        imgRank:setFile("ui/common/common_icon_1st.png")
        txtLevel:setVisible(false)
    elseif self.m_tData.rank[1][1] ==2 then
        imgRank:setFile("ui/common/common_icon_2nd.png")
        txtLevel:setVisible(false)
    elseif self.m_tData.rank[1][1] ==3 then
        imgRank:setFile("ui/common/common_icon_3rd.png")
        txtLevel:setVisible(false)
    end
    
    for i = 1, math.min(5, #self.m_tData.reward_gift) do
        local eItem, tItem = self:_createCellGoodItem(i)
        eItem:setScale(0.9)
        local con = GetElement(self.m_root, "con"..i.."_CellTowerPreview")
        con:addChild(eItem)
    end
end

--@brief    创建一个物品格子
--@param    nIndex，序号
function CellTowerPreview:_createCellGoodItem(nIndex)
    local eItem, tItem = CellGoodItem:createElement()
    --eItem:setScale(0.3)
    tItem:setFromTag(nIndex-1)
    tItem:setItemClickFun(WndTowerPreview, WndTowerPreview.onClickItem)
    local nItemId = self.m_tData.reward_gift[nIndex][1]
    local nItemCount= self.m_tData.reward_gift[nIndex][2]
    if nItemId then
        local tData = {
            id = nItemId,
            lastNum = nItemCount,
            lastTime = 1,
            isUse = false,
            data = "",
            playerItemId = -1,
            basicInfo = GetItemLocalData(nItemId)
        }
        tItem:setCellGoodItem(tData, 2)
    end
    return eItem, tItem
end

-------------------------------------私有方法模块End----------------------------------------

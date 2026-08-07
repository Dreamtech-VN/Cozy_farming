--CellDropList.lua
--@brief	CellDropList的UI模块
--@date		2015/04/15
--@author	xiaoyu_wu
--@note		掉落列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDropList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDropList:onExit(element)
	self:_unInit()
end

--@brief	点击物品后的回调
--@param	tItem:物品节点绑定的lua表
--@param    nTag:序号
--@param    tData:物品数据表
function CellDropList:onClickListItem(tItem, nTag, tData)
    WZLog("CellDropList:onClickListItem")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(tItem.m_root,self.m_root,1,tData, false)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新掉落列表
function CellDropList:_updateDropList()
    if self.m_root == nil or self.m_tData == nil then
        return
    end
    local tbconDropList = GetElement(self.m_root, "tbconDropList_CellDropList", WZUITableContainer)
    local nMinCellCount = 12
    tbconDropList:cleanTable()
    for i=1, math.max(#self.m_tData, nMinCellCount) do
        local eItem, tItem = self:_createCellGoodItem(i)
        tbconDropList:setCellElement(eItem)
        if i > #self.m_tData then
            eItem:setTouchEnable(false)
        end
    end
end

--@brief    创建一个物品格子
--@param    nIndex，序号
function CellDropList:_createCellGoodItem(nIndex)
    local eItem, tItem = CellGoodItem:createElement()
    eItem:setTag(nIndex-1)
    eItem:setScale(0.96)
    tItem:setFromTag(nIndex-1)
    tItem:setItemClickFun(self, self.onClickListItem)
    local nItemId = self.m_tData[nIndex]
    if nItemId then
        local tData = {
            id = nItemId,
            lastNum = 1,
            lastTime = 1,
            isUse = false,
            data = "",
            playerItemId = -1,
            basicInfo = GetItemLocalData(nItemId)
        }
        tItem:setCellGoodItem(tData, 5)
    end
    return eItem, tItem
end


-------------------------------------私有方法模块End----------------------------------------

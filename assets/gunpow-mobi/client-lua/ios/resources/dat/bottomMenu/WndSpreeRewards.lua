--WndSpreeRewards.lua
--@brief	WndSpreeRewards的UI模块
--@date		2014/01/17
--@author	xiaoyu_wu
--@note		获得奖励模块

TOTALSIZE = GlobalMethod:CCSize(570,276) --展示所有物品的容器大小
ITEMSIZE = GlobalMethod:CCSize(135,128) --每个物品的大小
EACHROWCOUNT = 4    --每排最多显示物品的个数
HORIZONTALINTERVAL = 10 --水平间隔
VERTIVALINTERVAL = 10  --垂直间隔

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSpreeRewards:onEnter(element)
	self.m_root = element
    local txtSpree = GetElement(element, "txtSpree_WndSpreeRewards", WZUILabelTTF)
    txtSpree:setText(LocalStrings.SPREE_SUCCESS)
    self:_update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSpreeRewards:onExit(element)
	self:_unInit()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:关闭按钮绑定的UI节点引用
function WndSpreeRewards:onClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    WindowManager:removeWindow(self.m_root, self)
end

--@brief	动画播放完成时被调用的函数
--@param	element:动画绑定的UI节点引用
function WndSpreeRewards:onAnimationFinish(element)
    local conAni = GetElement(self.m_root, "conAni_WndSpreeRewards")
    conAni:setVisible(false)
    local conContent = GetElement(self.m_root, "conContent_WndSpreeRewards")
    conContent:setVisible(true)
    conContent:setScale(0.2)
    local scaleAni = WZUIActionScaleTo:create()
    scaleAni:setScaleX(1)
    scaleAni:setScaleY(1)
    scaleAni:setDuration(0.3)
    conContent:runUIAction(scaleAni)
end

--@brief	设置说明文本
--@param	sText:说明文本
function WndSpreeRewards:setDescriptionText(sText)
    if self.m_root == nil then
        return
    end
    local txtSpree = GetElement(self.m_root, "txtSpree_WndSpreeRewards", WZUILabelTTF)
    txtSpree:setText(sText)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	界面更新函数
function WndSpreeRewards:_update()
    if self.m_root == nil then
        return
    end
    local rollconSpree = GetElement(self.m_root, "rollconSpree_WndSpreeRewards", WZUIMoveContainer)
    local moveElement = rollconSpree:getMoveElement()
    
    local nRowCount = math.floor((self.m_tItemList.nCount-1)/4) + 1
    local nHeight = nRowCount*(ITEMSIZE.height + VERTIVALINTERVAL)

    if nHeight > TOTALSIZE.height then
        moveElement:setContentSize(GlobalMethod:CCSize(TOTALSIZE.width, nHeight))
        rollconSpree:UpdateInsidePosition()
        moveElement:setPositionY(rollconSpree:getMinPosition().y)
        rollconSpree:setEnableMoveVertical(true)   
    end

    local nOffsetX = 0
    local nOffsetY = 0
    if nRowCount == 1 then
        local nWidth = self.m_tItemList.nCount*ITEMSIZE.width + (self.m_tItemList.nCount-1)*HORIZONTALINTERVAL
        nOffsetX = (TOTALSIZE.width - nWidth)/2
        nOffsetY = (TOTALSIZE.height - ITEMSIZE.height)/2
    end
    for i = 1, self.m_tItemList.nCount do
        local cellElement = self:_createItemCell(i)
        moveElement:addChild(cellElement)
        --描点在(0,1)
        local nPosX = nOffsetX + math.mod(i-1,4)*(ITEMSIZE.width + HORIZONTALINTERVAL)
        local nPosY = nOffsetY + nHeight - math.floor((i-1)/4)*(ITEMSIZE.height + VERTIVALINTERVAL)
        cellElement:setPosition(nPosX, nPosY)
    end
end

--@brief	根据索引创建一个CellItem
--@param	nIndex:索引
--@return   #1，CellItem对象
function WndSpreeRewards:_createItemCell(nIndex)
    if nIndex > self.m_tItemList.nCount then
        return
    end
    local cellElement, tLuaObj = CellItem:createElement()
    tLuaObj:setImg(self.m_tItemList.tItemIcon[nIndex])
    tLuaObj:setName(self.m_tItemList.tItemName[nIndex])
    tLuaObj:setNum(self.m_tItemList.tItemNum[nIndex])
    cellElement:setTouchEnable(false)
    cellElement:setAnchorPoint(GlobalMethod:ccp(0,1))
    return cellElement
end



-------------------------------------私有方法模块End----------------------------------------

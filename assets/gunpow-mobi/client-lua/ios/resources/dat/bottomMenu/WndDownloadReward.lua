--WndDownloadReward.lua
--@brief	WndDownloadReward的UI模块
--@date		2014/08/14
--@author	suyuan
--@note		下载奖励模块

local TOTALSIZE = GlobalMethod:CCSize(570,276) --展示所有物品的容器大小
local ITEMSIZE = GlobalMethod:CCSize(135,128) --每个物品的大小
local EACHROWCOUNT = 4    --每排最多显示物品的个数
local HORIZONTALINTERVAL = 10 --水平间隔
local VERTIVALINTERVAL = 10  --垂直间隔

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndDownloadReward:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
    local txtSpree = GetElement(element, "txtSpree_WndDownloadReward", WZUILabelTTF)
    txtSpree:setText(LocalStrings.SPREE_SUCCESS)
    self:_update()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndDownloadReward:onExit(element)
	self:_unInit()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:关闭按钮绑定的UI节点引用
function WndDownloadReward:onClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    self.callbac[2](0,MSGBOXRESTYPE_CONFIRM)
   
    WindowManager:removeWindow(self.m_root, self)
end

--@brief	设置说明文本
--@param	sText:说明文本
function WndDownloadReward:setDescriptionText(sText)
    if self.m_root == nil then
        return
    end
    local txtSpree = GetElement(self.m_root, "txtSpree_WndDownloadReward", WZUILabelTTF)
    txtSpree:setText(sText)
end

--@brief    显示奖励界面
function WndDownloadReward:showDownloadReward()
    local tItemName = GlobalGame.g_tDownloadReward.rewardItemsName
    local tItemIcon = GlobalGame.g_tDownloadReward.rewardItemsIcon
    local itemCount = GlobalGame.g_tDownloadReward.rewardItemsNum

    local sJson = json.encode(GlobalGame.g_tDownloadReward)
    WZLog("显示奖励界面", sJson)

    local wndDownloadRewardElement = WndDownloadReward:createElement()
    WndDownloadReward:setItemList(tItemName, tItemIcon, itemCount)
    WindowManager:addWindow(wndDownloadRewardElement, WndDownloadReward, nil, false)
    WndDownloadReward:setDescriptionText(string.format(LocalStrings.DOWNLOADREWARD_TIP, ProjConfig.EXTEND_LEVEL))
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	界面更新函数
function WndDownloadReward:_update()
    if self.m_root == nil then
        return
    end
    local rollconSpree = GetElement(self.m_root, "rollconSpree_WndDownloadReward", WZUIMoveContainer)
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
function WndDownloadReward:_createItemCell(nIndex)
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

--@brief	英文包适配函数
function WndDownloadReward:_adaptLanguage_en()
     local txtSpree = GetElement(self.m_root, "txtSpree_WndDownloadReward", WZUILabelTTF)
     txtSpree:setScale(0.7)
end

function WndDownloadReward:_adaptLanguage_pt(  )
    local txtSpree = GetElement(self.m_root, "txtSpree_WndDownloadReward", WZUILabelTTF)
    txtSpree:setScale(0.7)
end

-------------------------------------私有方法模块End----------------------------------------

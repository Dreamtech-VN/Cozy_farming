--CellShopNew.lua
--@brief	CellShopNew的UI模块
--@date		2015-6-16
--@author	binshao
--@note		单个服务器模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellShopNew:onEnter(element)
	self.m_root = element
    WZLog("----------CellShopNew:onEnter---------",element:getTag())
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellShopNew:onExit(element)
	self:_unInit()
end

function CellShopNew:onBuy()
    local cellData = self.data
    local tag = self.m_root:getTag()
    WZLog("CellShopNew---------onBuy----------",tag,self.data)
    local itemId = cellData.initData.shopItemId
    if cellData.initData.limitLeave == -1 or cellData.initData.limitLeave > 0 then
        WndShop:showShopInterfaceByTag(itemId)
    else
        MsgBoxManager:showTipBox(LocalStrings.SHOP_DAY_LIMITED )
    end
end

-- 加载数据
function CellShopNew:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellShopNew")
    self.m_root:addChild(cellElement)
    self.loadEnd = true
    self:_update()
end

function CellShopNew:setNewImgPath(path)
    WZLog("setOldImgPath-------------path-------------",path,self.loadEnd)
    self.data.imgPath = path
    if self.m_root == nil then return end
    if self.loadEnd == false then return end
    local di = GetElement(self.m_root, "imgDi_CellShopNew", WZUIImage)
    di:setFile(path)
end

-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新函数
function CellShopNew:_update()
    if self.loadEnd == false then return end
    WZLog("----------CellShopNew:_update---------",self.m_root:getTag(),self.data)
    -- 服务器标示
    if self.data.imgPath then
        local img = GetElement(self.m_root,"imgDi_CellShopNew",WZUIImage)
        img:setFile(self.data.imgPath)
    end
end

-------------------------------------私有方法模块End----------------------------------------
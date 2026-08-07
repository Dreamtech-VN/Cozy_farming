--CellShopOld.lua
--@brief	CellShopOld的UI模块
--@date		2015-6-16
--@author	binshao
--@note		单个服务器模块


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellShopOld:onEnter(element)
	self.m_root = element
    WZLog("----------CellShopOld:onEnter---------",element:getTag())
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellShopOld:onExit(element)
	self:_unInit()
end

function CellShopOld:onBuy()
    local cellData = self.data
    local tag = self.m_root:getTag()
    local itemId = cellData.initData.shopItemId
	local newad = cellData.initData.newad
    WZLog("CellShopOld---------onBuy----------",WndFastGetItems.m_nShopTipItemId,tag,newad,Serialize(cellData))
	if newad == "0" or newad == "1" then
		if cellData.jumpType == 2 then
			WndFastGetItems.m_nShopTipItemId = itemId
		end
    WZLog("CellShopOld1---------onBuy----------",WndFastGetItems.m_nShopTipItemId,tag,newad,Serialize(cellData))
		local jumpMethod = {"none","onTopDressTitle","onTopPropTitle","onTopLimitTitle","onTopGiveTitle"}
		local mainType = cellData.initData.mainType
		local index1,index2
        local curType = json.decode(mainType)
        for k,v in pairs(curType) do
            index1 = tonumber(k)
            index2 = tonumber(v)
		end
    	WZLog("CellShopOld---------onBuy----------",mainType,index1,index2)
		WndShop:onTempTab(index1)
		if WndShop[jumpMethod[index1]] then
			WndShop[jumpMethod[index1]](WndShop, index2)
		end
		return
	end
    if cellData.initData.limitLeave == -1 or cellData.initData.limitLeave > 0 then
        WndShop:showShopInterfaceByTag(itemId)
    else
        MsgBoxManager:showTipBox(LocalStrings.SHOP_DAY_LIMITED )
    end
end

-- 加载数据
function CellShopOld:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellShopOld")
    self.m_root:addChild(cellElement)
    self.loadEnd = true
    self:_update()
end

function CellShopOld:setOldImgPath(path)
    WZLog("setOldImgPath-------------path-------------",path,self.loadEnd)
    self.data.imgPath = path
    if self.m_root == nil then return end
    if self.loadEnd == false then return end
    local di = GetElement(self.m_root, "imgDi_CellShopOld", WZUIImage)
    di:setFile(path)
end

-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新函数
function CellShopOld:_update()
    if self.loadEnd == false then return end
    WZLog("----------CellShopOld:_update---------",self.m_root:getTag(),self.data)
    -- 服务器标示
    if self.data.imgPath then
        local img = GetElement(self.m_root,"imgDi_CellShopOld",WZUIImage)
        img:setFile(self.data.imgPath)
    end
end

-------------------------------------私有方法模块End----------------------------------------

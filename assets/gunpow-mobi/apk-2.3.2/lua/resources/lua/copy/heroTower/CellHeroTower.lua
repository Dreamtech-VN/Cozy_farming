--CellHeroTower.lua
--@brief	CellHeroTower的UI模块
--@date		2020/03/27
--@author	XTX
--@note		英雄塔-英雄关卡


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellHeroTower:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellHeroTower:onExit(element)
	self:_unInit()
end

--@brief 	加载
function CellHeroTower:onLoadData(element)
	-- body
	local cellElement = WZUISystem:getInstance():createElement("CellHeroTower")
    self.m_root:addChild(cellElement)

    self:_update()
end

--@brief 	点击英雄
function CellHeroTower:onClickHero(element)
	-- body

end

--@brief 	设置战力的显示
function CellHeroTower:setFightingVisible(bVisible)
	-- body
	self.m_bIsShowFight = bVisible
	if self.m_root == nil then return end 
	--战力
	local txtFighting = GetElement(self.m_root, "txtFighting_CellHeroTower", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setVisible(bVisible)
	end
	local imgArrow = GetElement(self.m_root, "imgArrow_CellHeroTower", WZUIImage)
	if imgArrow then 
		imgArrow:setVisible(bVisible)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellHeroTower:_update()
	-- body
	local tData = self.m_tData
	if self.m_tData == nil then return end 

	local conRole = GetElement(self.m_root, "conRole_CellHeroTower", WZUIContainer)
	conRole:removeAllChildrenWithCleanup(true)

	--英雄形象
	local tEquip = {}
    table.insert(tEquip, tData.playerInfo.headId)
    table.insert(tEquip, tData.playerInfo.faceId)
    table.insert(tEquip, tData.playerInfo.bodyId)
    table.insert(tEquip, tData.playerInfo.wingId)
	local conPlayer = CreatePlayerFigure(tData.playerInfo.sex, tEquip, "wait0", nil, nil, nil, nil, nil, nil, nil, tData.playerInfo.headColor, tData.playerInfo.bodyColor, false)
    conRole:addChild(conPlayer:getAnimNode())
    conPlayer:getAnimNode():setScale(0.85)
    conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.5,0)) 
	--名字
	local txtName = GetElement(self.m_root, "txtName_CellHeroTower", WZUILabelTTF)
	if txtName then 
		txtName:setText(tData.playerInfo.name)
	end
	local txtFloorName = GetElement(self.m_root, "txtFloorName_CellHeroTower", WZUILabelTTF)
	if txtFloorName then 
		txtFloorName:setText(tData.towerInfo.name)
	end
	--战力
	local txtFighting = GetElement(self.m_root, "txtFighting_CellHeroTower", WZUILabelTTF)
	if txtFighting then 
		txtFighting:setText(LocalStrings.COMBAT .. ":" .. tData.playerInfo.fight)
	end
	--状态
	local imgState = GetElement(self.m_root, "imgState_CellHeroTower", WZUIImage)
	if tData.state == 1 then 
		imgState:setVisible(true)
	end

	self:setFightingVisible(self.m_bIsShowFight)
end




-------------------------------------私有方法模块End----------------------------------------

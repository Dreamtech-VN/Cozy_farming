--CellProfessionCrystalLibrary.lua
--@brief	CellProfessionCrystalLibrary的UI模块
--@date		2021/02/07
--@author	XTX
--@note		职业水晶图鉴-Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellProfessionCrystalLibrary:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellProfessionCrystalLibrary:onExit(element)
	self:_unInit()
end

--@brief 	加载数据
function CellProfessionCrystalLibrary:onLoadData(element)
	-- body
	local celElement = WZUISystem:getInstance():createElement("CellProfessionCrystalLibrary")
	self.m_root:addChild(celElement)

	self.m_bIsLoaded = true
	self:_update()

	AdaptLanguage(self)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief  	刷新
function CellProfessionCrystalLibrary:_update()
	-- body
	local imgSkillIcon = GetElement(self.m_root, "imgSkillIcon_CellProfessionCrystalLibrary", WZUIImage)
	if imgSkillIcon then 
		imgSkillIcon:setFile(self.m_tData.icon)
	end

	local txtSkillName = GetElement(self.m_root, "txtSkillName_CellProfessionCrystalLibrary", WZUILabelTTF)
	if txtSkillName then 
		txtSkillName:setText(self.m_tData.name)
		txtSkillName:setUseSystemFont(true)
	end

	local imgCrystal = GetElement(self.m_root, "imgCrystal1_CellProfessionCrystalLibrary", WZUIImage)
	if imgCrystal then 
		imgCrystal:setScale(0.5)
		imgCrystal:setFile(self.m_tData.crystalIcon1)
	end

	local imgCrystal2 = GetElement(self.m_root, "imgCrystal2_CellProfessionCrystalLibrary", WZUIImage)
	if imgCrystal2 then 
		imgCrystal2:setScale(0.5)
		imgCrystal2:setFile(self.m_tData.crystalIcon2)
	end

	local txtDesc = GetElement(self.m_root, "txtDesc_CellProfessionCrystalLibrary", WZUILabelTTF)
	if txtDesc then 
		txtDesc:setText(self.m_tData.desc)
	end
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function CellProfessionCrystalLibrary:_adaptLanguage_vn()
	local txtSkillName = GetElement(self.m_root, "txtSkillName_CellProfessionCrystalLibrary", WZUILabelTTF)
	txtSkillName:setScale(0.75)
	local txtDesc = GetElement(self.m_root, "txtDesc_CellProfessionCrystalLibrary", WZUILabelTTF)
	txtDesc:setScale(0.75)
	local imgCrystal = GetElement(self.m_root, "imgCrystal1_CellProfessionCrystalLibrary", WZUIImage)
	imgCrystal:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
	local imgCrystal2 = GetElement(self.m_root, "imgCrystal2_CellProfessionCrystalLibrary", WZUIImage)
	imgCrystal2:setRelativePosition(GlobalMethod:ccp(0.85,0.5))
end
-------------------------------------语言适配End----------------------------------------

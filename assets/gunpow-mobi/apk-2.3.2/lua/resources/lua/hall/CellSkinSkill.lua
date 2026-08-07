--CellSkinSkill.lua
--@brief	CellSkinSkill的UI模块
--@date		2017/12/21
--@author	zsq
--@note		皮肤技能


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSkinSkill:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSkinSkill:onExit(element)
	self:_unInit()
end

function CellSkinSkill:setData(tData)
    self.m_tData = tData
end

function CellSkinSkill:onClickSkill(element)
	WZLog("CellSkinSkill:onClickSkill")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WndSkinSkill:showDetail(self.m_tData)

	if WndSkinSkill.selectedCell ~= nil then
		WndSkinSkill.selectedCell:setHighLight(false)
	end
	WndSkinSkill.selectedCell = self
	WndSkinSkill.selectedCell:setHighLight(true)
end

function CellSkinSkill:setHighLight(bool)
	WZLog("CellSkinSkill:setHighLight", bool, Serialize(self.m_tData))
	GetElement(self.m_root,"imgSelectBg_WndSkillProp",WZUI9Image):setVisible(bool)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellSkinSkill:onLoadData(element)
	local cellElement = WZUISystem:getInstance():createElement("CellSkinSkill")
	assert(cellElement, "CellSkinSkill cellElement create failed!")
    self.m_root:addChild(cellElement)
	cellElement:setLuaObjectIndex(self)

	local tData = self.m_tData
	local path = tData.icon
	
    local name = tData.name
    local explain = tData.tool_desc
    local openTip = tData.tj_desc
    local openType  = tData.hdtj
    local vipLevel = tData.hdtjcs
    local levelIcon = tData.lv_icon
    
	--图标
    local imgSkill  = GetElement(self.m_root,"imgSkill_WndSkillProp",WZUIImage)
	imgSkill:setFile(path)
	--等级图标
    local imgSkillLevel = GetElement(self.m_root,"imgSkillLevel_WndSkillProp",WZUIImage)
	imgSkillLevel:setFile(levelIcon)
	--状态类型
	local imgSkillStats = GetElement(self.m_root,"imgSkillStats_WndSkillProp",WZUIImage)
	local txtSkillStats = GetElement(self.m_root,"txtSkillStats_WndSkillProp",WZUILabelTTF)
	if tData.statsType == 2 then
		imgSkillStats:setVisible(false)
		txtSkillStats:setVisible(true)
	else
		imgSkillStats:setVisible(true)
		txtSkillStats:setVisible(false)
	end

	GetElement(self.m_root,"imgSkillBg_WndSkillProp",WZUIImage):setGrayRender(not tData.isOwn)
	GetElement(self.m_root,"imgSkill_WndSkillProp",WZUIImage):setGrayRender(not tData.isOwn)
	GetElement(self.m_root,"conSkillStats_WndSkillProp",WZUIContainer):setVisible(tData.isUse)
end




-------------------------------------私有方法模块End----------------------------------------

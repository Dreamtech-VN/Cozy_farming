--CellSkillGrid.lua
--@brief	CellSkillGrid的UI模块
--@date		2021/06/04
--@author	yrd
--@note		一个技能格子


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellSkillGrid:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellSkillGrid:onExit(element)
	self:_unInit()
end

--@brief	更新函数
function CellSkillGrid:_update()
    if self.m_root == nil then return end

	local skillInfo = self.m_tItem.basicInfo
	--id
	GetElement(self.m_root,"gridId_CellSkillGrid",WZUILabelTTF):setText(skillInfo.id)
	--技能
	local imgSkill = GetElement(self.m_root,"imgSkill_CellSkillGrid",WZUIImage)
	local imgSkillBg = GetElement(self.m_root,"imgSkillBg_CellSkillGrid",WZUIImage)
	imgSkill:setFile(skillInfo.icon)
	if skillInfo.skill_type == 6 then
		imgSkillBg:setFile("ui/common/common_zd_dk_ww.png")
		imgSkillBg:setScale(1.1)
		imgSkill:setScale(0.8)
	end
	--技能等级
    local imgSkillLevel = GetElement(self.m_root,"imgSkillLevel_CellSkillGrid",WZUIImage)
	if skillInfo.lv_icon ~= nil and type(skillInfo.lv_icon) == "string" then
		imgSkillLevel:setFile(skillInfo.lv_icon)
	end
	--装备中
	local imgSkillStats = GetElement(self.m_root,"imgSkillStats_CellSkillGrid",WZUIImage)
	imgSkillStats:setVisible(false)
	if self.m_tItem.isUse then
		imgSkillStats:setVisible(true)
	end
	--数量
	local txtSkillCount = GetElement(self.m_root,"txtSkillCount_CellSkillGrid",WZUILabelTTF)
	txtSkillCount:setText(self.m_tItem.lastNum)
	--按钮 默认不能点击
	local btnSkillInfo = GetElement(self.m_root,"btnSkillInfo_CellSkillGrid",WZUIButton)
	btnSkillInfo:setTouchContainerEnable(false)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

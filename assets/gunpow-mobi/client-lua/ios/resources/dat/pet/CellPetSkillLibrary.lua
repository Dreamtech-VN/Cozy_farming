--CellPetSkillLibrary.lua
--@brief	CellPetSkillLibrary的UI模块
--@date		2017/11/20
--@author	zsq
--@note		宠物技能图鉴


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPetSkillLibrary:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPetSkillLibrary:onExit(element)
	self:_unInit()
end

function CellPetSkillLibrary:setData(tData) 
	self.m_tData = tData	
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellPetSkillLibrary:onLoadData() 
	WZLog("CellPetSkillLibrary:onLoadData")
	local element = WZUISystem:getInstance():createElement("CellPetSkillLibrary")
	assert(element, "CellPetSkillLibrary element create failed!")
    self.m_root:addChild(element)
	element:setLuaObjectIndex(self)

	local tData = self.m_tData
	GetElement(self.m_root,"imgSkillP1_WndPetSkill",WZUIImage):setFile(tData.icon)
	GetElement(self.m_root,"txtName1_WndPetsSkill",WZUILabelTTF):setText(tData.name)
	GetElement(self.m_root,"txtLvK1_WndPetsSkill",WZUILabelTTF):setText(tData.tool_desc)
	AdaptLanguage(self)
end




-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------------
function CellPetSkillLibrary:_adaptLanguage_vn( )
	local txtName = GetElement(self.m_root,"txtName1_WndPetsSkill",WZUILabelTTF)
	txtName:setRelativePosition(GlobalMethod:ccp(0.15,0.75))
	txtName:setScale(0.8)

	local txtLvK = GetElement(self.m_root,"txtLvK1_WndPetsSkill",WZUILabelTTF)
	txtLvK:setRelativePosition(GlobalMethod:ccp(0.146892,0.65))
	txtLvK:setScale(0.8)
	txtLvK:setDimensions(GlobalMethod:CCSize(460,0))
end
-------------------------------------语言适配End------------------------------------------------
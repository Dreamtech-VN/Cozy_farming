--WndSkinSkillData.lua
--@brief	WndSkinSkill的数据模块
--@date		2017/12/21
--@author	zsq
--@note		皮肤技能

WndSkinSkill = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSkinSkill:_init()
	self.m_root = nil	 	  			--场景根节点
	self.useSkill = nil
	self.skillList = nil
	self.showSkillId = nil
	self.channel = nil
	self.selectedCell = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSkinSkill:_unInit()
	self.m_root = nil
	self.useSkill = nil
	self.skillList = nil
	self.showSkillId = nil
	self.channel = nil
	self.selectedCell = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSkinSkill:createElement()
	if WndSkinSkill.m_root ~= nil then
		WindowManager:removeWindow(WndSkinSkill.m_root, WndSkinSkill, true)
	end
	local element = WZUISystem:getInstance():createElement("WndSkinSkill")
	assert(element, "WndSkinSkill create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndSkinSkill:setData(useSkill, skillList)
	self.useSkill = useSkill
	self.skillList = VectorToTable(skillList)
	WZLog("WndSkinSkill:setData", useSkill, Serialize(VectorToTable(skillList)))

	ProtocolProcessorPhantom:send_SHAPE_GetShapeInfo()
end




-------------------------------------私有方法模块End----------------------------------------

--WndSkillExplosionData.lua
--@brief	WndSkillExplosion的数据模块
--@date		2022/02/10
--@author	yrd
--@note		技能界面-攻击特效

WndSkillExplosion = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSkillExplosion:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = {} 					--列表数据
	self.m_tCells = {} 					--列表元素
	self.m_tOwnData = {} 				--已拥有特效数据
	self.m_nSelectedIndex = 1 			--当前选中的元素索引
	self.m_tTxtCells = {} 				--属性元素
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSkillExplosion:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_tCells = nil
	self.m_tOwnData = nil
	self.m_nSelectedIndex = nil
	self.m_tTxtCells = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSkillExplosion:createElement()
	if WndSkillExplosion.m_root ~= nil then
		WindowManager:removeWindow(WndSkillExplosion.m_root, WndSkillExplosion, true)
	end
	local element = WZUISystem:getInstance():createElement("WndSkillExplosion")
	assert(element, "WndSkillExplosion create element failed!")
	self:_init()
	return element
end

--@brief	使用成功
function WndSkillExplosion:useItemOk(result)
	local tOwnedItem = self:getOwnItemByItemId(self.m_tData[self.m_nSelectedIndex].id)
	if tOwnedItem ~= nil and tOwnedItem.isUse == true then
		if result == 1 then
			MsgBoxManager:showTipBox(LocalStrings.SKILL_EXPLOSION_2)
		else
			MsgBoxManager:showTipBox(LocalStrings.SKILL_EXPLOSION_3)
		end
	else
		if result == 1 then
			MsgBoxManager:showTipBox(LocalStrings.SKILL_EXPLOSION_4)
		else
			MsgBoxManager:showTipBox(LocalStrings.SKILL_EXPLOSION_5)
		end
	end

	self:updateListData()
	self:updateUI()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

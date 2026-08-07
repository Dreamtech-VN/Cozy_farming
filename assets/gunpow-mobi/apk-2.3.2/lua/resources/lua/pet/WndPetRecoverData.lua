--WndPetRecoverData.lua
--@brief	WndPetRecover的数据模块
--@date		2016/11/17
--@author	zhangming
--@note		宠物回收

WndPetRecover = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPetRecover:_init()
	self.m_root = nil	 	  			--场景根节点
	self.t_choiceList = {}
	self.t_PetList = {}
	self.m_nType = 1 					--1:宠物 2:宠物装备
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPetRecover:_unInit()
	self.m_root = nil
	self.t_choiceList = nil
	self.t_PetList = nil
	self.m_nType = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPetRecover:createElement()
	local element = WZUISystem:getInstance():createElement("WndPetRecover")
	assert(element, "WndPetRecover create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

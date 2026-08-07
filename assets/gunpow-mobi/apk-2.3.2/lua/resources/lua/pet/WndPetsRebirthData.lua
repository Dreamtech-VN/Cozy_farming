--WndPetsRebirthData.lua
--@brief	WndPetsRebirth的数据模块
--@date		2015/03/31
--@author	qixiang_xie
--@note		宠物重生

WndPetsRebirth = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPetsRebirth:_init()
	self.m_root = nil	 	  			 --场景根节点
	self.m_petInfo = nil                 --宠物信息表
	self.m_nConsumeCount = 0             --记录宠物重生需要消耗的钻石数量
	self.m_nCostType  = 1                --记录消耗物品的类型
	self.m_bISAlter = false              --标识是否正在进行重生，防止多次点击事件
	self.m_tMatchPets = {}
	self.m_choicePet = nil				 --当前选取的宠物
	self.b_firstOpen = true             --子界面是否第一次打开
	self.petAni = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPetsRebirth:_unInit()
	self.m_root = nil
	self.m_petInfo = nil
	self.m_nConsumeCount = nil
	self.m_nCostType  = 1 
	self.m_bISAlter = nil
	self.m_tMatchPets = nil
	self.m_choicePet = nil
	self.b_firstOpen = nil			
	self.petAni = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPetsRebirth:createElement()
	if WndPetsRebirth.m_root ~= nil then
		WndPetsRebirth.m_root:removeFromParentAndCleanup(true)
	end
	local element = WZUISystem:getInstance():createElement("WndPetsRebirth")
	assert(element, "WndPetsRebirth create element failed!")
	self:_init()
	return element
end

--@brief   更新宠物信息
function WndPetsRebirth:updatePetInfo(petInfo)
	self.m_petInfo = petInfo
end

--@brief    设置宠物信息
function WndPetsRebirth:setPetInfo(petInfo)
	WZLog("WndPetsRebirth:setPetInfo")
	if petInfo ~= nil then
		self.m_petInfo = petInfo
	    
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WndPetsRebirth:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------

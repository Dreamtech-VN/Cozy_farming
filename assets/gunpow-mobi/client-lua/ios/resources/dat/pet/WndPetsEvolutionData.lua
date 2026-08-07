--WndPetsEvolutionData.lua
--@brief	WndPetsEvolution的数据模块
--@date		2015/03/31
--@author	qixiang_xie
--@note		宠物进化

WndPetsEvolution = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPetsEvolution:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_petInfo = nil                --宠物信息
	self.m_tUsePet = {}                 --记录格子里的宠物
	self.n_canUseNum = 0                --可以使用的个数
	self.m_bISAlter = false             --标识是否正在进行进阶，防止多次点击事件
	self.m_tMatchPets = nil             --存放可以被当前宠物吞噬的宠物
	self.m_tMatchList = {}
	self.t_usePetId = {}				--宠物的使用id
	self.t_cost = {}					--宠物的消耗表
	self.n_curFighting = 0 				--当前战力
	self.b_eatPet = false               --是否处于添加宠物界面
	self.b_firstOpen = true             --子界面是否第一次打开
	self.n_needLv = 0                   --进阶所需要等级
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPetsEvolution:_unInit()
	self.m_root = nil	 	  			
	self.m_petInfo = nil                
	self.m_tUsePet = nil                 
	self.n_canUseNum = 0                
	self.m_bISAlter = false             
	self.m_tMatchPets = nil
	self.m_tMatchList = nil
	self.t_cost = nil
	self.t_usePetId = nil
	self.n_curFighting = nil
	self.b_eatPet = nil
	self.b_firstOpen = nil
	self.n_needLv = nil
end





-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPetsEvolution:createElement()

	local element = WZUISystem:getInstance():createElement("WndPetsEvolution")
	assert(element, "WndPetsEvolution create element failed!")
	self:_init()
	return element
end

--@brief    设置宠物信息
function WndPetsEvolution:setPetInfo(petInfo)
	WZLog("WndPetsEvolution:setPetInfo")
	if petInfo ~= nil then
		self.m_petInfo = petInfo
		self.n_curFighting = petInfo.fighting
	end
end

--@brief   更新宠物信息
function WndPetsEvolution:updatePetInfo(petInfo)
	self.m_petInfo = petInfo
end


--@brief    更新进化按钮状态
function WndPetsEvolution:updateBtnStats()
	local btn =  self.m_root:getChildElement("btnPetEvoution_WndPetsEvolution")
	btn = WZUIButton:luaTo(btn)
	if self.m_petInfo then
        if self.m_petInfo.isInUsed then
        	btn:setTouchEnable(false)
        end
    else
    	btn:setTouchEnable(true)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WndPetsEvolution:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end




-------------------------------------私有方法模块End----------------------------------------

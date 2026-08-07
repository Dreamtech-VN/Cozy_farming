--WndPetsSkillData.lua
--@brief	WndPetsSkill的数据模块
--@date		2015/03/31
--@author	qixiang_xie
--@note		宠物技能

WndPetsSkill = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPetsSkill:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_petInfo = nil                 --存放宠物信息
	self.m_petSkillLockId = 0           --记录宠物那个技能锁定了
	self.m_bISAlter = false             --标识是否正在进行技能洗炼，防止多次点击事件
	self.n_skillNum = 0                 --技能数量
	self.m_tPetDate = {}        	    --宠物消耗的数据
	self.n_tSkillId = {}                --宠物的技能表
	self.locakNum = 0                   --宠物锁定
	self.m_nCheckTag = nil
	self.m_nPetId = nil
    self.getCache = false
    self.petAni = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPetsSkill:_unInit()
	self.m_root = nil
	self.m_petInfo = nil
	self.m_petSkillLockId = nil
	self.m_bISAlter = nil
	self.n_skillNum = nil
	self.m_tPetDate = nil
	self.n_tSkillId = nil
	self.locakNum = nil        	           
	self.m_nCheckTag = nil
	self.m_nPetId = nil
	self.petAni = nil
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPetsSkill:createElement()
	if WndPetsSkill.m_root ~= nil then
		WndPetsSkill.m_root:removeFromParentAndCleanup(true)
	end
	local element = WZUISystem:getInstance():createElement("WndPetsSkill")
	assert(element, "WndPetsSkill create element failed!")
	self:_init()
	return element
end

--@brief   更新宠物信息
function WndPetsSkill:updatePetInfo(petInfo)
	self.m_petInfo = petInfo
end

--@brief    设置宠物信息
function WndPetsSkill:setPetInfo(petInfo)
	WZLog("WndPetsEvolution:setPetInfo", Serialize(petInfo))
	if petInfo ~= nil then
		self.m_petInfo = petInfo
	    --self:setSkillInfo()
		self.m_nPetId = self.m_petInfo.playerPetId
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WndPetsSkill:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

--打开宠物技能图鉴
function WndPetsSkill:onLibrary(element) 
	WZLog("WndPetsSkill:onLibrary")
  	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	WndPetSkillLibrary:show()	
end
-------------------------------------私有方法模块End----------------------------------------

--WndPetGiftData.lua
--@brief	WndPetGift的数据模块
--@date		2016/11/16
--@author	zhangming
--@note		宠物资质洗脸

WndPetGift = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPetGift:_init()
	self.m_root = nil	 	  			--场景根节点WndPetGift
	self.m_petInfo = {}
	self.loadingId = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPetGift:_unInit()
	self.m_root = nil
	self.loadingId = nil
	self.m_petInfo = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPetGift:createElement()
	local element = WZUISystem:getInstance():createElement("WndPetGift")
	assert(element, "WndPetGift create element failed!")
	self:_init()
	return element
end

--@brief   设置宠物信息
function WndPetGift:setPetInfo(petInfo)
	WZLog("WndPetGift:setPetInfo")
	if petInfo ~= nil then
		self.m_petInfo = petInfo
		WZLog("WndPetGift:setPetInfo:",petInfo.fighting)
	end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

--WndPetFetterData.lua
--@brief	WndPetFetter的数据模块
--@date		2019/01/26
--@author	Tianxiang_Xu
--@note		宠物羁绊窗口

WndPetFetter = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPetFetter:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nFightPetData = nil 			--出战的宠物数据
	self.petAni = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPetFetter:_unInit()
	self.m_root = nil
	self.m_nFightPetData = nil
	self.petAni = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPetFetter:createElement()
	if WndPetFetter.m_root ~= nil then
		WndPetFetter.m_root:removeFromParentAndCleanup(true)
	end
	local element = WZUISystem:getInstance():createElement("WndPetFetter")
	assert(element, "WndPetFetter create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndPetFetter:showInterface(petData)
	-- body
	local wndFetter = WndPetFetter:createElement()
	if wndFetter then 
		self.m_nFightPetData = petData
		WindowManager:addWindow(wndFetter, WndPetFetter, true)
	end
end

function WndPetFetter:setCurPetsInfoData(petData)
	self.m_nFightPetData = petData
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	根据宠物Id获取羁绊数据
function WndPetFetter:_getFetterConfig(petId)
	-- body
	for i, value in pairs(GDatatab_pets_fetters) do
		if value.content == petId or value.content2 == petId then 
			return value 
		end
	end
	
	return nil 
end




-------------------------------------私有方法模块End----------------------------------------

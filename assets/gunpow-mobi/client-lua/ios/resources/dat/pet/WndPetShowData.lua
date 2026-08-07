--WndPetShowData.lua
--@brief	WndPetShow的数据模块
--@date		2015/12/11
--@author	zhangming
--@note		宠物预览界面

WndPetShow = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPetShow:_init()
	self.m_root = nil	 	  			--场景根节点
	self.petId = nil
	self.m_State = 0                    --宠物选择状态，0为紫，1为橙
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPetShow:_unInit()
	self.m_root = nil
	self.petId = nil
	self.m_State = nil                    
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPetShow:createElement()
	local element = WZUISystem:getInstance():createElement("WndPetShow")
	assert(element, "WndPetShow create element failed!")
	self:_init()
	return element
end


function WndPetShow:show(petId)
  WZLog("WndPetShow:show:", petId)
  local element = WndPetShow:createElement()
  WindowManager:addWindow(element, WndPetShow)
  WndPetShow.petId = petId
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

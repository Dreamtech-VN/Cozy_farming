--WndTeachOpenModuleData.lua
--@brief	WndTeachOpenModule的数据模块
--@date		2014/09/11
--@author	莫剑峰
--@note		教学窗口

WndTeachOpenModule = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTeachOpenModule:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_sDetail = ""                 --说明文本
    self.m_bIsImgRight = false
    self.m_sName = ""
    self.m_nStep = -1
    self.m_anim = nil
    self.m_mFingerX = 0
    self.m_bIsReplaceScene = false
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTeachOpenModule:_unInit()
	self.m_root = nil
    self.m_sDetail = ""
    self.m_bIsImgRight = false
    self.m_sName = ""
    self.m_nStep = -1
    self.m_anim = nil
    self.m_mFingerX = 0
    self.m_bIsReplaceScene = false
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTeachOpenModule:createElement()
	local element = WZUISystem:getInstance():createElement("WndTeachOpenModule")
	assert(element, "WndTeachOpenModule create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------

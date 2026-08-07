--WndTeachTalkData.lua
--@brief	WndTeachTalk的数据模块
--@date		2014/09/11
--@author	莫剑峰
--@note		教学窗口

WndTeachTalk = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTeachTalk:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tDetail = ""                 --说明文本
    self.m_bIsImgRight = false
    self.m_sName = ""
    self.m_nStep = -1
    self.m_sIcon = ""
    self.m_bIsReplaceScene = false
    self.m_tOffset = nil
    self.m_bIsInitOk = nil
    self.m_bIsUpgrade = false
    self.m_bIsReplace = false
    self.m_bIsUpgradeTeach = false
    self.m_tHeadList0 = nil
    self.m_tHeadList = nil
    self.m_bIsJump = 0
    self.m_nTrailerButtonId = nil
    self.m_nSound = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTeachTalk:_unInit()
    WZLog("WndTeachTalk:_unInit")
	self.m_root = nil
    self.m_tDetail = ""
    self.m_bIsImgRight = false
    self.m_sName = ""
    self.m_nStep = -1
    self.m_sIcon = ""
    self.m_bIsReplaceScene = false
    self.m_tOffset = nil
    self.m_bIsInitOk = nil
    self.m_bIsUpgrade = false
    self.m_bIsReplace = false
    self.m_bIsUpgradeTeach = false
    self.m_tHeadList0 = nil
    self.m_tHeadList = nil
    self.m_bIsJump = 0
    self.m_nTrailerButtonId = nil
    self.m_nSound = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTeachTalk:createElement()
	local element = WZUISystem:getInstance():createElement("WndTeachTalk")
	assert(element, "WndTeachTalk create element failed!")
	self:_init()
	return element
end


--@brief 设置说明文本
--@param txt:说明文本
function WndTeachTalk:setDetail(txtTable)
    self.m_tDetail = txtTable
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------

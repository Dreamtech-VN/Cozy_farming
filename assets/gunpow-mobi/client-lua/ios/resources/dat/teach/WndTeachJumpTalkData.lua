--WndTeachJumpTalkData.lua
--@brief	WndTeachJumpTalk的数据模块
--@date		2015/08/18
--@author	莫剑峰
--@note		对话跳转窗口

WndTeachJumpTalk = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTeachJumpTalk:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tDetail = ""                 --说明文本
    self.m_bIsImgRight = false
    self.m_sName = ""
    self.m_nStep = -1
    self.m_sIcon = ""
    self.m_bIsReplaceScene = false
    self.m_tOffset = nil
    self.m_tTableBtn = nil
    self.m_tabBattleCtb = nil
    self.m_nTabCtbNumber = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTeachJumpTalk:_unInit()
    WZLog("WndTeachJumpTalk:_unInit")
	self.m_root = nil
    self.m_tDetail = ""
    self.m_bIsImgRight = false
    self.m_sName = ""
    self.m_nStep = -1
    self.m_sIcon = ""
    self.m_bIsReplaceScene = false
    self.m_tOffset = nil
    self.m_tTableBtn = nil
    self.m_tabBattleCtb = nil
    self.m_nTabCtbNumber = 0
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTeachJumpTalk:createElement()
	local element = WZUISystem:getInstance():createElement("WndTeachJumpTalk")
	assert(element, "WndTeachJumpTalk create element failed!")
	self:_init()
	return element
end


--@brief 设置说明文本
--@param txt:说明文本
function WndTeachJumpTalk:setDetail(txtTable)
    self.m_tDetail = txtTable
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------

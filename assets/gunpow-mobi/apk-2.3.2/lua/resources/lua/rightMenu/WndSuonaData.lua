--WndSuonaData.lua
--@brief	WndSuona的数据模块
--@date		2014/01/20
--@author	孙珊珊
--@note		喇叭接口

WndSuona = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSuona:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tColor = 
	{
		"93,222,254",
		"255,227,116",
		"99,255,95",
		"255,89,74",
		"198,130,255",
	} --颜色表
	self.m_tColor_gold = 
	{
		"93,222,254",
		"255,89,74",
		"198,130,255",
	} --金喇叭滚动颜色表

	self.m_txtWorldChat = nil			
	self.m_tempTxt = nil
	self.m_sOriginal = nil
	self.m_conMoveNode = nil
	self.m_sOriginal_suonaMsg = nil	
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSuona:_unInit()
	self.m_root = nil
	self.suonaQuene = nil
	self.m_txtWorldChat = nil
	self.m_tempTxt = nil
	self.m_sOriginal = nil
	self.m_conMoveNode = nil
	self.m_sOriginal_suonaMsg = nil	
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSuona:createElement()
	local element = WZUISystem:getInstance():createElement("WndSuona")
	assert(element, "WndSuona create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

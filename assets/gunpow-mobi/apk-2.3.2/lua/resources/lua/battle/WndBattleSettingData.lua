--WndBattleSettingData.lua
--@brief	WndBattleSetting的数据模块
--@date		2013/1/16
--@author	Zjh
--@note		战斗设置界面

WndBattleSetting = {
	--请不要在这里定义变量
	g_nPointLineStyle = 0,
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBattleSetting:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_initMusicVolume = 0
    self.m_initSoundVolume = 0
    self.m_bLineBtnSel = false
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndBattleSetting:_unInit()
	self.m_root = nil
    self.m_initMusicVolume = nil
    self.m_initSoundVolume = nil
    self.m_bLineBtnSel = false
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBattleSetting:createElement()
	local element = WZUISystem:getInstance():createElement("WndBattleSetting")
	assert(element, "WndBattleSetting create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

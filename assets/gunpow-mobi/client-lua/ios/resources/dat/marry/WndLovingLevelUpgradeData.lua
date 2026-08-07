--WndLovingLevelUpgradeData.lua
--@brief	WndLovingLevelUpgrade的数据模块
--@date		2015/09/01
--@author	qixiang_xie
--@note		恩爱等级升级提示UI

WndLovingLevelUpgrade = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLovingLevelUpgrade:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nPreviousLevel = nil         --先前的恩爱等级
	self.m_nCurLevel = nil               --当前恩爱等级
	self.m_bActionFinish = false
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLovingLevelUpgrade:_unInit()
	self.m_root = nil
	self.m_nPreviousLevel = nil         --先前的恩爱等级
	self.m_nCurLevel = nil               --当前恩爱等级
	self.m_bActionFinish = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndLovingLevelUpgrade:createElement()
    if self.m_root ~= nil then 
        WindowManager:removeWindow(self.m_root,self,true,nil)
    end
	local element = WZUISystem:getInstance():createElement("WndLovingLevelUpgrade")
	assert(element, "WndLovingLevelUpgrade create element failed!")
	self:_init()
	return element
end

--@brief  设置升级信息
function WndLovingLevelUpgrade:setUpgradeInfo(previousLevel,curLevel)
	self.m_nPreviousLevel = previousLevel
	self.m_nCurLevel = curLevel
end

--@brief 显示恩爱等级升级动画
function WndLovingLevelUpgrade:showLovingUpgrade(cuLevel)
	local element = WndLovingLevelUpgrade:createElement()
	self.m_nCurLevel = cuLevel
	self.m_nPreviousLevel = cuLevel - 1
	WindowManager:addWindow(element,WndLovingLevelUpgrade,nil,nil,nil,true)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

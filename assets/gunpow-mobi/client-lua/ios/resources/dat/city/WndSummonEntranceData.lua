--WndSummonEntranceData.lua
--@brief	WndSummonEntrance的数据模块
--@date		2016/12/26
--@author	Tianxiang_Xu
--@note		爬塔和世界BOSS的入口

WndSummonEntrance = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSummonEntrance:_init()
	self.m_root = nil	 	  			--场景根节点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSummonEntrance:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSummonEntrance:createElement()
	local element = WZUISystem:getInstance():createElement("WndSummonEntrance")
	assert(element, "WndSummonEntrance create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
function WndSummonEntrance:showInterface()
    -- body
    if self.m_root then
        WindowManager:removeWindow(self.m_root, self, true)
    end

    local wndChallenge = WndSummonEntrance:createElement()
    if wndChallenge then
        WindowManager:addWindow(wndChallenge, WndSummonEntrance,nil,nil,nil,true)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

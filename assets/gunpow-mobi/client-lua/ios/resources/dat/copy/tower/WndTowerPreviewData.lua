--WndTowerPreviewData.lua
--@brief	WndTowerPreview的数据模块
--@date		2015/04/28
--@author	xiaoyu_wu
--@note		爬塔副本奖励预览窗口

WndTowerPreview = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTowerPreview:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tData = nil                  --数据表，LocalData中获取的所有奖励层列表
    self.m_nLoadCount = 1
    self.m_tbconList = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTowerPreview:_unInit()
	self.m_root = nil
    self.m_tData = nil
    self.m_nLoadCount = nil
    self.m_tbconList = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTowerPreview:createElement()
	local element = WZUISystem:getInstance():createElement("WndTowerPreview")
	assert(element, "WndTowerPreview create element failed!")
	self:_init()
	return element
end

--@brief	显示窗口
--@note		调用此接口显示爬塔副本奖励预览窗口
function WndTowerPreview:showWindow()
    local wndTowerPreview = self:createElement()
   
    WindowManager:addWindow(wndTowerPreview, self, true,nil,nil, true)
end

--@brief 获取根节点
function WndTowerPreview:getRoot()
    return self.m_root
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

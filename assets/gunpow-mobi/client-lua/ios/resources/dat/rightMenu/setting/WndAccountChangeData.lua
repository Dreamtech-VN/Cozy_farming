--WndGameAccountChangeData.lua
--@brief	WndGameAccountChange的数据模块
--@date		2015-11-09
--@author	binshao
--@note		绑定账号

WndAccountChange = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAccountChange:_init()
	self.m_root = nil	 	  			--场景根节点
    self.loadingId = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAccountChange:_unInit()
    WZLog("WndAccountChange:_unInit")
	self.m_root = nil
    self.loadingId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAccountChange:createElement()
	local element = WZUISystem:getInstance():createElement("WndAccountChange")
	assert(element, "WndAccountChange create element failed!")
	self:_init()
	return element
end

function WndAccountChange:_createLoadingBox()
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(20) --超时10分钟
    end
end

function WndAccountChange:_closeLoadingBox()
    MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
    self.loadingId = nil
end
-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------
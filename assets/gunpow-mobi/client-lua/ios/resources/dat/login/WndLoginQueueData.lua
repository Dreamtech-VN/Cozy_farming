--WndLoginQueueData.lua
--@brief	WndLoginQueue的数据模块
--@date		2016-3-16
--@author	binshao
--@note		登录排队

WndLoginQueue = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLoginQueue:_init()
	self.m_root = nil	 	  			--场景根节点
    self.loadingId = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLoginQueue:_unInit()
    WZLog("WndLoginQueue:_unInit")
	self.m_root = nil
    self.loadingId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndLoginQueue:createElement()
	local element = WZUISystem:getInstance():createElement("WndLoginQueue")
	assert(element, "WndLoginQueue create element failed!")
	self:_init()
	return element
end

function WndLoginQueue:createLoadingBox()
    if not self.loadingId then
        self.loadingId = MsgBoxManager:showLoadingBox(20,self,self._closeLoadingBox) --超时10分钟
    end
end

function WndLoginQueue:closeLoadingBox()
    MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
    self.loadingId = nil
end
-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------
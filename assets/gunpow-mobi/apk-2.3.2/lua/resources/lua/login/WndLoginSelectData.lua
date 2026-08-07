--WndLoginSelectData.lua
--@brief	WndLoginSelect的数据模块
--@date		2015-6-12
--@author	binshao
--@note		登陆账号选择

WndLoginSelect = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLoginSelect:_init()
	self.m_root = nil	 	  			--场景根节点
    self.loadingId = nil
    self.registInfo = {}
    self.isSdkLogin = nil
    self.isSdkFlag = nil
    self.oldAccount = nil           -- 记录当前的账号，修改账号时自动清空密码
    self.askTime = 0                -- 询问排队间隔
    self.getServersListFlag = false   -- 获取服务器列表状态
    self.clickTime = 0

    self.sdkIndex = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLoginSelect:_unInit()
	self.m_root = nil
    self.loadingId = nil
    self.registInfo = nil
    self.isSdkLogin = nil
    self.oldAccount = nil
    self.askTime = 0
    self.getServersListFlag = false
    self.clickTime = nil
    self.changeServer = false

    self.sdkIndex = 0
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndLoginSelect:createElement()
	local element = WZUISystem:getInstance():createElement("WndLoginSelect")
	assert(element, "WndLoginSelect create element failed!")
	self:_init()
	return element
end

function WndLoginSelect:_createLoadingBox(time)
    if not self.loadingId then
        local t = time or 20
        self.loadingId = MsgBoxManager:showLoadingBox(time,self,self._closeLoadingBox)
        WZLog("WndLoginSelect--------createloadingID",self.loadingId)
    end
end

function WndLoginSelect:_closeLoadingBox()
    if self.loadingId then 
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
        WZLog("WndLoginSelect--------closeloadingID",self.loadingId)
    end
    self.loadingId = nil
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------
--WndDownloadRewardData.lua
--@brief	WndDownloadReward的数据模块
--@date		2014/08/14
--@author	suyuan
--@note		下载奖励模块

WndDownloadReward = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDownloadReward:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tItemList = nil             --物品列表
    self.callbac = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDownloadReward:_unInit()
	self.m_root = nil
    self.m_tItemList = nil             --物品列表
    self.callbac = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDownloadReward:createElement()
	local element = WZUISystem:getInstance():createElement("WndDownloadReward")
	assert(element, "WndDownloadReward create element failed!")
	self:_init()
	return element
end

--@brief	设置奖励物品列表数据
--@param	tItemName，奖励物品名称列表
--@param	tItemIcon，奖励物品图标路径列表
--@param	tItemNum，奖励物品数量列表
function WndDownloadReward:setItemList(tItemName, tItemIcon, tItemNum)

    self.m_tItemList = {}
    self.m_tItemList.nCount = #tItemNum
    self.m_tItemList.tItemName = tItemName
    self.m_tItemList.tItemIcon = tItemIcon
    self.m_tItemList.tItemNum = tItemNum
    local sJson = json.encode(self.m_tItemList)
    WZLog("WndDownloadReward:setItemList", sJson)
    self:_update()
end

--@brief    设置关闭奖励界面后的回调方法
--@param    tcell，回调表对象
--@param    backFunc，回调方法
function WndDownloadReward:closeCallBack(tcell,backFunc)
    -- body
    if tcell and backFunc then
        self.callbac = {}
        self.callbac[1] = tcell
        self.callbac[2] = backFunc
        WZLog("回调方法",tcell,backFunc,self.callbac[1],self.callbac[2])
    end

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

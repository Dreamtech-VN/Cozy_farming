--WndCoupleHegemonyInviteData.lua
--@brief	WndCoupleHegemonyInvite的数据模块
--@date		2020/05/11
--@author	XTX
--@note		世界组队Boss邀请界面

WndCoupleHegemonyInvite = {
	--请不要在这里定义变量
}

GUILD = 2
FRIEND = 1

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCoupleHegemonyInvite:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tCouple = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCoupleHegemonyInvite:_unInit()
	self.m_root = nil
	self.m_tCouple = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCoupleHegemonyInvite:createElement()
	if WndCoupleHegemonyInvite.m_root ~= nil then
		WindowManager:removeWindow(WndCoupleHegemonyInvite.m_root, WndCoupleHegemonyInvite, true)
	end
	local element = WZUISystem:getInstance():createElement("WndCoupleHegemonyInvite")
	assert(element, "WndCoupleHegemonyInvite create element failed!")
	self:_init()
	return element
end


function WndCoupleHegemonyInvite:receiveFriendListData()
	WZLog("WndCoupleHegemonyInvite:receiveFriendListData")
	self:closeLoading()
	self:updateFriendData()
end

function WndCoupleHegemonyInvite:updateFriendData()
	if self.m_root == nil then
		return
    end

    self.m_tCouple = nil
	local tFriendList = CacheCenter:getFriendDataList()
    for i = 1, #tFriendList do
        if tFriendList[i].name == CacheCenter:getPlayerInfo().mateName then
            self.m_tCouple = tFriendList[i]
        end
    end

	self:updateUI()
end

--@brief    外部接口
function WndCoupleHegemonyInvite:showInterface(tCell,backFun)
	local approval = WndCoupleHegemonyInvite:createElement()
	WindowManager:addWindow( approval , WndCoupleHegemonyInvite)
	if tCell and backFun then
		self.m_tBack = {}
		self.m_tBack[1] = tCell
		self.m_tBack[2] = backFun
	end
 
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

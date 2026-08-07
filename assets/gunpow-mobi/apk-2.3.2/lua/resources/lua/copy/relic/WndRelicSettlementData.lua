--WndRelicSettlementData.lua
--@brief	WndRelicSettlement的数据模块
--@date		2019/07/17
--@author	yrd
--@note		遗迹副本结算

WndRelicSettlement = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRelicSettlement:_init()
	self.m_root = nil	 	  			--场景根节点
	self.needAddExp = nil
	self.leftExp = nil
	self.curLv =  nil
	self.curExp = nil
	self.cellList = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRelicSettlement:_unInit()
	self.m_root = nil
	self.needAddExp = nil
	self.leftExp = nil
	self.curLv =  nil
	self.curExp = nil
	self.cellList = {}
end

	
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRelicSettlement:createElement()
	if WndRelicSettlement.m_root ~= nil then
		WindowManager:removeWindow(WndRelicSettlement.m_root, WndRelicSettlement, true)
	end
	local element = WZUISystem:getInstance():createElement("WndRelicSettlement")
	assert(element, "WndRelicSettlement create element failed!")
	self:_init()
	return element
end

-- 对外接口
--hurtValue	int	总伤害输出
--hurtRank	int	输出排名
--hurtPercent	int	伤害所占百分比
--isWin	boolean	是否赢了
--killerId	long	击杀玩家id
--killerName	String	击杀玩家名称
-- bossId = 1
--@param    nType:2->世界组队Boss; 其他世界Boss
function WndRelicSettlement:showWnd( data )
	local wndRelicSettlement = WndRelicSettlement:createElement()
	WindowManager:addWindow(wndRelicSettlement, WndRelicSettlement, false)

    --local data = {hurtValue = 1502,hurtRank = 5,hurtPercent = 10,isWin = true,killerId = "110",killerName = "OOO",bossId = 1}
    self.m_tData = data
    self.m_tData.playerData = WBattleGlobal:getCurrent().m_tMakePairOk.m_tPlayerInfo
	self:_updateWin()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

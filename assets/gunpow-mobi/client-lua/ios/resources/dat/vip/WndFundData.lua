--WndFundData.lua
--@brief	WndFund的数据模块
--@date		2015/11/02
--@author	zsq
--@note		成长基金

WndFund = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFund:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tData = nil
	self.m_bBuy = false
	self.m_nTotal = 0
    self.loadingId = nil
	self.m_nStartIndex = nil
	self.m_numberOfReceived = nil
	self.m_tCellList = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFund:_unInit()
	self.m_root = nil
	self.m_tData = nil
	self.m_bBuy = nil
	self.m_nTotal = nil
    self.loadingId = nil
	self.m_nStartIndex = nil
	self.m_numberOfReceived = nil
	self.m_tCellList = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFund:createElement()
	local element = WZUISystem:getInstance():createElement("WndFund")
	assert(element, "WndFund create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	获得基金界面数据
function WndFund:setData(buy, levellist, receivelist, totalreceive)
	--是否购买基金
	self.m_bBuy = buy
	--累计获得钻石
	self.m_nTotal = totalreceive
	--计算已领取的次数
	self.m_numberOfReceived = 0

	self.m_tData = {}
	local count = true
	for i=1,#levellist do
		local tempList = {}
		tempList.level = levellist[i]
		tempList.receive = receivelist[i]
		table.insert(self.m_tData,tempList)
	end

	table.sort(self.m_tData , sortLevel)
	for i=1,#self.m_tData do
		if count and self.m_tData[i].receive == 1 then
			self.m_numberOfReceived = self.m_numberOfReceived + 1
		else
			count = false
		end
	end
	self:closeLoadingUI()
	self:update()
end

--@brief	全部标签排序
function sortLevel(a,b)
	if a.level ~= b.level then--是否已装备
		return a.level <= b.level 
	end
end

function WndFund:createLoadingUI()
    if not self.loadingId then self.loadingId = MsgBoxManager:showLoadingBox(20,self,self.closeLoadingUI) end
end

function WndFund:closeLoadingUI()
    if self.loadingId then
        MsgBoxManager:stopLoadingBoxByMsgId(self.loadingId)
        self.loadingId = nil
    end
end
-------------------------------------私有方法模块End----------------------------------------

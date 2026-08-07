--WndShopGivenData.lua
--@brief	WndShopGiven的数据模块
--@date		2016-4-21
--@author	binshao
--@note		物品赠送或索要模块

WndShopGiven = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndShopGiven:_init()
	self.m_root = nil	 	  		--场景根节点
	self.types = 1					-- 2 表示索要，1 表示赠送
	self.data = nil
	self.price = 0
	self.price2 = 0					--price2是越南粉钻的价格
	self.selSex = 2
	self.selFriend = nil			-- 选择的好友
	self.cellData = {}

	-- 动态加载初始化的数据
	self.initCnt = 20           -- 起始加载20个cell
	self.eachCnt = 10           -- 每次拖动加10个cell
	self.maxCnt = 50            -- 最多加载50个cell


	-- 好友列表数据
	self.friendInfo = nil        -- 好友列表信息
	self.friendIndex = 1         -- 好友列表加载cell的index
	self.friendFlag = true       -- 好友列表是否创建
	self.NeedCnt1 = 0            -- 需加载的cell数,默认为initCnt，每次滑动增加eachCnt

	self.loadingId = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndShopGiven:_unInit()
	self.m_root = nil
	self.types = 1
	self.data = nil
	self.price = 0
	self.price2 = 0
	self.selSex = nil
	self.selFriend = nil
	self.cellData = nil

	-- 好友列表数据
	self.friendInfo = nil
	self.friendIndex = 1
	self.friendFlag = true
	self.NeedCnt1 = 0

	self.selSex = 2
	self.loadingId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndShopGiven:createElement()
	local element = WZUISystem:getInstance():createElement("WndShopGiven")
	assert(element, "WndShopGiven create element failed!")
	self:_init()
	return element
end

-- 记录当前好友cell的信息
function WndShopGiven:setCellData(index, cell, tcell)
	if not self.cellData then self.cellData = {} end
	if not self.cellData[index+1] then self.cellData[index+1] = {} end
	self.cellData[index+1] = {index = index+1, cell = cell, tcell = tcell}
end

-- 设置当前好友列表
function WndShopGiven:setFriendData(playerId, playerName, level, sex, faceItemId, headItemId, friendNum,vipLv,headColor)
	self.friendInfo = {}
	WZLog("---------------get friend list-----------",playerId:size())
	for i=0,playerId:size()-1 do
		local friend = {}
		friend.playerId = playerId:get(i)
		friend.name = playerName:get(i)
		friend.level = level:get(i)
		friend.sex = sex:get(i)
		friend.faceId = faceItemId:get(i)
		friend.headId = headItemId:get(i)
		friend.friendPoint = friendNum:get(i)
		friend.vipLv = vipLv:get(i)
		friend.headColor = headColor:get(i)
		table.insert(self.friendInfo,friend)
	end
	self:closeLoading()
	self:initFriendTab()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------

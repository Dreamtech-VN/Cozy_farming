--WndWakeupcoinJumpData.lua
--@brief	WndWakeupcoinJump的数据模块
--@date		2016/03/31
--@author	Tianxiang_Xu
--@note		好友礼物列表

WndWakeupcoinJump = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function WndWakeupcoinJump:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_tGiftList = nil 		--礼物列表
	self.m_nFriendId = nil 		--送礼的好友ID
	self.m_nClickItemTag = nil 	--点击的礼物的tag
	self.m_nFriendliness = nil 	--好友度
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndWakeupcoinJump:_unInit()
	self.m_root = nil
	self.m_tGiftList = nil 		
	self.m_nFriendId = nil 		--送礼的好友ID
	self.m_nClickItemTag = nil 	--点击的礼物的tag
	self.m_nFriendliness = nil 	--好友度
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function WndWakeupcoinJump:createElement()
	local element = WZUISystem:getInstance():createElement("WndWakeupcoinJump")
	assert(element, "WndWakeupcoinJump element create failed!")
	self:_init()
	return element
end

--@brief 	设置可作为礼物数据列表
function WndWakeupcoinJump:setData()
	-- body
	local tGiftList = CacheCenter:getFriendGiftList()
	WZLog("WndWakeupcoinJump:setData", Serialize(tGiftList))
	self.m_tGiftList = tGiftList
	if self.m_tGiftList == nil or #self.m_tGiftList == 0 then
		WZLog("礼物列表为空，物品道具配置表的问题")
		return
	end
	table.sort(self.m_tGiftList, function (a,b) if a.value == b.value then return a.id < b.id else return a.value > b.value end end)
	self:_update()
end

--@brief 	设置好友ID
--@param 	friendID: 好友Id
--@param 	friendliness: 好友度
function WndWakeupcoinJump:setFriendId(friendID, friendliness)
	-- body
	self.m_nFriendId = friendID
	self.m_nFriendliness = friendliness

	self:_updateFriendliness()
end

--@brief 	更新好友度
--@param 	friendliness: 好友度
function WndWakeupcoinJump:resetFriendliness(friendID, friendliness)
	-- body
	if friendID == self.m_nFriendId then
		self.m_nFriendliness = self.m_nFriendliness + friendliness

		self:_updateFriendliness()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

-------------------------------------私有方法模块End----------------------------------------

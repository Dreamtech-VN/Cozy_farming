--WndGiveGoodPlayerData.lua
--@brief	WndGiveGoodPlayer的数据模块
--@date		2020/07/02
--@author	XTX
--@note		点赞玩家界面

WndGiveGoodPlayer = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGiveGoodPlayer:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCircleId = nil 
	self.m_tData = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndGiveGoodPlayer:_unInit()
	self.m_root = nil
	self.m_nCircleId = nil 
	self.m_tData = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGiveGoodPlayer:createElement()
	if WndGiveGoodPlayer.m_root ~= nil then
		WindowManager:removeWindow(WndGiveGoodPlayer.m_root, WndGiveGoodPlayer, true)
	end
	local element = WZUISystem:getInstance():createElement("WndGiveGoodPlayer")
	assert(element, "WndGiveGoodPlayer create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndGiveGoodPlayer:showInterface(cId)
	-- body
	local wndGoodPlayer = WndGiveGoodPlayer:createElement()
	if wndGoodPlayer then 
		self.m_nCircleId = cId
		WindowManager:addWindow(wndGoodPlayer, WndGiveGoodPlayer, false, nil, nil, true)
	end
end

--@brief 	设置数据
function WndGiveGoodPlayer:setData(cId, like, likeName, likeSex, likeVip, likeHeadId, likeFaceId, likeHeadColor, headEffectId, qqHallInfo)
	-- body
	if self.m_root == nil then return end 
	if self.m_nCircleId ~= cId then return end 

	self.m_tData = {}

	for j = 1, #like do
		local tLikeTemp = {}

		tLikeTemp.playerId = like[j]
		tLikeTemp.playerName = likeName[j]
		tLikeTemp.sex = likeSex[j]
		tLikeTemp.vipLevel = likeVip[j]
		tLikeTemp.headId = likeHeadId[j]
		tLikeTemp.faceId = likeFaceId[j]
		tLikeTemp.headColor = likeHeadColor[j]
		tLikeTemp.headEffectId = headEffectId and headEffectId[j] or 0
		if qqHallInfo and qqHallInfo[i] and qqHallInfo[i] ~= "" then 
			tLikeTemp.qqHallData = json.decode(qqHallInfo[i])
		end

		table.insert(self.m_tData, tLikeTemp)
	end

	self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

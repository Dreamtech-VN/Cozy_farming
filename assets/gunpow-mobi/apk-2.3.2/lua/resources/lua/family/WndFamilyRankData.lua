--WndFamilyRankData.lua
--@brief	WndFamilyRank的数据模块
--@date		2017/08/01
--@author	zsq
--@note		家园排行榜

WndFamilyRank = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFamilyRank:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nTag = nil
	self.m_tDataList = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFamilyRank:_unInit()
	self.m_root = nil
	self.m_nTag = nil
	self.m_tDataList = nil
	self.playerRank = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFamilyRank:createElement()
	if WndFamilyRank.m_root ~= nil then
		WindowManager:removeWindow(WndFamilyRank.m_root, WndFamilyRank, true)
	end
	local element = WZUISystem:getInstance():createElement("WndFamilyRank")
	assert(element, "WndFamilyRank create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	外部接口
function WndFamilyRank:showInterface()
	-- body
	local wnd = WndFamilyRank:createElement()
	if wnd then
		WindowManager:addWindow(wnd, WndFamilyRank, nil, nil, nil, true)
	end
end

function WndFamilyRank:setData(playerId, serverId, name, rank, faceId, headColor, headId, sex, level, vipLevel, homeLevel, homeExp, sheerLuxury, playerRank)
	self.m_tDataList = {}
	for i=1,#playerId do
		local temp = {}
		temp.playerId = playerId[i]
		temp.serverId = serverId[i]
		temp.name = name[i]
		temp.rank = rank[i]
		temp.faceId = faceId[i]
		temp.headColor = headColor[i]
		temp.headId = headId[i]
		temp.sex = sex[i]
		temp.level = level[i]
		temp.vipLevel = vipLevel[i]
		temp.homeLevel = homeLevel[i]
		temp.homeExp = homeExp[i]
		temp.sheerLuxury = sheerLuxury[i]
		table.insert(self.m_tDataList, temp)
	end
	self.playerRank = playerRank
	WZLog("WndFamilyRank:setData",playerRank,Serialize(self.m_tDataList))

	self:_update()
end

--排行奖励
function WndFamilyRank:onReward(element) 
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WndCompeteGift:showWnd(2)
end

--说明
function WndFamilyRank:onRuleClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndSingleMapDesc:showInterface(LocalStrings.FAMILYRANK_DESC)
end
-------------------------------------私有方法模块End----------------------------------------

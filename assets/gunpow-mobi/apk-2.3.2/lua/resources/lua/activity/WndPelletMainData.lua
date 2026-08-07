--WndPelletMainData.lua
--@brief	WndPelletMain的数据模块
--@date		2021/08/31
--@author	hyx
--@note		弹珠活动主界面

WndPelletMain = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPelletMain:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_sImgSpring = nil
	self.m_sProgressLaunch = nil
	self.m_sLaunchTimeSchedule = nil
	self.m_sCoinTimeSchedule = nil
	self.m_tPelletBall = {}
	self.m_nPelletIndex = 1 --投珠的个数
	self.m_bIsCoinTurn = {} --是否发射中，否则不给投币
	self.m_nPushProgress = 100 --下压进度条
	self.m_nPushHeight = 0 --下压高度
	self.m_tPelletMoveToY = {} --珠子下移位置
	self.m_tIsLaunchPellet = {} --是否已经离开发射台的珠子
	self.m_nPlayerCoin = 0 --游戏币数量
	self.m_nNoLuanchNum = 0 --珠子未发射的数量
	self.m_tBigSpecialRewards = nil
	self.m_tBigRewardData = {}
	self.m_bIsCoinIng = nil --是否投币中
	self.m_bIsLuanchSpeed = nil --防止发射过快
	self.m_bIsCreatePellet = nil --是否创建珠子中
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPelletMain:_unInit()
	self.m_root = nil
	self.m_sImgSpring = nil
	self.m_sProgressLaunch = nil
	self.m_sLaunchTimeSchedule = nil
	self.m_sCoinTimeSchedule = nil
	self.m_tPelletBall = {}
	self.m_nPelletIndex = 1
	self.m_bIsCoinTurn = {}
	self.m_nPushProgress = 100
	self.m_nPushHeight = 0
	self.m_tPelletMoveToY = {}
	self.m_tIsLaunchPellet = {}
	self.m_nPlayerCoin = 0
	self.m_nNoLuanchNum = 0
	self.m_tBigSpecialRewards = nil
	self.m_tBigRewardData = {}
	self.m_bIsCoinIng = nil
	self.m_bIsLuanchSpeed = nil
	self.m_bIsCreatePellet = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPelletMain:createElement()
	if WndPelletMain.m_root ~= nil then
		WindowManager:removeWindow(WndPelletMain.m_root, WndPelletMain, true)
	end
	local element = WZUISystem:getInstance():createElement("WndPelletMain")
	assert(element, "WndPelletMain create element failed!")
	self:_init()
	return element
end


--[[
--如果为0则代表没有进行碰撞  1为碰撞后向左 2则向右
参数解释
index: 第一个碰撞点
data: 【1】 1向左 2向右 3直接进洞
	  【2】 [1]1向左 2向右  [2]第几个点 [3]走的左边还是右边（第1排）
	  【3】 0、3直接进洞 1向左 2向右 --第二排处理(也就是2->的起点)
	  【4】 [1]1向左 2向右  进到第三排的时候位于左还是右 [2]第几个点 [3]走的左边还是右边
	  【5】 1向左 2向右 进口是否与柱子碰撞  可以为nil
	  【6】 第三排到终点 没有【5】产生碰撞的情况->[1]方向 [2]柱子左边还是右边 [3]第几个洞
	  	  没有与柱子产生碰撞的时候[1]方向(3排的) [2]走的左边还是右边 [3]终点第几个洞 [4]--如果存在碰撞，终点位置可能存在变化,但也是左右区分
]]
function WndPelletMain:setBallTraval(node, index, data, func)
	local array = CCArray:create()
	array:addObject(CCMoveTo:create(0.2,ccp(722,309)))

	local pos_top = 377 --顶部
	local pos_bottom = 25 --底部
	--出发点
	local line_pos1 = 638 --拐弯进入直线的第一个点
	local pointArray = CCPointArray:create(20)
	pointArray:addControlPoint(ccp(719,360))
	pointArray:addControlPoint(ccp(693,377))
	pointArray:addControlPoint(ccp(line_pos1, pos_top))
	array:addObject(CCCatmullRomTo:create(0.2, pointArray))
	
	--第一排位置 
	if data[1][1] == 1 or data[1][1] == 2 then
		local mid_x = {{157,210},{293,290},{378,408},{508,528}}
		local end_x = {{83,120},{194,230},{337,370},{467,500}}
		local pointArray1 = CCPointArray:create(20)
		pointArray1:addControlPoint(ccp(line_pos1,pos_top))
		pointArray1:addControlPoint(ccp(mid_x[index][data[1][1]],363))
		pointArray1:addControlPoint(ccp(end_x[index][data[1][1]],342))
		-- local time1 = {1.15,0.8,0.7,0.4}
		local time1 = {0.5,0.3,0.2,0.15}
		array:addObject(CCCatmullRomTo:create(time1[index], pointArray1))
	end
	--第一到第二排时候
	if data[2] and next(data[2]) ~= nil then
		local start2_x = {154,270,406,436,536}
		local mid2_x = {170,270,405,436,536}
		local end2_x = {{152,165},{255,275},{401,415},{531,548}}
		local temp_index = index
		local temp_index1 = index
		if data[2][2] then
			temp_index = data[2][2]
			if data[2][3] then
				temp_index1 = data[2][3]
			end
		end
		array:addObject(self:setBezierRoad(ccp(start2_x[temp_index1],352), ccp(mid2_x[temp_index1],308), ccp(end2_x[temp_index][data[2][1]],266)))
	end
	--第二排的处理
	if data[3] and next(data[3]) ~= nil then
		if data[3][1] == 0 then --直接进洞情况(经过第二排)
			array:addObject(self:setBezierRoad(ccp(103,278), ccp(59,247), ccp(59,pos_bottom)))
		elseif data[3][1] == 3 then --从第一排直接进洞情况
			if index == 4 then
				array:addObject(self:setBezierRoad(ccp(588,269), ccp(593,211), ccp(573,pos_bottom)))
			else
				array:addObject(self:setBezierRoad(ccp(70,364), ccp(56,302), ccp(59,pos_bottom)))
			end
		elseif data[3][1] == 1 or data[3][1] == 2 then --第二排到第三排的时候
			local start3_x = {{116,215},{236,345},{352,482},{502,582}}
			local mid3_x = {{102,210},{212,345},{352,482},{485,592}}
			local end3_x = {{93,113},{200,220},{340,360},{473,493}}
			local dir = data[3][1]
			local index1 = index
			local index2 = index
			if data[4] then --第三排左右的情况
				dir = data[4][1] or 1
				if data[4][2] then
					index1 = data[4][2] or 1
					if data[4][3] then
						index2 = data[4][3]
					end
				end
			end
			array:addObject(self:setBezierRoad(ccp(start3_x[index2][data[3][1]],282), ccp(mid3_x[index2][data[3][1]],237), ccp(end3_x[index1][dir],186)))
		end
	end
	if data[5] and next(data[5]) ~= nil then --柱子的碰撞
		local start_x = {153,153,153}
		local mid_x = {157,157,157}
		local end_x = {{163,190},{163,190},{163,190}}
		local pos_start = ccp(start_x[index],197)
		local pos_mid = ccp(mid_x[index],151)
		local pos_end =  ccp(end_x[index][data[5][1]],105)
		if not data[3] then --特殊情况，第二排直接到柱子
			local temp_pos_x = {0,320,320}
			local temp_pos_y = {0,270,270}
			local temp_mid_x = {0,313,313}
			local temp_mid_y = {0,170,170}
			local temp_end_x = {0,311,311}
			local temp_end_y = {0,105,105}
			pos_start = ccp(temp_pos_x[index],temp_pos_y[index])
			pos_mid = ccp(temp_mid_x[index],temp_mid_y[index])
			pos_end =  ccp(temp_end_x[index],temp_end_y[index])
		end
		array:addObject(self:setBezierRoad(pos_start, pos_mid, pos_end))
	end
	--第三排到终点
	if data[6] and next(data[6]) ~= nil then
		local pos = data[6][1] --方向
		local pos1 = data[6][2] --终点洞的左边还是右边
		local pos2 = data[6][3] --终点第几个洞
		local pos3 = data[6][4]--如果存在碰撞，终点位置可能存在变化
    	local start3_x1, mid3_x1
    	local start_y,mid_y = 200,138
    	if data[5] and next(data[5]) ~= nil then
    		start3_x1 = {{163,190},{214,284},{314,394}}
    		mid3_x1 = {{142,227},{213,273},{294,404}}
    		start_y = 115
    		mid_y = 111
    	else
    		start3_x1 = {{67,152},{160,262},{314,394},{444,534}}
    		mid3_x1 = {{57,147},{145,270},{294,404},{424,534}}
    	end
    	local end3_x1 = {{59,143},{238,273},{403,410},{543,573}}
	    array:addObject(self:setBezierRoad(ccp(start3_x1[pos][pos1], start_y), ccp(mid3_x1[pos][pos1], mid_y), ccp(end3_x1[pos2][pos3], pos_bottom)))
	end

	array:addObject(CCScaleTo:create(0.2,0))
	array:addObject(CCCallFunc:create(function()
		node:setVisible(false)
		node:stopAllActions()
		if func then
			func()
		end
    end))

    local seq = CCSequence:create(array)
    local array1 = CCArray:create()
    array1:addObject(CCRotateBy:create(5,360))
    array1:addObject(seq)
    local spawn = CCSpawn:create(array1)
    node:setVisible(true)
    node:setScale(0.7)
    node:runAction(spawn)
end
function WndPelletMain:setBezierRoad(pos1, pos2, endPos)
	local configInfo = ccBezierConfig()
    configInfo.controlPoint_1 = pos1
    configInfo.controlPoint_2 = pos2
    configInfo.endPosition = endPos
    return CCBezierTo:create(0.55, configInfo)
end
--珠子的线路图
--index 进入哪一个点
function WndPelletMain:setRoadPath(node, index, func)
	if not node or node:isVisible() == false then 
		return 
	end
	local reward_pos = {
		{{1,1,1,1,1,1,2,2,2,2,2,3},{ {{2},{1},{0}}, {{1},nil,{3}}, {{2},{1},{1},{1},nil,{1,1,1,1}}, {{2},{1},{1},{2},nil,{1,2,1,2}}, 
									 {{2},{1},{1},{2},{1},{1,1,1,2}}, {{2},{2},{2},{1,2},nil,{1,2,1,2}}, {{1},{1,1,1},{1},{1,1,1},nil,{1,1,1,1}}, 
									 {{1},{1,1,1},{1},{2,1,1},nil,{1,2,1,2}}, {{1},{2,1,1},{2},{1,2,1},nil,{2,1,1,2}}, {{2},{1,2,2},{1},{1,2,2},{1},{1,1,1,2}}, 
									 {{2},{1,2,2},{1},{1,2,2},nil,{1,2,1,2}}, {{1},{1,2,2},{1},{1,2,2},nil,{2,1,1,2}}}},
		{{1,1,2,2,2,2,3,3,3,3,3,4},{ {{2},{1},{1},{2},{2},{2,1,2,1}}, {{2},{2},{2},{2,2},nil,{2,2,2,2}}, {{1},{2,1,1},{2},{2,2,1},nil,{2,2,2,2}},
									 {{2},{1,2,2},{1},{2,2,2},nil,{2,2,2,2}}, {{2},{2,2,2},nil,nil,{2},{2,2,2,2}}, {{2},{2,2,2},{2},{1,3,2},nil,{3,1,2,2}},
									 {{1},{1,2,2},{1},{2,2,2},nil,{2,2,2,2}}, {{1},{2,2,2},nil,nil,{2},{2,2,2,2}}, {{1},{2,2,2},{2},{1,3,2},nil,{3,1,2,2}},
									 {{2},{1,3,3},{1},{1,3,3},nil,{3,1,2,2}}, {{2},{1,3,3},nil,nil,{2},{3,1,2,2}}, {{1},{1,3,4},{1},{1,3,3},nil,{3,1,2,2}}}},
		{{2,3,3,3,4,4,4},{ {{2},{2,2,2},{2},{2,3,2},nil,{3,2,3,1}}, {{1},{2,2,2},{2},{2,3,2},nil,{3,2,3,2}}, {{2},{1,3,3},{1},{2,3,3},nil,{3,2,3,1}},
						   {{2},{2,3,3},{2},{1,4,3},nil,{4,1,3,2}}, {{1},{1,3,4},{1},{2,3,3},nil,{3,2,3,1}}, {{1},{2,3,4},{2},{1,4,3},nil,{4,1,3,2}},
						   {{2},{2,4,5},{1},{1,4,4},nil,{4,1,3,2}}}},
		{{3,4,4,4},{ {{2},{2,3,3},{2},{2,4,3},nil,{4,2,4,1}}, {{1},{2,3,4},{2},{2,4,3},nil,{4,2,4,1}}, {{2},{1,4,5},{1},{2,4},nil,{4,2,4,1}},
					 {{2},{2,4,5},{3}}}}
	}
	if index == ""  or not index then
		index = 1
	end
	local random = math.random(1, #reward_pos[index][1])
	self:setBallTraval(node,reward_pos[index][1][random],reward_pos[index][2][random], func)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

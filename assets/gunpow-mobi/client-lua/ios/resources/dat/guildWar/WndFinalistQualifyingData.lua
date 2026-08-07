--WndFinalistQualifyingData.lua
--@brief	WndFinalistQualifying的数据模块
--@date		2017/02/25
--@author	qixiang
--@note		出线赛与入围赛的排名

WndFinalistQualifying = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndFinalistQualifying:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_type = nil                     -- 1出线赛    2入围赛                
	self.m_tRankInfo1 = nil              --出线赛本服排名
	self.m_tRankInfo2 = nil              --出线赛成员排名

	self.m_tRankInfo3 = nil              --入围赛全服排名
	self.m_tRankInfo4 = nil              --入围赛成员排名
	self.m_nCurType = 1                --当前显示类型1(全服)(本服)  2成员
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndFinalistQualifying:_unInit()
	self.m_root = nil
	self.m_type = nil
	self.m_nCurType = nil
	self.m_tRankInfo1 = nil              --出线赛全服排名
	self.m_tRankInfo2 = nil              --出线赛本服排名

	self.m_tRankInfo3 = nil              --入围赛全服排名
	self.m_tRankInfo4 = nil              --入围赛本服排名
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndFinalistQualifying:createElement()
	local element = WZUISystem:getInstance():createElement("WndFinalistQualifying")
	assert(element, "WndFinalistQualifying create element failed!")
	self:_init()
	return element
end

--matchType 1:出线赛 2:入围赛
function WndFinalistQualifying:show(matchType)
	WZLog("WndFinalistQualifying:show =",matchType)
	if matchType and matchType < 3 then
		local element = self:createElement()
		self.m_type = matchType
		WindowManager:addWindow(element,WndFinalistQualifying,false,false,false,true)
	end
end

--设置出线赛的本服排名
-- gid : 公会Id
-- level : 等级
-- name : 名字
-- sorce : 分数
-- fightNum : 战斗次数
-- winNum : 胜利次数
-- nameorsid : 出线赛为该公会会长名称，入围赛为该公会服务器Id
function WndFinalistQualifying:setData1(gid,level,name,sorce,fightNum,winNum,nameorsid)
	-- body
	WZLog("WndFinalistQualifying:setData1 =",self.m_root)
	if self.m_root == nil then return end
	local temp2 = {}
	for i,v in ipairs(gid) do
		local temp = {}
		temp.gid = gid[i]
		temp.level = level[i]
		temp.name = name[i]
		temp.sorce = sorce[i]
		temp.fightNum = fightNum[i]
		temp.winNum = winNum[i]
		temp.nameorsid = nameorsid[i]
		table.insert(temp2,temp)
	end

	self.m_tRankInfo1 = temp2
	self:show1()
end

--设置出线赛的成员排名
function WndFinalistQualifying:setData2(pid,level,name,sorce,fightNum,winNum)
	-- body
	WZLog("WndFinalistQualifying:setData2")
	if self.m_root == nil then return end
	local temp2 = {}
	for i,v in ipairs(pid) do
		local temp = {}
		temp.pid = pid[i]
		temp.level = level[i]
		temp.name = name[i]
		temp.sorce = sorce[i]
		temp.fightNum = fightNum[i]
		temp.winNum = winNum[i]
		table.insert(temp2,temp)
	end

	table.sort(temp2,function (a,b)
		if a.sorce > b.sorce then
			return true
		end
		return false
	end)
	self.m_tRankInfo2 = temp2
	self:show2()
end

--设置入围赛的全服排名
-- gid : 公会Id
-- level : 等级
-- name : 名字
-- sorce : 分数
-- fightNum : 战斗次数
-- winNum : 胜利次数
-- nameorsid : 出线赛为该公会会长名称，入围赛为该公会服务器Id
function WndFinalistQualifying:setData3(gid,level,name,sorce,fightNum,winNum,nameorsid)
	-- body
	WZLog("WndFinalistQualifying:setData3")
	if self.m_root == nil then return end
	local temp2 = {}
	for i,v in ipairs(gid) do
		local temp = {}
		temp.gid = gid[i]
		temp.level = level[i]
		temp.name = name[i]
		temp.sorce = sorce[i]
		temp.fightNum = fightNum[i]
		temp.winNum = winNum[i]
		temp.nameorsid = nameorsid[i]
		table.insert(temp2,temp)
	end

	self.m_tRankInfo3 = temp2
	self:show3()
end


--设置入围赛的成员排名
function WndFinalistQualifying:setData4(pid,level,name,sorce,fightNum,winNum)
	-- body
	WZLog("WndFinalistQualifying:setData4")
	if self.m_root == nil then return end
	local temp2 = {}
	for i,v in ipairs(pid) do
		local temp = {}
		temp.pid = pid[i]
		temp.level = level[i]
		temp.name = name[i]
		temp.sorce = sorce[i]
		temp.fightNum = fightNum[i]
		temp.winNum = winNum[i]
		table.insert(temp2,temp)
	end

	table.sort(temp2,function (a,b)
		if a.sorce > b.sorce then
			return true
		end
		return false
	end)
	self.m_tRankInfo4 = temp2
	self:show4()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

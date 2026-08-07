--WndPastureBusinessData.lua
--@brief	WndPastureBusiness的数据模块
--@date		2021/04/17
--@author	hyx
--@note		牧场交易行

WndPastureBusiness = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPastureBusiness:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tBtnChangeTitle = {}
	self.m_nCurIndex = nil
	self.m_tPastureLevelExp = {}
	self.m_isOpenView = {} --判断是否打开过的
	self.m_bCollectTime = false
	self.m_nTimeNumber = 0
	self.m_nWorkerNumber = 0
	self.m_nCoinNumber = 0
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPastureBusiness:_unInit()
	self.m_root = nil
	self.m_tBtnChangeTitle = {}
	self.m_nCurIndex = nil
	self.m_tPastureLevelExp = {}
	self.m_isOpenView = {}
	self.m_bCollectTime = false
	self.m_nTimeNumber = 0
	self.m_nWorkerNumber = 0
	self.m_nCoinNumber = 0
end

--牧场经验
function WndPastureBusiness:setPastureLevelExp()
	if GDatatab_pastureland then
		for i,v in pairs(GDatatab_pastureland) do
			local tab = {}
			tab.level = v.level
			tab.exp = v.exp
			tab.num = v.num
			tab.workeraddition = v.workeraddition
			tab.workerprice = v.workerprice
			tab.keepduration = v.keepduration
			tab.guai_id = v.AniFileId
			self.m_tPastureLevelExp[v.level] = tab
		end
		table.sort( self.m_tPastureLevelExp, function(a,b) 
			return a.level < b.level
		end)
	end
end
function WndPastureBusiness:getPastureLevelExp(lev,_bool)
	if _bool == true then
		return self.m_tPastureLevelExp or nil
	else
		return self.m_tPastureLevelExp[lev]
	end
end
--现有的坐骑数量
function WndPastureBusiness:getAnimalCurrentNum(  )
	return self.m_nMountNum
end

--获取到牧场的坐骑最高等级
function WndPastureBusiness:getCurPastureMountMaxLevel()
	if self.m_isOpenView[1] and self.m_isOpenView[1].getCurPastureMountMaxLevel then
		return self.m_isOpenView[1]:getCurPastureMountMaxLevel()
	end
end
function WndPastureBusiness:getPastureLevel()
	if self.m_isOpenView[1] and self.m_isOpenView[1].getPastureLevel then
		return self.m_isOpenView[1]:getPastureLevel()
	end
	return 0
end
function WndPastureBusiness:getBasePastureInfo()
	if self.m_isOpenView[1] and self.m_isOpenView[1].getBasePastureInfo then
		return self.m_isOpenView[1]:getBasePastureInfo()
	end
end
function WndPastureBusiness:getHasMountNum()
	if self.m_isOpenView[1] and self.m_isOpenView[1].getHasMountNum then
		return self.m_isOpenView[1]:getHasMountNum()
	end
end
function WndPastureBusiness:setWorkerNumber(num)
	self.m_nWorkerNumber = num
end
function WndPastureBusiness:getWorkerNumber()
	return self.m_nWorkerNumber or 0
end
function WndPastureBusiness:setCoinNumber(num)
	self.m_nCoinNumber = num
end
function WndPastureBusiness:getCoinNumber()
	return self.m_nCoinNumber or 0
end
--判断收集的时候是否触发到工坊的收集时间
function WndPastureBusiness:setCollectTime(bTime, timeNum)
	self.m_bCollectTime = bTime
	self.m_nTimeNumber = timeNum or 0
end
function WndPastureBusiness:getCollectTime()
	return self.m_bCollectTime, self.m_nTimeNumber
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPastureBusiness:createElement()
	if WndPastureBusiness.m_root ~= nil then
		WindowManager:removeWindow(WndPastureBusiness.m_root, WndPastureBusiness, true)
	end
	local element = WZUISystem:getInstance():createElement("WndPastureBusiness")
	assert(element, "WndPastureBusiness create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

--WndLeftMenuData.lua
--@brief	WndLeftMenu的数据模块
--@date		2013/12/10
--@author	xiaoyu_wu
--@note		左菜单模块

WndLeftMenu = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndLeftMenu:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tBtnsInfo = nil              --按钮信息
	self.m_tBtnWelInfo = nil 			--福利按钮信息
	self.m_bIsOpenAward = false 		--奖励按钮是否开放
	self.m_bIsOpenVip = false 			--Vip按钮是否开放
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndLeftMenu:_unInit()
	self.m_root = nil
    self.m_tBtnsInfo = nil
	self.m_tBtnWelInfo = nil 
	self.m_bIsOpenAward = nil 		
	self.m_bIsOpenVip = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndLeftMenu:createElement()
	local element = WZUISystem:getInstance():createElement("WndLeftMenu")
	assert(element, "WndLeftMenu create element failed!")
	self:_init()
	return element
end

--@brief	设置左菜单按钮信息
--@param	tBtnsInfo，按钮信息表
function WndLeftMenu:setBtnsInfo(tBtnsInfo,tBtnWelInfo)
    if tBtnsInfo == nil or tBtnWelInfo == nil then 
		WZLog("tBtnsInfo == nil or tBtnWelInfo == nil")
		return 
	end
	self.m_tBtnsInfo = {}
	self.m_tBtnWelInfo = {}

	local num = 0 
	for i,v in ipairs(tBtnWelInfo) do 
		if self:_checkIconButtonOpen(v) and v.IsHighlight == true then 
			num = num +1
		end
	end
	WZLog("WndLeftMenu:setBtnsInfo  ",num)
	
	for i,data in ipairs(tBtnsInfo) do
		local temp = {}
		temp.buttonId = data.buttonId
		temp.buttonType = data.buttonType
		temp.IsHighlight = data.IsHighlight
		temp.buttonSort = data.buttonSort
		temp.buttonStatus1Level = data.buttonStatus1Level
		temp.buttonStatus2Level = data.buttonStatus2Level
		temp.buttonStatus3Level = data.buttonStatus3Level
		if temp.buttonId == ISLAND_LEFT_AWARD then 
			temp.buttonSort = 1
		elseif temp.buttonId == ISLAND_LEFT_WELFARE then
			temp.buttonSort = 2 
			if num >0 then 
				temp.IsHighlight = true
			end
		elseif temp.buttonId == ISLAND_RIGHT_VIP then
			temp.buttonSort = 3 
		end
		table.insert(self.m_tBtnsInfo,temp)
	end
	
	
	self.m_tBtnWelInfo = tBtnWelInfo
    self:_update()
	
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置左菜单按钮信息的默认值
function WndLeftMenu:_setDefaultBtnsInfo()
    self.m_tBtnsInfo = {}
    --local tBtnStatusLevel = {5,2,6}
    --local tBtnStatusLevel = {5,2,6}
    local tBtnStatusLevel = {1,1,1}
    for i=ISLAND_LEFT_RANKING,ISLAND_LEFT_LOTTERY do
        local tBtnInfo = {}
        tBtnInfo.buttonId = i
        tBtnInfo.buttonType = ISLAND_BTNTYPE_LEFT
        tBtnInfo.buttonSort = 0
        tBtnInfo.IsHighlight = false
        tBtnInfo.buttonStatus1Level = tBtnStatusLevel[i-ISLAND_LEFT_RANKING+1]
        tBtnInfo.buttonStatus2Level = 0
        tBtnInfo.buttonStatus3Level = tBtnStatusLevel[i-ISLAND_LEFT_RANKING+1]
        table.insert(self.m_tBtnsInfo, tBtnInfo)
    end
end

--@brief	对按钮按照排序值排序
function WndLeftMenu:_sortButton()
    if self.m_tBtnsInfo[1].buttonSort == nil then
        return
    end
    local sortFunc = function(a, b)
        return a.buttonSort < b.buttonSort
    end
    table.sort(self.m_tBtnsInfo, sortFunc)
end


-------------------------------------私有方法模块End----------------------------------------

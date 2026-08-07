--WndRightMenuData.lua
--@brief	WndRightMenu的数据模块
--@date		2013/12/10
--@author	xiaoyu_wu
--@note		右菜单模块

WndRightMenu = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndRightMenu:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_tBtnsInfo = nil              --按钮信息
	self.m_tActivitiesMenu = nil 		--活动按钮信息
	self.m_tBtnMoreMenu = nil 			--更多按钮信息
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndRightMenu:_unInit()
	self.m_root = nil
    self.m_tBtnsInfo = nil
	self.m_tActivitiesMenu = nil 
	self.m_tBtnMoreMenu = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndRightMenu:createElement()
	local element = WZUISystem:getInstance():createElement("WndRightMenu")
	assert(element, "WndRightMenu create element failed!")
	self:_init()
	return element
end

--@brief	设置右菜单按钮信息
--@param	tBtnsInfo，按钮信息表
function WndRightMenu:setBtnsInfo(tBtnsInfo,tBtnMenu)
	if tBtnsInfo == nil or tBtnMenu == nil then 
		return  
	end
    self.m_tBtnsInfo = {}
	self.m_tActivitiesMenu = {}
	self.m_tBtnMoreMenu = {}
	local num = 0 
	for i,v in ipairs(tBtnMenu) do 
		if self:_checkIconButtonOpen(v) and v.IsHighlight == true then 
			num = num +1
		end
	end
	
	for i,data in ipairs(tBtnsInfo) do 
			local temp = {}
			temp.buttonId = data.buttonId
			temp.buttonType = data.buttonType
			temp.IsHighlight = data.IsHighlight
			temp.buttonSort = data.buttonSort
			temp.buttonStatus1Level = data.buttonStatus1Level
			temp.buttonStatus2Level = data.buttonStatus2Level
			temp.buttonStatus3Level = data.buttonStatus3Level
			if temp.buttonId == 40 then   --合成
				temp.buttonSort = 3		--插入数据，排序
				table.insert(self.m_tBtnsInfo,temp)
			elseif temp.buttonId == 44 then --更多
				temp.buttonSort = 4 
				table.insert(self.m_tBtnsInfo,temp)
			elseif temp.buttonId == 22 then  --任务
				temp.buttonSort = 1
				table.insert(self.m_tBtnsInfo,temp)
			elseif temp.buttonId == 46 then  --活动
				temp.buttonSort = 2
				if num >0 then 
					temp.IsHighlight = true
				end
				table.insert(self.m_tBtnsInfo,temp)
			else
				table.insert(self.m_tBtnMoreMenu,temp)
			end
	end
	self.m_tActivitiesMenu = tBtnMenu
    self:_update()
end



-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	设置右菜单按钮信息的默认值
function WndRightMenu:_setDefaultBtnsInfo()
    self.m_tBtnsInfo = {}
    local tBtnSort = {1,2,3,7,8,9,10,11,12,13,14,4,5,6}
    --local tBtnStatusLevel = {2,6,6,14,7,35,2,2,3,2,2,20,20,15}
    local tBtnStatusLevel = {1,1,1,1,1,1,1,1,1,1,1,1,1,1}
    for i=ISLAND_RIGHT_REWARD,ISLAND_RIGHT_EXCHANGE do
        local tBtnInfo = {}
        tBtnInfo.buttonId = i
        tBtnInfo.buttonType = ISLAND_BTNTYPE_RIGHT
        tBtnInfo.buttonSort = tBtnSort[i-ISLAND_RIGHT_REWARD+1]
        tBtnInfo.IsHighlight = false
        tBtnInfo.buttonStatus1Level = tBtnStatusLevel[i-ISLAND_RIGHT_REWARD+1]
        tBtnInfo.buttonStatus2Level = 0
        tBtnInfo.buttonStatus3Level = tBtnStatusLevel[i-ISLAND_RIGHT_REWARD+1]
        table.insert(self.m_tBtnsInfo, tBtnInfo)
    end
end

--@brief	对按钮按照排序值排序
function WndRightMenu:_sortButton()
    if self.m_tBtnsInfo[1].buttonSort == nil then
        return
    end
    local sortFunc = function(a, b)
		return a.buttonSort < b.buttonSort
    end
    table.sort(self.m_tBtnsInfo, sortFunc)
end


-------------------------------------私有方法模块End----------------------------------------

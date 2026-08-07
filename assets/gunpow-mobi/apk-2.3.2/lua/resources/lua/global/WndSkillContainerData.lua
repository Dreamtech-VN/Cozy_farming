--WndSkillContainerData.lua
--@brief	WndSkillContainer的数据模块
--@date		2017/05/15
--@author	 
--@note		技能容器

WndSkillContainer = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSkillContainer:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nCheckIndex = 1              --1(道具) 2(武器) 3(修炼)
	self.m_tCellDressSuit = nil 
	self.m_tDressSuit = nil 
	self.skillInterfacePanel = {}
	self.m_nLastTouchIndex = nil --记录上一次的点击
	self.m_tTopElement = nil 
	self.m_sSkillMode = nil 	--技能道具模式
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSkillContainer:_unInit()
	self.m_root = nil
	self.m_nCheckIndex = nil
	self.m_tCellDressSuit = nil 
	self.m_tDressSuit = nil 
	self.skillInterfacePanel = {}
	self.m_nLastTouchIndex = nil
	self.m_tTopElement = nil 
	self.m_sSkillMode = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSkillContainer:createElement()
	if WndSkillContainer.m_root ~= nil then
		WindowManager:removeWindow(WndSkillContainer.m_root, WndSkillContainer, true)
	end
	local element = WZUISystem:getInstance():createElement("WndSkillContainer")
	assert(element, "WndSkillContainer create element failed!")
	self:_init()
	return element
end

--显示技能 1(道具) 2(武器洗练) 3(修炼)
function WndSkillContainer:showById(id)
	WZLog("WndSkillContainer:showById =",id)
	--技能没红点，道具有红点，打开道具页
	if id == 1 and (not CacheCenter:getSkillRed()) and CacheCenter:getRedState("btnItem") then 
		id = 2
	end

	local isFinish5, finishStep5 = TeachGroup1:isTeachFinish(5)
    if isFinish5 ~= true and finishStep5 <= 5 and CacheCenter:getPlayerInfo().level <= 4 then
    	id = 1
    end

	if not self:_bShow(id) then
		return
	end

	local element = self:createElement()
	self.m_nCheckIndex = id
	WindowManager:addWindow(element, WndSkillContainer, false,nil,nil,true)
end

function WndSkillContainer:_bShow(id)
	WZLog("WndSkillContainer:_bShow",id)
	local playerInfo = CacheCenter:getPlayerInfo() 
	if id == 1 then
		--local btnInfo = GDatatab_button_info["id_25"]
		--if playerInfo.level < btnInfo.open_level then
		--	MsgBoxManager:showTipBox(btnInfo.feedback_info)
		--	return false
		--end
	elseif id == 2 then
		local btnInfo = GDatatab_button_info["id_25"]
		if playerInfo.level < btnInfo.open_level then
			MsgBoxManager:showTipBox(btnInfo.feedback_info)
			return false
		end
	elseif id == 3 then
		local btnInfo = GDatatab_button_info["id_72"]
		if playerInfo.level < btnInfo.open_level then
			MsgBoxManager:showTipBox(btnInfo.feedback_info)
			return false
		end
	elseif id == 4 then 
		local btnInfo = GDatatab_button_info["id_72"]
		if playerInfo.level < btnInfo.open_level then
			MsgBoxManager:showTipBox(btnInfo.feedback_info)
			return false
		end
	elseif id == 5 then 
		if not CheckButtonOpen(ISLAND_ASSISTSKILL) then 
			return false 
		end
	end
	return true
end

--@brief 	设置保存的套装数据
function WndSkillContainer:setDressSuitData(id, suitName, bIsUsed)
	-- body
	if self.m_root == nil then return end 

	self.m_tDressSuit = {}

	for i = 1, #id do
		local tItem = {}

		tItem.id = id[i]
		tItem.name = suitName[i]
		tItem.bIsUsed = bIsUsed[i] 

		table.insert(self.m_tDressSuit, tItem)
	end

	local function getUseValue(a)
		-- body
		if a.bIsUsed == true then
			return 0
		else
			return 1
		end
	end

	table.sort(self.m_tDressSuit, function (a, b)
		-- body
		return a.id < b.id
	end)

	WZLog("WndSkillContainer:setDressSuitData", Serialize(self.m_tDressSuit))
end

--@brief 	新增套装
function WndSkillContainer:addNewDressSuit(id, name)
	-- body
	if self.m_tDressSuit == nil then
		self.m_tDressSuit = {}
	end

	local tItem = {}

	tItem.id = id
	tItem.name = name
	tItem.bIsUsed = false

	table.insert(self.m_tDressSuit, tItem)
end

--@brief    更新多套时装数据
function WndSkillContainer:updateDressSuitData(nType)
    -- body
    if self.m_tCellDressSuit == nil then return end 
    if nType == 1 then
        self.m_tCellDressSuit:changeDressSuitOK()
    else
        self.m_tCellDressSuit:setSuitData(self.m_tDressSuit)
    end
end

--@brief 	套装改名
function WndSkillContainer:dressSuitRename(id, newName)
	-- body
	if self.m_tDressSuit == nil then return end 
	for i = 1, #self.m_tDressSuit do
		if self.m_tDressSuit[i].id == id then
			self.m_tDressSuit[i].name = newName

			break 
		end
	end
end

--@brief 	设置技能编辑模式
function WndSkillContainer:setSkillMode(mode)
	-- body
	if self.m_root == nil then return end 

	self.m_sSkillMode = mode
end

--@brief 	获取技能编辑模式
function WndSkillContainer:getSkillMode()
	-- body
	return self.m_sSkillMode
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

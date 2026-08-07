--WndMasterBoxActivityData.lua
--@brief	WndMasterBoxActivity的数据模块
--@date		2021/08/17
--@author	hyx
--@note		师门宝箱活跃度

WndMasterBoxActivity = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMasterBoxActivity:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tBoxActivityData = {}
	self.m_nActivityNum = 0
	self.m_nBoxType = 1
	self.m_nStatus = -1
	self.m_nCurIndex = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMasterBoxActivity:_unInit()
	self.m_root = nil
	self.m_tBoxActivityData = {}
	self.m_nActivityNum = 0
	self.m_nBoxType = 1
	self.m_nStatus = -1
	self.m_nCurIndex = nil
end

function WndMasterBoxActivity:setData(progress, _type, status)
	self.m_nActivityNum = progress
	self.m_nBoxType = _type
	self.m_nStatus = status
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMasterBoxActivity:createElement()
	if WndMasterBoxActivity.m_root ~= nil then
		WindowManager:removeWindow(WndMasterBoxActivity.m_root, WndMasterBoxActivity, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMasterBoxActivity")
	assert(element, "WndMasterBoxActivity create element failed!")
	self:_init()
	return element
end
--进度条奖励
function WndMasterBoxActivity:setProgress(_type, is_master)
	local data = {}
	is_master = is_master or nil
	for i,v in pairs(GDatatab_bag_reward) do
		if v.bag_type == _type then
			local tab = {}
			tab.id = v.id
			tab.demand = v.demand
			tab.reward = {}
			if is_master == true then
				tab.reward = v.master_reward
			else
				tab.reward = v.disciple_reward
			end
			table.insert(data, tab)
		end
	end
	table.sort( data, function(a,b) return a.id < b.id end)
	return data
end
--任务
function WndMasterBoxActivity:setShowTaskData(_type)
	local data = {}
	for i,v in pairs(GDatatab_bag_task) do
		if v.bag_type == _type then
			table.insert(data, v)
		end
	end
	table.sort( data, function(a,b) return a.id < b.id end)
	return data
end

--======= 活跃任务 ========
BoxActivityTaskItem = {}
function BoxActivityTaskItem:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tTaskData = nil
end
function BoxActivityTaskItem:_unInit()
	self.m_root = nil
	self.m_tTaskData = nil
end
--@brief	创建控件
function BoxActivityTaskItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(400,25))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function BoxActivityTaskItem:setTaskData(data)
	self.m_tTaskData = data
end
--@brief 	开始加载
function BoxActivityTaskItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("conTaskActivityItem")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:setData()	
end
function BoxActivityTaskItem:setData()
	if not self.m_tTaskData then return end

	GetElement(self.m_root,"txtTaskDesc",WZUILabelTTF):setText(self.m_tTaskData.desc)
	GetElement(self.m_root,"txtTaskNum",WZUILabelTTF):setText(self.m_tTaskData.reward)
end

--@return	新建的表实例对象
function BoxActivityTaskItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

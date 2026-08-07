--WndGmData.lua
--@brief	WndGm的数据模块
--@date		2021/01/15
--@author	hyx
--@note		GM界面

WndGm = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndGm:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tGmData = {}
	self.m_tButtonGmData = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndGm:_unInit()
	self.m_root = nil
	self.m_tGmData = {}
	self.m_tButtonGmData = {}
end

function WndGm:setGmData(data)
	if next(data) ~= nil then
		for i,v in ipairs(data.input) do
			local tab = {}
			tab.title = v[1]
			tab.msg = v[2]
			self.m_tGmData[i] = tab		
		end
		self:setGmView()
		for i,v in ipairs(data.button) do
			table.insert(self.m_tButtonGmData, v)
		end
		self:setButtonGmView()
	end
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndGm:createElement()
	if WndGm.m_root ~= nil then
		WindowManager:removeWindow(WndGm.m_root, WndGm, true)
	end
	local element = WZUISystem:getInstance():createElement("WndGm")
	assert(element, "WndGm create element failed!")
	self:_init()
	return element
end



CellGMItem = {}
function CellGMItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellGMItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function CellGMItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(300,60))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end

function CellGMItem:setCellGMMessage(data,func)
	self.m_sGMData = data
	self.m_sItemFunc = func
end

--@brief 	开始加载
function CellGMItem:onLoadData(element)
	local celElement = WZUISystem:getInstance():createElement("cellGMList")
	celElement:setVisible(true)
	element:addChild(celElement)

	self:upCellGMItem()
end

function CellGMItem:upCellGMItem()
	if not self.m_sGMData then return end

	local iten_edit = GetElement(self.m_root,"iten_edit",WZUIContainer)
	local iten_btn = GetElement(self.m_root,"iten_btn",WZUIButton)
	if string.find(self.m_sGMData.msg,"不需要输入") == nil then
		iten_btn:setVisible(false)
	else
		iten_edit:setVisible(false)
	end

	GetElement(self.m_root,"key_name",WZUILabelTTF):setText(self.m_sGMData.title)
	GetElement(self.m_root,"key_msg",WZUILabelTTF):setText(self.m_sGMData.msg)
end

function CellGMItem:onEditReceivEndCellGm()
	local gm_edit = GetElement(self.m_root,"editGm_CellGm",WZUIEditBox)
	local text = gm_edit:getText()

	if self.m_sItemFunc then
		self.m_sItemFunc(self.m_sGMData.title,text)
	end
end

function CellGMItem:onbtnClickItemGM()
	if self.m_sGMData then
		ProtocolProcessorWndTask:send_PLAYER_Trainer(tostring(self.m_sGMData.title))
	end
end

--@return	新建的表实例对象
function CellGMItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

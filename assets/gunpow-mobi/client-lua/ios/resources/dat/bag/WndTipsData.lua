--WndTipsData.lua
--@brief	WndTips的数据模块
--@date		2015/07/13
--@author	zsq
--@note		点击弹出的Tips窗口

WndTips = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndTips:_init()
	--self.m_root = nil	 	  			--场景根节点
	self.m_tGrid = nil
	self.xmlName = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndTips:_unInit()
	self.m_root = nil
	self.m_bIsVisible = nil
	self.m_tData = nil
	self.m_nType = nil
	self.m_tHighLightObj = nil
	self.m_tCallBack = nil 
	self.xmlName = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndTips:createElement()
    if self.m_root ~= nil then
        WindowManager:removeWindow(self.m_root,WndTips)
    end

	local xmlNameList = {"WndTips1","WndTips2","WndTips3","WndTips4","WndTips5","WndTips6",
			"WndTips4","WndTips8","WndTips7","WndTips9","WndTips10","WndTips11",
			"WndTips23","WndTips12","WndTips13","WndTips14","WndTips15","WndTips16",
			"WndTips17","WndTips18","WndTips19","WndTips20","WndTips21","WndTips22",
			"WndTips24","WndTips25","WndTips26","WndTips27","WndTips28","WndTips29",
			"WndTips30","WndTips32","WndTips33","WndTips34","WndTips35","WndTips36",
			"WndTips37","WndTips38","WndTips39","WndTips40","WndTips5","WndTips28",
			"WndTips43","WndTips44","WndTips10","WndTips6","WndTips47","WndTips48",
			"WndTips48","WndTips49","WndTips50","WndTips5","WndTips48","WndTips51",
			"WndTips48","WndTips13","WndTips56","WndTips56","WndTips56","WndTips56"}
	local xmlName = xmlNameList[self.m_nType]

	if xmlName == nil then xmlName = "WndTips" end

	local element = WZUISystem:getInstance():createElement(xmlName)
	assert(element, xmlName .. " create element failed!")
	self:_init()
	element:setLuaObjectIndex(self)
	self.m_root = element
	self.xmlName = xmlName
	return element
end

--@brief 	按钮回调
function WndTips:setCallBackFunc(tCell, func)
	-- body
	self.m_tCallBack = {}

	self.m_tCallBack[1] = tCell
	self.m_tCallBack[2] = func
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------



-------------------------------------私有方法模块End----------------------------------------

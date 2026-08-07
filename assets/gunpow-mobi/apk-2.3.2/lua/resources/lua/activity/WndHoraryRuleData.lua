--WndHoraryRuleData.lua
--@brief	WndHoraryRule的数据模块
--@date		2021/07/21
--@author	hyx
--@note		占卜卦象规则

WndHoraryRule = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndHoraryRule:_init()
	self.m_root = nil	 	  			--场景根节点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndHoraryRule:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndHoraryRule:createElement()
	if WndHoraryRule.m_root ~= nil then
		WindowManager:removeWindow(WndHoraryRule.m_root, WndHoraryRule, true)
	end
	local element = WZUISystem:getInstance():createElement("WndHoraryRule")
	assert(element, "WndHoraryRule create element failed!")
	self:_init()
	return element
end


HoraryRuleItem = {}
function HoraryRuleItem:_init()
	self.m_root = nil	 	  			--场景根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function HoraryRuleItem:_unInit()
	self.m_root = nil
end

--@brief	创建控件
function HoraryRuleItem:createElement()
	local tNewObj = self:_new()
	local element = WZUIContainer:create()
	element:setUseAbsSize(true)
	element:setAbsContentSize(GlobalMethod:CCSize(350,50))
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	self:_init()
	return element,tNewObj
end
function HoraryRuleItem:setRuleData(index)
	self.m_nCurIndex = index
end
function HoraryRuleItem:onLoadData(element)
	local str_name = ""
	local str = LocalStrings.ACTIVITY_TEXT86[self.m_nCurIndex]
	if str then
		local _str = SplitStringWithSeparator(str,",")
		for i=1,#_str do
			str_name = str_name .. _str[i]
		end
	end
	local txt1 = createLabel(str_name,ccp(0.5,0.5),ccp(0.5,0.5),20,ccc3(127,70,26))
	self.m_root:addChild(txt1)
	local txt2 = createLabel(LocalStrings.ACTIVITY_TEXT92[self.m_nCurIndex][1],ccp(0.15,0.5),ccp(0.5,0.5),20,ccc3(127,70,26))
	self.m_root:addChild(txt2)
	local txt3 = createLabel(LocalStrings.ACTIVITY_TEXT92[self.m_nCurIndex][2],ccp(0.85,0.5),ccp(0.5,0.5),20,ccc3(229,105,22))
	self.m_root:addChild(txt3)

	local con = WZUIContainer:create()
	con:setUseAbsSize(true)
	con:setAbsContentSize(GlobalMethod:CCSize(350,3))
	con:setRelativePosition(ccp(0.5, 0))
	self.m_root:addChild(con)
	local img9 = WZUI9Image:create()
	img9:setFile("ui/common/frame_fengexian_01.png")
	con:addChild(img9)

	if ProjConfig.LANGUAGE == "vn" then
		txt1:setFontSize(12)
		txt2:setFontSize(12)
		txt3:setFontSize(12)
	end
end
--@return	新建的表实例对象
function HoraryRuleItem:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

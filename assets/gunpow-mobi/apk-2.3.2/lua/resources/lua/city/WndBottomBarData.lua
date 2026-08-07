--WndBottomBarData.lua
--@brief	WndBottomBar的数据模块
--@date		2015/2/11
--@author	莫剑峰
--@note		底部条UI
WndBottomBar = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndBottomBar:_init()
    WZLog("WndBottomBar:_init")
	self.m_root = nil	 	  			--场景根节点
    self.m_nMoveDirection = 1
    self.m_bIsMoveHorizontalBar = false
    self.m_bIsMoveVerticalBar = false
    self.m_bIsNeedMoveVerticalBar = false
    self.m_tScene = nil
    self.m_nBtnCount = 0
    self.m_sName = "WndBottomBar"
    self.m_bHavePos = nil
    self.m_bState = false
    self.m_bRed = false
    self.m_bIsMatching = false 
end


--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function WndBottomBar:_unInit()
    self.m_root = nil
    self.m_nMoveDirection = 1
    self.m_bIsMoveHorizontalBar = false
    self.m_bIsMoveVerticalBar = false
    self.m_bIsNeedMoveVerticalBar = false
    self.m_tScene = nil
    self.m_nBtnCount = 0
    self.m_bHavePos = nil
    self.m_bState = false
    self.m_bRed = false
    self.m_bIsMatching = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndBottomBar:createElement()
    --[[
	local element = WZUISystem:getInstance():createElement("WndBottomBar")
	assert(element, "WndBottomBar create element failed!")
	self:_init()
	return element
    --]]
    local tNewObj = self:_new()
    assert(tNewObj, "CellCardItem table create failed!")
    tNewObj:_init()
    local element = WZUISystem:getInstance():createElement("WndBottomBar")
    assert(element, "CellCardItem element create failed!")
    element:setLuaObjectIndex(tNewObj)
    tNewObj.m_root = element

    GlobalGame.g_tWndBottomBarObj = tNewObj
    GlobalGame.g_tWndBottomBarObj.type = 1
    self.type = 1
    return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------
function WndBottomBar:_setDefaultBtnsInfo()

    local tBtnsInfo = GlobalGame:getBtnInfoByGroupType(4)
    table.sort(tBtnsInfo,function(a,b) return a.buttonSort2>b.buttonSort2 end) 

    self.m_tBtnsInfo = tBtnsInfo

    -- local tBtnsInfoExtend = GlobalGame:getBtnInfoByType(ISLAND_BTNTYPE_EXTEND)

    -- local btnListExtend = {}

    -- for i,v in ipairs(tBtnsInfoExtend) do
    --     btnListExtend[v.buttonSort] = v
    -- end
    -- self.m_tBtnsInfoExtend = btnListExtend
--    WZLog("WndBottomBar:_setDefaultBtnsInfo", Serialize(tBtnsInfo), Serialize(tBtnsInfoExtend))

end

--@brief    是否正在匹配
function WndBottomBar:setMatchState(bMatching)
    -- body
    self.m_bIsMatching = bMatching
end
-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WndBottomBar:_new( )
    local tNewObj = {}
    setmetatable(tNewObj, self)
    self.__index = self
    return tNewObj
end
-------------------------------------私有方法模块End----------------------------------------

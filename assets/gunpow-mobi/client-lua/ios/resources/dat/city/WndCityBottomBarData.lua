--WndCityBottomBarData.lua
--@brief	WndCityBottomBar的数据模块
--@date		2015/2/11
--@author	莫剑峰
--@note		底部条UI
WndCityBottomBar = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndCityBottomBar:_init()
    WZLog("WndCityBottomBar:_init")
	self.m_root = nil	 	  			--场景根节点
    self.m_nMoveDirection = 1
    self.m_bIsMoveHorizontalBar = false
    self.m_bIsMoveVerticalBar = false
    self.m_bIsNeedMoveVerticalBar = false
    self.m_tScene = nil
    self.m_nBtnCount = 0
    self.m_sName = "WndCityBottomBar"
    self.m_bHavePos = nil
    self.m_bState = false
    self.m_nTime = 0
    self.m_nTaskShowIndex = 0
    self.m_bRed = false
    self.m_sRes = "ui/city/beta/main_icon_di09_2.png"
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndCityBottomBar:_unInit()
	self.m_root = nil
    self.m_nMoveDirection = 1
    self.m_bIsMoveHorizontalBar = false
    self.m_bIsMoveVerticalBar = false
    self.m_bIsNeedMoveVerticalBar = false
    self.m_tScene = nil
    self.m_nBtnCount = 0
    self.m_bHavePos = nil
    self.m_bState = false
    self.m_nTime = 0
    self.m_nTaskShowIndex = 0
    self.m_bRed = false
    self.m_sRes = "ui/city/beta/main_icon_di09_2.png"
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndCityBottomBar:createElement()

    local tNewObj = self:_new()
    assert(tNewObj, "CellCardItem table create failed!")
    tNewObj:_init()
    local element = WZUISystem:getInstance():createElement("WndCityBottomBar")
    assert(element, "CellCardItem element create failed!")
    element:setLuaObjectIndex(tNewObj)
    tNewObj.m_root = element

    GlobalGame.g_tWndBottomBarObj = tNewObj
    GlobalGame.g_tWndBottomBarObj.type = 2
    self.type = 2
    return element,tNewObj
end

-------------------------------------公有方法模块End----------------------------------------
function WndCityBottomBar:_setDefaultBtnsInfo()

    local tBtnsInfo = GlobalGame:getBtnInfoByGroupType(1)
    table.sort(tBtnsInfo,function(a,b) return a.buttonSort2>b.buttonSort2 end) 
    self.m_tBtnsInfo = tBtnsInfo

    local tBtnsInfoExtend = GlobalGame:getBtnInfoByGroupType(2)
    self.m_tBtnsInfoExtend = tBtnsInfoExtend
    
    local tBtnsInfo = GlobalGame:getBtnInfoByType(ISLAND_BTNTYPE_LEFT)
    local btnList2 = {}
    for i,v in ipairs(tBtnsInfo) do
        if v.buttonSort ~= -1 then
            btnList2[v.buttonSort] = v
        else
            btnList2[i] = v
        end
    end

    self.m_tLeftBtnsInfo = btnList2

    WZLog("WndCityBottomBar:_setDefaultBtnsInfo", Serialize(self.m_tBtnsInfo), Serialize(self.m_tBtnsInfoExtend), Serialize(self.m_tLeftBtnsInfo))

end

-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function WndCityBottomBar:_new( )
    local tNewObj = {}
    setmetatable(tNewObj, self)
    self.__index = self
    return tNewObj
end
-------------------------------------私有方法模块End----------------------------------------

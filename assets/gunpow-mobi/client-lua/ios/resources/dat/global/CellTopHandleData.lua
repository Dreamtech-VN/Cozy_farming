--CellTopHandleData.lua
--@brief	CellTopHandle的数据模块
--@date		2015-12-15
--@author	binshao
--@note		顶部菜单栏

CellTopHandle = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellTopHandle:_init()
	self.m_root = nil  			--Cell的根节点
    self.data = nil          --数据表
    self.bottomCell = nil
    self.bottomTcell = nil
    self.goldCellInfo = nil
    self.m_bIsMatching = false 
end

--@brief    反初始化表的成员变量
--@note     在退出场景时回调的onExit函数里面必须调用本函数
function CellTopHandle:_unInit()
    self.m_root = nil
    self.data = nil
    self.bottomCell = nil
    self.bottomTcell = nil
    self.goldCellInfo = nil
    self.m_bIsMatching = nil 
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellTopHandle:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellTopHandle table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellTopHandle")
	assert(element, "CellTopHandle element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

-- top信息
-- parentNode 需要add的父节点的（一般为根节点）
-- imgPath 当前的主题文字图片路径
-- luaObj 当前的类名
-- cbFunc 返回回调函数
-- coinFlag 是否显示货币快捷键
-- bottomBarFlag 是否显示下拉菜单，默认不显示
-- chatFlag 是否显示聊天按键,默认不显示
-- redPointStr 红点事件，传当前类的字符串
-- tOther 其它信息
function CellTopHandle:setTopData(imgPath,luaObj,cbFunc,coinFlag,bottomBarFlag,chatFlag,redPointObj,tOther)
    local data = {}
    data.imgPath = imgPath
    data.luaObj = luaObj
    data.cbFunc = cbFunc
    data.coinFlag = coinFlag
    data.bottomBarFlag = bottomBarFlag
    data.chatFlag = chatFlag
    data.redPointObj = redPointObj
	data.tOther = tOther
    WZLog("--------------made-------------------",redPointObj)
    self.data = data
    self:_update()
end

-- 设置屏蔽点击参数
function CellTopHandle:setShieldClick(bFlag)
    WZLog("--------------state---------------",bFlag)
    self.shieldClick = bFlag
    if self.goldCellInfo and self.goldCellInfo.tcell then
        self.goldCellInfo.tcell:setShieldClick(bFlag)
    end
    if GlobalGame.g_tWndBottomBarObj then
        GlobalGame.g_tWndBottomBarObj:setState(bFlag)
    end
end

function CellTopHandle:getShieldClick()
    return self.shieldClick
end

--@brief    是否正在匹配
function CellTopHandle:setMatchState(bMatching)
    -- body
    self.m_bIsMatching = bMatching
    if self.goldCellInfo and self.goldCellInfo.tcell then
        self.goldCellInfo.tcell:setMatchState(bMatching)
    end
    if GlobalGame.g_tWndBottomBarObj then
        GlobalGame.g_tWndBottomBarObj:setMatchState(bMatching)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellTopHandle:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end
-------------------------------------私有方法模块End----------------------------------------

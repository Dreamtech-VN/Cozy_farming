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

    self.m_curTaskData = nil            --存放任务数据
    self.m_bIsGettingReward = false     --是否正在领奖
    self.m_nLoadingId = nil
    self.m_tCallBack = {}               --回主城前调用
    self.m_bIsDoSendEvent = nil         --是否是执行每分钟发一个pulse事件的
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

    self.m_curTaskData = nil
    self.m_bIsGettingReward = nil
    self.m_nLoadingId = nil
    self.m_tCallBack = nil
    self.shieldClick = nil 
    self.m_bIsDoSendEvent = nil         --是否是执行每分钟发一个pulse
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

    table.insert(g_tCellTopHandleObj,tNewObj)
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
-- bShowhouse 是否显示跳转主城的房子按钮 默认空为显示 false不显示
-- bShowTask 是否显示任务按钮 默认空为显示 false不显示
function CellTopHandle:setTopData(imgPath,luaObj,cbFunc,coinFlag,bottomBarFlag,chatFlag,redPointObj,tOther,bShowhouse,bShowTask)
    local data = {}
    data.imgPath = imgPath
    data.luaObj = luaObj
    data.cbFunc = cbFunc
    data.coinFlag = coinFlag
    data.bottomBarFlag = bottomBarFlag
    data.chatFlag = chatFlag
    data.redPointObj = redPointObj
    data.tOther = tOther
    data.bShowhouse = bShowhouse
    data.bShowTask = bShowTask
    WZLog("--------------made-------------------",redPointObj)
    self.data = data
    self:_update()
    self:setTopType()
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

--@brief    重新设置回调方法
function CellTopHandle:setCallBackFunc(luaObj,cbFunc)
    -- body
    self.data.luaObj = luaObj
    self.data.cbFunc = cbFunc
end

--@brief    设置跳转主城前调用的方法
function CellTopHandle:setJumpCityBefore(luaObj,cbFunc)
    self.m_tCallBack = {}
    self.m_tCallBack[1] = luaObj
    self.m_tCallBack[2] = cbFunc
end

--@brief    重新设置显示内容
function CellTopHandle:resetData(imgPath, luaObj, cbFunc, coinFlag, bottomBarFlag, chatFlag, redPointObj, tOther, bShowhouse, bShowTask)
    -- body
    self.data.imgPath = imgPath
    self.data.luaObj = luaObj
    self.data.cbFunc = cbFunc
    self.data.coinFlag = coinFlag
    self.data.bottomBarFlag = bottomBarFlag
    self.data.chatFlag = chatFlag
    self.data.redPointObj = redPointObj
    self.data.tOther = tOther
    self.data.bShowhouse = bShowhouse
    self.data.bShowTask = bShowTask

    self:_initUI()
    self:_addGold()
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

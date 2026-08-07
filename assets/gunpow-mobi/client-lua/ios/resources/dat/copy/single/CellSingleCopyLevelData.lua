--CellSingleCopyLevelData.lua
--@brief	CellSingleCopyLevel的数据模块
--@date		2015/04/10
--@author	xiaoyu_wu
--@note		单人副本关卡项

CellSingleCopyLevel = {
	-- 请在这里定义和初始化全局成员变量
    STATE_PASSED = 0, --已通关
    STATE_UNDERWAY = 1, --正挑战
    STATE_LEVELUNREACHED = 2, --等级不足
    STATE_LOCKED = 3, --还未解锁
    STATE_UNPASSEDCOMMON = 4 , --还没过精英副本所对应的普通副本章节
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellSingleCopyLevel:_init()
	self.m_root = nil  			--Cell的根节点
    
    self.m_nState = CellSingleCopyLevel.STATE_LOCKED --状态
    self.m_nTag = 0             --标记
    self.m_tData = nil          --数据表
    self.m_fClickCallback = nil --点击后的回调 
    self.m_tCallback = nil
    self.m_bShowArm = true
    self.m_nTaskCellId = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellSingleCopyLevel:_unInit()
	self.m_root = nil
    
    self.m_nState = CellSingleCopyLevel.STATE_LOCKED
    self.m_nTag = 0
    self.m_tData = nil
    self.m_fClickCallback = nil
    self.m_tCallback = nil
    self.m_bShowArm = nil
    self.m_nTaskCellId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellSingleCopyLevel:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellSingleCopyLevel table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellSingleCopyLevel")
	assert(element, "CellSingleCopyLevel element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief	设置状态
--@param    nState,状态
function CellSingleCopyLevel:setState(nState)
    self.m_nState = nState
    self:_updateForState(nState)
end

--@brief	获取状态
--@return   #1,状态
function CellSingleCopyLevel:getState()
    return self.m_nState
end

--@brief	设置标记
--@param    nTag,标记
function CellSingleCopyLevel:setTag(nTag)
    self.m_nTag = nTag
    self.m_root:setTag(nTag)
end

--@brief	获取标记
--@return   #1,标记
function CellSingleCopyLevel:getTag()
    return self.m_nTag
end

--@brief	设置数据
--@param    tData,数据表
--@note     请先调用本方法设置数据后再调用setCellElement方法加进tableContainer
function CellSingleCopyLevel:setData(tData)
    self.m_tData = tData
end

--@brief	获取数据表
--@return   #1,数据表
function CellSingleCopyLevel:getData()
    return self.m_tData
end

--@brief	设置点击回调方法
--@param    fCallback,回调方法
function CellSingleCopyLevel:setClickCallback(tCallback,fCallback)
    self.m_fClickCallback = fCallback
    self.m_tCallback = tCallback
end

function CellSingleCopyLevel:setArmStats(status)
    self.m_bShowArm = status
end

--@brief  设置任务跳转的cellId
function CellSingleCopyLevel:setTaskCellId(taskId)
     self.m_nTaskCellId = taskId
end

--@brief  创建指示箭头动画
function CellSingleCopyLevel:createArromAction()
    WZLog("CellSingleCopyLevel:createArromAction")
    local image = WZUIImage:create()
    image:setFile("ui/common/common_icon_jiantou.png")
    image:setScale(0.7)
    image:setUseOriginSize(true)
    image:setTouchEnable(false)
    local actionJump = WZUIActionJumpTo:create()
    actionJump:setPosition(GlobalMethod:ccp(0.5,0.5))
    actionJump:setHeight(10)
    actionJump:setJumps(100000)
    actionJump:setDuration(100000)
    image:runUIAction(actionJump)
    image:setTag(12568)
    image:setZOrder(10000)
    return image
end

--@brief  添加箭头指引动画
--@param  sectionCellId ：单人副本章节ID
function CellSingleCopyLevel:addArromAction(sectionCellId)
    WZLog("CellSingleCopyLevel:addArromAction")
    local arromAction = self.m_root:getChildByTag(12568)
    if arromAction then
        arromAction:setVisible(true)
    else
        arromAction = self:createArromAction()
        sectionCellId = sectionCellId + 1
        local cellInfo = GDatatab_single_map["id_" .. sectionCellId]
        if cellInfo == nil then
            arromAction:setRelativePositionLuaTo(0.49981,0.908159)
        else
            arromAction:setRelativePositionLuaTo(0.49981,0.658159)
        end
        self.m_root:addChild(arromAction)
    end
end

--@brief  设置箭头动画是否显示
function CellSingleCopyLevel:setArromActionVisibleStatus(visStatus)
    local arromAction = self.m_root:getChildByTag(12568)
    if arromAction then
        arromAction:setVisible(visStatus)
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellSingleCopyLevel:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------

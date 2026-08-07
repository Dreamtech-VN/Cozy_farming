--CellBattleDialogData.lua
--@brief	CellBattleDialog的数据模块
--@date		2014/09/17
--@author	莫剑峰
--@note		对话框

CellBattleDialog = {
	-- 请在这里定义和初始化全局成员变量
	-- DIMG = "ui/common/common_scale9_di70.png",
	-- AIMGL = "ui/common/common_icon_dhj2.png",
 --    AIMGD = "ui/common/common_icon_dhj.png",

 	DIMG = "ui/chat/talk_13.png",
	AIMGL = "ui/chat/talk_25.png",
    AIMGD = "ui/chat/talk_25.png",

	--Dir
	DIR_UP = 1,
	DIR_DOWN = 2,
	DIR_LEFT = 3,
	DIR_RIGHT = 4,
	DIR_CENTER = 5, --蘑菇云
	--Order
	ZORDER = 1000,	--对话框默认Order
	--Scale
	CENTER_SCALE = 0.83,
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellBattleDialog:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nOffsetX = 0
	self.m_nOffsetY = 0
	self.m_nShowTime = nil
	self.m_nMaxWidth = nil
	self.m_nMaxHeight = nil
	self.m_sText = nil
	self.m_nDir = nil
	self.m_tSender = nil
	self.m_tBackSender = nil
	self.m_tBackFunction = nil
	self.m_tParent = nil
	self.m_bJump = nil
	self.m_nScale = nil
	self.m_tTxtColor = nil
    self.m_bIsUpdatePos = nil
    self.m_tFollowObj = nil
    self.m_tOriginalPos = nil
    self.m_tFollowObjOriginalPos = nil
    self.m_bIsNeedClick = nil
    self.m_bIsScaleAction = nil
    self.m_bIsTalkMode = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellBattleDialog:_unInit()
	self.m_root = nil
	self.m_nOffsetX = 0
	self.m_nOffsetY = 0
	self.m_nShowTime = nil
	self.m_nMaxWidth = nil
	self.m_nMaxHeight = nil
	self.m_sText = nil
	self.m_nDir = nil
	self.m_tSender = nil
	self.m_tBackSender = nil
	self.m_tBackFunction = nil
	self.m_tParent = nil
	self.m_bJump = nil
	self.m_nScale = 1
	self.m_tTxtColor = nil
    self.m_bIsUpdatePos = nil
    self.m_tFollowObj = nil
    self.m_tOriginalPos = nil
    self.m_tFollowObjOriginalPos = nil
    self.m_bIsNeedClick = nil
    self.m_bIsScaleAction = nil
    self.m_bIsTalkMode = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建对话框
--@param	sText,文字内容,默认为空串
--@param	dir,对话框方向，默认右边
--@param	nShowTime,显示时间，默认2s.(-1表示永久显示/不自动销毁。若要手动移除请调用removeDialog)
--@param	tBackSender:回调的LuaTable(不需要回调不填)
--@param	tBackFunction:LuaTable中回调函数(不需要回调不填)
--@param	nOffsetX,X位置，默认为0
--@param	nOffsetY,Y位置，默认为0
--@param	nMaxWidth,显示最大宽度，默认对话框背景宽度
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		Order为默认值CellBattleDialog.ZORDER
function CellBattleDialog:createDialog(sText,dir,nShowTime,tBackSender,tBackFunction,nOffsetX,nOffsetY,nMaxWidth)
	local tNewObj = self:_new()
	assert(tNewObj, "CellBattleDialog table create failed!")
	tNewObj:_init()
	local element = WZUIContainer:create()
	assert(element, "CellBattleDialog element create failed!")
	element:setTouchEnable(false)
	tNewObj.m_sText = sText or ""
	tNewObj.m_nOffsetX = nOffsetX or tNewObj.m_nOffsetX
	tNewObj.m_nOffsetY = nOffsetY or tNewObj.m_nOffsetY
	tNewObj.m_nShowTime = nShowTime or 2
	tNewObj.m_nMaxWidth = nMaxWidth
	tNewObj.m_nDir = dir or CellBattleDialog.DIR_RIGHT
	tNewObj.m_tBackSender = tBackSender

	element:setLuaObjectIndex(tNewObj)

	element:setZOrder(CellBattleDialog.ZORDER)

	return element,tNewObj
end

--@brief	增加一个对话框
--@param	tSender,对话框相对于哪个控件上显示，不能为空（不能为根节点）
--@param	tParent,对话框addChild到哪个控件上，若为nil则直接使用tSender的父节点
--@param	sText,文字内容,默认为空串
--@param	dir,对话框方向，默认右边
--@param	nShowTime,显示时间，默认2s.(-1表示永久显示/不自动销毁。若要手动移除请调用removeDialog)
--@param	tBackSender:回调的LuaTable(不需要回调不填)
--@param	tBackFunction:LuaTable中回调函数(不需要回调不填)
--@param	nOffsetX,X偏移位置，默认为0
--@param	nOffsetY,Y偏移位置，默认为0
--@param	nMaxWidth,显示最大宽度，默认对话框背景宽度
--@param	nScale,设置Scale，默认为1
--@param	bJump,是否跳跃
--@param	tTxtColor,包含r,g,b键值的Lua表/ccc3(不填为默认的r,g,b为58,0,0)
--@param	bIsUpdatePos,是否需要更新位置
--@param	tFollowObj,更新位置的参考对象
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		Order为默认值CellBattleDialog.ZORDER
function CellBattleDialog:addDialog(tSender,tParent,sText,dir,nShowTime,tBackSender,tBackFunction,
	nOffsetX,nOffsetY,nMaxWidth,nScale,bJump,tTxtColor,bIsUpdatePos,tFollowObj, zOrder, tag, textLength, 
	isNeedClick, isOriScale, isScaleAction, isTalkMode, heroPos,bubbleId, playerId)
    --WZLog("CellBattleDialog:addDialog one")
	local tNewObj = self:_new()
	assert(tNewObj, "CellBattleDialog table create failed!")
	tNewObj:_init()

	CellBattleDialog.DIMG, CellBattleDialog.AIMGL = CellChatBubble:getBgAndArrow(bubbleId,playerId)
	CellBattleDialog.AIMGD = CellBattleDialog.AIMGL
	self.m_bIsTalkMode = isTalkMode
	self.m_bIsScaleAction = isScaleAction
    self.m_bIsOriScale = isOriScale
    self.m_bIsNeedClick = isNeedClick
    self.m_tHeroPos = heroPos
    self.m_nBubbleId = bubbleId

    local element
    if false then
        element = WZUIContainer:create()
        assert(element, "CellBattleDialog element create failed!")
    else
        element = WZUISystem:getInstance():createElement("CellBattleDialog")
        assert(element, "CellBattleDialog element create failed!")
        element:setLuaObjectIndex(tNewObj)
        tNewObj.m_root = element
    end
    
	element:setTouchEnable(false)
	if tSender == nil then
		WZLog("tSender is nil")
		return
	end
	if tSender.getParent == nil or tSender:getParent() == nil then
		WZLog("tSender has no parent")
		return
	end
	tNewObj.m_nTextLength = textLength
	tNewObj.m_tSender = tSender
	tNewObj.m_tParent = tParent or tSender:getParent()
	--ShowAll适配
	local parent = tNewObj.m_tParent
	local isShowAll = true
	while parent do
		if WZUIElement:luaTo(parent) and (WZUIElement:luaTo(parent):getNoBorder() == true or WZUIElement:luaTo(parent):getShowAll() == true) then
			isShowAll = false
			break
		end
		parent = parent:getParent()
		if parent == GetSceneRoot() then
			break
		end
	end
	element:setShowAll(isShowAll)
	--
	tNewObj.m_sText = sText or ""
	tNewObj.m_nOffsetX = nOffsetX or tNewObj.m_nOffsetX
	tNewObj.m_nOffsetY = nOffsetY or tNewObj.m_nOffsetY
	tNewObj.m_nShowTime = nShowTime or 2
	tNewObj.m_nMaxWidth = nMaxWidth
	tNewObj.m_nDir = dir or CellBattleDialog.DIR_RIGHT
	tNewObj.m_tBackSender = tBackSender
	tNewObj.m_tBackFunction = tBackFunction
	tNewObj.m_nScale = nScale or 1
	tNewObj.m_bJump = bJump
	
	tTxtColor = tTxtColor or {}
	tNewObj.m_tTxtColor = { r = tTxtColor.r , g = tTxtColor.g , b = tTxtColor.b }
	
    tNewObj.m_bIsUpdatePos = bIsUpdatePos
    tNewObj.m_tFollowObj = tFollowObj
    
	element:setLuaObjectIndex(tNewObj)

    if zOrder == nil then
        zOrder = 0
    end

    if tag == nil then
        tag = 0
    end

	tNewObj.m_tParent:addChild(element, zOrder,tag)

    if zOrder == nil then
        element:setZOrder(CellBattleDialog.ZORDER)
    end

    --WZLog("CellBattleDialog:addDialog", tNewObj.m_bIsUpdatePos)
	return element,tNewObj
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellBattleDialog:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------

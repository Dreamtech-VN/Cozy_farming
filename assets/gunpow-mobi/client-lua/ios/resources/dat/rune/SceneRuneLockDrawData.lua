--SceneRuneLockDrawData.lua
--@brief	SceneRuneLockDraw的数据模块
--@date		2017/03/15
--@author	qixiang
--@note		符文抽奖

SceneRuneLockDraw = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneRuneLockDraw:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nRuneDiamondLotteryFPrice = nil --钻石五次抽奖价格
	self.m_nRuneDiamondLotteryPrice = nil  --钻石抽奖价格

	self.m_nRuneGoldLotteryPrice = nil   --金币抽奖价格
	self.m_nRuneGoldLotteryFPrice = nil  --金币五次抽奖价格

	self.m_nFreeTime = nil   
	self.m_ntype0STimes = nil
	self.m_ntype1STimes = nil
	self.m_bEnableDraw = true

	self.m_tDrawItemId = nil
	self.m_tDrawItemNum = nil
	self.m_nIndex = 1
	self.m_nNodeIndex = 1
    self.m_nTag = nil           
    self.m_nTag = nil 
    self.isUseTicket = nil 			--是否使用双货币            
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneRuneLockDraw:_unInit()
	self.m_root = nil

	self.m_nRuneDiamondLotteryFPrice = nil --钻石五次抽奖价格
	self.m_nRuneDiamondLotteryPrice = nil  --钻石抽奖价格

	self.m_nRuneGoldLotteryPrice = nil   --金币抽奖价格
	self.m_nRuneGoldLotteryFPrice = nil  --金币五次抽奖价格
	self.m_nFreeTime = nil   
	self.m_ntype0STimes = nil
	self.m_ntype1STimes = nil
	self.m_bEnableDraw = nil
	self.m_tDrawItemId = nil
	self.m_tDrawItemNum = nil
	self.m_nIndex = 1
	self.m_nNodeIndex = 1
    self.m_nTag = nil         
    self.m_nTag = nil   
    self.isUseTicket = nil       
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneRuneLockDraw:createElement()
	if self.m_root then
        WindowManager:removeWindow(self.m_root, self, true)
    end
	local element = WZUISystem:getInstance():createElement("SceneRuneLockDraw")
	assert(element, "SceneRuneLockDraw create element failed!")
	self:_init()
	return element
end

function SceneRuneLockDraw:show()
    WZLog("SceneRuneLockDraw:show")
    if SceneRuneLockDraw and SceneRuneLockDraw.m_root == nil then
    	local element  = self:createElement()
        WindowManager:addWindow(element,self)
    end
end


--设置抽奖信息
--freeTime：距离免费抽奖时间（秒）
--type0STimes：金币抽奖距离特殊抽奖次数
--type1STimes：钻石抽奖距离特殊抽奖次数
function SceneRuneLockDraw:setDrawInfo(freeTime,type0STimes,type1STimes)
	WZLog("SceneRuneLockDraw:setDrawInfo ",freeTime,type0STimes,type1STimes)
	if self.m_root == nil then return end
	self.m_nFreeTime = freeTime   
	self.m_ntype0STimes = type0STimes
	self.m_ntype1STimes = type1STimes
	self:initUI()
end

--抽奖回调
function SceneRuneLockDraw:drawCallback(status,itemIds,itemNums,drawType)
	WZLog("SceneRuneLockDraw:drawCallback ",status,Serialize(itemIds))
	if self.m_root == nil then return end
	self.m_bEnableDraw = true
	if status ~= 0 then
		MsgBoxManager:showTipBox(LocalStrings.DRAW_RUNE_ERROR)
	else
		SoundManager:playEffectSound(SoundDefine.E_S_KILL_FUWENJIGUAN)
		self.m_tDrawItemId = itemIds
	    self.m_tDrawItemNum = itemNums
	    local GetElement = GetElement
	    if #self.m_tDrawItemId <= 0 then return end
	    local GetElement = GetElement
	    local conCenter = GetElement(self.m_root,"conCenter_SceneRuneLockDraw",WZUIContainer)
	    conCenter:setVisible(false)
	    self.m_tTopHangle:setTopTouchEnable(false)
	    conCenter:disableSchedule()
	    conCenter:enableSchedule("resetTouchEnableStats",10)
	    local spDraw1 = GetElement(self.m_root,"spDraw1_SceneRuneLockDraw",WZUISpine)
	    local spDraw2 = GetElement(self.m_root,"spDraw2_SceneRuneLockDraw",WZUISpine)
	    local conBtn = GetElement(self.m_root,"conBtn_SceneRuneLockDraw",WZUIContainer)
	    conBtn:setVisible(false)
	    spDraw1:play("bian_1",false)
	    spDraw2:play("yuan_1",false)
	    spDraw2:setVisible(true)
	    spDraw1:setLuaSpineEventFunc("event1")
		if SceneRune and SceneRune.m_root then --抽奖成功后需要刷新符文背包
    	    ProtocolProcessorSceneRune:send_RUNE_GetRuneInfo()
        end
        if WndRuneBook and WndRuneBook.m_root then
        	ProtocolProcessorSceneRune:send_RUNE_GetRuneList( )
        end
	end
end

--事件函数
function SceneRuneLockDraw:event1(animation, name, eventName)
	WZLog("SceneRuneLockDraw:event1 ",animation,name,eventName)
	local GetElement = GetElement
	if name == "complete" then
	    local spDraw1 = GetElement(self.m_root,"spDraw1_SceneRuneLockDraw",WZUISpine)
	    local spDraw2 = GetElement(self.m_root,"spDraw2_SceneRuneLockDraw",WZUISpine)
	    spDraw1:setLuaSpineEventFunc("event3")
	    spDraw2:play("yuan_2",false)
	    spDraw2:setLuaSpineEventFunc("event2")
	end
end


--事件函数
function SceneRuneLockDraw:event2(animation, name, eventName)
	WZLog("SceneRuneLockDraw:event2 ",animation,name,eventName)
	local GetElement = GetElement
	if name == "complete" then
	    WZLog("ceneRuneLockDraw:event2 end")
	    local spDraw1 = GetElement(self.m_root,"spDraw1_SceneRuneLockDraw",WZUISpine)
	    local spDraw2 = GetElement(self.m_root,"spDraw2_SceneRuneLockDraw",WZUISpine)
	    spDraw2:setLuaSpineEventFunc("event3")
	    spDraw2:play("yuan_3",false)
	    spDraw1:play("bian_2",false)
	    self.m_root:enableSchedule("playDrawRuneImage",0.7)
	end
end

--事件函数
function SceneRuneLockDraw:event3(animation, name, eventName)
	WZLog("SceneRuneLockDraw:event3")

end

function SceneRuneLockDraw:moveToT(index,itemId)
	WZLog("SceneRuneLockDraw:moveToT=",index)
	local image = WZUIImage:create()
	image:setUseOriginSize(true)
	image:setRelativePosition(GlobalMethod:ccp(0.499989,0.708621))
	local conDraw = GetElement(self.m_root,"conDraw_SceneRuneLockDraw",WZUIContainer)
	local conDrawItem3 = GetElement(conDraw,"conDrawItem" .. index .. "_SceneRuneLockDraw",WZUIContainer)
	local relPs = conDrawItem3:getRelativePosition()
	local absX = 960 * relPs.x
	local absY = 580 * relPs.y
	if itemId > 0 then
		local itemInfo = GDatatab_item["id_" .. itemId]
		image:setFile(itemInfo.icon)
		conDraw:addChild(image)
		conDrawItem3:setTag(itemId)
		image:setTag(index)
		local actionMoveTo = WZUIActionMoveToPosition:create()
        actionMoveTo:setPosition(GlobalMethod:ccp(absX,absY))
        actionMoveTo:setDuration(0.4)
		local itemInfo = GDatatab_item["id_" ..itemId]
		image:setFile(itemInfo.icon)
		actionMoveTo:setFinishLuaFunction("showDrawRuneImage")
		actionMoveTo:setFinishLuaTable(self)
		image:runUIAction(actionMoveTo)
	end
end

function SceneRuneLockDraw:showDrawRuneImage(element)
   WZLog("SceneRuneLockDraw:showDrawRuneImage ",element:getTag())
    local tag = element:getTag()
    element:removeFromParentAndCleanup(true)
    local GetElement = GetElement
    if tag then
   	    local conDraw = GetElement(self.m_root,"conDraw_SceneRuneLockDraw",WZUIContainer)
   	    local conDrawItem = GetElement(conDraw,"conDrawItem" .. tag .. "_SceneRuneLockDraw",WZUIContainer)
   	    conDrawItem:setVisible(true)
   	    local imgDraw = GetElement(conDrawItem,"imgDraw_SceneRuneLockDraw",WZUIImage)
   	    local itemId = conDrawItem:getTag()
   	    if itemId then
   	    	local itemInfo = GDatatab_item["id_" .. itemId]
		    imgDraw:setFile(itemInfo.icon)
   	    end
   	    local count =  #self.m_tDrawItemId
   	    if tag == 3 and count == 1 then
   	    	self:showDrawItem(self.m_tDrawItemId,self.m_tDrawItemNum)
   	    else
   	    	if tag == count then
   	    	    self:showDrawItem(self.m_tDrawItemId,self.m_tDrawItemNum)
   	        end
   	    end
    end
end

--播放抽奖的符文图片
function SceneRuneLockDraw:playDrawRuneImage(element)
	WZLog("SceneRuneLockDraw:playDrawRuneImage")
	element:disableSchedule()
	local conDraw = GetElement(self.m_root,"conDraw_SceneRuneLockDraw",WZUIContainer)
	local image = WZUIImage:create()
	image:setUseOriginSize(true)
	image:setRelativePosition(GlobalMethod:ccp(0.499989,0.741379))
	image:setScale(0)
	image:setTag(118)
	conDraw:addChild(image)
	local act1 = WZUIActionScaleTo:create()
	act1:setDuration(0.8)
	act1:setScaleX(1)
	act1:setScaleY(1)
	local itemInfo = GDatatab_item["id_" .. self.m_tDrawItemId[1]]
    image:setFile(itemInfo.icon)
    act1:setFinishLuaTable(self)
    act1:setFinishLuaFunction("playMoveAction")
    image:runUIAction(act1)
end

--显示抽奖到的符文图片
function SceneRuneLockDraw:playMoveAction()
	WZLog("SceneRuneLockDraw:playMoveAction")
	-- local spDraw1 = GetElement(self.m_root,"spDraw1_SceneRuneLockDraw",WZUISpine)
	-- local spDraw2 = GetElement(self.m_root,"spDraw2_SceneRuneLockDraw",WZUISpine)
	-- spDraw2:setVisible(false)
	-- spDraw1:play("stand",false)
	local count =  #self.m_tDrawItemId
	local conDraw = GetElement(self.m_root,"conDraw_SceneRuneLockDraw",WZUIContainer)
	local childNode = conDraw:getChildByTag(118)
	if childNode then
		childNode:removeFromParentAndCleanup(true)
	end
	if count == 1 then
		self.m_nIndex = 1
	    self.m_nNodeIndex = 3
		self:moveToT(self.m_nNodeIndex,self.m_tDrawItemId[self.m_nIndex])
	else
		self.m_nIndex = 1
	    self.m_nNodeIndex = 1
		self:moveToT(self.m_nNodeIndex,self.m_tDrawItemId[self.m_nIndex])
		self.m_root:enableSchedule("showDraw",0.2)
	end
end

function SceneRuneLockDraw:showDraw(element)
	WZLog("SceneRuneLockDraw:showDraw")
	self.m_nIndex = self.m_nIndex + 1
	self.m_nNodeIndex = self.m_nNodeIndex + 1
	if self.m_nIndex <= 10 then
		self:moveToT(self.m_nNodeIndex, self.m_tDrawItemId[self.m_nIndex])
	else
		element:disableSchedule()
	end
end

function SceneRuneLockDraw:resetTouchEnableStats(element)
	WZLog("SceneRuneLockDraw:resetTouchEnableStats")
	if self.m_root == nil then return end
	element:disableSchedule()
	self.m_tTopHangle:setTopTouchEnable(true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


--@brief  添加顶部导航栏
function SceneRuneLockDraw:addTop()
	WZLog("SceneRuneLockDraw:addTop")
	local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    self.m_tTopHangle = tcell
    self.m_oTopObject = cell
    tcell:setTopData("ui/common/common_icon_chouqufuwen.png",SceneRuneLockDraw,SceneRuneLockDraw.onCloseClick,true,false,false,"SceneRuneLockDraw",{goldType=8})
end


-------------------------------------私有方法模块End----------------------------------------

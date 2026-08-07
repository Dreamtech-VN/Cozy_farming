--TeachBossMap.lua
--@brief	TeachBossMap的模块
--@date		2011/2/19
--@author	liangguang_long
--@note		副本教学

TeachBossMap =
{
	ISLAND_BOSSMAP = 1005,             --进入副本按钮       --1005
    BOSSMAP_CHALLENGE = 1501,          --挑战关卡按钮       --1501
    BOSSMAP_SIMPLE = 1502,             --简单模式按钮       --1502
    BOSSMAP_SURE = 1503,               --挑战确定按钮       --1503
	TEACH_ORDER = 12001,			   --层
	TEACH_ISSTOP = false ,			   --是否停止教学
	INDEX = 0,						   --步骤索引
	ISMOVE = false,					   --是否移动事件
	CELL,							   --触发教学节点事件
	SHELTER,						   --遮罩层节点
	ICON,							  --发光效果图片路径
	FADEPOS,
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	开始新手教学
--@param	nId：新手教学的编号
--@param	nStep：当前新手教学的步骤编号
function TeachBossMap:start( nId , nStep )
	WZLog("start TeachBossMap:start::::" , nStep , TeachBossMap.INDEX)
	if nId == nil or nStep == nil then
		return
	end
	Teach:beganTeach()
	--移除场景里教学用的遮挡层
	Teach:removeShelter()
	self:_isCloseStep( nStep )
	--获取下一步的新手教学的步骤编号
	nStep = self:_getTeachStep( nStep )
	if nStep then
		self:_createShelter( nStep )	--创建遮罩层
	end
end

--@brief	移开回调函数
function TeachBossMap:onMoveOut( element )
	TeachBossMap.ISMOVE = true
end

--@brief	开始接触回调函数
function TeachBossMap:onTouchBegan( element )
	TeachBossMap.ISMOVE = false
end

--@brief	遮罩层点击结束事件
function TeachBossMap:onTouchEnd( element , pt )
	if TeachBossMap.TEACH_ISSTOP == true and TeachBossMap.ISMOVE == false then
		pt = TeachBossMap.SHELTER:convertToNodeSpace( pt )
		local isBool = Teach:getUiRect( TeachBossMap.SHELTER , TeachBossMap.CELL ,  pt )
		if isBool == false then
			--教学结束
			Teach:removeTeachElement()
			Teach.TEACHOVER = true
			TeachBossMap.INDEX = nil
		end
		WZLog("isBool:::::" , isBool)
	end
end

--@brief	自动完成新手教学教程
--@@note	5秒钟后如果没有走新手教学，就自动完成新手教学
function TeachBossMap:scheduleCompleteTeach( element )
	WZLog("element::::::::::::::s::::::::::" , element , TeachBossMap.SHELTER)
	element:disableSchedule()
	TeachBossMap.TEACH_ISSTOP = true
	local tCell = element:getChildElement("WndTeachTouch")
	local winSize = element:getContentSize()
	local size = tCell:getContentSize()
	local img = element:getChildElement("imgTeachTouch")
	local imgSize = img:getContentSize()
	tCell:setPosition( GlobalMethod:ccp(winSize.width / 2 ,winSize.height / 2) )
	tCell:setContentSize( GlobalMethod:CCSize(winSize.width , winSize.height)  )
	img:setRelativeSize(GlobalMethod:CCSize(winSize.width/imgSize.width , winSize.height/imgSize.height))
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	创建遮罩层
--@param	nId：新手教学的编号
function TeachBossMap:_createShelter( nId )
	--获取需要新手教学的节点和要提示的文本内容
	local tCell , sDesc , nDirection , isIsland , dirPt , dir = self:_getTeachUiData( nId )
	if tCell then
		local conShelter = WindowManager:addTeachShelterLayer( TeachBossMap.TEACH_ORDER )
		conShelter:setLuaObjectIndex(TeachBossMap)
		TeachBossMap.SHELTER = conShelter
		TeachBossMap.CELL = tCell
		WindowManager:addTeachTouchLayerForElement(tCell, tCell:getContentSize())
		WindowManager:setTeachTouchCallBack( TeachBossMap, "onTouchBegan", nil, "onTouchEnd" , "onMoveOut")
		if isIsland == true then
			SceneIsland:changeBuildingShining(tCell)
			tCell:setZOrder(500)
		end
		--弹出教学对话框
		Teach:showDialog( conShelter , tCell ,sDesc , nDirection , dirPt )
		--发光效果
		Teach:showShineAction( tCell , TeachBossMap.ICON , dir , TeachBossMap.FADEPOS ) 
		--创建定时器
		TeachBossMap:_startSchedule( conShelter )
	end
end

--@brief	获取需要新手教学的节点和要提示的文本内容
--@param	nId：新手教学的编号
--@return	tCell：返回要提示新手教学的ui节点
--@return	sDesc：返回提示文本内容
--@return	nDirection：返回对话框方向
--@return	isIsland：是否小岛界面的控件
function TeachBossMap:_getTeachUiData( nId )
	if nId == nil then
		return
	end
	local tCell = nil
	local sDesc = nil
	local nDirection = nil
	local isIsland = false
	local dirPt = GlobalMethod:ccp( -32 , 0 )
	local dir = GlobalMethod:CCSize(18 , 57)
    local pos = GlobalMethod:ccp(0 , 0)
	local icon = "common/animation/button_9_an.png"
	if nId == TeachBossMap.ISLAND_BOSSMAP then					--进入副本按钮       --1005
		tCell = GetTeachElementById( TeachIdDefine.TEACH_ISLAND , TeachIdDefine.ISLAND_BOSSMAP )
		sDesc = LocalStrings.TEACH_BOSSMAP						--"快带着刚获得的小伙伴进行一场副本探险吧"
		nDirection = CellDialog.DIR_LEFT
		isIsland = true
		TeachBossMap.INDEX = 1005
		icon = nil 
		dirPt = GlobalMethod:ccp( 20 , 0 )
	elseif nId == TeachBossMap.BOSSMAP_CHALLENGE then			--挑战关卡按钮       --1501
		tCell = GetTeachElementById( TeachIdDefine.TEACH_BOSSMAP, TeachIdDefine.BOSSMAP_CHALLENGE )
		sDesc = LocalStrings.TEACH_BOSSMAP_CHALLENGE			--"选择难度为普通。通关后将自动解锁下一难度"
		nDirection = CellDialog.DIR_UP
		TeachBossMap.INDEX = 1501
		dir = GlobalMethod:CCSize(55 , 57)
		if ProjConfig.LANGUAGE == "cn" then
			dir = GlobalMethod:CCSize(18 , 57)
		end

		dirPt = GlobalMethod:ccp( -12 , 0 )
	elseif nId == TeachBossMap.BOSSMAP_SIMPLE then				--简单模式按钮       --1502
		tCell = GetTeachElementById( TeachIdDefine.TEACH_BOSSMAP , TeachIdDefine.BOSSMAP_SIMPLE )
		sDesc = LocalStrings.TEACH_BOSSMAP_SIMPLE					--"选择难度为简单。通关后将自动解锁下一难度"
		nDirection = CellDialog.DIR_DOWN
		TeachBossMap.INDEX = 1502
		icon = "common/animation/model_easy_an.png"
		dirPt = GlobalMethod:ccp( -40 , 50 )  --0,70
		dir = GlobalMethod:CCSize(4 , 4)
		pos = GlobalMethod:ccp(1.3 , 20)
	elseif nId == TeachBossMap.BOSSMAP_SURE then				--挑战确定按钮       --1503
		tCell = GetTeachElementById( TeachIdDefine.TEACH_BOSSMAP , TeachIdDefine.BOSSMAP_SURE )
		sDesc = LocalStrings.TEACH_BOSSMAP_SURE						--"点击创建副本房间"
		nDirection = CellDialog.DIR_UP
		TeachBossMap.INDEX = 1503
		dirPt = GlobalMethod:ccp( -30 , 4 )
		dir = GlobalMethod:CCSize(80 , 44)
		pos = GlobalMethod:ccp( 0 , 0.2 )
	end
	self:_setFadeIcon( icon )
	self:_setFadePos( pos )
	self:_checktCell( tCell )
	return tCell , sDesc , nDirection , isIsland , dirPt , dir
end

--@brief	获取下一步的新手教学的步骤编号
--@param	nStep：当前新手教学的步骤编号
--@return	num：返回下一步新手教学的步骤编号
function TeachBossMap:_getTeachStep( nStep )
	local num = nil
	if nStep == 0 then
		num = 1005
	elseif nStep == 1005 then
		num = 1501
	elseif nStep == 1501 then
		num = 1502
	elseif nStep == 1502 then
		num = 1503
	elseif nStep == 1503 then
		num = 1504
	end
	return num
end

--@brief	设置发光图片
function TeachBossMap:_setFadeIcon( icon )
	TeachBossMap.ICON = icon
end

--@brief	设置发光图片偏移位置
function TeachBossMap:_setFadePos( pos )
	TeachBossMap.FADEPOS = pos
end

--@brief	开始自动完成新手教学教程定时器
function TeachBossMap:_startSchedule( element )
	if TeachBossMap.INDEX ~= TeachBossMap.ISLAND_BOSSMAP then
		element:enableSchedule("scheduleCompleteTeach" , Teach.SCHEDULETIME )
	end
end

--@brief	按钮回调函数
--@return	当前新手教学的步骤编号
function TeachBossMap:_isCloseStep( nStep )
	if nStep == TeachBossMap.BOSSMAP_SURE then
		--教学结束
		Teach:removeTeachElement()
		TeachBossMap.INDEX = nil
		TeachBossMap.TEACH_ISSTOP = false
		Teach.TEACHOVER = true
	end
end

--@brief	检查节点是否存在
function TeachBossMap:_checktCell( tCell )
	if tCell == nil then
		WZLog("tCell:::is nil::::::")
		Teach:removeTeachElement()
		TeachPet.INDEX = nil
	end
end

-------------------------------------私有方法模块End----------------------------------------












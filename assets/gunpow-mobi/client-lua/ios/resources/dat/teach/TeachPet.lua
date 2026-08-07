--TeachPet.lua
--@brief	TeachPet的模块
--@date		2011/2/19
--@author	liangguang_long
--@note		宠物教学

TeachPet =
{
	ISLAND_PET = 1006,                --进入宠物按钮        --1006
	PET_ENTER_CENTER = 1601,          --宠物中心培养按钮    --1601
	PET_TRAIN_IN = 1602,           	  --宠物培养按钮      	--1602
	PET_TRAIN_WAY = 1603,             --宠物培训方式   		--1603
	PET_TRAIN_SURE = 1604,            --宠物培养按钮        --1604
	PET_TRAIN_SAVE = 1605,            --宠物培养保存按钮    --1605
	PET_CLOSE = 1606,          		  --宠物关闭按钮        --1606
	TEACH_ORDER = 12001,		  	  --层
	TEACH_ISSTOP = false ,			  --是否停止教学
	INDEX = 0,						  --步骤索引
	ICON,							  --发光效果图片路径
	SHELTER,						  --遮罩层节点
	ISMOVE = false,					  --判断移动事件
	CELL,							  --触发教学节点事件
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	开始新手教学
--@param	nId：新手教学的编号
--@param	nStep：当前新手教学的步骤编号
function TeachPet:start( nId , nStep )
	WZLog("TeachPet:start" , nStep , TeachPet.INDEX)
	if nId == nil or nStep == nil then
		return
	end
	Teach:beganTeach()
	--移除场景里教学用的遮挡层
	Teach:removeShelter()
	TeachPet:onClickBackFun( nStep )
	--获取下一步的新手教学的步骤编号
	nStep = self:_getTeachStep( nStep )
	if nStep then
		self:_createShelter( nStep )	--创建遮罩层
	end
end
	
--@brief	按钮回调函数
--@return	当前新手教学的步骤编号
function TeachPet:onClickBackFun( nStep )
    WZLog("TeachPet:onClickBackFun", nStep)
	if nStep == TeachPet.PET_TRAIN_SURE then
		--GlobalGame.g_bIfInTeaching = false
		Teach:removeTeachElement()
		GlobalGame.g_bIfInTeaching = true
	elseif nStep == TeachPet.PET_CLOSE then
		Teach:removeTeachElement()
		TeachPet.INDEX = nil
		--返回小岛
		sceneIsland = SceneIsland:createElement()
		replaceScene(sceneIsland)
	end
end

--@brief	自动完成新手教学教程
--@@note	5秒钟后如果没有走新手教学，就自动完成新手教学
function TeachPet:scheduleCompleteTeach( element )
	WZLog("TeachPet:scheduleCompleteTeach" , element )
	element:disableSchedule()
	TeachPet.TEACH_ISSTOP = true
	local tCell = element:getChildElement("WndTeachTouch")
	local winSize = element:getContentSize()
	local size = tCell:getContentSize()
	local img = element:getChildElement("imgTeachTouch")
	local imgSize = img:getContentSize()
	tCell:setPosition( GlobalMethod:ccp(winSize.width / 2 ,winSize.height / 2) )
	tCell:setContentSize( GlobalMethod:CCSize(winSize.width , winSize.height)  )
	img:setRelativeSize(GlobalMethod:CCSize(winSize.width/imgSize.width , winSize.height/imgSize.height))
end

--@brief	移开事件函数
function TeachPet:onMoveOut()
    WZLog("TeachPet:onMoveOut")
	TeachPet.ISMOVE = true
end

--@brief	开始按下事件函数
function TeachPet:onTouchBegan()
    WZLog("TeachPet:onTouchBegan")
	TeachPet.ISMOVE = false
end

--@brief	按下结束事件函数
function TeachPet:onTouchEnd( element , pt )
    WZLog("TeachPet:onTouchEnd")
	if TeachPet.TEACH_ISSTOP == true and TeachPet.ISMOVE == false then
		pt = TeachPet.SHELTER:convertToNodeSpace( pt )
		local isBool = Teach:getUiRect( TeachPet.SHELTER , TeachPet.CELL ,  pt )
		if isBool == false then
			--教学结束
			Teach:removeTeachElement()
			ScenePet:setPageConVisible(true)
			TeachPet.INDEX = nil
		end
	end
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	创建遮罩层
--@param	nId：新手教学的编号
function TeachPet:_createShelter( nId )
    WZLog("TeachPet:_createShelter",nId)
	--获取需要新手教学的节点和要提示的文本内容
	local tCell , sDesc , nDirection , isIsland , dir , dialogPt = self:_getTeachUiData( nId )
	if tCell then
		local conShelter = WindowManager:addTeachShelterLayer( TeachPet.TEACH_ORDER )
		conShelter:setLuaObjectIndex(TeachPet)
		TeachPet.SHELTER = conShelter
		TeachPet.CELL = tCell
		WindowManager:addTeachTouchLayerForElement(tCell, tCell:getContentSize())
		WindowManager:setTeachTouchCallBack( TeachPet, "onTouchBegan" , nil, "onTouchEnd" , "onMoveOut")
		if isIsland == true then
			SceneIsland:changeBuildingShining(tCell)
			tCell:setZOrder(500)
		end
		--弹出教学对话框
		Teach:showDialog( conShelter , tCell , sDesc , nDirection , dialogPt )
		--发光效果
		Teach:showShineAction(tCell , TeachPet.ICON , dir)
		--创建定时器
		TeachPet:_startSchedule( conShelter )
	end
end

--@brief	获取需要新手教学的节点和要提示的文本内容
--@param	nId：新手教学的编号
--@return	tCell：返回要提示新手教学的ui节点
--@return	sDesc：返回提示文本内容
--@return	nDirection：返回对话框方向
--@return	isIsland：是否小岛界面的控件
function TeachPet:_getTeachUiData( nId )
    WZLog("TeachPet:_getTeachUiData",nId)
	if nId == nil then
		return
	end
	local tCell = nil
	local sDesc = nil
	local nDirection = nil
	local isIsland = false
	local order = nil
	local dir = GlobalMethod:CCSize(9.6 , 9.6)
	local dialogPt = GlobalMethod:ccp( -28 , 0)
	local icon = "common/animation/button_10_an.png"
	if nId == TeachPet.ISLAND_PET then						--进入宠物按钮       --1006
		tCell = GetTeachElementById( TeachIdDefine.TEACH_ISLAND , TeachIdDefine.ISLAND_PET )
		sDesc = LocalStrings.TEACH_PET  					--"进入宠物乐园培养属性提升等级增加战力"
		nDirection = CellDialog.DIR_DOWN
		isIsland = true
		TeachPet.INDEX = 1006
		icon = nil 
	elseif nId == TeachPet.PET_ENTER_CENTER then			--宠物中心培养按钮   --1601
		tCell = GetTeachElementById( TeachIdDefine.TEACH_PET , TeachIdDefine.PET_ENTER_CENTER )
		sDesc = LocalStrings.TEACH_PET_CENTER				--"宠物中心中可培养、查看宠物"
		nDirection = CellDialog.DIR_UP
		TeachPet.INDEX = 1601
		dir = GlobalMethod:CCSize(78 , 90)
		dialogPt = GlobalMethod:ccp( 0 , 0)
	elseif nId == TeachPet.PET_TRAIN_IN then				--宠物培养按钮       --1602
		tCell = GetTeachElementById( TeachIdDefine.TEACH_PET , TeachIdDefine.PET_TRAIN_IN )
		sDesc = LocalStrings.TEACH_PET_STARTTRAIN						--"此处可进行宠物培养"
		nDirection = CellDialog.DIR_UP
		TeachPet.INDEX = 1602
		dialogPt = GlobalMethod:ccp( -18 , 0)
	elseif nId == TeachPet.PET_TRAIN_WAY then				--宠物培训方式   	 --1603
		tCell = GetTeachElementById( TeachIdDefine.TEACH_PET , TeachIdDefine.PET_TRAIN_WAY )
		sDesc = LocalStrings.TEACH_PET_TRAIN_WAY			--"钻石培养高概率使宠物属性全面上升"
		nDirection = CellDialog.DIR_UP
		TeachPet.INDEX = 1603
		dir = GlobalMethod:CCSize(30 , 10)
		dialogPt = GlobalMethod:ccp( -20 , -8)
		icon = "common/animation/close_an.png"
	elseif nId == TeachPet.PET_TRAIN_SURE then				--宠物培养按钮        --1604
		tCell = GetTeachElementById( TeachIdDefine.TEACH_PET , TeachIdDefine.PET_TRAIN_SURE )
		sDesc = LocalStrings.TEACH_PET_TRAINBTN				--"花费钻石提升宠物属性"
		nDirection = CellDialog.DIR_UP
		TeachPet.INDEX = 1604
	elseif nId == TeachPet.PET_TRAIN_SAVE then				--宠物培养保存按钮    --1605
		tCell = GetTeachElementById( TeachIdDefine.TEACH_PET , TeachIdDefine.PET_TRAIN_SAVE )
		sDesc = LocalStrings.TEACH_PET_TRAINSURE			--"点击可使此次培养成果生效，宠物属性全面上升"
		nDirection = CellDialog.DIR_UP
		TeachPet.INDEX = 1605
		dialogPt = GlobalMethod:ccp( 0 , 0)
	elseif nId == TeachPet.PET_CLOSE then					--宠物关闭按钮        --1606
		tCell = GetTeachElementById( TeachIdDefine.TEACH_PET , TeachIdDefine.PET_CLOSE )
		sDesc = LocalStrings.TEACH_PET_CLOSE				--"培养完成，返回大厅"
		nDirection = CellDialog.DIR_DOWN
		TeachPet.INDEX = 1606
		icon = "common/animation/close_an.png"
		dir = GlobalMethod:CCSize(48 , 44)
		dialogPt = GlobalMethod:ccp( -28 , 3)
	end
	self:_setFadeIcon( icon )
	self:_checktCell( tCell )
	return tCell , sDesc , nDirection , isIsland , dir , dialogPt
end

--@brief	获取下一步的新手教学的步骤编号
--@param	nStep：当前新手教学的步骤编号
--@return	num：返回下一步新手教学的步骤编号
function TeachPet:_getTeachStep( nStep )
    WZLog("TeachPet:_getTeachStep", nStep)
	local num = nil
	if nStep == 0 then
		num = 1006
	elseif nStep == 1006 then
		num = 1601
	elseif nStep == 1601 then
		num = 1602
	elseif nStep == 1602 then
		num = 1603
	elseif nStep == 1603 then
		num = 1604
	elseif nStep == 1604 then
		num = 1605
	elseif nStep == 1605 then
		num = 1606
	elseif nStep == 1606 then
		num = 1607
	end
	return num
end

--@brief	开始自动完成新手教学教程定时器
function TeachPet:_startSchedule( element )
    WZLog("TeachPet:_startSchedule")
	if TeachPet.INDEX ~= TeachPet.ISLAND_PET then
		element:enableSchedule( "scheduleCompleteTeach" , Teach.SCHEDULETIME )
	end
end

--@brief	设置发光图片
function TeachPet:_setFadeIcon( icon )
    WZLog("TeachPet:_setFadeIcon", icon)
	TeachPet.ICON = icon
end

--@brief	检查节点是否存在
function TeachPet:_checktCell( tCell )
    WZLog("TeachPet:_checktCell")
	if tCell == nil then
		WZLog("tCell:::is nil::::::")
		Teach:removeTeachElement()
		TeachPet.INDEX = nil
	end
end

-------------------------------------私有方法模块End----------------------------------------









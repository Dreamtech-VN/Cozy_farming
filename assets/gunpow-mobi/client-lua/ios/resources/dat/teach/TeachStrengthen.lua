--TeachStrengthen.lua
--@brief	TeachStrengthen的模块
--@date		2011/2/19
--@author	liangguang_long
--@note		宠物教学

TeachStrengthen =
{
	ISLAND_STRENGTHEN = 1004,           --进入强化研究院按钮    --1004
	STRENGTHEN_FUN_ENTER = 1401,        --强化功能窗口进入按钮  --1401
	STRENGTHEN_WEAPON_ITEM = 1402,      --强化的武器            --1402
	STRENGTHEN_OTHER = 1403,            --其他物品栏按钮        --1403
	STRENGTHEN_OTHER_ITEM = 1404,       --其他物品栏物品        --1404
	STRENGTHEN_START = 1405,           	--强化按钮              --1405
	STRENGTHEN_CLOSE = 1406,           	--强化关闭按钮          --1406
	TEACH_ORDER = 12001,			   	--层
	TEACH_ISSTOP = false ,			   --是否停止教学
	INDEX = 0,						 	--步骤索引
	STONENUM = 1 , 
	ICON,
	CELL,							  --触发教学节点事件
	SHELTER,						  --遮罩层节点
	ISMOVE = false,					  --判断移动事件
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	开始新手教学
--@param	nId：新手教学的编号
--@param	nStep：当前新手教学的步骤编号
function TeachStrengthen:start( nId , nStep )
	WZLog("start TeachStrengthen:start::::",nId  , nStep , TeachStrengthen.INDEX)
	if nId == nil or nStep == nil then
		return
	end
	Teach:beganTeach()
	--@brief	移除发光
	Teach:removeShine()
	--移除场景里教学用的遮挡层
	Teach:removeShelter()
	local nId = self:onClickBackFun( nStep )
	if nId then
		nStep = nId
	end
	--获取下一步的新手教学的步骤编号
	nStep = self:_getTeachStep( nStep )
	if nStep then
		self:_createShelter( nStep )	--创建遮罩层
	end
	WZLog("end:::::::::::::::::::::::::::::",nStep)
end

--@brief	移开事件函数
function TeachStrengthen:onMoveOut()
	TeachStrengthen.ISMOVE = true
end

--@brief	遮罩层点击开始事件
function TeachStrengthen:onTouchBegan( )
	WZLog("onTouchBegan:::::::::::::::::")
	TeachStrengthen.ISMOVE = false
end

--@brief	遮罩层点击结束事件
function TeachStrengthen:onTouchEnd( element , pt )
	if TeachStrengthen.TEACH_ISSTOP == true and TeachStrengthen.ISMOVE == false then
		pt = TeachStrengthen.SHELTER:convertToNodeSpace( pt )
		local isBool = Teach:getUiRect( TeachStrengthen.SHELTER , TeachStrengthen.CELL ,  pt )
		if isBool == false then
			--教学结束
			Teach:removeTeachElement()
			SceneStrengthen:setpageContainerMove(true)
			TeachStrengthen.INDEX = nil
			TeachStrengthen.STONENUM = 1
		end
	end
end

--@brief	按钮回调函数
--@return	当前新手教学的步骤编号
function TeachStrengthen:onClickBackFun( nStep )
	local nId = nil
	if nStep == TeachStrengthen.STRENGTHEN_CLOSE then
		--教学结束
		Teach:removeTeachElement()
		TeachStrengthen.INDEX = nil
		TeachStrengthen.STONENUM = 1
		--返回小岛
		sceneIsland = SceneIsland:createElement()
		replaceScene(sceneIsland)
	elseif nStep == TeachStrengthen.STRENGTHEN_OTHER_ITEM then
		local nSuccessRate = WndIntensify:_getSuccessRate()
		local isStone , nStone = WndIntensify:isItemExist( 6 , 1 )
		nId = self:_selectStone( nStone , nSuccessRate )
	end
	return nId
end

--@brief	自动完成新手教学教程
--@@note	5秒钟后如果没有走新手教学，就自动完成新手教学
function TeachStrengthen:scheduleCompleteTeach( element )
	WZLog("TeachStrengthen:scheduleCompleteTeach:::::::5:" , element )
	element:disableSchedule()
	TeachStrengthen.TEACH_ISSTOP = true
	local tCell = element:getChildElement("WndTeachTouch")
	local winSize = element:getContentSize()
	local size = tCell:getContentSize()
	local img = element:getChildElement("imgTeachTouch")
	local imgSize = img:getContentSize()
	tCell:setPosition( GlobalMethod:ccp(winSize.width / 2 ,winSize.height / 2) )
	tCell:setContentSize( GlobalMethod:CCSize(winSize.width , winSize.height)  )
	WZLog("width::::::::::::",winSize.width,winSize.height)
	WZLog("width::::::::::::",imgSize.width,imgSize.height)
	img:setRelativeSize(GlobalMethod:CCSize(winSize.width/imgSize.width , winSize.height/imgSize.height))
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	创建遮罩层
--@param	nId：新手教学的编号
function TeachStrengthen:_createShelter( nId )
	--获取需要新手教学的节点和要提示的文本内容
	local tCell ,sDesc ,nDirection ,isIsland ,dirPt,dir,pt = self:_getTeachUiData( nId )
	if tCell then 
		local conShelter = WindowManager:addTeachShelterLayer( TeachStrengthen.TEACH_ORDER )
		conShelter:setLuaObjectIndex(TeachStrengthen)
		TeachStrengthen.SHELTER = conShelter
		TeachStrengthen.CELL = tCell
		local size = tCell:getContentSize()
		WZLog("tCell：：：：：：：" , size.width ,size.height)
		WindowManager:addTeachTouchLayerForElement(tCell, GlobalMethod:CCSize(size.width*0.9 , size.height*0.9))
		WindowManager:setTeachTouchCallBack( TeachStrengthen, "onTouchBegan", nil, "onTouchEnd" , "onMoveOut")
		if isIsland == true then
			SceneIsland:changeBuildingShining(tCell)
			tCell:setZOrder(500)
		end
		--弹出教学对话框
		Teach:showDialog( conShelter , tCell ,sDesc , nDirection , dirPt )
		--发光效果
		TeachStrengthen:_showShineAction( tCell , TeachStrengthen.ICON , dir , pt)
		--创建定时器
		TeachStrengthen:_startSchedule( conShelter )
	end
end

--@brief	获取需要新手教学的节点和要提示的文本内容
--@param	nId：新手教学的编号
--@return	tCell：返回要提示新手教学的ui节点
--@return	sDesc：返回提示文本内容
--@return	nDirection：返回对话框方向
--@return	isIsland：是否小岛界面的控件
function TeachStrengthen:_getTeachUiData( nId )
	if nId == nil then
		return
	end
	local tCell = nil
	local sDesc = nil
	local nDirection = nil
	local isIsland = false
	local dirPt = GlobalMethod:ccp(-30 , 0)
	local size = GlobalMethod:CCSize(0 , 0)
	local pt = GlobalMethod:ccp(0,0)
	local icon = "common/animation/button_10_an.png"
	if nId == TeachStrengthen.ISLAND_STRENGTHEN then			--进入强化研究院按钮  --1004
		tCell = GetTeachElementById( TeachIdDefine.TEACH_ISLAND , TeachIdDefine.ISLAND_STRENGTHEN )
		sDesc = LocalStrings.TEACH_STRENGTHEN					--"想轻松提高战斗力吗？那就来强化装备吧！"
		nDirection = CellDialog.DIR_RIGHT
		isIsland = true
		TeachStrengthen.INDEX = 1004
		icon = nil
	elseif nId == TeachStrengthen.STRENGTHEN_FUN_ENTER then		--强化功能窗口进入按钮  --1401
		tCell = GetTeachElementById( TeachIdDefine.TEACH_STRENGTHEN , TeachIdDefine.STRENGTHEN_FUN_ENTER )
		sDesc = LocalStrings.TEACH_STRENGTHENSTART				--"开始进行装备强化"
		nDirection = CellDialog.DIR_UP
		TeachStrengthen.INDEX = 1401
		dirPt = GlobalMethod:ccp(-32 , 0)
		size = GlobalMethod:CCSize(73 , 77)
	elseif nId == TeachStrengthen.STRENGTHEN_WEAPON_ITEM then	--强化的武器            --1402
		tCell = GetTeachElementById( TeachIdDefine.TEACH_STRENGTHEN , TeachIdDefine.STRENGTHEN_WEAPON_ITEM )
		sDesc = LocalStrings.TEACH_STRENGTHEN_WEAPON			--"选择需要强化的武器"
		nDirection = CellDialog.DIR_LEFT
		TeachStrengthen.INDEX = 1402
		icon = "common/animation/7_an.png"
		dirPt = GlobalMethod:ccp( 20 , 0 )
		size = GlobalMethod:CCSize(72 , 72)
		pt = GlobalMethod:ccp(0 , -2)
	elseif nId == TeachStrengthen.STRENGTHEN_OTHER then			--其他物品栏按钮        --1403
		tCell = GetTeachElementById( TeachIdDefine.TEACH_STRENGTHEN , TeachIdDefine.STRENGTHEN_OTHER )
		sDesc = LocalStrings.TEACH_STRENGTHEN_OTHER				--"选择强化所需道具"
		nDirection = CellDialog.DIR_DOWN
		TeachStrengthen.INDEX = 1403
		 icon = "common/animation/button_8_an.png"
		dirPt = GlobalMethod:ccp(-100 , 0)
		size = GlobalMethod:CCSize(-60 , 60)
		pt = GlobalMethod:ccp(-19.6 , 0)
	elseif nId == TeachStrengthen.STRENGTHEN_OTHER_ITEM  then	--其他物品栏物品        --1404
		tCell = GetTeachElementById( TeachIdDefine.TEACH_STRENGTHEN , TeachIdDefine.STRENGTHEN_OTHER_ITEM  )
		sDesc = LocalStrings.TEACH_STRENGTHEN_SELECTSTONE		--"选择强化石"
		icon = "common/animation/7_an.png"
		nDirection = CellDialog.DIR_LEFT
		TeachStrengthen.INDEX = 1404
		dirPt = GlobalMethod:ccp( 40 , 0 )
		--size = GlobalMethod:CCSize(72 , 72)
	elseif nId == TeachStrengthen.STRENGTHEN_START then			--强化按钮              --1405
		tCell = GetTeachElementById( TeachIdDefine.TEACH_STRENGTHEN , TeachIdDefine.STRENGTHEN_START )
		sDesc = LocalStrings.TEACH_STRENGTHEN_START				--"恭喜，强化成功！战斗力大幅提升"
		nDirection = CellDialog.DIR_UP
		TeachStrengthen.INDEX = 1405
		dirPt = GlobalMethod:ccp( -18 , 0 )
		size = GlobalMethod:CCSize(73 , 77)
	elseif nId == TeachStrengthen.STRENGTHEN_CLOSE then			--强化关闭按钮          --1406
		tCell = GetTeachElementById( TeachIdDefine.TEACH_STRENGTHEN , TeachIdDefine.STRENGTHEN_CLOSE )
		sDesc = LocalStrings.TEACH_STRENGTHEN_CLOSE				--"强化完成，返回大厅："
		nDirection = CellDialog.DIR_DOWN
		TeachStrengthen.INDEX = 1406
		icon = "common/animation/close_an.png"
		dirPt = GlobalMethod:ccp( -30 , 4 )
		size = GlobalMethod:CCSize(35 , 48)
	end
	WZLog("tCell::::::" , tCell)
	self:_setFadeIcon( icon )
	self:_checktCell( tCell )
	return tCell , sDesc , nDirection , isIsland , dirPt , size , pt
end

--@brief	获取下一步的新手教学的步骤编号
--@param	nStep：当前新手教学的步骤编号
--@return	num：返回下一步新手教学的步骤编号
function TeachStrengthen:_getTeachStep( nStep )
	local num = nil
	if nStep == 0 then
		num = 1004
	elseif nStep == 1004 then
		num = 1401
	elseif nStep == 1401 then
		num = 1402
	elseif nStep == 1402 then
		num = 1403
	elseif nStep == 1403 then
		num = 1404
	elseif nStep == 1404 then
		num = 1405
	elseif nStep == 1405 then
		num = 1406
	elseif nStep == 1406 then
		num = 1407
	end
	return num
end

--@brief	设置发光图片
function TeachStrengthen:_setFadeIcon( icon )
	TeachStrengthen.ICON = icon
end

--@brief	添加强化石
function TeachStrengthen:_selectStone( nStone , nSuccessRate )
	if nStone == nil or nStone == 0 then
		Teach:removeTeachElement()
		TeachStrengthen.STONENUM = 1
		TeachStrengthen.INDEX = nil
	elseif TeachStrengthen.STONENUM < nStone and TeachStrengthen.STONENUM <= 3 then
		TeachStrengthen.STONENUM = TeachStrengthen.STONENUM + 1
		if nSuccessRate < 100 then
			TeachStrengthen.INDEX = TeachStrengthen.INDEX - 1
			return TeachStrengthen.INDEX
		end
	end
end

--@brief	教学按钮发光效果
--@param	tCell：发光节点
--@param	icon：图片路径
function TeachStrengthen:_showShineAction( tCell , icon , dir , pt)
	if tCell == nil or icon == nil then
		return
	end
	dir = dir or GlobalMethod:CCSize( 10 , 10 )
	local order = tCell:getZOrder() - 2
	local size = tCell:getContentSize()
	local reSize = tCell:getRelativeSize()
	local pos = tCell:getRelativePosition()
	local w = reSize.width + dir.width / size.width
	local h = reSize.height + dir.height / size.height
	WZLog("tCell::::size0::::" , pos.x , pos.y )
	if pt then
		pos = GlobalMethod:ccp( pos.x + pt.x / size.width , pos.y + pt.y / size.height )
	end
	--创建发光图片
	local con = WZUIContainer:create()
	con:setRelativePosition( pos )
	con:setRelativeSize( GlobalMethod:CCSize( w , h ) )
	con:setZOrder( order )
	local img = WZUI9Image:create()
	img:setFile( icon )
	con:addChild( img )
	Teach.CONFLARE = con 
	--创建发光
	Teach:_createShineAction( img )
	tCell:getParentElement():addChild( con )
	return con , img
end

--@brief	开始自动完成新手教学教程定时器
function TeachStrengthen:_startSchedule( element )
	if TeachStrengthen.INDEX ~= TeachStrengthen.ISLAND_STRENGTHEN then
		element:enableSchedule("scheduleCompleteTeach" , Teach.SCHEDULETIME )
	end
end

--@brief	检查节点是否存在
function TeachStrengthen:_checktCell( tCell )
	if tCell == nil then
		WZLog("tCell:::is nil::::::")
		Teach:removeTeachElement()
		TeachStrengthen.STONENUM = 1
		TeachStrengthen.INDEX = nil
	end
end

-------------------------------------私有方法模块End----------------------------------------














--BattleMapManager.lua
--@brief	战斗地图的管理
--@date  	2013/12/26
--@author 	Zjh
--@note 	战斗地图的管理


BattleMapManager =
{
	--pixel的宽度
	m_nWidth,

	--pixel的高度
	m_nHeight,

	--发射线的颜色
	m_tPointColor =
	{
		r = 0,
		g = 0,
		b = 0,
	},

	--背景图
	m_tBgImg =
	{
		--大小
		nWidth,
		nHeight,
		--图片集
		tImgs =
		{
			--数组里的键值示例
			[-1] =
			{
				--图片路径
				sImgPath,
				--坐标
				nPosX,
				nPosY,
			}
		},
		tControl,--屏幕控制器
	},

	--中景图
	m_tMidImg =
	{
		--大小
		nWidth,
		nHeight,
		--图片集
		tImgs =
		{
			--数组里的键值示例
			[-1] =
			{
				--图片路径
				sImgPath,
				--坐标
				nPosX,
				nPosY,
			}
		},
		tControl,--屏幕控制器
	},

	--前景图
	m_tFrontImg =
	{
		--数组里的键值示例
		[-1] =
		{
			--图片路径
			sImgPath,
			--位图路径
			sBytePath,
			--坐标
			nPosX,
			nPosY,
			--破坏类型
			nBreakType,
			--图片大小
			nWidth,
			nHeight,
		},
		tControl,--屏幕控制器
	},

	--雾图
	m_tFogImg =
	{
		--数组里的键值示例
		[-1] =
		{
			--图片路径
			sImgPath,
			--位图路径
			sBytePath,
			--坐标
			nPosX,
			nPosY,
			--破坏类型
			nBreakType,
			--图片大小
			nWidth,
			nHeight,
		},
		tControl,--屏幕控制器
	},

	--出生坐标点集
	m_tPositions =
	{
		--数组里的键值示例
		[-1] =
		{
			nPosX,
			nPosY,
		}
	},
	--C++类
	m_pixelSprites = nil,
	m_pixelByte = nil,
	m_fogpixelSprites = nil,
}

BattleMapManager.ENUM =
{
	--BreakType
	NOBREAK = 0,
	BREAK = 1,
	--MapOrder
	FRONT_ORDER = 5,
	BG_ORDER = 4,
	MID_ORDER = 4,
	--Path
	DEF_BATTLE_IMG_PATH = "battle/map/",
	DEF_BATTLE_FILE_PATH = "image/battle/map/",
	--MIN MAX
	MAX_SIZE = 65535,
	MIN_SIZE = -65536,
}

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	加载地图到内存
--@param 	sMapId:地图ID
--@return 	是否成功
--@note		将地图信息读入到table表
function BattleMapManager:loadMap(sMapId)
	WZLog("BattleMapManager:startLoadMap",sMapId)
    if tonumber(sMapId) < 1 then
        sMapId = "58"
    end

    if ProjConfig.DEBUG == 1 and WBattleGlobal:getCurrent():isEscapeBattle() then
		sMapId = "134"
	end

	self:clear()

	WZLog("startGetMapXML")

	local xmlString = BattleUtil:getMapXML(self.ENUM.DEF_BATTLE_FILE_PATH.."map"..sMapId..".map")

	WZLog("endGetMapXML")

	local xmlDoc = WZLuaXmlDocument:create(xmlString)

	if xmlDoc == nil then
		return false
	end

	local rootElement = xmlDoc:getRootElement()

	self.m_tPointColor.r = tonumber(rootElement:attributeString("r"))
	self.m_tPointColor.g = tonumber(rootElement:attributeString("g"))
	self.m_tPointColor.b = tonumber(rootElement:attributeString("b"))
	self.m_nWidth = tonumber(rootElement:attributeString("pixelWidth"))
	self.m_nHeight = tonumber(rootElement:attributeString("pixelHeight"))

	self.m_tBgImg.nWidth = tonumber(rootElement:attributeString("bgWidth"))
	self.m_tBgImg.nHeight = tonumber(rootElement:attributeString("bgHeight"))

	self.m_tMidImg.nWidth = tonumber(rootElement:attributeString("midWidth"))
	self.m_tMidImg.nHeight = tonumber(rootElement:attributeString("midHeight"))
	
	--背景图部分
	WZLog("BgImg",self.m_nWidth,self.m_nHeight,self.m_tBgImg.nWidth,self.m_tBgImg.nHeight,self.m_tMidImg.nWidth,self.m_tMidImg.nHeight)

	self.m_tBgImg.tImgs = {}
	local element = rootElement:findChildElement("background_img")
	while element do
		local cell = {}
		cell.sImgPath = self.ENUM.DEF_BATTLE_IMG_PATH .. element:attributeString("img")
		cell.nPosX = tonumber(element:attributeString("x"))
		cell.nPosY = tonumber(element:attributeString("y"))
		cell.nScale = 1.0 
		if element:existAttribute("scale") then 
			cell.nScale = tonumber(element:attributeString("scale"))
		end
		

		table.insert(self.m_tBgImg.tImgs,cell)

		element = element:nextSiblingElement("background_img")
	end

	--中景图部分
	self.m_tMidImg.tImgs = {}
	local element = rootElement:findChildElement("mid_img")
	while element do
		local cell = {}
		cell.sImgPath = self.ENUM.DEF_BATTLE_IMG_PATH .. element:attributeString("img")
		cell.nPosX = tonumber(element:attributeString("x"))
		cell.nPosY = tonumber(element:attributeString("y"))
		if element:existAttribute("scale") then 
			cell.nScale = tonumber(element:attributeString("scale"))
		end
		table.insert(self.m_tMidImg.tImgs,cell)

		element = element:nextSiblingElement("mid_img")
	end

	--前景图部分
	self.m_tFrontImg = {}
	local element = rootElement:findChildElement("pixel_img")
	while element do
		local cell = {}
		cell.sImgPath = self.ENUM.DEF_BATTLE_IMG_PATH .. element:attributeString("img")
		cell.nPosX = tonumber(element:attributeString("x"))
		cell.nPosY = tonumber(element:attributeString("y"))
        cell.bFlipX = false
        cell.bFlipY = false
		if element:existAttribute("break_data") then
			cell.sBytePath = self.ENUM.DEF_BATTLE_IMG_PATH .. element:attributeString("break_data")
			cell.nWidth = tonumber(element:attributeString("w"))
			cell.nHeight = tonumber(element:attributeString("h"))
            if element:existAttribute("flip_x") and element:existAttribute("flip_y") then
                cell.bFlipX = element:attributeString("flip_x") == "true"
                cell.bFlipY = element:attributeString("flip_y") == "true"
            end
		else
			cell.sBytePath = ""
			cell.nWidth = 0
			cell.nHeight = 0
		end

		cell.nBreakType = tonumber(element:attributeString("break_type"))

		table.insert(self.m_tFrontImg,cell)

		element = element:nextSiblingElement("pixel_img")
	end

	--出生坐标
	self.m_tPositions = {}
	local element = rootElement:findChildElement("point")
	while element do
		local cell = {}
		cell.nPosX = tonumber(element:attributeString("x"))
		cell.nPosY = tonumber(element:attributeString("y"))

		table.insert(self.m_tPositions,cell)

		element = element:nextSiblingElement("point")
	end

	WZLog(Serialize(BattleMapManager.m_tPositions))


	--雾图部分
	if WBattleGlobal:getCurrent():isFog() then
		local xmlString2 = BattleUtil:getMapXML(self.ENUM.DEF_BATTLE_FILE_PATH.."map9998.map")
		local xmlDoc2 = WZLuaXmlDocument:create(xmlString2)
		if xmlDoc2 == nil then
			return false
		end
		local rootElement2 = xmlDoc2:getRootElement()
		self.m_tFogImg = {}
		local element = rootElement2:findChildElement("pixel_img")
		while element do
			local cell = {}
			cell.sImgPath = self.ENUM.DEF_BATTLE_IMG_PATH .. element:attributeString("img")
			cell.nPosX = tonumber(element:attributeString("x"))
			cell.nPosY = tonumber(element:attributeString("y"))
	        cell.bFlipX = false
	        cell.bFlipY = false
			if element:existAttribute("break_data") then
				cell.sBytePath = self.ENUM.DEF_BATTLE_IMG_PATH .. element:attributeString("break_data")
				cell.nWidth = tonumber(element:attributeString("w"))
				cell.nHeight = tonumber(element:attributeString("h"))
	            if element:existAttribute("flip_x") and element:existAttribute("flip_y") then
	                cell.bFlipX = element:attributeString("flip_x") == "true"
	                cell.bFlipY = element:attributeString("flip_y") == "true"
	            end
			else
				cell.sBytePath = ""
				cell.nWidth = 0
				cell.nHeight = 0
			end

			cell.nBreakType = tonumber(element:attributeString("break_type"))

			table.insert(self.m_tFogImg,cell)
			WZLog("load map fog image ",cell.sImgPath,cell.nPosX,cell.nPosY,cell.nWidth,cell.nHeight);
			element = element:nextSiblingElement("pixel_img")
		end

		return true
	end
end

--@brief	获取雾屏幕控制器
--@retrun 	前景屏幕控制器
--@note
function BattleMapManager:getFogControl()
	return self.m_tFogImg.tControl
end

--@brief	获取前景屏幕控制器
--@retrun 	前景屏幕控制器
--@note
function BattleMapManager:getFrontControl()
	return self.m_tFrontImg.tControl
end

--@brief	获取地图位信息
--@retrun 	地图位信息
function BattleMapManager:getPixelByte()
	return self.m_pixelByte
end

--@brief	获取背景屏幕控制器
--@retrun 	背景屏幕控制器
--@note
function BattleMapManager:getMidControl()
	return self.m_tMidImg.tControl
end

--@brief	获取背景屏幕控制器
--@retrun 	背景屏幕控制器
--@note
function BattleMapManager:getBgControl()
	return self.m_tBgImg.tControl
end

--@brief	加入背景图片
--@param 	layer:场景元素
--@note		将背景加入到场景元素中
function BattleMapManager:addBgMap(layer)
	local minX = self.ENUM.MAX_SIZE
	local minY = self.ENUM.MAX_SIZE
	local maxX = self.ENUM.MIN_SIZE
	local maxY = self.ENUM.MIN_SIZE

	local defaultPixelFormat = CCTexture2D:defaultAlphaPixelFormat()
	CCTexture2D:setDefaultAlphaPixelFormat(kTexture2DPixelFormat_RGB565)
	local bg = self.m_tBgImg.tImgs
	for i=1,#bg do
        WZLog("BattleMapManager:addBgMap load ",bg[i].sImgPath)
		local sprite = CCSprite:create(bg[i].sImgPath)
		sprite:setAnchorPoint(GlobalMethod:ccp(0,0))
		sprite:setPosition( bg[i].nPosX , bg[i].nPosY )
		sprite:setScale(bg[i].nScale)
		-- minX = math.min(minX , bg[i].nPosX)
		-- minY = math.min(minY , bg[i].nPosY)
		-- maxX = math.max(maxX , bg[i].nPosX + sprite:getContentSize().width )
		-- maxY = math.max(maxY , bg[i].nPosY + sprite:getContentSize().height )

		layer:addChild(sprite)
        WZLog("BattleMapManager:addBgMap load end ",bg[i].sImgPath)
	end
	CCTexture2D:setDefaultAlphaPixelFormat(defaultPixelFormat)
	
	-- layer:setContentSize(GlobalMethod:CCSize( maxX-minX , maxY-minY ))
	-- layer:setAbsContentSize(GlobalMethod:CCSize( maxX-minX , maxY-minY ))
	layer:setContentSize(GlobalMethod:CCSize( self.m_tBgImg.nWidth , self.m_tBgImg.nHeight ))
	layer:setAbsContentSize(GlobalMethod:CCSize( self.m_tBgImg.nWidth , self.m_tBgImg.nHeight ))
	layer:setZOrder(self.ENUM.BG_ORDER)

	--背景屏幕控制器
	self.m_tBgImg.tControl = BattleScreenControl:create(layer)
	self.m_tBgImg.tControl:setDisableBoundPos(true)
	self.m_tBgImg.tControl:setZoomOutInit(self.m_tBgImg.tControl:getOptimalZoomOutLimit(1))
	-- if self.m_tBgImg.tControl:getZoomOutInit() < 0.65 then
		-- self.m_tBgImg.tControl:setZoomOutInit(0.65)
	-- end
	self.m_tBgImg.tControl:setZoomInInit(100)
end

--@brief	加入中景图片
--@param 	layer:场景元素
--@note		将中景加入到场景元素中
function BattleMapManager:addMidMap(layer)

	local mg = self.m_tMidImg.tImgs
	
	local defaultPixelFormat = CCTexture2D:defaultAlphaPixelFormat()
	local bg = self.m_tBgImg.tImgs
	if #bg <= 0 then 
		CCTexture2D:setDefaultAlphaPixelFormat(kTexture2DPixelFormat_RGB565)
	end
	for i=1,#mg do
        WZLog("BattleMapManager:addMidMap load ",mg[i].sImgPath)
		local sprite = CCSprite:create(mg[i].sImgPath)
		sprite:setAnchorPoint(GlobalMethod:ccp(0,0))
		sprite:setPosition( mg[i].nPosX , mg[i].nPosY )
		sprite:setScale(mg[i].nScale)
		layer:addChild(sprite)
        WZLog("BattleMapManager:addMidMap load end ",mg[i].sImgPath)
	end
	CCTexture2D:setDefaultAlphaPixelFormat(defaultPixelFormat)
	
	layer:setContentSize(GlobalMethod:CCSize( self.m_tMidImg.nWidth , self.m_tMidImg.nHeight ))
	layer:setAbsContentSize(GlobalMethod:CCSize( self.m_tMidImg.nWidth , self.m_tMidImg.nHeight ))
	layer:setZOrder(self.ENUM.MID_ORDER)

	self.m_tMidImg.tControl = BattleScreenControl:create(layer)
	self.m_tMidImg.tControl:setDisableBoundPos(true)
	self.m_tMidImg.tControl:setZoomOutInit(self.m_tMidImg.tControl:getOptimalZoomOutLimit(1))
	-- if self.m_tMidImg.tControl:getZoomOutInit() < 0.65 then
		-- self.m_tMidImg.tControl:setZoomOutInit(0.65)
	-- end
	self.m_tMidImg.tControl:setZoomInInit(100)
end

--@brief	加入前景图片
--@param 	layer:场景元素
--@note		将前景加入到场景元素中
function BattleMapManager:addFrontMap(layer)

	local fg = self.m_tFrontImg

	layer:setContentSize(GlobalMethod:CCSize( self.m_nWidth , self.m_nHeight ))
	layer:setAbsContentSize(GlobalMethod:CCSize( self.m_nWidth , self.m_nHeight ))
	WZLog("BattleMapManager:addFrontMap", self.m_nWidth , self.m_nHeight)
	--前景屏幕控制器
	self.m_tFrontImg.tControl = BattleScreenControl:create(layer)
	self.m_tFrontImg.tControl:setZoomOutInit(self.m_tFrontImg.tControl:getOptimalZoomOutLimit())
	self.m_tFrontImg.tControl:setZoomInInit(1)
	--[[if self.m_tFrontImg.tControl:getZoomOutInit() < 0.65 then
		self.m_tFrontImg.tControl:setZoomOutInit(0.65)
	end--]]

	self.m_pixelSprites = CCArray:create()

	self.m_pixelSprites:retain()

	for i=1,#fg do
        local cell = fg[i]
        local filePath = fg[i].sImgPath
        if WDSprite.isSupportFlip ~= nil and WDSprite:isSupportFlip() then 
            if cell.bFlipX == true and cell.bFlipY == true then 
                filePath = filePath .. "xy"
            elseif cell.bFlipX == true then 
                filePath = filePath .. "x"
            elseif cell.bFlipY == true then 
                filePath = filePath .. "y"
            end
        end
        WZLog("BattleMapManager:addFrontMap load ", self.m_tFrontImg.tControl:getZoomOutInit(), filePath)
		local sprite = WDSprite:create(filePath , fg[i].sBytePath , GlobalMethod:CCSize( fg[i].nWidth , fg[i].nHeight ) , fg[i].nBreakType == 1 )

		sprite:setAnchorPoint(GlobalMethod:ccp(0,0))
		sprite:setPosition( fg[i].nPosX , fg[i].nPosY )

		self.m_pixelSprites:addObject(sprite)
		layer:addChild(sprite,-2)
        WZLog("BattleMapManager:addFrontMap load end ",filePath)
	end

	layer:setZOrder(self.ENUM.FRONT_ORDER)

	self.m_pixelByte = WDByte:create()
	self.m_pixelByte:retain()
	self.m_pixelByte:init(self.m_pixelSprites)
end

--@brief	加入雾图片
--@param 	layer:场景元素
--@note		将雾加入到场景元素中
function BattleMapManager:addFogMap(layer)

	local fg = self.m_tFogImg

	layer:setContentSize(GlobalMethod:CCSize( 2304 , 1800 ))
	layer:setAbsContentSize(GlobalMethod:CCSize( 2304 , 1800 ))
	WZLog("BattleMapManager:addFogMap", self.m_nWidth , self.m_nHeight)
	--雾屏幕控制器
	self.m_tFogImg.tControl = BattleScreenControl:create(layer )
	self.m_tFogImg.tControl:setZoomOutInit(BattleMapManager:getFrontControl():getZoomOutInit())--self.m_tFogImg.tControl:getOptimalZoomOutLimit())
	self.m_tFogImg.tControl:setZoomInInit(1)
	--[[if self.m_tFogImg.tControl:getZoomOutInit() < 0.65 then
		self.m_tFogImg.tControl:setZoomOutInit(0.65)
	end--]]

	self.m_fogpixelSprites = CCArray:create()

	self.m_fogpixelSprites:retain()
	local defaultPixelFormat = CCTexture2D:defaultAlphaPixelFormat()
	CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA8888)
	-- if self:isNew() and getTotalMemory() <= 1536 then 
		-- CCTexture2D:setDefaultAlphaPixelFormat(kCCTexture2DPixelFormat_RGBA4444)
	-- end
	for i=1,#fg do
        local cell = fg[i]
        local filePath = fg[i].sImgPath
        if WDSprite.isSupportFlip ~= nil and WDSprite:isSupportFlip() then 
            if cell.bFlipX == true and cell.bFlipY == true then 
                filePath = filePath .. "xy"
            elseif cell.bFlipX == true then 
                filePath = filePath .. "x"
            elseif cell.bFlipY == true then 
                filePath = filePath .. "y"
            end
        end
        WZLog("BattleMapManager:addFogMap load ", self.m_tFogImg.tControl:getZoomOutInit(),filePath,cell.nPosX,cell.nPosY,cell.nWidth,cell.nHeight)
		local sprite = WDSprite:create(filePath , fg[i].sBytePath , GlobalMethod:CCSize( fg[i].nWidth , fg[i].nHeight ) , fg[i].nBreakType == 1 )		
		sprite:setAnchorPoint(GlobalMethod:ccp(0,0))
		sprite:setPosition( fg[i].nPosX , fg[i].nPosY )
		
		self.m_fogpixelSprites:addObject(sprite)
		SceneBattle:getFogLayer2():addChild(sprite,-2)
        WZLog("BattleMapManager:addFogMap load end ",filePath)
	end
	CCTexture2D:setDefaultAlphaPixelFormat(defaultPixelFormat)

	--layer:setScale(2)
end

--@brief	重载地图纹理
--@note		当纹理被释放,需要重新加载时候调用
function _updateTexture_BattleMapManager()
	WZLog("_updateTexture_BattleMapManager")
	local self = BattleMapManager
	if self.m_pixelSprites then
		for i=0,self.m_pixelSprites:count()-1 do
			tolua.cast(self.m_pixelSprites:objectAtIndex(i),"WDSprite"):updateImgToTexture()
		end
	end

	if self.m_fogpixelSprites then
		for i=0,self.m_fogpixelSprites:count()-1 do
			tolua.cast(self.m_fogpixelSprites:objectAtIndex(i),"WDSprite"):updateImgToTexture()
		end
	end
end

--@brief	清除内存数据
--@note		退出/重载时候调用
function BattleMapManager:clear()
	if self.m_pixelSprites then
		self.m_pixelSprites:release()
	end
	self.m_pixelSprites = nil

	if self.m_pixelByte then
		self.m_pixelByte:release()
	end

	self.m_pixelByte = nil

	if self.m_fogpixelSprites then
		self.m_fogpixelSprites:release()
	end
	self.m_fogpixelSprites = nil
end


--@brief   重新加载地图数据
function BattleMapManager:reload()
    if self.m_pixelSprites then
		for i=0,self.m_pixelSprites:count()-1 do
			tolua.cast(self.m_pixelSprites:objectAtIndex(i),"WDSprite"):reload()
		end
        if self.m_pixelByte then
            self.m_pixelByte:init(self.m_pixelSprites)
        end
	end

	if self.m_fogpixelSprites then
		for i=0,self.m_fogpixelSprites:count()-1 do
			tolua.cast(self.m_fogpixelSprites:objectAtIndex(i),"WDSprite"):reload()
		end
	end
end
------碰撞相关

--@brief	描绘爆炸
--@param 	point:爆破点
--@param 	lpBreakCircle:爆破纹理
--@param 	lpBreakCircleMark:爆破圈
--@param 	digHoleDir:挖坑的方向
--@return 	是否爆炸成功(物理本身不能爆炸也算失败)
--@note		包括物理层和表现层的改变
function BattleMapManager:drawBroke(point,lpBreakCircle,lpBreakCircleMark,nBreakWidth,nBreakHeight,isMapErosion, digHoleDir)
	if nBreakWidth and nBreakHeight and (nBreakWidth <= 0 or nBreakHeight <= 0) then 
        return true
    end
    if isMapErosion == nil and (nBreakWidth > 2000 or nBreakHeight > 2000) then
        MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, NetManager, NetManager.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil)
        return true
    end
	WZLog("BattleMapManager:drawBroke", point.x, point.y, nBreakWidth, nBreakHeight, point.y - nBreakHeight/2, digHoleDir, self.m_pixelSprites and self.m_pixelSprites:count() or "nil")
	if digHoleDir and digHoleDir == 1 then 
		point.y = point.y + nBreakHeight * 10/65
	elseif digHoleDir and digHoleDir == 2 then 
		point.y = point.y - nBreakHeight * 10/65
	elseif digHoleDir and digHoleDir == 3 then 
		point.x = point.x - nBreakWidth * 10/65
	elseif digHoleDir and digHoleDir == 4 then 
		point.x = point.x + nBreakWidth * 10/65
	end
    if self.m_pixelByte then
		if nBreakWidth and nBreakHeight then
			if self.m_pixelByte:drawBroke(point,lpBreakCircleMark,nBreakWidth,nBreakHeight) == false then
				return false
			end
		else
			if self.m_pixelByte:drawBroke(point,lpBreakCircleMark) == false then
				return false
			end
		end
	end
	if self.m_pixelSprites and self.m_pixelSprites:count() > 0 then
		for i=0,self.m_pixelSprites:count()-1 do
			if nBreakWidth and nBreakHeight then
				tolua.cast(self.m_pixelSprites:objectAtIndex(i),"WDSprite"):drawBroke(point,lpBreakCircle,lpBreakCircleMark,nBreakWidth,nBreakHeight)
			else
				tolua.cast(self.m_pixelSprites:objectAtIndex(i),"WDSprite"):drawBroke(point,lpBreakCircle,lpBreakCircleMark )
			end
		end
	end
	return true
end

--@brief	--是否新版本
function BattleMapManager:isNew()
	return true and tolua.cast(self.m_pixelSprites:objectAtIndex(0),"WDSprite").drawBrokeWithAlpha ~= nil
end

--@brief	描绘雾爆炸
--@param 	point:爆破点
--@param 	lpBreakCircle:爆破纹理
--@param 	lpBreakCircleMark:爆破圈
--@return 	是否爆炸成功
--@note		表现层的改变
function BattleMapManager:fogDrawBroke(point,lpBreakCircle,lpBreakCircleMark,nBreakWidth,nBreakHeight,isMapErosion, isWithAlpha)
	if nBreakWidth and nBreakHeight and (nBreakWidth <= 0 or nBreakHeight <= 0) then 
        return true
    end
    if isMapErosion == nil and (nBreakWidth > 1500 or nBreakHeight > 1500) then
        MsgBoxManager:showConfirmBox(LocalStrings.NETWORK_UNAVAILABLE, NetManager, NetManager.networkUnavailableTipCallback, MSGBOXLEVEL_HIGH, nil)
        return true
    end


	if self.m_fogpixelSprites and self.m_fogpixelSprites:count() > 0 then
		isWithAlpha = isWithAlpha and self:isNew()
		for i=0,self.m_fogpixelSprites:count()-1 do
			if nBreakWidth and nBreakHeight then
				if isWithAlpha then
					tolua.cast(self.m_fogpixelSprites:objectAtIndex(i),"WDSprite"):drawBrokeWithAlpha(point,lpBreakCircle,lpBreakCircleMark,nBreakWidth,nBreakHeight)
				else
					tolua.cast(self.m_fogpixelSprites:objectAtIndex(i),"WDSprite"):drawBroke(point,lpBreakCircle,lpBreakCircleMark,nBreakWidth,nBreakHeight)
				end
			else
				if isWithAlpha then
					tolua.cast(self.m_fogpixelSprites:objectAtIndex(i),"WDSprite"):drawBrokeWithAlpha(point,lpBreakCircle,lpBreakCircleMark, 0, 0 )
				else
					tolua.cast(self.m_fogpixelSprites:objectAtIndex(i),"WDSprite"):drawBroke(point,lpBreakCircle,lpBreakCircleMark )
				end
			end
		end
	end
	return true
end

--@brief	检测碰撞
--@param 	mover:移动对象
--@param 	isNormal:
--@param 	lpBreakCircleMark:爆破圈(没有的时候设为nil)
--@return 	#1 bool,是否产生碰撞
--@return 	（如果有碰撞）#2 Vector2,新位置
--@return 	（如果有碰撞）#3 Vector2,斜率向量
--@note		包括碰撞后的属性变化更新
function BattleMapManager:checkCollision(mover,isNormal,lpBreakCircleMark)
	isNormal = isNormal or false
	local ccArray
	if self.m_pixelByte == nil then
		return false
	end
	if lpBreakCircleMark then
		ccArray = self.m_pixelByte:checkCollision(mover,lpBreakCircleMark,isNormal)
	else
		ccArray = self.m_pixelByte:checkCollision(mover,isNormal)
	end
	local isCollision = tolua.cast( ccArray:objectAtIndex(0) ,"CCBool"):getValue()
	--if isCollision == false then
	--	return isCollision
	--else
	local newPos = tolua.cast( ccArray:objectAtIndex(1) ,"Vector2")
	local tangent = tolua.cast( ccArray:objectAtIndex(2) ,"Vector2")

	return isCollision,newPos,tangent
	--end
end

--@brief	判断给定区域是否为空
--@param 	x: x坐标
--@param 	x: y坐标
--@param 	width:宽
--@param 	height:高
--@param 	step:步长
--@return 	#1 bool,true 是空的 false 非空
--@note		判断给定区域是否为空
function BattleMapManager:isEmptyPixel( x, y, width, height, step)
    if self.m_pixelByte == nil then return true end
    if self.m_pixelByte.isEmptyPixel == nil then return true end
    return self.m_pixelByte:isEmptyPixel(x, y, width, height, step)
end

function BattleMapManager:showExploder()
	local layer = CCLayerColor:create(ccc4(255,255,255,80),256,256)
	layer:setTag(10000)
	layer:setPositionX(100)
    layer:setPositionY(100)
	WndBattleHud.m_root:removeChildByTag(10000,true)
	WndBattleHud.m_root:addChild(layer)

	local sp = WDExplodeHole:currentInstance():getSprite(-1)
	sp:setPositionX(128)
    sp:setPositionY(128)
	sp:setAnchorPoint(GlobalMethod:ccp(0,0))
	layer:addChild(sp)

	local x = 0
	local y = 0
	for i = 1,30 do
		sp = WDExplodeHole:currentInstance():getSprite(i)
		if y + sp:getContentSize().height > 256 then
				y = 0
				x = x + 30
		end
		sp:setPositionX(x)
        sp:setPositionY(y)
		sp:setAnchorPoint(GlobalMethod:ccp(0,0))
		layer:addChild(sp)
		y = y + sp:getContentSize().height + 10
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


-------------------------------------私有方法模块End----------------------------------------





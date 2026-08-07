--SceneTeachBattle.lua
--@brief	SceneTeachBattle的UI模块
--@date		2013/2/24
--@author	Zjh
--@note		战斗教学界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneTeachBattle:onEnter(element)
	SoundManager:playBgMusic(SoundDefine.E_MUSIC_BATTLE)
	self.m_root = element

	self.m_root:enableSchedule("loop",0)	--开启循环定时器

	self.m_root:getChildElement("multiTouchPanel_SceneTeachBattle"):addChild(WndTeachBattleHud:createElement())

	self:_initShowFront()

	WndTeachBattleHud:setWindLevel({x=0,y=0})

	WndTeachBattleHud:setWindVisible(true)

	WndTeachBattleHud:setMyHero(TeachBattle:getMyHero())

	TeachBattle:getMyHero():getShopAnimation():setPosition(GlobalMethod:ccp(200,50))

	if GlobalGame.g_tSysConfig.openNewTeach == false then
		GetElement(self.m_root,"conSkip_SceneTeachBattle"):setVisible(false)
	end
	
	TeachBattle:startTeachStep()

	CCDirector:sharedDirector():setAnimationInterval(1.0/60)

    --炮弹缓存
    ---[[
    self.m_tBulletCache = {}
    local bulletExplodeElement = nil
    do
        bulletExplodeElement = TeachBattle:buildWeaponExplodeElement(nil, TeachBattle:getMyHero():getWeaponName())
        if bulletExplodeElement ~= nil then
            bulletExplodeElement:retain()
            table.insert(self.m_tBulletCache, bulletExplodeElement)
        end
    end
    --]]

    --第三方渠道登陆icon显示
    if GlobalGame.g_bIfInTeaching == false then
        if curSdkObj then
            curSdkObj:setCallbackByName("logout",PassportDefaultCallback.logoutCallback,PassportDefaultCallback)
                if config.SDKOtherConfig.isShowIcon == "true" then
                WZLog("show icon test fc")
                --self.m_showIcon = {}
                --self.m_showIcon.funcode = "showIcon"
                --local sJson = json.encode(self.m_showIcon)
                --curSdkObj:accountOthers( sJson,nil,nil);

            end
        end
    end

end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneTeachBattle:onExit(element)

    if self.m_tBulletCache ~= nil then
        for i, v in pairs(self.m_tBulletCache) do
            if v ~= nil then
                v:release()
            end
        end
    end

	self:_unInit()
	CCDirector:sharedDirector():setAnimationInterval(1.0/30)
end

--@brief	初始化
--@note		进入战斗界面前的所有初始化
function SceneTeachBattle:init()
	self:_initMap()							--加载地图

	self.m_loop = TeachBattleLoop:create()		--生成循环功能

	self.m_touch = BattleTouch:create()		--生成触摸管理功能

	self.m_pointsLine = BattlePointsLine:create(self:getTopInfoLayer(), 20)

	self:getFrontLayer():addChild(TeachBattle:getBoss():getAnimation():getAnimNode())
	self:getFrontLayer():addChild(TeachBattle:getMyHero():getAnimation():getAnimNode())
end

--@brief	每帧循环处理函数
--@param	element:定时器绑定对象
--@param	dt:定时器间隔
--@note		定时器回调
function SceneTeachBattle:loop(element,dt)
	if self.m_loop ~= nil then
		self.m_loop:update(dt)
	end
end

------获取元素

--@brief	获取背景Layer
--@return	背景Layer
--@note
function SceneTeachBattle:getBgLayer()
	return WZUIContainer:luaTo(GetElement(self.m_root,"conBgLayer_SceneTeachBattle"))
end

--@brief	获取中景Layer
--@return	中景Layer
--@note
function SceneTeachBattle:getMidLayer()
	return WZUIContainer:luaTo(GetElement(self.m_root,"conMidLayer_SceneTeachBattle"))
end

--@brief	获取前景Layer
--@return	前景Layer
--@note
function SceneTeachBattle:getFrontLayer()
	return WZUIContainer:luaTo(GetElement(self.m_root,"conFrontLayer_SceneTeachBattle"))
end

--@brief	获取信息层Layer
--@return	信息层Layer
--@note		存放一些不会变化位置的信息内容
function SceneTeachBattle:getInfoLayer()
	return WZUIContainer:luaTo(GetElement(self.m_root,"conInfoLayer_SceneTeachBattle"))
end

--@brief	获取Top信息层Layer
--@return	Top信息层Layer
--@note		存放一些信息在整个场景的最上层
function SceneTeachBattle:getTopInfoLayer()
	return WZUIContainer:luaTo(GetElement(self.m_root,"conTopInfoLayer_SceneTeachBattle"))
end

--@brief	获取BattleLoop
--@return	BattleLoop
--@note
function SceneTeachBattle:getBattleLoop()
	return self.m_loop
end

--@brief	获取BattleTouch
--@return	BattleTouch
--@note
function SceneTeachBattle:getBattleTouch()
	return self.m_touch
end

--@brief	获取BattlePointsLine
--@return	BattlePointsLine
--@note		抛物线
function SceneTeachBattle:getBattlePointsLine()
	return self.m_pointsLine
end
------触摸回调

--@brief	触摸面板Began回调
--@param	element:回调绑定的UI节点引用
--@param	point：触摸点
--@param	nIdx：触摸点id
--@note
function SceneTeachBattle:onTouchBegan(element, point,nIdx)
	if self.m_touch then
		self.m_touch:onTouchBegan(element, point,nIdx)
	end
end

--@brief	触摸面板Moved回调
--@param	element:回调绑定的UI节点引用
--@param	point：触摸点
--@param	nIdx：触摸点id
--@note
function SceneTeachBattle:onTouchMoved(element, point,nIdx)
	if self.m_touch then
		self.m_touch:onTouchMoved(element, point,nIdx)
	end
end

--@brief	触摸面板End回调
--@param	element:回调绑定的UI节点引用
--@param	point：触摸点
--@param	nIdx：触摸点id
--@note
function SceneTeachBattle:onTouchEnd(element, point,nIdx)

	if self.m_touch then
		self.m_touch:onTouchEnd(element, point,nIdx)
	end
end

--@brief	SKIP回调
function SceneTeachBattle:onEndTeach(sender)
	ProtocolProcessorTeach:send_TASK_TiroStep(TeachBattle.ID_BATTLE, 99 )
	TeachFollowingFiveLevel:afterBlackDragon(99)
end

--@brief	往场景根节点添加元素的方法
--@param	element:要添加的界面元素引用
--@note		这里会修改showAll属性，为了适配不同分辨率，保证界面元素不会变形
--          注: 对于主场景showAll属性已经是true的时候不用修改元素的showAll
--          小岛界面有特殊需求，所以showAll属性为false，需要修改里面元素的showAll属性
function SceneTeachBattle:addChild(element)
    if self.m_root == nil or element == nil then
        return
    end
    element:setShowAll(true)
    self.m_root:addChild(element)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	初始化地图
--@note		加载地图，设置地图界面
function SceneTeachBattle:_initMap()

	BattleMapManager:addBgMap(self:getBgLayer())

	--BattleMapManager:addMidMap(self:getMidLayer())

	BattleMapManager:addFrontMap(self:getFrontLayer())

	self:getInfoLayer():setZOrder(9)

	self.m_root:getChildElement("multiTouchPanel_SceneTeachBattle"):setZOrder(10)

	self:getTopInfoLayer():setZOrder(20)
end

--@brief	进入战斗后的前景调整
--@note
function SceneTeachBattle:_initShowFront()

	--镜头参数初始化
	local dZoom = BattleMapManager:getFrontControl():getZoomInInit() - BattleMapManager:getFrontControl():getZoomOutInit()
	BattleScreen.m_nNormalScale = dZoom * 0.4 + BattleMapManager:getFrontControl():getZoomOutInit()
	BattleScreen.m_nLastScale = BattleScreen.m_nNormalScale

	self:getFrontLayer():setScale(BattleMapManager:getFrontControl():getZoomOutInit())
	BattleMapManager:getFrontControl():centerOnPoint({x = self:getFrontLayer():getContentSize().width/2 , y = 0 })
end

-------------------------------------私有方法模块End----------------------------------------

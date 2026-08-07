--WndFootMarkActive.lua
--@brief	WndFootMarkActive的UI模块
--@date		2017/11/28
--@author	Tianxiang_Xu
--@note		激活足迹界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFootMarkActive:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFootMarkActive:onExit(element)
	FootEffectManager:getInstance():destroy()
    if WndFootMark.initFootLayer and WndFootMark.m_root then
        WndFootMark:initFootLayer()
    else
        SceneCity:initFootLayer()
    end

	self.m_root:disableSchedule()
	self:_unInit()
end

--@brief 	界面加载完成回调
function WndFootMarkActive:onEnterTransitionDidFinish()
	-- body
	local conM = GetElement(self.m_root,"conMountAnim_WndFootMarkActive",WZUIContainer)
	FootEffectManager:getInstance():setFootLayer(conM)
	self:_update()
end

--@brief 	点击确认按钮回调
function WndFootMarkActive:onReturnClick(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndFootMarkActive:_update()
	-- body
	self:_getNewFootMarkAni()
end

--@brief 	获得足迹动画
function WndFootMarkActive:_getNewFootMarkAni()
    SoundManager:playEffectSound(SoundDefine.E_S_GET_DESIGNATION)
    local con = GetElement(self.m_root,"conAniGet_WndFootMarkActive",WZUIContainer)
    con:setVisible(true)

    local conM = GetElement(self.m_root,"conMountAnim_WndFootMarkActive",WZUIContainer)
    self:_createMountAni(conM)

    local txtName = GetElement(self.m_root,"txtMountAniName_WndFootMarkActive",WZUILabelTTF)
    local tBasicInfo = GDatatab_item["id_" .. GDatatab_footmark["id_" .. self.m_nFootMarkId].item_id] 
    if g_curbuy_footmark then
       tBasicInfo = GDatatab_item["id_" .. g_curbuy_footmark]
        g_curbuy_footmark = nil
    end
    txtName:setText(tBasicInfo.name)
    txtName:setColor(QUALITYCOLOR[tBasicInfo.quality])
end

--@brief 	足迹动画
function WndFootMarkActive:_createMountAni(con)
    local sex = CacheCenter:getPlayerInfo().sex == 1 and true or false 
    if con:getChildByTag(99) then con:removeChildByTag(99, true) end

    local head,body = CacheCenter:getHeadAndBodyColor()
    local equipList = CacheCenter:getEquipedDecorationList()
    if CacheCenter:getPlayerInfo().mountsId then 
    	self.m_anim = CreatePlayerFigure(CacheCenter:getPlayerInfo().sex, equipList, "wait", nil, nil, nil, nil, nil, nil, nil, head, body, false)
    	self.m_anim:setMount(CacheCenter:getPlayerInfo().mountsId)
    else
    	self.m_anim = CreatePlayerFigure(CacheCenter:getPlayerInfo().sex, equipList, "wait0", nil, nil, nil, nil, nil, nil, nil, head, body, false)
    end
    local node = self.m_anim:getAnimNode()
    node:setScale(0.6)
    con:addChild(node,0,99)
    con:setScale(0)
    local scaleTo = CCScaleTo:create(0.5,1,1)
    con:runAction(scaleTo)
    self.m_root:enableSchedule("moveAni")
    self.firstPostX = self.m_anim:getPosition().x
end

--@brief 足迹刷新
function WndFootMarkActive:updateFootEffect()
    local pos = self.m_anim:getPosition()
    if not self.m_tOldFootPos then
        self.m_tOldFootPos = pos
    end
    local footId = self.m_nFootMarkId
    local distance = GDatatab_footmark["id_" .. footId] and GDatatab_footmark["id_" .. footId].distance or 40
    if  BattleCommon:pointDis(self.m_tOldFootPos,pos) > distance then
    	WZLog("WndFootMarkActive:updateFootEffect")
        self.m_tOldFootPos = pos
        
        FootEffectManager:getInstance():addEffect(footId, pos, 50, self.m_anim:getAnimNode():getScaleX(),self.m_anim:getAnimNode():getScaleY())
    end
end

--@brief 	跑动
function WndFootMarkActive:moveAni()
	-- body
	if self.m_anim == nil then return end 

	local pos = self.m_anim:getPosition()
	pos.x = pos.x + 10
	if self.m_bIsFirst then 
		self.m_nMoveMaxDis = 200 
		--self.m_anim:setFlipX(true)
		self.m_bIsFirst = false 
		self.m_anim:play(g_tRoleAnitionName[3], true)
	end
	self.m_anim:setPosition(pos)
	self:updateFootEffect()

	if self.m_nMoveMaxDis > 0 then 
		self.m_nMoveMaxDis = self.m_nMoveMaxDis - 10
	else
		self.m_nMoveMaxDis = 400 
		pos.x = self.firstPostX - 200
        WZLog("YYYYYYYYYYY:",pos.x)
		self.m_anim:setPosition(pos)
	end
	
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------
function WndFootMarkActive:_adaptLanguage_ug( )
    GetElement(self.m_root,"txtConfirm_WndFootMarkActive",WZUILabelTTF):setScale(0.6)
end
-------------------------------------语言适配End----------------------------------------

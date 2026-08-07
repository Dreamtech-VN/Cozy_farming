--WndOwnCityData.lua
--@brief	WndOwnCity的数据模块
--@date		2015/2/11
--@author	莫剑峰
--@note		主城UI
WndOwnCity = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndOwnCity:_init()
    WZLog("WndOwnCity:_init")
	self.m_root = nil	 	  			--场景根节点
	self.m_tBtnsInfo = nil              --按钮信息
	self.m_tBtnWelInfo = nil 			--福利按钮信息
	self.m_bIsOpenAward = false 		--奖励按钮是否开放
	self.m_bIsOpenVip = false 			--Vip按钮是否开放
    self.m_bOnEnter = nil
    self.m_tScene = nil
    self.m_tLeftBtnsInfo = nil
    self.m_nLeftBtnCount = 0
    self.m_nIndexNo = -1
    self.m_bIsUpdateCardWelfare = nil
    self.m_bIsClickWelfare = nil
    self.m_adapter = nil
    self.m_tArmatureCardWelfare = nil
    self.m_tArmatureCardWelfare2 = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndOwnCity:_unInit()
	self.m_root = nil
    self.m_tBtnsInfo = nil
	self.m_tBtnWelInfo = nil 
	self.m_bIsOpenAward = nil 		
	self.m_bIsOpenVip = nil
    self.m_bOnEnter = nil
    self.m_tScene = nil
    self.m_tLeftBtnsInfo = nil
    self.m_nLeftBtnCount = 0
    self.m_nIndexNo = -1
    self.m_bIsUpdateCardWelfare = nil
    self.m_bIsClickWelfare = nil
    self.m_adapter = nil
    self.m_tArmatureCardWelfare = nil
    self.m_tArmatureCardWelfare2 = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndOwnCity:createElement()
	local element = WZUISystem:getInstance():createElement("WndOwnCity")
	assert(element, "WndOwnCity create element failed!")
	self:_init()
	return element
end


--@brief	设置左菜单按钮信息
--@param	tBtnsInfo，按钮信息表
function WndOwnCity:setBtnsInfo(tBtnsInfo,tBtnWelInfo)
    if tBtnsInfo == nil or tBtnWelInfo == nil then 
		WZLog("tBtnsInfo == nil or tBtnWelInfo == nil")
		return 
	end
	self.m_tBtnsInfo = {}
	self.m_tBtnWelInfo = {}

	local num = 0 
	for i,v in ipairs(tBtnWelInfo) do 
		if self:_checkIconButtonOpen(v) and v.IsHighlight == true then 
			num = num +1
		end
	end
	WZLog("WndOwnCity:setBtnsInfo  ",num)
	
	for i,data in ipairs(tBtnsInfo) do
		local temp = {}
		temp.buttonId = data.buttonId
		temp.buttonType = data.buttonType
		temp.IsHighlight = data.IsHighlight
		temp.buttonSort = data.buttonSort
		temp.buttonStatus1Level = data.buttonStatus1Level
		temp.buttonStatus2Level = data.buttonStatus2Level
		temp.buttonStatus3Level = data.buttonStatus3Level
		if temp.buttonId == ISLAND_LEFT_AWARD then 
			temp.buttonSort = 1
		elseif temp.buttonId == ISLAND_LEFT_WELFARE then
			temp.buttonSort = 2 
			if num >0 then 
				temp.IsHighlight = true
			end
		elseif temp.buttonId == ISLAND_RIGHT_VIP then
			temp.buttonSort = 3 
		end
		table.insert(self.m_tBtnsInfo,temp)
	end
	
	
	self.m_tBtnWelInfo = tBtnWelInfo
    self:_update()
	
end

--@brief    接收人物缓存信息
function WndOwnCity:getPlayerInfo()
    local  bIsHasInfo = CacheCenter:hasPlayerInfo()
    if bIsHasInfo == true then
        self:setPlayerInfoCache(CacheCenter:getPlayerInfo())
    end
end

--@brief    更新人物缓存信息
function WndOwnCity:updatePlayerInfoData()
    WZLog("WndOwnCity:updatePlayerInfoData")
    self:setPlayerInfoCache(CacheCenter:getPlayerInfo())
    self:updateForUpgrade()
end

--@brief    设置人物缓存信息
function WndOwnCity:setPlayerInfoCache(data, isCity)
    if isCity == nil then
        self.m_tPlayerInfo = data
        self:updateInfo()
    end

    local figure = FigureSceneManager:getInstance().m_tFigure
    if figure ~= nil and SceneCity:getBgLayer() and SceneCity:getBgLayer():isVisible() and CacheCenter:getEquipmentList() then
        figure.m_tPlayerInfo = CacheCenter:getPlayerInfo()
        local colour,bodyColour = CacheCenter:getHeadAndBodyColor()
        figure.m_tPlayerInfo.colour = colour
        figure.m_tPlayerInfo.bodyColour = bodyColour
        
        figure:createName()

        local showMonster = false
        local monsterId
        local isMonster = false
        local equip = CacheCenter:getDecorationList()
        if CacheCenter:getPlayerInfo().shapeId > 0 and CacheCenter:getPlayerInfo().showShape == 1 then
            showMonster = true
            isMonster = true
            monsterId = CacheCenter:getPlayerInfo().shapeId
        end

        WZLog("WndOwnCity:setPlayerInfoCache 1", CacheCenter:getPlayerInfo().sex, CacheCenter:getPlayerInfo().shapeId, showMonster, figure.m_bIsMonster)
        
        if showMonster ~= figure.m_bIsMonster or showMonster then
            figure:changeFigureAnim()
        end

        --WZLog("WndOwnCity:setPlayerInfoCache 1", Serialize(CacheCenter:getPlayerInfo()))
        local data = {}
        local headId = nil
        local faceId = nil
        for k, v in pairs(equip) do
            if  v.maintype == 5 and v.isUse then
                local subType = v.subtype
                local equipId = v.id
                if subType == 0 then
                    data.head = GetItemLocalData(v.id).animation_index_code
                    headId = GetItemLocalData(v.id).id
                elseif subType == 1 then
                    data.face = GetItemLocalData(v.id).animation_index_code
                    faceId = GetItemLocalData(v.id).id
                elseif subType == 2 then
                    data.body = GetItemLocalData(v.id).animation_index_code
                elseif subType == 3 then
                    data.wing = GetItemLocalData(v.id).animation_index_code
                end
            end
        end

        local tEquip = data
        local head = nil
        local face = nil
        local body = nil
        local weapon = nil
        local weapType = nil
        local wing = nil
        if tEquip.head ~= nil and tEquip.head ~= "" then
            head = tEquip.head
        end
        if tEquip.face ~= nil and tEquip.face~="" then
            face = tEquip.face
        end
        if tEquip.body ~= nil and tEquip.body~="" then
            body = tEquip.body
        end

        if tEquip.wing ~= nil and tEquip.wing ~="" then
            wing = tEquip.wing
        end

        --设置默认显示
        local gameParam = CacheCenter:getGameParam()
        if CacheCenter:getPlayerInfo().sex == 0 then
            if head == nil then head = GDatatab_item["id_"..(gameParam and gameParam.defaultManHeadId or 4903)].animation_index_code end
            if face == nil then face = GDatatab_item["id_"..(gameParam and gameParam.defaultManFaceId or  4902)].animation_index_code end
            if body == nil then body = GDatatab_item["id_"..(gameParam and gameParam.defaultManBodyId or  4901)].animation_index_code end

            if headId == nil then headId = gameParam and gameParam.defaultManHeadId or 4903 end
            if faceId == nil then faceId = gameParam and gameParam.defaultManFaceId or 4902 end
        else
            if head == nil then head = GDatatab_item["id_"..(gameParam and gameParam.defaultWomanHeadId or 4906)].animation_index_code end
            if face == nil then face = GDatatab_item["id_"..(gameParam and gameParam.defaultWomanFaceId or 4905)].animation_index_code end
            if body == nil then body = GDatatab_item["id_"..(gameParam and gameParam.defaultWomanBodyId or 4904)].animation_index_code end

            if headId == nil then headId = gameParam and gameParam.defaultWomanHeadId or 4906 end
            if faceId == nil then faceId = gameParam and gameParam.defaultWomanFaceId or 4905 end
        end

        
        local colour,bodyColour = CacheCenter:getHeadAndBodyColor()
        WZLog("WndOwnCity:setPlayerInfoCache 2", head, face, body, headId, faceId, colour, bodyColour)
        if isMonster == false then
            WZLog("WndOwnCity:setPlayerInfoCache 3")
            local conPlayer = figure.m_anim
            conPlayer:setHead(head,colour)
            conPlayer:setFace(face)
            if body ~= nil then
                conPlayer:setBody(body, CacheCenter:getPlayerInfo().sex == 0)
            end
            conPlayer:setBodyRanSe(bodyColour)

            if wing ~= nil then
                conPlayer:setWing(wing)
            else
                conPlayer:setWing(0)
            end
            conPlayer:play("wait0",true)
        end

        if self.m_root and self.m_tHeadAnim then
            self.m_tHeadAnim:setHead(headId,faceId,CacheCenter:getPlayerInfo().sex,nil,colour )
        end
    end

end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndOwnCity:_setDefaultBtnsInfo()

    local tBtnsInfo = GlobalGame:getBtnInfoByGroupType(3)
    table.sort(tBtnsInfo,function(a,b) return a.buttonSort2>b.buttonSort2 end) 

    self.m_tBtnsInfo = tBtnsInfo
    for i = 1, #self.m_tBtnsInfo do
        if self.m_tBtnsInfo[i].buttonId == 147 and GlobalGame.g_autoFootballActivity ~= 1 then
            table.remove(self.m_tBtnsInfo, i)
            break 
        end
    end
    for i = 1, #self.m_tBtnsInfo do
        if self.m_tBtnsInfo[i].buttonId == 149 and GlobalGame.g_autoBackActivity ~= 1 then
            table.remove(self.m_tBtnsInfo, i)
            break 
        end
    end

    local tBtnsInfo = GlobalGame:getBtnInfoByType(ISLAND_BTNTYPE_LEFT)
    local btnList2 = {}
    for i,v in ipairs(tBtnsInfo) do
        if v.buttonSort ~= -1 then
            btnList2[v.buttonSort] = v
        else
            btnList2[i] = v
        end
    end
    -- local temp1 = tBtnsInfo[1]
    -- local temp2 = tBtnsInfo[2]
    -- local temp3 = tBtnsInfo[3]
    -- tBtnsInfo[1] = temp3
    -- tBtnsInfo[2] = temp1
    -- tBtnsInfo[3] = temp2

    self.m_tLeftBtnsInfo = btnList2
    WZLog("WndOwnCity:_setDefaultBtnsInfo", Serialize(self.m_tBtnsInfo), Serialize(self.m_tLeftBtnsInfo))

    WZLog("WndOwnCity:_setDefaultBtnsInfo2", Serialize(self.m_tLeftBtnsInfo))
end

-------------------------------------私有方法模块End----------------------------------------

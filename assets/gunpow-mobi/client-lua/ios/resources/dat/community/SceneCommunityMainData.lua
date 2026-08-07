--SceneCommunityMainData.lua
--@brief	SceneCommunityMain的数据模块
--@date		2015/04/20
--@author	zsq
--@note		公会场景

SceneCommunityMain = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneCommunityMain:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nLoadingId = nil
	self.m_tImgTotem = nil
	self.m_tSpine = nil
	self.m_tSceneLayer = nil
	self.jumpTo = nil
    self.m_tTopHangle = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneCommunityMain:_unInit()
	self.m_root = nil
	self.m_nLoadingId = nil
	self.m_tImgTotem = nil
	self.m_tSpine = nil
	self.m_tSceneLayer = nil
	self.jumpTo = nil
    self.m_tTopHangle = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneCommunityMain:createElement()
	local element = WZUISystem:getInstance():createElement("SceneCommunityMain")
	assert(element, "SceneCommunityMain create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
function SceneCommunityMain:showInterface()
    -- body
    local tempScene = SceneCommunityMain:createElement()
    if tempScene then
        replaceScene(tempScene)
    end
end

--@brief    更新人物缓存信息
function SceneCommunityMain:updatePlayerInfoData()
    WZLog("SceneCommunityMain:updatePlayerInfoData")
    self:setPlayerInfoCache(CacheCenter:getPlayerInfo())
end

--@brief    设置人物缓存信息
function SceneCommunityMain:setPlayerInfoCache(data, isCity)
    local figure = FigureSceneManager:getInstance().m_tFigure
    if figure ~= nil and self.m_root then
        figure.m_tPlayerInfo = CacheCenter:getPlayerInfo()
        figure:createName()

        local showMonster = false
        local monsterId
        local equip = CacheCenter:getDecorationList()
        if CacheCenter:getPlayerInfo().shapeId > 0 then
            showMonster = true
            monsterId = CacheCenter:getPlayerInfo().shapeId
        end

        WZLog("WndOwnCity:setPlayerInfoCache 1", CacheCenter:getPlayerInfo().shapeId, showMonster, figure.m_bIsMonster)
        if showMonster ~= figure.m_bIsMonster or showMonster  then
            figure:changeFigureAnim()
            return
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
        if bIsBoy == true then
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
        WZLog("WndOwnCity:setPlayerInfoCache 2", body, headId, faceId)
        local conPlayer = figure.m_anim
        conPlayer:setHead(head,colour)
        conPlayer:setFace(face)
        if body ~= nil then
            conPlayer:setBody(body)
        end
        conPlayer:setBodyRanSe(bodyColour)

        if wing ~= nil then
            conPlayer:setWing(wing)
        else
            conPlayer:setWing(0)
        end
        conPlayer:play("wait0",true)

    end

end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief   创建加载框
function SceneCommunityMain:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function SceneCommunityMain:closeLoading()
	MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
end


-------------------------------------私有方法模块End----------------------------------------

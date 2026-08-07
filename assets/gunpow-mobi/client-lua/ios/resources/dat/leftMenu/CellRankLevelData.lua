--CellRankLevelData.lua
--@brief	CellRankLevel的数据模块
--@date		2016/05/21
--@author	Tianxiang_Xu
--@note		等级榜&成就榜

CellRankLevel = {
	-- 请在这里定义和初始化全局成员变量
}


--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellRankLevel:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_nShowInfoId = nil            --显示信息的id:玩家id或房间id
    self.m_tData = nil                  --数据
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellRankLevel:_unInit()
	self.m_root = nil
    self.m_nShowInfoId = nil
    self.m_tData = nil                  --数据
end

--@brief    创建场景
--@return   #1，场景element的引用
--@note     请仅用此方法创建场景
function CellRankLevel:createElement()
    local obj = {}
    setmetatable(obj, {__index = CellRankLevel})
    obj:_init()
    local element = WZUIContainer:create()
    element:setName("__CellRankLevel")
    element:setUseAbsSize(true)
    element:setAbsContentSize(GlobalMethod:CCSize(675,85))
    element:setLuaObjectIndex(obj)
    return element,obj
end
-------------------------------------公有方法模块Begin--------------------------------------
--@brief    设置节点所需数据
function CellRankLevel:setData(ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param4, param5, param6, param7, rankType, trendRank, vipLevel, param8, headColor, param9)
    -- body
    if self.m_tData == nil then
        self.m_tData = {}
    end

    self.m_tData.ranking = ranking
    self.m_tData.playerId = playerId
    self.m_tData.name = name
    self.m_tData.faceId = faceId
    self.m_tData.headId = headId
    self.m_tData.sex = sex
    self.m_tData.level = level
    self.m_tData.param1 = param1
    self.m_tData.param2 = param2
    self.m_tData.param3 = param3
    self.m_tData.param4 = param4
    self.m_tData.param5 = param5
    self.m_tData.param6 = param6
    self.m_tData.param7 = param7
    self.m_tData.rankType = rankType
    self.m_tData.trendRank = trendRank
    self.m_tData.vipLevel = vipLevel
    self.m_tData.param8 = param8
    self.m_tData.headColor = headColor
    self.m_tData.param9 = param9 
end

--@brief    初始化cell
function CellRankLevel:initCellData(ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param4, param5, param6, param7, rankType, trendRank, vipLevel, param8, headColor, param9)
    if self.m_root == nil then
        WZLog("self.m_root == nil")
        return
    end

    if ranking <= 3 then
        local imgIcon = GetElement(self.m_root, "imgRankIcon_CellRankLevel", WZUIImage)
        GetElement(self.m_root, "txtRankNum_CellRankLevel", WZUILabelAtlasFont):setVisible(false)
        imgIcon:setVisible(true)
        if ranking == 1 then
            imgIcon:setFile("ui/common/common_icon_1st.png")
        elseif ranking == 2 then
            imgIcon:setFile("ui/common/common_icon_2nd.png")
        elseif ranking == 3 then
            imgIcon:setFile("ui/common/common_icon_3rd.png")
        end
    else
        GetElement(self.m_root, "imgRankIcon_CellRankLevel", WZUIImage):setVisible(false)
    end

    --自己显示绿色
    if playerId == CacheCenter:getPlayerInfo().id then
        local imgBK = GetElement(self.m_root, "imgBK_CellRankLevel", WZUI9Image)
        imgBK:setFile("ui/common/common_scale9_di38.png")
    end

    --保存id
    self.m_nShowInfoId = playerId
    --将参数转换成字符串并和label顺序对应
    local txt0 = tostring(ranking)
    local txt10 = "Lv" .. tostring(level)   --玩家等级
    local txt11 = name                      --玩家名字
    local txt20
    local txt30

    local conInfoLabel_n = GetElement(self.m_root, "conInfoLabel_n", WZUIContainer)
    local labelInfo4 = GetElement(self.m_root, "label_info_n_4", WZUILabelTTF)

    if rankType == 2 then   --等级榜
        txt20 = "Lv" .. tostring(level)
        txt30 = param2

        if txt30 == nil or txt30 == "" then
            txt30 = LocalStrings.NONE .. LocalStrings.COMMUNITY
        end
        GetElement(self.m_root, "label_info_n_2", WZUILabelTTF):setVisible(false)
        GetElement(self.m_root, "txtValue2", WZUILabelTTF):setAnchorPoint(GlobalMethod:ccp(0,0.5))
        -- if ProjConfig.LANGUAGE == "pt" then
        --     GetElement(self.m_root, "label_info_n_4", WZUILabelTTF):setScale(0.6)
        -- end
    elseif rankType == 13 then  --成就榜
        txt20 = param1
        txt30 = param2
        local bEnableStroke = false 
        local tempPoint = GlobalMethod:ccp(0.82,0.91)
        if txt30 == nil or txt30 == "" then
            txt30 = LocalStrings.SHOP_NOCHENGHAO
        else
            local sTitleName = SplitStringWithSeparator(txt30,"&")
            local sNewTitle, nLetterNum = string.gsub(txt30, "&", ",")
            if sTitleName[2] ~= nil and sTitleName[2] ~= "" then
                if tonumber(sTitleName[2]) == nil or nLetterNum > 2 then
                else
                    local bExist = WZFileUtil:isFileExist(string.format(g_sTitleSpineName, sTitleName[2]) .. ".json")
                    if bExist then
                        bEnableStroke = true 
                        labelInfo4:setColor(GlobalMethod:ccc3(229,105,22))
                        labelInfo4:setRelativePosition(GlobalMethod:ccp(0.82,0.44))
                    end
                end
            end
        end
        CreateDesiSpine(conInfoLabel_n, labelInfo4, txt30, tempPoint, bEnableStroke)
        if ProjConfig.LANGUAGE == "en" then
            GetElement(self.m_root, "label_info_n_4", WZUILabelTTF):setScale(0.6)
        end
        if ProjConfig.LANGUAGE == "pt" or ProjConfig.LANGUAGE == "es" then
            GetElement(self.m_root, "label_info_n_4", WZUILabelTTF):setScale(0.6)
        end
    end
    if rankType ~= 3 then
        --人物头像
        self:_showHeadIcon(faceId, headId, sex, "conHead1_CellRankLevel", vipLevel, headColor)
    end
    
    GetElement(self.m_root, "label_info_n_2", WZUILabelTTF):setText(txt10)
    GetElement(self.m_root, "label_info_n_3", WZUILabelTTF):setText(txt20)
    if rankType ~= 13 then
        labelInfo4:setText(txt30)
    end
    GetElement(self.m_root, "txtValue2", WZUILabelTTF):setText(txt11)
    GetElement(self.m_root, "txtRankNum_CellRankLevel", WZUILabelAtlasFont):setText(txt0)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@param	新建的表实例对象
function CellRankLevel:_new( )
    local tNewObj = {}
    setmetatable(tNewObj, self)
    self.__index = self
    return tNewObj
end

--@brief    根据当前等级返回相应的数据表数据
--@param    level 当前竞技等级
function CellRankLevel:_getIntegralName(level)
    return WndRankList:_getIntegralName(level)
end

-------------------------------------私有方法模块End----------------------------------------

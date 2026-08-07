--CellRankFightingData.lua
--@brief	CellRankFighting的数据模块
--@date		2016/05/21
--@author	Tianxiang_Xu
--@note		战力榜&宠物榜

CellRankFighting = {
	-- 请在这里定义和初始化全局成员变量
}


--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellRankFighting:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_nShowInfoId = nil            --显示信息的id:玩家id或房间id
    self.m_tData = nil                  --数据
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellRankFighting:_unInit()
	self.m_root = nil
    self.m_nShowInfoId = nil
    self.m_tData = nil                  --数据
end

--@brief    创建场景
--@return   #1，场景element的引用
--@note     请仅用此方法创建场景
function CellRankFighting:createElement()
    local obj = {}
    setmetatable(obj, {__index = CellRankFighting})
    obj:_init()
    local element = WZUIContainer:create()
    element:setName("__CellRankFighting")
    element:setUseAbsSize(true)
    element:setAbsContentSize(GlobalMethod:CCSize(675,85))
    element:setLuaObjectIndex(obj)
    return element,obj
end
-------------------------------------公有方法模块Begin--------------------------------------
--@brief    设置节点所需数据
function CellRankFighting:setData(ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param4, param5, param6, param7, rankType, trendRank, vipLevel, param8, headColor, param9, headEffectId, wifeHeadEffectId, qqHallData)
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
    self.m_tData.headEffectId = headEffectId
    self.m_tData.wifeHeadEffectId = wifeHeadEffectId
    self.m_tData.qqHallData = qqHallData
end

--@brief    初始化cell
function CellRankFighting:initCellData(ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param4, param5, param6, param7, rankType, trendRank, vipLevel, param8, headColor, param9, headEffectId, qqHallData)
    if self.m_root == nil then
        WZLog("self.m_root == nil")
        return
    end

    if ranking <= 3 then
        local imgIcon = GetElement(self.m_root, "imgRankIcon_CellRankFighting", WZUIImage)
        GetElement(self.m_root, "txtRankNum_CellRankFighting", WZUILabelAtlasFont):setVisible(false)
        imgIcon:setVisible(true)
        if ranking == 1 then
            imgIcon:setFile("ui/common/common_icon_1st_1.png")
        elseif ranking == 2 then
            imgIcon:setFile("ui/common/common_icon_2nd_1.png")
        elseif ranking == 3 then
            imgIcon:setFile("ui/common/common_icon_3rd_1.png")
        end
    else
        GetElement(self.m_root, "imgRankIcon_CellRankFighting", WZUIImage):setVisible(false)
    end

    --自己显示绿色
    if playerId == CacheCenter:getPlayerInfo().id then
        local imgBK = GetElement(self.m_root, "imgBK_CellRankFighting", WZUI9Image)
        imgBK:setFile("ui/common/frame_lieb_01.png")
    end

    --保存id
    self.m_nShowInfoId = playerId
    --将参数转换成字符串并和label顺序对应
    local txt0 = tostring(ranking)
    local txt10 = "Lv" .. tostring(level)   --玩家等级
    local txt11 = name                      --玩家名字
    local txt30, txt31, txt20, temp1,temp2 = "","","","",""   

    temp1 = level
    temp2 = name
    local txtValue4 = GetElement(self.m_root, "txtValue4", WZUILabelTTF)
    if rankType == 1 or rankType == 59 then   --战力榜(1本服战力榜 59全服战力榜)
        txt20 = param1
        txt30 = param2
        if txt30 == nil or txt30 == "" then
            txt30 = LocalStrings.NONE .. LocalStrings.COMMUNITY
        end
        GetElement(self.m_root, "label_info_n_4", WZUILabelTTF):setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
        local txtFighting = GetElement(self.m_root, "txtAtlasFighting2_CellRankFighting", WZUILabelAtlasFont)
        txtFighting:setVisible(true)
        txtFighting:setText(txt20)

        GetElement(self.m_root, "imgHead2BK_CellRankFighting", WZUIImage):setFile("ui/common/commom_text_cz.png")
        GetElement(self.m_root, "imgHead2BK_CellRankFighting", WZUIImage):setUseOriginSize(true)
    elseif rankType == 3 or rankType == 60 then   --宠物榜(3本服 60全服)
        txt10 = "Lv" .. param2
        txt11 = param3
        
        temp1 = param2
        temp2 = param3

        txt20 = param4
        txt30 = "Lv" .. tostring(level)   --玩家等级
        txt31 = name                      --玩家名字
        GetElement(self.m_root, "label_info_n_4", WZUILabelTTF):setVisible(false)
        local txtFighting = GetElement(self.m_root, "txtAtlasFighting2_CellRankFighting", WZUILabelAtlasFont)
        txtFighting:setVisible(true)
        txtFighting:setText(txt20)

        local txtLevel4 = GetElement(self.m_root, "label_info_n_4", WZUILabelTTF)
        txtLevel4:setAnchorPoint(GlobalMethod:ccp(0, 0))
        txtLevel4:setVisible(true)
        txtLevel4:setColor(GlobalMethod:ccc3(105,65,46))
        txtLevel4:setRelativePosition(GlobalMethod:ccp(0.78, 0.5))
        txtValue4:setAnchorPoint(GlobalMethod:ccp(0, 1))
        txtValue4:setRelativePosition(GlobalMethod:ccp(0.78, 0.5))

        local qualityPic = {"ui/common/frame_green.png","ui/common/frame_bule.png","ui/common/frame_violet.png","ui/common/frame_orange.png","ui/common/common_scale9_beibaodi1.png"}
        --品质框背景
        local imgQuatityBk = GetElement(self.m_root, "imgQuatityBK_CellRankFighting", WZUIImage)
        imgQuatityBk:setVisible(true)
        --品质框
        local imgQuatityRect = GetElement(self.m_root, "imgQuatityRect_CellRankFighting", WZUIImage)
        imgQuatityRect:setFile(qualityPic[tonumber(param5)])
        imgQuatityRect:setScale(0.8)
        imgQuatityRect:setVisible(true)

        local petIcon = GetElement(self.m_root, "imgHead1BK_CellRankFighting", WZUIImage)
        petIcon:setScale(0.8)
        petIcon:setFile(param1)
        petIcon:setUseOriginSize(true)

        GetElement(self.m_root, "imgHead2BK_CellRankFighting", WZUIImage):setFile("ui/common/commom_text_cz.png")
        GetElement(self.m_root, "imgHead2BK_CellRankFighting", WZUIImage):setUseOriginSize(true)
        if ProjConfig.LANGUAGE == "hk" then
            local label_info_n_2 = GetElement(self.m_root, "label_info_n_2", WZUILabelTTF)
            label_info_n_2:setRelativePosition(GlobalMethod:ccp(0.236851,0.582353))
            local txtValue2 = GetElement(self.m_root, "txtValue2", WZUILabelTTF)
            txtValue2:setRelativePosition(GlobalMethod:ccp(0.236851,0.558824))
            txtValue2:setScale(0.8)
            txtValue2:setDimensions(GlobalMethod:CCSize(180))
            txtValue2:setAlignment(kCCTextAlignmentLeft)
        end
    elseif rankType == 38 or rankType == 39 or rankType == 40 or rankType == 41 or rankType == 46 or rankType == 47 then
        txt20 = param1
        txt30 = param2
        if txt30 == nil or txt30 == "" then
            txt30 = LocalStrings.NONE .. LocalStrings.COMMUNITY
        end
        GetElement(self.m_root, "label_info_n_4", WZUILabelTTF):setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
        local txtFighting = GetElement(self.m_root, "txtAtlasFighting2_CellRankFighting", WZUILabelAtlasFont)
        txtFighting:setVisible(true)
        txtFighting:setText(txt20)
        local imgHead2BK = GetElement(self.m_root, "imgHead2BK_CellRankFighting", WZUIImage)
        imgHead2BK:setFile("shopitems/diamond.png")
        imgHead2BK:setUseOriginSize(true)
        imgHead2BK:setScale(0.5)
        if rankType == 46 or rankType == 47 then
            imgHead2BK:setFile("shopitems/meilixianhua.png")
        end

        if ProjConfig.LANGUAGE == "vn" then
            if rankType == 38 or rankType == 39 then
                txtFighting:setText(math.floor(txt20 / 2000))
            end
        end
        --东南亚渠道号 要求钻石乘6
        if ProjConfig.CHANNEL_ID == 1009 or ProjConfig.CHANNEL_ID == 1016 or ProjConfig.CHANNEL_ID == 1038 or ProjConfig.CHANNEL_ID == 1046 or ProjConfig.CHANNEL_ID == 1063 then
            if rankType == 38 or rankType == 39 then
                txtFighting:setText(math.floor(txt20 * 6))
            end
        end
        --美洲渠道号 要求钻石乘5
        if ProjConfig.CHANNEL_ID == 1087 or ProjConfig.CHANNEL_ID == 1065 or ProjConfig.CHANNEL_ID == 1069 or ProjConfig.CHANNEL_ID == 1081 or ProjConfig.CHANNEL_ID == 1044 or ProjConfig.CHANNEL_ID == 1066 or ProjConfig.CHANNEL_ID == 1043 or ProjConfig.CHANNEL_ID == 1089 or ProjConfig.CHANNEL_ID == 1042 then
            if rankType == 38 or rankType == 39 then
                txtFighting:setText(math.floor(txt20 * 5))
            end
        end

        if tonumber(param3) == 1 then --跨服标志
            local img = WZUIImage:create()
            img:setFile("ui/common/common_icon_kuafu.png")
            img:setUseOriginSize(true)
            img:setAnchorPoint(GlobalMethod:ccp(0,1))
            img:setRelativePosition(GlobalMethod:ccp(0.236851,0.5))
            self.m_root:addChild(img)
            GetElement(self.m_root, "txtValue2", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.27,0.5))
        end
    end
    if rankType ~= 3 and rankType ~= 60 then
        --人物头像
        self:_showHeadIcon(faceId, headId, sex, "conHead1_CellRankFighting", vipLevel, headColor, headEffectId)
    end
    --获取Container控件
    local conInfoLabel_n = GetElement(self.m_root, "conInfoLabel_n", WZUIContainer)--包含4个label
    if  conInfoLabel_n == nil or conInfoLabel_s == nil then WZLog("====nil") end
    
    GetElement(self.m_root, "label_info_n_2", WZUILabelTTF):setText(txt10)
    GetElement(self.m_root, "label_info_n_4", WZUILabelTTF):setText(txt30)
    GetElement(self.m_root, "txtValue2", WZUILabelTTF):setText(txt11)
    txtValue4:setText(txt31)
    GetElement(self.m_root, "txtRankNum_CellRankFighting", WZUILabelAtlasFont):setText(txt0)

    local txtReuniteLabel = GetElement(self.m_root,"txtReuniteLabel",WZUIFreeTextBox)
    if txtReuniteLabel then
        if rankType ~= 3 and rankType ~= 60 then
            local str = [[<T C="127,70,26" S="20" P="1">Lv</T><T C="229,105,22" S="20" P="1">%s</T><BR>8</BR><I Z="0.6" P="1">%s</I><I Z="0.6" P="1">%s</I><T C="127,70,26" S="20" P="1">%s</T>]]
            local strQQBluePath = ""
            local strQQYearPath = ""
            local bShowQQInfo = true 
            if ProjConfig:getChannelId() ~= 1118 then 
                bShowQQInfo = false 
            end 
            --qq大厅蓝钻年费图标
            if qqHallData and bShowQQInfo then 
                if qqHallData.is_blue_vip or qqHallData.is_super_blue_vip then 
                    if qqHallData.is_super_blue_vip then 
                        strQQBluePath = "ui/qqHall/hh_" .. qqHallData.blue_vip_level .. ".png"
                    else 
                        strQQBluePath = "ui/qqHall/pz_" .. qqHallData.blue_vip_level .. ".png"
                    end
                    if qqHallData.is_blue_year_vip then 
                        strQQYearPath = "ui/qqHall/nian.png"
                    end
                end
            end
            txtReuniteLabel:setShowText(string.format(str,temp1, strQQBluePath, strQQYearPath, temp2))
        else
            --qq大厅蓝钻年费图标
            SetQQHallBlueIcon(self.m_root, qqHallData, {"imgQQBlue_CellRankFighting", "imgQQYear_CellRankFighting"}, {"txtValue4"}, {WZUILabelTTF}, 0.027)
            local str = [[<T C="127,70,26" S="20" P="1">Lv</T><T C="229,105,22" S="20" P="1">%s</T><T C="127,70,26" S="20" P="1"> %s</T>]]
            txtReuniteLabel:setShowText(string.format(str,temp1,temp2))
        end
    end
    GetElement(self.m_root, "label_info_n_2", WZUILabelTTF):setVisible(false)
    GetElement(self.m_root, "txtValue2", WZUILabelTTF):setVisible(false)

    if rankType == 59 then
        if tonumber(param5) ~= CacheCenter:getPlayerInfo().serverId then
            --跨服标志(*)
            local imgCrossServer = WZUIImage:create()
            imgCrossServer:setFile("ui/common/common_icon_kuafu.png")
            imgCrossServer:setUseOriginSize(true)
            imgCrossServer:setAnchorPoint(ccp(0,0.5))
            imgCrossServer:setRelativePosition(ccp(1,0.5))
            txtReuniteLabel:addChild(imgCrossServer)
        end
    end
    if rankType == 60 then
        if tonumber(param6) ~= CacheCenter:getPlayerInfo().serverId then
            --跨服标志(*)
            local imgCrossServer = WZUIImage:create()
            imgCrossServer:setFile("ui/common/common_icon_kuafu.png")
            imgCrossServer:setUseOriginSize(true)
            imgCrossServer:setAnchorPoint(ccp(0,0.5))
            imgCrossServer:setRelativePosition(ccp(1,0.5))
            txtValue4:addChild(imgCrossServer)
        end
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@param	新建的表实例对象
function CellRankFighting:_new( )
    local tNewObj = {}
    setmetatable(tNewObj, self)
    self.__index = self
    return tNewObj
end

--@brief    根据当前等级返回相应的数据表数据
--@param    level 当前竞技等级
function CellRankFighting:_getIntegralName(level)
    return WndRankList:_getIntegralName(level)
end

-------------------------------------私有方法模块End----------------------------------------

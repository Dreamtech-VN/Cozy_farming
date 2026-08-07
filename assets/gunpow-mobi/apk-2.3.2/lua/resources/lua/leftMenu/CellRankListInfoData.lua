--CellRankListInfoData.lua
--@brief	CellRankListInfo的数据模块
--@date		2015/04/22
--@author	hyq
--@note		排行榜信息格子

CellRankListInfo = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function CellRankListInfo:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_nShowInfoId = nil            --显示信息的id:玩家id或房间id
    self.m_nWifeId  = nil               --妻子的id
    self.m_nRankTypeOfFiveLabel = 14    --包含5个标签的排行榜类型
    self.m_tData = nil                  --数据
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellRankListInfo:_unInit()
	self.m_root = nil
    self.m_nShowInfoId = nil
    self.m_nWifeId  = nil               --妻子的id
    self.m_nRankTypeOfFiveLabel = nil
    self.m_tData = nil                  --数据
end

--@brief    创建场景
--@return   #1，场景element的引用
--@note     请仅用此方法创建场景
function CellRankListInfo:createElement()
    local obj = {}
    setmetatable(obj, {__index = CellRankListInfo})
    obj:_init()
    local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setAbsContentSize(GlobalMethod:CCSize(675,85))
    element:setLuaObjectIndex(obj)
    return element,obj
end
-------------------------------------公有方法模块Begin--------------------------------------
--@brief    设置节点所需数据
function CellRankListInfo:setData(ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param4, param5, param6, param7, rankType, trendRank, vipLevel, param8, headColor, param9, headEffectId, wifeHeadEffectId, qqHallData)
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
function CellRankListInfo:initCellData(ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param4, param5, param6, param7, rankType, trendRank, vipLevel, param8, headColor, param9, headEffectId, wifeHeadEffectId, qqHallData)
    if self.m_root == nil then
        WZLog("self.m_root == nil")
        return
    end

    if ranking <= 3 then
        local imgIcon = GetElement(self.m_root, "imgRankIcon_CellRankListInfo", WZUIImage)
        GetElement(self.m_root, "txtRankNum_CellRankListInfo", WZUILabelAtlasFont):setVisible(false)
        imgIcon:setVisible(true)
        if ranking == 1 then
            imgIcon:setFile("ui/common/common_icon_1st_1.png")
        elseif ranking == 2 then
            imgIcon:setFile("ui/common/common_icon_2nd_1.png")
        elseif ranking == 3 then
            imgIcon:setFile("ui/common/common_icon_3rd_1.png")
        end
    else
        GetElement(self.m_root, "imgRankIcon_CellRankListInfo", WZUIImage):setVisible(false)
    end

    --自己显示绿色
    if playerId == CacheCenter:getPlayerInfo().id then
        local imgBK = GetElement(self.m_root, "imgBK_CellRankListInfo", WZUI9Image)
        imgBK:setFile("ui/common/frame_lieb_01.png")
    end

    --保存id
    self.m_nShowInfoId = playerId
    self.m_nWifeId = tonumber(param1)
    --将参数转换成字符串并和label顺序对应
    local txt0 = tostring(ranking)
    local txt10 = "Lv" .. tostring(level)   --玩家等级
    local txt11 = name                      --玩家名字
    local txt20,txt21,txt22,txt30,txt32,temp1,temp2 = "","","","","","",""
    temp1 = level
    temp2 = name
    local temp3,temp4 = "",""
    if rankType == 23 then      --恩爱榜
        GetElement(self.m_root, "btnHasband_CellRankListInfo", WZUIButton):setTouchEnable(true)
        GetElement(self.m_root, "btnWife_CellRankListInfo", WZUIButton):setTouchEnable(true)
        txt20 = "Lv" .. param3
        txt21 = param2
        
        temp3 = param3
        temp4 = param2

        txt30 = param7 --LocalStrings.COUPLE_LOVE
        txt32 = param6  --恩爱等级
        GetElement(self.m_root, "imgHead3BK_CellRankListInfo", WZUIImage):setFile("ui/common/common_icon_enai1.png")
        GetElement(self.m_root, "imgHead3BK_CellRankListInfo", WZUIImage):setScale(0.5)
        GetElement(self.m_root, "imgHead3BK_CellRankListInfo", WZUIImage):setUseOriginSize(true)
        --恩爱等级
        local txtAtlasLv = GetElement(self.m_root, "txtAtlasLv_CellRankListInfo", WZUILabelAtlasFont)
        txtAtlasLv:setAnchorPoint(GlobalMethod:ccp(0.5, 0.5))
        txtAtlasLv:setText(txt32)
        txtAtlasLv:setVisible(false)
        GetElement(self.m_root, "label_info_n_4", WZUILabelTTF):setColor(GlobalMethod:ccc3(158,0,0))
        --妻子头像
        self:_showHeadIcon(tonumber(param5), tonumber(param4), 1, "conHead2_CellRankListInfo", param8, tonumber(param9), wifeHeadEffectId)
    end
    if rankType ~= 3 then
        --人物头像
        self:_showHeadIcon(faceId, headId, sex, "conHead1_CellRankListInfo", vipLevel, headColor, headEffectId)
    end
    --获取Container控件
    local conInfoLabel_n = GetElement(self.m_root, "conInfoLabel_n", WZUIContainer)--包含4个label
    if  conInfoLabel_n == nil or conInfoLabel_s == nil then WZLog("====nil") end

    conInfoLabel_n:setVisible(true)
    GetElement(self.m_root, "label_info_n_2", WZUILabelTTF):setText(txt10)
    GetElement(self.m_root, "label_info_n_3", WZUILabelTTF):setText(txt20)
    GetElement(self.m_root, "label_info_n_4", WZUILabelTTF):setText(txt30)
    GetElement(self.m_root, "txtValue2", WZUILabelTTF):setText(txt11)
    GetElement(self.m_root, "txtValue3", WZUILabelTTF):setText(txt21)
    GetElement(self.m_root, "txtRankNum_CellRankListInfo", WZUILabelAtlasFont):setText(txt0)

    local txtReuniteLabel = GetElement(self.m_root,"txtReuniteLabel",WZUIFreeTextBox)
    local bShowQQInfo = true 
    if ProjConfig:getChannelId() ~= 1118 then 
        bShowQQInfo = false 
    end
    if txtReuniteLabel then
        local strQQBluePath = ""
        local strQQYearPath = ""
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
        local str = [[<T C="127,70,26" S="20" P="1">Lv</T><T C="229,105,22" S="20" P="1">%s</T><BR>8</BR><I Z="0.6" P="1">%s</I><I Z="0.6" P="1">%s</I><T C="127,70,26" S="20" P="1">%s</T>]]
        txtReuniteLabel:setShowText(string.format(str,temp1, strQQBluePath, strQQYearPath, temp2))
    end
    local txtReuniteLabel1 = GetElement(self.m_root,"txtReuniteLabel1",WZUIFreeTextBox)
    if txtReuniteLabel1 then
        local strQQBluePath = ""
        local strQQYearPath = ""
        --qq大厅蓝钻年费图标
        if qqHallDataWife and bShowQQInfo then 
            if qqHallDataWife.is_blue_vip or qqHallDataWife.is_super_blue_vip then 
                if qqHallDataWife.is_super_blue_vip then 
                    strQQBluePath = "ui/qqHall/hh_" .. qqHallDataWife.blue_vip_level .. ".png"
                else 
                    strQQBluePath = "ui/qqHall/pz_" .. qqHallDataWife.blue_vip_level .. ".png"
                end
                if qqHallDataWife.is_blue_year_vip then 
                    strQQYearPath = "ui/qqHall/nian.png"
                end
            end
        end
        local str = [[<T C="127,70,26" S="20" P="1">Lv</T><T C="229,105,22" S="20" P="1">%s</T><BR>8</BR><I Z="0.6" P="1">%s</I><I Z="0.6" P="1">%s</I><T C="127,70,26" S="20" P="1">%s</T>]]
        txtReuniteLabel1:setShowText(string.format(str,temp3, strQQBluePath, strQQYearPath, temp4))
    end
    GetElement(self.m_root, "label_info_n_2", WZUILabelTTF):setVisible(false)
    GetElement(self.m_root, "txtValue2", WZUILabelTTF):setVisible(false)

    GetElement(self.m_root, "label_info_n_3", WZUILabelTTF):setVisible(false)
    GetElement(self.m_root, "txtValue3", WZUILabelTTF):setVisible(false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	以本表为模版创建一个新的表实例对象
--@param	新建的表实例对象
function CellRankListInfo:_new( )
    local tNewObj = {}
    setmetatable(tNewObj, self)
    self.__index = self
    return tNewObj
end

--@brief    根据当前等级返回相应的数据表数据
--@param    level 当前竞技等级
function CellRankListInfo:_getIntegralName(level)
    return WndRankList:_getIntegralName(level)
end


-------------------------------------私有方法模块End----------------------------------------

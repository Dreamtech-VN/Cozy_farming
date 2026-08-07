--CellActivityRankListData.lua
--@brief	CellActivityRankList的数据模块
--@date		2016/07/11
--@author	Tianxiang_Xu
--@note		活动夫妻战和工会战排行榜单

CellActivityRankList = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellActivityRankList:_init()
	self.m_root = nil  			--Cell的根节点
	self.m_nShowInfoId = nil            --显示信息的id:玩家id或房间id
    self.m_nWifeId  = nil               --妻子的id
    self.m_tData = nil
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellActivityRankList:_unInit()
	self.m_root = nil
	self.m_nShowInfoId = nil            --显示信息的id:玩家id或房间id
    self.m_nWifeId  = nil               --妻子的id
    self.m_tData = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellActivityRankList:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellActivityRankList table create failed!")
	tNewObj:_init()

	local element = WZUIContainer:create()
    element:setUseAbsSize(true)
    element:setName("__CellActivityRankList")
    element:setAbsContentSize(GlobalMethod:CCSize(730,93))
    element:setLuaObjectIndex(tNewObj)
    return element,tNewObj
end

--@brief    设置节点所需数据
function CellActivityRankList:setData(ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param5, param6, param7, rankType, vipLevel, winCount, guildName, headColor, param8)
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
    self.m_tData.param5 = param5
    self.m_tData.param6 = param6
    self.m_tData.param7 = param7
    self.m_tData.rankType = rankType
    self.m_tData.vipLevel = vipLevel
    self.m_tData.winCount = winCount
    self.m_tData.guildName = guildName
    self.m_tData.headColor = headColor
    self.m_tData.param8 = param8
end

--@brief    初始化cell
function CellActivityRankList:initCellData(ranking, playerId, name, faceId, headId, sex, level, param1, param2, param3, param5, param6, param7, rankType, vipLevel, winCount, guildName, headColor, param8)
    if self.m_root == nil then
        WZLog("self.m_root == nil")
        return
    end

    if ranking <= 3 then
        local imgIcon = GetElement(self.m_root, "imgRankIcon_CellActivityRankList", WZUIImage)
        GetElement(self.m_root, "txtRankNum_CellActivityRankList", WZUILabelAtlasFont):setVisible(false)
        imgIcon:setVisible(true)
        if ranking == 1 then
            imgIcon:setFile("ui/common/common_icon_1st.png")
        elseif ranking == 2 then
            imgIcon:setFile("ui/common/common_icon_2nd.png")
        elseif ranking == 3 then
            imgIcon:setFile("ui/common/common_icon_3rd.png")
        end
    else
        GetElement(self.m_root, "imgRankIcon_CellActivityRankList", WZUIImage):setVisible(false)
    end

    --自己显示绿色
    if playerId == CacheCenter:getPlayerInfo().id or tonumber(param1) == CacheCenter:getPlayerInfo().id then
        local imgBK = GetElement(self.m_root, "imgBK_CellActivityRankList", WZUI9Image)
        imgBK:setFile("ui/common/common_scale9_di38.png")
    end

    --保存id
    self.m_nShowInfoId = playerId
    self.m_nWifeId = tonumber(param1)
    --将参数转换成字符串并和label顺序对应
    local txt0 = tostring(ranking)
    local txt10 = tostring(level)   --玩家等级
    local txt11 = name                      --玩家名字
    local txt20
    local txt21
    local txt22
    local txt30
    local txtValue4 = GetElement(self.m_root, "txtValue4", WZUILabelAtlasFont)
    if rankType == g_tGameActivityTypes.ACTIVITY_COUPLEFIGHTING then      --夫妻榜
    	txtValue4:setVisible(true)
    	GetElement(self.m_root, "label_info_n_4", WZUILabelTTF):setVisible(false)
        GetElement(self.m_root, "btnHasband_CellActivityRankList", WZUIButton):setTouchEnable(true)
        GetElement(self.m_root, "btnWife_CellActivityRankList", WZUIButton):setTouchEnable(true)
        txt20 = param3
        txt21 = param2
        txt30 = winCount --LocalStrings.COUPLE_LOVE
        --妻子头像
        self:_showHeadIcon(tonumber(param5), tonumber(param6), 1, "conHead2_CellActivityRankList", param7, tonumber(param8))
        GetElement(self.m_root, "txtValue4", WZUILabelAtlasFont):setText(txt30)
    elseif rankType == g_tGameActivityTypes.ACTIVITY_COMMUNITYFIGHTING then  --公会榜
    	txt20 = winCount
    	txt30 = guildName

    	GetElement(self.m_root, "txtValue5", WZUILabelAtlasFont):setVisible(true)
    	GetElement(self.m_root, "conPlayerHead2_CellActivityRankList", WZUIContainer):setVisible(false)
    	txtValue4:setVisible(false)
    	GetElement(self.m_root, "label_info_n_4", WZUILabelTTF):setVisible(true)
    	GetElement(self.m_root, "txtValue3", WZUILabelTTF):setVisible(false)
    	GetElement(self.m_root, "imgLv3_CellActivityRankList", WZUIImage):setVisible(false)
    	GetElement(self.m_root, "label_info_n_3", WZUILabelAtlasFont):setVisible(false)

    	GetElement(self.m_root, "txtValue5", WZUILabelAtlasFont):setText(txt20)
    end
    --人物头像
    self:_showHeadIcon(faceId, headId, sex, "conHead1_CellActivityRankList", vipLevel, headColor)
    --获取Container控件
    local conInfoLabel_n = GetElement(self.m_root, "conInfoLabel_n", WZUIContainer)--包含4个label
    if  conInfoLabel_n == nil or conInfoLabel_s == nil then WZLog("====nil") end

    conInfoLabel_n:setVisible(true)
    GetElement(self.m_root, "label_info_n_2", WZUILabelAtlasFont):setText(txt10)
    GetElement(self.m_root, "label_info_n_3", WZUILabelAtlasFont):setText(txt20)
    GetElement(self.m_root, "label_info_n_4", WZUILabelTTF):setText(txt30)
    GetElement(self.m_root, "txtValue2", WZUILabelTTF):setText(txt11)
    GetElement(self.m_root, "txtValue3", WZUILabelTTF):setText(txt21)
    GetElement(self.m_root, "txtRankNum_CellActivityRankList", WZUILabelAtlasFont):setText(txt0)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellActivityRankList:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	return tNewObj
end


-------------------------------------私有方法模块End----------------------------------------

--CellAthRank.lua
--@brief	CellAthRank的UI模块
--@date		2015-9-18
--@author	binshao
--@note		排行伤害


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellAthRank:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellAthRank:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellAthRank:onLoadData(element)
    local element = WZUISystem:getInstance():createElement("CellAthRank")
    self.m_root:addChild(element)
    AdaptLanguage(self)
    self:_update()
end

function CellAthRank:OnCheckPlayerInfo()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.data.playerId)
end

-- 设置玩家信息
local imgRankPath = {"ui/common/common_icon_1st.png","ui/common/common_icon_2nd.png","ui/common/common_icon_3rd.png"}
function CellAthRank:_update()
    local txtRank = GetElement(self.m_root,"txtRank_CellAthRank",WZUILabelTTF)
    if self.data.rank <= 3 then
        local imgRank = GetElement(self.m_root,"imgRank_CellAthRank",WZUIImage)
        imgRank:setFile(imgRankPath[self.data.rank])
        imgRank:setVisible(true)
    else
        txtRank:setText(self.data.rank)
    end

    -- 头像
    local con = GetElement(self.m_root,"conHead_CellAthRank",WZUIContainer)
    CellHead:show(con,self.data.headId,self.data.faceId,self.data.sex,nil,nil,self.data.vipLv,self.data.headColor)

    -- 名字等级
    local pName = self.data.name
	local txtName = GetElement(self.m_root,"txtName_CellAthRank",WZUILabelTTF)
    local ftbName = GetElement(self.m_root,"ftbAllName_CellAthRank",WZUIFreeTextBox)
    local serverId = IPDhttpServer:getCurServerId()
    if tonumber(serverId) == tonumber(self.data.serverId) then
        txtName:setVisible(true)
        ftbName:setVisible(false)
        txtName:setText(pName)
    else
        txtName:setVisible(false)
        ftbName:setVisible(true)
        ftbName:setShowText(string.format(LocalStrings.ALL_SERCER_RANK_NAME,pName))
    end

    local txtLv = GetElement(self.m_root,"txtLv_CellAthRank",WZUILabelTTF)
    txtLv:setText("Lv"..self.data.level)

    -- 分数
	local txtScore = GetElement(self.m_root,"txtScore_CellAthRank",WZUILabelTTF)
    txtScore:setText(self.data.athScore)

    -- 胜利次数和胜率
    local txtWin = GetElement(self.m_root,"txtWinCnt_CellAthRank",WZUILabelTTF)
    local winCnt = math.floor(self.data.athWinCnt*100/self.data.athCnt)
    txtWin:setText(string.format(LocalStrings.ATH_DESC_7,self.data.athCnt,self.data.athWinCnt,winCnt))
	-- if ProjConfig.LANGUAGE == "en" then
	-- 	txtWin:setText(string.format(LocalStrings.ATH_DESC_7,self.data.athWinCnt,self.data.athCnt,winCnt))
	-- end

    if self.data.name == CacheCenter:getPlayerInfo().name then
        txtName:setColor(GlobalMethod:ccc3(3,111,8))
        txtLv:setColor(GlobalMethod:ccc3(3,111,8))
        txtScore:setColor(GlobalMethod:ccc3(3,111,8))
        txtWin:setColor(GlobalMethod:ccc3(3,111,8))
        txtRank:setColor(GlobalMethod:ccc3(3,111,8))

        local imgDi = GetElement(self.m_root,"imgDi_CellAthRank",WZUI9Image)
        imgDi:setFile("ui/common/common_scale9_di38.png")
    end
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------

function CellAthRank:_adaptLanguage_en()
    WZLog("----------------en---------------------CellAthRank:_adaptLanguage_en")
    local txtWin = GetElement(self.m_root,"txtWinCnt_CellAthRank",WZUILabelTTF)
    txtWin:setFontSize(20)
    txtWin:setDimensions(GlobalMethod:CCSize(200,0))
end

function CellAthRank:_adaptLanguage_pt()
    WZLog("----------------en---------------------CellAthRank:_adaptLanguage_pt")
    local txtWin = GetElement(self.m_root,"txtWinCnt_CellAthRank",WZUILabelTTF)
    txtWin:setFontSize(16)
    txtWin:setDimensions(GlobalMethod:CCSize(200,0))
end

function CellAthRank:_adaptLanguage_tr()
    local txtWin = GetElement(self.m_root,"txtWinCnt_CellAthRank",WZUILabelTTF)
    txtWin:setFontSize(20)
    txtWin:setDimensions(GlobalMethod:CCSize(200,0))
end

function CellAthRank:_adaptLanguage_es()
    local txtWin = GetElement(self.m_root,"txtWinCnt_CellAthRank",WZUILabelTTF)
    txtWin:setFontSize(18)
    txtWin:setDimensions(GlobalMethod:CCSize(200,0))
end
-------------------------------------私有方法模块End----------------------------------------
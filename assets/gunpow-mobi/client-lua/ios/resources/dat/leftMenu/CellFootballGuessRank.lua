--CellFootballGuessRank.lua
--@brief	CellFootballGuessRank的UI模块
--@date		2018/06/01
--@author	Tianxiang_Xu
--@note		足球精彩排名列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFootballGuessRank:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFootballGuessRank:onExit(element)
	self:_unInit()
end

--@brief    加载cell数据信息
function CellFootballGuessRank:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellFootballGuessRank")
    self.m_root:addChild(cellElement)
    self.m_bIsLoad = true

    self:_update()
end

--@brief    点击Cell时调用
function CellFootballGuessRank:onCellClickedCallback(element)
    WZLog("CellFootballGuessRank:onCellClickedCallback")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndCheckOther:show(self.m_tData.id)
end

--@brief    点击物品回调
function CellFootballGuessRank:clickItemBack(tCell, tag, tData)
    -- body
    WndItemInfo:showInfo(tCell.m_root,WndFootballActivity.m_root,1,tData,false)
end

--@brief    显示玩家头像
--@param    人物脸ID
--@param    人物头ID
--@param    人物性别
--@param    添加到容器的名称
function CellFootballGuessRank:_showHeadIcon(faceId, headId, sex, sConName, vipLevel, headColor)
    WZLog("CellFootballGuessRank:_showHeadIcon()")
    --设置默认显示
    conHead = GetElement(self.m_root, sConName, WZUIContainer)
    local headNode = CellHead:show(conHead,headId,faceId,sex,nil,nil,vipLevel, headColor)
    headNode:setScale(0.82)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellFootballGuessRank:_update()
	-- body
	local tData = self.m_tData 
    local imgRankIndex = GetElement(self.m_root, "imgRankIndex_CellFootballGuessRank", WZUIImage)
    local txtRankIndex = GetElement(self.m_root, "txtRankIndex_CellFootballGuessRank", WZUILabelAtlasFont)
	if tData.rank <= 3 then
        txtRankIndex:setVisible(false)
        imgRankIndex:setVisible(true)
        if tData.rank == 1 then
            imgRankIndex:setFile("ui/common/common_icon_1st.png")
        elseif tData.rank == 2 then
            imgRankIndex:setFile("ui/common/common_icon_2nd.png")
        elseif tData.rank == 3 then
            imgRankIndex:setFile("ui/common/common_icon_3rd.png")
        end
    else
        txtRankIndex:setVisible(true)
        txtRankIndex:setText(tData.rank)
        imgRankIndex:setVisible(false)
    end

    --自己显示绿色
    -- if playerId == CacheCenter:getPlayerInfo().id then
    --     local imgBK = GetElement(self.m_root, "imgBK_CellRankLevel", WZUI9Image)
    --     imgBK:setFile("ui/common/common_scale9_di38.png")
    -- end

    --人物头像
    self:_showHeadIcon(tData.faceId, tData.headId, tData.sex, "conHead_CellFootballGuessRank", tData.vipLevel, tData.headColor)
    
    GetElement(self.m_root, "txtName_CellFootballGuessRank", WZUILabelTTF):setText(tData.name)
    GetElement(self.m_root, "txtCurNum_CellFootballGuessRank", WZUILabelTTF):setText(tData.curNum)

    --展示奖励
    self:_showReward()
end

--@brief    展示奖励
function CellFootballGuessRank:_showReward()
    -- body
    local nItemindex = 0
    for i = 1, #self.m_tData.reward do
        if tonumber(self.m_tData.reward[i][1]) ~= -1 then
            nItemindex = nItemindex + 1
            local conItem = GetElement(self.m_root, "conItem" .. nItemindex .. "_CellFootballGuessRank", WZUIContainer)
            if conItem then
                conItem:removeAllChildrenWithCleanup(true)
                conItem:setVisible(true)

                local element, tNewObj = CellGoodItem:createElement()
                if element and tNewObj then
                    tNewObj:setCellGoodLocalId(self.m_tData.reward[i][1], self.m_tData.reward[i][2], 4)
                    tNewObj:setItemClickFun(self, self.clickItemBack)
                    element:setScale(0.7)
                    conItem:addChild(element)
                end
            end
        end
    end
end


-------------------------------------私有方法模块End----------------------------------------

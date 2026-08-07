--CellTowerRank.lua
--@brief	CellTowerRank的UI模块
--@date		2015/04/28
--@author	xiaoyu_wu
--@modify   qixiang_xie
--@note		爬塔副本排名单元格


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTowerRank:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTowerRank:onExit(element)
	self:_unInit()
end

--@brief  显示排行榜里的人物信息
function CellTowerRank:onClickPlayerInfo(element)
    WZLog("CellTowerRank:onClickPlayerInfo")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.m_tData.playerId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@加载数据
function CellTowerRank:onLoadData(element)
   WZLog("CellTowerRank:onLoadData")
   local cellElement = WZUISystem:getInstance():createElement("CellTowerRank")
   element:addChild(cellElement)

   self:_update()
end

--@brief	更新界面
function CellTowerRank:_update()
    -- 人物头像
    local sex = self.m_tData.playerSex == 0 and true or false
    local conHead = GetElement(self.m_root, "conHead_CellTowerRank",WZUIContainer)
    CellHead:show(conHead,self.m_tData.headId,self.m_tData.faceId,self.m_tData.playerSex,nil,nil,self.m_tData.vipLevel,self.m_tData.headColor)
    
    local index = self.m_nRank % 2
    local txtRank = nil
    local imgRank = GetElement(self.m_root,"imgRank_CellTowerRank",WZUIImage)
    imgRank:setFile("")
    imgRank:setScale(0.8)
    if self.m_nRank == 1 then
        imgRank:setFile("ui/common/common_icon_1st.png")
    elseif self.m_nRank == 2 then
        imgRank:setFile("ui/common/common_icon_2nd.png")
    elseif self.m_nRank == 3 then
        imgRank:setFile("ui/common/common_icon_3rd.png")
    else
        txtRank = GetElement(self.m_root,"txtRank_CellTowerRank",WZUILabelTTF)
        txtRank:setText(self.m_nRank)
        txtRank:setColor(GlobalMethod:ccc3(158,0,0))
    end

    local imgBg = GetElement(self.m_root,"imgBg_CellTowerRank",WZUI9Image)
   

    local txtLevel = GetElement(self.m_root, "txtLevel_CellTowerRank", WZUILabelTTF)
    txtLevel:setText("Lv"..self.m_tData.playerLevel)
    
    local txtName = GetElement(self.m_root, "txtName_CellTowerRank", WZUILabelTTF)
    txtName:setText(self.m_tData.playerName)
    
    local txtUnion = GetElement(self.m_root, "txtUnion_CellTowerRank", WZUILabelTTF)
    if string.len(self.m_tData.playerGuild) == 0 then
        txtUnion:setText(LocalStrings.SHOP_NOGONGHUI)
    else
        txtUnion:setText(self.m_tData.playerGuild)
    end

    local txtFloor = GetElement(self.m_root, "txtFloor_CellTowerRank", WZUILabelTTF)
    txtFloor:setText(string.format(LocalStrings.NUMBER_LEVEL,self.m_tData.playerFloor))

    local playerName = CacheCenter:getPlayerInfo().name
    if playerName == self.m_tData.playerName then
        imgBg:setFile("ui/common/common_scale9_di38.png")
        txtLevel:setColor(GlobalMethod:ccc3(0,72,3))
        txtName:setColor(GlobalMethod:ccc3(0,72,3))
        txtUnion:setColor(GlobalMethod:ccc3(0,72,3))
        txtFloor:setColor(GlobalMethod:ccc3(0,72,3))
        if txtRank then
            txtRank:setColor(GlobalMethod:ccc3(0,72,3))
        end
    else
        imgBg:setFile("ui/common/common_scale9_di18.png")
        txtLevel:setColor(GlobalMethod:ccc3(105,65,45))
        txtName:setColor(GlobalMethod:ccc3(79,60,48))
        txtUnion:setColor(GlobalMethod:ccc3(79,60,48))
        txtFloor:setColor(GlobalMethod:ccc3(79,60,48))
    end

end
-------------------------------------私有方法模块End----------------------------------------
--CellPvpRankList.lua
--@brief	CellQualifyingRank的UI模块
--@date		2015-11-11
--@author	binshao
--@note		排位赛排行榜单元格


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpRankList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPvpRankList:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellPvpRankList:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellPvpRankList")
    self.m_root:addChild(cellElement)
    self:_update()
    AdaptLanguage(self)
end

--@brief	点击单元格时被调用的函数
--@param	element:按钮绑定的UI节点引用
function CellPvpRankList:OnCheckPlayerInfo(element)
    WZLog("CellPvpRankList:onClickCell")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.data.playerId)
end

--@brief    其它Item点击回调
function CellPvpRankList:onItemClick(luaObject,tag)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    self.callFunc[2](self.callFunc[1],luaObject,self.reward[tag + 1])
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新人物头像
--playerId	int[]	玩家id
--playerName	String[]	玩家名称
--playerSex	byte[]	玩家性别
--playerHeadId	int[]	玩家头
--playerFaceId	int[]	玩家脸
--playerLevel	short[]	玩家等级
--segmentLevel	int[]	玩家段位id
--score	int[]	玩家积分
--battleTimes	int[]	本周战斗次数
--winTimes	int[]	本周胜利次数
--winStreak	int[]	本周最高连胜次数
function CellPvpRankList:_update()
    local data = self.data

    -- 排名
    local imgPath = {"ui/common/common_icon_1st.png","ui/common/common_icon_2nd.png","ui/common/common_icon_3rd.png" }
    if tonumber(data.rank) and data.rank < 4 then
        local img = GetElement(self.m_root,"imgRank_CellPvpRankList",WZUIImage)
        img:setFile(imgPath[tonumber(data.rank)])
    else
        local txt = GetElement(self.m_root,"txtRank_CellPvpRankList",WZUILabelTTF)
        txt:setText(data.rank)
    end

    for i = 1, #data.reward do
        local conItem = GetElement(self.m_root, "conItem" .. i .. "_CellPvpRankReward", WZUIContainer)
        if conItem then
            local celElement, tNewObj = CellGoodItem:createElement()
            if celElement and tNewObj then
                local shopItems = GDatatab_item["id_"..data.reward[i][1]]
                local itemInfo = {id=data.reward[i][1], name=shopItems.name,icon=shopItems.icon,lastNum=data.reward[i][2],quality=shopItems.quality ,basicInfo=shopItems}
                self.reward[i] = itemInfo
                if shopItems.main_type == 5 then
                    tNewObj:setCellGoodItem(itemInfo,17)
                else
                    tNewObj:setCellGoodItem(itemInfo,4)
                end
                celElement:setScale(0.8)
                tNewObj:setItemClickFun(self,self.onItemClick)
                conItem:addChild(celElement)
                celElement:setTag(i - 1)
            end
        end
    end
end

-------------------------------------私有方法模块End----------------------------------------

--------------------------------------语言适配Begin------------------------------------------
function CellPvpRankList:_adaptLanguage_en(  )
    -- GetElement(self.m_root,"txtSegLv_CellPvpRankList",WZUILabelTTF):setFontSize(18)
    -- GetElement(self.m_root,"ftbWin_CellPvpRankList",WZUIFreeTextBox):setScale(0.73)
    -- GetElement(self.m_root,"txtWinNum_CellPvpRankList",WZUILabelTTF):setFontSize(16)
    -- GetElement(self.m_root,"conWin_CellPvpRankList",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.88,0.5))
end

function CellPvpRankList:_adaptLanguage_vn(  )
    -- GetElement(self.m_root,"txtSegLv_CellPvpRankList",WZUILabelTTF):setFontSize(18)
    -- GetElement(self.m_root,"ftbWin_CellPvpRankList",WZUIFreeTextBox):setScale(0.73)
    -- GetElement(self.m_root,"txtWinNum_CellPvpRankList",WZUILabelTTF):setFontSize(16)
    -- GetElement(self.m_root,"conWin_CellPvpRankList",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.88,0.5))
end

function CellPvpRankList:_adaptLanguage_tr(  )
    local txtScore = GetElement(self.m_root,"txtScore_CellPvpRankList",WZUILabelTTF)
    txtScore:setScale(0.7)
    txtScore:setRelativePosition(GlobalMethod:ccp(0.5,0.256667))

end
--------------------------------------语言适配End--------------------------------------------
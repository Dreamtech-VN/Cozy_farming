--CellTrainingRewardListData.lua
--@brief    CellTrainingRewardList的数据模块
--@date     2017/02/13
--@author   jianfeng_mo
--@note     训练营奖励列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTrainingRewardList:onEnter(element)
	self.m_root = element
	--多语言版本界面适配
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTrainingRewardList:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellTrainingRewardList:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellTrainingRewardList")
    self.m_root:addChild(cellElement)
    self:_update()
end

-- 点击领取回调
function CellTrainingRewardList:clickReward(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WZLog("CellTrainingRewardList:clickReward", self.data.open)
    if self.data.open ~= -1 then
        MsgBoxManager:showTipBox(LocalStrings.TRAINCAMP_DEC5)
        return
    end
    if self.data.level > CacheCenter:getPlayerInfo().level then
        MsgBoxManager:showTipBox(string.format(LocalStrings.OPAN_FOR_LEVEL, self.data.level))
        return
    end
    ProtocolProcessorSingleMap:send_SINGLEMAP_StartChallenge(self.data.id, COPYTYPE_TRAIN )
    element:setTouchEnable(false)
    --GetElement(self.m_root, "txtReward_CellTrainingRewardList"):setVisible(true)
end 

--@note		设置UI界面数据
function CellTrainingRewardList:_update()
    local curData = self.data

    local txtName =  GetElement(self.m_root, "txtName_CellTrainingRewardList", WZUILabelTTF)
    txtName:setText(curData.name)

    local dec = LocalStrings.TRAINCAMP_DEC1
    local state = LocalStrings.TRAINCAMP_DEC2
    if curData.state == 1 then
        state = LocalStrings.TRAINCAMP_DEC2
    else
        state = ""
    end
    local txtDec = GetElement(self.m_root, "txtDec_CellTrainingRewardList", WZUIFreeTextBox)
    txtDec:setShowText(string.format(dec, state))

    WZLog("CellTrainingRewardList:_update one", curData.id,curData.state, type(curData.state))
    if curData.state == 0 then
        GetElement(self.m_root, "txtReward_CellTrainingRewardList"):setVisible(false)
    end

    local img = GetElement(self.m_root, "imgLevel_CellTrainingRewardList", WZUIImage)
    img:setFile("ui/common/common_icon_xunliany".. curData.difficulty ..".png")

    if ProjConfig.LANGUAGE == "en" or ProjConfig.LANGUAGE == "vn" then
        for i = 1, 3 do
            GetElement(self.m_root, "txtChallenge"..i.."_CellTrainingRewardList", WZUILabelTTF):setScale(0.9)
        end
    end

    self:_createVipReward()
end

--@brief    更新vip奖励
function CellTrainingRewardList:_createVipReward()
    local id = {}
    local num = {}
    local id2 = {}
    local num2 = {}
    local reward = self.data.reward
    WZLog("CellTrainingRewardList:_createVipReward one",reward)
    --id, num = SplitItemString(reward)

    for i,v in ipairs(reward) do
        table.insert(id,v[1])
        table.insert(num,v[2])
    end

    self.id = id
    self.num = num
    for i=1,#id do
        WZLog("CellTrainingRewardList:_createVipReward two", Serialize(id), Serialize(num))
        if id[i] ~= nil then
            local key = "id_"..id[i]
            local tData = GDatatab_item[key]
            local name = tData.name
            local icon = tData.icon
            local num =  num[i]
            local quality = tData.quality
            local itemInfo = {name=name,icon=icon,lastTime=num,lastNum=num,quality=quality,basicInfo=CopyTable(tData)}

            local con = GetElement(self.m_root,"conLeft"..i,WZUIContainer)
            con:removeAllChildrenWithCleanup(true)
            local celElement,tLuaObj = CellTrainingReward:createElement()
            if celElement ~= nil then 
                celElement = WZUIContainer:luaTo(celElement)
                tLuaObj:setCellTrainingReward(itemInfo, 16)
                tLuaObj:setItemClickFun(self, self.onClickItem)
                tLuaObj:setTag(i)
                celElement:setScale(0.85)
                con:addChild(celElement)
            end
        end
    end
end

function CellTrainingRewardList:onClickItem(tItem, nTag, tData)
    if self.m_root == nil then return end
    WndItemInfo:showInfo(tItem.m_root,WndVip.m_root,1,tData, false)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------
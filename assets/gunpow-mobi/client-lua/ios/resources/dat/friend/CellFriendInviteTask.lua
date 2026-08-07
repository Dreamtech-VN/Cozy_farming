--CellFriendInviteTask.lua
--@brief	CellFriendInviteTask的UI模块
--@date		2016/06/07
--@author	Tianxiang_Xu
--@note		邀请码好友任务子项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFriendInviteTask:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFriendInviteTask:onExit(element)
	self:_unInit()
end

--@brief    加载cell数据和信息
function CellFriendInviteTask:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellFriendInviteTask")
    self.m_root:addChild(cellElement)

    self:_update()
    AdaptLanguage(self)
end

--@brief    点击奖励物品回调
function CellFriendInviteTask:onOthersClick(luaTable,tag,tData)
    -- body
    if tData == nil then
       return
    end
    local tagindex = tag+1
    WndItemInfo:onCloseClick()
    WndItemInfo:showInfo(luaTable.m_root,WndFriends.m_root,1,tData,false, nil, true)
end

--@brief    获取任务ID
function CellFriendInviteTask:getTaskId()
    -- body
    return self.m_tData.id
end

--@brief    点击领取回调
function CellFriendInviteTask:onGetReward(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    if self.m_tCallBack == nil then return end

    self.m_tCallBack[2](self.m_tCallBack[1], self.m_tData.id)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新cell信息
function CellFriendInviteTask:_update()
    -- body
    self:_setDesc()
    self:_showRewardsList()
    self:_setStatus()
end

--@brief    显示奖励物品列表
function CellFriendInviteTask:_showRewardsList()
    -- body
    local tRewardList = self.m_tData.reward

    for i = 1, #tRewardList do
        local key = "id_" .. tRewardList[i][1]
        local celElement,tLuaObj = CellGoodItem:createElement()
        if celElement ~= nil then 
            local conItem = GetElement(self.m_root, string.format("conItem%d_CellFriendInviteTask", i), WZUIContainer)
            celElement = WZUIContainer:luaTo(celElement)
            WZLog("CellFriendInviteTask:_showRewardsList",tRewardList[i][1], tRewardList[i][2])
            local itemInfo = {id = tRewardList[i][1], name=GDatatab_item[key].name,icon=GDatatab_item[key].icon,lastTime=tRewardList[i][2],quality=GDatatab_item[key].quality,basicInfo=CopyTable(GDatatab_item[key])}
            tLuaObj:setCellGoodItem(itemInfo,16)
            tLuaObj:setItemClickFun(self,self.onOthersClick)
            celElement:setScale(0.7)
            conItem:addChild(celElement)
            if ProjConfig.LANGUAGE == "es" then
                local txtBtnWord = GetElement(self.m_root,"txtBtnWord_CellFriendInviteTask",WZUILabelTTF)
                txtBtnWord:setScale(0.8)
                txtBtnWord:setDimensions(GlobalMethod:CCSize(120))
            end 
        end
    end
end

--@brief    设置状态
function CellFriendInviteTask:_setStatus()
    -- body
    local nStatus = self.m_tData.status
    local conProg = GetElement(self.m_root, "conProg_CellFriendInviteTask", WZUIContainer)
    local btnGetRewards = GetElement(self.m_root, "btnGetRewards_CellFriendInviteTask", WZUIButton)
    local txtHavedGet = GetElement(self.m_root, "txtHavedGet_CellFriendInviteTask", WZUILabelTTF)

    if nStatus == -1 then
        conProg:setVisible(true)
        btnGetRewards:setVisible(false)
        txtHavedGet:setVisible(false) 
        local progTask = GetElement(self.m_root, "progTask_CellFriendInvoteTask", WZUIProgress)
        local txtProgress = GetElement(self.m_root, "txtProgress_CellFriendInvoteTask", WZUILabelTTF)
        progTask:setPercentage(math.floor(self.m_tData.nComplete * 100 / self.m_tData.nTarget))
        txtProgress:setText(self.m_tData.nComplete .. "/" .. self.m_tData.nTarget)
    elseif nStatus == 0 then
        conProg:setVisible(false)
        btnGetRewards:setVisible(true)
        txtHavedGet:setVisible(false) 
    elseif nStatus == 1 then
        conProg:setVisible(false)
        btnGetRewards:setVisible(false)
        txtHavedGet:setVisible(true) 
    end 
end

--@brief    设置描述
function CellFriendInviteTask:_setDesc()
    -- body
    local txtDesc = GetElement(self.m_root, "txtDesc_CellFriendInviteTask", WZUILabelTTF)
    txtDesc:setText(self.m_tData.desc)
end
-------------------------------------私有方法模块End----------------------------------------
--------------------------------------语言适配Begin-----------------------------------------
function CellFriendInviteTask:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtBtnWord_CellFriendInviteTask",WZUILabelTTF):setScale(0.8)
end

function CellFriendInviteTask:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtDesc_CellFriendInviteTask",WZUILabelTTF):setFontSize(18)
end

function CellFriendInviteTask:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtDesc_CellFriendInviteTask",WZUILabelTTF):setFontSize(18)
end

function CellFriendInviteTask:_adaptLanguage_tr( )
    GetElement(self.m_root,"txtDesc_CellFriendInviteTask",WZUILabelTTF):setFontSize(18)
end

function CellFriendInviteTask:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtDesc_CellFriendInviteTask",WZUILabelTTF):setFontSize(18)
end
--------------------------------------语言适配End-------------------------------------------
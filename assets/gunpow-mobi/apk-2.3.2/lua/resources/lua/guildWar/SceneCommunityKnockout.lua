--SceneCommunityKnockout.lua
--@brief	SceneCommunityKnockout的UI模块
--@date		2017/02/22
--@author	zsq
--@note		公会战淘汰赛房间


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneCommunityKnockout:onEnter(element)
	self.m_root = element
    AdaptLanguage(self)
end

--@brief    场景加载完成回调
function SceneCommunityKnockout:onEnterTransitionDidFinish(element)
	self.m_nTab = 1
	self:_addTop()

    --设置倒计时
    self:_setScheduleForCon()

	ChangeChatChannel(Chat_Channel_Community_Knockout_Room)

	--发协议获得数据
	ProtocolProcessorCommunityWar:send_GUILDWAR_EntryGuildRoom()
	--self:setRoomData()
end
		
--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneCommunityKnockout:onExit(element)
	self:_unInit()
end

--@brief    添加顶部信息
function SceneCommunityKnockout:_addTop()
    local celElement, tNewObj = CellTopHandle:createElement()
    tNewObj:setTopData("ui/community/bag_icon_taotaisaifj.png",SceneCommunityKnockout,SceneCommunityKnockout.onTempClose,true,1,true,nil)
    self.m_root:addChild(celElement, 0, 666)
end

function SceneCommunityKnockout:onTempClose() 
   	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	ProtocolProcessorCommunityWar:send_GUILDWAR_OutGuildRoom( )
	replaceScene(SceneCommunityWar:createElement())
end

function SceneCommunityKnockout:showScene()
	local scene = SceneCommunityKnockout:createElement()
	replaceScene(scene)
end

function SceneCommunityKnockout:onTab(element)
	WZLog("SceneCommunityKnockout:onTab")
   	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	self.m_nTab = tonumber(element:getTag())	
	self:_updateRight()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function SceneCommunityKnockout:_updateRight()
	if self.m_root == nil then return end
	WZLog("SceneCommunityKnockout:_updateRight")
    local freeCon = GetElement(self.m_root, "freecon_SceneCommunityKnockout", WZUIFreeListContainer)
    local nCurPositionY = freeCon:getMoveElement():getPositionY()
    local tLastSize = freeCon:getMoveElement():getContentSize()
    freeCon:removeAll()

	if self.m_nTab == 1 then
    	for i = 1, #self.m_tRoomMemberList do
    	    local element, tNewObj = CellCommunityKnockout2:createElement()
    	    if element and tNewObj then
    	        local tData = self.m_tRoomMemberList[i]
    	        tNewObj:setData(tData, nType)
    	        --tNewObj:setCallBackFunc(self, self.onClickRoomCell)
    	        freeCon:pushBack(element)
    	    end
    	end
	else
    	for i = 1, #self.m_tRoomMemberList do
			if self.m_tRoomMemberList[i].state == 2 or self.m_tRoomMemberList[i].state == 4 then
    	    local element, tNewObj = CellCommunityKnockout2:createElement()
    	    if element and tNewObj then
    	        local tData = self.m_tRoomMemberList[i]
    	        tNewObj:setData(tData, nType)
    	        --tNewObj:setCallBackFunc(self, self.onClickRoomCell)
    	        freeCon:pushBack(element)
    	    end
			end
    	end
	end

	--freeCon:getMoveElement():setPositionY(freeCon:getMinPosition().y)
    --重新设置列表的位置
    local tCurSize = freeCon:getMoveElement():getContentSize()
    local nTempPositionY = nCurPositionY - (tCurSize.height - tLastSize.height)/2
    if nTempPositionY > freeCon:getMaxPosition().y then
        nTempPositionY = freeCon:getMaxPosition().y
    end
    freeCon:getMoveElement():setPositionY(nTempPositionY)
end

--@brief    创建参战队伍成员列表
function SceneCommunityKnockout:_createTeamList()
	if self.m_root == nil then return end
    -- body

	--有权限的玩家设置为类型1
    local nType = 1
	--没有权限的玩家设置为类型2
    --if tonumber(CacheCenter:getPlayerInfo().position) ~= COMMUNITY_PRESIDENT then
    if tonumber(CacheCenter:getPlayerInfo().id) ~= self.m_nAdmin then
        nType = 2
    end

    for i = 1, 3 do
        local tbconTeam = GetElement(self.m_root, string.format("tbconTeam%d_SceneCommunityKnockout", i), WZUITableContainer)
        tbconTeam:cleanTable()
        for j = 1, 3 do
            local element, tNewObj = CellCommunityKnockout1:createElement()
            if element and tNewObj then
                local tData = nil 
                for k = 1, #self.m_tRoomMemberList do
                    if self.m_tRoomMemberList[k].teamId == i and self.m_tRoomMemberList[k].teamPosition == j then
                        tData = self.m_tRoomMemberList[k]
                        break
                    end
                end
                tNewObj:setData(tData, nType)
                tNewObj:setCallBackFunc(self, self.onClickRoomCell)
                element:setTag(j - 1)
                tbconTeam:setCellElement(element)
            end
        end
    end

    --战力和状态
    self:_showFightingAndResult()
	--房间人数
	local totalNum = 0
	for i=1,#self.m_tRoomMemberList do
		if self.m_tRoomMemberList[i].state == 2 or self.m_tRoomMemberList[i].state == 4 then
			totalNum = totalNum + 1
		end
	end
	GetElement(self.m_root,"txtRoomMemberNum_SceneCommunityKnockout",WZUILabelTTF):setText(
		string.format(LocalStrings.KNOCKOUT4,tostring(totalNum)))
end

--@brief    房间点击设置队员回调
function SceneCommunityKnockout:onClickRoomCell(element)
	if type(element) ~= "number" then
    	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	end
    -- body
    if tonumber(CacheCenter:getPlayerInfo().id) == self.m_nAdmin then
    	WndCompeteMember:showInterface(self.m_tRoomMemberList)
	else
		MsgBoxManager:showTipBox(LocalStrings.KNOCKOUT10)	
	end
end

--@brief    设置战斗开始倒计时
function SceneCommunityKnockout:_setScheduleForCon()
    -- body
    local conRoomRight = GetElement(self.m_root, "conRoomRight_SceneCommunityKnockout", WZUIContainer)
    if conRoomRight then
        conRoomRight:enableSchedule("_caculateLeftTime", 1)
    end
end

--@brief    创建房间开始倒计时或相关提示
function SceneCommunityKnockout:_caculateLeftTime()
    -- body
    tab=os.date("*t",SystemTime:getServerTime())
    tab.hour = 20
    tab.min = 15
    tab.sec = 0
    local nLeftTime = os.time(tab)-SystemTime:getServerTime()
    local leftTime = GetElement(self.m_root, "leftTime_SceneCommunityKnockout", WZUILabelTTF)
    local sTime = returnToTimeFormat(nLeftTime)
    leftTime:setText(sTime)
    
    if nLeftTime < 0 then
        txtLeave:setVisible(false)
        leftTime:setVisible(false)
    else
        txtLeave:setVisible(true)
        leftTime:setVisible(true)
    end

    if nLeftTime <= 120 then --比赛结束2分钟还没匹配到才跳出房间
        self:showExitRoomAtt()
    end
end

--@brief    显示战队战斗力和战队人数或对战结果
function SceneCommunityKnockout:_showFightingAndResult()
    -- body
    for i = 1, 3 do
        local nNum, nFighting = self:_getTeamNumAndFighting(i)
        --总战力
        local txtFighting = GetElement(self.m_root, string.format("txtFighting%d_SceneCommunityKnockout", i), WZUILabelTTF)
        if txtFighting then
            txtFighting:setText(LocalStrings.COMBAT_IN_ALL .. ":" .. nFighting)
        end
        --战队人数
        local txtNumber = GetElement(self.m_root, string.format("txtNumber%d_SceneCommunityKnockout", i), WZUILabelTTF)
        if txtNumber then
            txtNumber:setText(nNum .. "/3" .. LocalStrings.SPACE8)
        end
        --战斗结果
        local imgResult = GetElement(self.m_root, string.format("imgResult%d_SceneCommunityKnockout", i), WZUIImage)
        imgResult:setVisible(false)
        if imgResult then
            imgResult:setFile("ui/common/common_icon_jxz.png") --进行中
            imgResult:setFile("ui/common/common_icon_shengli.png") --胜利
            imgResult:setFile("ui/common/common_icon_shibai.png") --失败
        end
    end
end

--@brief    返回战队人数和战队战力
--@param    team:战队Id
function SceneCommunityKnockout:_getTeamNumAndFighting(teamId)
    -- body
    if self.m_tRoomMemberList == nil or #self.m_tRoomMemberList == 0 then
        return 0,0
    end

    local nNum, nFighting = 0, 0
    for i = 1, #self.m_tRoomMemberList do
        if self.m_tRoomMemberList[i].teamId == teamId then
            nNum = nNum + 1
            nFighting = nFighting + self.m_tRoomMemberList[i].fighting
        end
    end

    return nNum, nFighting
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function SceneCommunityKnockout:_adaptLanguage_en(  )
    for i=1,3 do
        local txtTeamMark = GetElement(self.m_root,"txtTeamMark"..i.."_SceneCommunityKnockout",WZUILabelTTF)
        txtTeamMark:setScale(0.5)
    end
    local txtRule = GetElement(self.m_root,"txtRule_SceneCommunityKnockout",WZUILabelTTF)
    txtRule:setDimensions(GlobalMethod:CCSize(100,0))
    local txtLeave = GetElement(self.m_root,"txtLeave_SceneCommunityKnockout",WZUILabelTTF)
    txtLeave:setRelativePosition(GlobalMethod:ccp(0.67,0.053))
    local txtLeftTime = GetElement(self.m_root,"leftTime_SceneCommunityKnockout",WZUILabelTTF)
    txtLeftTime:setRelativePosition(GlobalMethod:ccp(0.723667,0.053))
    local txtStartAuto = GetElement(self.m_root,"txtStartAuto_SceneCommunityKnockout",WZUILabelTTF)
    txtStartAuto:setRelativePosition(GlobalMethod:ccp(0.898542,0.053))

    GetElement(self.m_root,"txtIntensify1_SceneCommunityKnockout",WZUILabelTTF):setScale(0.9)
    GetElement(self.m_root,"txtIntensify2_SceneCommunityKnockout",WZUILabelTTF):setScale(0.9)
end

function SceneCommunityKnockout:_adaptLanguage_pt(  )
    for i=1,3 do
        local txtTeamMark = GetElement(self.m_root,"txtTeamMark"..i.."_SceneCommunityKnockout",WZUILabelTTF)
        txtTeamMark:setScale(0.5)
        txtTeamMark:setRelativePosition(GlobalMethod:ccp(0.5,0.963))
    end

    GetElement(self.m_root,"btnInfo",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.810583,0.83))
    GetElement(self.m_root,"txtRule_SceneCommunityKnockout",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.911875,0.828))

    local txtLeave = GetElement(self.m_root,"txtLeave_SceneCommunityKnockout",WZUILabelTTF)
    txtLeave:setRelativePosition(GlobalMethod:ccp(0.671542,0.053))
    local txtLeftTime = GetElement(self.m_root,"leftTime_SceneCommunityKnockout",WZUILabelTTF)
    txtLeftTime:setRelativePosition(GlobalMethod:ccp(0.715333,0.053))
    local txtStartAuto = GetElement(self.m_root,"txtStartAuto_SceneCommunityKnockout",WZUILabelTTF)
    txtStartAuto:setRelativePosition(GlobalMethod:ccp(0.8975,0.053))

    GetElement(self.m_root,"txtIntensify1_SceneCommunityKnockout",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtIntensify2_SceneCommunityKnockout",WZUILabelTTF):setScale(0.8)

    GetElement(self.m_root,"txtRoomMemberNum_SceneCommunityKnockout",WZUILabelTTF):setScale(0.8)
end

function SceneCommunityKnockout:_adaptLanguage_vn(  )
    for i=1,2 do
        local txtIntensify = GetElement(self.m_root,"txtIntensify"..i.."_SceneCommunityKnockout",WZUILabelTTF)
        txtIntensify:setFontSize(20)
    end
end

function SceneCommunityKnockout:_adaptLanguage_es(  )
    for i=1,2 do
        local txtIntensify = GetElement(self.m_root,"txtIntensify"..i.."_SceneCommunityKnockout",WZUILabelTTF)
        txtIntensify:setFontSize(18)
        local txtImprove = GetElement(self.m_root,"txtImprove"..i.."_SceneCommunityKnockout",WZUILabelTTF)
        txtImprove:setFontSize(16)
    end
    local txtRule = GetElement(self.m_root,"txtRule_SceneCommunityKnockout",WZUILabelTTF)
    txtRule:setScale(0.8)
    txtRule:setDimensions(GlobalMethod:CCSize(100,0))
    GetElement(self.m_root,"btnInfo",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.77,0.83))

    local txtLeave = GetElement(self.m_root,"txtLeave_SceneCommunityKnockout",WZUILabelTTF)
    txtLeave:setRelativePosition(GlobalMethod:ccp(0.6,0.053))

    local leftTime = GetElement(self.m_root,"leftTime_SceneCommunityKnockout",WZUILabelTTF)
    leftTime:setRelativePosition(GlobalMethod:ccp(0.65,0.053))

    local txtStartAuto = GetElement(self.m_root,"txtStartAuto_SceneCommunityKnockout",WZUILabelTTF)
    txtStartAuto:setRelativePosition(GlobalMethod:ccp(0.87,0.053))
    txtStartAuto:setScale(0.8)

    for i=1,3 do
        GetElement(self.m_root,"txtTeamMark"..i.."_SceneCommunityKnockout",WZUILabelTTF):setFontSize(10)
    end
end

function SceneCommunityKnockout:_adaptLanguage_tr(  )
    GetElement(self.m_root,"btnInfo",WZUIButton):setRelativePosition(GlobalMethod:ccp(0.79,0.83))
    GetElement(self.m_root,"txtRule_SceneCommunityKnockout",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.9,0.828))

    for i=1,3 do
        local txtTeamMark = GetElement(self.m_root,"txtTeamMark"..i.."_SceneCommunityKnockout",WZUILabelTTF)
        txtTeamMark:setScale(0.5)
        local txtFighting = GetElement(self.m_root, string.format("txtFighting%d_SceneCommunityKnockout", i), WZUILabelTTF)
        txtFighting:setScale(0.7)
    end

end
-------------------------------------语言适配End--------------------------------------------
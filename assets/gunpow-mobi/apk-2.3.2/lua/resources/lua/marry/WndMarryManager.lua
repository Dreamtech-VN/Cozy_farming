--WndMarryManager.lua
--@brief	结婚管理模块
--@date		2014/01/09
--@author	叶威
--@note		跟据当前婚姻状况，管理当前界面

WndMarryManager = {}


--@brief 求婚类型定义
WndMarryManager.marryType = {
    DREAM = 1,            --心形花束
    ROMAN = 2,            --水晶鞋
    WARM = 3,             --金苹果
    SIMPLE = 4,           --钻石戒指
}

--@brief 求婚道具id
WndMarryManager.itemIds =
{
    152,   --第一个,心形玫瑰
    153,   --第二个,水晶鞋
    151,   --第三个,金苹果
    150,    --第四个,戒指
}


--@brief 婚礼类型
WndMarryManager.weddingType= {
    LUXURY = 1,          --奢华婚礼
    RICH = 2,            --豪华婚礼
    ROMAN = 3,           --浪漫婚礼
}


--@brief 婚礼情况
WndMarryManager.weddingSituation={
	NOT_MARRY = 1,       --没有结婚
	ADD_MARRY = 2,       --举办婚礼
	MARRY_SITUATION = 3, --结婚详情
}

WndMarryManager.holdWeddingType = 1  -- 婚礼类型
WndMarryManager.isShowParticle = false  --记录是否正在播放全局礼花

-------------------------------------公有方法模块Begin--------------------------------------


--@brief	注册所有结婚协议
--@note		进入小岛界面时注册，由于结婚协议全局特殊性，为方便处理全部注册为全局协议
function WndMarryManager:RegAllProtocol()
	ProtocolProcessorWndMarry:regAll()
    ProtocolProcessorMarryHoll:regAll()
end
--@brief	初始化方法
--@note		注册结婚协议
function WndMarryManager:initManager(ntype)
    WZLog("WndMarryManager:initManager")
	self.m_tMarryStatus = {}          --保存婚姻状况的表
    self.m_bRefreshData = false        --是否仅是刷新数据
    self.m_tMarryLetters = nil         --保存求婚信的表
    self.m_nLoadingId = -1             --加载框ID
	self.m_nTimeId = nil                --婚礼开始时间（订婚：-1，结婚是相应的ID）
    self.m_ntype = ntype
	--获取婚姻状况
    WndMarryManager:setIsRefreshData(false)
    ProtocolProcessorWndMarry:send_WEDDING_GetMaritalStatus()
end

--@brief	反初始化方法
--@note		注册结婚协议
function WndMarryManager:unInitManager()
	self.m_tMarryStatus = nil
    self.m_bRefreshData = false
    self.m_tMarryLetters = nil
	self.m_nTimeId = nil                --婚礼开始时间（订婚：-1，结婚是相应的ID）
    self.m_ntype = nil
end

--@brief	取得我的婚礼开始时间
function WndMarryManager:getMyWeddimgTime()
	return self.m_tMarryStatus.wedTime
end

--@brief	获得婚礼开始时间
--@return   #1婚礼开始时间
function WndMarryManager:getWeddingTimeId()
   return self.m_nTimeId
end

--@brief	获得婚姻状况表
--@return   #1,保存婚姻状况的表
function WndMarryManager:getMarryStatusTable()
   WZLog("self.m_tMarryStatus = ",self.m_tMarryStatus)
   return self.m_tMarryStatus
end

--@brief	获得求婚信列表
--@return   #1,保存所有求婚信的表
function WndMarryManager:getMarryLettersTable()
    return self.m_tMarryLetters
end


--@brief 根据道具id，获取对应的求婚类型
--@param id:道具id
--@return #1,返回相应的求婚类型,WndMarryManager.marryType
function WndMarryManager:getMarryTypeByItemId(id)
    WZLog("WndMarryManager:getMarryTypeByItemId")
    WZLog(id)
    for i = 1,#WndMarryManager.itemIds do
        local value = WndMarryManager.itemIds[i]
        if value == id then
             WZLog(i)
            return i
        end
    end
end

--@brief 邀请玩家参加婚礼
--@param  marryRecordId : 婚礼id
--@param playerName : 邀请人姓名
--@param password : 密码，不输入密码为""
function WndMarryManager:inviteFriendWedding(marryRecordId,playerName,password)
    WndMarryManager.marryRecordId=marryRecordId
    WndMarryManager.password=password
    MsgBoxManager:showConfirmCancelBox(string.format(LocalStrings.WEDDING_INVITE_TIPS,playerName),self,self.sureInviteFrienCallback)
end

--@brief  同意参加朋友婚礼
function WndMarryManager:sureInviteFrienCallback(id,opertionType)
    WZLog("WndMarryManager:sureInviteFrienCallback")
    if opertionType == MSGBOXRESTYPE_CONFIRM  then
        ProtocolProcessorGlobal:send_WEDDING_JoinWedding(WndMarryManager.marryRecordId ,WndMarryManager.password)
    end
    WndMarryManager.marryRecordId=nil
    WndMarryManager.password=nil
end

--@brief 设置仅是否是刷新数据
--param bFlag:是否刷新数据
function WndMarryManager:setIsRefreshData(bFlag)
    self.m_bRefreshData = bFlag
end

--@brief	移除窗口
--@param	wndElement，窗口的节点引用
--@param	wndLuaObj，窗口绑定的Lua表对象
--@note		当全局结婚消息来时，需要关闭当前所有结婚相关的窗口
function WndMarryManager:removeAllWindow()
    WZLog("WndMarryManager:removeAllWindow")
    WindowManager:removeWindow(WndMarry.m_root,WndMarry, true,false)
    WindowManager:removeWindow(WndMarryLetter.m_root,WndMarryLetter, true,false)
    WindowManager:removeWindow(WndMarryHoll.m_root,WndMarryHoll, true,false)
    WindowManager:removeWindow(WndMarryLetterList.m_root,WndMarryLetterList, true,false)
    WindowManager:removeWindow(WndMarryBetrothed.m_root,WndMarryBetrothed, true,false)
    WindowManager:removeWindow(WndMarryWeddingAsk.m_root,WndMarryWeddingAsk, true,false)
    WindowManager:removeWindow(WndWeddingDetails.m_root,WndWeddingDetails, true,false)
    if WindowManager:getSceneRoot():getLuaObjectName() == "SceneMarryWedding" then
        replaceScene(SceneCity:createElement())
    elseif WindowManager:getSceneRoot():getLuaObjectName() == "SceneMarryCopy" then
        replaceScene(SceneCity:createElement())
    elseif WindowManager:getSceneRoot():getLuaObjectName() == "SceneKidHome" then
        replaceScene(SceneCity:createElement())
    end
end

--@brief   创建加载框
function WndMarryManager:createLoading()
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

function WndMarryManager:showMarryHoll()
    WZLog("WndMarryManager:showMarryHoll", WndMarryManager.m_tMarryStatus.marryStatus, WndMarryManager.m_tMarryStatus.wedTime)
    -- self:setIsRefreshData(false)
    -- ProtocolProcessorWndMarry:send_WEDDING_GetMaritalStatus()
    -- self:createLoading()

    --20221117 nijinlin 点击前往结婚无反应
    -- self:initManager(2)
    -- self:createLoading()

    --20221121 nijinlin 点击前往夫妻
    if not (WndMarryManager.m_tMarryStatus.marryStatus == 2 and WndMarryManager.m_tMarryStatus.wedTime == -1) then
        if CheckButtonOpen(ISLAND_RIGHT_COUPLE) then
            WndCouple:showInterface()
        end
        return
    end
    if MsgBoxManager and LocalStrings.MARRY_DESC_42  then
        MsgBoxManager:showTipBox(LocalStrings.MARRY_DESC_42, 5)
    end
end

--@brief   关闭加载框
function WndMarryManager:closeLoading()
	local nId = self.m_nLoadingId
    if nId ~= nil and nId ~= -1  then
        MsgBoxManager:stopLoadingBoxByMsgId(nId)
    end
    self.m_nLoadingId = -1
end

--@brief 获取加载TAG
function WndMarryManager:getLoadingTag()
    return self.m_nLoadingId
end

----------------协议处理部分-----------------------------------------

--@brief 获得异性发送的求婚信/结婚函
--@brief sendName : 发送人名称
--@brief marryType : 【订婚：1鲜花，2戒指，3银行卡，4金钥匙】【结婚：1奢华，2:豪华，3:浪漫，4：普通】
--@brief marryMark : 婚姻状况标识(1是订婚，2是结婚)
--@brief timeId	:婚礼开始时间（订婚：-1，结婚是相应的ID）
--@brief marryRecordId : 结婚记录Id
--@brief sendFaceId : 发送人的脸装扮
--@brief sendHeadId : 发送人的头装扮
function WndMarryManager:getMarryLetterFromOther( sendName, marryType, marryMark,timeId,marryRecordId,sendFaceId,sendHeadId,playerId,headColor)

    if WindowManager:getTeachShelterLayer() or WndTeachTalk.m_root then return end
    --时间ID
	self.m_nTimeId = timeId
	WZLog("******************####********timeId**********",timeId)
	if IfActiveWindow(WndMarryLetterList) == false then
        --当前是求婚信界面时不移除窗口
        WZLog("IfActiveWindow(WndMarryLetterList) == false")
        self:removeAllWindow()
    end
	if IfActiveWindow(WndPurchase) == true then 
        WZLog("IfActiveWindow(WndPurchase) == true")
        WindowManager:removeWindow(WndPurchase.m_root,WndPurchase, true,false)
	end
	
	WZLog("WndMarryManager:getMarryLetterFromOther")
    if marryMark == 1 then
        --订婚
        local wndMarryLetter = WndMarryLetter:createElement()
        WndMarryLetter:setWindowType(WndMarryLetter.wndType.RECV_LETTER)
        WndMarryLetter:getMarryLetterFromOther(marryRecordId, sendName, marryType,sendFaceId,sendHeadId,playerId,headColor)
        WindowManager:addWindow(wndMarryLetter,WndMarryLetter,nil,nil,nil,true)
		--WndMarryLetter:setMyName(wndMarryLetter)
    else
        --结婚
        WZLog("proposeItemId:"..marryType)
        local weddingType = ""
        WndMarryManager.holdWeddingType = marryType
        
        if marryType == WndMarryManager.weddingType.LUXURY then
            weddingType = LocalStrings.WEDDING_LUXURY
        elseif marryType == WndMarryManager.weddingType.RICH then
            weddingType = LocalStrings.WEDDING_RICH
        elseif marryType == WndMarryManager.weddingType.ROMAN then
            weddingType = LocalStrings.WEDDING_ROMAN
        else
            weddingType = LocalStrings.WEDDING_ORIGINAL
        end
        local wndMarryWeddingAsk = WndMarryWeddingAsk:createElement()
        WndMarryWeddingAsk:setTextAndTitleImgPath(WndMarryWeddingAsk.wndType.RECIEVE,string.format(LocalStrings.WEDDING_ASK_TIPS,weddingType))
        WndMarryWeddingAsk:setMarryRecordId(marryRecordId)
        WndMarryWeddingAsk:setWeddingType(marryType)
		
		WndMarryWeddingAsk:setWeddinTime(timeId)
        WindowManager:addWindow(wndMarryWeddingAsk ,WndMarryWeddingAsk,nil,nil,nil,true)
    end
end

--@brief 获取婚姻状况成功的回调函数
--@param marryStatus : 婚姻状态（0：表示未婚，1：表示已订婚，2：表示已婚举办婚礼
--@param coupleId : 伴侣的Id
--@param coupleName : 伴侣名称
--@param weddingType : 婚礼类型（0：无，1：奢华，2：豪华，3：浪漫）
--@param wedTime 距离结婚时间的秒数（只有等待结婚的人才有，订婚或已经结过婚的为-1）
--@param divorceTime 离婚冷却时间戳
--@note  获取婚姻状况成功和获取求婚信成功为互斥协议，有求婚信是则服务器会返回获取求婚信成功
function WndMarryManager:getMarryStatusOK(marryStatus, coupleId, coupleName, weddingType,wedTime, divorceTime, divorceCDTime)
	WZLog("-------WndMarry:getMarryStatusOK---------",self.m_ntype)
	WZLog("marryStatus:"..marryStatus)
	WZLog("coupleId:"..coupleId)
	WZLog("coupleName:"..coupleName)
	WZLog("weddingType:"..weddingType)
    WZLog("wedTime:",wedTime)

    if not CheckButtonOpen(146,true) and not CheckButtonOpen(8,true) then
        CheckButtonOpen(8)
        return
    end
    
    --保存结婚状态数据
    self.m_tMarryStatus = {marryStatus = marryStatus,coupleId=coupleId,coupleName=coupleName,weddingType=weddingType,wedTime=wedTime}

    if self.m_bRefreshData == false then
        if self.m_ntype == 2 then
            if CheckButtonOpen(194) then
                ProtocolProcessorMarryHoll:send_WEDDING_GetWedList()
            end            
        else 
            if marryStatus ~= 2 or (marryStatus == 2 and wedTime ~= -1)then
        		if WndMarryHoll.m_root == nil then 
                    if WndCouple.m_root then 
                        WndCouple:showMarrHoll()
                    end
                    if WndMarryHoll and WndMarryHoll.m_root then
                        WndMarryHoll:onShowItemInfo(self.m_tMarryStatus.marryStatus, self.m_tMarryStatus.wedTime, divorceTime, divorceCDTime)
                    end
                else
                    -- if WndCouple.m_root then 
                    --     WndCouple:showMarrHoll()
                    -- end
                    WndMarryHoll:onShowItemInfo(self.m_tMarryStatus.marryStatus, self.m_tMarryStatus.wedTime, divorceTime, divorceCDTime)
                end
            else 
                if WndCouple.m_root then
                    WndCouple:showMarryWed()
                end
            end
        end
    end
    self.m_bRefreshData = false
end


--@brief 获取求婚信成功
--@param marryRecordId : 求婚信的Id
--@param sendPlayerName : 求婚人名称
--@param marryType : 类型【1鲜花，2戒指，3银行，4钥匙】
--@param sendTime : 发送求婚信时间
--@param headIds : 玩家头部形象
--@param faceIds : 玩家脸部形象
--@note  获取婚姻状况成功和获取求婚信成功为互斥协议，有求婚信是则服务器会返回获取求婚信成功
function WndMarryManager:getMarryLetterOK(marryRecordId, sendPlayerName, marryType, sendTime, headIds, faceIds, playerLevels, playerIds, headColors, serverId)
	WZLog("WndMarryManager:getMarryLetterOK")
    self.m_tMarryLetters = {}
    self.m_tMarryLetters.marryRecordId = {}
    self.m_tMarryLetters.sendPlayerName = {}
    self.m_tMarryLetters.marryType = {}
    self.m_tMarryLetters.sendTimes = {}
    self.m_tMarryLetters.headIds = {}
    self.m_tMarryLetters.faceIds = {}
    self.m_tMarryLetters.headColors = {}
    self.m_tMarryLetters.playerLevel = {}
    self.m_tMarryLetters.playerId = {}
    self.m_tMarryLetters.serverId = {}
	WZLog("WndMarryManager:getMarryLetterOK")
    for i = 0, marryRecordId:size()-1 do
        table.insert(self.m_tMarryLetters.marryRecordId, marryRecordId:get(i))
	end
    for i = 0, sendPlayerName:size()-1 do
        table.insert(self.m_tMarryLetters.sendPlayerName, sendPlayerName:get(i))
	end
    for i = 0, marryType:size()-1 do
        table.insert(self.m_tMarryLetters.marryType, marryType:get(i))
	end
    
    for i = 0, sendTime:size()-1 do
        table.insert(self.m_tMarryLetters.sendTimes, sendTime:get(i))
    end

    for i = 0, headIds:size()-1 do
        table.insert(self.m_tMarryLetters.headIds, headIds:get(i))
    end

    for i = 0, faceIds:size()-1 do
        table.insert(self.m_tMarryLetters.faceIds, faceIds:get(i))
    end

    for i = 0, playerLevels:size()-1 do
        table.insert(self.m_tMarryLetters.playerLevel, playerLevels:get(i))
    end

    for i = 0, playerIds:size()-1 do
        table.insert(self.m_tMarryLetters.playerId, playerIds:get(i))
    end

    for i = 0, headColors:size()-1 do
        table.insert(self.m_tMarryLetters.headColors, headColors:get(i))
    end

    for i = 0, serverId:size()-1 do
        table.insert(self.m_tMarryLetters.serverId, serverId:get(i))
    end
    
    if WndCouple.m_root then 
        WndCouple:showMarrHoll()
    end

    --在玩家A发送结婚请求给B，同一时间B也发送结婚请求，会造成窗口卡主。
    if IfActiveWindow(WndMarryLetter) == true and
        WndMarryLetter.m_nWindowType == WndMarryLetter.wndType.RECV_LETTER then
        WindowManager:removeWindow(WndMarryLetter.m_root,WndMarryLetter,true,false)
    end

    if #self.m_tMarryLetters.marryRecordId > 0 then
        if IfActiveWindow(WndMarryLetterList)  then
           WndMarryLetterList:update()
        else
             --显示求婚信窗口
            local wndMarryLetterList = WndMarryLetterList:createElement()
            WindowManager:addWindow(wndMarryLetterList,WndMarryLetterList,nil,nil,nil,true)
        end
        
    else
        if IfActiveWindow(WndMarryLetterList)  then
           WindowManager:removeWindow(WndMarryLetterList.m_root,WndMarryLetterList,true,false)
        end
        --没有结婚列表取消小红点
        ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(94)
    end
   
end

--@brief 更改婚姻状态成功，回调给玩家
--@brief isAgree : 是否同意
--@brief coupleName : 伴侣名称
--@brief marryMark : 婚姻状况标识(0是订婚，1是结婚)
function WndMarryManager:changeMarryStatusOK(isAgree, coupleName, marryMark)	
	WZLog("WndMarryManager:changeMarryStatusOK ",isAgree,coupleName,marryMark)
    if self.m_tMarryStatus == nil then
        self.m_tMarryStatus = {}
    end
     self.m_tMarryStatus.coupleName = coupleName
    if  isAgree == false then
        --拒绝方不弹出窗口
        return
    end
    self:_showMarryTips(isAgree, coupleName, marryMark)
	
	WZLog("boolIsWillingPropose = ",isAgree)
	WZLog("marryMark = ",marryMark)
	WZLog("WndMarryHoll.m_root = ",WndMarryHoll.m_root)
	--取得结婚信成功后
	if marryMark == 1 and isAgree == true then 
		if WndMarryHoll.m_root ~= nil then 
			GetElement(WndMarryHoll.m_root,"conMarryPurpose_WndMarryHoll"):setVisible(false)
			GetElement(WndMarryHoll.m_root,"conAddWedding_WndMarryHoll"):setVisible(true) 
		end 
	end 
	
end

--@brief 更改婚姻状态成功，推送给伴侣
--@brief isAgree : 是否同意
--@brief coupleName : 伴侣名称
--@brief marryMark : 婚姻状况标识(0是订婚，1是结婚)
function WndMarryManager:changeMarryStatusToCoupleOK(isAgree, coupleName, marryMark)
	WZLog("WndMarryManager:changeMarryStatusToCoupleOK")
     if self.m_tMarryStatus == nil then
        self.m_tMarryStatus = {}
    end
	
	--取得结婚信成功后
	if marryMark == 0 and isAgree == true then 
		if WndMarryHoll.m_root ~= nil then 
			GetElement(WndMarryHoll.m_root,"conMarryPurpose_WndMarryHoll"):setVisible(false)
			GetElement(WndMarryHoll.m_root,"conAddWedding_WndMarryHoll"):setVisible(true) 
		end 
	end 
    self.m_tMarryStatus.coupleName = coupleName
    self:_showMarryTips(isAgree, coupleName, marryMark)

    --如果在结婚礼堂,需要更新求婚按钮
    SceneWeddingDaily:updateProposeBtn()
end

--@brief  解除婚姻关系的消息，推送给伴侣
--@brief coupleName : 伴侣名称
--@brief marryMark : 婚姻状况标识(1是订婚,2是夫妻)
function WndMarryManager:getRemoveEngagementToCouple(coupleName, marryMark)
	WZLog("WndMarryManager:parse_WEDDING_RemoveEngagementToCouple = ",marryMark)
    local txt = LocalStrings.RELIEVE_RELATT_SUCCESS
    if coupleName ~= nil and marryMark ~= nil then
        if marryMark == 1 then
           txt = string.format(LocalStrings.MARRY_END_SUCCESS,coupleName)
        elseif marryMark == 2 then
           txt = string.format(LocalStrings.WEDDING_END_TIPS,coupleName)
        end
    end

    if WndCouple.m_root then
        WndCouple:showInterface(1)
    end
    MsgBoxManager:showConfirmBox(txt,nil,nil,nil,nil)
    self:removeAllWindow()
end

--@brief 赠送钻石成功,推送给伴侣
--@brief diamondCountGive : 所赠送的钻石数
--@brief coupleName : 伴侣名称
--@brief giveId : 赠送人Id
function WndMarryManager:getGiveDiamondOK(diamondCountGive, coupleName, giveId)
	WZLog("WndMarryManager:getGiveDiamondOK")
    if giveId == CacheCenter:getPlayerInfo().id then
        return
    end
    local wndMarryTips = WndMarryTips:createElement()
    WndMarryTips:setSureCallBackObjAndFun(self,self.sureToGiveDiamond)
    WndMarryTips:setTipsContent(WndMarryTips.wndType.TIPS,string.format(LocalStrings.GIVE_DIAMOND_TIPS,coupleName,diamondCountGive))
    WindowManager:addWindow(wndMarryTips , WndMarryTips)
end

--@brief 播放全服结婚动画
--@brief weddingType : 婚礼类型（-10：奢华，-9：豪华，-8：浪漫，-7：普通）
--@brief recieveName : 全服公告里面接受者的名字
--@brief sendName : 全服公告里面发送者的名字

local ANIMATION_TAG = 9871654

function WndMarryManager:playAllServerMarryAnimation(weddingType,recieveName,subType,sendName)
	--在战斗中不播放结婚动画
	if GlobalGame.g_bIfInBattle == true then 
		return 
	end    
	
    local playerName = CacheCenter:getPlayerInfo().name
	
    WZLog("WndMarryManager:playAllServerMarryAnimation")
    WZLog("播放全局画动作类型subType = ",subType)
	--1,2是浪漫
    local animationName = nil
	
end

--@brief 播放全服结婚动画
--@brief recieveName : 全服公告里面接受者的名字
function WndMarryManager:_XmlActionFinishCallback() 
    local animation = WindowManager:getSceneRoot():getChildByTag(ANIMATION_TAG)
    if animation == nil then
        return
    end
    WZLog("WndMarryManager:_XmlActionFinishCallback")
    WindowManager:getSceneRoot():removeChild(animation,true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief   显示发送求婚信是否成功的状态
function WndMarryManager:_showMarryLetterTips(result)
   local txt = nil
   if result == 1 then
        txt = LocalStrings.SEND_PROPOSAL_LETTER1
    elseif result == 2 then
        txt = LocalStrings.SEND_PROPOSAL_LETTER2
    elseif result == 3 then
        txt = LocalStrings.SEND_PROPOSAL_LETTER3
    elseif result == 4 then
        txt = LocalStrings.SEND_PROPOSAL_LETTER4
    elseif result == 5 then
        txt = LocalStrings.SEND_PROPOSAL_LETTER5
    elseif result == 6 then
        txt = LocalStrings.SEND_PROPOSAL_LETTER6
    elseif result == 7 then
        txt = LocalStrings.SEND_PROPOSAL_LETTER7
    elseif result == 8 then
        txt = LocalStrings.SEND_PROPOSAL_LETTER8
    elseif result == 9 then
        local num = CacheCenter:getGameParam().marryFriendNum
        txt =string.format(LocalStrings.SEND_PROPOSAL_LETTER9,num)
    end
    if txt ~= nil then
        MsgBoxManager:showTipBox(txt)
    end
end

--@brief  到一定时间后删除动画
function WndMarryManager:_scheduleRemovePar(element,delta)
    element:disableSchedule()
    element:removeFromParentAndCleanup(true)
end

--@brief    显示求婚/结婚成功，失败窗口
--@brief boolIsWillingPropose : 是否同意
--@brief coupleName : 伴侣名称
--@brief marryMark : 婚姻状况标识(0是订婚，1是结婚)
function WndMarryManager:_showMarryTips(boolIsWillingPropose, coupleName, marryMark)
    self:removeAllWindow()
    local txt = nil
    local sTipImgPath = nil
    local bSuccess = false
    local iWndType = WndMarryTips.wndType.WEDDING_OK
    if marryMark == 1 then
        --订婚
        if boolIsWillingPropose == true then
            --成功
            txt = string.format(LocalStrings.MARRY_OK,coupleName)
            sTipImgPath = "ui/marrige/marry_scale9_cgdk.png"
            iWndType = WndMarryTips.wndType.WEDDING_OK
            bSuccess = true
            if WndMarryHoll.m_root then
                WndMarryHoll:onShowItemInfo(1,-1)
            end
        else
            --失败
            txt = string.format(LocalStrings.MARRY_FAILD,coupleName)
            sTipImgPath = "ui/marrige/marry_scale9_sbdk.png"
            bSuccess = false
            iWndType = WndMarryTips.wndType.WEDDING_FAILD
        end
    else
        --结婚
        if boolIsWillingPropose == true then
            --成功
            txt = string.format(LocalStrings.WEDDING_SUCCUSS,coupleName)
            sTipImgPath = "ui/marrige/marry_scale9_cgdk.png"
            iWndType = WndMarryTips.wndType.WEDDING_OK
            bSuccess = true
            
        else
            --失败
            txt = LocalStrings.WEDDING_FAILD
            sTipImgPath = "ui/marrige/marry_scale9_sbdk.png"
            bSuccess = false
            iWndType = WndMarryTips.wndType.WEDDING_FAILD
        end
    end
    WZLog("ndMarryManager:_showMarryTips")
    local wndMarryTips = WndMarryTips:createElement()
    WndMarryTips:setTipsContent(iWndType, txt, sTipImgPath)
    WindowManager:addWindow(wndMarryTips ,WndMarryTips,nil,nil,nil,true)
    
end

--@brief  显示本服有人结婚成功的粒子效果
function WndMarryManager:showGlobalWeddingMes(marryType)
    WZLog("WindowManager:showGlobalWeddingMes")
    local animationName1  =  "qiuhun01"
    local animationName2  =  "qiuhun02"
    local animationName3  =  "qiuhun03"
    
    if marryType == WndMarryManager.weddingType.LUXURY and not WndMarryManager.isShowParticle  then
        
        local element1 = WZUISystem:getInstance():createElement(animationName1)
        element1 = WZUIContainer:luaTo(element1)
        element1:setTouchEnable(false)
        WindowManager:getSceneRoot():addChild(element1,99999,3*6*9)

        local element2 = WZUISystem:getInstance():createElement(animationName2)
        element2 = WZUIContainer:luaTo(element2)
        element2:setTouchEnable(false)
        WindowManager:getSceneRoot():addChild(element2,99999,3*6*8)

        local element3 = WZUISystem:getInstance():createElement(animationName3)
        element3 = WZUIContainer:luaTo(element3)
        element3:setTouchEnable(false)
        WindowManager:getSceneRoot():addChild(element3,99999,3*6*7)
        WndMarryManager.isShowParticle = true
        DelayCallFunction(function ()
            
            local sceneRoot = WindowManager:getSceneRoot()
            local child1 = GetElement(sceneRoot,"qiuhun01",WZUIContainer)
            local child2 = GetElement(sceneRoot,"qiuhun02",WZUIContainer)
            local child3=  GetElement(sceneRoot,"qiuhun03",WZUIContainer)
            WndMarryManager.isShowParticle = false
            
            if child1 and child2 and child3 then
                child1:removeFromParentAndCleanup(true)
                child2:removeFromParentAndCleanup(true)
                child3:removeFromParentAndCleanup(true)
            end
        end,nil,5)
        
    elseif marryType == WndMarryManager.weddingType.RICH and not WndMarryManager.isShowParticle then
        
        local element1 = WZUISystem:getInstance():createElement(animationName3)
        element1 = WZUIContainer:luaTo(element1)
        element1:setTouchEnable(false)
        WindowManager:getSceneRoot():addChild(element1,99999,2*6*9)

        local element2 = WZUISystem:getInstance():createElement(animationName2)
        element2 = WZUIContainer:luaTo(element2)
        element2:setTouchEnable(false)
        WindowManager:getSceneRoot():addChild(element2,99999,2*6*8)
            
        DelayCallFunction(function ()
            local sceneRoot = WindowManager:getSceneRoot()
            local child1 = GetElement(sceneRoot,"qiuhun02",WZUIContainer)
            local child2 = GetElement(sceneRoot,"qiuhun03",WZUIContainer)
            if child1 and child2 then
                child1:removeFromParentAndCleanup(true)
                child2:removeFromParentAndCleanup(true)
                WndMarryManager.isShowParticle = false
            end
        end,nil,5)
    elseif marryType == WndMarryManager.weddingType.ROMAN and not WndMarryManager.isShowParticle  then
        
        local element = WZUISystem:getInstance():createElement(animationName2)
        element = WZUIContainer:luaTo(element)
        element:setTouchEnable(false)

        WindowManager:getSceneRoot():addChild(element,99999,1*6*9)
        
        DelayCallFunction(function ()
            local sceneRoot = WindowManager:getSceneRoot()
            local child1 = GetElement(sceneRoot,"qiuhun02",WZUIContainer)
            if child1  then
                child1:removeFromParentAndCleanup(true)
                WndMarryManager.isShowParticle = false
            end
        end,nil,5)
    end
end


-------------------------------------私有方法模块End----------------------------------------

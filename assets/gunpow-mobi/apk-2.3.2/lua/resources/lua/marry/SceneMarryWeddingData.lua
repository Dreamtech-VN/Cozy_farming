--SceneMarryWeddingData.lua
--@brief	SceneMarryWedding的数据模块
--@date		2015/08/12
--@author	qixiang_xie
--@note		夫妻关系界面

SceneMarryWedding = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneMarryWedding:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nSendGiftCount = 0           --玩家今日可以赠送礼物的次数
    self.m_nLoveLevel = 0               --当前恩爱等级    
    self.m_bLoadFinish = false
    self.m_nSendItemId = nil            --当前正在送礼物的ID
    self.m_tGiftList = nil
    self.m_tKidData = nil               --孩子的信息
    self.m_nNeedPay = 1                 --离婚是否需要付费0不需要 1需要支付

    self.m_logInfo = nil                --恩爱日志数据
    self.m_nGiftTag = nil               --送礼物类型
    self.m_nDivorceCDTime = nil         --离婚后需要等待多少秒才能再婚
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneMarryWedding:_unInit()
	self.m_root = nil
	self.m_nSendGiftCount = 0           --玩家今日可以赠送礼物的次数
    self.m_nLoveLevel = 0               --当前恩爱等级
    self.m_bLoadFinish = nil
    self.m_nSendItemId = nil
    self.m_tGiftList = nil
    self.m_tKidData = nil               --孩子的信息
    self.m_nNeedPay = nil

    WndMultiCopy.g_nBackRoomState = 0

    self.m_logInfo = nil                --恩爱日志数据
    self.m_nGiftTag = nil               --送礼物类型
    self.m_nDivorceCDTime = nil         --离婚后需要等待多少秒才能再婚
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneMarryWedding:createElement()
	local element = WZUISystem:getInstance():createElement("SceneMarryWedding")
	assert(element, "SceneMarryWedding create element failed!")
	self:_init()
	return element
end

--@brief    外部接口
function SceneMarryWedding:showInterface()
    -- body
    local scene = SceneMarryWedding:createElement()
    replaceScene(scene)
end

--@brief   结婚日志排序
function sortWeddingLoveLog(a,b)
  if a.createDate > b.createDate then
    return true
  else
    return false
  end
end

--@brief  获取恩爱日志成功(显示恩爱日志)
function SceneMarryWedding:getLovingDaily(logType, createDate, leftPlayerName, rightPlayerName, itemName, loveExp)
	WZLog("SceneMarryWedding:getLovingDaily ")
    -- if #logType == 0 then
    --     MsgBoxManager:showTipBox(LocalStrings.LOVING_DAILY)
    --     return
    -- end
	local temp = {}
    for i,v in ipairs(logType) do
        local logInfos = {}
        logInfos.logType = v
        logInfos.createDate = createDate[i]
        logInfos.leftPlayerName = leftPlayerName[i]
        logInfos.rightPlayerName = rightPlayerName[i]
        logInfos.itemName = itemName[i]
        logInfos.loveExp = loveExp[i]
        table.insert(temp,logInfos)
    end
    table.sort(temp,sortWeddingLoveLog)
	
    local logInfo = {}
    local playerName = CacheCenter:getPlayerInfo().name
    local daily = nil
    for i,v in ipairs(temp) do
    	local strTime = os.date("%m-%d %H:%M",v.createDate)
    	if v.logType ==1 then
    	    if v.leftPlayerName == playerName then
    	    	daily = string.format(LocalStrings.LOVING_DIARY_1,v.rightPlayerName,v.itemName,v.loveExp,strTime)
                -- 
    	    elseif v.rightPlayerName == playerName then
    	    	daily = string.format(LocalStrings.LOVING_DIARY_2,v.leftPlayerName,v.itemName,v.loveExp,strTime)
            else 
                daily = string.format(LocalStrings.LOVING_DIARY_4,v.leftPlayerName,v.rightPlayerName,v.itemName,v.loveExp,strTime)
    	    end
    	    table.insert(logInfo,daily)
    	elseif v.logType==2 then
    	    daily = string.format(LocalStrings.LOVING_DIARY_3,v.loveExp,strTime)
    	    table.insert(logInfo,daily)
    	end
    end
    
    self.m_logInfo = logInfo
    self:updateLog()
end

--@brief  处理从服务端获取到的夫妻关系信息
--@param  manName : 男方名称
--@param  womanName : 女方名称
--@param  loveExp ： 恩爱经验
--@param  loveLevel : 恩爱等级
--@param  giftNum ：礼物剩余次数

function SceneMarryWedding:receivePropInfo(manName, womanName, loveExp, loveLevel, giftNum, manHeadId, manFaceId, manBodyId, manWingId, womanHeadId, womanFaceId, womanBodyId, womanWingId,partnerId,manHeadColor,manBodyColor,womanHeadColor,womanBodyColor, manServerId, womanServerId, manSkillEndTime, womanSkillEndTime)
	WZLog("SceneMarryWedding:receivePropInfo =",partnerId,giftNum)
    WndMarryManager:closeLoading()
    self.loveId = partnerId
    -- if self.m_root == nil then
    --     local seneMarryWedding = SceneMarryWedding:createElement()
    --     --WindowManager:addWindow(seneMarryWedding, SceneMarryWedding)
    --     replaceScene(seneMarryWedding)
    -- end
    if loveLevel == 0 then
        loveLevel = loveLevel + 1
    end
    self.m_nLoveLevel = loveLevel 
    self.m_sManeName = manName
    self.m_sWomanName = womanName
    self.m_nLoveExp = loveExp
    self.m_nGiftNum = giftNum
    self.m_nManHeadId = manHeadId
    self.m_nManFaceId = manFaceId
    self.m_nManBodyId = manBodyId
    self.m_nManWingId = manWingId
    self.m_nManHeadColor = manHeadColor
    self.m_nManBodyColor = manBodyColor
    self.m_nManServerId = manServerId

    self.m_nWomanHeadId = womanHeadId
    self.m_nWomanFaceId = womanFaceId
    self.m_nWomanBodyId = womanBodyId
    self.m_nWomanWingId = womanWingId
    self.m_nWomanHeadColor = womanHeadColor
    self.m_nWomanBodyColor = womanBodyColor
    self.m_nWomanServerId = womanServerId

    self.m_nManSkillEndTime = manSkillEndTime
    self.m_nWomanSkillEndTime = womanSkillEndTime

    local sexx = CacheCenter:getPlayerInfo().sex
    if sexx == 0 then
        self.m_nWifeId = partnerId
        self.m_nHudandId = CacheCenter:getPlayerInfo().id
    else
        self.m_nWifeId = CacheCenter:getPlayerInfo().id
        self.m_nHudandId = partnerId
    end
    

    if self.m_root ~= nil then
        self:updateInfo()
    end
end

function SceneMarryWedding:getLoveId()
    return self.loveId
end

--@brief    收到离婚时候小孩的信息
function SceneMarryWedding:getKidDataOK(fatherDevote, motherDevote, ownerId, childId, sex, childName, headId, faceId, level, childFight, childProp, needPay, headEffectId, divorceCDTime)
    -- body
    self.m_tKidData = {}
    self.m_nNeedPay = needPay
    self.m_nDivorceCDTime = divorceCDTime

    for i = 1, #childId do
        local tItem = {}

        tItem.id = childId[i]
        tItem.name = childName[i]
        tItem.headId = headId[i]
        tItem.faceId = faceId[i]
        tItem.sex = sex[i]
        tItem.level = level[i]
        tItem.fatherDevote = fatherDevote
        tItem.motherDevote = motherDevote
        tItem.needPay = needPay
        tItem.ownerId = ownerId[i]
        tItem.fighting = childFight[i]
        tItem.property = childProp[i]
        tItem.headEffectId = headEffectId[i]

        table.insert(self.m_tKidData, tItem)
    end
    WZLog("SceneMarryWedding:getKidDataOK", Serialize(self.m_tKidData))
    if #self.m_tKidData == 0 then
        self:noKidDivorce()
    else
        WndParentsCare:showInterface(3, needPay)
        WndParentsCare:setData(self.m_tKidData, nil, self.m_nDivorceCDTime)
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------


function SceneMarryWedding:_addTop()
    local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_jh.png",SceneMarryWedding,SceneMarryWedding.onCloseClick,true,true,true,"SceneMarryWedding")
end


-------------------------------------私有方法模块End----------------------------------------

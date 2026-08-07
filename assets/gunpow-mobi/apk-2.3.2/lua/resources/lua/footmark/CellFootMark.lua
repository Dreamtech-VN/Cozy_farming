--CellFootMark.lua
--@brief	CellFootMark的UI模块
--@date		2017/11/21
--@author	Tianxiang_Xu
--@note		足迹系统-足迹Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFootMark:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFootMark:onExit(element)
	self.m_root:disableSchedule()
	self:_unInit()
end


-- 加载数据
function CellFootMark:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellFootMark")
    self.m_root:addChild(cellElement)
    self.loadEnd = true
    self:_update()
    AdaptLanguage(self)
end

--@brief	选中足跡
function CellFootMark:onSelect(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = self.m_tData.id
    WZLog("----------onSelect--------------",tag)
    WndFootMark:onClickFootMark(tag)
    WndFootMark:showRunAni()
end

--@brief    点击使用按键
function CellFootMark:onFighting(element)
    WZLog("---------------------fighting----------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = self.m_tData.id
    WndFootMark:onClickFootMark(tag)
    ProtocolProcessorFootMark:send_FOOTMARK_ChangeState(self.m_tData.id)
end

--@brief    点击隱藏按键
function CellFootMark:onDown(element)
    WZLog("---------------------onDown----------------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    ProtocolProcessorFootMark:send_FOOTMARK_ChangeState(self.m_tData.id)
end

--@brief	购买足迹确认
function CellFootMark:buyMountConfirm()
    local data = self:getWayResult()
     WZLog("CellFootMark:buyMountConfirm ")
    CellFootMark.m_currentClick = self
    if JudgeMoneyIsEnough(data.payId, data.payCnt,nil,nil,67, nil, nil, nil, nil, self, self.sureUseDiamondInstead) then
        self:sureUseDiamondInstead()
    else
        WndFastGetItems:show(self.m_tData.basicInfo.id)
    end
end

--@brief    确认用钻石代替礼券购买足迹
function CellFootMark:sureUseDiamondInstead()
    -- body
    WZLog("CellFootMark:sureUseDiamondInstead", type(CellFootMark.m_currentClick.m_tData.basicInfo.id))
    g_nUseFootMarkId = CellFootMark.m_currentClick.m_tData.basicInfo.id
    ProtocolProcessorFootMark:send_FOOTMARK_UseFootmark(CellFootMark.m_currentClick.m_tData.basicInfo.id)
end

--@brief    解锁
function CellFootMark:onUnlock()
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local data = self:getWayResult()
    WZLog("CellFootMark:onUnlock", Serialize(self.m_tData))
    if data.type == 3 then
        if data.payId == 1 or data.payId == 2 or data.payId == 70 then
            local str = string.format(LocalStrings.FOOTMARK_TEXT12,GDatatab_item["id_" .. data.payId].name,data.payCnt)
            MsgBoxManager:showConfirmBox(str, self, self.buyMountConfirm, MSGBOXLEVEL_HIGH, nil)
        else
            local itemInfo = GDatatab_item["id_"..data.payId]
            local str = string.format(LocalStrings.FOOTMARK_TEXT12,itemInfo.name.."x",data.payCnt)
            MsgBoxManager:showConfirmBox(str, self, self.buyMountConfirm, MSGBOXLEVEL_HIGH, nil)
        end
    else
        if data.isUnlock then
            g_nUseFootMarkId = self.m_tData.basicInfo.id
            ProtocolProcessorFootMark:send_FOOTMARK_UseFootmark(self.m_tData.basicInfo.id)
        else
            if data.type == 2 then MsgBoxManager:showTipBox(data.str) end
        end
    end
end

--@brief    当前足迹的获取信息
function CellFootMark:getWayResult()
    local tItem,count = self:_getWay() -- count = 1 表示赠送， 2表示等级领取，3 表示购买
    WZLog("CellFootMark:getWayResult", count)
    -- 获取方式和结果
    if count == 1 then
        if self.m_tData.state == false then
            data = {type = count,isUnlock = true}
        else
            data = {type = count, isUnlock = false, str = LocalStrings.MOUNTS_GM_GET}
        end
    elseif count == 2 then
        data = self:_judgeLvGet(tItem,count)
    elseif count == 3 then
        data = {type = count, isUnlock = false, payType = tItem.s,payId = tItem.t, payCnt = tItem.v}
    end

    return data
end

--@brief    设置选中状态
function CellFootMark:setSelectState(isSel)
    self.selState = isSel
    if self.loadEnd == false then return end
    local img = GetElement(self.m_root,"imgSel_CellFootMark",WZUI9Image)
    img:setVisible(self.selState)
end

--@brief 	获取足迹Id
function CellFootMark:getFootMarkId()
	-- body
	return self.m_tData.id
end
---------------------------------------公有方法模块End----------------------------------------

---------------------------------------私有方法模块Begin--------------------------------------
function CellFootMark:_update()
    -- 头像
    self:_createImage()
    -- 信息
    self:_initMountInfo()
    -- 按键状态
    self:_initBtnState()
end

function CellFootMark:_initMountInfo()
    -- 等级和名字
    local txtLv = GetElement(self.m_root,"txtLv_CellFootMark",WZUILabelTTF)
    txtLv:setText("Lv"..self.m_tData.upgradeLevel)
    txtLv:setColor(QUALITYCOLOR[self.m_tData.basicInfo.quality])
    local txtName = GetElement(self.m_root,"txtName_CellFootMark",WZUILabelTTF)
    txtName:setText(self.m_tData.basicInfo.name)
    txtName:setColor(QUALITYCOLOR[self.m_tData.basicInfo.quality])

    local imgRed = GetElement(self.m_root,"imgRed_CellFootMark",WZUIImage)
    local txtLock = GetElement(self.m_root,"txtLock_CellFootMark",WZUILabelTTF)
	local conMountstars = GetElement(self.m_root,"conMountstars_CellFootMark",WZUIContainer)
	local nCurTime = SystemTime:getServerTime()
    -- 解锁状态或星级
    if self.m_tData.remainTime == -1 or self.m_tData.remainTime > nCurTime then
        -- 星级
        if self.m_tData.remainTime == -1 then 
	        conMountstars:setVisible(true)
	        txtLock:setVisible(false)
	        local starCnt = self.m_tData.advancedLevel
	        local imgPath = {"ui/common/common_icon_xingxing2.png","ui/common/common_09.png" }
	        for i =1, 10 do
	            local index = starCnt >= i and 1 or 2
	            local star = GetElement(self.m_root,"imgStar"..i.."_CellFootMark",WZUIImage)
	            star:setFile(imgPath[index])
	        end
	        imgRed:setVisible(false)
	    elseif self.m_tData.remainTime > nCurTime then
	    	local nLeftSeconds = self.m_tData.remainTime - nCurTime
	    	self:_showLeftTime(nLeftSeconds)
	    	self.m_root:enableSchedule("caculateTime", 1)
	    end
        imgRed:setVisible(false)
    elseif self:_judgeLockState() then
        txtLock:setText(LocalStrings.FOOTMARK_TEXT18)
        txtLock:setColor(GlobalMethod:ccc3(5,180,0))
        txtLock:setVisible(true)
        imgRed:setVisible(true)
    else
        txtLock:setText(LocalStrings.STAR_SOUL_NOT_ACTIVE)
        txtLock:setColor(GlobalMethod:ccc3(255,89,74))
        txtLock:setVisible(true)
        imgRed:setVisible(false)
    end

    -- 是否选中
    local img = GetElement(self.m_root,"imgSel_CellFootMark",WZUI9Image)
    img:setVisible(self.selState)
end

--@brief    创建足迹头像
function CellFootMark:_createImage()
    local conImage = GetElement(self.m_root,"conImage_CellFootMark",WZUIContainer)
    local childNode = conImage:getChildByTag(122)
    if not childNode then
        local cell,tcell = CellGoodItem:createElement()
        if cell then
            cell = WZUIContainer:luaTo(cell)
            tcell:setCellGoodItem(self.m_tData,10)
            tcell:setBackImgFile2()
            conImage:addChild(cell,0,122)
        end
    end
end

-- 初始化宠物状态 1出战  2乘骑  3 锁定
function CellFootMark:_initBtnState()
    local state = 3
    local nUsingFootMarkId = CacheCenter:getUsingFootMarkId()
    local nCurTime = SystemTime:getServerTime()

    if self.m_tData.remainTime == -1 or self.m_tData.remainTime > nCurTime then state = 2 end
    if self.m_tData.id == nUsingFootMarkId then state = 1 end

    for i = 1, 3 do
        local con = GetElement(self.m_root, "conState" .. i .. "_CellFootMark", WZUIContainer)
        if con then
            con:setVisible(i == state)
        end
    end

end

-- 判断解锁状态
-- self.m_tData.state = nil 表示没有该坐骑， false表示有该坐骑，但是没有领取， true表示有该坐骑并且领取了
function CellFootMark:_judgeLockState()
    local tItem,count = self:_getWay() -- count = 1 表示赠送， 2表示等级领取，3 表示购买
    if count == 1 then
        -- 符合赠送条件，可以解锁
        WZLog("----------lock state1-----------",self.m_tData.state)
        if self.m_tData.state == false then return true end
    elseif count == 2 then
        -- 符合等级领取条件可以解锁
        WZLog("----------lock state2-----------",tItem.v,self.m_tData.state)
        local data = self:_judgeLvGet(tItem,count)
        return data.isUnlock
    elseif count == 3 then
        -- 物品够，提示红点，钻石除外
        local costId,costCnt = tItem.t,tItem.v
        local curCnt = CacheCenter:getPlayerItemCountById(costId)
        WZLog("----------lock state3-----------",costId,costCnt,curCnt)
        if costId == 1 then
            return false
        else
            if curCnt >= costCnt then return true end
            return false
        end
    end
    return false
end


-- 坐骑获取方式
function CellFootMark:_getWay()
    local tData = self.m_tData.tItem.way
    local tItem = {s = 0,t = 0,v = 0}
    local count = #tData
    local type = count
    if count == 1 then
        tItem.s = tData[1][2]      -- 赠送
    elseif count == 2 then
        tItem.s = tData[1][2]      -- 等级(1 玩家等级 5竞技等级 6 恩爱等级 7 公会等级 8排位等级)
        tItem.v = tData[2][2]
    else
        tItem.s = tData[1][2]       -- 购买方式
        tItem.t = tData[2][2]       -- 货币ID
        tItem.v = tData[3][2]       -- 货币的数量
    end
    return tItem,count
end

function CellFootMark:_judgeLvGet(tItem,count)
    local lv1 = CacheCenter:getPlayerInfo().level
    local lv5 = CacheCenter:getPlayerInfo().tournamentLevel
    local lv6 = CacheCenter:getPlayerInfo().loveLevel
    local lv7 = CacheCenter:getPlayerInfo().guildLevel
    local lv8 = CacheCenter:getPlayerInfo().segmentLevel
    WZLog("---------------player cur level data-------------------",lv1,lv5,lv6,lv7,lv8)
    local data = {}
    local lvType = tItem.s
    local needLv = tItem.v
    local playerLv = {lv1,nil,nil,nil,lv5,lv6,lv7,lv8 }
    local desc = {LocalStrings.MOUNTS_LEVEL_GET,nil,nil,nil,LocalStrings.MOUNTS_LEVEL_GET5,LocalStrings.MOUNTS_LEVEL_GET6,LocalStrings.MOUNTS_LEVEL_GET7,LocalStrings.MOUNTS_LEVEL_GET8}

    if playerLv[lvType] >= needLv and self.m_tData.state == nil then
        data = {type = count,isUnlock = true }
    else
        -- 竞技场等级提示额外处理
        if lvType == 5 then needLv = GDatatab_integral["id_"..needLv].dan end
        data = {type = count,isUnlock = false, str = string.format(desc[lvType],needLv)}
    end
    return data
end

--@brief 	计算体验时间
function CellFootMark:caculateTime()
	-- body
	local nCurTime = SystemTime:getServerTime()
	local nLeftSeconds = self.m_tData.remainTime - nCurTime
	if nLeftSeconds > 0 then 
		self:_showLeftTime(nLeftSeconds)
    else
    	self.m_root:disableSchedule()
    	self.m_tData.isHave = false
        self.m_tData.upgradeLevel = 0
    	--更新缓存数据
    	CacheCenter:updateAfterUseTimeEnd(self.m_tData.id)
    	WndFootMark:updateAfterUseTimeEnd(self.m_tData.id)
    	self:_initMountInfo()
    	self:_initBtnState()
	end
end

--@brief 	展示剩余体验时间
function CellFootMark:_showLeftTime(nLeftSeconds)
	-- body
	local nDays, nHours, nMinutes, nSeconds 
	local txtLock = GetElement(self.m_root,"txtLock_CellFootMark",WZUILabelTTF)
	if nLeftSeconds >= 24 * 3600 then 
		nDays = math.floor(nLeftSeconds/(24*3600))
		txtLock:setText(LocalStrings.FOOTMARK_TEXT22 .. ":" .. nDays .. LocalStrings.DAY)
	else
		nHours = math.floor(nLeftSeconds/3600)
		nMinutes = math.floor((nLeftSeconds - nHours * 3600)/60)
		nSeconds = nLeftSeconds - nHours * 3600 - nMinutes * 60
		local sTimeFormat = LocalStrings.FOOTMARK_TEXT22 .. ":" .. "%02d:%02d:%02d"
		txtLock:setText(string.format(sTimeFormat, nHours, nMinutes, nSeconds))
	end
	txtLock:setColor(GlobalMethod:ccc3(0,72,3))
	txtLock:setVisible(true)
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellFootMark:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtLv_CellFootMark",WZUILabelTTF):setFontSize(16)
    local txtName = GetElement(self.m_root,"txtName_CellFootMark",WZUILabelTTF)
    txtName:setFontSize(14)
    txtName:setRelativePosition(GlobalMethod:ccp(0.2,0.5))
    txtName:setDimensions(GlobalMethod:CCSize(180,0))
    
    GetElement(self.m_root,"txtState1_CellFootMark",WZUILabelTTF):setScale(0.7)

    local txtLock = GetElement(self.m_root,"txtLock_CellFootMark",WZUILabelTTF)
    txtLock:setScale(0.65)
end

function CellFootMark:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtLv_CellFootMark",WZUILabelTTF):setFontSize(16)
    local txtName = GetElement(self.m_root,"txtName_CellFootMark",WZUILabelTTF)
    txtName:setFontSize(14)
    txtName:setRelativePosition(GlobalMethod:ccp(0.2,0.5))
    txtName:setDimensions(GlobalMethod:CCSize(180,0))

    GetElement(self.m_root,"txtState1_CellFootMark",WZUILabelTTF):setScale(0.7)
    
    local txtLock = GetElement(self.m_root,"txtLock_CellFootMark",WZUILabelTTF)
    txtLock:setScale(0.65)
end

function CellFootMark:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtLv_CellFootMark",WZUILabelTTF):setScale(0.7)
    local txtName = GetElement(self.m_root,"txtName_CellFootMark",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(270,0))

    GetElement(self.m_root,"txtLock_CellFootMark",WZUILabelTTF):setScale(0.7)
end

function CellFootMark:_adaptLanguage_tr(  )
    GetElement(self.m_root,"txtLv_CellFootMark",WZUILabelTTF):setFontSize(16)
    local txtName = GetElement(self.m_root,"txtName_CellFootMark",WZUILabelTTF)
    txtName:setFontSize(14)
    txtName:setRelativePosition(GlobalMethod:ccp(0.2,0.5))
    txtName:setDimensions(GlobalMethod:CCSize(180,0))
    
    GetElement(self.m_root,"txtState1_CellFootMark",WZUILabelTTF):setScale(0.7)
    GetElement(self.m_root,"txtLock_CellFootMark",WZUILabelTTF):setScale(0.8)
end

function CellFootMark:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtLv_CellFootMark",WZUILabelTTF):setScale(0.8)
    local txtName = GetElement(self.m_root,"txtName_CellFootMark",WZUILabelTTF)
    txtName:setScale(0.8)
end

function CellFootMark:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtLv_CellFootMark",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtLock_CellFootMark",WZUILabelTTF):setScale(0.8)
end

function CellFootMark:_adaptLanguage_ug(  )
    GetElement(self.m_root,"txtLv_CellFootMark",WZUILabelTTF):setScale(0.7)
    local txtName = GetElement(self.m_root,"txtName_CellFootMark",WZUILabelTTF)
    txtName:setScale(0.7)
    txtName:setDimensions(GlobalMethod:CCSize(270,0))

    GetElement(self.m_root,"txtLock_CellFootMark",WZUILabelTTF):setScale(0.7)

    GetElement(self.m_root,"txtState1_CellFootMark",WZUILabelTTF):setScale(0.65)
    GetElement(self.m_root,"txtState2_CellFootMark",WZUILabelTTF):setScale(0.65)
end
-------------------------------------语言适配End--------------------------------------------
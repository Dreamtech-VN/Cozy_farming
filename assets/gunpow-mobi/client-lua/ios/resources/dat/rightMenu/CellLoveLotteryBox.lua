--CellLoveLotteryBox.lua
--@brief	CellLoveLotteryBox的UI模块
--@date		2017/10/20
--@author	Tianxiang_Xu
--@note		幸运转盘保底奖励进度


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellLoveLotteryBox:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellLoveLotteryBox:onExit(element)
	self:_unInit()
end

--@brief    界面加载完成回调
function CellLoveLotteryBox:onEnterTransitionDidFinish()
    -- body
    WndGameActivity:_createLoading()
    ProtocolProcessorWndActivityOnLine:send_ACTIVITY_GetLuckActivityInfo()
end

function CellLoveLotteryBox:onClickRewardBox(element)
    -- body
    WZLog("CellLoveLotteryBox:onClickRewardBox")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local tag = element:getTag()
    local rewardList = {}
    rewardList.strartNum = nil
    rewardList.icon = {}   
    rewardList.num = {}
    rewardList.nType = 3
    rewardList.strartNum = self.m_tData.curTimes
   
    rewardList.endNum = self.m_tData.lotteryCount[tag]

    for i,v in ipairs(self.m_tData.lotteryReward) do
        if i == tag then
            local ids,nums = SplitItemString(v)
            if ids ~= nil and #ids > 0 then
                for j,k in ipairs(ids) do
                    table.insert(rewardList.icon,GDatatab_item["id_" .. k].icon)
                    table.insert(rewardList.num,nums[j])
                end
            end
        end
    end

    WndTips:show(element,WndGameActivity.m_root,3,rewardList,GlobalMethod:ccp(0,0))
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellLoveLotteryBox:_update()
    -- body
    local tData = self.m_tData 
    --进度
    local prgTimes = GetElement(self.m_root, "prgTimes_CellLoveLotteryBox", WZUIProgress)
    if prgTimes then 
        if tData.curTimes <= tData.firstTimes then 
            prgTimes:setPercentage(math.floor(tData.curTimes * 33/tData.firstTimes))
        elseif tData.curTimes <= tData.secondTimes then 
            prgTimes:setPercentage(33 + math.floor((tData.curTimes - tData.firstTimes) * 33/(tData.secondTimes - tData.firstTimes)))
        else
            prgTimes:setPercentage(66 + math.floor((tData.curTimes - tData.secondTimes) * 34/(tData.thirdTimes - tData.secondTimes)))
        end
    end

    for i=1,3 do
        local conRewardBox = GetElement(self.m_root,"conRewardBox" .. i .. "_CellLoveLottery",WZUIContainer)
        local imgNormal = GetElement(conRewardBox,"imgNormal_CellLoveLottery",WZUIImage)
        local imgGet = GetElement(conRewardBox,"imgGet_CellLoveLottery",WZUIImage)
        local txtCount= GetElement(self.m_root,"txtCount".. i .. "_CellLoveLotteryBox",WZUILabelTTF)
        imgNormal:setVisible(true)
        imgGet:setVisible(false)
        if i == 1 and self.m_tData.curTimes >= self.m_tData.firstTimes then
            imgNormal:setVisible(false)
            imgGet:setVisible(true)
        elseif i == 2 and self.m_tData.curTimes >= self.m_tData.secondTimes then
            imgNormal:setVisible(false)
            imgGet:setVisible(true)
        elseif i == 3 and self.m_tData.curTimes >= self.m_tData.thirdTimes then
            imgNormal:setVisible(false)
            imgGet:setVisible(true)
        end
        if i == 1 then
            txtCount:setText(self.m_tData.firstTimes)
        elseif i == 2 then
            txtCount:setText(self.m_tData.secondTimes)
        elseif i == 3 then
            txtCount:setText(self.m_tData.thirdTimes)
        end
    end
end




-------------------------------------私有方法模块End----------------------------------------

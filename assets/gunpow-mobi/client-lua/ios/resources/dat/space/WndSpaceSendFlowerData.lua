--WndSpaceSendFlowerData.lua
--@brief	WndSpaceSendFlower的数据模块
--@date		2016/01/06
--@author	zsq
--@note		送鲜花

WndSpaceSendFlower = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndSpaceSendFlower:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_nFlowerTpye = nil		--默认为空间送鲜花 1是鲜花榜活动
	self.m_nPlayerId = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndSpaceSendFlower:_unInit()
	self.m_root = nil
	self.m_nFlowerTpye = nil		--默认为空间送鲜花 1是鲜花榜活动
	self.m_nPlayerId = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndSpaceSendFlower:createElement()
	local element = WZUISystem:getInstance():createElement("WndSpaceSendFlower")
	assert(element, "WndSpaceSendFlower create element failed!")
	self:_init()
	return element
end

function WndSpaceSendFlower:showInterface(type,playerId)
    if self.m_root then
        self.m_root:removeFromParentAndCleanup(true)
    end

	local wnd = WndSpaceSendFlower:createElement()
    if wnd then
        self.m_nFlowerTpye = type
        self.m_nPlayerId = playerId
		WindowManager:addWindow(wnd, WndSpaceSendFlower, true, nil, nil, true)
    end
end

--@biref 	获取活动数据，判断鲜花榜活动是否存在
function WndSpaceSendFlower:GetActivityListInfoOK( activityId, title, startTime, endTime, serverTime , types, type2)
	--body
	if self.m_root == nil then return end 

	local bFlowerAcvitivyExist = false 
	for i = 1, #activityId do
        WZLog("WndSpaceSendFlower:GetActivityListInfoOK1", activityId[i], title[i],type2[i],types[i],serverTime,endTime[i])
        if type2[i] == 0 then    --等于0 的才是活动
            if serverTime < endTime[i] then 
                if types[i]>0 then 
                    if types[i] == g_tGameActivityTypes.ACTIVITY_FLOWER_LIST then
                        bFlowerAcvitivyExist = true
                        break 
                    end
                end 
            end 
        end
    end

    if bFlowerAcvitivyExist then 
    	self.m_nFlowerTpye = 1
    end

    self:update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

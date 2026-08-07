--WndCopperInfoView.lua
--@brief	WndCopperInfoView的UI模块
--@date		2015/07/27
--@author	mbq
--@note		金币副本信息


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCopperInfoView:onEnter(element)
	self.m_root = element
    self:_schedule()
    self:_initUI()
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCopperInfoView:onExit(element)
    self:_clearCopper()
    self:_unSchedule()
	self:_unInit()
end

function WndCopperInfoView:addCopper(copper,pos)
    if not self.m_tCopperList then
        self.m_tCopperList = {}
    end
    table.insert(self.m_tCopperList,copper)
    local point = self.m_root:convertToNodeSpace(pos)
    copper:setPosition(point)
    if copper:getScale() == 0.5 then
        copper:setScale(0.25)
    else
        copper:setScale(0.5)
    end
    self.m_root:addChild(copper,100)
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 初始化ui
function WndCopperInfoView:_initUI()
    local x,y = GetElement(self.m_root, "imgCopperIcon_WndCopperInfoView", WZUIImage):getPosition()
    self.m_tTargetPos = BattleCommon:getPointTable(x,y)
end

--@brief 启动计时器
function WndCopperInfoView:_schedule()
    self.m_root:enableSchedule("_updateCollectAct")
end

--@brief 关闭计时器
function WndCopperInfoView:_unSchedule()
    if self.m_root then
        self.m_root:disableSchedule()
    end
end

function WndCopperInfoView:_updateCollectAct(element,dt)
    if self.m_tCopperList and #self.m_tCopperList then
        for i =  #self.m_tCopperList, 1,-1 do
            local copper = self.m_tCopperList[i]
            local x,y = copper:getPosition()
            if BattleCommon:pointDis(BattleCommon:getPointTable(x,y),self.m_tTargetPos) > 100 then
                local toPosX = x + (self.m_tTargetPos.x - x)/20
                local toPosY = y + (self.m_tTargetPos.y - y)/20
                copper:setPosition(GlobalMethod:ccp(toPosX,toPosY))
            elseif BattleCommon:pointDis(BattleCommon:getPointTable(x,y),self.m_tTargetPos) > 5 then
                local toPosX = x + (self.m_tTargetPos.x - x)/10
                local toPosY = y + (self.m_tTargetPos.y - y)/10
                copper:setPositionX(toPosX)
                copper:setPositionY(toPosY)
            else
                table.remove(self.m_tCopperList,i)
                --WZLog("WndCopperInfoView:_updateCollectAct",copper:getScale())
                if copper:getScale() == 0.25 then
                    GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.COPPER_COPY_ADD_COPPER,1)
                else
                    GlobalGame:getBattleEventDispatcher():Dispatch(BATTLE_EVENT_TYPE.COPPER_COPY_ADD_COPPER,2)
                end
                copper:removeFromParentAndCleanup(true)
                copper:release()
            end
        end
    end
end

function WndCopperInfoView:getSceneCopperNum()
    if self.m_tCopperList then
        return #self.m_tCopperList
    end
    return 0
end

function WndCopperInfoView:_clearCopper()
    if self.m_tCopperList and #self.m_tCopperList then
        for i =  #self.m_tCopperList, 1,-1 do
            local copper = self.m_tCopperList[i]
            table.remove(self.m_tCopperList,i)
            copper:removeFromParentAndCleanup(true)
            copper:release()
        end
        self.m_tCopperList = nil
    end
end

-------------------------------------语言适配模块Begin----------------------------------------
function WndCopperInfoView:_adaptLanguage_vn()
    WZLog("WndCopperInfoView:_adaptLanguage_vn")
    local imgCopperIcon = GetElement(self.m_root,"imgCopperIcon_WndCopperInfoView",WZUIImage)
    imgCopperIcon:setRelativePosition(GlobalMethod:ccp(0.534652,0.5))

    local copperNum =  GetElement(self.m_root,"copperNum_WndCopperInfoView",WZUILabelTTF)
    copperNum:setRelativePosition(GlobalMethod:ccp(0.611846,0.5))
end

function WndCopperInfoView:_adaptLanguage_en()
    WZLog("WndCopperInfoView:_adaptLanguage_en")
    local imgCopperIcon = GetElement(self.m_root,"imgCopperIcon_WndCopperInfoView",WZUIImage)
    imgCopperIcon:setRelativePosition(GlobalMethod:ccp(0.57,0.5))

    local copperNum =  GetElement(self.m_root,"copperNum_WndCopperInfoView",WZUILabelTTF)
    copperNum:setRelativePosition(GlobalMethod:ccp(0.64,0.5))
end

function WndCopperInfoView:_adaptLanguage_th(  )
    local imgCopperIcon = GetElement(self.m_root,"imgCopperIcon_WndCopperInfoView",WZUIImage)
    imgCopperIcon:setRelativePosition(GlobalMethod:ccp(0.484,0.5))
    local copperNum =  GetElement(self.m_root,"copperNum_WndCopperInfoView",WZUILabelTTF)
    copperNum:setRelativePosition(GlobalMethod:ccp(0.58,0.5))
end


function WndCopperInfoView:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtCopper_WndCopperInfoView",WZUILabelTTF):setScale(0.9)
    local imgCopperIcon = GetElement(self.m_root,"imgCopperIcon_WndCopperInfoView",WZUIImage)
    imgCopperIcon:setScale(0.7)
    imgCopperIcon:setRelativePosition(GlobalMethod:ccp(0.680807,0.5))
    local copperNum =  GetElement(self.m_root,"copperNum_WndCopperInfoView",WZUILabelTTF)
    copperNum:setScale(0.9)
    copperNum:setRelativePosition(GlobalMethod:ccp(0.746461,0.5))

    GetElement(self.m_root,"ftbHurt_WndCopperInfoView",WZUIFreeTextBox):setScale(0.9)
end

function WndCopperInfoView:_adaptLanguage_tr(  )
    local txtCopper = GetElement(self.m_root,"txtCopper_WndCopperInfoView",WZUILabelTTF)
    txtCopper:setRelativePosition(GlobalMethod:ccp(0.0038,0.5))

    local imgCopperIcon = GetElement(self.m_root,"imgCopperIcon_WndCopperInfoView",WZUIImage)
    imgCopperIcon:setRelativePosition(GlobalMethod:ccp(0.519268,0.5))

    local copperNum =  GetElement(self.m_root,"copperNum_WndCopperInfoView",WZUILabelTTF)
    copperNum:setRelativePosition(GlobalMethod:ccp(0.584923,0.5))
end

function WndCopperInfoView:_adaptLanguage_es(  )
    local txtCopper = GetElement(self.m_root,"txtCopper_WndCopperInfoView",WZUILabelTTF)
    txtCopper:setRelativePosition(GlobalMethod:ccp(0.0038,0.5))
    txtCopper:setFontSize(14)

    local imgCopperIcon = GetElement(self.m_root,"imgCopperIcon_WndCopperInfoView",WZUIImage)
    imgCopperIcon:setRelativePosition(GlobalMethod:ccp(0.57,0.5))

    local copperNum =  GetElement(self.m_root,"copperNum_WndCopperInfoView",WZUILabelTTF)
    copperNum:setRelativePosition(GlobalMethod:ccp(0.63,0.5))
    copperNum:setFontSize(16)
end
-------------------------------------语言适配模块End----------------------------------------

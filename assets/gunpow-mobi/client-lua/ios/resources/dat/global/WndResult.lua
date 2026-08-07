--WndResult.lua
--@brief	WndResult的UI模块
--@date		2015/09/22
--@author	zsq
--@note		操作结果的图片动画


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndResult:onEnter(element)
	self.m_root = element
    table.insert(GlobalGame.g_tWndFightingList, self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndResult:onExit(element)
    WZLog("WndResult:onExit1")
    local icon = self.m_tMsgData.sMsgBody.m_sIcon
	self:_unInit()
    if "ui/common/common_icon_qhz.png" == icon then
        local isFinish9, finishStep9 = TeachGroup1:isTeachFinish(9)
        WZLog("WndResult:onExit2", finishStep9)
        if isFinish9 ~= true and finishStep9 > 0 then
            WindowManager:removeTeachShelterLayer()
            TeachGroup1:startGroupLevelUp(nil, nil, true, nil, {9,6, WndStrengthen.m_root})
        end
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndResult:_update()
	WZLog("WndResult:_update")
	local tMsg = self.m_tMsgData
	local icon = tMsg.sMsgBody.m_sIcon or "ui/common/common_icon_qhz.png"
	GetElement(self.m_root,"img_WndResult",WZUIImage):setFile(icon)

	self.m_root:setTag(1)
	local x,y = self.m_root:getPosition()
	local array = CCArray:create()
	local startSpeed = 0.12
	array:addObject(CCMoveTo:create(startSpeed,ccp(x,y+60)))
	array:addObject(CCFadeTo:create(startSpeed,255))
	array:addObject(CCScaleTo:create(startSpeed,1.2))
	local action = CCSpawn:create(array)
	local actionSequence = CCSequence:createWithTwoActions(action,CCCallFuncN:create(onFinishAniTemp))
	self.m_root:runAction(actionSequence)
end

-------------------------------------私有方法模块End----------------------------------------

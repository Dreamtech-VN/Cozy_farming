--WndTeamTips.lua
--@brief	WndTeamTips的UI模块
--@date		2016/06/22
--@author	Tianxiang_Xu
--@note		战队列表状Tips


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndTeamTips:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndTeamTips:onExit(element)
	self:_unInit()
end

--@brief    加载界面完成回调
function WndTeamTips:onEnterTransitionDidFinish(element)
    -- body
    self:setWindowPosition(self.m_Element,self.m_parentNode, self.m_offset)
    self:_update()
end
--@brief    关闭回调函数
function WndTeamTips:onCloseClick()
    if self.m_root == nil then
        return
    end
    self.m_root:removeFromParentAndCleanup(true)
end

--@brief    设置窗口位置
function WndTeamTips:setWindowPosition(element,parentElement,offset)
    -- 获得element的世界坐标  
    -- 以element坐标系为起点，向根节点(世界坐标)变换，坐标必须为(0,0)  
    local ptA = element:convertToWorldSpace(GlobalMethod:ccp(0,0))
    WZLog("获得element 世界坐标方法1",ptA.x,ptA.y)

    local pt = parentElement:convertToNodeSpace(ptA)
    WZLog("获得element 在parentElement中的坐标",pt.x,pt.y,nType)
    if offset ~= nil then
        pt.x = pt.x + offset.x
        pt.y = pt.y + offset.y
    end
    self.m_root:setPosition(pt)

    --获得窗口的世界坐标
    local worldPosition = self.m_root:convertToWorldSpace(GlobalMethod:ccp(0,0))
    WZLog("窗口世界坐标",worldPosition.x,worldPosition.y)
    --检查下超框
    --祝福tip
    local positionX = element:getPositionX()
    local positionY = element:getPositionY()
    local newPt = element:convertToWorldSpace(GlobalMethod:ccp(positionX, positionY))
    WZLog("HHHHHHHHHHHHHH", newPt.x, newPt.y)
    local conOuside = GetElement(self.m_root, "conOuside_WndTeamTips", WZUIContainer)
    local conSize = conOuside:getAbsContentSize()
    local screenSize = CCEGLView:sharedOpenGLView():getDesignResolutionSize()
    WZLog("KKKKKKKKKKKKKKKK", conSize.width, conSize.height, screenSize.width, screenSize.height)

    local tipPt = GlobalMethod:ccp(newPt.x + conSize.width/2, newPt.y)
    if tipPt.y + conSize.height/2 >= screenSize.height then 
        tipPt.y = tipPt.y - (tipPt.y + conSize.height/2 - screenSize.height + 20)
    end

    if tipPt.y - conSize.height/2 < 0 then 
        tipPt.y = conSize.height/2 + 20
    end

    if tipPt.x + conSize.width >= screenSize.width then
        tipPt.x = tipPt.x - conSize.width
    end

    if tipPt.x - conSize.width/2 <= 0 then
        tipPt.x = tipPt.x + conSize.width/2
    end

    self.m_root:setPosition(tipPt)
end

--@brief    检查坐标点是否在VIP按钮范围内
--@param    pt:鼠标点击的世界坐标
--@return   在按钮范围内返回true,否则返回false
function WndTeamTips:checkPointInBtn(pt)
    WZLog("WndTeamTips:checkPoint",pt.x,pt.y)
    if self.m_root == nil then return end
    local btn  = GetElement(self.m_root,"conOuside_WndTeamTips",WZUIContainer)
    if btn == nil then return false end
    local btnSize = btn:getContentSize()
    --获得btn的世界坐标
    local ptA = btn:convertToWorldSpace(GlobalMethod:ccp(0,0))
    WZLog("获得btn 世界坐标",ptA.x,ptA.y)
    WZLog("按钮大小",btnSize.width,btnSize.height)
    if (pt.x > ptA.x and pt.x < ptA.x + btnSize.width) and (pt.y > ptA.y and pt.y < ptA.y + btnSize.height) then
        return true
    else
        return false
    end 

end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    战队列表型Tips
function WndTeamTips:_update()
    -- body
    local tData = self.m_tData

    for i = 1, #tData do
        local conHead = GetElement(self.m_root, string.format("conHead%d_WndTeamTips", i), WZUIContainer)
        local celElement, tNewObj = CellTeamMember:createElement()
        if celElement then
            tNewObj:setData(tData[i])
            conHead:addChild(celElement)
        end
    end
end




-------------------------------------私有方法模块End----------------------------------------

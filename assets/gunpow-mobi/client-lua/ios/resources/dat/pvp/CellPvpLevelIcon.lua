--CellPvpLevelIcon.lua
--@brief	CellPvpLevelIcon的UI模块
--@date		2017/02/13
--@author	Tianxiang_Xu
--@note		排位赛等级图标节点


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellPvpLevelIcon:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellPvpLevelIcon:onExit(element)
	self:_unInit()
end

--@brief    点击图标回调
function CellPvpLevelIcon:onCheck(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_tData.id == 1 then
        local title = LocalStrings.TIPS4
        local tData = {icon="ui/common/common_icon_pws1.png",
            title=title,
            level=0,
            px=0.2,
            py=0.5,
            highLightObj = self,
            pvprankMark = 1,
            }
        WndTips:show(element,ScenePvpRank.m_root,1,tData,GlobalMethod:ccp(336,60), true)
    else
        if self.m_tPvpData then
            local data = {winNum = self.m_tPvpData.winTimes,total = self.m_tPvpData.joinTimes,maxWinNum = self.m_tPvpData.continous, exp = self.m_nCurIntegral}
            WndTips:show(element,ScenePvpRank.m_root,17,data,GlobalMethod:ccp(336,100), true)
        end
    end
end
--------------------------------公有方法模块End----------------------------------------


--------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function CellPvpLevelIcon:_update()
    -- body
    local tData = self.m_tData
    --圆形底图
    local imgCircle = GetElement(self.m_root, "imgCircle_CellPvpLevelIcon", WZUIImage)
    if imgCircle then
        imgCircle:setVisible(self.m_bIsCircleVisible)
    end
    --图标
    local imgIcon = GetElement(self.m_root, "imgIcon_CellPvpLevelIcon", WZUIImage)
    if imgIcon then
        imgIcon:setFile("ui/common/" .. tData.icon .. ".png")
    end

    GetElement(self.m_root, "btnTip_CellPvpLevelIcon", WZUIButton):setTouchEnable(self.m_bCanTouch)
end



---------------------------------私有方法模块End----------------------------------------

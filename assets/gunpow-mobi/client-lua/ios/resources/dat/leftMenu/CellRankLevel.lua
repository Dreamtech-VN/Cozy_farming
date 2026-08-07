--CellRankLevel.lua
--@brief	CellRankLevel的UI模块
--@date		2016/05/21
--@author	Tianxiang_Xu
--@note		等级榜&成就榜


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRankLevel:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRankLevel:onExit(element)
	self:_unInit()
end


--@brief    加载时才显示cell信息
function CellRankLevel:onLoadData(element)
    WZLog("CellRankLevel:onLoadData")
    local cellElement = WZUISystem:getInstance():createElement("CellRankLevel")
    self.m_root:addChild(cellElement)
    if self.m_tData ~= nil then 
        self:initCellData(self.m_tData.ranking, self.m_tData.playerId, self.m_tData.name, self.m_tData.faceId, self.m_tData.headId, self.m_tData.sex, self.m_tData.level, self.m_tData.param1, self.m_tData.param2, self.m_tData.param3, self.m_tData.param4, self.m_tData.param5, self.m_tData.param6, self.m_tData.param7, self.m_tData.rankType, self.m_tData.trendRank, self.m_tData.vipLevel, self.m_tData.param8, self.m_tData.headColor, self.m_tData.param9)

    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    点击Cell时调用
function CellRankLevel:onCellClickedCallback(element)
    WZLog("CellRankLevel:onCellClickedCallback")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local cellTag = self.m_root:getTag()
    WZLog("cellTag ====",cellTag, self.m_nShowInfoId)
    --self.m_nShowInfoId
    WndCheckOther:show(self.m_nShowInfoId)
end

--@brief    显示玩家头像
--@param    人物脸ID
--@param    人物头ID
--@param    人物性别
--@param    添加到容器的名称
function CellRankLevel:_showHeadIcon(faceId, headId, sex, sConName,vipLevel, headColor)
    WZLog("CellRankLevel:_showHeadIcon()")
    --设置默认显示
    conHead = GetElement(self.m_root, sConName, WZUIContainer)
    CellHead:show(conHead,headId,faceId,sex,nil,nil,vipLevel, headColor)
end

-------------------------------------私有方法模块End----------------------------------------

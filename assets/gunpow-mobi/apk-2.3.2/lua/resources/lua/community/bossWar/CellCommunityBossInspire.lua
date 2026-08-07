--CellCommunityBossInspire.lua
--@brief	CellCommunityBossInspire的UI模块
--@date		2017/01/18
--@note		公会Boss战绩排行Cell


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCommunityBossInspire:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCommunityBossInspire:onExit(element)
	self:_unInit()
end

--@brief    查看玩家信息回调
function CellCommunityBossInspire:onCheck(element)
    -- body
    WndCheckOther:show(self.m_tData.playerId)   
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	设置排名信息
function CellCommunityBossInspire:setData(tData)
	self.m_tData = tData
	GetElement(self.m_root, "labName_CellCommunityBossInspire", WZUILabelTTF):setText(tData.name)
	GetElement(self.m_root, "labCost_CellCommunityBossInspire", WZUILabelTTF):setText(tData.cost)
    local imgCostIcon = GetElement(self.m_root, "imgCostIcon_CellCommunityBossInspire", WZUIImage)
    if imgCostIcon then
    	if CacheCenter:getGameParam().isUseTicket == "0" then
        	imgCostIcon:setFile(GDatatab_item["id_70"].icon)
        else
        	imgCostIcon:setFile(GDatatab_item["id_1"].icon)
        end
        imgCostIcon:setScale(0.5)
    end

    --排名前三显示图片
    local picName = {"ui/common/common_icon_1st.png","ui/common/common_icon_2nd.png","ui/common/common_icon_3rd.png"}
    GetElement(self.m_root, "imgName_CellCommunityBossInspire", WZUIImage):setVisible(false)
    if tonumber(tData.rank) ~= nil and tonumber(tData.rank) >= 1 and tonumber(tData.rank) <= 3 then
        GetElement(self.m_root, "imgName_CellCommunityBossInspire", WZUIImage):setVisible(true)
        GetElement(self.m_root, "imgName_CellCommunityBossInspire", WZUIImage):setFile(picName[tonumber(tData.rank)])
    end
    --排名
    GetElement(self.m_root,"txtRanking_CellCommunityBossInspire",WZUILabelTTF):setText(tData.rank)
    --等级
    GetElement(self.m_root,"txtLevel_CellCommunityBossInspire",WZUILabelTTF):setText(tData.level)
    --百分比
    GetElement(self.m_root,"txtPercent",WZUILabelTTF):setText(tData.percent .. "%")

    --头像
    local conHead = GetElement(self.m_root,"conHead_Cell",WZUIContainer)
    local imgHead = CellHead:show(conHead, tData.headId, tData.faceId, tData.sex, nil, GlobalMethod:ccp(0.54,0.29), tData.vipLevel, tData.headColor)
    imgHead:setScale(1.1)
end


-------------------------------------私有方法模块End----------------------------------------

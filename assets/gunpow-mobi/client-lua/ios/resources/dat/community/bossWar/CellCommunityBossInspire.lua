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
end


-------------------------------------私有方法模块End----------------------------------------

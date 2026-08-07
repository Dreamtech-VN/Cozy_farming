--CellRankItemWorldBoss.lua
--@brief	CellRankItemWorldBoss的UI模块
--@date		2015-9-18
--@author	binshao
--@note		排行伤害


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRankItemWorldBoss:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRankItemWorldBoss:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellRankItemWorldBoss:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellRankItemWorldBoss")
    self.m_root:addChild(cellElement)
    self:_update()
end

function CellRankItemWorldBoss:OnCheckPlayerInfo()
    WZLog("--------------52020---------------",self.data.id)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    WndCheckOther:show(self.data.id)
end

-- 设置玩家信息
local imgRankPath = {"ui/common/common_icon_1st.png","ui/common/common_icon_2nd.png","ui/common/common_icon_3rd.png"}
function CellRankItemWorldBoss:_update()
    local myName = CacheCenter:getPlayerInfo().name
    if self.data.name == myName then
        -- local imgDi = GetElement(self.m_root,"imgRankDi_CellRankItemWorldBoss",WZUI9Image)
        -- imgDi:setFile("ui/common/common_scale9_di38.png")
    end

    if self.data.rank <= 3 then
        local imgRank = GetElement(self.m_root,"imgRank_CellRankItemWorldBoss",WZUIImage)
        imgRank:setFile(imgRankPath[self.data.rank])
        imgRank:setVisible(true)
    else
        local txtRank = GetElement(self.m_root,"txtRank_CellRankItemWorldBoss",WZUILabelTTF)
        txtRank:setText(self.data.rank)
    end

	local txtName = GetElement(self.m_root,"txtName_CellRankItemWorldBoss",WZUILabelTTF)
    txtName:setText(self.data.name)
	local txtHurt = GetElement(self.m_root,"txtHurt_CellRankItemWorldBoss",WZUILabelTTF)
    txtHurt:setText(self.data.hurt)
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------
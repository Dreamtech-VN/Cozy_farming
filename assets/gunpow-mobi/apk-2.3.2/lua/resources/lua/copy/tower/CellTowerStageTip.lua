--CellTowerStageTip.lua
--@brief	CellTowerStageTip的UI模块
--@date		2015-7-4
--@author	binshao
--@note		爬塔副本关卡弹框


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellTowerStageTip:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellTowerStageTip:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新界面
function CellTowerStageTip:_update()
    local txtName = GetElement(self.m_root,"txtName_CellTowerStageTip", WZUILabelTTF)
    local name = self.m_tData.monster_name and self.m_tData.monster_name or "LV 33 彬少KK虾"
    txtName:setText(name)

    local imgM = GetElement(self.m_root,"imgMonster_CellTowerStageTip", WZUIImage)
    imgM:setFile("ui/chat/button_expression.png")

    local txtDesc =  GetElement(self.m_root,"txtDesc_CellTowerStageTip", WZUILabelTTF)
    txtDesc:setText(self.m_tData.monster_explain)
end
-------------------------------------私有方法模块End----------------------------------------
--CellFootballGuessResult.lua
--@brief	CellFootballGuessResult的UI模块
--@date		2018/06/01
--@author	Tianxiang_Xu
--@note		足球精彩结果列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFootballGuessResult:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFootballGuessResult:onExit(element)
	self:_unInit()
end

--@brief    加载cell数据信息
function CellFootballGuessResult:onLoadData(element)
    -- body
    local cellElement = WZUISystem:getInstance():createElement("CellFootballGuessResult")
    self.m_root:addChild(cellElement)
    self.m_bIsLoad = true

    self:_update()
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function CellFootballGuessResult:_update()
	-- body
	local tData = self.m_tData 
    --自己显示绿色
    -- if playerId == CacheCenter:getPlayerInfo().id then
    --     local imgBK = GetElement(self.m_root, "imgBK_CellRankLevel", WZUI9Image)
    --     imgBK:setFile("ui/common/common_scale9_di38.png")
    -- end
    
    GetElement(self.m_root, "txtName1_CellFootballGuessResult", WZUILabelTTF):setText(tData.name1)
    GetElement(self.m_root, "txtName2_CellFootballGuessResult", WZUILabelTTF):setText(tData.name2)
    GetElement(self.m_root, "txtNum1_CellFootballGuessResult", WZUILabelTTF):setText(string.format(LocalStrings.FOOTBALL_TEXT1, tData.name1, tData.num1))
    GetElement(self.m_root, "txtNum2_CellFootballGuessResult", WZUILabelTTF):setText(string.format(LocalStrings.FOOTBALL_TEXT1, tData.name2, tData.num2))
    GetElement(self.m_root, "txtNum3_CellFootballGuessResult", WZUILabelTTF):setText(string.format(LocalStrings.FOOTBALL_TEXT2, tData.num3))

    if tData.state == 0 or tData.state == 1 then
    	GetElement(self.m_root, "txtNum4_CellFootballGuessResult", WZUILabelTTF):setText(LocalStrings.FOOTBALL_STATE)
    else
    	GetElement(self.m_root, "txtNum4_CellFootballGuessResult", WZUILabelTTF):setText(tData.num4)
    end
end




-------------------------------------私有方法模块End----------------------------------------

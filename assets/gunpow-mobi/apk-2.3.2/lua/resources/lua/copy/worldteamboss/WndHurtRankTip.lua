--WndHurtRankTip.lua
--@brief	WndHurtRankTip的UI模块
--@date		2020/05/06
--@author	XTX
--@note		TIP类型的伤害排名界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndHurtRankTip:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndHurtRankTip:onExit(element)
	self:_unInit()
end

--@brief    加载界面完成回调
function WndHurtRankTip:onEnterTransitionDidFinish(element)
	--body
	self:_createHurtRank()
end

--@brief    点击关闭按钮回调
function WndHurtRankTip:onCloseWin(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root, self, true)
end


-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
-- 创建伤害排行
function WndHurtRankTip:_createHurtRank()
    local data = self.hurtInfo
    
    local tab = GetElement(self.m_root, "tbRankList_WndHurtRankTip", WZUITableContainer)
    tab:cleanTable()

    local conList = GetElement(self.m_root, "conHurtList_WndHurtRankTip", WZUIContainer)
    if data == nil or #data == 0 then
    	ShowPanelNullTip(conList)
    	return
    end
    removeShowPanelNullTip(conList)
    for i = 1, #data do
        if self.m_nType == 0 then 
            local cell,tcell = CellWorldTeamBossList:createElement()
            cell:setTag(i-1)
            tab:setCellElement(cell)
            tcell:setData(data[i], 1)
        elseif self.m_nType == 1 then 
            local cell,tcell = CellRankItemWorldBoss:createElement()
            cell:setTag(i-1)
            tab:setCellElement(cell)
            tcell:setData(data[i])
        end
    end
end




-------------------------------------私有方法模块End----------------------------------------

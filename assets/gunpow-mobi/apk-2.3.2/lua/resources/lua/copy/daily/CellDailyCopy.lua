--CellDailyCopy.lua
--@brief	CellDailyCopy的UI模块
--@date		2015-6-17
--@author	binshao
--@note		日常副本单元格


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDailyCopy:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDailyCopy:onExit(element)
	self:_unInit()
end

-- 点击cell回调，如果未开启，弹TIP
function CellDailyCopy:OnBtnSelect(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if not self.tData.diff[1].isOpen then
        local desc = self.tData.diff[1].localData.map_desc
        local data = "\n"..desc.."\n"
        WZLog("WWWWWWW:",desc,data)
        local leftCon = GetElement(WndDailyCopy.m_root,"conLeft_WndDailyCopy",WZUIContainer)
        --MsgBoxManager:showTipBox(data)
        WndItemInfo:showInfo(element,leftCon,3,data,false,nil,nil)
        return
    end
    self.callback[2](self.callback[1],self.m_root:getTag())
end

-- 设置cell选择状态
function CellDailyCopy:SetSelectState(state)
    local imgSel = GetElement(self.m_root, "imgSel_CellDailyCopy", WZUI9Image)
    imgSel:setVisible(state)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief    更新界面
function CellDailyCopy:_update()
    local localData = self.tData.diff[1].localData
    local imgMap = GetElement(self.m_root, "imgMap_CellDailyCopy", WZUIImage)
    WZLog("CellDailyCopy:_update:",self.tData.section)
    WZLog("ui/dailyCopy/common_icon_copyModle"..self.tData.section..".png")
	local imgFile = {"ui/dailyCopy/common_icon_cw_xdsl.png", "ui/dailyCopy/common_icon_cw_fsem.png","ui/dailyCopy/common_icon_cw_cwdb.png"}
    imgMap:setFile(imgFile[self.tData.section])
    local boolGray = not  self.tData.diff[1].isOpen
    imgMap:setGrayRender(boolGray)
    -- if not  self.tData.diff[1].isOpen then
    --     imgMap:setGra
    -- end

    AdaptLanguage(self)
end


-------------------------------------私有方法模块End----------------------------------------

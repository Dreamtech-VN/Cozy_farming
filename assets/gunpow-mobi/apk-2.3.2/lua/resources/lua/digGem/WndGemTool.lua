--WndGemTool.lua
--@brief	WndGemTool的UI模块
--@date		2017/03/13
--@author	Tianxiang_Xu
--@note		挖宝系统-工具界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndGemTool:onEnter(element)
	self.m_root = element
    CacheCenter:registerUpateMoneyObserver(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndGemTool:onExit(element)
    CacheCenter:unregisterUpateMoneyObserver(self)
	self:_unInit()
end

--@brief    加载界面完成回调
function WndGemTool:onEnterTransitionDidFinish(element)
    -- body
    self:setData(WndDigGem.m_tToolList)
end

--@brief    关闭按钮回调
function WndGemTool:onCloseClick(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    点击帮助按钮回调
function WndGemTool:onClickRule(element)
    -- body
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

    WndSingleMapDesc:showInterface1(LocalStrings.DIGGEM_TEXT19)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    刷新
function WndGemTool:_update()
    -- body
    self:_showGemCoin()
    self:_createToolList()
end

--@brief    创建挖宝工具列表
function WndGemTool:_createToolList()
    -- body
    local tableToolList = GetElement(self.m_root, "tableToolList_WndGemTool", WZUITableContainer)
    tableToolList:cleanTable()

    for i = 1, #self.m_tToolList do
        local celElement, tNewObj = CellGemTool:createElement()
        if celElement and tNewObj then
            celElement:setTag(i - 1)
            tNewObj:setData(self.m_tToolList[i])
            tableToolList:setCellElement(celElement)
        end
    end
end

--@brief    矿晶数量
function WndGemTool:_showGemCoin()
    -- body
    local ftxtGemCoin = GetElement(self.m_root, "ftxtGemCoin_WndGemTool", WZUIFreeTextBox)
    if ftxtGemCoin then
        local sFormat = [[<I Z="0.5" P="1">%s</I><T C="255,236,193" S="20" P="1" SC="132,66,29" SS="4" SE="1">%d</T>]]
        local icon = GDatatab_item["id_58"].icon
        gemCoinNum = CacheCenter:getMoneyList().gemCoin 
        ftxtGemCoin:setShowText(string.format(sFormat, icon, gemCoinNum))
        if gemCoinNum >= 100000000 then
            local conCoin = GetElement(self.m_root, "conCoin_WndGemTool", WZUIContainer)
            conCoin:setAbsContentSize(GlobalMethod:CCSize(160,38))
            conCoin:updateRelativeSize()
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------

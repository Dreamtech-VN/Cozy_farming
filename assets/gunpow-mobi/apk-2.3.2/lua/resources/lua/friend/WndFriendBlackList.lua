--WndFriendBlackList.lua
--@brief	WndFriendBlackList的UI模块
--@date		2020/07/07
--@author	XTX
--@note		玩家黑名单列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFriendBlackList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFriendBlackList:onExit(element)
	self:_unInit()
end

--@brief	加载动画
function WndFriendBlackList:onEnterTransitionDidFinish(element)
	--body
	self:createLoading()
	ProtocolProcessorWndFriends:send_FRIENT_GetBlackList()
end

--@brief	关闭按钮回调事件
function WndFriendBlackList:onClickClose(element)
	WZLog("关闭按钮回调事件")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief    查看玩家信息
function WndFriendBlackList:onPlayerInfo(tCell, tag, tData)
    -- body
    WndCheckOther:show(tData.id)
end

--@brief    显示黑名单列表
function WndFriendBlackList:onShowBlacklist()
    if self.m_root == nil then
        return
    end
    local tbconBlacklist = WZUITableContainer:luaTo(self.m_root:getChildElement("tbconBlacklist_WndFriendBlackList"))
    tbconBlacklist:cleanTable()

    local conBlacklist = GetElement(self.m_root, "conForList_WndFriendBlackList", WZUIContainer)
    self.m_tBlacklist = CacheCenter:getFriendBlacklist()
    if self.m_tBlacklist == nil or #self.m_tBlacklist == 0 then
        ShowPanelNullTip( conBlacklist, LocalStrings.BLACKLIST_TEXT6)
        return 
    end
    removeShowPanelNullTip(conBlacklist)

    table.sort(self.m_tBlacklist, function (a,b)
        -- body
        local onlineA = WndFriends:checkSortOnline(a)
        local onlineB = WndFriends:checkSortOnline(b)

        if onlineA ~= onlineB then
            return onlineA >= onlineB
        elseif a.level ~= b.level then
            return a.level > b.level 
        else
            return a.id < b.id
        end
    end)

    for i = 1, #self.m_tBlacklist do 
        local celElement , tCell = CellFriendBlacklist:createElement()
        celElement:setTag(i - 1)
        tbconBlacklist:setCellElement(celElement)
        tCell:setBackFun(self, self.onPlayerInfo)
        tCell:setCellData(self.m_tBlacklist[i])
    end

    tbconBlacklist:getMoveElement():setPositionY(tbconBlacklist:getMinPosition().y)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

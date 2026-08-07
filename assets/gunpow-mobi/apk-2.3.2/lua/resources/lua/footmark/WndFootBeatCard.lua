--WndFootBeatCard.lua
--@brief	WndFootBeatCard的UI模块
--@date		2021/11/02
--@author	XTX
--@note		足迹打卡


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFootBeatCard:onEnter(element)
	self.m_root = element

	ProtocolProcessorFootMark:send_FOOTMARK_GetFootMarkCityInfo()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFootBeatCard:onExit(element)
	self:_unInit()
	if WZFileUtil:isFileExist("pack/footmark/pack_footmark_0.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/footmark/pack_footmark_0.plist")
    end
    if WZFileUtil:isFileExist("pack/footmark/pack_footmark_1.plist") then
        CCSpriteFrameCache:sharedSpriteFrameCache():removeSpriteFramesFromFile("pack/footmark/pack_footmark_1.plist")
    end
end


--@brief	关闭足迹信息界面
function WndFootBeatCard:onClose()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WndFootBeatCard.m_root:removeFromParentAndCleanup(true)
    if WndFootMark and WndFootMark.showFirstBGUI and WndFootMark.m_root then
        WndFootMark:showFirstBGUI(true)
    end
end

--@brief	点击规则按钮回调
function WndFootBeatCard:onClickRule()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WndSingleMapDesc:showInterface(LocalStrings.FOOTMARK_TEXT30)
end

--@brief	点击商城按钮回调
function WndFootBeatCard:onClickShop()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    WndFootShop:showInterface({160169})
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	显示打卡列表
function WndFootBeatCard:_showBeatCardList()
	local tbCityList = GetElement(self.m_root, "tbCityList_WndFootBeatCard", WZUITableContainer)
	tbCityList:cleanTable()

	for i = 1, #self.m_tCityCardList do
		local element, tNewObj = CellFootCardItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)

			tNewObj:setData(self.m_tCityCardList[i])
			tbCityList:setCellElement(element)

			if self.m_tCityCardList[i].open_status ~= 1 then --只显示一张敬请期待
				break 
			end
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------

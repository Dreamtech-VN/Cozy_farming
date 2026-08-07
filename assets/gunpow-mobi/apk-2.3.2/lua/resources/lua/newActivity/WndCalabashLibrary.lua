--WndCalabashLibrary.lua
--@brief	WndCalabashLibrary的UI模块
--@date		2023/02/02
--@author	XTX
--@note		葫芦娃活动-图鉴


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCalabashLibrary:onEnter(element)
	self.m_root = element

	g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}
	CacheCenter:registerUpatePlayerItemObserver(self)--注册物品

	self:_initStaticText()

	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCalabashLibrary:onExit(element)
	g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}
	CacheCenter:unregisterUpatePlayerItemObserver(self)

	self:_unInit()
end

--@brief    onenter函数已执行
function WndCalabashLibrary:onEnterTransitionDidFinish(element)
    WZLog("WndCalabashLibrary:onEnterTransitionDidFinish")
	self:setData()
end

--@brief    关闭窗口
function WndCalabashLibrary:onCloseClick()
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
    --如果是自动弹出的活动界面
    WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	初始化静态文本
function WndCalabashLibrary:_initStaticText()
	GetElement(self.m_root, "txtTitle_WndCalabashLibrary", WZUILabelTTF):setText(LocalStrings.CALABASH_TEXT1[2])
	GetElement(self.m_root, "txtDesc_WndCalabashLibrary", WZUILabelTTF):setText(LocalStrings.CALABASH_TEXT1[10])
end

--@brief 	刷新
function WndCalabashLibrary:_update()
	local tbList = GetElement(self.m_root, "tbList_WndCalabashLibrary", WZUITableContainer)
	tbList:cleanTable()
	self.m_tCellItem = {}

	for i = 1, #self.m_tTaskList do
		local element, tNewObj = CellCalabashLibraryItem:createElement()
		if element and tNewObj then 
			element:setVisible(true)
			element:setTag(i - 1)
			tNewObj:setData(self.m_tTaskList[i])

			tbList:setCellElement(element)

			table.insert(self.m_tCellItem, tNewObj)
		end
	end
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin----------------------------------------

function WndCalabashLibrary:_adaptLanguage_vn()
GetElement(self.m_root, "txtDesc_WndCalabashLibrary", WZUILabelTTF):setFontSize(18)
end

-------------------------------------语言适配End----------------------------------------

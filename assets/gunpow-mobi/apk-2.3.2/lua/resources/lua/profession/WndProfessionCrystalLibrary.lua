--WndProfessionCrystalLibrary.lua
--@brief	WndProfessionCrystalLibrary的UI模块
--@date		2021/02/07
--@author	XTX
--@note		职业水晶图鉴


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndProfessionCrystalLibrary:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndProfessionCrystalLibrary:onExit(element)
	self:_unInit()
end

function WndProfessionCrystalLibrary:onEnterTransitionDidFinish(element)
	--body
	WZLog("WndProfessionCrystalLibrary:onEnterTransitionDidFinish")
	self:setData()
end


--@brief 	点击关闭按钮回调
function WndProfessionCrystalLibrary:onClickClose(element)
	-- body
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)

	WindowManager:removeWindow(self.m_root, WndProfessionCrystalLibrary, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	刷新
function WndProfessionCrystalLibrary:_update()
	-- body
	local tbLibraryList = GetElement(self.m_root, "tbLibraryList_WndProfessionCrystalLibrary", WZUITableContainer)
	tbLibraryList:cleanTable()

	WZLog("WndProfessionCrystalLibrary:_update", Serialize(self.m_tLibraryData))
	for i = 1, #self.m_tLibraryData do
		local element, tNewObj = CellProfessionCrystalLibrary:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setData(self.m_tLibraryData[i])

			tbLibraryList:setCellElement(element)
		end
	end
end




-------------------------------------私有方法模块End----------------------------------------

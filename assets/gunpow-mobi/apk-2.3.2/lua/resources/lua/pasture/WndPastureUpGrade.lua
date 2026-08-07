--WndPastureUpGrade.lua
--@brief	WndPastureUpGrade的UI模块
--@date		2021/04/19
--@author	hyx
--@note		牧场升级


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndPastureUpGrade:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndPastureUpGrade:onExit(element)
	self:_unInit()
end
--打开界面
function WndPastureUpGrade:showInterface(lev)   
	local wndUpgrade = WndPastureUpGrade:createElement(lev)
	if wndUpgrade ~= nil then
	    WindowManager:addWindow(wndUpgrade,WndPastureUpGrade,nil,false)
	end
end

function WndPastureUpGrade:onEnterTransitionDidFinish(element)
	WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end
function WndPastureUpGrade:actionCallback()
	self:initShow()
end
function WndPastureUpGrade:initShow()
	local lev = self.m_nUpgradeLevel
	local index = 1
	local m_desc = {}
	local lev_info = WndPastureBusiness:getPastureLevelExp(lev, true)
	if lev >= #lev_info then
		lev = #lev_info
	end
	for i, v in pairs(GDatatab_pasture_factory) do
		if v.needlevel == lev then
			m_desc[index] = v.id
			index = index + 1
		end
	end

	local str_desc = ""
	local txtExplanation = GetElement(self.m_root, "txtDesc", WZUIFreeTextBox)
	local txtSize = txtExplanation:getContentSize()	
	txtExplanation:setAnchorPoint(ccp(0,1))
	txtExplanation:setPositionY(txtSize.height-5)

	local txtTitleFreeLevel = GetElement(self.m_root,"txtTitleFreeLevel",WZUIFreeTextBox)
	local str_upgrade = [[<T C="255,227,116" S="20" P="1" SC="132,66,29" SS="4" SE="1">%s Lv.%d</T><BL>10</BL><I Z="0.8">ui/common/common_icon_jiehunjiantou.png</I><T C="255,227,116" S="20" P="1" SC="132,66,29" SS="4" SE="1"> Lv.%d</T>]]
	txtTitleFreeLevel:setShowText(string.format(str_upgrade,LocalStrings.PASTURE_TEXT7, lev - 1, lev))
	if next(m_desc) == nil then
		str_desc = string.format([[<T C="127,70,26" S="20" P="1">%s</T><T C="5,180,0" S="20" P="1"> %d</T><BL>40</BL><I Z="0.8">ui/common/common_icon_jiehunjiantou.png</I><BL>20</BL><T C="127,70,26" S="20" P="1">%s</T><T C="5,180,0" S="20" P="1"> %d</T>]],
				LocalStrings.PASTURE_TEXT15,GDatatab_pastureland["id_"..lev-1].num, LocalStrings.PASTURE_TEXT15,GDatatab_pastureland["id_"..lev].num)
	else
		for i=1,#m_desc+1 do
			local str,str1,str2 = "","",""
			if i == 1 then
				str_desc = string.format([[<T C="127,70,26" S="20" P="1">%s</T><T C="5,180,0" S="20" P="1"> %d</T><BL>40</BL><I Z="0.8">ui/common/common_icon_jiehunjiantou.png</I><BL>20</BL><T C="127,70,26" S="20" P="1">%s</T><T C="5,180,0" S="20" P="1"> %d</T>]],
					LocalStrings.PASTURE_TEXT15,GDatatab_pastureland["id_"..lev-1].num, LocalStrings.PASTURE_TEXT15,GDatatab_pastureland["id_"..lev].num)
			else
				str_desc = str_desc .. [[<BR></BR>]]

				local data1 = GDatatab_pasture_factory["id_"..m_desc[i-1]]
				if data1 then
					str1 = data1.name
				end

				local data = GDatatab_pasture_factory["id_"..m_desc[i-1]-1]
				if data and data.type == data1.type then
					str = data.name
				end
				if str == "" then
					str2 = string.format([[<T C="127,70,26" S="20" P="1">%s</T><BL>10</BL><T C="229,105,22" S="20" P="1">%s</T>]],str1,LocalStrings.TIPSWORD6)
				else
					str2 = string.format([[<T C="127,70,26" S="20" P="1">%s</T><BL>10</BL><I Z="0.8">ui/common/common_icon_jiehunjiantou.png</I><BL>10</BL><T C="127,70,26" S="20" P="1">%s</T>]],str,str1)
				end
				str_desc = str_desc .. str2
			end
		end
	end
	txtExplanation:setShowText(str_desc)
	local rollconExplanation = self.m_root:getChildElement("rollconExplanation_WndPastureUpGrade")
	if rollconExplanation == nil then 
		return
	end
	rollconExplanation = WZUIMoveContainer:luaTo(rollconExplanation)
	local rollSize = rollconExplanation:getContentSize()
	--更改滚动容器Element的大小
	local moveElement = rollconExplanation:getMoveElement()
	local size = moveElement:getRelativeSize()
	moveElement:setRelativeSize( CCSize(1 , txtSize.height / rollSize.height ) )
	rollconExplanation:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(rollconExplanation:getMinPosition().y)
end

function WndPastureUpGrade:onBtnClose()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

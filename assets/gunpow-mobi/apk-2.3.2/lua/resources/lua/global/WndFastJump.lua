--WndFastJump.lua
--@brief	WndFastJump的UI模块
--@date		2017/09/08
--@author	 
--@note		快速跳转


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndFastJump:onEnter(element)
	self.m_root = element
	self:_initUI()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndFastJump:onExit(element)
	self:_unInit()
end



-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndFastJump:_initUI()
	-- body
	WZLog("WndFastJump:_initUI")
	local playerLevel = CacheCenter:getPlayerInfo().level
	local level = 199
	local iconS = nil
	local link = nil
	for k,v in pairs(GDatatab_upgrade) do
		for j,k in ipairs(v.lv) do
			local minL = k[1]
			local maxL = k[2]
			if maxL >= playerLevel and maxL < level then
				iconS = v.icon
				link = v.link
				level = maxL
			end
		end
	end
	link = tostring(link)
	local tabList = GetElement(self.m_root,"tabList_WndFastJump",WZUITableContainer)
	tabList:cleanTable()
	iconS = SplitStringWithSeparator(iconS,",")
	link = SplitStringWithSeparator(link,",")
	WZLog("WndFastJump:_initUI", iconS, link)
	if #iconS == 1 then
		tabList:setCellElementHeight(1)
	elseif #iconS == 2 then
		tabList:setCellElementHeight(0.5)
	end

	local txtTitle = GetElement(self.m_root,"txtTitle_WndFastJump",WZUILabelTTF)
	local sMsg = string.format(LocalStrings.LEVEL_UNREACHED, self.m_nOpenLevel)
	txtTitle:setText(sMsg)

	local txtDes = GetElement(self.m_root,"txtDes_WndFastJump",WZUILabelTTF)
	txtDes:setText(LocalStrings.FINISH_TASK_UPDATE_TIP)

	if iconS then
		for i,v in ipairs(iconS) do
		    local element = CreateElement("CellJumpItem_WndFastJump")
		    element = WZUIContainer:luaTo(element)
		    local btnJump = GetElement(element,"btnJump_WndFastJump",WZUIButton)
		    btnJump:setTag(tonumber(link[i]))
		    GetElement(element,"imgFunNor_WndFastJump",WZUIImage):setFile(v)
		    GetElement(element,"imgFunSel_WndFastJump",WZUIImage):setFile(v)
		    element:setTag(i-1)
		    tabList:setCellElement(element)
	    end
	end
	
end

function WndFastJump:onClickJump(element)
	-- body
	WZLog("WndFastJump:onClickJump")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	local tag = element:getTag()
	JumpByUIId(tag,nil)
end


function WndFastJump:onClickClose(element)
	-- body
	WZLog("WndFastJump:onClickClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
	WindowManager:removeWindow(self.m_root,self,true)
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin--------------------------------------------
function WndFastJump:_adaptLanguage_en(  )
	GetElement(self.m_root,"txtTitle_WndFastJump",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtDes_WndFastJump",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(360))
end

function WndFastJump:_adaptLanguage_pt(  )
	GetElement(self.m_root,"txtTitle_WndFastJump",WZUILabelTTF):setScale(0.68)
	GetElement(self.m_root,"txtDes_WndFastJump",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(360))
end

function WndFastJump:_adaptLanguage_es(  )
	GetElement(self.m_root,"txtTitle_WndFastJump",WZUILabelTTF):setScale(0.68)
	GetElement(self.m_root,"txtDes_WndFastJump",WZUILabelTTF):setDimensions(GlobalMethod:CCSize(360))
end
-------------------------------------语言适配End------------------------------------------------
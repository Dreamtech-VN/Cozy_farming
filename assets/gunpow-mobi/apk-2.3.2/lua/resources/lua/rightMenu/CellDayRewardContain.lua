--CellDayRewardContain.lua
--@brief	CellDayRewardContain的UI模块
--@date		2017/05/28
--@author	 
--@note		 


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellDayRewardContain:onEnter(element)
	self.m_root = element
	self:uiInit()
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellDayRewardContain:onExit(element)
	self:_unInit()
end


--显示UI
function CellDayRewardContain:uiInit()
	WZLog("CellDayRewardContain:uiInit =",Serialize(self.m_nGetStats),Serialize(self.m_nRewardItemId))
	local GetElement = GetElement
	local LocalStrings = LocalStrings

	local itemIndex = 1

	for i=1,7 do
		local conDay = GetElement(self.m_root,"conDay" .. i .. "_CellDayRewardContain",WZUIContainer)
		local txtDay = GetElement(conDay,"txtDay_CellDayRewardContain",WZUILabelTTF)
		txtDay:setText(string.format(LocalStrings.SingInDAYS,i))
		if i > 1 then
			itemIndex = itemIndex + self.m_nRewardCount[i - 1]
		end
		local imgItem = GetElement(conDay,"imgItem_CellDayRewardContain",WZUIImage)
		local itemInfo = GDatatab_item["id_" .. self.m_nRewardItemId[itemIndex] ]
		imgItem:setFile(itemInfo.icon)

		--local txtItemName = GetElement(conDay,"txtItemName_CellDayRewardContain",WZUILabelTTF)
		--txtItemName:setText(itemInfo.name)

		local txtNum = GetElement(conDay,"txtNum_CellDayRewardContain",WZUILabelTTF)
		txtNum:setText(self.m_nRewardItemsParamCount[itemIndex])

		local imgGet= GetElement(conDay,"imgGet_CellDayRewardContain",WZUIImage)
		local sp = GetElement(conDay,"sp_CellDayRewardContain",WZUISpine)
		local imgBlack = GetElement(conDay,"imgBlack_CellDayRewardContain",WZUI9Image)
		
		if self.m_nGetStats[i] == 1 then
			imgGet:setVisible(true)
			txtNum:setVisible(false)
			imgBlack:setVisible(true)
			
			if i == 7 then
				sp:setFileAtlas("city/ui_main_iconeffect.atlas")
				sp:setFileJson("city/ui_main_iconeffect.json")
				sp:setAnimationName("animation")
				sp:setRelativePosition(GlobalMethod:ccp(0.5,0.705357))
			    sp:setVisible(true)
		    end
		else
			if self.m_nGetStats[i] == 0 then
				sp:setVisible(true)
				if i == 7 then
					sp:setFileAtlas("ui/common_scale9_jinji_6.atlas")
			        sp:setFileJson("ui/common_scale9_jinji_6.json")
				    sp:setAnimationName("common_scale9_jinji_6")
				    sp:setRelativePosition(GlobalMethod:ccp(0.512195,0.464284))
		        end
			else
				sp:setVisible(false)
				if i == 7 then
					sp:setFileAtlas("city/ui_main_iconeffect.atlas")
					sp:setFileJson("city/ui_main_iconeffect.json")
					sp:setAnimationName("animation")
					sp:setRelativePosition(GlobalMethod:ccp(0.5,0.705357))
			        sp:setVisible(true)
		        end
			end
			imgBlack:setVisible(false)
			imgGet:setVisible(false)
		end
	end

	local tempStart = os.date("%m.%d",self.m_nStartTime)
	local tempend = os.date("%m.%d",self.m_nEndTime)

	local txtTime = GetElement(self.m_root,"txtTime_CellDayRewardContain",WZUILabelTTF)
	txtTime:setText(":" .. tempStart .. "-" .. tempend)
end

function CellDayRewardContain:onClickGet(element)
	WZLog("CellDayRewardContain:onClickGet ")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local tag = element:getTag()
	local stats = self.m_nGetStats[tag]

	local itemIndex = 1
	for i = 2,tag do
		itemIndex = itemIndex + self.m_nRewardCount[i - 1]
	end
	
	if stats == -1 or stats == 1 then
		WndItemInfo:onCloseClick()
		
		tData = {
            id = self.m_nRewardItemId[itemIndex],
            lastNum = self.m_nRewardCount[tag],
            lastTime = 1,
            isUse = false,
            data = "",
            playerItemId = -1,
            basicInfo = GetItemLocalData(self.m_nRewardItemId[itemIndex])
        }
		WndItemInfo:showInfo(self.m_root,WndNewActivity.m_root,1,tData,false)
	else
		self.m_callbackFun(self.m_callbackLua,self.m_nActivityId,self.m_nRewardid[tag],tag)
	end
	
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

function CellDayRewardContain:_adaptLanguage_vn(  )
	GetElement(self.m_root,"txtTime_CellDayRewardContain",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.310058,-0.0778267))
end
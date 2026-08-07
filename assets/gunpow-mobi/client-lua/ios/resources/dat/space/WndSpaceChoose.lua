--WndSpaceChoose.lua
--@brief	WndSpaceChoose的UI模块
--@date		2016/01/13
--@author	zsq
--@note		选择日期


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndSpaceChoose:onEnter(element)
	self.m_root = element
	AdaptLanguage(self)
	self:update()
	self.m_root:enableSchedule("setData",0.01)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndSpaceChoose:onExit(element)
	self:_unInit()
end

--@brief	关闭按钮点击回调
function WndSpaceChoose:onClose(element)
    WZLog("WndSpaceChoose:onClose")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	点击确定
function WndSpaceChoose:onConfirm(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local age =	GetElement(self.m_root,"ttfAge",WZUILabelTTF):getText()
	local constellation = GetElement(self.m_root,"ttfConstellation",WZUILabelTTF):getText()
	GetElement(WndSpaceDetail.m_root,"ttfAge",WZUILabelTTF):setText(age)
	GetElement(WndSpaceDetail.m_root,"ttfConstellation",WZUILabelTTF):setText(constellation)

	--更新资料
	WndSpaceDetail:update()
	WndSpaceMain:sendProtocol()
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新留言
function WndSpaceChoose:update()
	if self.m_root == nil then return end
	local tableContainer = GetElement(self.m_root,"tbCon_WndSpaceChoose1",WZUITableContainer)
	--显示从今年开始往前数100年
	for i = 1,103 do 
		local celElement,tCell = CellSpaceChoose:createElement()
		if i > 101 or i == 1 then
			tCell:setDisplay("")
		elseif ProjConfig.LANGUAGE == "pt" then
			tCell:setDisplay((os.date("%Y")-101+i))
		else
			tCell:setDisplay((os.date("%Y")-101+i)..LocalStrings.SPACE30)
		end
		celElement:setTag(i-1)    --从0开始设置Tag值
		tableContainer:setCellElement(celElement)
		--停留到上次设置的年龄
		if WndSpaceMain.m_tData.playerAge == 0 then
			tableContainer:getMoveElement():setPositionY(2575-50*15)
		else
			tableContainer:getMoveElement():setPositionY(2575-50*WndSpaceMain.m_tData.playerAge)
		end
		tableContainer:setMoveActionFinishCallback("conStop")
	end 

	local tableContainer = GetElement(self.m_root,"tbCon_WndSpaceChoose2",WZUITableContainer)
	for i = 1,15 do 
		local celElement,tCell = CellSpaceChoose:createElement()
		if i > 13 or i == 1 then
			tCell:setDisplay("")
		else
			if ProjConfig.LANGUAGE == "pt" then
				local month = {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
				tCell:setDisplay(month[i-1])
			else
				tCell:setDisplay((i-1)..LocalStrings.SPACE31)
			end
		end
		celElement:setTag(i-1)    --从0开始设置Tag值
		tableContainer:setCellElement(celElement)
		--停留到上次设置的星座
		if WndSpaceMain.m_tData.playerCon == 0 then
			tableContainer:getMoveElement():setPositionY(375-50*6)
		else
			tableContainer:getMoveElement():setPositionY(375-50*(12-(WndSpaceMain.m_tData.playerCon+3)%12))
		end
		tableContainer:setMoveActionFinishCallback("conStop")
	end 

	local tableContainer = GetElement(self.m_root,"tbCon_WndSpaceChoose3",WZUITableContainer)
	for i = 1,34 do 
		local celElement,tCell = CellSpaceChoose:createElement()
		if i > 32 or i == 1 then
			tCell:setDisplay("")
		elseif ProjConfig.LANGUAGE == "pt" then
			tCell:setDisplay(LocalStrings.SPACE32..(i-1))
		else
			tCell:setDisplay((i-1)..LocalStrings.SPACE32)
		end
		celElement:setTag(i-1)    --从0开始设置Tag值
		tableContainer:setCellElement(celElement)
		local dayNum
		if WndSpaceMain.m_tData.birthday ~= nil and WndSpaceMain.m_tData.birthday ~= "" then
			dayNum = json.decode(WndSpaceMain.m_tData.birthday).day
		end
		if dayNum ~= nil then
			tableContainer:getMoveElement():setPositionY(850-50*(31-dayNum))
		else
			tableContainer:getMoveElement():setPositionY(850-50*15)
		end
	end 
end

--@brief	设置数据
function WndSpaceChoose:setData(element,t)
    local tbCon1 = GetElement(self.m_root,"tbCon_WndSpaceChoose1",WZUITableContainer)
    local PositionY1 = tbCon1:getMoveElement():getPositionY()
    local tbCon2 = GetElement(self.m_root,"tbCon_WndSpaceChoose2",WZUITableContainer)
    local PositionY2 = tbCon2:getMoveElement():getPositionY()
    local tbCon3 = GetElement(self.m_root,"tbCon_WndSpaceChoose3",WZUITableContainer)
    local PositionY3 = tbCon3:getMoveElement():getPositionY()

	--计算出生日期
	local age = math.floor((2575 - PositionY1 + 20)/50) 
	local month = math.floor((PositionY2 + 175 + 20)/50) + 1
	local day = math.floor((PositionY3 + 650 + 20)/50) + 1
	self.m_nCurDay = day
	WndSpaceMain.m_tData.birthday = json.encode({year=(os.date("%Y")-age),month=month,day=day})

	WndSpaceMain.m_tData.playerAge = age

	--计算星座
	local constellation
	if month == 1 then
		if day <= 19 then
			constellation = LocalStrings.SPACE88
			WndSpaceMain.m_tData.playerCon = 10
		else
			constellation = LocalStrings.SPACE89
			WndSpaceMain.m_tData.playerCon = 11
		end
	elseif month == 2 then
		if day <= 18 then
			constellation = LocalStrings.SPACE89
			WndSpaceMain.m_tData.playerCon = 11
		else
			constellation = LocalStrings.SPACE90
			WndSpaceMain.m_tData.playerCon = 12
		end
	elseif month == 3 then
		if day <= 20 then
			constellation = LocalStrings.SPACE90
			WndSpaceMain.m_tData.playerCon = 12
		else
			constellation = LocalStrings.SPACE79
			WndSpaceMain.m_tData.playerCon = 1
		end
	elseif month == 4 then
		if day <= 19 then
			constellation = LocalStrings.SPACE79
			WndSpaceMain.m_tData.playerCon = 1
		else
			constellation = LocalStrings.SPACE80
			WndSpaceMain.m_tData.playerCon = 2
		end
	elseif month == 5 then
		if day <= 20 then
			constellation = LocalStrings.SPACE80
			WndSpaceMain.m_tData.playerCon = 2
		else
			constellation = LocalStrings.SPACE81
			WndSpaceMain.m_tData.playerCon = 3
		end
	elseif month == 6 then
		if day <= 21 then
			constellation = LocalStrings.SPACE81
			WndSpaceMain.m_tData.playerCon = 3
		else
			constellation = LocalStrings.SPACE82
			WndSpaceMain.m_tData.playerCon = 4
		end
	elseif month == 7 then
		if day <= 22 then
			constellation = LocalStrings.SPACE82
			WndSpaceMain.m_tData.playerCon = 4
		else
			constellation = LocalStrings.SPACE83
			WndSpaceMain.m_tData.playerCon = 5
		end
	elseif month == 8 then
		if day <= 22 then
			constellation = LocalStrings.SPACE83
			WndSpaceMain.m_tData.playerCon = 5
		else
			constellation = LocalStrings.SPACE84
			WndSpaceMain.m_tData.playerCon = 6
		end
	elseif month == 9 then
		if day <= 22 then
			constellation = LocalStrings.SPACE84
			WndSpaceMain.m_tData.playerCon = 6
		else
			constellation = LocalStrings.SPACE85
			WndSpaceMain.m_tData.playerCon = 7
		end
	elseif month == 10 then
		if day <= 23 then
			constellation = LocalStrings.SPACE85
			WndSpaceMain.m_tData.playerCon = 7
		else
			constellation = LocalStrings.SPACE86
			WndSpaceMain.m_tData.playerCon = 8
		end
	elseif month == 11 then
		if day <= 22 then
			constellation = LocalStrings.SPACE86
			WndSpaceMain.m_tData.playerCon = 8
		else
			constellation = LocalStrings.SPACE87
			WndSpaceMain.m_tData.playerCon = 9
		end
	elseif month == 12 then
		if day <= 21 then
			constellation = LocalStrings.SPACE87
			WndSpaceMain.m_tData.playerCon = 9
		else
			constellation = LocalStrings.SPACE88
			WndSpaceMain.m_tData.playerCon = 10
		end
	end

	--设置年龄星座
	GetElement(self.m_root,"ttfAge",WZUILabelTTF):setText(age..LocalStrings.SPACE91)
	GetElement(self.m_root,"ttfConstellation",WZUILabelTTF):setText(constellation)
end

--@brief	年容器移动停止
function WndSpaceChoose:conStop()
	WZLog("WndSpaceChoose:con1Stop")

    local tbCon1 = GetElement(self.m_root,"tbCon_WndSpaceChoose1",WZUITableContainer)
    local PositionY1 = tbCon1:getMoveElement():getPositionY()
    local tbCon2 = GetElement(self.m_root,"tbCon_WndSpaceChoose2",WZUITableContainer)
    local PositionY2 = tbCon2:getMoveElement():getPositionY()

	local year = os.date("%Y") - math.floor((2575 - PositionY1 + 20)/50) 
	local month = math.floor((PositionY2 + 175 + 20)/50) + 1

	local dayNum = os.date("%d",os.time({year=year,month=month+1,day=0}))
	local tableContainer = GetElement(self.m_root,"tbCon_WndSpaceChoose3",WZUITableContainer)
	tableContainer:cleanTable()
	for i = 1,(dayNum + 3) do 
		local celElement,tCell = CellSpaceChoose:createElement()
		if i > (dayNum + 1) or i == 1 then
			tCell:setDisplay("")
		else
			tCell:setDisplay((i-1)..LocalStrings.SPACE32)
		end
		celElement:setTag(i-1)    --从0开始设置Tag值
		tableContainer:setCellElement(celElement)
	end 
	local day = math.min(self.m_nCurDay,dayNum)
	tableContainer:getMoveElement():setPositionY((day-1)*50-(575+(dayNum-28)*25))

	--容器位置校正
    tbCon1:getMoveElement():setPositionY((year-os.date("%Y")+99)*50-2375)
    tbCon2:getMoveElement():setPositionY((month-1)*50-175)
end
-------------------------------------私有方法模块End----------------------------------------

--@brief 	英语适配模块
function WndSpaceChoose:_adaptLanguage_en()
	GetElement(self.m_root, "ttf2", WZUILabelTTF):setScale(0.7)
	GetElement(self.m_root, "ttf1", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.142,0.765))
	GetElement(self.m_root,"ttfConstellation",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.258,0.765))
end

function WndSpaceChoose:_adaptLanguage_pt(  )
	GetElement(self.m_root, "ttf2", WZUILabelTTF):setScale(0.7)
end

function WndSpaceChoose:_adaptLanguage_tr(  )
	GetElement(self.m_root, "ttf1", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.21,0.765))
	GetElement(self.m_root, "ttf2", WZUILabelTTF):setFontSize(16)
	GetElement(self.m_root, "ttfConstellation", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.39,0.765))
end

function WndSpaceChoose:_adaptLanguage_es(  )
	GetElement(self.m_root, "ttf1", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.18,0.765))
	local ttf = GetElement(self.m_root, "ttf2", WZUILabelTTF)
	ttf:setFontSize(16)
	ttf:setDimensions(GlobalMethod:CCSize(500,0))
	GetElement(self.m_root, "ttfConstellation", WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.33,0.765))
end
--ScenePvpAmuse.lua
--@brief	ScenePvpAmuse的UI模块
--@date		2016/11/21
--@author	binshao
--@note		pvp模式娱乐竞技


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function ScenePvpAmuse:onEnter(element)
	
	self.m_root = element
	ChangeChatChannel(Chat_Channel_Pvp_Amuse)
	ProtocolProcessorGlobal:send_ROOM_GetFunnyMatchInfo()
	self:_addCommonBtn()
	self:_addTop()
    WndChat:addChatWindowToCurScene()
    SoundManager:playBgMusic(SoundDefine.E_MUSIC_HALL)

    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function ScenePvpAmuse:onExit(element)
	self:_unInit()
end

function ScenePvpAmuse:getOpenTime()
	ProtocolProcessorGlobal:send_ROOM_GetFunnyMatchInfo()
end

function ScenePvpAmuse:showScene()
	local scene = ScenePvpAmuse:createElement()
	replaceScene(scene)
end

function ScenePvpAmuse:_addTop()
	local cell,tcell = CellTopHandle:createElement()
	self.m_root:addChild(cell)
    tcell:setTopData("ui/common/common_icon_yls.png",ScenePvpAmuse,ScenePvpAmuse.onTempClose,true,true,true,"ScenePvpAmuse")
    self.topCell = {cell = cell, tcell = tcell}
end

-- 返回
function ScenePvpAmuse:onTempClose()
	WZLog("----------ScenePvpAmuse:onReturn------------")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

	local scene = ScenePvp:createElement()
	replaceScene(scene)
end

--@brief    触摸开始回调
function ScenePvpAmuse:onTouchBegin(element, pt)
    WZLog("ScenePvpAmuse:onTouchBegin")
    local bPoint = WndItemInfo:checkPoint(pt)
    if bPoint == false then 
        WndItemInfo:onCloseClick()
    end

    if not WndTips:checkPointInBtn(pt) then
        WndTips:onCloseClick()
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function ScenePvpAmuse:_addCommonBtn()
	local cell,tcell = CellArenaCommonBtn:createElement()
	self.m_root:addChild(cell)
end

function ScenePvpAmuse:initOpenState()
	if self.m_root == nil then return end

	local tableList = GetElement(self.m_root, "tableList_ScenePvpAmuse", WZUITableContainer)
	tableList:cleanTable()

	for i = 1, #self.m_tItemList do
		local element, tNewObj = CellPvpAmuseItem:createElement()
		if element and tNewObj then 
			element:setTag(i - 1)
			tNewObj:setData(self.m_tItemList[i].openState, self.m_tItemList[i].matchType, self.m_tItemList[i].openTime)

			tableList:setCellElement(element)
		end
	end
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function ScenePvpAmuse:_adaptLanguage_en(  )
	for i = 1, 5 do
		local txtEventTime = GetElement(self.m_root,"txtEventTime"..i.."_ScenePvpAmuse",WZUILabelTTF)
		txtEventTime:setScale(0.85)
		txtEventTime:setRelativePosition(GlobalMethod:ccp(0.477778,0.5))

		local txtGameName = GetElement(self.m_root,"txtGameName"..i.."_ScenePvpAmuse",WZUILabelTTF)
		txtGameName:setScale(0.8)
		local txtGame = GetElement(self.m_root,"txtGame"..i.."_ScenePvpAmuse",WZUILabelTTF)
		txtGame:setScale(0.8)
		txtGame:setDimensions(GlobalMethod:CCSize(200))
	end
end

function ScenePvpAmuse:_adaptLanguage_th(  )
	for i = 1, 5 do
		local txtEventTime = GetElement(self.m_root,"txtEventTime"..i.."_ScenePvpAmuse",WZUILabelTTF)
		txtEventTime:setScale(0.85)
		txtEventTime:setRelativePosition(GlobalMethod:ccp(0.477778,0.5))

		local txtGame = GetElement(self.m_root,"txtGame"..i.."_ScenePvpAmuse",WZUILabelTTF)
		txtGame:setScale(0.8)
		txtGame:setDimensions(GlobalMethod:CCSize(200))
	end
end

function ScenePvpAmuse:_adaptLanguage_vn(  )
	-- for i = 1, 5 do
	-- 	local txtEventTime = GetElement(self.m_root,"txtEventTime"..i.."_ScenePvpAmuse",WZUILabelTTF)
	-- 	txtEventTime:setScale(0.7)
	-- 	txtEventTime:setRelativePosition(GlobalMethod:ccp(0.477778,0.6))

	-- 	local txtGameName = GetElement(self.m_root,"txtGameName"..i.."_ScenePvpAmuse",WZUILabelTTF)
	-- 	txtGameName:setScale(0.8)
	-- 	txtGameName:setRelativePosition(GlobalMethod:ccp(0.5,0.828492))
	-- 	local txtGame = GetElement(self.m_root,"txtGame"..i.."_ScenePvpAmuse",WZUILabelTTF)
	-- 	txtGame:setScale(0.8)
	-- 	txtGame:setDimensions(GlobalMethod:CCSize(200))
	-- 	txtGame:setRelativePosition(GlobalMethod:ccp(0.5,0.446345))
	-- end
end

function ScenePvpAmuse:_adaptLanguage_pt(  )
	for i = 1, 5 do
		local imgEventTime = GetElement(self.m_root,"imgEventTime"..i.."_ScenePvpAmuse",WZUIImage)
		imgEventTime:setScaleX(1.1)
		imgEventTime:setScaleY(1.5)
		imgEventTime:setRelativePosition(GlobalMethod:ccp(0.555556,0.5))
		local txtEventTime = GetElement(self.m_root,"txtEventTime"..i.."_ScenePvpAmuse",WZUILabelTTF)
		txtEventTime:setScale(0.8)
		txtEventTime:setDimensions(GlobalMethod:CCSize(100))

		local txtGameName = GetElement(self.m_root,"txtGameName"..i.."_ScenePvpAmuse",WZUILabelTTF)
		txtGameName:setScale(0.55)
		local txtGame = GetElement(self.m_root,"txtGame"..i.."_ScenePvpAmuse",WZUILabelTTF)
		txtGame:setScale(0.8)
		txtGame:setDimensions(GlobalMethod:CCSize(200))

		GetElement(self.m_root,"ftbOpenTime"..i.."_ScenePvpAmuse",WZUILabelTTF):setScale(0.8)
		GetElement(self.m_root,"ftbOpenHour"..i.."_ScenePvpAmuse",WZUILabelTTF):setScale(0.8)
	end
end

function ScenePvpAmuse:_adaptLanguage_es(  )
	for i=1,5 do
		local txtEventTime = GetElement(self.m_root,"txtEventTime"..i.."_ScenePvpAmuse",WZUILabelTTF)
		txtEventTime:setDimensions(GlobalMethod:CCSize(100,0))
		txtEventTime:setScale(0.7)
		local txtGameName = GetElement(self.m_root,"txtGameName"..i.."_ScenePvpAmuse",WZUILabelTTF)
		txtGameName:setScale(0.7)
	end
	GetElement(self.m_root,"txtGame2_ScenePvpAmuse",WZUILabelTTF):setScale(0.65)
	GetElement(self.m_root,"txtGame3_ScenePvpAmuse",WZUILabelTTF):setScale(0.8)
	GetElement(self.m_root,"txtGame5_ScenePvpAmuse",WZUILabelTTF):setScale(0.65)
	for i=1,5 do
		local ftbOpenHour = GetElement(self.m_root,"ftbOpenHour"..i.."_ScenePvpAmuse",WZUILabelTTF)
		ftbOpenHour:setScale(0.8)
	end
end

function ScenePvpAmuse:_adaptLanguage_tr(  )
	for i = 1, 5 do
		local txtEventTime = GetElement(self.m_root,"txtEventTime"..i.."_ScenePvpAmuse",WZUILabelTTF)
		txtEventTime:setScale(0.65)
		
		local txtGameName = GetElement(self.m_root,"txtGameName"..i.."_ScenePvpAmuse",WZUILabelTTF)
		txtGameName:setScale(0.55)
		local txtGame = GetElement(self.m_root,"txtGame"..i.."_ScenePvpAmuse",WZUILabelTTF)
		txtGame:setScale(0.8)
		txtGame:setDimensions(GlobalMethod:CCSize(200))
		
	end
end
-------------------------------------语言适配End--------------------------------------------
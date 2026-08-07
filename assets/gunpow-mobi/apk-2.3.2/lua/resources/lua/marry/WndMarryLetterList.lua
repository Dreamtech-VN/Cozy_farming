--WndMarryLetterList.lua
--@brief	WndMarryLetterList的UI模块
--@date		2014/01/15
--@author	叶威
--@note		求婚信列表


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMarryLetterList:onEnter(element)
	self.m_root = element
    self:update()
	--1.8多语言文本
	self:_moreLanguageForStroke()

    --if GlobalGame.g_tRedPointList.marry then
    --    GlobalGame.g_tRedPointList.marry = nil
    ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(94)
    SceneCity:updateRedDotBuilding("marry", false)
    --end
    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMarryLetterList:onExit(element)
	self:_unInit()
end

--@brief	关闭窗口
--@param	element:按钮的引用
function WndMarryLetterList:onCloseClick(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    if element == nil then
		WZLog("WndMarryLetterList:onCloseClick(element) element is nil ")
	end
	WindowManager:removeWindow(self.m_root, self, true)
    if IfActiveWindow(WndMarryHoll) == true then 
        WindowManager:removeWindow(WndMarryHoll.m_root,WndMarryHoll, true,false)
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新界面
function WndMarryLetterList:update()
    self:_updateLetterList()
end


--@brief 更新婚信列表
function WndMarryLetterList:_updateLetterList()
    WZLog("WndMarryLetterList:_updateLetterList")
    local tMarryLetters = WndMarryManager:getMarryLettersTable()
    local txt = ""
    if tMarryLetters ~= nil then
        local count = #tMarryLetters.marryRecordId
        local conLetter = WZUITableContainer:luaTo(GetElement(self.m_root,"tbconList_WndMarryLetterList"))
        conLetter:cleanTable()
        if conLetter == nil then
            WZLog("WndMarryLetterList:_updateLetterList conLetter == nil")
            return
        end
        for i = 1,count do
            --创建列表项
            cell,obj = CellMarryLetter:createElement()
            if cell ~= nil and obj ~= nil then
                self:getLetterContentByIndex(i,obj,tMarryLetters)
                obj:setLetterId(tMarryLetters.marryRecordId[i])
                cell:setTag(i-1)
            else
                WZLog("WndMarryLetterList:_updateLetterList cell ~= nil or obj ~= nil")
            end
            conLetter:setCellElement(cell)
        end
    else
        WZLog("WndMarryLetterList:_updateLetterList tMarryLetters is nil")
    end
end

--@brief 获得求婚信的内容
--@param index:第几封信
function WndMarryLetterList:getLetterContentByIndex(index,obj,tMarryLetters)
    if tMarryLetters ~= nil then
        --由编号，内容，时间拼接一条完整的求婚信简介
        local letterId = tMarryLetters.marryType[index]
        if letterId == 1 then
            letterId = "id_152"
        elseif letterId ==2 then
            letterId = "id_153"
        elseif letterId ==3 then
            letterId = "id_151"
        elseif letterId ==4 then
            letterId = "id_150"
        end
        local sendTimes = tMarryLetters.sendTimes[index]
        local sendName = tMarryLetters.sendPlayerName[index]
        sendTimes = sendTimes
        
        local strTime = os.date("%m-%d %H:%M",sendTimes)
        
        local proposeS = string.format(LocalStrings.PROPPSE_LIST_TIPS,GDatatab_item[letterId].name)

        local headId = tMarryLetters.headIds[index]
        local faceId = tMarryLetters.faceIds[index]

        local playerLevel = tMarryLetters.playerLevel[index]

        local playerId = tMarryLetters.playerId[index]

        local headColor = tMarryLetters.headColors[index]
        local serverId = tMarryLetters.serverId[index]

        obj:setLetterInfo(sendName,playerLevel,strTime,proposeS,headId,faceId,playerId,headColor, serverId)
    end
end

--1.8多语言文本
function WndMarryLetterList:_moreLanguageForStroke()
	if self.m_root == nil then
		return
	end
		--说明按钮文字
		local txtBtnExplain = self.m_root:getChildElement("txtBtnExplain_WndMarryLetterList")
		if txtBtnExplain ~= nil then
			txtBtnExplain = WZUILabelTTF:luaTo(txtBtnExplain)	
			txtBtnExplain:setText(LocalStrings.INTRODUCTION)
		end
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndMarryLetterList:_adaptLanguage_es(  )
    GetElement(self.m_root,"txtNameDesc_WndMarryLetter",WZUILabelTTF):setFontSize(20)
    local txtCoupleName = GetElement(self.m_root,"txtCoupleName_WndMarryLetter",WZUILabelTTF)
    txtCoupleName:setRelativePosition(GlobalMethod:ccp(0.41,0.415545))
    txtCoupleName:setFontSize(16)
end
-------------------------------------语言适配End--------------------------------------------
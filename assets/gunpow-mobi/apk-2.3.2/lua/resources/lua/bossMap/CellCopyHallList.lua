--CellCopyHallList.lua
--@brief	CellCopyHallList的UI模块
--@date		2015-7-29
--@author	binshao
--@note		组队副本的大厅房间列表cell

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellCopyHallList:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellCopyHallList:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellCopyHallList:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellCopyHallList")
    self.m_root:addChild(cellElement)
    self.loadEnd = true
    self:_update()
    AdaptLanguage(self)
end

-------------------------------------公有方法模块End----------------------------------------

--@brief	点击单元格背景时被调用的函数
--@param	element:表绑定的UI节点引用
function CellCopyHallList:onClickCell(element)
	WZLog("CellCopyHallList:onClickCell")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_tData.battleStatus == 1 then
        MsgBoxManager:showTipBox(LocalStrings.ROOM_BATTLEING)-- 战斗中
    elseif self.m_tData.roomStaus then
        MsgBoxManager:showTipBox(LocalStrings.ROOM_FULL)-- 等待，但人满
    elseif self.m_tData.passWord and string.len(self.m_tData.passWord) > 0 then
        self:enterRoomPassword() -- 密码房间
    else
        WndMultiCopy:joinRoomCallBack(self.m_tData.roomId,self.m_tData.passWord,self.m_tData.mapId)
    end
end

-- 密码输入框
function CellCopyHallList:enterRoomPassword()
    WndMultiCopy:setClickRoomData(self.m_tData.roomId, self.m_tData.passWord,self.m_tData.mapId)
	local element = WndEditBox:createElement()
    WndEditBox:setData(LocalStrings.ROOM_PASSWORD, LocalStrings.CLICK_TO_INPUT_PASSWORD)
    WndEditBox:setEditType(2)
    WndEditBox:setOkCallBack(self.enterRoomPasswordOk, self)
    WindowManager:addWindow(element, WndEditBox,true)
end

-- 确认输入密码
function CellCopyHallList:enterRoomPasswordOk(password)
    local passWord = WndMultiCopy:getClickRoomData().passWord
    local roomId = WndMultiCopy:getClickRoomData().roomId
    local mapId = WndMultiCopy:getClickRoomData().mapId
    WZLog("--------------CellCopyHallList:enterRoomPasswordOk--------------",password,passWord,roomId,mapId)
	if password ~= passWord then
		MsgBoxManager:showTipBox(LocalStrings.PASSWORD_NOT_MATCH)
		return false
    else
        WndMultiCopy:joinRoomCallBack(roomId,passWord,mapId)
        return true
	end
end

-------------------------------------私有方法模块Begin--------------------------------------

--@brief 更新函数
function CellCopyHallList:_update()
	--人数
    local txtPeopleNum = GetElement(self.m_root, "txtPeopleNum_CellCopyHallList", WZUILabelTTF)
    txtPeopleNum:setText(self.m_tData.playerNum.."/"..self.m_tData.playerCountNum)

    -- ID
    local txtId = GetElement(self.m_root, "txtRoomId_CellCopyHallList", WZUILabelTTF)
    txtId:setText(self.m_tData.roomId)
    WZLog("-----------------mul id-------------",self.m_tData.roomId)

    --是否加锁
    local imgLock = GetElement(self.m_root, "imgLock_CellCopyHallList")
    WZLog("self.m_tData.passWord-------------------1",self.m_tData.passWord)
    WZLog("self.m_tData.passWord-------------------2",self.m_tData.passWord == "")
    if self.m_tData.passWord and string.len(self.m_tData.passWord) > 0 then --有密码
        imgLock:setVisible(true)
    else
        imgLock:setVisible(false)
    end

    --房间名称
    local txtRoomName = GetElement(self.m_root, "txtRoomName_CellCopyHallList", WZUILabelTTF)
    txtRoomName:setText(self.m_tData.roomName)
	
    --房间状态
    local txtState = GetElement(self.m_root, "txtState_CellCopyHallList", WZUILabelTTF)
    local imgState = GetElement(self.m_root, "imgState_CellCopyHallList", WZUIImage)
	if self.m_tData.battleStatus == 1 then --战斗中
        imgState:setFile("ui/common/common_icon_fb_tz.png")
        txtState:setText(LocalStrings.COMBATTING)
        txtState:setColor(ccc3(255,89,73))
    elseif self.m_tData.roomStaus == true then --等待中已满人
        imgState:setFile("ui/common/common_icon_fb_dd.png")
        txtState:setText(LocalStrings.ATH_WAIT)
        txtState:setColor(ccc3(3,180,0))
    else --等待中没满人
        imgState:setFile("ui/common/common_icon_fb_dd.png")
        txtState:setText(LocalStrings.ATH_WAIT)
        txtState:setColor(ccc3(3,180,0))
    end

    -- 难度
    local tCopyData = GDatatab_team_map["id_"..self.m_tData.mapId]
    local difPath = {"ui/copy/copy_icon_jd1.png","ui/copy/copy_icon_kn1.png","ui/copy/copy_icon_dy1.png","ui/copy/copy_icon_jx1.png"}
    local txtPath = {"ui/common/common_icon_zdjd.png","ui/common/common_icon_zdkn.png","ui/common/common_icon_zddy.png","ui/common/common_icon_zdjx.png"}
    local imgDif = GetElement(self.m_root, "imgDif_CellCopyHallList", WZUIImage)
    local imgDifText = GetElement(self.m_root, "imgDifText_CellCopyHallList", WZUIImage)
    imgDif:setFile(difPath[tCopyData.difficulty])
    imgDifText:setFile(txtPath[tCopyData.difficulty])

    local imgHelpIcon = GetElement(self.m_root, "imgHelpIcon_CellCopyHallList", WZUIImage)
    if imgHelpIcon then 
        if self.m_tData.assist == 1 then 
            imgHelpIcon:setVisible(true)
        else
            imgHelpIcon:setVisible(false)
        end
    end
end
-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin-----------------------------------------
function CellCopyHallList:_adaptLanguage_es(  )
    local txtTip = GetElement(self.m_root,"txtTip_CellCopyHallList",WZUILabelTTF)
    txtTip:setFontSize(18)
    txtTip:setRelativePosition(GlobalMethod:ccp(0.83,0.52588))

--     local txtPeopleNum = GetElement(self.m_root,"txtPeopleNum_CellCopyHallList",WZUILabelTTF)
--     txtPeopleNum:setRelativePosition(GlobalMethod:ccp(0.116713,0.5))
end

function CellCopyHallList:_adaptLanguage_en()
    local txtPeopleNum = GetElement(self.m_root,"txtPeopleNum_CellCopyHallList",WZUILabelTTF)
    txtPeopleNum:setRelativePosition(GlobalMethod:ccp(0.953,0.5))
end
-------------------------------------私有方法模块End----------------------------------------
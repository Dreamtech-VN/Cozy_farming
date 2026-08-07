--CellRoomItem.lua
--@brief	CellRoomItem的UI模块
--@date		2013/12/18
--@author	李光森
--@note		游戏大厅中房间列表中的项


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellRoomItem:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellRoomItem:onExit(element)
	self:_unInit()
end

-- 加载数据
function CellRoomItem:onLoadData(element)
    local cellElement = WZUISystem:getInstance():createElement("CellRoomItem")
    self.m_root:addChild(cellElement)
    AdaptLanguage(self)
    self:_update()
end

--@brief	cell点击回调
--@param	element:触发事件的控件引用
function CellRoomItem:onCellClickCallback(element)
    WZLog("CellRoomItem:onCellClickCallback")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_lpClickCallback ~= nil then
        self.m_lpClickCallback(self.m_tCallbackTable,self)
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	cell更新函数
--@note     实际上的初始化函数
function CellRoomItem:_update()
    -- 匹配，组队模式，混战模式
    local imgPath = {"ui/common/common_icon_ppms.png","ui/common/common_icon_zdms.png","ui/common/common_icon_hzms.png"}
    local imgMode = GetElement(self.m_root,"imgMode_CellRoomItem",WZUIImage)
    imgMode:setFile(imgPath[self.m_tData.startMode])

    local txtId = GetElement(self.m_root,"txtId_CellRoomItem",WZUILabelTTF)
    txtId:setText(self.m_tData.roomId)

    local txtPcnt = GetElement(self.m_root,"txtPCnt_CellRoomItem",WZUILabelTTF)
    txtPcnt:setText(self.m_tData.playerNum.."/"..self.m_tData.maxNum)

    local txtName = GetElement(self.m_root,"txtRoomName_CellRoomItem",WZUILabelTTF)
    txtName:setText(self.m_tData.roomName)

    --状态  0:等待中，1:战斗中
    local txtState = GetElement(self.m_root,"txtState_CellRoomItem",WZUILabelTTF)
    local imgState = GetElement(self.m_root,"imgState_CellRoomItem",WZUIImage)
    if self.m_tData.battleStatus==0 then
        txtState:setText(LocalStrings.HALL_WAIT)
        txtState:setStrokeColor(GlobalMethod:ccc3(3,111,8))
        imgState:setFile("ui/common/common_icon_dengjb.png")
        txtPcnt:setColor(GlobalMethod:ccc3(79,60,48))
    elseif self.m_tData.battleStatus==1 then
        txtState:setText(LocalStrings.WORD_FIGHTING)
        txtState:setStrokeColor(GlobalMethod:ccc3(155,0,0))
        imgState:setFile("ui/common/common_icon_zhanjb.png")
        txtPcnt:setColor(GlobalMethod:ccc3(158,0,0))
    end

    local imgLock = GetElement(self.m_root,"imgLock_CellRoomItem",WZUIImage)
    --WZLog("---------------------password------------------",self.m_tData.roomName,self.m_tData.passWord)
    imgLock:setVisible(self.m_tData.passWord ~= "-1")
end
-------------------------------------私有方法模块End---------------------------------------

------------------------------------------语言适配Begin----------------------------------------------
function CellRoomItem:_adaptLanguage_en(  )
    local txt = GetElement(self.m_root,"txtState_CellRoomItem",WZUILabelTTF)
    txt:setFontSize(13)
    txt:setRotation(43)
    txt:setRelativePosition(GlobalMethod:ccp(0.663333,0.633333))

    GetElement(self.m_root,"txtRoomName_CellRoomItem",WZUILabelTTF):setMaxLength(18)

    GetElement(self.m_root,"txtId_CellRoomItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.376923,0.66))
    GetElement(self.m_root,"txtPCntT_CellRoomItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.450769,0.27))
    GetElement(self.m_root,"txtPCnt_CellRoomItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.890769,0.27))
end

function CellRoomItem:_adaptLanguage_th(  )
    GetElement(self.m_root,"txtRoomName_CellRoomItem",WZUILabelTTF):setMaxLength(50)

    GetElement(self.m_root,"txtId_CellRoomItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.376923,0.66))
    GetElement(self.m_root,"txtPCntT_CellRoomItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.466154,0.27))
    GetElement(self.m_root,"txtPCnt_CellRoomItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.936923,0.27))
end

function CellRoomItem:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtRoomName_CellRoomItem",WZUILabelTTF):setMaxLength(30)

    local txt = GetElement(self.m_root,"txtState_CellRoomItem",WZUILabelTTF)
    txt:setRotation(43)
    txt:setRelativePosition(GlobalMethod:ccp(0.7375,0.709375))

    GetElement(self.m_root,"txtPCntT_CellRoomItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.450769,0.27))
    GetElement(self.m_root,"txtPCnt_CellRoomItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.906154,0.27))
end

function CellRoomItem:_adaptLanguage_pt(  )
    local txt = GetElement(self.m_root,"txtState_CellRoomItem",WZUILabelTTF)
    txt:setFontSize(12)
    txt:setRotation(43)
    txt:setRelativePosition(GlobalMethod:ccp(0.646667,0.633333))

    GetElement(self.m_root,"txtPCntT_CellRoomItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.450769,0.27))
    GetElement(self.m_root,"txtPCnt_CellRoomItem",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.913846,0.27))
end


function CellRoomItem:_adaptLanguage_tr()
    local txtState = GetElement(self.m_root,"txtState_CellRoomItem",WZUILabelTTF)
    txtState:setScale(0.6)
    txtState:setRotation(45)
    txtState:setRelativePosition(GlobalMethod:ccp(0.6875,0.659375))
end

function CellRoomItem:_adaptLanguage_es(  )
    local txt = GetElement(self.m_root,"txtState_CellRoomItem",WZUILabelTTF)
    txt:setFontSize(12)
    txt:setRotation(43)
    txt:setRelativePosition(GlobalMethod:ccp(0.646667,0.633333))

    local txtPCntT = GetElement(self.m_root,"txtPCntT_CellRoomItem",WZUILabelTTF)
    txtPCntT:setRelativePosition(GlobalMethod:ccp(0.6,0.27))

    local txtPCnt = GetElement(self.m_root,"txtPCnt_CellRoomItem",WZUILabelTTF)
    txtPCnt:setRelativePosition(GlobalMethod:ccp(1.19,0.27))
end

function CellRoomItem:_adaptLanguage_ug(  )
    local txtId = GetElement(self.m_root,"txtId_CellRoomItem",WZUILabelTTF)
    txtId:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtId:setRelativePosition(GlobalMethod:ccp(1.15,0.66))
    local txtPCnt = GetElement(self.m_root,"txtPCnt_CellRoomItem",WZUILabelTTF)
    txtPCnt:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtPCnt:setRelativePosition(GlobalMethod:ccp(0.5,0.27))
    local txtIdT = GetElement(self.m_root,"txtIdT_CellRoomItem",WZUILabelTTF)
    txtIdT:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtIdT:setRelativePosition(GlobalMethod:ccp(1.4,0.66))
    local txtPCntT = GetElement(self.m_root,"txtPCntT_CellRoomItem",WZUILabelTTF)
    txtPCntT:setAnchorPoint(GlobalMethod:ccp(1,0.5))
    txtPCntT:setRelativePosition(GlobalMethod:ccp(1.4,0.27))
end
------------------------------------------语言适配End------------------------------------------------
--WndMarryLetter.lua
--@brief	WndMarryLetter的UI模块
--@date		2014/01/08
--@author	叶威
--@note		求婚信


-------------------------------------公有方法模块Begin--------------------------------------


--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndMarryLetter:onEnter(element)
    WZLog("WndMarryLetter:onEnter")
	self.m_root = element
    
    self:_update()

    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndMarryLetter:onExit(element)
	self:_unInit()
end

--@brief	关闭窗口
--@param	element:按钮的引用
function WndMarryLetter:onCloseClick(element)
    WZLog("WndMarryLetter:onCloseClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)

    if element == nil then
		WZLog("WndMarryLetter:onCloseClick(element) element is nil ")
	end
    --WindowManagerAni:createCloseAction(self.m_root,"onCloseActionCallback",self)
    self:onCloseActionCallback()
end

--@brief   关闭动画回调
function WndMarryLetter:onCloseActionCallback(elem,data)
    local nWindowType = self.m_nWindowType
    WindowManager:removeWindow(self.m_root, self, true)
    if nWindowType == WndMarryLetter.wndType.RECV_LETTER then
        if IfActiveWindow(WndPurchase) == true then
            WindowManager:removeWindow(WndPurchase.m_root,WndPurchase, true,false)
        end
        if IfActiveWindow(WndMarryHoll) == true then
            WindowManager:removeWindow(WndMarryHoll.m_root,WndMarryHoll, true,false)
        end
    end
end
--------------发送求婚信------------

--@brief 设置求婚成功后自己的名字
function WndMarryLetter:setMyName(element)
	WZLog("WndMarryLetter:setMyName()")
    if element then 
        local txtMyName_WndMarryLetter = element:getChildElement("txtMyName_WndMarryLetter")
        if txtMyName_WndMarryLetter then 
            --WZUILabelTTF:luaTo(txtMyName_WndMarryLetter):setText(GlobalGame.g_tPlayerInfo.sPlayerName)
        end 
    end
end 


--@brief 好友列表按钮响应函数
--@param element:按钮的引用
function WndMarryLetter:onFriendListClick(element)
    WZLog("WndMarryLetter:onFriendListClick -------------")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local parent = element:getParent()
    local parentTag = parent:getTag()
    if parentTag > 1 then
        WndCheckOther:show(parentTag)
    else
        WndFriendList:showInterface(5,self,self.selectSexFriendCallBack) --显示好友界面
    end
end

--@brief 异性好友选定回调函数
--@param id：异性好友的id，name：异性好友的名字 lv 等级 zsdj 转生等级
function WndMarryLetter:selectSexFriendCallBack(lovingInfo)
    WZLog("lovingInfo = ",Serialize(lovingInfo))
    if lovingInfo ~=nil and #lovingInfo >=1 then
        self.m_nCoupleId = lovingInfo[1].id
        local lovingInfoName = lovingInfo[1].name
        local faceItemId = lovingInfo[1].faceItemId 
        local headItemId = lovingInfo[1].headItemId
        local sex = lovingInfo[1].sex
        local headColor = lovingInfo[1].headColor
        self.m_nFriendliness = lovingInfo[1].friendliness
        local tEquip = {faceItemId,headItemId}
        local conLovingFace =  WZUIContainer:luaTo(GetElement(self.m_root,"conLovingFace_WndMarryLetter"))
        local headNode= CellHead:show(conLovingFace,headItemId,faceItemId,sex,nil,nil,nil,headColor)
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtCoupleName_WndMarryLetter")):setText(lovingInfoName)
    end
end
--@brief  发送按钮响应函数
--@param  element:按钮的引用
function WndMarryLetter:onSendClick(element)
    WZLog("WndMarryLetter:onSendClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local num = CacheCenter:getGameParam().marryFriendNum
    if self.m_nCoupleId == 0 then
         MsgBoxManager:showTipBox(LocalStrings.CHANGE_LOVER)
         return
    elseif self.m_nFriendliness  ~= nil and tonumber(self.m_nFriendliness) < tonumber(num) then
       local txt =string.format(LocalStrings.SEND_PROPOSAL_LETTER9,num)
       MsgBoxManager:showTipBox(txt)
       return
    end
    --确认求婚
    local index = self.m_nMarryType
     --发送求婚信
    ProtocolProcessorWndMarry:send_WEDDING_SendLoveLetter(self.m_nCoupleId, 1, self.m_nMarryType,-1)
    WndMarryManager:removeAllWindow()
end

--@brief 点击购买道具确认按钮的响应函数
--@param  id:消息的id，nType:消息响应类型
function WndMarryLetter:onBuyItemClick(id,nType)
    --确定购买
    if nType == MSGBOXRESTYPE_CONFIRM then
        WZLog("WndMarryLetter:onBuyItemClick")
        local buyId = WndMarryManager.itemIds[self.m_nMarryType]
        local fileName,_= self:_getFileNameAndLetter()
        WndPurchase:showBuyInterface(6,buyId,nil,nil,nil)
    end
end

--@brief 购买道具完成后的回调处理
function WndMarryLetter:buyItemCallBack()
    WZLog("WndMarryLetter:buyItemCallBack")
    WndMarryManager:setIsRefreshData(true)
    ProtocolProcessorWndMarry:send_WEDDING_GetMaritalStatus()  --刷新结婚道具
end

--@brief 消耗道具提示点击确定后的回调处理
function WndMarryLetter:sureRequireMarry()
    WZLog("WndMarryLetter:sureRequireMarry")
    --确认求婚
    local index = self.m_nMarryType
     WZLog("index: " , index,self.m_nCoupleId)
     --发送求婚信
    ProtocolProcessorWndMarry:send_WEDDING_SendLoveLetter(self.m_nCoupleId, 1, self.m_nMarryType,-1)
    WndMarryManager:removeAllWindow()
end

----------接收到求婚信--------

--@brief 点击同意按钮的响应函数
--@param  element:按钮的引用
function WndMarryLetter:onAgreeClick(element)
    WZLog("WndMarryLetter:onAgreeClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --同意订婚，结果回调在WndMarryManager中处理
	WZLog("self.m_nCoupleId = ",self.m_nCoupleId)
    ProtocolProcessorWndMarry:send_WEDDING_ChangeMarryStatus(true,self.m_nCoupleId,-1)
    WndMarryManager:removeAllWindow()

    if GlobalGame.g_tRedPointList.marry then
        SceneCity:updateRedDotBuilding("marry", false)
    end
    ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(94)

end

--@brief 点击拒绝按钮的响应函数
--@param  element:按钮的引用
function WndMarryLetter:onRejectClick(element)
    WZLog("WndMarryLetter:onRejectClick")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --拒绝求婚,结果回调在WndMarryManager中处理
    ProtocolProcessorWndMarry:send_WEDDING_ChangeMarryStatus(false,self.m_nCoupleId,-1)
    WndMarryManager:removeAllWindow()

    if GlobalGame.g_tRedPointList.marry then
        SceneCity:updateRedDotBuilding("marry", false)
    end
    ProtocolProcessorSceneCity:send_PLAYER_CancelRedDot(94)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	更新界面
function WndMarryLetter:_update()
    WZLog("WndMarryLetter:_update()")
    self:_updateIcon()
    self:_showTypeWindow()
    self:_playAnimation()
end


--@brief	获取图标路径和求婚信内容
--@return #1,图标名称
--@return #2,求婚信内容
function WndMarryLetter:_getFileNameAndLetter()
    local fileName = nil
    local txt = nil
    WZLog("WndMarryLetter:_getFileNameAndLetter")
    WZLog(self.m_nMarryType)
    local conbg1 = GetElement(self.m_root,"conbg1_WndMarryLetter",WZUIContainer)
    local conbg2 = GetElement(self.m_root,"conbg2_WndMarryLetter",WZUIContainer)
    local conbg3 = GetElement(self.m_root,"conbg3_WndMarryLetter",WZUIContainer)
    local conbg4 = GetElement(self.m_root,"conbg4_WndMarryLetter",WZUIContainer)
    local imgProGift = GetElement(self.m_root,"imgProGift_WndMarryLetter",WZUIImage)
    local btnReject = GetElement(self.m_root,"btnReject_WndMarryLetter",WZUIButton)
    local btnSend = GetElement(self.m_root,"btnSend_WndMarryLetter",WZUIButton)
    local btnAgree = GetElement(self.m_root,"btnAgree_WndMarryLetter",WZUIButton)
    local txtProp = GetElement(self.m_root,"txtProp_WndMarryLetter",WZUILabelTTF)

    local norElement = btnSend:getNormalElement()
    local norImg = WZUI9Image:luaTo(norElement:getChildByTag(1))
    local selElement = btnSend:getSelectElement()
    local selImg = WZUI9Image:luaTo(selElement:getChildByTag(1))

    local agreeNorElement = btnAgree:getNormalElement()
    local agreeNorImg = WZUI9Image:luaTo(agreeNorElement:getChildByTag(1))
    local agreeSelElement = btnAgree:getSelectElement()
    local agreeSelecetImg = WZUI9Image:luaTo(agreeSelElement:getChildByTag(1))


    local rejectNorElement = btnReject:getNormalElement()
    local rejNorImg = WZUI9Image:luaTo(rejectNorElement:getChildByTag(1))
    local rejectSelElement = btnReject:getSelectElement()
    local regSelecetImg = WZUI9Image:luaTo(rejectSelElement:getChildByTag(1))

    if self.m_nMarryType == WndMarryManager.marryType.DREAM  then
        --梦幻求婚
        fileName = "ui/marrige/common_icon_xxhs.png"
        txt = LocalStrings.MARRY_ROMAN_CONTENT
        conbg1:setVisible(true)
        imgProGift:setFile("ui/marrige/common_icon_fk.png")

        norImg:setFile("ui/common/common_btn_marryf.png")
        selImg:setFile("ui/common/common_btn_marryf_sel.png")

        rejNorImg:setFile("ui/common/common_btn_marryf.png")
        regSelecetImg:setFile("ui/common/common_btn_marryf_sel.png")

        agreeNorImg:setFile("ui/common/common_btn_marryf.png")
        agreeSelecetImg:setFile("ui/common/common_btn_marryf_sel.png")

        txtProp:setStrokeColor(GlobalMethod:ccc3(255,117,134))
       
    elseif self.m_nMarryType == WndMarryManager.marryType.ROMAN then
        --浪漫求婚
        fileName = "ui/marrige/common_icon_sjx.png"
        txt = LocalStrings.MARRY_SIMPLE_CONTENT
        conbg2:setVisible(true)
        imgProGift:setFile("ui/marrige/common_icon_zkk.png")

        norImg:setFile("ui/common/common_btn_marryz.png")
        selImg:setFile("ui/common/common_btn_marryz_sel.png")

        rejNorImg:setFile("ui/common/common_btn_marryz.png")
        regSelecetImg:setFile("ui/common/common_btn_marryz_sel.png")

        agreeNorImg:setFile("ui/common/common_btn_marryz.png")
        agreeSelecetImg:setFile("ui/common/common_btn_marryz_sel.png")
       
        txtProp:setStrokeColor(GlobalMethod:ccc3(189,104,182))
    elseif self.m_nMarryType == WndMarryManager.marryType.WARM then
        --温馨求婚
        fileName = "ui/marrige/common_icon_jpg.png"
        txt = LocalStrings.MARRY_DREAM_CONTENT
        conbg3:setVisible(true)
        imgProGift:setFile("ui/marrige/common_icon_hk.png")

        norImg:setFile("ui/common/common_btn_marryh.png")
        selImg:setFile("ui/common/common_btn_marryh_sel.png")

        rejNorImg:setFile("ui/common/common_btn_marryh.png")
        regSelecetImg:setFile("ui/common/common_btn_marryh_sel.png")

        agreeNorImg:setFile("ui/common/common_btn_marryh.png")
        agreeSelecetImg:setFile("ui/common/common_btn_marryh_sel.png")
       
        txtProp:setStrokeColor(GlobalMethod:ccc3(244,167,107))
    elseif self.m_nMarryType == WndMarryManager.marryType.SIMPLE then
        --朴实求婚
        fileName = "ui/marrige/common_icon_zsjz.png"
        txt = LocalStrings.MARRY_WARM_CONTENT
        conbg4:setVisible(true)
        imgProGift:setFile("ui/marrige/common_icon_nk.png")

        norImg:setFile("ui/common/common_btn_marryl.png")
        selImg:setFile("ui/common/common_btn_marryl_sel.png")

        rejNorImg:setFile("ui/common/common_btn_marryl.png")
        regSelecetImg:setFile("ui/common/common_btn_marryl_sel.png")

        agreeNorImg:setFile("ui/common/common_btn_marryl.png")
        agreeSelecetImg:setFile("ui/common/common_btn_marryl_sel.png")

      
        txtProp:setStrokeColor(GlobalMethod:ccc3(99,151,197))
    end
    
    return fileName,txt
end

--@brief	更新道具图标,求婚内容
function WndMarryLetter:_updateIcon()
    WZLog("WndMarryLetter:_updateIcon")
    local fileName = nil
    local txt = nil
    fileName,txt = self:_getFileNameAndLetter()
    if fileName ~= nil then
        WZUIImage:luaTo(GetElement(self.m_root,"imgIcon_WndMarryLetter")):setFile(fileName)
    end
    if txt ~= nil then
        self:_updateLanguageText(txt)
    end
end

--@brief 根据窗口类型显示具体界面
function WndMarryLetter:_showTypeWindow()
    WZLog("WndMarryLetter:_showTypeWindow")
    if self.m_nWindowType == WndMarryLetter.wndType.SEND_LETTER then
       
		--发送婚信
        WZUIContainer:luaTo(GetElement(self.m_root,"conName_WndMarryLetter")):setVisible(true)
        WZUIContainer:luaTo(GetElement(self.m_root,"conSendBtn_WndMarryLetter")):setVisible(true)
        WZUIContainer:luaTo(GetElement(self.m_root,"conAgreeBtn_WndMarryLetter")):setVisible(false)
        WZUIContainer:luaTo(GetElement(self.m_root,"conRejectBtn_WndMarryLetter")):setVisible(false)
         --显示玩家名字
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtYourName_WndMarryLetter")):setText(GlobalGame.g_tPlayerInfo.sPlayerName)

        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtProposeTips_WndMarryLetter")):setText(LocalStrings.PROPOSE_TIPS)
    else
		--收到婚信
        WZUIContainer:luaTo(GetElement(self.m_root,"conName_WndMarryLetter")):setVisible(true)
        WZUIContainer:luaTo(GetElement(self.m_root,"conSendBtn_WndMarryLetter")):setVisible(false)
        WZUIContainer:luaTo(GetElement(self.m_root,"conAgreeBtn_WndMarryLetter")):setVisible(true)
        WZUIContainer:luaTo(GetElement(self.m_root,"conRejectBtn_WndMarryLetter")):setVisible(true)
        --GetElement(self.m_root,"conClose_WndMarryLetter",WZUIContainer):setVisible(false)
        -- 显示玩家名字
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtCoupleName_WndMarryLetter")):setText(GlobalGame.g_tPlayerInfo.sPlayerName)
        --显示求婚人的名字
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtYourName_WndMarryLetter")):setText(self.m_sCoupleName)
        WZUILabelTTF:luaTo(GetElement(self.m_root,"txtProposeTips_WndMarryLetter")):setText("")
        local playerInfo = CacheCenter:getPlayerInfo()
        local sex = playerInfo.sex
        if sex == 0 then
            sex =1
        else
            sex = 0
        end

        local conPropFace =WZUIContainer:luaTo(GetElement(self.m_root,"conLovingFace_WndMarryLetter"))
        if self.m_nPlyaerId ~= nil then
            conPropFace:setTag(self.m_nPlyaerId)
        end
        if conPropFace:getChildByTag(5) ~=nil then
           conPropFace:removeChildByTag(5,true)
        end
        WZLog("CellHead:show() = ",self.m_nSendHeadId,self.m_nSendFaceId)
        local headNode= CellHead:show(conPropFace,self.m_nSendHeadId,self.m_nSendFaceId,sex,nil,nil,nil,self.m_nHeadColor)
        headNode:setTag(5)
        
    end
end

--@brief   更新多语言文本
--@param   content:文本内容
function WndMarryLetter:_updateLanguageText(content)
    --文本内容
    WZUILabelTTF:luaTo(GetElement(self.m_root,"txtContent_WndMarryLetter")):setText("    " .. content)
end

--@brief  播放动画
function WndMarryLetter:_playAnimation()
     -- local element = WZUISystem:getInstance():createElement(WndMarryManager.animationName.qiuhun1)
     -- if element == nil then
     --    WZLog("WndMarryLetter:_playAnimation,element == nil")
     --    return
     -- end
     -- element:setTouchEnable(false)
     -- element:setZOrder(99999)
     -- WindowManager:getSceneRoot():addChild(element)
 --    self.m_root:addChild(element)  
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function WndMarryLetter:_adaptLanguage_tr(  )
    GetElement(self.m_root, "txtProposeTips_WndMarryLetter", WZUILabelTTF):setScale(0.75)

    GetElement(self.m_root,"txtCoupleName_WndMarryLetter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.376324,0.415545))
end

function WndMarryLetter:_adaptLanguage_en(  )
    GetElement(self.m_root,"txtProp_WndMarryLetter",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.50563,0.862656))

    local txtProposeTips = GetElement(self.m_root,"txtProposeTips_WndMarryLetter",WZUILabelTTF)
    txtProposeTips:setDimensions(GlobalMethod:CCSize(400))
    txtProposeTips:setRelativePosition(GlobalMethod:ccp(0.5,0.674969))
end

function WndMarryLetter:_adaptLanguage_es(  )
    WZUIContainer:luaTo(GetElement(self.m_root,"conName_WndMarryLetter")):setRelativePosition(GlobalMethod:ccp(0.57,0.705511))
end
-------------------------------------语言适配End--------------------------------------------
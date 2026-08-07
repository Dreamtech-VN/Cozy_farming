--WndMail.lua
--@brief	WndMail的UI模块
--@date	2015/3/23
--@author	chuanchuan_wang
--@note          邮件模块

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note	在这里做场景进入前的准备工作
function WndMail:onEnter(element)
	WZLog("WndMail:onEnter",self.m_nOpenTag)
	self.m_root = element
	ChangeChatChannel( Chat_CHannel_Mail )
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note	在这里做场景退出前的清理工作
function WndMail:onExit(element)
	WZLog("退出场景WndMail:onExit")
    g_bIsShowWndDressUp = true
    g_tTempItemForLaterShow = {}

	self:_unInit()
end

--@brief	创建窗口动画
function WndMail:onEnterTransitionDidFinish(element)
    g_bIsShowWndDressUp = false
    g_tTempItemForLaterShow = {}

    WindowManagerAni:createAppearAction(self.m_root,true,"actionCallback",self)
end

function WndMail:setTips(fullBag)
    self.bFullBag = fullBag
    WndRewardShow:closeCallBack(self,self.tipCallBack)
end

function WndMail:tipCallBack(fullBag)
    if self.bFullBag then
       self.bFullBag = false
        MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG2)
    end
end

--@brief	邮件接口
--@param    recId:收件人id,recName:收件人名字，mailTheme:邮件主题
--@note     三个参数都为空表示点击邮件按钮进入，不为空则表示通过发邮件进入
function WndMail:showMail(recId,recName,mailTheme)
	WZLog("邮件接口WndMail:showMail",recId,recName,mailTheme)
    --1.未打开：（1）点击打开 （2）发邮件
	if self.m_root == nil then
		local wndMailElement = WndMail:createElement()
		WindowManager:addWindow(wndMailElement, WndMail, false)
	end
    if recId ~= nil and recName ~= nil then
        self.m_nOpenTag = 2
		self.t_editMail = {}
        self.t_editMail.recId = recId
        self.t_editMail.recName = recName
        self.t_editMail.mailTheme = mailTheme
        GetElement(self.m_root, "selRecvMailOfBoxGroup_WndMail", WZUICheckBox):setCheckIndex(0)
        GetElement(self.m_root, "selSendMailOfBoxGroup_WndMail", WZUICheckBox):setCheckIndex(1)
    end
end

--@brief	窗口动画完成回调
function WndMail:actionCallback(elem,data)
    --设置界面文本
    self:_setUIStaticText()
    CacheCenter:isMailRedPoint()
    -- 初始化邮件系统
    self:_initMailSysInfo(self.m_nOpenTag)
    --初始化商务箱的红点
    self:addMarkonShop()
    --多语言版本界面适配
    -- AdaptLanguage(self)
end

function WndMail:addMarkonShop()
    local mailList = CacheCenter:getMailList()
    local bAddMark = false
    for i = 1, #mailList do
        if self:_isShopMail(mailList[i]) then
            --4为已领取，6为已付款，7为已拒绝
            if mailList[i].isRead ~= 4 and mailList[i].isRead ~= 6 and mailList[i].isRead ~= 7 then
                bAddMark = true
                break
            end
        end
    end
    if bAddMark then
      local con1 = self.m_root:getChildElement("selShopMailOfBoxGroup_WndMail")
      AddRemark(con1, true)
    end
end

--@brief	单击关闭按钮时被调用的函数
--@note	关闭后返回主界面
function WndMail:onCloseClick(element)
	WZLog("单击关闭按钮")
	SoundManager:playEffectSound(SoundDefine.E_S_CLOSE_WIN)
	self.m_nNearFriendId = nil		 --是否附近好友打开邮件
	if self.m_tNearBack and self.m_tNearBack then
		self.m_tNearBack[2](self.m_tNearBack[1])
	end
    	WindowManagerAni:createDisappearAction(self.m_root,"onCloseActionCallback_mail",self)
end

--@brief	窗口动画关闭完成回调
function WndMail:onCloseActionCallback_mail(elem,data)
    	  WindowManager:removeWindow(self.m_root , WndMail , true)
end

--@brief	开始触摸回调函数
--@param	element：触发的节点
--@param	pt：按下的位置
function WndMail:clickBegan(element , pt)
	WZLog("开始触摸clickBegan")
  local point = self.m_root:convertToNodeSpace(pt)
  local bPoint = WndItemInfo:checkPoint(pt,dir)
  if bPoint == true then
  else
    WndItemInfo:onCloseClick()
  end
end

function WndMail:onReturn(element)
    WZLog("WndMail:onReturn(element)")
	checkEditLenovoWord(element)
end
--@brief    editbox输入结束是调用
function WndMail:onReturnContent(element)
    WZLog("WndMail:onReturnContent(element)")
	checkEditLenovoWord(element)
    --获取类容
    local editContentMail = WZUIEditBox:luaTo(self.m_root:getChildElement("editContentMail_WndMail"))
    local content = editContentMail:getText()
    WZLog("content===",content)
    local editboxTheme = GetElement(self.m_root,"editThemeMail_WndMail",WZUIEditBox)
    local theme = editboxTheme:getText()
    WZLog("theme===",theme)
    --缓存邮件类容
    local mailListCache = CacheCenter:getMailList()
    WZLog("#mailListCache===",#mailListCache,#self.m_tMailList)
    for i=1,#mailListCache do
        if mailListCache[i].mailType == 3 then
            mailListCache[i].recTheme = theme
            mailListCache[i].mailContent = content
            for j=1,#self.m_tMailList do
                if self.m_tMailList[j].mailType == 3 then
                    self.m_tMailList[j].recTheme = theme
                    self.m_tMailList[j].mailContent = content
                    break
                end
            end
            break
        end
    end
end

--@brief	复选框组的收件箱按钮单击时被调用的函数
--@note	更换主题背景图片,隐藏底部文字,发送发收件箱协议
function WndMail:onRecvMailGroupClick()
	WZLog("点击收件箱")
    self:_setOpenTag(1)
end

--@brief	复选框组的发件箱按钮单击时被调用的函数
--@note	更换主题背景图片,显示底部文字并发收件箱协议
function WndMail:onSendMailGroupClick()
	WZLog("点击发件箱")
    self:_setOpenTag(2)
end

--@brief   复选框组的商务箱按钮单击时被调用的函数
--@note 更换主题背景图片,显示底部文字并发收件箱协议
function WndMail:onShopMailGroupClick()
    WZLog("点击商务箱")
    self:_setOpenTag(3)
    local con1 = self.m_root:getChildElement("selShopMailOfBoxGroup_WndMail")
    AddRemark(con1, false)
end

--@brief 选取标签栏点击时得处理
function WndMail:_setOpenTag(openTag)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN2)
    if self.m_root == nil or self.m_nOpenTag == openTag then
        return
    end
    self.m_nOpenTag = openTag 
    self.n_curPage = 1
    self.m_tCurOpenMail = nil
    if self.m_nOpenTag ~= 2 then --收件箱
        GetElement(self.m_root,"txtSender2_WndMail",WZUILabelTTF):setText(LocalStrings.MAIL_SENDER)
    else  --发件箱
        GetElement(self.m_root,"txtSender2_WndMail",WZUILabelTTF):setText(LocalStrings.MAIL_RECV)
    end
    --隐藏写信面板
    GetElement(self.m_root,"conMailContentBk1_WndMail",WZUIContainer):setVisible(false)
    GetElement(self.m_root,"conMailContentBk2_WndMail",WZUIContainer):setVisible(false)
    --创建邮件列表
    self:_createMailMenuList()
    self:onCompleteMailClick()
    self:_setWndMailBtnVisible(openTag)
end

--@brief    更新邮件列表
function WndMail:updateMailList(tMailData)
    WZLog("WndMail:updateMailList()")
    if self.m_root == nil or self.m_nOpenTag == 2 then
        return
    end
    local isShopMial = self:_isShopMail(tMailData)
    if isShopMial then
      local con1 = self.m_root:getChildElement("selShopMailOfBoxGroup_WndMail")
      AddRemark(con1, true)
    end
    local btag = self.m_nOpenTag == 3
    if isShopMial ~= btag then
        return
    end
    --设置按钮是否可见
    self:_setWndMailBtnVisible(self.m_nOpenTag)
    --创建邮件列表
    self:_createMailMenuList()
    --显示邮件图标或复选框
    self:_isMailIconVisible(self.b_isEdit)
end

--@brief    更新邮件列表
function WndMail:updateShopMailList(id, state)
    WZLog("WndMail:updateShopMailList()")
    self:closeLoading("updateShopMailList")
    local mailListCache = CacheCenter:getMailList()
    for i=1,#mailListCache do
        if mailListCache[i].mailId == id then
            if state == 7 then
                table.remove(mailListCache, i)
                --设置按钮是否可见
                GetElement(self.m_root,"btnReject_WndMail",WZUIButton):setVisible(false)        --拒绝
                GetElement(self.m_root,"btnPay_WndMail",WZUIButton):setVisible(false)        --付款
                self:_createMailMenuList()
            else
               mailListCache[i].isRead =  state
               self.m_tCurOpenMail.isRead = state
               self:openShopMail()
            end
            break
        end
    end
end

--@brief 点击拒绝付款按钮
function WndMail:onReject()
    WZLog("点击拒绝按钮")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    self:createLoading("onReject") 
    ProtocolProcessorWndMail:MAIL_MallMailOperate(self.m_tCurOpenMail.mailId, 3)
end

-- --@brief 点击付款按钮
-- function WndMail:onDoPay() 
--     WZLog("点击付款按钮")
--     SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
--     MsgBoxManager:showConfirmBox(LocalStrings.PETCONFIRMREBIRTH, WndMail,self.doPay)
-- end

--@brief 点击付款按钮
function WndMail:onDoPay()
    WZLog("点击付款按钮2")
    local id,num = SplitItemString(self.m_tCurOpenMail.cost)
    WZLog("点击付款按钮:",id[1], num[1])
    if JudgeMoneyIsEnough(1, tonumber(num[1]), nil, nil, 50)  then
        local ss = string.format(LocalStrings.MAIL_DOPAY2, num[1])
       MsgBoxManager:showConfirmBox(ss, WndMail,self.doPay)
    end
end

--@brief 点击付款按钮
function WndMail:doPay() 
    WZLog("点击付款按钮22")
    self:createLoading("onReject")
    ProtocolProcessorWndMail:MAIL_MallMailOperate(self.m_tCurOpenMail.mailId, 2)
end

--@brief	写邮件发送按钮按钮调用的函数
--@note	用户名ID , 主题 ,内容不能为空
function WndMail:onSendMailClick()
	WZLog("点击发送按钮")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    --获取邮件用户名
    local recvName = GetElement(self.m_root,"txt_showRec_WndMail",WZUILabelTTF)
	local name = recvName:getText()
    WZLog("name,id",name,self.m_nRecId)
    local recId = nil
    recId = self.t_editMail.recId
	if recId == nil or name == "" then
		MsgBoxManager:showTipBox(LocalStrings.EDITMAILID)
		return
	end

	--获取邮件主题
	local editThemeMail = WZUIEditBox:luaTo(self.m_root:getChildElement("editThemeMail_WndMail"))
	local theme = editThemeMail:getText()
	if theme == "" then
		MsgBoxManager:showTipBox(LocalStrings.EDITMAILTHEME)
		return
	end
    --判断主题长度
    local themeMaxLengh = editThemeMail:getMaxLength() --主题最大长度
    local themeCurLengh = ChineseStringLen(theme)--editThemeMail:getWordCount() --主题当前长度
    if themeCurLengh > themeMaxLengh then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_OUTTHEME)
        return
    end
	--获取邮件邮件内容
	local editContentMail = WZUIEditBox:luaTo(self.m_root:getChildElement("editContentMail_WndMail"))
	local content = editContentMail:getText()
	if content == "" then
		MsgBoxManager:showTipBox(LocalStrings.EDITMAILCONTENT)
		return
	end
    --判断内容长度
    local contentMaxLengh = editThemeMail:getMaxLength() --内容最大长度
    local contentCurLengh = ChineseStringLen(theme)--editThemeMail:getWordCount() --内容当前长度
    if contentCurLengh > contentMaxLengh then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_OUTTEXT)
        return
    end
	WZLog("WndMail:onSendMailClick",name,theme,content,recId)
    --发送邮件请求
    self:createLoading("onSendMailClickSend")
	ProtocolProcessorWndMail:send_MAIL_SendMail(theme, recId, content)
end

--@brief    点击一键领取回调
function WndMail:onGetAllClick()
    WZLog("WndMail:onGetAllClick()")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN) 
    self:createLoading("send_MAIL_GetAllMailReward")
    ProtocolProcessorWndMail:send_MAIL_GetAllMailReward()
end

--@brief    获取所有邮件物品响应
function WndMail:getAllRewardOk(allRewards, mailId)
    WZLog("WndMail:getAllRewardOk()",allRewards)
    self:_setGetAllButton(false)
    if allRewards == nil or allRewards == "" then
        return
    end
    --领取按钮和附件列表清空
    self:setRightDeletButtonState(true)
    --清楚物品
    --local tabCon = GetElement(self.m_root,"tableConReward_WndMail",WZUITableContainer)
    --tabCon:cleanTable()
    
    local id,num = SplitItemString(allRewards) --所有物品ID及数量
    local rewardTable = {}
    for i = 1, #id do
        local bHas = false
        for k, v in pairs(rewardTable) do
            if v.id == id[i] then
                bHas = true
                v.num = v.num + num[i]
                break
            end
        end
        if not bHas then
            local t = {}
            t.id = id[i]
            t.num = num[i]
            table.insert(rewardTable, t)
        end
    end
    local tId = {}
    local tNum = {}
    for k,v in pairs(rewardTable) do
        table.insert(tId,v.id)
        table.insert(tNum,v.num)
    end
    self:closeLoading("send_MAIL_GetAllMailReward")
    local con = GetElement(self.m_root,"tbconRecvSendMailFrame_WndMail",WZUITableContainer)
    for i = 0, mailId:size() -1 do
        for j=1, #self.m_tMailList do
            if self.m_tMailList[j].mailId == mailId:get(i) then
                self.m_tMailList[j].isRead = 8
                local cellElement = con:getCellElement(j - 1)
                if cellElement == nil then break end --
                    local cell = cellElement:getChildElement("CellMailList")
                    local cellTable = WZUIContainer:luaTo(cell):getLuaObjectIndex()
                    cellTable:setIconState(8)
                break
            end
        end
    end
    --更改缓存数据
    local mailListCache = CacheCenter:getMailList()
    if mailListCache == nil then return end
    for i=1,#mailListCache do
        for j = 0, mailId:size()-1 do
            if mailListCache[i].mailId == mailId:get(j) then
                mailListCache[i].isRead = 8
            end
        end
    end
    --GetElement(self.m_root,"conReward_WndMail",WZUIContainer):setVisible(false)--物品栏
    --显示物品
	--处理皮肤转化
	for i=1,#tId do
		local tData = GDatatab_item["id_"..tId[i]]
		WZLog("ssss", tId[i])
		if tData ~= nil and tData.main_type == 20 then
			local show = true
			if COPYSKINDATA ~= nil then  
				local sId = tData.property[1][1]
				for i=1,#COPYSKINDATA do
					if COPYSKINDATA[i].shapeId == sId then
						if COPYSKINDATA[i].remainTime == -1 then
							show = false
						end
					end
				end
			end
			WZLog("NOTRECYCLEIDS_0", show)
			
			if show == true and (not utilsValueInTable(tData.id, NOTRECYCLESKINIDS)) then
				table.insert(NOTRECYCLESKINIDS, tData.id)
			end
		end
	end
    WndRewardShow:showById(tId,tNum)
    self.m_nOpenTag = -1
    self:_setOpenTag(1)
    pushEquipInList()
end

--@brief    点击cell时调用
--@author   hyq
function WndMail:onCellClick(tCellData,tCell)
    WZLog("wndMail:onCellClick(tCellElement,nMailId)",tCellData.mailId)
    if self.m_tCurOpenMail.mailId == tCellData.mailId then
        return
    end
    self.m_tCurOpenMail = tCellData
    self.m_tCurOpenCell:setChoiceState(false)
    self.m_tCurOpenCell = tCell
    -- end
    self:openMail(tCellData)
end

--@brief	打开邮件时调用函数
--@param	tOpenMail:要打开的邮件
--@note     向读邮件界面传名称主题，邮件ID,当前节点,当前页数
--@author   hyq
function WndMail:openMail(tOpenMail)
    WZLog("WndMail:openMail")
    --如果是编写的邮件，则退出
    if tOpenMail.mailType == self.n_editMailId then
        self:_initWriteMailInfo()
        return
    end
    --如果是打开过的邮件，则自己显示邮件内容，否则等服务器响应
    if tOpenMail.isRead ~= 0 and tOpenMail.isRead ~= 8 then
        self:openMailCallBack(tOpenMail.mailId)
    else
        --创建加载框
        self:createLoading("openMailSend")
        --发送协议获得邮件内容
        ProtocolProcessorWndMail:send_MAIL_GetMailContent(tOpenMail.mailId)
    end
end

--@brief	获得邮件内容协议回调函数
--@author   hyq
function WndMail:openMailCallBack(id, state)
    --关闭加载框
    self:closeLoading("openMailRec")
    if self.m_tCurOpenMail.mailId ~= id then
       WZLog("openMailCallBack the mailId is error")
    end
    --显示邮件信息容器
    GetElement(self.m_root,"conMailContentBk1_WndMail",WZUIContainer):setVisible(true)--显示容器
    GetElement(self.m_root,"conMailContentBk2_WndMail",WZUIContainer):setVisible(false)--写信容器
    --不显示发送按钮
    GetElement(self.m_root,"btnSend_WndMail",WZUIButton):setVisible(false)
    --显示邮件内容
    local theme = self.m_tCurOpenMail.theme
    local sendTime = self.m_tCurOpenMail.time
    local content = self.m_tCurOpenMail.content
    local attachments = self.m_tCurOpenMail.attachments
    local sender = self.m_tCurOpenMail.senderName
    WZLog("openCalllBack:", state,theme, sendTime, content, attachments)
    local timeNum = string.sub(sendTime,12, 16)
	GetElement(self.m_root,"txtTheme1_WndMail",WZUILabelTTF):setText(""..theme)
	GetElement(self.m_root,"txtTime1_WndMail",WZUILabelTTF):setText(timeNum)
    --更新邮件图标并改变邮件状态
    if state ~= nil then
        self.m_tCurOpenMail.isRead = state
    end
    local con = GetElement(self.m_root,"tbconRecvSendMailFrame_WndMail",WZUITableContainer)
    if self.m_nOpenTag == 1 then
        self.m_tCurOpenCell:setIconState(self.m_tCurOpenMail.isRead) 
        --GetElement(cellElement,"imgIsNew_CellMailList",WZUIImage):setVisible(false)
    end
    WZLog("self.m_tCurOpenMail.sendId",self.m_tCurOpenMail.sendId)
    if  self.m_tCurOpenMail.mailType == 3 then
        GetElement(self.m_root,"mailContent_WndMail",WZUILabelTTF):setText(content)
        self:_upMoveContainerLayer()
        GetElement(self.m_root,"txtSender1_WndMail",WZUILabelTTF):setText(""..sender)
        self:openShopMail()
        return
    end
    local hasAnnex = false
	local bDete = false
    if  self.m_tCurOpenMail.sendId < 10 then    --1系统邮件：1普通，2附件
		GetElement(self.m_root,"imgNameType_WndMail",WZUIImage):setFile("ui/mail/common_icon_GMtb.png")
        GetElement(self.m_root,"txtSender1_WndMail",WZUILabelTTF):setText(LocalStrings.CHAT_SYSTEM)
        GetElement(self.m_root,"btnReply_WndMail",WZUIButton):setVisible(false)
        GetElement(self.m_root,"conReward_WndMail",WZUIContainer):setVisible(false)--物品栏
		WZLog("openCalllBack:", attachments, self.m_tCurOpenMail.attachment)
        if attachments ~= nil and attachments ~= "" then --有附件
            if self.m_tCurOpenMail.attachment == 1 then
                local id,num = SplitItemString(attachments)
                WZLog("显示领取按钮",attachments)
                self:showAnnex(id,num)
				hasAnnex = true
                if self.m_tCurOpenMail.isRead ~= 2 then
					bDete = true
                end
            else
                local tabCon = GetElement(self.m_root,"tableConReward_WndMail",WZUITableContainer)
                tabCon:cleanTable()
            end
        end
    else
		GetElement(self.m_root,"imgNameType_WndMail",WZUIImage):setFile("ui/mail/common_icon_yjptwj.png")
        GetElement(self.m_root,"txtSender1_WndMail",WZUILabelTTF):setText(""..sender)
        if self.m_tCurOpenMail.sendId ~= CacheCenter:getPlayerInfo().id then --2普通收件   
            GetElement(self.m_root,"btnReply_WndMail",WZUIButton):setVisible(true)
        else    --3发件
            GetElement(self.m_root,"btnReply_WndMail",WZUIButton):setVisible(false)--回复按钮
        end
    end
    if  self.m_tCurOpenMail.mailType == 2 then
        GetElement(self.m_root,"txtSender1_WndMail",WZUILabelTTF):setText(""..self.m_tCurOpenMail.recvName)
    end
    GetElement(self.m_root,"conReward_WndMail",WZUIContainer):setVisible(hasAnnex)
    --右边的删除按钮
    self:setRightDeletButtonState(not bDete)
    WZLog("hhhhhh:", hasAnnex)
    if self.m_nOpenTag == 1 then
        if hasAnnex then
            GetElement(self.m_root, "scrollNotice_WndMail", WZUIMoveContainer):setContentSize(GlobalMethod:CCSize(355,165))
        else
            GetElement(self.m_root, "scrollNotice_WndMail", WZUIMoveContainer):setContentSize(GlobalMethod:CCSize(355,245))
        end
    end
    GetElement(self.m_root,"mailContent_WndMail",WZUILabelTTF):setText(content)
    self:_upMoveContainerLayer()
end

--购买商品邮件的修改
function WndMail:openShopMail()
    WZLog("WndMail:openShopMail:",self.m_tCurOpenMail.cost)
    local state =  self.m_tCurOpenMail.isRead
    local attachments = self.m_tCurOpenMail.attachments
    if attachments ~= nil and attachments ~= "" then --有附件
        local id,num = SplitItemString(attachments) 
        self:showAnnex(id,num)  
    else
        local tabCon = GetElement(self.m_root,"tableConReward_WndMail",WZUITableContainer)
        tabCon:cleanTable()
    end
    GetElement(self.m_root,"conReward_WndMail",WZUIContainer):setVisible(true)
    WZLog("WndMail:openShopMail():", state)
    GetElement(self.m_root,"conPayNum_WndMail",WZUIContainer):setVisible(state>= 4)
    GetElement(self.m_root,"conNeedPay_WndMail",WZUIContainer):setVisible(state== 5)
    if state == 4 or state == 6 then
        if state == 4 then
            GetElement(self.m_root,"txtNoNeedPay_WndMail", WZUILabelTTF):setText(LocalStrings.ACTIVE_GET)
        else
            GetElement(self.m_root,"txtNoNeedPay_WndMail", WZUILabelTTF):setText(LocalStrings.MAIL_HASPAY)
        end
        GetElement(self.m_root,"conNoNeedPay_WndMail",WZUIContainer):setVisible(true)
    else
        GetElement(self.m_root,"conNoNeedPay_WndMail",WZUIContainer):setVisible(false)
    end
    GetElement(self.m_root,"btnReject_WndMail",WZUIButton):setVisible(state==5)      --拒绝
    GetElement(self.m_root,"btnPay_WndMail",WZUIButton):setVisible(state== 5)        --付款
    GetElement(self.m_root,"btnGet_WndMail",WZUIButton):setVisible(state==3)        --领取
    if state == 3 or state == 5 then
        GetElement(self.m_root,"btnDeleteMail_WndMail",WZUIButton):setVisible(false)
    else
        GetElement(self.m_root,"btnDeleteMail_WndMail",WZUIButton):setVisible(true)
    end
    if state == 5 then
        local id,num = SplitItemString(self.m_tCurOpenMail.cost)
        local moneyIcon = {"ui/common/common_icon_zuanshi.png","ui/common/common_icon_jinbi.png"}
        GetElement(self.m_root,"imgMoneyType_WndMail",WZUIImage):setFile(moneyIcon[tonumber(id[1])])
        GetElement(self.m_root,"txtPayNum_WndMail",WZUILabelTTF):setText(num[1])
    end
end


--@brief    打开好友列表选择收件人
--@author   hyq
function WndMail:onOpenFriendsList()
    WZLog("打开好友列表选择收件人")
    WndFriendList:showInterface(4,self,self.onSelectFriendBackFun)
end

function WndMail:onSelectFriendBackFun(tFriendList)
    WZLog("WndMail:onSelectFriendBackFun",tFriendList.id,tFriendList.name)
    self.t_editMail.recId = tFriendList.id
    self.t_editMail.recName = tFriendList.name
    GetElement(self.m_root,"txt_showRec_WndMail",WZUILabelTTF):setText(self.t_editMail.recName)
end


--@brief	显示附件
function WndMail:showAnnex(id,num)
	local tabCon = GetElement(self.m_root,"tableConReward_WndMail",WZUITableContainer)
	tabCon:cleanTable()
    local nums = #id
    local columnCount = tabCon:getColumnCount()
    WZLog("nums,columnCount====",nums,columnCount)
    if nums <= 0 then return end
    --为了从右边开始排
    --local tableNum = math.max(0, 4-nums)
	for i=1,nums do
        WZLog("di====",i,id[i],num[i])
		local data = GDatatab_item["id_"..id[i]]
        local itemType = data.main_type == 5 and 14 or 4
        local xishu = itemType == 14 and 86400 or 1
	    local itemInfo = {name=data.name,icon=data.icon,lastTime=num[i]*xishu,customizeLastTime=num[i]*xishu,quality=data.quality,basicInfo=data} 
	    local celElement,tLuaObj = CellGoodItem:createElement()
        if celElement ~= nil then 
	     	celElement = WZUIContainer:luaTo(celElement)
            tLuaObj:setItemClickFun(self,self.clickCellGoodItem)
			celElement:setScale(0.9)
	     	tLuaObj:setCellGoodItem(itemInfo,itemType)
            celElement:setTag(i-1)
            tabCon:setCellElement(i-1,0,celElement)
            --tabCon:setCellElement(tableNum + i-1,0,celElement)
        end
	end 
end

--@brief  点击附件是的响应时间
--@brief    装备被点击
function WndMail:clickCellGoodItem(element,tag,tData)
    WZLog("WndMail:clickCellGoodItem",tag, tData,Serialize(tData))
    --WndItemInfo:onCloseClick()
    local elementMail = GetElement(self.m_root, "conMain_WndMail", WZUIContainer)
    WndItemInfo:showInfo(element.m_root,elementMail,1,tData,false)
end

--@brief	点击编辑按钮时调用函数
function WndMail:onEditMailClick()
	WZLog("点击编辑按钮",#self.m_tMailList)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_root == nil then
		return
	end

    if  self.m_tMailList == nil or #self.m_tMailList == 0 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_NOLIST)
       return
    end
    if #self.m_tMailList == 1 and self.m_tMailList[1].mailType == self.n_editMailId then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_ISWRITE)
        return
    end
    --设置选中数量
    self:selCheckNumCounter(2)
    --显示邮件图标或复选框
    self:_isMailIconVisible(true)
    --设置
    self:setSeletbutton(false)
    GetElement(self.m_root, "ConSelDelComp_WndMail", WZUIContainer):setVisible(true)
    GetElement(self.m_root, "btnEditMail_WndMail", WZUIButton):setVisible(false)
    GetElement(self.m_root,"conGetAll_WndMail",WZUIContainer):setVisible(false)
end

--@brief	点击完成按钮时调用函数
--@note	隐藏checkbox，初始化全选,删除,返回 三个按钮并显示编辑按钮
function WndMail:onCompleteMailClick(element)
	WZLog("点击完成按钮")
    if element ~= nil then
	   SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    end
    --设置选中数量
    self:selCheckNumCounter(2)
    --显示邮件图标或复选框
    self:_isMailIconVisible(false)
    GetElement(self.m_root, "ConSelDelComp_WndMail", WZUIContainer):setVisible(false)
    GetElement(self.m_root, "btnEditMail_WndMail", WZUIButton):setVisible(true)
    GetElement(self.m_root,"conGetAll_WndMail",WZUIContainer):setVisible(true)
end

--@brief    统计被选中的邮件数量
--@param    element : checkbox节点
--@author   hyq
--@param    nTag:0点击复选框1、1全选n、2编辑0/完成0/删除（选中）0、3删除（打开，是否有选中）1
function WndMail:selCheckNumCounter(nTag,state)
    WZLog("统计被选中的邮件数量WndMail:selCheckNumCounter",nTag) 
    state = state or 0
    nTag = nTag or 0
    local mailNum = #self.m_tMailList
    if nTag == 0 and element == nil then
        WZLog("nTag == 0 and element == nil")
        return
    end
    if nTag == 0 then --点击复选框
        if state == 1 then
            self.m_nCountSelMailNum = self.m_nCountSelMailNum + 1
        else
            self.m_nCountSelMailNum = self.m_nCountSelMailNum - 1
        end 
    elseif nTag == 1 then --全选
        self.m_nCountSelMailNum = mailNum  
    elseif nTag == 2 then --编辑或完成或删除（选中的邮件），删除要在响应函数调用
        self.m_nCountSelMailNum = 0
    elseif nTag == 3 then --删除（当前打开的邮件），需判断当前打开的邮件是否被选中
        self.m_nCountSelMailNum = self.m_nCountSelMailNum - 1 --
    end
    --设置删除是否可按
    self:setDeletButtonState(self.m_nCountSelMailNum > 0)
end

--@brief 设置删除按钮状态
--@param bool是否删除
function WndMail:setDeletButtonState(bool)
    WZLog("WndMail:setDeletButtonState", bool)
    GetElement(self.m_root,"btnDelSelMail_WndMail",WZUIButton):setVisible(bool)
    GetElement(self.m_root,"btnCompleteMail_WndMail",WZUIButton):setVisible(not bool)
end


--@brief	点击全部选择按钮调用函数
--@author   hyq
function WndMail:onSelectAllMailClick()
	WZLog("点击全部选择按钮")
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	--Table容器
	local tbconRecvMailFrame = GetElement(self.m_root, "tbconRecvSendMailFrame_WndMail", WZUITableContainer)
    local tag = 1
    if self.m_nCountSelMailNum == #self.m_tMailList then
        tag = 2
    end
    --显示邮件图标或复选框
    for i , v in pairs(self.m_tMailList) do
        if self.m_tMailList[i].mailType ~= self.n_editMailId then
            local tCell = tbconRecvMailFrame:getCellElement(i-1)
            if tCell ~= nil then
                local cell = tCell:getChildElement("CellMailList")
                local cellTable = WZUIContainer:luaTo(cell):getLuaObjectIndex()
                local index = tag == 1 and 1 or 0
                cellTable:_setCheckBoxStatic(index)
            end
        end
    end
    self:setSeletbutton(tag==1)
    self:selCheckNumCounter(tag,nil)
end

--@brief    设置全选按钮的状态
function WndMail:setSeletbutton(bool)
    GetElement(self.m_root,"imgAll_WndMail",WZUIImage):setVisible(bool)
    GetElement(self.m_root,"imgAll_yes_WndMail",WZUIImage):setVisible(bool)
end

--@brief    删除选中邮件按钮回调
--@author   hyq
function WndMail:onDeletMailCallback()
    WZLog("点击删除选中邮件按钮onDeletMailCallback")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local ids = WZLuaVector_int_:create()  --用于保存被选中的邮件id
    local tbconRecvMailFrame = GetElement(self.m_root, "tbconRecvSendMailFrame_WndMail", WZUITableContainer) 
    --遍历邮件列表
    for i , v in pairs(self.m_tMailList) do
        local tCell = tbconRecvMailFrame:getCellElement(i-1)
        if tCell ~= nil then
            local cell = tCell:getChildElement("CellMailList")
            local cellTable = WZUIContainer:luaTo(cell):getLuaObjectIndex() 
            local selTag = cellTable:getCheckState()
            WZLog("selTag====",i,selTag)
            if selTag == 1 then --选中
                 --如果删除邮件中又附件择不可以删除
                if self.m_tMailList[i].attachment == 1 and self.m_tMailList[i].isRead ~= 2 and self.m_tMailList[i].isRead ~= 8 then
                    MsgBoxManager:showTipBox(LocalStrings.MAIL_GETANNEX)
                    self:_setGetAllButton(true)
                    return
                end
                if self.m_tMailList[i].mailType ~= 99 then
                    ids:push(self.m_tMailList[i].mailId)
                end
            end
        end
    end
    self.m_nDeleteMailType = 1
    self:createLoading("deleteSelMailSend")
    ProtocolProcessorWndMail:send_MAIL_DeleteMail(ids)
end

--@brief	回复邮件
--@author   hyq
function WndMail:onReplyMail(element)
	WZLog("WndMail:onReplyMail")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    GetElement(self.m_root, "selRecvMailOfBoxGroup_WndMail", WZUICheckBox):setCheckIndex(0)
    GetElement(self.m_root, "selSendMailOfBoxGroup_WndMail", WZUICheckBox):setCheckIndex(1)
    --onRecvMailGroupClick
    --增加一条编写的邮件
    --self:_addOneEditMail(self.m_nRecId,self.m_sSenderName)
    self.t_editMail.recId = self.m_tCurOpenMail.sendId
    self.t_editMail.recName = self.m_tCurOpenMail.senderName
    self:_addOneEditMail()
    self:_setOpenTag(2)
    --初始化写邮件
    --self:_createMailMenuList()
end
--@brief	领取附件
function WndMail:onGetAnnex(element)
    WZLog("WndMail:onGetAnnex(element)")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local id,num = SplitItemString(self.m_tCurOpenMail.attachments) 
    -- if #id > CacheCenter:getRemainAmount() then
    --     MsgBoxManager:showTipBox(LocalStrings.MAIL_FULLBAG)
    --     return
    -- end
    self:createLoading("onGetAnnex")
    if self.m_tCurOpenMail.mailType == 3 then
        ProtocolProcessorWndMail:MAIL_MallMailOperate(self.m_tCurOpenMail.mailId, 1)
    else
        ProtocolProcessorWndMail:send_MAIL_GetMailReward(self.m_tCurOpenMail.mailId)
    end
end

--@brief 一键获取的领取状态设置
function WndMail:_setGetAllButton(bool)
    WZLog("WndMail:_setGetAllButton", bool)
    GetElement(self.m_root,"btnGetAll_WndMail",WZUIButton):setVisible(bool)
end

--@brief    领取附件成功
function WndMail:getAwardOk()
    self:closeLoading("onGetAnnexOk")
    --领取按钮
    self:setRightDeletButtonState(true)
    --清楚物品
    --local tabCon = GetElement(self.m_root,"tableConReward_WndMail",WZUITableContainer)
    --tabCon:cleanTable()
    --更新邮件图标并改变邮件状态
    self.m_tCurOpenCell:setIconState(2)
    --更改缓存数据
    local mailListCache = CacheCenter:getMailList()
    if mailListCache == nil then return end
    for i=1,#mailListCache do
        if mailListCache[i].mailId == self.m_tCurOpenMail.mailId then
            mailListCache[i].isRead = 2
            break
        end
    end
    self.m_tCurOpenMail.isRead = 2
     --一键领取按钮
    local hasNewMail = false
    for i=1,#mailListCache do
        local readTag = mailListCache[i].isRead
        if mailListCache[i].attachment == 1 and readTag ~= 2 then
            hasNewMail = true
            break
        end
    end
	--GetElement(self.m_root,"conReward_WndMail",WZUIContainer):setVisible(false)--物品栏
    self:_setGetAllButton(hasNewMail)
end

--@brief	写邮件
function WndMail:onWriteMail()
	WZLog("WndMail:onWriteMail")
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    local conWriteMail = GetElement(self.m_root,"conMailContentBk2_WndMail",WZUIContainer)
    if conWriteMail:isVisible() then
        WZLog("is writting mail")
        return
    end
    self.m_nRecId = nil
    --增加一封写邮件
    self:_addOneEditMail()
    --初始化写邮件
    self:_createMailMenuList()
    --先增加了邮件，择将打开邮件的id设置为self.n_editMailId
end

--@brief     点击删除按钮调用函数
--@note     删除所有被选择的checkbox 并不显示checkBox,初始化全选,删除,返回 三个按钮
function WndMail:onDelMail(element)
	WZLog("点击删除按钮",self.m_nCurOpenMailId)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
    if self.m_tCurOpenMail.mailType == 3 then
        -- local ids = WZLuaVector_int_:create()
        -- ids:push(self.m_tCurOpenMail.mailId)
        self.m_nDeleteMailType = 0
         --删除邮件请求
        ProtocolProcessorWndMail:send_MAIL_DeleteMail2(self.m_tCurOpenMail.mailId )
        --创建加载框
        self:createLoading("deleteOpenMailSend")
        return
    end
    --删除正在写的邮件
    local isVisible = GetElement(self.m_root,"conMailContentBk2_WndMail",WZUIContainer):isVisible()
    WZLog("isVisible===",isVisible)
    if isVisible then
        --删除缓存数据
        local mailListCache = CacheCenter:getMailList()
        for i=1,#mailListCache do
            if mailListCache[i].mailType == self.n_editMailId then
               table.remove(mailListCache,i)
               break
            end
        end
        for j=1,#self.m_tMailList do
            if self.m_tMailList[j].mailType == self.n_editMailId then
                table.remove(self.m_tMailList,j)
                break
            end
        end
        --设置写信面板不可见
        GetElement(self.m_root,"conMailContentBk2_WndMail",WZUIContainer):setVisible(false)
        GetElement(self.m_root,"conMailContentBk1_WndMail",WZUIContainer):setVisible(true)

        self.m_nRecId = nil
        self.m_tCurOpenMail = nil
        --创建邮件列表
        self:_createMailMenuList()
        return
    end
    --如果删除邮件中又附件择不可以删除
    if self.m_tCurOpenMail.mailType ~= 3 and self.m_tCurOpenMail.attachment == 1 and self.m_tCurOpenMail.isRead ~= 2 then
        MsgBoxManager:showTipBox(LocalStrings.MAIL_GETANNEX)
        return
    end
    if self.m_tCurOpenMail == nil then
       return
    end

	local ids = WZLuaVector_int_:create()
	ids:push(self.m_tCurOpenMail.mailId)
    self.m_nDeleteMailType = 0
    --删除邮件请求
	ProtocolProcessorWndMail:send_MAIL_DeleteMail(ids )
    --创建加载框
    self:createLoading("deleteOpenMailSend")
end

--@brief   点击好友列表回调函数
--@note   显示好友列表界面
function WndMail:onShowFriendList()
	WZLog("点击好友列表")
	if self.m_root == nil then
		return
	end
	ProtocolProcessorWndMail:unregAll()
	WndAddNearFriend:showInterface()
	WndAddNearFriend:setBackFun(self,self.onNearFriendBackFun,self.onCloseFun)
	self.m_tNearFriendList = nil 	
end

--@brief	主题编辑结束调用
function WndMail:onEditEnd(element)
    WZLog("WndMail:onEditEnd(element)")
	checkEditLenovoWord(element)
end

--@brief	邮件内容编辑结束调用
function WndMail:onInfoEditEnd(element)
    WZLog("WndMail:onInfoEditEnd(element)")
	checkEditLenovoWord(element)
end

--@brief   创建加载框
function WndMail:createLoading(strTag)
    WZLog("WndMail:createLoading type:",strTag)
	self.m_nLoadingId = MsgBoxManager:showLoadingBox()
end

--@brief   关闭加载框
function WndMail:closeLoading(strTag)
    WZLog("WndMail:closeLoading type:",strTag)
	local nId = self.m_nLoadingId
	MsgBoxManager:stopLoadingBoxByMsgId(nId)
end

--@brief   选择好友关闭回调
function WndMail:onCloseFun()
	WZLog("WndMail:onCloseFun()::::")
	ProtocolProcessorWndMail:regAll()
end

--@brief   选择好友关闭回调函数
function WndMail:onNearFriendBackFun(tFriend,mailType)
	WZLog("选择好友关闭回调函数:",mailType)
	self.m_nMailType = mailType
	self.m_nNearFriendId = tFriend.id
	self:_setRecvName(tFriend.name)
end

--@brief    服务器响应时调用
--@param    nTag:0删除邮件，1发送邮件
--@author   hyq
function WndMail:getInfoFromServer(nTag)
    WZLog("WndMail:getInfoFromServer()",nTag)
    if nTag == 0 then
        --关闭加载框
        self:closeLoading("deleteMailRec")
        self.m_bDelMailTypeChangeEnabled = true
        WZLog("self.m_nDeleteMailType====",self.m_nDeleteMailType)
        self:_deletMailFromList(self.m_nDeleteMailType)
        
    elseif nTag == 1 then
        --关闭加载框
        self:closeLoading("onSendMailClickRec")
        local mailListCache = CacheCenter:getMailList()
        for i=1,#mailListCache do
            if mailListCache[i].mailType == self.n_editMailId then
                table.remove(mailListCache,i)
                break
            end
        end
        for j=1,#self.m_tMailList do
            if self.m_tMailList[j].mailType == self.n_editMailId then
                table.remove(self.m_tMailList,j)
                self.m_tCurOpenMail = nil
                break
            end
        end
        if self.m_nOpenTag == 2 then
            --创建邮件列表
            self:_createMailMenuList()
            --显示邮件图标或复选框
            self:_isMailIconVisible(self.b_isEdit)
        end
    end

end


-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------
--@brief    初始化邮件系统
--@param    ntag:1点击打开邮件，2通过好友打开邮件
--@author   hyq
function WndMail:_initMailSysInfo(ntag)
    WZLog("WndMail:_initMailSysInfo(ntag)",ntag)
    if self.m_root == nil then
        return
    end
    local tag = ntag or 1
    if tag == 1 then  --选中收件箱
    elseif tag == 2 then  --选中发件箱 
        --插入一封邮件
        self:_addOneEditMail()
    elseif tag == 3 then  --选中商品箱     
    end
    self:_setWndMailBtnVisible(tag)
    self:_createMailMenuList()
end

--@brief    是否显示邮件图标或复选框
--@param    bMailIconVisible:bool，true显示邮件图标，false显示复选框
--@author   hyq
function WndMail:_isMailIconVisible(bMailIconVisible)
    WZLog("显示邮件图标或复选框",bMailIconVisible)
    self.b_isEdit = bMailIconVisible
    if self.m_root == nil or self.m_tMailList == nil or #self.m_tMailList == 0 then
        return
    end
    local tbconRecvMailFrame = GetElement(self.m_root, "tbconRecvSendMailFrame_WndMail", WZUITableContainer) 
    --遍历邮件列表
    for i , v in pairs(self.m_tMailList) do
        if self.m_tMailList[i].mailType ~= self.n_editMailId then
            local tCell = tbconRecvMailFrame:getCellElement(i-1)
            if tCell ~= nil then
                local cell = tCell:getChildElement("CellMailList")
                local cellTable = WZUIContainer:luaTo(cell):getLuaObjectIndex()
                cellTable:setCheckState(not bMailIconVisible)
                -- local mailIcon = GetElement(tCell, "imgMailIcon_CellMaiList", WZUIImage)
                -- local mailCheckBox = GetElement(tCell, "conCheckBoxMail_CellMaiList", WZUIContainer)
                -- if mailIcon == nil or mailCheckBox == nil then return end
                -- mailIcon:setVisible(not bMailIconVisible)
                -- mailCheckBox:setVisible(bMailIconVisible)
                -- GetElement(tCell,"conGou_CellMailList",WZUIContainer):setVisible(false)
                -- GetElement(tCell,"conHasGet_CellMaiList",WZUIContainer):setVisible(not bMailIconVisible)
            end
        end
    end
end

--@brief    初始化写信收件人、主题
--author    hyq
function WndMail:_initWriteMailInfo(mailRecer,mailTheme,mailContent)
    WZLog("WndMail:initWriteMailInfo",mailRecer,mailTheme,mailContent)
    --发送、删除按钮可见
    GetElement(self.m_root,"btnDeleteMail_WndMail",WZUIButton):setVisible(true)  --删除
    GetElement(self.m_root,"btnSend_WndMail",WZUIButton):setVisible(true)        --发送
    --写信面板可见
    GetElement(self.m_root,"conMailContentBk1_WndMail",WZUIContainer):setVisible(false)
    GetElement(self.m_root,"conMailContentBk2_WndMail",WZUIContainer):setVisible(true)
    --选择收件人可按
    GetElement(self.m_root,"btn_openFriendsList_WndMail",WZUIButton):setTouchEnable(true)
    local recLabel = GetElement(self.m_root,"txt_showRec_WndMail",WZUILabelTTF)
    recLabel:setText("")
    recLabel:setVisible(true)
    if self.t_editMail.recName ~= nil then
        recLabel:setText(self.t_editMail.recName)
    end
    --初始化主题
    local themeLabel = GetElement(self.m_root,"editThemeMail_WndMail",WZUIEditBox)
    themeLabel:setText("")
    if self.t_editMail.mailTheme ~= nil then
        themeLabel:setText(self.t_editMail.mailTheme)
    end
    --清空邮件内容
    local contentLabel = GetElement(self.m_root,"editContentMail_WndMail",WZUIEditBox)
    contentLabel:setText("")
    if self.t_editMail.content ~= nil then
        contentLabel:setText(self.t_editMail.content)
    end
    -- if ProjConfig.LANGUAGE == "pt" then
    --     WZLog("--WndMail:themeLabel--")
    --     contentLabel:setScale(0.8)
    -- end
end

--@brief    增加一条编写的邮件
--@note     写邮件，回复，发邮件是调用
function WndMail:_addOneEditMail()
    WZLog("WndMail:_addOneEditMail")
    local mailListCache = CacheCenter:getMailList()
    if mailListCache == nil then
        WZLog("mailListCache == nil")
        CacheCenter:addOneEditMailToCache()
        mailListCache = CacheCenter:getMailList()
    else
        --如果存在编写邮件将其删除
        for i=1,#mailListCache do
            if mailListCache[i].mailType == self.n_editMailId then
                table.remove(mailListCache,i)
                break
            end
        end
    end
    local temp = {}
    temp.time = os.date("%Y-%m-%d %H:%M:%S") --获取系统日期及时间
    WZLog("temp.time===",temp.time)
    temp.mailId = self.n_editMailId
    temp.recName = self.t_editMail.recName or ""--收件人姓名
    temp.theme = self.t_editMail.mailTheme or ""--邮件主题
    temp.content = "" --邮件类容
    temp.mailType = self.n_editMailId--邮件类型
    temp.recId = self.t_editMail.recId--收件人id
    temp.sendId = CacheCenter:getPlayerInfo().id--发送者id
    table.insert(mailListCache,1,temp)--加入到缓存
end

--@brief 获取当前页的邮件
--@param checkType:当前邮件选择状态
function WndMail:_getPageList()
    local mailList = CacheCenter:getMailList()
    if mailList == nil then
        return
    end
    --遍历收件箱和发件箱的邮件
    local playerId = CacheCenter:getPlayerInfo().id
    local tMialList = {}
    for i=1,#mailList do
        if self.m_nOpenTag == 1 then
            if mailList[i].sendId ~=  playerId and not self:_isShopMail(mailList[i]) then
                mailList[i].mailType = 1
                table.insert(tMialList,mailList[i])
            end
        elseif  self.m_nOpenTag == 2  then 
            if mailList[i].sendId == playerId and not self:_isShopMail(mailList[i])then
                if mailList[i].mailId ~= self.n_editMailId then
                    mailList[i].mailType = 2
                end
                table.insert(tMialList,mailList[i])
            end
        elseif  self.m_nOpenTag == 3  then 
            if self:_isShopMail(mailList[i]) then
                mailList[i].mailType = 3
                table.insert(tMialList,mailList[i])
            end
        end
    end
    table.sort(tMialList,_sortMailList)
    --根据当前页数选取邮件
    local m_tMailList = {}
    self.n_mailNum = #tMialList
    local maxNum = #tMialList < self.n_curPage * NUMBER_FRIEND_PAGE and  #tMialList or self.n_curPage * NUMBER_FRIEND_PAGE--每页显示20封邮件
    local starNum = (self.n_curPage -1) * NUMBER_FRIEND_PAGE +1
    for i = starNum, maxNum do
        table.insert(m_tMailList,tMialList[i])
    end
    return m_tMailList
end

--@brief 判断是否是商务箱
function WndMail:_isShopMail(tMailData)
    if tMailData ~= nil and tMailData.headId ~= nil and tMailData.headId > 0 then
        WZLog("tMailData.headId:", tMailData.headId)
        return true
    else
        return false
    end
end

--@brief   创建函数
--@note    创建邮件列表
function WndMail:_createMailMenuList()
    WZLog("_createMailMenuList()")
    --清空列表
    self:_clearMailList()
    --更新邮件列表table
    self.m_tMailList = self:_getPageList()
	local tbconRecvMailFrame = GetElement(self.m_root, "tbconRecvSendMailFrame_WndMail", WZUITableContainer)
    --创建邮件列表
    self:_setBottomOrTopElement(tbconRecvMailFrame)
    if self.m_tMailList == nil or #self.m_tMailList < 1 then
         --设置写信面板不可见
        GetElement(self.m_root,"conMailContentBk2_WndMail",WZUIContainer):setVisible(false)
        GetElement(self.m_root,"conMailContentBk1_WndMail",WZUIContainer):setVisible(false)
        ShowPanelNullTip(tbconRecvMailFrame)
        return
    end
    removeShowPanelNullTip(tbconRecvMailFrame) 
    DelayCallFunction(self._createMailMenuList2, self, 0.01,tbconRecvMailFrame)
end

--@brief   创建函数
--@note    创建邮件列表
function WndMail:_createMailMenuList2(tbconRecvMailFrame)
    WZLog("_createMailMenuList2()")
    local curMail_root = nil
    --邮件最大显示数量，如果是商品箱则显示30
    local mailMaxNum = self.m_nOpenTag == 3 and 30 or NUMBER_FRIEND_PAGE
    local maxNum = #self.m_tMailList < mailMaxNum and #self.m_tMailList or mailMaxNum
    WZLog("WndMail:_createMailMenuList2:",maxNum)
    for i = 1 , maxNum do
        --邮件下标索引自加
        local celElement , tCell = CellMailList:createElement()
        celElement:setTag(i-1)
        tbconRecvMailFrame:setCellElement(celElement)
        if i == 1 then
            self.m_tCurOpenMail = self.m_tMailList[i]
            self.m_tCurOpenCell = tCell
            WZLog("self.m_tCurOpenMail ~= nil",i) 
            tCell:setMailCellAllElement(self.m_tMailList[i],true)
        else
            tCell:setMailCellAllElement(self.m_tMailList[i])
        end
    end
    
    if self.turnPage == "down" then
        WZLog("执行到这里:::1",tbconRecvMailFrame:getMinPosition().y)
        tbconRecvMailFrame:UpdateInsidePosition()
        tbconRecvMailFrame:getMoveElement():setPositionY(tbconRecvMailFrame:getMinPosition().y)         
    end
    if self.turnPage == "up" then
        WZLog("执行到这里:::2",tbconRecvMailFrame:getMaxPosition().y)
        tbconRecvMailFrame:UpdateInsidePosition()
        tbconRecvMailFrame:getMoveElement():setPositionY(tbconRecvMailFrame:getMaxPosition().y) 
    end
    tbconRecvMailFrame:updateTopDownPosition()
    
    self:_isMailIconVisible(self.b_isEdit)
    self:openMail(self.m_tCurOpenMail)
end

--设置邮件table是否可拉
function WndMail:_setBottomOrTopElement(tbconRecvMailFrame)
    --上下拉触发分页
    if self:_getUpPage() then
        --Begin:翻页效果2
        tbconRecvMailFrame:setEnableDropRefresh(false)
        local ttf = WZUILabelTTF:create()
        ttf:setText(LocalStrings.FRONT_PAGE)
        ttf:setFontSize(22)
        ttf:setUseOriginSize(true)
        ttf:setColor(GlobalMethod:ccc3(255,236,193))
        tbconRecvMailFrame:setTopNotice(LocalStrings.FRONT_PAGE, LocalStrings.FRONT_PAGE_TIP)
        tbconRecvMailFrame:setTopElementFunction("_getMailUpPage")--设置TopElement的Lua回调函数
        tbconRecvMailFrame:setEnableTopElement(true)--设置TopElement是否可用
        tbconRecvMailFrame:setVisibleHeight(30)
        tbconRecvMailFrame:setHideTopElement(false)--设置topElement是否隐藏
        tbconRecvMailFrame:setTopElement(ttf)--设置容器的TopElement对象
        --tbconRecvMailFrame:slideToPosition(0,0,0,0,nil)
    else
        WZLog("TOhideTop")
        tbconRecvMailFrame:setEnableDropRefresh(false)
        tbconRecvMailFrame:setEnableTopElement(false)
        tbconRecvMailFrame:setHideTopElement(true)
    end
    if self:_getDownPage() then
        --Begin:翻页效果2
        tbconRecvMailFrame:setEnableDagLoading(false)
        local ttf = WZUILabelTTF:create()
        ttf:setText(LocalStrings.NEXT_PAGE)
        ttf:setFontSize(22)
        ttf:setColor(GlobalMethod:ccc3(255,236,193))
        ttf:setUseOriginSize(true)
        tbconRecvMailFrame:setBottomNotice(LocalStrings.NEXT_PAGE, LocalStrings.NEXT_PAGE_TIP)
        tbconRecvMailFrame:setBottomElementFunction("_getMailDownPage")--设置BottomElement的Lua回调函数
        tbconRecvMailFrame:setVisibleHeight(30)
        tbconRecvMailFrame:setEnableBottomElement(true)--设置BottomElement是否可用
        tbconRecvMailFrame:setHideBottomElement(false)--设置bottomElement是否隐藏
        tbconRecvMailFrame:setBottomElement(ttf)--设置容器的BottomElement对象
        --tbconRecvMailFrame:slideToPosition(0,0,0,0,nil)
    else
        WZLog("TOhideDown") 
        tbconRecvMailFrame:setEnableDagLoading(false)
        tbconRecvMailFrame:setEnableBottomElement(false)
        tbconRecvMailFrame:setHideBottomElement(true)
    end
end

--@brief    邮件排序函数
function    _sortMailList(a,b)
    if  a.mailId == WndMail.n_editMailId then
        return true
    end
    if a.attachment ~= b.attachment then
        if a.attachment == 1 then
            if a.isRead == 2 then
                return false
            else
                return true
            end
        else
            if b.isRead == 2 then
                return true
            else
                return false
            end 
        end
    else
        if a.isRead ~= b.isRead then
            if a.isRead == 2 then
                return false
            end
            if b.isRead == 2 then
                return true
            end
        end
    end
    local timeStrA = a.time
    local timeStrB = b.time
    
    local timeA = _timeStrToTime(timeStrA)
    local timeB = _timeStrToTime(timeStrB)
    
    if timeA.year > timeB.year then
        return true
    elseif timeA.year == timeB.year and timeA.month > timeB.month then
        return true
    elseif timeA.year == timeB.year and timeA.month == timeB.month and timeA.day > timeB.day then
        return true
    elseif timeA.year == timeB.year and timeA.month == timeB.month and timeA.day == timeB.day and timeA.hour > timeB.hour then
        return true
    elseif timeA.year == timeB.year and timeA.month == timeB.month and timeA.day == timeB.day and timeA.hour == timeB.hour and timeA.min > timeB.min then
        return true
    elseif timeA.year == timeB.year and timeA.month == timeB.month and timeA.day == timeB.day and timeA.hour == timeB.hour and timeA.min == timeB.min and timeA.sec > timeB.sec then
        return true
    end

    return false
end
--@brief    将时间字符串转换为时间
function _timeStrToTime(timeStr)
    local ts = nil
    local y  = string.sub(timeStr,1, 4 )
    local m  = string.sub(timeStr,6, 7 )
    local d  = string.sub(timeStr,9, 10)
    local h  = string.sub(timeStr,12,13)
    local mm = string.sub(timeStr,15,16)
    local s  = string.sub(timeStr,18,19)
    ts = {year = y,month = m,day = d,hour = h,min = mm,sec = s}
    return ts
end

--@brief	清空邮件列表
function WndMail:_clearMailList()
    GetElement(self.m_root, "tbconRecvSendMailFrame_WndMail", WZUITableContainer):cleanTable()
end

--@brief	设置写邮件名称
function WndMail:_setRecvName(sName,color)
	sName = sName or ""
	color = color or GlobalMethod:ccc3(255,255,255)
	local txtName = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtName_WndMail"))
	txtName:setText(sName)
	txtName:setColor(color)
end

--@brief	获取写邮件人名称
function WndMail:_getRecvName()
	local txtName = WZUILabelTTF:luaTo(self.m_root:getChildElement("txtName_WndMail"))
	return txtName:getText()
end

--@brief    从邮件列表中移除指定邮件
--@param    nTag: 0删除打开的邮件，1删除选中的邮件
--@author   hyq
function WndMail:_deletMailFromList(nTag)
    WZLog("WndMail:_deletMailFromList(nTag)",nTag)
    local mailListCache = CacheCenter:getMailList()
    if mailListCache == nil or #mailListCache == 0 then
        return
    end
    local tbconRecvMailFrame = GetElement(self.m_root, "tbconRecvSendMailFrame_WndMail", WZUITableContainer)
    local deleNum = 0
    --删除邮件
    for i=1,#self.m_tMailList do
        local tCell = tbconRecvMailFrame:getCellElement(i-1)
        if tCell ~= nil then
            local cell = tCell:getChildElement("CellMailList")
            local cellTable = WZUIContainer:luaTo(cell):getLuaObjectIndex() 
            local selTag = cellTable:getCheckState()
            if nTag == 0 then --删除打开的邮件
                if self.m_tMailList[i].mailId == self.m_tCurOpenMail.mailId then
                    --删除缓存
                    for j=1,#mailListCache do
                        if mailListCache[j].mailId == self.m_tMailList[i].mailId then
                            table.remove(mailListCache,j)
                            self.m_tCurOpenMail = nil
                            break
                        end
                    end
                    break
                end
            else --删除选中的邮件
                WZLog("selTag====",i,selTag)
                if selTag == 1 and self.m_tMailList[i].mailType ~= self.n_editMailId then --选中
                    deleNum = deleNum + 1
                    if self.m_tCurOpenMail ~= nil and self.m_tCurOpenMail.mailId == self.m_tMailList[i].mailId then
                        self.m_tCurOpenMail = nil
                    end
                    --删除邮件缓存
                    for j=1,#mailListCache do
                        if mailListCache[j].mailId == self.m_tMailList[i].mailId then
                            WZLog("j2===",j)
                            table.remove(mailListCache,j)
                            break
                        end
                    end
                end
            end
        end
    end
    WZLog("----TTTTTT----:", deleNum)
    if deleNum >= #self.m_tMailList  then
        self.b_isEdit = false
        self:setSeletbutton(false)
    end
    --重新创建列表
    self:_createMailMenuList()
    self:_isMailIconVisible(self.b_isEdit)
    --设置按钮是否可见
    local tag = self.m_nOpenTag
    if self.b_isEdit then
        tag = 0
    end
    self:_setWndMailBtnVisible(tag)
end

--@brief    设置按钮是否可见
--@param    tag:0点击编辑,1选中收件箱，2选中发件箱
--@author   hyq
function WndMail:_setWndMailBtnVisible(tag)
    WZLog("WndMail:_setWndMailBtnVisible:", tag)
    --编写邮件按钮
    GetElement(self.m_root, "btnWriteMail_WndMail", WZUIContainer):setVisible(tag==2)
    --商品邮件提示
    GetElement(self.m_root, "txtShopTips_WndMail", WZUILabelTTF):setVisible(tag==3)
    --一键领取按钮
    if tag == 1 then
        local btnGetAll = GetElement(self.m_root,"btnGetAll_WndMail",WZUIButton)
        local mailList = CacheCenter:getMailList()
        local hasNewMail = false
        for i=1,#mailList do
            local readTag = mailList[i].isRead
            if mailList[i].attachment == 1 and readTag ~= 2 and not self:_isShopMail(mailList[i]) and readTag ~= 8 then
                hasNewMail = true
                break
            end
        end
        self:_setGetAllButton(hasNewMail)
    else
        self:_setGetAllButton(false)  
    end
    if tag == 3 then --商务箱
        GetElement(self.m_root, "scrollNotice_WndMail", WZUIMoveContainer):setAbsContentSize(GlobalMethod:CCSize(355,135))
        GetElement(self.m_root, "btnEditMail_WndMail", WZUIButton):setVisible(false)
        GetElement(self.m_root,"conReward_WndMail",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5, 0.36))
    else
        GetElement(self.m_root,"conPayNum_WndMail",WZUIContainer):setVisible(false)
        GetElement(self.m_root,"conReward_WndMail",WZUIContainer):setRelativePosition(GlobalMethod:ccp(0.5, 0.28))
    end
    --右边按钮相关
    GetElement(self.m_root,"btnDeleteMail_WndMail",WZUIButton):setVisible(false)  --删除
    GetElement(self.m_root,"btnReply_WndMail",WZUIButton):setVisible(false)      --回复
    GetElement(self.m_root,"btnGet_WndMail",WZUIButton):setVisible(false)        --领取
    GetElement(self.m_root,"btnSend_WndMail",WZUIButton):setVisible(false)        --发送
    GetElement(self.m_root,"btnReject_WndMail",WZUIButton):setVisible(false)        --拒绝
    GetElement(self.m_root,"btnPay_WndMail",WZUIButton):setVisible(false)        --付款
end

--@brief 设置右边领取按钮与删除按钮
--@param bHas,是否拥有附件
function WndMail:setRightDeletButtonState(bHas)
    local btnDele = GetElement(self.m_root,"btnDeleteMail_WndMail",WZUIButton)
    btnDele:setVisible(bHas)
    GetElement(self.m_root,"btnGet_WndMail",WZUIButton):setVisible(not bHas)        --领取
end

--@brief  	更新滚动容器内部布局函数
function WndMail:_upMoveContainerLayer()
	if self.m_root == nil then return end

	--文本大小size
	local txtNotice = WZUILabelTTF:luaTo(self.m_root:getChildElement("mailContent_WndMail"))
	local txtSize = txtNotice:getContentSize()

	-- 滑动层size
	local scroll = GetElement(self.m_root, "scrollNotice_WndMail", WZUIMoveContainer)
	if scroll == nil then  return end
    local scrollSize = scroll:getContentSize()
    WZLog("WndMail:_upMoveContainerLayer:",scrollSize.height)
	--更改滚动容器Element的大小
	local moveElement = scroll:getMoveElement()
	local size = moveElement:getRelativeSize()
	moveElement:setRelativeSize( CCSize( size.width, txtSize.height / scrollSize.height) )
	scroll:UpdateInsidePosition()  --更新滚动容器内部布局
	moveElement:setPositionY(scroll:getMinPosition().y)
end

--@brief    多语言版本文本
function WndMail:_setUIStaticText()
    GetElement(self.m_root,"txtSender2_WndMail",WZUILabelTTF):setText(LocalStrings.MAIL_SENDER)
     GetElement(self.m_root,"txt_showRec_WndMail",WZUILabelTTF):setText(LocalStrings.EDITMAILID)
     GetElement(self.m_root,"editThemeMail_WndMail",WZUIEditBox):setPlaceHolder(LocalStrings.MAILTITELENT)
     if ProjConfig.LANGUAGE == "pt" then
        local edit = GetElement(self.m_root,"editThemeMail_WndMail",WZUIEditBox)
        edit:setScale(0.6)
        edit:setRelativeSize(GlobalMethod:CCSize(1.3,1))
        --edit:setDimensions(GlobalMethod:CCSize(200,0))
     end
     if ProjConfig.LANGUAGE == "tr" then
        --local txt = [[<T C="255,236,193" S="16" P="0">%s</T>]]
        local edit = GetElement(self.m_root,"editThemeMail_WndMail",WZUIEditBox)
        edit:setAnchorPoint(GlobalMethod:ccp(0,0.5))
        edit:setRelativePosition(GlobalMethod:ccp(0,0.45))
        --edit:setVerticalPlaceHolderAlignment(0)
        --edit:setVerticalAlignment(0)
        edit:setFontSize(18)
     end
     GetElement(self.m_root,"editContentMail_WndMail",WZUIEditBox):setPlaceHolder(LocalStrings.MAILMAXLENG)
end


-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配模块Star--------------------------------------
function WndMail:_adaptLanguage_en()
	GetElement(self.m_root,"txtBusiness_WndMail",WZUILabelTTF):setFontSize(20)
	GetElement(self.m_root,"txtBusiness2_WndMail",WZUILabelTTF):setFontSize(22)
	GetElement(self.m_root,"txtBtnEdit_WndMail",WZUILabelTTF):setScale(0.85)
	local txtSel = GetElement(self.m_root,"txtSelName_WndMail",WZUILabelTTF)
	txtSel:setFontSize(20)
	txtSel:setRelativePosition(GlobalMethod:ccp(0.4, 0.5))

    local mailContent = GetElement(self.m_root,"mailContent_WndMail",WZUILabelTTF)
    mailContent:setMaxLength(400)
end

function WndMail:_adaptLanguage_pt(  )
    GetElement(self.m_root,"txtBusiness_WndMail",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtBusiness2_WndMail",WZUILabelTTF):setFontSize(22)
    GetElement(self.m_root,"txtBtnEdit_WndMail",WZUILabelTTF):setFontSize(22)
    local txtSel = GetElement(self.m_root,"txtSelName_WndMail",WZUILabelTTF)
    txtSel:setFontSize(20)
    txtSel:setRelativePosition(GlobalMethod:ccp(0.4, 0.5))
    GetElement(self.m_root,"txtRecv_WndMail",WZUILabelTTF):setScale(0.9)
    GetElement(self.m_root,"txtRecvOfGroupBox_WndMail",WZUILabelTTF):setScale(0.9)
    local txtBtnEdit = GetElement(self.m_root,"txtBtnEdit_WndMail",WZUILabelTTF)
    txtBtnEdit:setDimensions(GlobalMethod:CCSize(100,0))
    txtBtnEdit:setScale(0.8)
    local txtBtnGetAll = GetElement(self.m_root,"txtBtnGetAll_WndMail",WZUILabelTTF)
    txtBtnGetAll:setScale(0.7)
    txtBtnGetAll:setDimensions(GlobalMethod:CCSize(100,0))

    local mailContent = GetElement(self.m_root,"mailContent_WndMail",WZUILabelTTF)
    mailContent:setMaxLength(400)
end

function WndMail:_adaptLanguage_th()
	local txtSel = GetElement(self.m_root,"txtSelName_WndMail",WZUILabelTTF)
	txtSel:setFontSize(20)
	txtSel:setRelativePosition(GlobalMethod:ccp(0.35, 0.5))

    local mailContent = GetElement(self.m_root,"mailContent_WndMail",WZUILabelTTF)
    mailContent:setMaxLength(400)
end

function WndMail:_adaptLanguage_vn(  )
    GetElement(self.m_root,"txtBusiness_WndMail",WZUILabelTTF):setFontSize(20)
    GetElement(self.m_root,"txtBusiness2_WndMail",WZUILabelTTF):setFontSize(20)
    local senderName = GetElement(self.m_root,"senderName_WndMailTTF",WZUILabelTTF)
    senderName:setRelativePosition(GlobalMethod:ccp(-0.00928572,0.466667))
    senderName:setFontSize(17)

    GetElement(self.m_root,"txtSelName_WndMail",WZUILabelTTF):setRelativePosition(GlobalMethod:ccp(0.419118,0.5))

    local txtSender = GetElement(self.m_root,"txtSender2_WndMail",WZUILabelTTF)
    txtSender:setFontSize(17)
    txtSender:setRelativePosition(GlobalMethod:ccp(-0.00928572,0.5))

    local mailContent = GetElement(self.m_root,"mailContent_WndMail",WZUILabelTTF)
    mailContent:setMaxLength(400)
end

--@brief    土耳其适配
function WndMail:_adaptLanguage_tr(  )
    local txtRecv = GetElement(self.m_root,"txtRecv_WndMail",WZUILabelTTF)
    txtRecv:setDimensions(GlobalMethod:CCSize(90,0))
    txtRecv:setScale(0.78)

    local txtRecvSel = GetElement(self.m_root,"txtRecvOfGroupBox_WndMail",WZUILabelTTF)
    txtRecvSel:setDimensions(GlobalMethod:CCSize(90,0))
    txtRecvSel:setScale(0.78)

    GetElement(self.m_root,"txtOutBox_WndMail",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtSendOfGroupBox_WndMail",WZUILabelTTF):setScale(0.76)

    local txtGetAll = GetElement(self.m_root,"txtBtnGetAll_WndMail",WZUILabelTTF)
    txtGetAll:setDimensions(GlobalMethod:CCSize(130,0))
    txtGetAll:setScale(0.8)

    local txtSelName = GetElement(self.m_root,"txtSelName_WndMail",WZUILabelTTF)
    txtSelName:setDimensions(GlobalMethod:CCSize(100,0))
    txtSelName:setFontSize(18)

    local txtBtnEdit = GetElement(self.m_root,"txtBtnEdit_WndMail",WZUILabelTTF)
    txtBtnEdit:setScale(0.88)

    local txtBusiness = GetElement(self.m_root,"txtBusiness2_WndMail",WZUILabelTTF)
    txtBusiness:setFontSize(22)

    GetElement(self.m_root,"txtSender2_WndMail",WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root,"txtTheme2_WndMail",WZUILabelTTF):setScale(0.8)
    
    local mailContent = GetElement(self.m_root,"mailContent_WndMail",WZUILabelTTF)
    mailContent:setMaxLength(400)
end

function WndMail:_adaptLanguage_es(  )
    local txtSel = GetElement(self.m_root,"txtSelName_WndMail",WZUILabelTTF)
    txtSel:setFontSize(18)
    txtSel:setRelativePosition(GlobalMethod:ccp(0.38,0.5))
    txtSel:setDimensions(GlobalMethod:CCSize(80,0))

    local txtRecv = GetElement(self.m_root,"txtRecv_WndMail",WZUILabelTTF)
    txtRecv:setDimensions(GlobalMethod:CCSize(110,0))
    txtRecv:setScale(0.6)

    local txtRecvSel = GetElement(self.m_root,"txtRecvOfGroupBox_WndMail",WZUILabelTTF)
    txtRecvSel:setDimensions(GlobalMethod:CCSize(130,0))
    txtRecvSel:setScale(0.6)

    local txtOutBox = GetElement(self.m_root,"txtOutBox_WndMail",WZUILabelTTF)
    txtOutBox:setDimensions(GlobalMethod:CCSize(110,0))
    txtOutBox:setScale(0.6)

    local txtSendOfGroup = GetElement(self.m_root,"txtSendOfGroupBox_WndMail",WZUILabelTTF)
    txtSendOfGroup:setDimensions(GlobalMethod:CCSize(110,0))
    txtSendOfGroup:setScale(0.6)

    local txtBtnEdit = GetElement(self.m_root,"txtBtnEdit_WndMail",WZUILabelTTF)
    txtBtnEdit:setScale(0.77)

    local txtBtnGetAll = GetElement(self.m_root,"txtBtnGetAll_WndMail",WZUILabelTTF)
    txtBtnGetAll:setScale(0.77)

    local txtShopTips = GetElement(self.m_root,"txtShopTips_WndMail",WZUILabelTTF)
    txtShopTips:setDimensions(GlobalMethod:CCSize(300,0))

    local txtBusiness = GetElement(self.m_root,"txtBusiness_WndMail",WZUILabelTTF)
    txtBusiness:setScale(0.6)
    txtBusiness:setDimensions(GlobalMethod:CCSize(110,0))
    
    local txtBusiness2 = GetElement(self.m_root,"txtBusiness2_WndMail",WZUILabelTTF)
    txtBusiness2:setScale(0.6)
    txtBusiness2:setDimensions(GlobalMethod:CCSize(110,0))

    local mailContent = GetElement(self.m_root,"mailContent_WndMail",WZUILabelTTF)
    mailContent:setMaxLength(400)
end
-------------------------------------语言适配模块End--------------------------------------

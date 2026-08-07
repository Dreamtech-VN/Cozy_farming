--SceneThrowingEggs.lua
--@brief	SceneThrowingEggs的UI模块
--@date		2014/02/23
--@author	孙珊珊
--@note		副本战斗结束砸蛋功能


-------------------------------------公有方法模块Begin--------------------------------------
SceneThrowingEggs.xmlAction = [[ <WZUIContainer Type="WZUIContainer" Name="conZuanAni_SceneThrowingEggs" Visible="True">
                <WZUIImage Type="WZUIImage" File="ui/common/common_black_bg.png" Opacity="0" />
                <WZUIImage Type="WZUIImage" UseOriginSize="True" File="common/text/diamond_egg.png" RelativePosition="1.08949,0.5" Name="imgText_SceneThrowingEggs">
                    <Action Type="WZUIActionSequence" Duration="1" IsLoop="False" >
                        <ChildAction Type="WZUIActionMoveTo" StartWithCurrentPosition="True" MoveX="-0.58" Duration="0.2" />
                        <ChildAction Type="WZUIActionDelayTime" Duration="0.6" />
                        <ChildAction Type="WZUIActionMoveTo" StartWithCurrentPosition="True" MoveX="-1.3" Duration="0.2" FinishLuaFunction="_updatePayTime" />
                    </Action>
                </WZUIImage>
            </WZUIContainer>]]
--@brief	往场景根节点添加元素的方法
--@param	element:要添加的界面元素引用
--@note		这里会修改showAll属性，为了适配不同分辨率，保证界面元素不会变形
function SceneThrowingEggs:addChild(element)
    if self.m_root == nil or element == nil then
        return
    end
   
    element:setShowAll(true)
    self.m_root:addChild(element)
end

function SceneThrowingEggs:checkEggs()
	WZLog("SceneThrowingEggs:checkEggs",self.m_nHadThrowingEggCount)
end

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function SceneThrowingEggs:onEnter(element)
	self.m_root = element

   
   	--多语言版本界面适配
    AdaptLanguage(self)


	if self.m_tData ~= nil then
		self:_update()
	end

	--多语言版本界面适配
	AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function SceneThrowingEggs:onExit(element)
	ProtocolProcessorSceneThrowingEggs:unregAll()
	self:_unInit()
    --GlobalGame:setIfInBattle(false)
end

--@brief	关闭场景
function SceneThrowingEggs:closeWindow()
	sceneBossMap = SceneIsland:createElement()
	if sceneBossMap ~= nil then
        GlobalGame.g_tSysConfig.cartonTab = 1
		replaceScene(sceneBossMap)
        
	end
end
-------------------------------------关于界面点击事件---------------------------------------
--@brief	点击蛋蛋时调用的函数
--@param	element:表绑定的UI节点引用
function SceneThrowingEggs:onClickEgg(element)
	local tag = element:getTag()
	--[[if self.nTag==tag then
		 return
	end]]
	SoundManager:playEffectSound(SoundDefine.E_S_OPENCARD)
	--self.nTag = tag
	local flag=false
	if self.nFreeTime==0 or self.m_nFreeThrowEggTimes==2 then
		--if self.nPayTime==0 or GlobalGame.g_tPlayerInfo.nTickets<self.m_tData.pices[1] or
        WZLog("SceneThrowingEggs:onClickEgg", tostring(self.nPayTime), tostring(GlobalGame.g_tPlayerInfo.nTickets), tostring(self.m_tData.pices[self.m_nAlreadyDiamodTime]), tostring(self.m_nAlreadyDiamodTime), tostring(self.m_nPayThrowEggTimes))
		if self.nPayTime==0 or GlobalGame.g_tPlayerInfo.nTickets<self.m_tData.pices[self.m_nAlreadyDiamodTime] or 
		self.m_nPayThrowEggTimes==6 then
			WZLog("nnnnnnnnnnnnnn",GlobalGame.g_tPlayerInfo.nTickets,self.m_tData.pices[self.m_nAlreadyDiamodTim],self.nPayTime)
			if GlobalGame.g_tPlayerInfo.nTickets<self.m_tData.pices[self.m_nAlreadyDiamodTime] and self.nPayTime ~= 0  then
				MsgBoxManager:showTipBox(LocalStrings.DIAMOND_NOT_ENOUGH_PLEASE_RECHARGE)
			end
		else
			flag = true
			self.m_nPayThrowEggTimes = self.m_nPayThrowEggTimes + 1
			ProtocolProcessorSceneThrowingEggs:send_BOSSMAPBATTLE_Reward( )
		end
	else
		flag = true
		self.m_nFreeThrowEggTimes = self.m_nFreeThrowEggTimes + 1
	end
	if flag==false then
		return
	end
	self:setEggIsTouchEnable(false)

	for i=1,#self.m_tPoint do
		if self.m_tPoint[i] == tag then
			table.remove(self.m_tPoint,i)
			break
		end
	end
	
	self:_startLottery(tag,GlobalGame.g_tPlayerInfo.nPlayerId)

end
--@brief	点击确定充值回调
--@param    nType，按钮类型，关闭，取消，确定
--@param    nId，按钮id
function SceneThrowingEggs:clickSureMoney(nId,nType)
	if nType == MSGBOXRESTYPE_CONFIRM then
		SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
		PassportSdkManager:gotoPaymentPage()
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief	更新显示上方文本信息
function SceneThrowingEggs:_update()
	if self.m_root == nil then
		WZLog("_update() m_root is nil")
		return
	end

	if self.m_tData == nil then
		WZLog("_update() m_tData is nil")
		return
	end
	ProtocolProcessorSceneThrowingEggs:regAll()
	self:_setLocalText()
	self:_updateTable()
end

--@brief	更新显示上方文本信息
function SceneThrowingEggs:_setLocalText()

	local txtF1 = self.m_root:getChildElement("txtF1_SceneThrowingEggs")
	local txtF2 = self.m_root:getChildElement("txtF2_SceneThrowingEggs")
	if txtF1==nil or txtF2==nil then
		return
	end
	txtF1 = WZUILabelTTF:luaTo(txtF1)
	txtF2 = WZUILabelTTF:luaTo(txtF2)
	txtF1:setText(LocalStrings.THROWINGEGGS_MSG_ZUAN)
	txtF2:setText(LocalStrings.THROWINGEGGS_MSG_THROWEGG)

end
--@brief   创建蛋蛋表
function SceneThrowingEggs:_updateTable()
	local tbconEggs = self.m_root:getChildElement("tbconEggs_SceneThrowingEggs")
	if tbconEggs==nil then
		return
	end
	tbconEggs = WZUITableContainer:luaTo(tbconEggs)
	for i=1,self.m_tData.eggCount do
		--创建单元格(cell)
		local cellElement = WZUISystem:getInstance():createElement("conEggsCell_SceneThrowingEggs")
		if cellElement== nil then
		   return
		end
		cellElement = WZUIContainer:luaTo(cellElement)
		--
		local imgIcon = cellElement:getChildElement("imgIcon_conEggsCell")
		if imgIcon==nil then
			WZLog("imgIcon==nil")
		end
		imgIcon = WZUIImage:luaTo(imgIcon)
		imgIcon:setFile(self.m_tEggIcon[i])
		imgIcon:setVisible(true)
		--
		local conEgg = cellElement:getChildElement("conEgg_conEggsCell")
		if conEgg==nil then
			WZLog("conEgg==nil")
		end
		conEgg = WZUIContainer:luaTo(conEgg)
		--
		conEgg:setTag(i)
		local nRandom = math.random(1,18)
		if nRandom>=1 and nRandom<=3 then
			self.nEggAniType[i] = 1
			self:_createEggsAnimation(conEgg,"egg1_full",1)
		elseif nRandom>=4 and nRandom<=8 then
			self.nEggAniType[i] = 2
			self:_createEggsAnimation(conEgg,"egg2_full",1)
		elseif nRandom>=9 and nRandom<=14 then
			self.nEggAniType[i] = 3
			self:_createEggsAnimation(conEgg,"egg3_full",1)
		else
			self.nEggAniType[i] = 4
			self:_createEggsAnimation(conEgg,"egg4_full",1)
		end
		--
		conEgg:setVisible(false)
		--
		local btnEgg = cellElement:getChildElement("btnEgg_conEggsCell")
		if btnEgg == nil then
			WZLog("btnEgg == nil")
		end
		btnEgg = WZUIButton:luaTo(btnEgg)
		btnEgg:setTouchEnable(false)
		--
		local txtNum = cellElement:getChildElement("txtNum_conEggsCell")
		if txtNum == nil then
			WZLog("txtNum == nil")
		end
		txtNum = WZUILabelTTF:luaTo(txtNum)
     	txtNum:setText("X"..self.m_tEggNum[i])
        txtNum:setVisible(true)
		--
		local txtName = cellElement:getChildElement("txtName_conEggsCell")
		if txtName == nil then
			WZLog("txtName == nil")
		end
		txtName = WZUILabelTTF:luaTo(txtName)
		txtName:setVisible(true)
		txtNum:setTag(i)
		txtName:setTag(i)
		imgIcon:setTag(i)
		btnEgg:setTag(i)

		cellElement:setTag(i-1)
		tbconEggs:setCellElement(cellElement)
		cellElement:setVisible(true)
	end
	--添加免费砸蛋时间倒计时
	self:_updateFreeTime()
	--给表容器添加延迟动画
	self:DelayAnimation(tbconEggs,1.5,"_DelayFinished")
end

--@brief	免费砸蛋时间倒计时
function SceneThrowingEggs:_updateFreeTime()

	local txtZuan = self.m_root:getChildElement("txtZuan_SceneThrowingEggs")
	if txtZuan==nil then
		return
	end
	txtZuan = WZUILabelTTF:luaTo(txtZuan)
	txtZuan:setText("0")
	local txtTotalZuan = self.m_root:getChildElement("txtTotalZuan_SceneThrowingEggs")
	if txtTotalZuan==nil then
		return
	end
	txtTotalZuan = WZUILabelTTF:luaTo(txtTotalZuan)
	self.nFreeTime = 5
	txtTotalZuan:setText(self.nFreeTime)
	txtTotalZuan:enableSchedule("_scheduleFreeTime",1)
end

--@brief	调用钻石砸蛋阶段动画
function SceneThrowingEggs:_playNextAnimation()

	--给图片添加序列动画，序列动画完成后再调用钻石倒计时
	self:SequenceAnimation()

end

--@brief	钻石砸蛋时间倒计时
function SceneThrowingEggs:_updatePayTime()
	--
	local actionCon = self.m_root:getChildElement("conZuanAni_SceneThrowingEggs")
	if actionCon==nil then
	   WZLog("actionCon==nil")
	   return
	end
	actionCon = WZUIContainer:luaTo(actionCon)
	actionCon:removeFromParentAndCleanup(true)
	local txtZuan = self.m_root:getChildElement("txtZuan_SceneThrowingEggs")
	if txtZuan==nil then
		return
	end
	txtZuan = WZUILabelTTF:luaTo(txtZuan)
	txtZuan:setText(self.m_tData.pices[1])
	local txtTotalZuan = self.m_root:getChildElement("txtTotalZuan_SceneThrowingEggs")
	if txtTotalZuan==nil then
		return
	end
	txtTotalZuan = WZUILabelTTF:luaTo(txtTotalZuan)
	txtTotalZuan:setText(self.nPayTime)
	self.nPayTime = 10
	self:DelayAnimation(txtTotalZuan,1,"_schedulePayTime")
end

--@brief	免费砸蛋时间倒计时
function SceneThrowingEggs:_scheduleFreeTime(element)

	local txtTotalZuan = self.m_root:getChildElement("txtTotalZuan_SceneThrowingEggs")
	if txtTotalZuan==nil then
		return
	end
	txtTotalZuan = WZUILabelTTF:luaTo(txtTotalZuan)
	txtTotalZuan:setText(self.nFreeTime)
	if self.nFreeTime==0 then
		element:disableSchedule()
		--local eggsNum = 2*(self.m_tData.playerCount-1) + 2 - self.m_nFreeThrowEggTimes
		for i=1,self.m_tData.playerCount do
			if self.m_tData.playerIds[i] ~= GlobalGame.g_tPlayerInfo.nPlayerId then
				self.m_nOtherplayerId = self.m_tData.playerIds[i]
				for i=1,2 do
					self:_palyOtherThrowEgg()
				end
			end
		end
		for i=1,2 - self.m_nFreeThrowEggTimes do
			self.m_nOtherplayerId = GlobalGame.g_tPlayerInfo.nPlayerId
			self:_palyOtherThrowEgg()
		end
		self:_playNextAnimation()
		
	else
		self.nFreeTime = self.nFreeTime - 1
	end
end

--@brief	钻石砸蛋时间倒计时
function SceneThrowingEggs:_schedulePayTime(element)

	local txtTotalZuan = self.m_root:getChildElement("txtTotalZuan_SceneThrowingEggs")
	if txtTotalZuan==nil then
		return
	end
	txtTotalZuan = WZUILabelTTF:luaTo(txtTotalZuan)
	txtTotalZuan:setText(self.nPayTime)
	if self.nPayTime==0 then
		--关闭界面
		self:closeWindow()
	else
		self.nPayTime = self.nPayTime - 1
		self:DelayAnimation(txtTotalZuan,1,"_schedulePayTime")
	end
end

--@brief	延迟动画播完回调函数
function SceneThrowingEggs:_DelayFinished()

    --蛋蛋列表出现
	local tbconEggs = self.m_root:getChildElement("tbconEggs_SceneThrowingEggs")
	if tbconEggs==nil then
		return
	end
	tbconEggs = WZUITableContainer:luaTo(tbconEggs)
	WZLog("self.m_tData.eggCount",self.m_tData.eggCount)
	for i=1,self.m_tData.eggCount do
		local cell = tbconEggs:getCellElement(i-1)

		local conEgg = cell:getChildElement("conEgg_conEggsCell")
		conEgg = WZUIContainer:luaTo(conEgg)

		conEgg:setVisible(true)
		local imgIcon = cell:getChildElement("imgIcon_conEggsCell")
		imgIcon = WZUIImage:luaTo(imgIcon)

		imgIcon:setVisible(false)
		local btnEgg = cell:getChildElement("btnEgg_conEggsCell")
		btnEgg = WZUIButton:luaTo(btnEgg)
		btnEgg:setTouchEnable(false)
		local txtNum = cell:getChildElement("txtNum_conEggsCell")
		txtNum = WZUILabelTTF:luaTo(txtNum)
		txtNum:setVisible(false)
		local txtName = cell:getChildElement("txtName_conEggsCell")
		txtName = WZUILabelTTF:luaTo(txtName)
		txtName:setVisible(false)
	end
	--播放物品列表退出的动画，从中间到左
	self:_createEnterAnimation(tbconEggs,0.5,-0.8,"_ExitAnimationFinish")
end

--@brief	物品列表退出动画播完后回调的函数
function SceneThrowingEggs:_ExitAnimationFinish()
	--蛋蛋列表出现
	local tbconEggs = self.m_root:getChildElement("tbconEggs_SceneThrowingEggs")
	if tbconEggs==nil then
		return
	end
	tbconEggs = WZUITableContainer:luaTo(tbconEggs)
	--播放蛋蛋列表出来的动画，从左到中间
	self:_createEnterAnimation(tbconEggs,0.5,0.8,"_EnterAnimationFinish")
end

--@brief	蛋蛋出场动画播放完后调用的函数
function SceneThrowingEggs:_EnterAnimationFinish()
	local tbconEggs = self.m_root:getChildElement("tbconEggs_SceneThrowingEggs")
	if tbconEggs==nil then
		return
	end
	tbconEggs = WZUITableContainer:luaTo(tbconEggs)
	for i=1,self.m_tData.eggCount do
		local cell = tbconEggs:getCellElement(i-1)
		local btnEgg = cell:getChildElement("btnEgg_conEggsCell")
		btnEgg = WZUIButton:luaTo(btnEgg)
		btnEgg:setTouchEnable(true)
	end
	 
end

--@brief    设置是否可以点砸蛋的按钮
function SceneThrowingEggs:setEggIsTouchEnable(bIsEnable)
	for i=1,self.m_tData.eggCount do
		local tbconEggs = self.m_root:getChildElement("tbconEggs_SceneThrowingEggs")
		if tbconEggs==nil then
			return
		end
		tbconEggs = WZUITableContainer:luaTo(tbconEggs)
		local cell = tbconEggs:getCellElement(i-1)
		local btnEgg = cell:getChildElement("btnEgg_conEggsCell")
		if btnEgg == nil then
			WZLog("btnEgg == nil")
		end
		btnEgg = WZUIButton:luaTo(btnEgg)
		--if btnEgg:getTag()~=self.nTag then
			btnEgg:setTouchEnable(false)
		--end
	end
	
	if bIsEnable then
		for i,tag in pairs(self.m_tPoint) do
			local tbconEggs = self.m_root:getChildElement("tbconEggs_SceneThrowingEggs")
			if tbconEggs==nil then
				return
			end
			tbconEggs = WZUITableContainer:luaTo(tbconEggs)
			local cell = tbconEggs:getCellElement(tag-1)
			local btnEgg = cell:getChildElement("btnEgg_conEggsCell")
			if btnEgg == nil then
				WZLog("btnEgg == nil")
			end
			btnEgg = WZUIButton:luaTo(btnEgg)
			btnEgg:setTouchEnable(true)
		end
		
	end
	
end

--@brief	开始砸蛋
--@param	playerId:玩家ID
function SceneThrowingEggs:_startLottery(tag,playerId)
	WZLog("``````````````````````````",tag)
    WZLog("#self.m_tData.pices = ",#self.m_tData.pices, self.m_tData.eggCount)
	for var = 1,#self.m_tData.egg_Item_Name do 
		WZLog("self.m_tData.pices[var] = ",self.m_tData.pices[var])
        WZLog("self.m_tData.egg_Item_Name[var] = ",self.m_tData.egg_Item_Name[var])
        WZLog("self.m_tData.egg_playeId[var] = ",self.m_tData.egg_playeId[var])
	end 
	local tbconEggs = self.m_root:getChildElement("tbconEggs_SceneThrowingEggs")
	if tbconEggs==nil then
		return
	end
	tbconEggs = WZUITableContainer:luaTo(tbconEggs)
	local cell = tbconEggs:getCellElement(tag-1)
	local conEgg = cell:getChildElement("conEgg_conEggsCell")
	conEgg = WZUIContainer:luaTo(conEgg)
	local btnEgg = cell:getChildElement("btnEgg_conEggsCell")
	btnEgg = WZUIButton:luaTo(btnEgg)
	btnEgg:setTouchEnable(false)
	if self.nEggAniType[tag]==1 then
		self:_createEggsAnimation(conEgg,"egg1_split",2)
		self:_createEggsAnimation(conEgg,"egg1_fragment",3)
	elseif self.nEggAniType[tag]==2 then
		self:_createEggsAnimation(conEgg,"egg2_split",2)
		self:_createEggsAnimation(conEgg,"egg2_fragment",3)
	elseif self.nEggAniType[tag]==3 then
		self:_createEggsAnimation(conEgg,"egg3_split",2)
		self:_createEggsAnimation(conEgg,"egg3_fragment",3)
	else
		self:_createEggsAnimation(conEgg,"egg4_split",2)
		self:_createEggsAnimation(conEgg,"egg4_fragment",3)
	end
	conEgg:setVisible(true)
	self:_displayGoods(playerId,tag)
	self:DelayAnimation(cell,0.5,"_stopSplitAnimation")
end

--@brief	显示炸开后的蛋蛋和物品信息
--@param	playerId:玩家id
function SceneThrowingEggs:_displayGoods(playerId,tag)
	local index = self.m_tPlayerEggs[playerId][1]
   
	local tbconEggs = self.m_root:getChildElement("tbconEggs_SceneThrowingEggs")
	if tbconEggs==nil then
		return
	end
     WZLog("tbconEggs==",tbconEggs)
	tbconEggs = WZUITableContainer:luaTo(tbconEggs)
	local cell = tbconEggs:getCellElement(tag-1)
 WZLog("cell==",cell)
	local imgIcon = cell:getChildElement("imgIcon_conEggsCell")
	imgIcon = WZUIImage:luaTo(imgIcon)
	imgIcon:setVisible(true)
 WZLog("imgIcon==",imgIcon)
	local txtNum = cell:getChildElement("txtNum_conEggsCell")
	txtNum = WZUILabelTTF:luaTo(txtNum)
	txtNum:setVisible(true)

	local txtName = cell:getChildElement("txtName_conEggsCell")
	txtName = WZUILabelTTF:luaTo(txtName)
	txtName:setVisible(true)

	imgIcon:setFile(self.m_tData.egg_item_icon[index])
	txtNum:setText("X"..self.m_tData.egg_ItemNum[index])
	txtName:setText(self:getPlayerNameByPlayerId(playerId))
	
	table.remove(self.m_tPlayerEggs[playerId],1)
end

--@brief	停止蛋蛋裂开的动画
function SceneThrowingEggs:_stopSplitAnimation(sender)
	if self.m_animationSprite2[sender:getTag()+1]~=nil then
		self.m_animationSprite2[sender:getTag()+1]:stopPlay()
		self.m_animationSprite2[sender:getTag()+1]:setVisible(false)
	end
	--
	self:setEggIsTouchEnable(true)
end


--@brief	通过蛋蛋的索引自爆蛋蛋
--@param	nIndex:蛋蛋的索引
function SceneThrowingEggs:_baoEggByIndex(nIndex)
	self:_startLottery(nIndex,1)
end
-------------------------------------关于动画---------------------------------------

--@brief	蛋蛋显示动画
--@param	element:当前节点控件
--@param	sEggType:蛋的动画名称
--@param	nTpye:蛋的动画类型
function SceneThrowingEggs:_createEggsAnimation(element,sEggType,nTpye)
	local tag = element:getTag()
	if nTpye==1 then
		if self.m_animationSprite3[tag]~=nil then
			self.m_animationSprite3[tag]:stopPlay()
			self.m_animationSprite3[tag]:setVisible(false)
		end
		if self.m_animationSprite2[tag]~=nil then
			self.m_animationSprite2[tag]:stopPlay()
			self.m_animationSprite2[tag]:setVisible(false)
		end
		self.m_animationSprite1[tag] = AnimationManager:createSpriteWithAnimation(IWCO_EGG, sEggType, nil, nil)
		element:addChild(self.m_animationSprite1[tag])
		self.m_animationSprite1[tag]:setVisible(true)
		self.m_animationSprite1[tag]:setPosition(self.m_animationSprite1[tag]:getContentSize().width*0.7,self.m_animationSprite1[tag]:getContentSize().height*0.45)
		self.m_animationSprite1[tag]:playOnce()
	elseif nTpye==2 then
		if self.m_animationSprite1[tag]~=nil then
			self.m_animationSprite1[tag]:stopPlay()
			self.m_animationSprite1[tag]:setVisible(false)
		end
		if self.m_animationSprite3[tag]~=nil then
			self.m_animationSprite3[tag]:stopPlay()
			self.m_animationSprite3[tag]:setVisible(false)
		end
		self.m_animationSprite2[tag] = AnimationManager:createSpriteWithAnimation(IWCO_EGG, sEggType, nil, nil)
		element:addChild(self.m_animationSprite2[tag])
		self.m_animationSprite2[tag]:setVisible(true)
		self.m_animationSprite2[tag]:setPosition(self.m_animationSprite2[tag]:getContentSize().width*0.7,self.m_animationSprite2[tag]:getContentSize().height*0.6)
		self.m_animationSprite2[tag]:playOnce()
	elseif nTpye==3 then
		if self.m_animationSprite1[tag]~=nil then
			self.m_animationSprite1[tag]:stopPlay()
			self.m_animationSprite1[tag]:setVisible(false)
		end
		self.m_animationSprite3[tag] = AnimationManager:createSpriteWithAnimation(IWCO_EGG, sEggType, nil, nil)
		element:addChild(self.m_animationSprite3[tag])
		self.m_animationSprite3[tag]:setVisible(true)
		self.m_animationSprite3[tag]:setPosition(self.m_animationSprite3[tag]:getContentSize().width*0.7,self.m_animationSprite3[tag]:getContentSize().height*0.75)
		self.m_animationSprite3[tag]:playOnce()
	end
end

--@brief	延迟动画
--@param	element:当前节点控件
--@param	duration:播放动画总时间
--@param	fun:回调函数
function SceneThrowingEggs:DelayAnimation(element,duration,fun)
	element:stopAllActions()
    local actionXml = [[ <Action Type="WZUIActionDelayTime"  Duration="%f"  FinishLuaFunction="%s"/>]]
    actionXml = string.format(actionXml,duration,fun)
    local action = WZUISystem:getInstance():createUIActionFromXmlText(actionXml)
    if action and element then
		element:runUIAction(action)
	end
end

--@brief	钻石阶段的序列动画
function SceneThrowingEggs:SequenceAnimation()
	
	local  xmlElement = string.format(SceneThrowingEggs.xmlAction)
	local actionElement = WZUISystem:getInstance():createUIElementFromXmlText(xmlElement)
	actionElement = WZUIContainer:luaTo(actionElement)
	self.m_root:addChild(actionElement)

end

--@brief	物品列表和蛋蛋出场动画
--@param	element:表绑定的UI节点引用
function SceneThrowingEggs:_createEnterAnimation(element,nDuration,nMovex,fun)
	element:stopAllActions()
	actionXml = [[<Action Type="WZUIActionMoveTo" StartWithCurrentPosition="True" IsLoop="False" Duration="%f" MoveX="%f" FinishLuaFunction="%s" />]]
	action = string.format(actionXml,nDuration,nMovex,fun)
    local action = WZUISystem:getInstance():createUIActionFromXmlText(action)
    if action and element then
		element:runUIAction(action)
	end
end

--@brief    中文适配函数
--@note     中文适配函数
function SceneThrowingEggs:_adaptLanguage_cn()
	WZLog("SceneThrowingEggs:_adaptLanguage_cn")
    local txtZuan = GetElement(self.m_root, "txtZuan_SceneThrowingEggs", WZUILabelTTF)
    if txtZuan then
    	txtZuan:setRelativePosition(ccp(0.385,0.701389))
    end
end 

-------------------------------------私有方法模块End----------------------------------------
-------------------------------------语言适配器模块Begin--------------------------------------

--@brief	英文适配函数
--@note		英文适配函数
function SceneThrowingEggs:_adaptLanguage_en()

    local txtZuan= self.m_root:getChildElement("txtZuan_SceneThrowingEggs")
	if  txtZuan ~= nil then 
	   WZUILabelTTF:luaTo(txtZuan):setRelativePosition(ccp(0.185,0.701389))
	end	
end

--@brief	葡语适配函数
--@note		葡语适配函数
function SceneThrowingEggs:_adaptLanguage_pt()

    local txtF1= self.m_root:getChildElement("txtF1_SceneThrowingEggs")
	if  txtF1 ~= nil then 
	   WZUILabelTTF:luaTo(txtF1):setRelativePosition(ccp(0.287148,0.702778))
	end	

	local txtF2= self.m_root:getChildElement("txtF2_SceneThrowingEggs")
	if  txtF2 ~= nil then 
	   WZUILabelTTF:luaTo(txtF2):setRelativePosition(ccp(0.691138,0.704609))
	   WZUILabelTTF:luaTo(txtF2):setFontSize(24)
	end	
    
	local txtZuan= self.m_root:getChildElement("txtZuan_SceneThrowingEggs")
	if  txtZuan ~= nil then 
	   WZUILabelTTF:luaTo(txtZuan):setRelativePosition(ccp(0.265,0.701389))
	end	
	
	local txtTotalZuan= self.m_root:getChildElement("txtTotalZuan_SceneThrowingEggs")
	if  txtTotalZuan ~= nil then 
	   WZUILabelTTF:luaTo(txtTotalZuan):setRelativePosition(ccp(0.868661,0.702778))
	end	
end 

--@brief  越南语适配函数
--@return 无
--@note   备注
function SceneThrowingEggs:_adaptLanguage_vn()
	--"本次砸蛋扣除钻石"、"正在等待其他玩家砸蛋:"标签超框调整
	local txtF1 = self.m_root:getChildElement("txtF1_SceneThrowingEggs")
	local txtF2 = self.m_root:getChildElement("txtF2_SceneThrowingEggs")
	if txtF1==nil or txtF2==nil then
		return
	end
	txtF1 = WZUILabelTTF:luaTo(txtF1)
	txtF2 = WZUILabelTTF:luaTo(txtF2)
	txtF1:setFontSize(22)
	txtF1:setDimensions(CCSize(280,0))
	txtF1:setAlignment(kCCTextAlignmentLeft)
	txtF2:setFontSize(26)
	txtF2:setDimensions(CCSize(280,0))
	txtF2:setAlignment(kCCTextAlignmentLeft)
    
	local txtZuan = self.m_root:getChildElement("txtZuan_SceneThrowingEggs")
	if txtZuan==nil then
		return
	end
	txtZuan = WZUILabelTTF:luaTo(txtZuan)
	txtZuan:setRelativePosition(ccp(0.3255,0.690389))
    --砖石数目
	local txtTotalZuan= self.m_root:getChildElement("txtTotalZuan_SceneThrowingEggs")
	if  txtTotalZuan ~= nil then 
	   WZUILabelTTF:luaTo(txtTotalZuan):setRelativePosition(ccp(0.738661,0.682778))
	end	
end

-------------------------------------语言适配器模块End----------------------------------------

--WndPracticeData.lua
--@brief	WndPractice的数据模块
--@date		2016/07/20
--@author	zhangming
--@note		修炼系统

G_Practice_Quick = 1   --修炼快速选择的功能
WndPractice = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndPractice:_init()
	self.m_root = nil	 	  			--场景根节点
	self.n_speed = 0                    --滚动速度
	self.t_data = {}                    --修炼的数据表
	self.n_rollTime = 0                 --滚动时间
	self.t_bActionOver = {}         	--动作完成的数组
	self.t_nConListPosY = {}            --滚动列表对应的y坐标
	self.t_nRollResult = {}             --摇奖结果
	self.t_imgMoveElement = {}          --飞行时候的移动节点
	self.m_nLoadingId = 0               --loadId
	self.n_fighting = 0                 --当前战斗力
	self.conPlayer = nil
	self.m_nCurAni = nil
	self.conOtherPlayer = nil 			--双修玩家
	self.m_nDoubleState = 0 			--双修状态 ： 0->未开启,且没有双修对象；1->有双修对象；2->已开启，未有双修对象
	self.m_tOpenCost = nil 			--开启双修消耗
	self.m_tOtherPlayerInfo = nil
	self.m_nLeftTime = 0
	self.m_tPublishTime = nil 		--退出惩罚
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndPractice:_unInit()
	self.m_root = nil
	self.n_speed = nil
	self.t_data = nil
	self.n_rollTime = nil
	self.b_actionOver = nil
	self.t_nConListPosY = nil          
	self.t_nRollResult = nil
	self.t_imgMoveElement = nil
	self.m_nLoadingId = nil  
	self.n_fighting = nil
	self.conPlayer = nil
	self.m_nCurAni = nil
	self.conOtherPlayer = nil
	self.m_nDoubleState = nil 
	self.m_tOpenCost = nil 
	self.m_tOtherPlayerInfo = nil
	self.m_nLeftTime = nil 
	self.m_tPublishTime = nil 		--退出惩罚
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndPractice:createElement()
	local element = WZUISystem:getInstance():createElement("WndPractice")
	assert(element, "WndPractice create element failed!")
	self:_init()
	return element
end

function WndPractice:showWin() 
	WZLog("WndPractice:showWin")
	if WndBagMain.m_root == nil then return end
	local wndPractice = WndPractice:createElement()
	GetElement(WndBagMain.m_root,"conSubWin",WZUIContainer):addChild(wndPractice)
end

--@brief 	开启双修功能
function WndPractice:openDoublePracticeOK(result, opType)
	-- body
	if self.m_root == nil then return end 
	
	if result == true then 
		if opType == 0 then 
			self.m_nDoubleState = 2
			MsgBoxManager:showTipBox(LocalStrings.PRACTICE_TEXT6)
		else
			MsgBoxManager:showTipBox(LocalStrings.PRACTICE_TEXT7)
		end
	end
end

--@brief 	设置双修相关数据
function WndPractice:setDoubleData(shuangXiuStatus, shuangXiuInfo, timeLimit)
	-- body
	-- shuangXiuInfo = {"name":"莎曼撤鼓石人","id":1990991,"sex":1,"head":4906,"face":4905,"body":4904,"wing":0,"headcolor":0,"bodycolor":0}
	self.m_nDoubleState = shuangXiuStatus
	self.m_tOtherPlayerInfo = json.decode(shuangXiuInfo)
	self.m_nLeftTime = timeLimit

	if self.m_nLeftTime > 0 then 
		self.m_root:enableSchedule("_caculateTime", 1)
	end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndPractice:moveBg() 
	local dist = -430
	local imgBg1 = GetElement(self.m_root,"imgBg1",WZUIImage)
   	local array = CCArray:create()
   	array:addObject(CCMoveBy:create(5,GlobalMethod:ccp(dist,0)))
	array:addObject( CCCallFunc:create(function()
		imgBg1:setRelativePosition(ccp(1,0.5))
	end ))
   	local action =  CCRepeatForever:create(CCSequence:create(array))
   	imgBg1:runAction(action)

	local imgBg2 = GetElement(self.m_root,"imgBg2",WZUIImage)
   	local array = CCArray:create()
   	array:addObject(CCMoveBy:create(5,GlobalMethod:ccp(dist,0)))
	array:addObject( CCCallFunc:create(function()
		imgBg2:setRelativePosition(ccp(1,0.5))
	end ))
   	local action =  CCRepeatForever:create(CCSequence:create(array))
   	imgBg2:runAction(action)
end

--@brief	显示人物形象
function WndPractice:showPlayer()
	if self.m_root == nil then return end
	if self.conPlayer ~= nil then 
		self.conPlayer:getAnimNode():removeFromParentAndCleanup(true) 
		self.conPlayer = nil
	end

	local tEquip = CacheCenter:getEquipedDecorationList()
	local headColor = 0
	local bodyColor = 0
	for i=1,#tEquip do
		if type(tEquip[i]) == "table" and tEquip[i].basicInfo.main_type == 5 and tEquip[i].basicInfo.sub_type == 0 and tEquip[i].isUse == true then
			headColor = tEquip[i].color
		end
		if type(tEquip[i]) == "table" and tEquip[i].basicInfo.main_type == 5 and tEquip[i].basicInfo.sub_type == 2 and tEquip[i].isUse == true then
			bodyColor = tEquip[i].color
		end
	end

	self.m_tPlayerInfo = CacheCenter:getPlayerInfo()
	local sex = self.m_tPlayerInfo.sex
    local conP = WZUIContainer:luaTo(self.m_root:getChildElement("conMain"))
    if not self.conPlayer then
		local conPlayer
		if self.m_tPlayerInfo.shapeId ~= 0 and self.m_tPlayerInfo.showShape == 1 then
        	conPlayer = CreatePlayerFigure(sex, nil, "run", nil, nil ,nil, nil, nil ,nil, nil, headColor ,bodyColor,true,self.m_tPlayerInfo.shapeId)
			conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.68,0.2))
        	conPlayer:getAnimNode():setAnchorPoint(ccp(0.5,0))
		else
        	conPlayer = CreatePlayerFigure(sex, tEquip, "run", nil, nil ,nil, nil, nil ,nil, nil, headColor ,bodyColor,false)
			conPlayer:getAnimNode():setRelativePosition(GlobalMethod:ccp(0.68,0.2))
			--conPlayer:setScale(0.95)
		end
        self.conPlayer = conPlayer
		self.conPlayer:play("run",true)
        conP:addChild(conPlayer:getAnimNode(),5)

        self:_createPlayerName(conPlayer:getAnimNode(), self.m_tPlayerInfo.name, "C15_F20_S4_C5")
    end
end

--@brief	设置是否双倍修炼
function WndPractice:setDouble(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	local doublePracticeConsume = CacheCenter:getGameParam().doublePracticeConsume
	local doublePracticeVipLimit = CacheCenter:getGameParam().doublePracticeVipLimit
	if doublePracticeConsume == nil or doublePracticeConsume == "" then doublePracticeConsume = "[70,5]" end
	if doublePracticeVipLimit == nil or doublePracticeVipLimit == "" then doublePracticeVipLimit = [[5]] end

	local setDouble = GetElement(self.m_root,"setDouble",WZUICheckBox)
	--判断vip等级
    if CacheCenter:getPlayerInfo().vipLevel < tonumber(doublePracticeVipLimit) then
    	local sMsg = string.format(LocalStrings.MULTI_SWEEP_TIP, tonumber(doublePracticeVipLimit))
        MsgBoxManager:showConfirmCancelBox(sMsg, self, self.needMoreDiamondCallBack, MSGBOXLEVEL_HIGH,nil)
		setDouble:enableSchedule("_setDouble",0.01)
		return
	end

	local id, num = SplitItemString(doublePracticeConsume)
	WZLog("WndPractice:setDouble",doublePracticeConsume, Serialize(id),Serialize(num))
    if setDouble:getCheckIndex() == 0 then
		MsgBoxManager:showTipBox(string.format(LocalStrings.CONVERSION3, tostring(num[1])))
	elseif setDouble:getCheckIndex() == 1 then

    end
end

function WndPractice:_setDouble()
	local setDouble = GetElement(self.m_root,"setDouble",WZUICheckBox)
	setDouble:setCheckIndex(0)
    setDouble:disableSchedule()
end

--@brief	提示框的回调
function WndPractice:needMoreDiamondCallBack(nId, nResType)
    if nResType == MSGBOXRESTYPE_CONFIRM then
		PassportSdkManager:gotoPaymentPage()
    end
end

--@brief 	开始倒计时惩罚时间
function WndPractice:_caculateTime(element, delta)
	-- body
	if self.m_nLeftTime > 0 then 
		self.m_nLeftTime = self.m_nLeftTime - 1 
	else
		self.m_root:disableSchedule()
	end
end

--@brief 	创建玩家名字
function WndPractice:_createPlayerName(parentNode, playerName, styleKey)
	--body
	local txtName = WZUILabelTTF:create()
	txtName:setText(playerName)
	if styleKey then 
		txtName:setLabelStyleKey(styleKey)
	else
		txtName:setLabelStyleKey("C18_F20_S4_C5")
	end
	txtName:setRelativePosition(GlobalMethod:ccp(0.5, 1.9))
	parentNode:addChild(txtName) 
end
-------------------------------------私有方法模块End----------------------------------------

--SceneTabooBattleData.lua
--@brief	SceneTabooBattle的数据模块
--@date		2017/04/21
--@note		禁忌之地场景
TabooEventType = {
	Battle = 1,	--战斗
	Reward = 2, --奖励
	Box = 3,	--宝箱
	AddItem = 4, --增加骰子 
	Advance = 5, --前进
	Back = 6,	--后退
	Trans = 7,  --传送
	Random = 8,  --随机事件
	BoxRush = 9, --清除宝箱
}

SceneTabooBattle = {
	--请不要在这里定义变量
}

SceneTabooBattle.g_rewardIds = nil
SceneTabooBattle.g_nums = nil

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function SceneTabooBattle:_init()
	self.m_nChapterId = -1
	self.m_root = nil	 	  			 --场景根节点
	self.m_tCardList = nil --卡牌数组
	self.m_tData = nil --面板数据
	self.m_nFilpCount = 0 --翻牌计数
	self.m_spine = nil --骰子动画
	self.m_imgSpine = nil --骰子动画图片
	self.m_nImgSpineDelay = nil --骰子动画图片延迟
	self.m_nCurrentStep = 1 --当前行走步伐
	self.m_nMoveStepNum = 0 --行走步数
	self.m_nMoveStepDelay = nil --移动延迟
	self.m_bReset = nil
	self.m_bExtraBoxOpen = nil
	self.m_bIsInMoveAction = nil --行动中
	self.m_nTabooRunTime = nil 		--骰子动画播放时间
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function SceneTabooBattle:_unInit()
	self.m_nChapterId = -1
	self.m_root = nil
	self.m_tCardList = nil
	self.m_tData = nil
	self.m_nFilpCount = 0
	self.m_spine = nil
	self.m_imgSpine = nil
	self.m_nImgSpineDelay = nil
	self.m_nCurrentStep = 1
	self.m_nMoveStepNum = 0 
	self.m_nMoveStepDelay = nil
	self.m_bReset = nil
	self.m_bExtraBoxOpen = nil
	self.m_bIsInMoveAction = nil
	self.m_nTabooRunTime = nil
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function SceneTabooBattle:createElement()
	local element = WZUISystem:getInstance():createElement("SceneTabooBattle")
	assert(element, "SceneTabooBattle create element failed!")
	self:_init()
	return element
end

function SceneTabooBattle:show(chapterId)
	WZLog("SceneTabooBattle:show")
	local scene = self:createElement()
	self.m_nChapterId = chapterId or -1
	replaceScene(scene)
end

--@brief	设置点击返回按钮返回的场景绑定的Lua表引用
--@param	tLuaObj，场景绑定的Lua表引用
--@note		点击返回按钮后切换到设置的场景，如果tLuaObj设置为nil，则禁用返回按钮
function SceneTabooBattle:setBackSceneLuaObj(tLuaObj)
	self.m_tBackSceneLuaObj = tLuaObj
end

--@brief	关闭按钮
function SceneTabooBattle:onCloseClick(element)
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
   	SceneTabooMap:show()
    SceneTabooMap:setCallBackFun(WndChallengeEntrance, WndChallengeEntrance.showInterface)
end

--@brief 刷新界面
function SceneTabooBattle:updateData(data)
	WZLog("SceneTabooBattle:updateInfoViewData ")
	if not self.m_root  then
		return
	end
	self.m_tData = data
	self.m_nCurrentStep = self.m_tData.currentIndex + 1
	self.m_nChapterId = data.currentChapterId
	self:_updateView()
end

--@brief 刷新宝箱
function SceneTabooBattle:updateBoxData(boxIndex,boxId,boxStatus,boxCountdown)
	if not self.m_root  then
		return
	end

	
	self:_updateBoxView(boxIndex,boxId,boxStatus,boxCountdown)
end

--@brief 刷新骰子
function SceneTabooBattle:updateDiceData(rushTime)
	if not self.m_root  then
		return
	end
	self:_updateDiceView(rushTime)
end

--@brief 投骰子回调
function SceneTabooBattle:throwDiceBack(point,jsonParam,normalBoxId,normalBoxStatus,extraBoxId)
	SceneTabooBattle.g_jsonParam = {}
	SceneTabooBattle.g_normalBoxStatus = normalBoxStatus
	SceneTabooBattle.g_extraBoxId = extraBoxId
	self.m_nMoveStepNum = point
	for i = 1,#jsonParam do
		table.insert(SceneTabooBattle.g_jsonParam,json.decode(jsonParam[i]))
	end

	SceneTabooBattle:_showTabooBtnActoin()
end


--@brief  添加顶部导航栏
function SceneTabooBattle:addTop()
	WZLog("SceneTabooBattle:addTop")
	local cell,tcell = CellTopHandle:createElement()
    self.m_root:addChild(cell)
    self.m_tTopHangle = tcell
    self.m_oTopObject = cell
    tcell:setTopData("ui/common/common_icon_jjzd.png",SceneTabooBattle,SceneTabooBattle.onCloseClick,true,true,false,"SceneTabooBattle",{goldType = 10})
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

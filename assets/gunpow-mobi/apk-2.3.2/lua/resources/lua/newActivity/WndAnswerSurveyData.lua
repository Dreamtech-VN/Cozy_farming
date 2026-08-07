--WndAnswerSurveyData.lua
--@brief	WndAnswerSurvey的数据模块
--@date		2019/12/12
--@author	Tianxiang_Xu
--@note		问题调研

WndAnswerSurvey = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndAnswerSurvey:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tQuestionList = nil 			--问题列表
	self.m_tSystemConfig = nil 			--系统配置
	self.m_tAnswerList = nil 			--玩家答案
	self.m_nLoadingId = nil 
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndAnswerSurvey:_unInit()
	self.m_root = nil
	self.m_tQuestionList = nil 			--问题列表
	self.m_tSystemConfig = nil 			--系统配置
	self.m_tAnswerList = nil 			--玩家答案
	self.m_nLoadingId = nil 
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndAnswerSurvey:createElement()
	if WndAnswerSurvey.m_root ~= nil then
		WindowManager:removeWindow(WndAnswerSurvey.m_root, WndAnswerSurvey, true)
	end
	local element = WZUISystem:getInstance():createElement("WndAnswerSurvey")
	assert(element, "WndAnswerSurvey create element failed!")
	self:_init()
	return element
end

--@brief 	外部接口
function WndAnswerSurvey:showInterface()
	-- body
	local wndAnswer = WndAnswerSurvey:createElement()
	if wndAnswer then 
		WindowManager:addWindow(wndAnswer, WndAnswerSurvey, false, nil, nil, true)
	end
end

function WndAnswerSurvey:submitOk(code)
	-- body
	self:_stopLoading()
	
	if code == 0 then 
		MsgBoxManager:showTipBox(LocalStrings.ANSWER_TEXT8)
	elseif code == 1 then 
		MsgBoxManager:showTipBox(LocalStrings.ANSWER_TEXT7)
	end
	GlobalGame.g_questionOpen = false
	WndOwnCity:openQuestion(GlobalGame.g_questionOpen)

	WindowManager:removeWindow(self.m_root , self , true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief 	设置问题数据
function WndAnswerSurvey:getQuestionData()
	-- body
	self.m_tQuestionList = {}

	for i, value in pairs(GDatatab_survey_question) do
		if value.set == self.m_tSystemConfig.num then 
			table.insert(self.m_tQuestionList, CopyTable(value))
		end
	end

	table.sort(self.m_tQuestionList, function (a, b)
		-- body
		return a.turn < b.turn
	end)

	self:_update()
end

--@brief    数据加载动画
function WndAnswerSurvey:_createLoading()
    -- body
     if self.m_root == nil then return end
    if self.m_nLoadingId == nil then
        self.m_nLoadingId = MsgBoxManager:showLoadingBox()
    end
end

--@brief    加载动画停止
function WndAnswerSurvey:_stopLoading()
    if self.m_root == nil then return end
    -- body
    if self.m_nLoadingId ~= nil then
        MsgBoxManager:stopLoadingBoxByMsgId(self.m_nLoadingId)
    end
    self.m_nLoadingId = nil 
end


-------------------------------------私有方法模块End----------------------------------------

--CellActivityRedEnvelopeData.lua
--@brief	CellActivityRedEnvelope的数据模块
--@date		2016/08/11
--@author	Tianxiang_Xu
--@note		限时折扣活动

CellActivityRedEnvelope = {
	-- 请在这里定义和初始化全局成员变量
}

--@brief	定义并初始化表的实例成员变量
--@note		表的实例变量必须在这里定义和初始化
function CellActivityRedEnvelope:_init()
	self.m_root = nil  			--Cell的根节点
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function CellActivityRedEnvelope:_unInit()
	self.m_root = nil
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建控件
--@return	#1，控件element的引用
--@return	#2, 表的引用，也可以用element:getLuaObjectIndex()
--@note		请仅用此方法创建场景
function CellActivityRedEnvelope:createElement()
	local tNewObj = self:_new()
	assert(tNewObj, "CellActivityRedEnvelope table create failed!")
	tNewObj:_init()
	local element = WZUISystem:getInstance():createElement("CellActivityRedEnvelope")
	assert(element, "CellActivityRedEnvelope element create failed!")
	element:setLuaObjectIndex(tNewObj)
	tNewObj.m_root = element
	return element,tNewObj
end

--@brief 	设置数据					
function CellActivityRedEnvelope:setMessage(activityId,startTime,endTime, maxCount, count)
	-- body
	WZLog("CellFireworks:setMessage",maxCount,Serialize(rewardCounts))
	self.m_nStartTime = startTime
	self.m_nEndTime = endTime
	self.maxCount = maxCount
	if maxCount == nil then
		self.maxCount = "8"
	end
	local text = GetElement(self.m_root,"text_CellActivityRedEnvelope",WZUIFreeTextBox)
	text:setShowText(string.format(LocalStrings.NEWYEARTIP7,"","",tostring(self.maxCount)))
	self:_showTime()
	AdaptLanguage(self)
end

--@brief    设置活动时间
function CellActivityRedEnvelope:_showTime()
    -- body
    --字“活动时间”
    local txtTimeWord = GetElement(self.m_root, "txtTimeWord_CellActivityRedEnvelope", WZUILabelTTF)
    if txtTimeWord then
        txtTimeWord:setText(LocalStrings.ACTIVE_TIME .. ":")
    end
    --活动时间
    local txtTime = GetElement(self.m_root, "txtTime_CellActivityRedEnvelope", WZUILabelTTF)
    if txtTime then
        local sStartDate = os.date("*t", self.m_nStartTime)
        local sEndDate = os.date("*t", self.m_nEndTime)
        txtTime:setText(string.format(LocalStrings.ACTIVITYTIME_FORMAT, sStartDate.month, sStartDate.day, sStartDate.hour, sStartDate.min, sEndDate.month, sEndDate.day, sEndDate.hour, sEndDate.min))
    end
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	以本表为模版创建一个新的表实例对象
--@return	新建的表实例对象
function CellActivityRedEnvelope:_new( )
	local tNewObj = {}
	setmetatable(tNewObj, self)
	self.__index = self
	CellActivityRedEnvelope.m_current = tNewObj
	return tNewObj
end

-------------------------------------私有方法模块End----------------------------------------

-------------------------------------语言适配Begin------------------------------------------
function CellActivityRedEnvelope:_adaptLanguage_vn(  )
	local txtTime = GetElement(self.m_root,"txtTime_CellActivityRedEnvelope",WZUILabelTTF)
	txtTime:setRelativePosition(GlobalMethod:ccp(0.5,0.5))
	local text = GetElement(self.m_root,"text_CellActivityRedEnvelope",WZUIFreeTextBox)
	text:setMaxWidth(520)
	text:setScale(0.8)
end
function CellActivityRedEnvelope:_adaptLanguage_en(  )
	local text = GetElement(self.m_root,"text_CellActivityRedEnvelope",WZUIFreeTextBox)
	text:setScale(0.7)
	text:setMaxWidth(680)
end
function CellActivityRedEnvelope:_adaptLanguage_es(  )
	local text = GetElement(self.m_root,"text_CellActivityRedEnvelope",WZUIFreeTextBox)
	text:setScale(0.7)
	text:setMaxWidth(600)
end
function CellActivityRedEnvelope:_adaptLanguage_pt(  )
	local text = GetElement(self.m_root,"text_CellActivityRedEnvelope",WZUIFreeTextBox)
	text:setScale(0.7)
	text:setMaxWidth(680)
end

function CellActivityRedEnvelope:_adaptLanguage_tr(  )
	local text = GetElement(self.m_root,"text_CellActivityRedEnvelope",WZUIFreeTextBox)
	text:setScale(0.7)
	text:setMaxWidth(680)
end

------------------------------------语言适配End--------------------------------------------
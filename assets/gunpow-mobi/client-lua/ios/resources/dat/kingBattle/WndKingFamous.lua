--WndKingFamous.lua
--@brief	WndKingFamous的UI模块
--@date		2015/5/12
--@author	Zjh
--@note

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKingFamous:onEnter(element)
	self.m_root = element

	self:_updateUI_static_txt()
end

----@brief onEnter函数执行完成回调
function WndKingFamous:onEnterTransitionDidFinish(element)
    --弹窗动画
    WindowManagerAni:createAction(self.m_root, true, "actionCallback", self)
end

----@brief    弹窗动画完成后的回调
function WndKingFamous:actionCallback(element, data)
	--初始化界面
	self:_testInit()
	self:_updateUI_dynamic()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKingFamous:onExit(element)
	self:_unInit()
end

--@brief	点击关闭按钮时被调用的函数
--@param	element:按钮绑定的UI节点引用
function WndKingFamous:onClose(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	WindowManagerAni:createCloseAction(self.m_root, "onActionCallBack", self)
end

--@brief	动画播完后的回调
function WndKingFamous:onActionCallBack()
	WindowManager:removeWindow(self.m_root, self, true)
end

--@brief	人物详细信息回调
--@param	element:表绑定的UI节点引用
function WndKingFamous:onFamousDetail(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	local heroId = element:getTag()
	WndCheckOther:show(heroId)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndKingFamous:_testInit()
	self.m_tData = {}
	local tData
	tData = {m_nSeason = 1 , m_nId = {GlobalGame.g_tPlayerInfo.nPlayerId,GlobalGame.g_tPlayerInfo.nPlayerId,GlobalGame.g_tPlayerInfo.nPlayerId} , m_nName = {"弹弹岛冠军","弹弹岛亚军","弹弹岛季军"} }
	table.insert(self.m_tData,tData)
	tData = {m_nSeason = 2 , m_nId = {GlobalGame.g_tPlayerInfo.nPlayerId,GlobalGame.g_tPlayerInfo.nPlayerId,GlobalGame.g_tPlayerInfo.nPlayerId} , m_nName = {"弹弹岛冠军1","弹弹岛亚军1","弹弹岛季军1"} }
	table.insert(self.m_tData,tData)
end

function WndKingFamous:_updateUI_dynamic()
	self:_initTable()
end

function WndKingFamous:_initTable()
	local tabElement = GetElement(self.m_root,"tabFamous_WndKingFamous",WZUITableContainer)
	for i=#self.m_tData,1,-1 do
		local data = self.m_tData[i]
		local element = WZUISystem:getInstance():createElement("CellKingFamous")
		element:setTag(i-1)
		tabElement:setCellElement(element)

		GetElement(element,"txtSeason_CellKingShowAward",WZUILabelTTF):setText( string.format( LocalStrings.WHAT_SEASON , data.m_nSeason ) )
		
		GetElement(element,"txtFirst_CellKingShowAward",WZUILabelTTF):setText( LocalStrings.FIRST_PLACE.."："..data.m_nName[1])
		GetElement(element,"txtSecond_CellKingShowAward",WZUILabelTTF):setText(LocalStrings.SECOND_PLACE.."："..data.m_nName[2])
		GetElement(element,"txtThird_CellKingShowAward",WZUILabelTTF):setText( LocalStrings.THIRD_PLACE.."："..data.m_nName[3])
		
		GetElement(element,"btnFirst_CellKingShowAward"):setTag(data.m_nId[1])
		GetElement(element,"btnSecond_CellKingShowAward"):setTag(data.m_nId[2])
		GetElement(element,"btnThird_CellKingShowAward"):setTag(data.m_nId[3])
	end
end

function WndKingFamous:_updateUI_static_txt()

	local tempElement = nil

	tempElement = GetElement(self.m_root,"txtTitle_WndKingFamous",WZUILabelTTF)
	tempElement:setText( LocalStrings.KING_FAMOUS )
end
-------------------------------------私有方法模块End----------------------------------------

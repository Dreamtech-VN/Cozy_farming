--CellFootballQuizBtn.lua
--@brief	CellFootballQuizBtn的UI模块
--@date		2018/05/31
--@author	yeruida
--@note		足球竞猜按钮


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function CellFootballQuizBtn:onEnter(element)
	self.m_root = element
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function CellFootballQuizBtn:onExit(element)
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function CellFootballQuizBtn:updata()
	local homeTeam = GDatatab_football_team["id_"..self.data.homeTeam].name
	local visitTeam = GDatatab_football_team["id_"..self.data.visitTeam].name
	GetElement(self.m_root,"txtTeam1_CellFootballQuizBtn",WZUILabelTTF):setText(homeTeam)
	GetElement(self.m_root,"txtTeam2_CellFootballQuizBtn",WZUILabelTTF):setText(visitTeam)
	local curTime = SystemTime:getServerTime()

	if self.data.status == 0 then
		if curTime >= self.data.matchStartLeaveTime then
			GetElement(self.m_root,"conState_CellFootballQuizBtn",WZUIContainer):setVisible(true)
			GetElement(self.m_root,"txtState_CellFootballQuizBtn",WZUILabelTTF):setText(LocalStrings.FOOTBALL_TEXT3)	
		else
			GetElement(self.m_root,"conState_CellFootballQuizBtn",WZUIContainer):setVisible(false)
		end
	else
		GetElement(self.m_root,"conState_CellFootballQuizBtn",WZUIContainer):setVisible(true)
		GetElement(self.m_root,"txtState_CellFootballQuizBtn",WZUILabelTTF):setText(LocalStrings.LABEL_END)		
	end
end

function CellFootballQuizBtn:setHighLight(bool)
	GetElement(self.m_root,"imgBtn1_CellFootballQuizBtn",WZUIImage):setVisible(not bool)
	GetElement(self.m_root,"imgBtn2_CellFootballQuizBtn",WZUIImage):setVisible(bool)
end

function CellFootballQuizBtn:onClickBack()
	SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	if self.m_tBack then
        self.m_tBack[2](self.m_tBack[1],self.data)
    end
end
-------------------------------------私有方法模块End----------------------------------------

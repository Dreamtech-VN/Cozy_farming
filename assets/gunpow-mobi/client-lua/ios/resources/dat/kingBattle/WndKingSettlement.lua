--WndKingSettlement.lua
--@brief	WndKingSettlement的UI模块
--@date		2015/5/12
--@author	Zjh
--@note

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndKingSettlement:onEnter(element)
	self.m_root = element

	self:_updateUI_static_txt()
	self:_testInit()
	self:_updateUI_dynamic()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndKingSettlement:onExit(element)
	self:_unInit()
end

--@brief	确定按钮回调
--@param	element:表绑定的UI节点引用
function WndKingSettlement:onSure(element)
    SoundManager:playEffectSound(SoundDefine.E_S_CLICK_BTN)
	
	WindowManager:removeWindow(self.m_root, self, true)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
function WndKingSettlement:_testInit()
	self.m_bWin = true
	
	self.m_tData =
	{
		{m_bWin = true , m_nId = 1 , m_nLevel = 39 , m_sName = "大神" , m_sServerName="S.2-霸气冲天" , m_nScore = "100" , m_nKingMoney = "50" },
		{m_bWin = false , m_nId = GlobalGame.g_tPlayerInfo.nPlayerId , m_nLevel = 39 , m_sName = "大神" , m_sServerName="S.2-霸气冲天" , m_nScore = "10" , m_nKingMoney = "5" },
	}
end

function WndKingSettlement:_updateUI_dynamic()
	if self.m_bWin then
		GetElement(self.m_root,"imgTitle_WndKingSettlement",WZUIImage):setFile("common/text/battle_hud_fightwin1.png")
	else
		GetElement(self.m_root,"imgTitle_WndKingSettlement",WZUIImage):setFile("common/text/battle_hud_fightlose1.png")
	end
	
	self:_initTable()
end

function WndKingSettlement:_initTable()
	local tabElement = GetElement(self.m_root,"tabSettlement_WndKingSettlement",WZUITableContainer)
	for i=1,#self.m_tData do
		local data = self.m_tData[i]
		local element = WZUISystem:getInstance():createElement("CellKingSettlement")
		element:setTag(i-1)
		tabElement:setCellElement(element)

		if data.m_nId == GlobalGame.g_tPlayerInfo.nPlayerId then
			GetElement(element,"imgMySelf_CellKingRank"):setVisible(true)
		end
		
		if data.m_bWin then
			GetElement(element,"imgResult_CellKingSettlement",WZUIImage):setFile("ui/kingBattle/win.png")
		else
			GetElement(element,"imgResult_CellKingSettlement",WZUIImage):setFile("ui/kingBattle/lose.png")
		end
		
		GetElement(element,"txtPlayer_CellKingSettlement",WZUIFreeTextBox):setShowText(string.format( [[<T C="255,255,0" S="22">Lv.%s</T><T C="255,255,255" S="22">%s</T>]] , data.m_nLevel, data.m_sName) )
		GetElement(element,"txtServer_CellKingSettlement",WZUILabelTTF):setText(data.m_sServerName)
		
		local moneyImg = GDatatab_item["id_"..4].icon
		GetElement(element,"txtAward_CellKingSettlement",WZUIFreeTextBox):setShowText(string.format( [[<T C="255,255,0" S="22" P="1">%s</T><T C="255,255,255" S="22" P="1">+%s    </T><I Z="0.3" P="1">%s</I><T C="255,255,255" S="22" P="1">+%s</T>]]  ,LocalStrings.KING_SCORE ,data.m_nScore, moneyImg, data.m_nKingMoney))
	end
end

function WndKingSettlement:_updateUI_static_txt()
	local tempElement = nil

	local txtTab =
	{
		{"txtWinLose_WndKingSettlement"	 ,LocalStrings.WIN_LOSE        	},
		{"txtPlayer_WndKingSettlement"   ,LocalStrings.PLAYER        	},
		{"txtServer_WndKingSettlement"   ,LocalStrings.WHERE_THE_SERVER },
		{"txtAward_WndKingSettlement"    ,LocalStrings.GET_AWARD	    },
		{"txtSure_WndKingSettlement"     ,LocalStrings.CONFIRM			},
	}
	for i=1,#txtTab do
		local txt = txtTab[i]
		tempElement = GetElement(self.m_root,txt[1],WZUILabelTTF)
		tempElement:setText(txt[2])
	end
end
-------------------------------------私有方法模块End----------------------------------------

--WndCopyGuildInfoView.lua
--@brief	WndCopyGuildInfoView的UI模块
--@date		2018/10/26
--@author	yrd
--@note		公会副本ui


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCopyGuildInfoView:onEnter(element)
	self.m_root = element

	self:_initUI()
    self:_initEvent()
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCopyGuildInfoView:onExit(element)
	self:_removeEvent()
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndCopyGuildInfoView:_initUI()
    local boss  = WBattleGlobal:getCurrent():getBossArray()
    local bossBigSkillRound = boss[1].m_tAiScript[1][3].condition[1].conditionParm1

	GetElement(self.m_root, "txt1_WndCopyGuildInfoView", WZUILabelTTF):setText(LocalStrings.GUILD_BOSS_WIN_HURT..":")
	GetElement(self.m_root, "txt3_WndCopyGuildInfoView", WZUILabelTTF):setText(LocalStrings.KING_REST_TIMES)

	GetElement(self.m_root, "txt2_WndCopyGuildInfoView", WZUILabelTTF):setText(0)
	GetElement(self.m_root, "txt4_WndCopyGuildInfoView", WZUILabelTTF):setText(bossBigSkillRound - 1)
end




-------------------------------------私有方法模块End----------------------------------------

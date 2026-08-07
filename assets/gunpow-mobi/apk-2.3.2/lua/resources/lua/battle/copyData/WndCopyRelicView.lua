--WndCopyRelicView.lua
--@brief	WndCopyRelicView的UI模块
--@date		2019/07/26
--@author	yrd
--@note		遗迹副本战斗信息界面


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	进入场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景进入前的准备工作
function WndCopyRelicView:onEnter(element)
	self.m_root = element

	self:_initUI()
    self:_initEvent()

    AdaptLanguage(self)
end

--@brief	退出场景时被调用的函数
--@param	element:表绑定的UI节点引用
--@note		在这里做场景退出前的清理工作
function WndCopyRelicView:onExit(element)
	self:_removeEvent()
	self:_unInit()
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

function WndCopyRelicView:_initUI()
    local boss  = WBattleGlobal:getCurrent():getBossArray()

    local maxNum = 0
    if WBattleGlobal:getCurrent().m_nBattleType == BattleConstants.g_nBATTLE_TYPE_BOSS then
        if WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODEL_GUILD_STATE then
            maxNum = boss[1].m_tAiScript[1][3].condition[1].conditionParm1 - 1 --boss第几次会放高伤害子弹
        elseif WBattleGlobal:getCurrent().battleMode == BattleConstants.g_tBossBattleMode.MODE_REMAINSBOSS then
            maxNum = CacheCenter:getGameParam().digdungeonRound
        end
    end

	GetElement(self.m_root, "txt1_WndCopyRelicView", WZUILabelTTF):setText(LocalStrings.GUILD_BOSS_WIN_HURT..":")
	GetElement(self.m_root, "txt3_WndCopyRelicView", WZUILabelTTF):setText(LocalStrings.TEAMBOSS_TEXT24)

	GetElement(self.m_root, "txt2_WndCopyRelicView", WZUILabelTTF):setText("0(0%)")
	GetElement(self.m_root, "txt4_WndCopyRelicView", WZUILabelTTF):setText(maxNum.."/"..maxNum)
end




-------------------------------------私有方法模块End----------------------------------------


-------------------------------------语言适配begin----------------------------------------
function WndCopyRelicView:_adaptLanguage_vn()
    GetElement(self.m_root, "txt1_WndCopyRelicView", WZUILabelTTF):setScale(0.8)
    GetElement(self.m_root, "txt3_WndCopyRelicView", WZUILabelTTF):setScale(0.8)
end
-------------------------------------语言适配End----------------------------------------
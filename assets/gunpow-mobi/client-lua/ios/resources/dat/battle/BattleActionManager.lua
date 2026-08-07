-- BattleActionManager.lua
--@brief	动作管理
--@date  	2014/01/08
--@author 	TaoYinqing

BattleActionManager = {}

local g_tBattaleActionManager = nil

--@brief	获得当前的动作管理器
--@return	#1, 返回当前的动作管理器
function BattleActionManager:currentManager()
	if g_tBattaleActionManager == nil then
		g_tBattaleActionManager = {}
		setmetatable(g_tBattaleActionManager,{__index = BattleActionManager})
		g_tBattaleActionManager.m_tAction = {}
		g_tBattaleActionManager.m_nActionIdSeed = 1
	end
	return g_tBattaleActionManager
end

--@brief	做时间滴答调用
--@param	nDt	上一桢到当前桢过去的时间
function BattleActionManager:update(nDt)
	local removeIds = {}
	for k,v in pairs(self.m_tAction) do
		v:update(nDt)
		if v:isDone() then
			removeIds[v:getActionId()] = v:getActionId()
		end
	end
	for k,v in pairs(removeIds) do
		self.m_tAction[v] = nil
	end
end

--@brief	添加动作
--@param	tAction 动作表
function BattleActionManager:addAction(tAction)
	--tAction.m_nActionId = self.m_nActionIdSeed
	tAction:setActionId(self.m_nActionIdSeed)
    self.m_nActionIdSeed = self.m_nActionIdSeed + 1
	self.m_tAction[tAction:getActionId()] = tAction
end

--@brief	删除动作
--@param	nActionId 	动作的id 在添加动作的时候 会给其分配一个id  保存在成员变量m_nAction	Id里面
function BattleActionManager:removeAction(nActionId)
	self.m_tAction[nActionId] = nil
end
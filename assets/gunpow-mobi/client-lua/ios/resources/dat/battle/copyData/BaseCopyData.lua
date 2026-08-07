--BaseCopyData.lua
--@brief    副本数据
--@date     2015/06/25
--@note     经副本显示信息与胜利条件控制

BaseCopyData = {}

--@brief    以本表为模版创建一个新的表实例对象
--@return   新建的表实例对象
function BaseCopyData:new()
    local tNewObj = {}
    setmetatable(tNewObj, { __index = BaseCopyData })
    self:_init()
    return tNewObj
end

--@brief    初始化对象
function BaseCopyData:_init()
    self.m_viewNode = nil  --信息面板容器
    self.m_buildGuaiIndex = -10000 
end

--@brief 创建显示信息
--@return 显示面板
function BaseCopyData:getInfoView()
    if not self.m_viewNode then
        self.m_viewNode = WZUIContainer:create()
    end
    return self.m_viewNode
end

--@创建怪物id
function BaseCopyData:getBuildGuaiIndex()
    return self.m_buildGuaiIndex
end

function BaseCopyData:addBuildGuaiIndex()
    self.m_buildGuaiIndex = self.m_buildGuaiIndex - 1
end


--@brief 杀死怪物
function BaseCopyData:killMonster(monsterId,battleId,pos)
end

--@brief 销毁
function BaseCopyData:destroy()
    if self.m_viewNode and self.m_viewNode.getParent() then
        self.m_viewNode.removeFromParentAndCleanup(true)
    end
    self.m_viewNode = nil
end

--@brief 回合开始前准备
function BaseCopyData:readyStartRound()
end

function BaseCopyData:processReadyStartRound(dt)
    return true
end

function BaseCopyData:doneReadyStartRound()
end

--@brief 回合开始
function BaseCopyData:updateByTurn()

end

--@brief 移动镜头
function BaseCopyData:zoomTo(target,isfollow)
    local msg = MsgManager:createMsg(BattleMsgZoomToHero)
    msg.m_nPlayerId = target:getId()
    msg.m_nPlayerPos = target:getPosition()
    msg.m_bIsFollow = isfollow or false
    MsgManager:pushPriorMsg(msg)
     --local isZoom = BattleScreen:zoomToHero(target:getId() , target:getPosition())
     --return isZoom
end

--@brief 结束条件判断
--@return 1 胜利 2 失败
function BaseCopyData:checkIsEnd()
    return 0
end

--@brief 副本结束处理
function BaseCopyData:copyEnd()
    WZLog("BaseCopyData:copyEnd")
    self.m_bIsEnd = true
end
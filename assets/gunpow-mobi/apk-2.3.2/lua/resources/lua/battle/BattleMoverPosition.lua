--BattleMoverPosition.lua
--@brief	移动轨迹模拟物理层
--@date		2014/03/06
--@author	TaoYinqing


--@brief	移动轨迹模拟数据表
BattleMoverPosition = {
	m_tPosition = nil ,     --当前位置
    m_tPrePosition = nil ,  --上一次位置
    m_tSpeed = nil,         --速度
    m_tAcceleration = nil,  --加速度
}

-------------------------------------公有方法模块--------------------------------------
--@brief    创建方法
--@return   #1,返回新的对象
function BattleMoverPosition:create()
    local obj = {}
    setmetatable(obj,{__index = BattleMoverPosition})
    
    --init obj member variable
    obj.m_tPosition = {x = 0, y = 0}
    obj.m_tPrePosition = {x = 0, y = 0}
    obj.m_tSpeed = {x = 0, y = 0}
    obj.m_tAcceleration = {x = 0, y = 0}
    
    return obj;
end

--@brief    设置位置
--@param    tPos 位置
function BattleMoverPosition:setPosition(tPos)
   self.m_tPosition.x,self.m_tPosition.y = tPos.x,tPos.y
end

--@brief    获得当前位置
--@return   #1,当前位置
function BattleMoverPosition:getPosition()
    return {x = self.m_tPosition.x,y = self.m_tPosition.y}
end

--@brief    设置速度
--@param    tPos 速度
function BattleMoverPosition:setSpeed(tSpeed)
   self.m_tSpeed.x,self.m_tSpeed.y = tSpeed.x,tSpeed.y
end

--@brief    设置加速度
--@param    tPos 加速度
function BattleMoverPosition:setAcceleration(tAcc)
    self.m_tAcceleration.x,self.m_tAcceleration.y = tAcc.x,tAcc.y
end

--@brief    更新位置
function BattleMoverPosition:updatePosition()
   --[[
    m_speed+=m_acceleration;
    
    m_prePosition=m_position;
    m_position+=m_speed;
    --]]
    self.m_tSpeed.x = self.m_tSpeed.x + self.m_tAcceleration.x
    self.m_tSpeed.y = self.m_tSpeed.y + self.m_tAcceleration.y
    
    self.m_tPrePosition.x,self.m_tPrePosition.y = self.m_tPosition.x,self.m_tPosition.y
    
    self.m_tPosition.x = self.m_tPosition.x + self.m_tSpeed.x
    self.m_tPosition.y = self.m_tPosition.y + self.m_tSpeed.y
end

-------------------------------------私有方法模块--------------------------------------

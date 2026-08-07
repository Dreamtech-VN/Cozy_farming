--BattleMsgTemplate.lua
--@brief	战斗相关消息
--@date		2013/12/31
--@author	李俊鸿
--@note		示例模板

--@brief	消息数据表
BattleMsgTemplate = {
    m_sName = "BattleMsgTemplate",
}

-------------------------------------公有方法模块--------------------------------------

--@brief	消息初始化函数
--@note		消息系统第一次调用process函数前调用
function BattleMsgTemplate:init()
end

--@brief	消息处理过程函数
--@return	#1,nil或true表示消息处理结束，否则返回false
--@note		未处理结束消息的process函数将会再次被调用，直到处理结束
function BattleMsgTemplate:process()
end

--@brief	消息处理完成函数
--@note		消息系统最后一次调用process函数后调用
function BattleMsgTemplate:done()
end

-------------------------------------私有方法模块--------------------------------------

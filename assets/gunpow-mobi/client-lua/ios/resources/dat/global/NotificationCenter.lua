--NotificationCenter.lua
--@brief	通知中心
--@date		2014/11/12
--@author	xiaoyu.wu
--@note		通知中心用来传递消息，有事件发生的对象可以发送消息给注册过这个事件的对象

--通知名称定义


--通知中心表
NotificationCenter = {
    m_tRegisterInfoMap = {}, --存储所有的注册信息,key为通知名，value为所有注册过该通知的对象的注册信息列表
}

--通知数据表，在通知触发后回调时作为入参返回
Notification = {
    sName = nil,   --通知名称，避免重名
    tUserData = nil,   --通知附带的用户数据，由各个通知本身决定
}

--存储注册信息的数据表
RegisterInfo = {
    tLuaObj = nil,  --回调的lua对象
    fCallback = nil,  --回调方法
}

-------------------------------------公有方法模块Begin--------------------------------------
--@brief	发送通知
--@param    sName：通知名称
--@param    tUserInfo：用户数据
--@note     发送通知时，会向所有注册过该通知的名称的对象发送通知
function NotificationCenter:sendNotification(sName, tUserInfo)
    local notication = {
        sName = sName,
        tUserInfo = tUserInfo
    }
    
    local tList = self.m_tRegisterInfoMap[sName] or {}
    for i,v in ipairs(tList) do
        v.fCallback(v.tLuaObj, notication)
    end
end

--@brief	注册通知
--@param    sName：注册的通知的名称
--@param    tLuaObj：回调的lua表对象
--@param    fCallback：回调方法
--@note     当有对象发送同名通知的时候，会回调到指定的lua表对象的指定方法里去，回调参数为通知对象tNotification
function NotificationCenter:registerNotification(sName, tLuaObj, fCallback)
    self.m_tRegisterInfoMap[sName] = self.m_tRegisterInfoMap[sName] or {}
    local tRegisterInfo = {
        tLuaObj = tLuaObj,
        fCallback = fCallback
    }
    table.insert(self.m_tRegisterInfoMap[sName], tRegisterInfo)
end

--@brief    反注册通知
--@param    sName：反注册的通知的名称，为空时，会反注册lua对象注册的所有通知
--@param    tLuaObj：反注册的lua表对象
--@note     不用时及时反注册，以便内存释放，尤其是注册的表为非全局表时
function NotificationCenter:unregisterNotification(sName, tLuaObj)
    if sName == nil then
        for _,tList in pairs(self.m_tRegisterInfoMap) do
            self:_removeLuaObjFromList(tLuaObj, tList)
        end
    else
        local tList = self.m_tRegisterInfoMap[sName]
        self:_removeLuaObjFromList(tLuaObj, tList)
    end
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------
--@brief    从一个列表中删除注册对象
--@param    tLuaObj,要删除的对象
--@param    tList,列表
function NotificationCenter:_removeLuaObjFromList(tLuaObj, tList)
	if tList == nil then  return end
    for i,v in ipairs(tList) do
        if v.tLuaObj == tLuaObj then
            table.remove(tList, i)
        end
    end
end

-------------------------------------私有方法模块End----------------------------------------

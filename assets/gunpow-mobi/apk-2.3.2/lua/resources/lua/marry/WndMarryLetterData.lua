--WndMarryLetterData.lua
--@brief	WndMarryLetter的数据模块
--@date		2014/01/08
--@author	叶威
--@note		求婚信

WndMarryLetter = {
	--请不要在这里定义变量
}

--@brief 窗口类型
WndMarryLetter.wndType = {
    SEND_LETTER = 0,      --发的求婚信
    RECV_LETTER = 1,      --接收到的求婚信
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMarryLetter:_init()
	self.m_root = nil	 	  			--场景根节点
    self.m_nMarryType = 0               --求婚类型，定义查看WndMarryManager
    self.m_nWindowType = 0              --窗口类型
    self.m_nCoupleId = 0                --求婚对象的ID
    self.m_nSendHeadId = 0
    self.m_nSendFaceId = 0
    self.m_nPlyaerId = nil
    self.m_nHeadColor = nil
    self.m_nFriendliness = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMarryLetter:_unInit()
	self.m_root = nil
    self.m_nMarryType = nil
    self.m_nWindowType = nil
    self.m_nCoupleId = nil
    self.m_nSendHeadId = nil
    self.m_nSendFaceId = nil
    self.m_nPlyaerId = nil
    self.m_nFriendliness = nil
    self.m_nHeadColor = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMarryLetter:createElement()
    if WndMarryLetter.m_root ~= nil then
        WindowManager:removeWindow(WndMarryLetter.m_root, WndMarryLetter, true)
    end
	local element = WZUISystem:getInstance():createElement("WndMarryLetter")
	assert(element, "WndMarryLetter create element failed!")
	self:_init()
	return element
end

--@brief	设置求婚类型
--@param    nType:求婚类型，字段参看WndMarry模块定义
function WndMarryLetter:setMarryType(nType)
    WZLog("WndMarryLetter:setMarryType")
    self.m_nMarryType = nType
    WZLog(self.m_nMarryType)
end

--@brief	设置窗口类型
--@param    nType:窗口类型
function WndMarryLetter:setWindowType(nType)
    self.m_nWindowType = nType
end

--@breif   获得求婚信/结婚函时的处理函数
--@brief marryRecordId :结婚纪录Id
--@brief sendName : 发送人名称
--@brief marryType : 信物Id
function WndMarryLetter:getMarryLetterFromOther(marryRecordId, sendName, marryType,sendFaceId,sendHeadId,playerId,headColor)
    WZLog("WndMarryLetter:getMarryLetterFromOther =",sendFaceId,sendHeadId)
    self.m_sCoupleName = sendName
    self.m_nCoupleId = marryRecordId
    self.m_nMarryType = marryType
    self.m_nSendHeadId = sendHeadId
    self.m_nSendFaceId = sendFaceId
    self.m_nPlyaerId = playerId
    self.m_nHeadColor = headColor
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------




-------------------------------------私有方法模块End----------------------------------------

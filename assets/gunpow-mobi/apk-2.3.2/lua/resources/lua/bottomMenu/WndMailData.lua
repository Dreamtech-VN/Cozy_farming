--WndMailData.lua
--@brief	WndMail的数据模块
--@date		2013/12/09
--@author	liangguang_long
--@note     邮件模块

WndMail = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMail:_init()
    WZLog("WndMail:_init()")
	self.m_root = nil	 	  		 --场景根节点
	self.m_nOpenTag = 1              --邮件打开标识，1收件箱，2发件箱，3商城
	self.t_editMail = {}             --当前编写邮件的信息
	self.m_tCurOpenMail = {}         --当前打开的邮件
	self.m_tCurOpenCell = {}         --当前打开的邮件的cell
	self.m_nCountSelMailNum = 0      --当前被选中的邮件数量
	self.n_editMailId = -99          --编写邮件的Id
	self.m_nDeleteMailType = 0       --删除邮件的类型
	self.n_curPage = 1               --当前的页数
	self.m_tMailList = {}            --邮件当前的列表
	self.turnPage = "down"			 --当前所处的状态
	self.b_isEdit = false            --是否处于编辑状态
	self.n_mailNum = 0              --当前界面邮件总数
end

--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMail:_unInit()	
	self.m_root = nil
	self.m_nOpenTag = nil
	self.t_editMail = nil
	self.m_tCurOpenMail = nil
	self.m_tCurOpenCell = nil
	self.m_nCountSelMailNum = nil
	self.n_editMailId = nil
	self.m_nDeleteMailType = nil
	self.n_curPage = nil
	self.m_tMailList = nil
	self.turnPage = nil
	self.b_isEdit = nil
	self.n_mailNum = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMail:createElement()
	local element = WZUISystem:getInstance():createElement("WndMail")
	assert(element, "WndMail create element failed!")
	self:_init()
	return element
end

function WndMail:getCheckIndex()
	return self.m_nCheckBox
end

--@brief	设置是否为打开邮件
--@note		bIsOpen：true为大开邮件状态，false为未打开邮件状态
function WndMail:setIsOpenMail( bIsOpen )
	self.m_bOpen = bIsOpen
	
end

--@brief	获取邮件是否为打开状态
--@note		true为大开邮件状态，false为未打开邮件状态
function WndMail:getIsOpenMail()
	return self.m_bOpen
end

function WndMail:setNearBackFun(tCell,backFun)
	self.m_tNearBack = {}
	table.insert(self.m_tNearBack,tCell)
	table.insert(self.m_tNearBack,backFun)
end

function WndMail:showFriendBackFun(tCell,backFun)
	self.m_tFriendBackFun = {}
	table.insert(self.m_tFriendBackFun,tCell)
	table.insert(self.m_tFriendBackFun,backFun)
end
-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------

--@brief	判断是否显示上一页函数
--@note		当前页大于1的时候显示上一页，否则不显示
function WndMail:_getUpPage()
	WZLog("WndMail:_getUpPage", self.n_curPage)
	if self.n_curPage > 1 then
		return true
	end
    return false
end

--@brief	判断是否显示下一页函数
--@note		当前页小于总页数的时候显示下一页，否则不显示
function WndMail:_getDownPage()
	WZLog("WndMail:_getDownPage", self.n_mailNum)
	if self.n_mailNum > self.n_curPage*NUMBER_FRIEND_PAGE then
		return true
	end
    return false
end

--@brief	判断是否显示上一页函数
--@note		当前页大于1的时候显示上一页，否则不显示 
function WndMail:_getMailUpPage( )
    self.n_curPage = self.n_curPage - 1
    self.turnPage = "up"
    self:_createMailMenuList()
end

--@brief	判断是否显示下一页函数
--@note		当前页小于总页数的时候显示下一页，否则不显示  
function WndMail:_getMailDownPage()
    self.n_curPage = self.n_curPage + 1
    self.turnPage = "down"
    self:_createMailMenuList()
end

function WndMail:_getMailType()
	return self.m_nMailType
end

function WndMail:setOpenMailId(tag)
	if tag == 0 then
		tag = 0 
	else
		tag = tag - 1 
	end
	local nMailId , sName , sTheme , nMailId , nMailType,nRead = self:_getWndMailInfoData( tag )
	self.m_nCurOpenMailId = nMailId 	 --当前打开邮件的ID
end
-------------------------------------私有方法模块End----------------------------------------

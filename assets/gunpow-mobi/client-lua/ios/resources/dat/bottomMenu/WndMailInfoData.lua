--WndMailInfoData.lua
--@brief	WndMailInfo的数据模块
--@date		2013/12/10
--@author	liangguang_long
--@note     读邮件内容模块

WndMailInfo = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMailInfo:_init()
	self.m_root = nil	  	 --场景根节点
	self.m_sSendName = nil   --邮件者
	self.m_sTheme = nil      --邮件主题
	self.m_sComtent = nil    --邮件内容
	self.m_sSendTime = nil   --邮件时间
	self.m_nMailType = 0   --邮件类型
	self.m_sRemark = nil     --邮件附带信息一般为url
	self.m_nCurPage = nil    --当前页
	self.m_nMailId = nil     --邮件编号
	self.m_nCurIndex = 0     --当前按下的复选框索引
	self.m_nLoadingId = nil  --加载框ID
	self.m_tColseFun = nil 	 --关闭回调列表
	self.m_nTag = nil 
	self.m_nSenderId = 0 
end


--@brief	初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMailInfo:_unInit()
	self.m_root = nil	
	self.m_sSendName = nil   --邮件者
	self.m_sTheme = nil      --邮件主题
	self.m_sComtent = nil    --邮件内容
	self.m_sSendTime = nil   --邮件时间
	self.m_nMailType = nil   --邮件类型
	self.m_sRemark = nil     --邮件附带信息一般为url
	self.m_nCurPage = nil      --当前页
	self.m_nMailId = nil     --邮件ID
	self.m_nCurIndex = nil     --当前按下的复选框索引
	self.m_nLoadingId = nil  --加载框ID
	self.m_tColseFun = nil 	 --关闭回调列表
	self.m_nTag = nil 
	self.m_nSenderId = nil 
end

-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMailInfo:createElement()
	local element = WZUISystem:getInstance():createElement("WndMailInfo")
	assert(element, "WndMailInfo create element failed!")
	self:_init()
	return element
end

--@brief	从获取邮件内容协议返回成功回调函数获取数据
--@return	#1，content:邮件内容
--@return	#2，sendTime:发送时间
--@return	#3，remark:邮件附带信息一般为url
--@note     更新界面数据，和显示删除回复按钮
function WndMailInfo:setMailContent(content, sendTime, remark,renderId)
	if self.m_root == nil then 
	return 
	end
	WZLog("WndMailInfo:setMailContent:",renderId)
	self.m_sComtent = content     --邮件内容
	self.m_sSendTime = sendTime   --邮件时间
	self.m_sRemark = remark       --邮件附带信息一般为url
	self.m_nSenderId = renderId
	--更新界面
	self:_update()
end

--@brief	从WndMail上获取数据
--@return	#1，sSender:名称
--@return	#2，sTheme:主题
--@return	#3，_mailId:邮件ID
--@return	#5， nPage:当前页数
function WndMailInfo:setMailCellAllElement(sSender , sTheme , mailId , nMailType , nPage , index )
		WZLog("page",nPage)
	if self.m_root == nil then 
		return 
	end
	self.m_sSendName = sSender   --邮件者
	self.m_sTheme = sTheme       --邮件主题
	self.m_nMailId = mailId      --邮件ID
	self.m_nCurPage = nPage      --当前页数
	self.m_nMailType = nMailType --邮件类型
	self.m_nTag = index
	
	--如果是收件箱就显示删除好回复按钮，如果是发件箱就显示删除按钮
	self:_showDelRecevieBtn()
	self:_update()	--更新函数	
end

--@brief	从邮件界面中获取按下的复选框的索引
--@return	#1，nIndex:当前复选框组按下的索引
--@note     用于判断是读取发件箱邮件还是读取收件箱邮件
function WndMailInfo:setCurCheckBoxIndex( nIndex )
	if self.m_root == nil then 
		return 
	end
	self.m_nCurIndex =  nIndex      --当前按下的复选框索引
	--如果打开是发件箱,更换打开邮件内容标题
	if nIndex == 2 then 
		self:_changTitleImg( nIndex )    
	end
	
end

--@brief	设置关闭回调函数
function WndMailInfo:setColseBackFun(tCell,backFun)
	self.m_tColseFun = {}
	table.insert(self.m_tColseFun,tCell)
	table.insert(self.m_tColseFun,backFun)
end

--@brief	设置文本内容属性
function WndMailInfo:_setTxt(tCell,desc)
	if self.m_root == nil or tCell == nil then
		return
	end
	desc = desc or ""
	tCell = WZUILabelTTF:luaTo(tCell)
	tCell:setText(desc)
	tCell = nil
end


--@brief	适配控件属性
function WndMailInfo:_setTxtPro(tCell,tCellValue,tCellAdd)
	if self.m_root == nil or tCell == nil or tCellValue == nil then
		return
	end
	tCell = WZUILabelTTF:luaTo(tCell)
	tCellValue = WZUILabelTTF:luaTo(tCellValue)
	local nDir = 8
	local tCellSize = tCell:getContentSize()
	local tCellPt = tCell:getRelativePosition()
	local lpSize = tCell:getParentElement():getContentSize()
	local x = tCellPt.x + ( tCellSize.width + nDir )/lpSize.width
	tCellValue:setRelativePosition(GlobalMethod:ccp(x,tCellPt.y))
	if tCellAdd then
		local size = tCellValue:getContentSize()
		local x = x + ( size.width + nDir )/lpSize.width
		tCellAdd:setRelativePosition(GlobalMethod:ccp(x,tCellPt.y))
	end
	tCell = nil 
	tCellValue = nil
	tCellAdd = nil 
end

-------------------------------------公有方法模块End----------------------------------------







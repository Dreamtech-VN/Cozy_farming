--WndWelcomeBackDescData.lua
--@brief	WndWelcomeBackDesc的数据模块
--@date		2023/03/09
--@author	yrd
--@note		欢迎回来活动说明

WndWelcomeBackDesc = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndWelcomeBackDesc:_init()
	self.m_root = nil	 	  			--场景根节点
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndWelcomeBackDesc:_unInit()
	self.m_root = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndWelcomeBackDesc:createElement()
	if WndWelcomeBackDesc.m_root ~= nil then
		WindowManager:removeWindow(WndWelcomeBackDesc.m_root, WndWelcomeBackDesc, true)
	end
	local element = WZUISystem:getInstance():createElement("WndWelcomeBackDesc")
	assert(element, "WndWelcomeBackDesc create element failed!")
	self:_init()
	return element
end

--@brief	转换规则说明内容，用于区分换行
--@param    #1 desc:规则说明内容
function WndWelcomeBackDesc:_changeDesc( desc )
	if desc == nil or desc == "" then
		return
	end
	local sDesc = ""
	local txt = desc
	local fileTxt = "\\n"
	local nLen = string.len( txt )
	local txtLen = string.len( fileTxt )
	local pos = 1
	
	for i = 1 , nLen do
		local nPos = string.find( txt , fileTxt , pos )
		if nPos ~= nil then --如果还找到数据，就添加数据
			local newDesc = string.sub( txt , pos , nPos - txtLen - nLen )
			txt = string.sub( txt , nPos + txtLen )
			nLen = string.len( txt )
			if i == 1 then
				sDesc = newDesc 
			else
				sDesc = sDesc .. "\n" .. newDesc 
			end
		else	--如果找不好数据，添加最后的数据
			sDesc = sDesc .. "\n" .. txt 
			return sDesc
		end
	end
	return sDesc
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

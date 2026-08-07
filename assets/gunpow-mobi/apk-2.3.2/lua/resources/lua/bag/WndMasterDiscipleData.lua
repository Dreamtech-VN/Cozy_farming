--WndMasterDiscipleData.lua
--@brief	WndMasterDisciple的数据模块
--@date		2021/09/02
--@author	hyx
--@note		师徒和徒弟共存的时候tips

WndMasterDisciple = {
	--请不要在这里定义变量
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndMasterDisciple:_init()
	self.m_root = nil	 	  			--场景根节点
	self.m_tDiscipleData = {}
	self.m_tMasterData = {}
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndMasterDisciple:_unInit()
	self.m_root = nil
	self.m_tDiscipleData = {}
	self.m_tMasterData = {}
end

function WndMasterDisciple:setData(data1, data2)
	self.m_tDiscipleData = data1
	self.m_tMasterData = data2
end
-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndMasterDisciple:createElement()
	if WndMasterDisciple.m_root ~= nil then
		WindowManager:removeWindow(WndMasterDisciple.m_root, WndMasterDisciple, true)
	end
	local element = WZUISystem:getInstance():createElement("WndMasterDisciple")
	assert(element, "WndMasterDisciple create element failed!")
	self:_init()
	return element
end

-------------------------------------公有方法模块End----------------------------------------


-------------------------------------私有方法模块Begin--------------------------------------





-------------------------------------私有方法模块End----------------------------------------

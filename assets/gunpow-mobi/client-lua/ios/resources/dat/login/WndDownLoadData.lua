--WndDownLoadData.lua
--@brief	WndDownLoad的数据模块
--@date		2015-8-17
--@author	binshao
--@note		登陆加载

WndDownLoad = {

}

--下载标识
WndDownLoad.DownloadFlag =
{
    DOWNLOADFLAG_NORUPDATE = 1, --正在下载正常的更新包
    DOWNLOADFLAG_EXTENDUPDATE = 2 --正在下载增量包
}

--@brief	定义并初始化表的成员变量
--@note		变量的定义和初始化必须在这里完成,外部无需调用该方法
function WndDownLoad:_init()
	WZLog("WndDownLoad:_init")
	self.m_root = nil					--场景根节点
    self.isShowDownloadTips = false    --是否已弹出过下载提示界面
	self.lastestVersion = nil			--如果一次更新多个版本，lastVersion指当前更新版本的上一个版本
	self.finishDownloadSize = 0 		--已经完成下载的更新包的总大小
	self.lastPackageSize = 0   			--上一个版本的更新包大小
	self.progBar_percentage = 0
	self.sumSize = 0
    self.downloadFlag = 2
    self.isEverShowTipDialog = false	--是否已经出现过对话框，如果出现过一次则不出现第二次
	self.isEverDownloadFile = false		--判断是否有下载过资源，有的话要进行reloadall
    self.m_bIsHaveExtendUpdate = false   --是否有增量资源要更新
    self.m_bIsHaveNormalUpdate = false   --是否有动态更新的资源
    self.m_nDownLoadSize = 0             --下载计数器大小
    self.PrelastBarIndex = 0
    self.downloadSize = 0
    self.m_nAccountInfo = nil
    self.m_nInfoTask = -1
    self.m_nInfoTaskForId = -1
    self.m_nInfoChangeTask = -1
    self.imgDescTime = 0            -- 图片计时
    self.tipsDescTime = 0           -- 提示计时
    self.m_loader = nil
    self.bLoadEnd = nil
    self.scheduleTime = 0
    self.checkUpdate = false        -- 是否检查过更新

    self.maxDownCnt = 0             -- 需要更新包的数量
    self.curDownCnt = 0             -- 当前已更新包的数量
    self.t_utilsAdapter = nil
end


--@brief	反初始化表的成员变量
--@note		在退出场景时回调的onExit函数里面必须调用本函数
function WndDownLoad:_unInit()
	WZLog("WndDownLoad:_unInit")
	self.m_root = nil
    self.isShowDownloadTips = nil
	self.lastestVersion = nil		
	self.finishDownloadSize = 0
	self.lastPackageSize = 0    		
	self.progBar_percentage = 0
	self.sumSize = 0
    self.downloadFlag = 2
    self.isEverShowTipDialog = false
	self.isEverDownloadFile = false
    self.m_bIsHaveExtendUpdate = false   --是否有增量资源要更新
    self.m_bIsHaveNormalUpdate = false   --是否有动态更新的资源
    self.m_nDownLoadSize = 0            -- 需要下载的资源大小
    self.downloadSize = 0
    self.m_nAccountInfo = nil
    self.m_nInfoTask = -1
    self.m_nInfoTaskForId = -1
    self.m_nInfoChangeTask = -1
    self.imgDescTime = 0
    self.m_loader = nil
    self.bLoadEnd = nil
    self.scheduleTime = 0
    self.checkUpdate = false

    self.maxDownCnt = nil
    self.curDownCnt = nil

      self.t_utilsAdapter = nil
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDownLoad:createElement()
	local element = WZUISystem:getInstance():createElement("WndDownLoad")
	assert(element, "WndDownLoad create element failed!")
	self:_init()
	return element
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
-------------------------------------私有方法模块End----------------------------------------
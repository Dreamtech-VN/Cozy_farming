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
    self.m_sObbFilePath = nil        --android obb扩展资源包路径
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
    self.m_sObbFilePath = nil        --android obb扩展资源包路径
end


-------------------------------------公有方法模块Begin--------------------------------------

--@brief	创建场景
--@return	#1，场景element的引用
--@note		请仅用此方法创建场景
function WndDownLoad:createElement()
	local element = WZUISystem:getInstance():createElement("WndDownLoad")
	assert(element, "WndDownLoad create element failed!")
	self:_init()
    self:initObbFilePath()
	return element
end
-------------------------------------公有方法模块End----------------------------------------

-------------------------------------私有方法模块Begin--------------------------------------
function WndDownLoad:initObbFilePath()
    WZLog("WndDownLoad:initObbFilePath")
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    if platForm == 2 and ProjConfig.USE_DOWNLOAD_OBB  and ProjConfig.USE_DOWNLOAD_OBB > 0 then --android
        WZLog("WndDownLoad:initObbFilePath", platForm)
        --适配android9+ targesdkVersion = 29时,由于存储权限更改无法再获取原先/Adnroid/obb/包名/******.obb文件读写权限
        --作兼容处理，没有以上权限则读写/Android/data/包名/cache或files下文件
        local obbFilePath = WZDeviceInfo:getExpansionFileName()        
        local isObbExist = WZFileUtil:isFileExist(obbFilePath)
        WZLog("WndDownLoad:initObbFilePath 1-1", tostring(isObbExist), obbFilePath)          
        if isObbExist == true then
            self.m_sObbFilePath = obbFilePath
            WZLog("WndDownLoad:initObbFilePath 1-1 m_sObbFilePath", self.m_sObbFilePath)
            return
        end

        local obbFilePathCache = ""
        local isObbExistCache = false
        local fileName = SplitStringWithSeparator(obbFilePath, "/")
        if #fileName >= 1 then
            obbFilePathCache = CCFileUtils:sharedFileUtils():getTmpWritablePath() .. fileName[#fileName]
            isObbExistCache = WZFileUtil:isFileExist(obbFilePathCache)
        end

        WZLog("WndDownLoad:initObbFilePath 1-2", tostring(isObbExistCache), obbFilePathCache)
        if isObbExistCache == true and #obbFilePathCache > 0 then
            self.m_sObbFilePath = obbFilePathCache
            WZLog("WndDownLoad:initObbFilePath 1-2 m_sObbFilePath ", self.m_sObbFilePath)
            return
        end
        
        local makeDownloadPath = self:makeFileDirectory(obbFilePath)
        if makeDownloadPath == true then
            self.m_sObbFilePath = obbFilePath
            WZLog("WndDownLoad:initObbFilePath 2-1", self.m_sObbFilePath)
        else
            self.m_sObbFilePath = obbFilePathCache
            WZLog("WndDownLoad:initObbFilePath 2-2", self.m_sObbFilePath)
        end
    end
end

--@brief    创建目录
function WndDownLoad:makeFileDirectory(fullPath)
    local nFindLastIndex = 2
    while true do
        nFindLastIndex  = string.find(fullPath, "/", nFindLastIndex + 1)

        if not nFindLastIndex then
            break
        end

        local path = string.sub(fullPath, 1, nFindLastIndex - 1)
        WZLog("WndDownLoad:makeFileDirectory 1",tostring(nFindLastIndex), path)
        local isDirectoryExist =  WZFileUtil:isDirectoryExist(path)
        if isDirectoryExist == false then
            local makeDownloadPath = WZFileUtil:makeDirectory(path)
            if makeDownloadPath ~= true then
                WZLog("WndDownLoad:makeFileDirectory fail", tostring(fullPath))
                return false
            end
        end
    end

    WZLog("WndDownLoad:makeFileDirectory 2", tostring(fullPath))
    return true
end
-------------------------------------私有方法模块End----------------------------------------
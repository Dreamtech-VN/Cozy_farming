--SNSSdkManager.lua
--@brief	第三方社交类sdk管理类
--@date		2014/03/25
--@author	xiaoyu_wu
--@note		第三方社交类sdk管理类

SNSSdkManager = { 
    m_tSdkNameList = nil, --渠道类sdk名称表
    m_tCurSdkObj = nil, --当前使用的sdk表对象
}

-------------------------------------公有方法模块Begin--------------------------------------
--@brief    根据渠道号构建sdk
function SNSSdkManager:initSdk()
    CCLuaLog("SNSSdkManager:initSdk")
    self.m_tCurSdkObj = self:initSdkWithName()
end

--@brief    获取默认的社交类sdk名称
--@return   默认的社交类sdk名称
--@note     默认为配置文件中的第一个
--@brief    从配置文件中获得sdk列表
--@return   #1,sdk名称表
function SNSSdkManager:getSdkList()
    CCLuaLog("SNSSdkManager:getSdkList")
    self.m_tSdkNameList = SDK_Util:getSDKsByTypeFromConfigFile("SNS") or {}
    return self.m_tSdkNameList
end

--@brief    根据sdk名称初始化sdk
--@param    sSdkName,sdk名称
function SNSSdkManager:initSdkWithName(sSdkName)
     if sSdkName == nil then
        if self.m_tSdkNameList == nil then
            self:getSdkList()
        end
    end
    local tabSdk = {}
    for i = 1,#self.m_tSdkNameList do
        sSdkName = self.m_tSdkNameList[i]
        if sSdkName == nil then
            return
        end
        local tSdkLuaObj = SDK_SNS:create(sSdkName)
        if tSdkLuaObj == nil then
            CCLuaLog("SNSSdkManager:initSdkWithName create "..sSdkName.." sdk lua object fail!")
            return
        end
        if sSdkName == "com/wyd/weChat/AsynSns" or sSdkName == "wyd_weChat_adapter" then
            local bPort,key = self:getWeChatKey()
            if  bPort then
                tSdkLuaObj.m_tConfig.SDKInitConfig.AppKey = key
            end
            
        end
        --英雄助手的修改
        if sSdkName == "com/wyd/heroHelp/AsynSns" then
            local bPort,key = self:getWeChatKey()
            if  bPort then
                tSdkLuaObj.m_tConfig.SDKOtherConfig.weChatKey = key
            end
        end
        tSdkLuaObj:initSDK()
        table.insert(tabSdk, tSdkLuaObj)
    end
    return tabSdk
end

--@brief    根据sdk名称获取sdk对象
--@param    sSdkName,sdk名称
function SNSSdkManager:getSdkObj(sSdkName)
   local sdkObj = nil
   for i=1,#self.m_tSdkNameList do
        WZLog("SNSSdkManager:getSdkObj:",sSdkName, self.m_tSdkNameList[i])
        if self.m_tSdkNameList[i] == sSdkName then
            sdkObj = self.m_tCurSdkObj[i]
            break
        end
   end
    return sdkObj
end

function SNSSdkManager:showTactic(sSdkName)
    local tSdkLuaObj = self:getSdkObj(sSdkName)
    if tSdkLuaObj == nil then
        return
    end
    tSdkLuaObj:showTactic("", nil, nil)
end

function SNSSdkManager:showClub(sSdkName)
    local tSdkLuaObj = self:getSdkObj(sSdkName)
    if tSdkLuaObj == nil then
        return
    end
    tSdkLuaObj:showClub("", SNSSdkManager.showClubCallback, SNSSdkManager)
end

function SNSSdkManager:showClubCallback(jsonArg)
    WZLog("SNSSdkManager:showClubCallback", jsonArg)
end

function SNSSdkManager:showShop(sSdkName)
    local tSdkLuaObj = self:getSdkObj(sSdkName)
    if tSdkLuaObj == nil then
        return
    end
    tSdkLuaObj:showShop("", SNSSdkManager.showShopCallback, SNSSdkManager)
end

function SNSSdkManager:showShopCallback(jsonArg)
    WZLog("SNSSdkManager:showShopCallback", jsonArg)
    WndVip:showWndUI(0)
end

function SNSSdkManager:heroOthers(sSdkName,funName)
    WZLog("SNSSdkManager:heroOthers", jsonArg)
    local tSdkLuaObj = self:getSdkObj(sSdkName)
    if tSdkLuaObj == nil then
        return
    end
    funName = funName or ""
    tSdkLuaObj:heroOthers(funName, nil, nil)
end

function SNSSdkManager:postDataCallback(jsonArg)
    WZLog("SNSSdkManager:postDataCallback", jsonArg)
    local tResult = json.decode(jsonArg)
    if tResult["result"] == "gonglvspot" then --英雄论坛
        SceneCity:updateRedDotBuilding("help", true)
    elseif tResult["result"] == "clubpot" then --英雄俱乐部
        WndCheckOther:showRed5()
    elseif tResult["result"] == "shoppot" then --英雄商城
        SceneCity:updateRedDotBuilding("eliteShop", true)
    elseif tResult["result"] == "spreadpot" then --英雄分享
        SceneCity:updateRedDotBuilding("share", true)
    elseif tResult["result"] == "praypot" then --英雄分享
        SceneCity:updateRedDotBuilding("pray", true)
    elseif tResult["return"] == "blocState" then --开关的状态
        g_bloc_tactic = tResult["tacticState"] --攻略
        g_bloc_club = tResult["clubState"]--俱乐部
        g_bloc_shop = tResult["shopState"]--精英商城
        g_bloc_spread = "false" --分享按钮,由于是中途版本添加的方法，所以需要先判断是否有该执行函数
        if PassportSdkManager.showHeoShare then
            g_bloc_spread = tResult["spreadState"]
        end
        g_bloc_pray = "false"
        if PassportSdkManager.showHeroPray then
            g_bloc_pray = tResult["prayState"]--祈愿
        end
        WndOwnCity:updateEliteShopAndHelpAndShare()
    end
end

function SNSSdkManager:shareWeChatText()
    local tSdkLuaObj = self:getSdkObj(self:_getWeChatName())
    if tSdkLuaObj == nil then
        return
    end
    tSdkLuaObj:shareWeChatText("", nil, nil)
end
function SNSSdkManager:shareWeChatImage(path)
    local tSdkLuaObj = self:getSdkObj(self:_getWeChatName())
    if tSdkLuaObj == nil then
        return
    end
    WZLog("WndPets:onFunctionClick HAHA:", path)
    tSdkLuaObj:shareWeChatImage(path, SNSSdkManager.shareWeChatImageCallBack, SNSSdkManager)
end

function SNSSdkManager:shareWeChatImageCallBack(sSdkName,sJson)
    ProtocolProcessorPrefetchCache:send_TASK_WeChatShare()
end

function SNSSdkManager:postData(sSdkName,sJson)
    local tSdkLuaObj =  self:getSdkObj(sSdkName) --self.m_tSdkObjMap[sSdkName]
    if tSdkLuaObj == nil then
        return
    end
    tSdkLuaObj:postData(sJson, SNSSdkManager.postDataCallback, SNSSdkManager)
end

--@brief    根据sdk名称分享内容
--@param    sSdkName,sdk名称
--@param    sUid,用户id
--@param    sContent,分享内容
--@param    sPicPath,本地图片路径
--@param    sPicUrl,网络图片url
--@param    tCallbackObj : 回调方法所属对象
--@param    funcCallback : 回调方法
function SNSSdkManager:share(sSdkName, sUid, sContent, sPicPath, sPicUrl, tCallbackObj, funcCallback)
    self:_checkTokenValid(sSdkName, sUid)
    
    local tSdkLuaObj = self.m_tSdkObjMap[sSdkName]
    if tSdkLuaObj == nil then
        return
    end
    
    self.tParams = {}
    self.tParams.content = sContent
    self.tParams.picPath = sPicPath or ""
    self.tParams.picUrl = sPicUrl or ""

    self.tCallback = tCallbackObj
    self.funcCallback = funcCallback
    local sJson = json.encode(self.tParams)
    WZLog("SNSSdkManager:share", sJson,SNS_STATE_LOGIN,tSdkLuaObj.m_nState)
    if tSdkLuaObj.m_nState == SNS_STATE_LOGIN then
        tSdkLuaObj:share(sJson, funcCallback, tCallbackObj)
    else
        self:_saveCurrentOperation(tSdkLuaObj.share, tSdkLuaObj, sJson, funcCallback, tCallbackObj)
    end
end

--@brief facebook的分享
--@brief title:标题
--@brief desc:内容
--@brief imgUrl:图片地址
function SNSSdkManager:shareFacebook(title,desc,imgUrl)
    if self.m_tCurSdkObj == nil then
        return
    end
    local tParams = {}
    tParams.title = title or "dandandao"
    tParams.desc = desc or "Let‘s play dandandao"
    tParams.imgUrl = imgUrl or ""
    local sJson = json.encode(tParams)
    self.m_tCurSdkObj:share(sJson,self.shareCallback, self)
end

function SNSSdkManager:sdkShare(sSdkName,sContent,sPicPath,sPicUrl,tCallbackObj,funcCallback)
    local tSdkLuaObj = self.m_tSdkObjMap[sSdkName]
    if tSdkLuaObj == nil then
        return
    end
    
    local tParams = {}
    tParams.content = sContent
    tParams.picPath = sPicPath or ""
    tParams.picUrl = sPicUrl or ""
    local sJson = json.encode(tParams)
    WZLog("SNSSdkManager:share", sJson)
    
    tSdkLuaObj:share(sJson,funcCallback,tCallbackObj)
    
end

--@brief 分享后的回调
--@param 回调的json信息
function SNSSdkManager:shareCallback(sJson)
    WZLog("SNSSdkManager:shareCallback")
    local t_jsonArg = SDK_Util:decodeFromJson(sJson);
    if t_jsonArg["return"] == "shareSuccess" then
        MsgBoxManager:showTipBox(LocalStrings.SHARE_SUCCESS)
        return
    end
    local gender = t_jsonArg["gender"]
    local name = t_jsonArg["name"]
    local imgUrl = t_jsonArg["imgUrl"]
    WZLog("SNSSdkManager:shareCallback222",id,name,imgUrl )
    ProtocolProcessorCache:send_PLAYER_SaveFacebook(1, name, gender, imgUrl)
end

function SNSSdkManager:getWeChatKey()
    local packName = WGameCmUtil:GetBundleIdentifier()
    if packName == "com.wyd.dandandao.hero" then
        return true,"wx0d4ee07c333dc8fc"
    elseif packName == "com.wyd.hero.dandandao.hero" then
        return true,"wx0d4ee07c333dc8fc"
    elseif packName == "com.wyd.hero.dandandao.nearme.gamecenter" then
        return true,"wxce995eaafd20483e"
    elseif packName == "com.wyd.hero.dandandao.uc" then
        return true,"wxaa123a4d8776e2ef"
    elseif packName == "com.tencent.tmgp.DDD2" then
        return true,"wx07aa3cd7774981bc"
    elseif packName == "com.wyd.hero.dandandao.baidu" then
        return true,"wx602f2a4662d95aa8"
    elseif packName == "com.wyd.hero.dandandao.m4399" then
        return true,"wx0a3e5f0f7d980a2e"
    elseif packName == "com.wyd.hero.dandandao.huawei" then
        return true,"wxed463b8b88162a61"
    elseif packName == "com.wyd.hero.dandandao.mi" then
        return true,"wxb12d3d24959c5d53"
    elseif packName == "com.wyd.hero.dandandao.qihu" then
        return true,"wxccc90f0f4b6e766c"
    elseif packName == "com.wyd.hero.dandandao.mz" then
        return true,"wxc0cf95d1a0840c4c"
    elseif packName == "com.wyd.hero.dandandao.wdj" then
        return true,"wxf8bcbe26622f70ac"
    elseif packName == "com.wyd.hero.dandandao.downjoy" then
        return true,"wxf9ce5974e99fdf8c"
    elseif packName == "com.wyd.hero.dandandao.mzw" then
        return true,"wx6b681f46c58b5305"
    end
    return false,""
end
-------------------------------------公有方法模块End----------------------------------------
-------------------------------------私有方法模块Begin--------------------------------------

--@brief
function SNSSdkManager:sendWeiboInfo(type,uid,icon)
    --发送玩家微博ID（PLAYER_SetPlayerWeiboId = 45）
    local sIcon = "http://tp4.sinaimg.cn/%s/180/1"
    if type == 0 then
        sIcon = string.format(sIcon,tostring(uid))
        WZLog("icon下载地址",sIcon)
    end
    WZLog("玩家微博信息",type,uid,sIcon)
    ProtocolProcessorAccount:send_PLAYER_SetPlayerWeiboId(type, tostring(uid), tostring(sIcon))
end

function SNSSdkManager:_getWeChatName()
    local platForm =  WZUISystem:getInstance():getPlatformInfo()
    if  platForm == 2 then --2为安卓系统
        return "com/wyd/weChat/AsynSns"     
    elseif platForm == 1 then --1Ios系统
        return "wyd_weChat_adapter"
    end
    return ""
end

-------------------------------------私有方法模块End----------------------------------------
--YDMicrosoftTranslation.lua
--@brief	微软翻译
--@date  	2017/4/26
--@author 	张铭
--@note 	微软翻译

YDMicrosoftTranslation = {
	m_sTxt = "",
}

function YDMicrosoftTranslation:needTranslation()
    WZLog("YDMicrosoftTranslation:needTranslation")
    --local task = WZHTTPPostDataLuaTask:create()
    if IWZHTTPTask.setHeader then
       local packageName = WGameCmUtil:GetBundleIdentifier()
         WZLog("YDMicrosoftTranslation:needTranslation222:",packageName)
       if packageName == "com.wyd.gplay.bombheroes" or packageName == "com.wyd.appstore.bombheroes" or
          packageName == "com.bombman.omgEU" or packageName == "com.bombman.omg" or
          packageName == "com.wyd.brgp.bombheroes" or packageName == "com.tutu.chibibomberios" or
          packageName == "com.tutu.chibibomberandroid" or packageName == "com.wyd.tcl.bombheroes " or 
          packageName == "com.wyd.samsung.bombheroes" or packageName == "com.wyd.samsungbr.bombheroes" or 
          packageName == "com.ios.jt.bombboombang" or packageName == "com.ios.rwt.bombcrash" or 
          packageName == "com.letui.doombomb" or packageName == "com.ios.jt.bombgala" or
          packageName == "com.wyd.gplay.bombheroesen" or packageName == "com.wyd.gplay.heroibomba" or
          packageName == "com.bombmaster.mg" or packageName == "com.ios.edo.bomb" or 
          packageName == "com.ios.rwt.bomberclash" or packageName == "com.edo.ios.Ihabombom" or 
          packageName == "com.ios.jt.bombmonster" or packageName == "com.ios.jt.bouncelegends" or 
          packageName == "com.ios.jt.bouncingchurch" or packageName == "com.sfrz.ddd" or 
          packageName == "com.ddd.haiwai" or packageName == "com.overseas.dan" or
          packageName == "com.ios.jt.bouncingchurch" or packageName == "com.ios.jt.bombcyclone" or 
          packageName == "com.sfrz.ddd" or packageName == "com.ios.jt.shootertribe" or 
          packageName == "com.DDBom.b" or packageName == "com.mh.jl" or packageName == "com.ios.jt.secrettreasure" or 
          packageName == "dd.pd.cr" or packageName == "com.ios.jt.projectilefiring" or packageName == "com.ios.jt.mysteriousland" or 
          packageName == "com.ios.jt.galgun" then
           WZLog("YDMicrosoftTranslation:needTranslation333")
          return true 
        end  
    end
    return false
end

function YDMicrosoftTranslation:translationLanguage(txt)
	self.m_sTxt = txt
	self:getToken()
end

function YDMicrosoftTranslation:getToken()
   WZLog("YDMicrosoftTranslation:getToken:")
  local sPostData = json.encode({})	
  local url = "https://api.cognitive.microsoft.com/sts/v1.0/issueToken"
  local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
  local downLoadInfoTask = nil
  downLoadInfoTask = WZHTTPPostDataLuaTask:create(1, url,sPostData,self.tokenCallback, self)
  if downLoadInfoTask.setHeader then
     WZLog("YDMicrosoftTranslation:getToken2222:")
      downLoadInfoTask:setHeader("Content-Length"," 0")
      downLoadInfoTask:setHeader("Ocp-Apim-Subscription-Key","ec221f877d0441a49294d15d752b2860")
      mulThreadSystem:addDownloadTask(downLoadInfoTask)
  else
    WZLog("YDMicrosoftTranslation:getToken no setHeader")
  end 
end

function YDMicrosoftTranslation:tokenCallback(nTaskId, sResponse, nTotalSize, nNowSize, bFinished, bFailed)
    WZLog("YDMicrosoftTranslation:tokenCallbackhhh sResponse:", nTaskId,sResponse,nTotalSize,nNowSize,bFinished,bFailed)
    if bFinished then --成功
		local strArray = SplitStringWithSeparator(sResponse,"\n")
		local str1 = strArray[#strArray]
    if #strArray <= 2 then
        WndChat:translateCallback(self.m_sTxt)
        MsgBoxManager:showTipBox(LocalStrings.NEED_UPDATE_VERSION)
        return
    end
    WZLog("YDMicrosoftTranslation:tokenCallback sResponse:", sResponse)
    WZLog("YDMicrosoftTranslation:tokenCallback str1:", str1)
		local sPostData = json.encode({})
	  	local str2 = "?text="..URLEscape(self.m_sTxt).."&to="..ProjConfig.LANGUAGE.."&appId=Bearer+"..str1
	  	local url = "http://api.microsofttranslator.com/v2/Http.svc/Translate"..str2
	  	local mulThreadSystem = WZUISystem:getInstance():getMultiThreadSystem()
	  	local downLoadInfoTask = nil
	  	downLoadInfoTask = WZHTTPInfoLuaTask:createWithTimeout(1, url, 10,30,self.translationCallback, self)
	    mulThreadSystem:addDownloadTask(downLoadInfoTask)
	    WZLog("YDMicrosoftTranslation:tokenCallback:",str2)
    elseif bFailed then --失败
    	 WZLog("YDMicrosoftTranslation:tokenCallback3333:",sResponse)
       WndChat:translateCallback(self.m_sTxt)
    end
end

function YDMicrosoftTranslation:translationCallback(nTaskId, sResponse, bFinished, bFailed)
    if bFinished then --成功
    	local s1 = string.find(sResponse,"/\">")
    	local s2 = string.find(sResponse,"</string>")
    	local  s3 = string.sub(sResponse,s1+3,s2-1)
    	print("YDMicrosoftTranslation:translationCallback:",s3)
    	WndChat:translateCallback(s3)
     elseif bFailed then --失败
        WndChat:translateCallback(self.m_sTxt)
    end
end
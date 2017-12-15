sub init()
print "HomeScreen " ; "init()"
    
    m.layoutTop = m.top.findNode("layoutTop")
    m.progressBar = m.top.findNode("progressBar")
    m.audiolist = m.top.findNode("audioLabelList")
    m.audioPlayer = m.top.findNode("audioPlayer")
    
    m.readAudioContentTask = createObject("RoSGNode","ContentReader")
    m.readAudioContentTask.observeField("audiocontent","showAudioList")
    m.readAudioContentTask.audiocontenturi = "pkg:/server/audiocontent.xml"
    m.readAudioContentTask.control = "RUN" 
    
    m.contentId = ""
    m.mediaType = ""
    
    m.audiolist.observeField("itemFocused", "onListItemFocused")
    m.top.observeField("deepLinkingLand", "onDeepLinkingLand")
end sub

sub showAudioList()
print "showAudioList " ; "init()"
    
    m.audiolist.content = m.readAudioContentTask.audiocontent
    m.audiolist.setFocus(true)
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
print "HomeScreen " ; "onKeyEvent()"     
  
  handled = false
  if press 
    if (key = "OK")
        if m.audiolist.hasFocus() = true
            itemSelected = m.audiolist.itemSelected
            m.audioPlayer.itemContent = m.audiolist.content.getChild(itemSelected)
            m.audioPlayer.audioControl = "play"
            m.audioPlayer.setFocus(true)        
                    
            if m.audioPlayer.visible = false
               m.audioPlayer.visible = true 
            end if
    end if
    else if (key = "right")
        if m.audioPlayer.itemContent <> invalid
            m.audioPlayer.setFocus(true)
        end if
    else if (key = "left")    
        m.audiolist.setFocus(true)
    end if 
  end if
  return handled
end function

sub onListItemFocused()
print "HomeScreen " ; "onListItemFocused()"
    itemFocused = m.audiolist.itemFocused
    if m.top.deepLinkingLand 
        if m.top.mediaDPType = "short-form"     
            for i = 0 to m.audiolist.content.getChildCount() - 1
                index = i
                if m.audiolist.content.getChild(index).TrackIDAudio = m.contentId
                    m.audiolist.jumpToItem = index
                    m.audioPlayer.itemContent = m.audiolist.content.getChild(index)
                    m.audioPlayer.audioControl = "play"
                    m.audioPlayer.setFocus(true)
                    m.audioPlayer.visible = true 
                    
                    exit for
                end if    
            end for 
        end if
        
        m.top.deepLinkingLand = false    
    end if
    
    if m.audioPlayer.itemContent <> invalid AND m.audioPlayer.audioState <> "paused" AND m.audioPlayer.audioState <> "finished"
        if m.audioPlayer.itemContent.title <> m.audiolist.content.getChild(itemFocused).title
           m.audioPlayer.resumeStatePoster = "pkg:/images/button_play.png"
        else
           m.audioPlayer.resumeStatePoster = "pkg:/images/button_pause.png" 
        end if
    end if
    
    
end sub

Sub onDeepLinkingLand()
    m.contentId = m.top.contentDLId
    m.mediaType = m.top.mediaDPType
End Sub

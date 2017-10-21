sub init()
print "AudioPlayer " ; "init()"
        
    m.timer = m.top.findNode("timer")
    m.backgroundPoster = m.top.findNode("backgroundPoster")
    m.itemPoster = m.top.findNode("itemPoster")
    m.itemAuthor = m.top.findNode("itemAuthor")
    m.itemAlbumInfo = m.top.findNode("itemAlbumInfo")
    m.itemSongName = m.top.findNode("itemSongName")
    m.itemCurPosition = m.top.findNode("itemCurPosition")
    m.itemLenght = m.top.findNode("itemLenght")
    m.audio = m.top.findNode("audio")
    m.itemFramePoster = m.top.findNode("itemFramePoster")
    
    m.itemPlayStatePoster = m.top.findNode("itemPlayStatePoster")
    m.itemRepeat = m.top.findNode("itemRepeat")
    
    m.progressBar = m.top.findNode("progressBar")
    
    m.authorAnimation = m.top.FindNode("authorAnimation")
    m.albumAnimation = m.top.FindNode("albumAnimation")
    m.songAnimation = m.top.FindNode("songAnimation")
    
    m.progressBar.progressBarBckgColor = "0xE0F2F2"
    m.progressBar.progressBarBckgWidth = "388"
    m.progressBar.progressBarBckgHeight = "6"
    
    m.progressBar.progressBarColor = "0x00897B"
    m.progressBar.progressBarHeight = "6" 
    
    m.replay = false
    
    m.timer.observeField("fire", "onTimerFire")
    
    m.top.observeField("itemContent", "onItemContent")
    m.top.observeField("focusedChild", "onFocus")
    
    m.itemAuthor.observeField("translation", "onAuthorRender")
    m.itemAlbumInfo.observeField("translation", "onAlbumRender")
    m.itemSongName.observeField("translation", "onSongNameRender")
    
    m.audio.observeField("state","onPlayerState") 
    m.audio.observeField("position","onPlayerPosition")
       
    
    m.progressBar.progressBarWidth = 0
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
print "AudioPlayer " ; "onKeyEvent()"     
  
  handled = false
  if press
   
    if (key = "fastforward")
        if m.itemLive <> "true"
            if m.audio.position < m.audio.duration
                m.audio.seek = m.audio.position + divider(m.audio.duration)
            else 
                m.audio.control = "stop"
            end if
         end if
    else if (key = "rewind")
        if m.itemLive <> "true"    
            m.audio.seek = m.audio.position - divider(m.audio.duration)
        end if
    else if (key = "play")
        if m.audio.state = "playing"
           m.audio.control = "pause" 
        else if m.audio.state = "paused"
            m.audio.control = "resume"
        else if m.audio.state = "stopped" OR m.audio.state = "finished"
            m.audio.control = "play"
        end if

    else if (key = "OK")
    
        if m.itemRepeat.text = "Repeat is OFF" AND m.itemLive <> "true"
            m.itemRepeat.text = "Repeat is ON"
            m.itemRepeat.color = "0xf4f07c"
            m.replay = true
        else if m.itemRepeat.text = "Repeat is ON" AND m.itemLive <> "true"
           m.itemRepeat.text = "Repeat is OFF"
           m.itemRepeat.color = "0xffffff" 
           m.replay = false
        end if        
    end if 
  end if
  return handled
end function


sub onAuthorRender()

    if m.itemAuthor.renderTracking = "none"
        m.authorAnimation.control = "start"
    end if

end sub

sub onAlbumRender()  

    if m.itemAlbumInfo.renderTracking = "none"
        m.albumAnimation.control = "start"
    end if 

end sub

sub onSongNameRender() 

    if m.itemSongName.renderTracking = "none"
        m.songAnimation.control = "start"
    end if 
          
end sub

sub onItemContent()
    print "audioPlayer " ; "onItemContent()"
    
    itemcontent = m.top.itemContent
    
    m.itemAuthor.text = itemcontent.actors
    m.itemAlbumInfo.text = itemcontent.album
    m.itemSongName.text = itemcontent.title
    m.itemPoster.uri = itemcontent.HDPosterUrl
    m.itemLive = itemcontent.Rating
    
    if m.itemLive = "true"
       m.itemRepeat.visible = false
    else
       m.itemRepeat.visible = true   
    end if
    
    stopingLblAnimation()
    resetLblTranslation()
    
    m.audio.content = itemcontent
    
    m.timer.control = "start"

end sub

sub onTimerFire()
    if m.itemAuthor.renderTracking = "partial"
        m.authorAnimation.control = "start"                
    end if

    if m.itemAlbumInfo.renderTracking = "partial"
        m.albumAnimation.control = "start"     
    end if

    if m.itemSongName.renderTracking = "partial"
        m.songAnimation.control = "start"     
    end if        

end sub

sub resetLblTranslation()
print "AudioPlayer " ; "resetLblTranslation()"
    m.itemAuthor.translation = [0, 0]
    m.itemAlbumInfo.translation = [0, 0]
    m.itemSongName.translation = [0, 0]

end sub

sub stopingLblAnimation()
print "AudioPlayer " ; "stopingLblAnimation()"
    m.authorAnimation.control = "stop"
    m.albumAnimation.control = "stop"
    m.songAnimation.control = "stop"

end sub

sub onPlayerState()
    if m.audio.state = "playing" 
        m.itemPlayStatePoster.uri = "pkg:/images/button_pause.png"                         
    else if m.audio.state =  "stopped" OR m.audio.state = "paused"
        m.itemPlayStatePoster.uri =  "pkg:/images/button_play.png" 
    else if m.audio.state = "finished"    
        if  m.replay = true
            m.audio.control = "play"
        end if    
    m.itemPlayStatePoster.uri =  "pkg:/images/button_play.png" 
    else if m.audio.state = "error" 
        m.itemAuthor.text = m.audio.errorMsg
        m.itemAlbumInfo.text = m.audio.errorMsg       
    end if
    
end sub

sub onPlayerPosition()
    if m.itemLive <> "true"
        
        m.itemLenght.text = calulateMinDuration(m.audio.duration)
        m.itemCurPosition.text = calulatePositionMin(m.audio.position)
        m.itemCurPosition.visible = true
        
        m.progressBar.progressBarWidth = m.progressBar.progressBarBckgWidth
        
        passedAudioProgress = (m.audio.position / m.audio.duration) * 100
        
        passedProgreesBar = (m.progressBar.progressBarWidth / 100) *  passedAudioProgress

        m.progressBar.progressBarWidth = passedProgreesBar
    else
        m.progressBar.progressBarWidth = 0
        m.itemCurPosition.visible = false
        m.itemLenght.text = "LIVE"
    end if 

end sub

sub onFocus()

    if m.top.hasFocus()
        m.backgroundPoster.blendColor = "0xd7d7d7"
        m.itemFramePoster.visible = "true"
    else 
        m.backgroundPoster.blendColor = "0xFFFFFFFF"        
        m.itemFramePoster.visible = "false"
    end if
    
end sub

function calulateMinDuration(duration)
    seconds = duration MOD 60
    minutes = int(duration / 60) 

    durationString = Str(minutes)+":"+Str(seconds)
    
    return durationString  
    
end function

function calulatePositionMin(position)
    seconds = position MOD 60
    minutes = int(position / 60) 

    positionString = Str(minutes) + ":" + Str(seconds)
    
    return positionString  
end function

function divider(duration)
    percent = (duration / 100) *  5
    
    return percent
end function

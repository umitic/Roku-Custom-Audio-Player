sub init()
print "ContentReader " ; "init()"
         
    m.top.functionName = "readContent"
end sub

sub readContent()
    print "ContentReader " ; "readContent()"
    
    audiocontent = createObject("RoSGNode","ContentNode")

    audiocontentxml = createObject("roXMLElement")
      
    xmlstring = ReadAsciiFile(m.top.audiocontenturi)
    audiocontentxml.parse(xmlstring)
      
    if audiocontentxml.getName() = "AudioContent"
        for each audio in audiocontentxml.GetNamedElements("audio")
            audioitem = audiocontent.createChild("ContentNode")
            audioItem.setFields(audio.getAttributes())
        end for
    end if

      m.top.audiocontent = audiocontent
end sub
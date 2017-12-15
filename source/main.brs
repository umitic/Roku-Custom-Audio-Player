sub Main(args as Dynamic) as Void

    showSGScreen(args)
end sub

sub showSGScreen(args = invalid as Dynamic)
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    m.scene = screen.CreateScene("HomeScene")
    
    'DeepLinking
    if args.contentId <> invalid AND args.mediaType <> invalid
        m.scene.contentDLId = args.contentId
        m.scene.mediaDPType = args.mediaType
        m.scene.deepLinkingLand = true
    end if
    
    screen.show()

    while(true)
        msg = wait(0, m.port)
    msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
    
end sub

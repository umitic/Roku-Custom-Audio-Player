sub init()
print "MarkupGridItem " ; "init()" 
    
    m.top.id = "markupGridItem"
    m.itemPoster = m.top.findNode("itemPoster") 
    m.itemMask = m.top.findNode("itemMask")
    m.progressBar = m.top.findNode("progressBar")
    m.itemMaskBar = m.top.findNode("itemMaskBar")
      
    m.top.observeField("itemContent", "onShowContent")
    m.top.observeField("focusPercent", "onShowFocus")
end sub

sub onShowContent()
print "MarkupGridItem " ; "onShowContent()"
    
    itemcontent = m.top.itemContent
    m.itemPoster.uri = itemcontent.posterUri
    m.itemPoster.width = itemcontent.posterWidth
    m.progressBar.width = itemcontent.progressBarWidth
    m.itemMaskBar.width = m.progressBar.width
end sub

sub onShowFocus()
print "MarkupGridItem " ; "onShowFocus()"
    
    m.itemMask.opacity = 0.75 - (m.top.focusPercent * 0.75)
    m.itemMaskBar.opacity = 0.75 - (m.top.focusPercent * 0.75)

end sub

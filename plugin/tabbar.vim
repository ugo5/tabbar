function MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor
  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'
  return s
endfunction

function MyTabLabel(n)
  " Append the tab number
  let label = '['.a:n .': '
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let modified_part = ''
  
  for bufnum in buflist  
    if getbufvar(bufnum, "tab_name") != '' 
      return  label . getbufvar(bufnum, "tab_name") . ']'
    endif
  endfor

  if getbufvar(buflist[winnr - 1], "&modified")
    let modified_part = '+'
  endif

  if getbufvar(buflist[winnr - 1], "buf_tab_title") != '' 
    return  label . modified_part . getbufvar(buflist[winnr - 1], "buf_tab_title")
  endif

  let name = bufname(buflist[winnr - 1])
  if name == ''
    if &buftype=='quickfix'
      let name = '[Quickfix List]'
    else
      let name = '[No Name]'
    endif
  else
    let name = fnamemodify(name,":t")
  endif
  let label .= modified_part . name . ']'
  return label
endfunction

set tabline=%!MyTabLine()

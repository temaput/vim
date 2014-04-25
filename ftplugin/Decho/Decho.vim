"" ftplugin/Decho/Decho.vim
"  Author:  Charles E. Campbell
"  Version: 3m	ASTRO-ONLY
"  Date:    Aug 07, 2012
"
""    Allows a Decho-based output window to be on the left and code on the right.
"     VSplitAndTag() will cause the code window to synchronize to the current
"     function named under the cursor.
"
"  <f9>   tag to word under cursor in tmp file; show in window on right-hand-side
"         When in source window, <f9> will tag the tmp file and source file to the
"         calling function
"  <s-f9> tag to word under cursor in tmp file; show in window on left-hand-side
"         When in source window, <s-f9> will tag the tmp file and source file to the
"         calling function
"  <c-f9> display current calling function trace
"  $      goes to end-of-line (except for any trailing ~###s, typically there due
"         to my inline debugger)
"
"  One may have two or three vertical windows open this way.
"         <s-f9>                   <f9>
"       |left-hand | tmp file | right-hand |
"       |source    |          | source     |
"
" ---------------------------------------------------------------------
"DechoTabOn

" =====================================================================
"  Public Interface: {{{1
if !exists("g:no_dbg_maps") || !g:no_dbg_maps
 nno	<buffer> <silent>	<F9>	:call <SID>VSplitTagRight()<CR>zMzxz.
 nno	<buffer> <silent>	<s-F9>	:call <SID>VSplitTagLeft()<CR>zMzxz.
 nno	<buffer> <silent>	<c-F9>	:call <SID>DechoFuncTrace()<cr>
 nno	<buffer> <silent>	<up>	<up>:call <SID>DechoChgLine()<cr>
 nno	<buffer> <silent>	<down>	<down>:call <SID>DechoChgLine()<cr>
 nno	<buffer> <silent>	<right>	:call <SID>DechoChgLine()<cr>
 nno	<buffer> <silent>	<left>	:echo <SID>GetFuncName()<cr>
 nno	<buffer> <silent>	$		:if match(getline("."),'\~\d\+$') != -1<bar>exe 'norm! $F~h'<bar>else<bar>exe 'norm! $'<bar>endif<cr>
 nno	<buffer> <silent>	<F6>	:echo 'F9:split,tag right  sF9:split,tag left  cF9:function_trace up:prv dbgline dn: nxt dbgline left:current dbgline right:current dbgfunc'<CR>
endif
if !exists("g:no_dbg_commands") || !g:no_dbg_commands
 com!	DSTR	call s:VSplitTagRight()<bar>norm! zMzxz.
 com!	DSTL	call s:VSplitTagLeft()<bar>norm! zMzxz.
 com!	DFT		call s:DechoFuncTrace()
 com!	DCL		call s:DechoChgLine()
 com!	DFN		call s:GetFuncName()
endif
if v:version >= 700 && has("balloon_eval") && !exists("s:initbeval") && has("syntax") && exists("g:syntax_on")
 let s:initbeval = &beval
 let &l:bexpr    = "DechoBalloon()"
 set beval
" au BufWinEnter,WinEnter *	if &ft == "Decho"|set beval|else|let &beval= s:initbeval|endif
endif

" =====================================================================
"  Functions: {{{1
" =====================================================================

" ---------------------------------------------------------------------
" s:VSplitTagRight: {{{2
fun! s:VSplitTagRight()
"  call Dfunc("s:VSplitTagRight()")

"  " check if cursor in source-code window (as opposed to Decho window)
  let curname= expand("%")
  let dbgline= getline(".")
  if curname =~ '*.vim'
"   call Decho("cursor in source-code window")
   let eikeep= &ei
   set ei=all
   wincmd h
   exe "norm! j[{[{0z\<cr>"
   call s:VSplitTagRight()
   let &ei= eikeep
"   call Dret("s:VSplitTagRight")
   return
  endif

  " get name of function
  let b:dbg_oldwrdR     = exists("s:wrdR")?     s:wrdR     : ""
  let b:dbg_oldwrdlineR = exists("s:wrdlineR")? s:wrdlineR : 0
  let s:wrdR            = s:GetFuncName()
  let s:wrdlineR        = getline(".")
  if s:wrdR == ""
   echohl Error | echo "unable to find function name" | echohl None
"   call Dret("s:VSplitTagRight")
   return
  endif
"  call Decho("wrdR<".s:wrdR."> oldwrdR<".b:dbg_oldwrdR."> oldwrdlineR#".b:dbg_oldwrdlineR)
  let curwinnr = winnr()

  " vertically split window
  if !exists("s:vsplitright")
"   call Decho("split right")
   let spr= &spr
   set spr
   botright vsplit
   let &spr          = spr
   let s:vsplitright = winnr()
   augroup DBGTMP_VSTR
     au BufWinLeave *.c,*.h,*.cpp,*.vim call <SID>VsplitRightQuit()
   augroup END

   " tag to word (ie. function name)
   let ei= &ei
   set ei=BufWinLeave
   exe s:vsplitright."wincmd w"
   call s:DechoTag("ta",s:wrdR,ei,"R")

  elseif exists("b:dbg_oldwrdR") && s:wrdR == b:dbg_oldwrdR && s:wrdlineR == b:dbg_oldwrdlineR
   " tag to next in chain
"   call Decho("tag to next in chain")
   let ei= &ei
   set ei=BufWinLeave
   exe s:vsplitright."wincmd w"
   call s:DechoTag("tn",s:wrdR,ei,"R")

  else
"   call Decho("re-enter window")
   let ei= &ei
   set ei=BufWinLeave
   exe s:vsplitright."wincmd w"
   call s:DechoTag("ta",s:wrdR,ei,"R")
  endif

  " final screen adjusting
  if dbgline =~ '\~\d\+$'
   " go to line number if one present, and put line in middle-of-window
"   call Decho("goto line#".substitute(dbgline,'^.*\~\(\d\+$\)','\1',''))
   exe substitute(dbgline,'^.*\~\(\d\+$\)','\1','')
   exe "norm! 0zxz."
   redraw!
  else
   " put tagged line at top-of-window
   exe "norm! 0zxz\<cr>"
  endif

"  call Dret("s:VSplitTagRight : s:vsplitright=".(exists("s:vsplitright")? s:vsplitright : "---"))
endfun

" ---------------------------------------------------------------------
" s:VSplitTagLeft: {{{2
fun! s:VSplitTagLeft()
"  call Dfunc("s:VSplitTagLeft()")

  " check if cursor in source-code window (as opposed to tmp* window)
  let curname= expand("%")
  let dbgline= getline(".")
  if curname =~ '*.vim'
"   call Decho("cursor in source-code window")
   let eikeep= &ei
   set ei=all
   wincmd h
   exe "norm! j[{[{0z\<cr>"
   call s:VSplitTagLeft()
   let &ei= eikeep
"   call Dret("s:VSplitTagRight")
   return
  endif

  " get name of function
  let b:dbg_oldwrdL     = exists("s:wrdL")?     s:wrdL     : ""
  let b:dbg_oldwrdlineL = exists("s:wrdlineL")? s:wrdlineL : 0
  let s:wrdL            = s:GetFuncName()
  let s:wrdlineL        = getline(".")
  if s:wrdL == ""
   echohl Error | echo "unable to find function name" | echohl None
"   call Dret("s:VSplitTagLeft")
   return
  endif
"  call Decho("wrdL<".s:wrdL."> oldwrdL<".b:dbg_oldwrdL."> oldwrdlineL#".b:dbg_oldwrdlineL)
  let curwinnr = winnr()

  " vertically split window
  if !exists("s:vsplitleft")
"   call Decho("split left")
   let spr= &spr
   set spr
   topleft vsplit
   let &spr         = spr
   let s:vsplitleft = winnr()
   augroup DBGTMP_VSTRL
     au BufWinLeave *.c,*.h,*.cpp,*.vim call <SID>VsplitLeftQuit()
   augroup END

  " tag to word (ie. function name)
   let ei= &ei
   set ei=BufWinLeave
   exe s:vsplitleft."wincmd w"
   call s:DechoTag("ta",s:wrdL,ei,"L")

  elseif exists("b:dbg_oldwrdL") && s:wrdL == b:dbg_oldwrdL && s:wrdlineL == b:dbg_oldwrdlineL
  " tag to next in chain
"   call Decho("tag to next in chain")
   let ei= &ei
   set ei=BufWinLeave
   exe s:vsplitleft."wincmd w"
   call s:DechoTag("tn",s:wrdL,ei."L")

  else
"   call Decho("re-enter window")
   let ei= &ei
   set ei=BufWinLeave
   exe s:vsplitleft."wincmd w"
   call s:DechoTag("ta",s:wrdL,ei."L")
  endif

  " final screen adjusting
  if dbgline =~ '\~\d\+$'
   " go to line number if one present, and put line in middle-of-window
   exe substitute(dbgline,'^.*\~\(\d\+$\)','\1','')
   exe "norm! 0zxz."
   redraw!
  else
   " put tagged line at top-of-window
   exe "norm! 0zxz\<cr>"
  endif

"  call Dret("s:VSplitTagLeft : s:vsplitleft=".(exists("s:vsplitleft")? s:vsplitleft : "---"))
endfun

" ---------------------------------------------------------------------
" s:GetFuncName: get function name containing cursor position or, if its {{{2
"                the call to the function itself, that function name
fun! s:GetFuncName()
"  call Dfunc("s:GetFuncName()")
  let funcpat = '^|*\(\h[a-zA-Z0-9_#:<>]*\)(.*{$'
  let funcline= getline(".")
"  call Decho("(GetFuncName#1) funcline<".funcline.">")
  if funcline !~ funcpat
   if funcline =~ '\<return .*}\%(\~\d\+\)\=$'
	" handle return
	let funcname= substitute(funcline,'^|*return \(\h\w*\)\>.\{-}$','\1','')
"	call Decho("(GetFuncName#2) funcname<".funcname."> (extracted from a Dret line)")
   else
	" handle not-a-function call, not-a-return
	let [funcline,funccol] = searchpairpos('^|*\%(\h[a-zA-Z0-9_#:<>]*\)(.*{$','','|return\>.*}\%(\~\d\+\)\=$','Wbn')
"    call Decho("(GetFuncName#3) funcline#".funcline." funccol#".funccol)
    if funcline > 0
	 let funcname= substitute(getline(funcline),funcpat,'\1','e')
    else
     let funcname= ""
    endif
   endif
  else
   " handle function start
   let funcname= substitute(funcline,funcpat,'\1','e')
"   call Decho("(GetFuncName#4) funcname<".funcname."> (extracted from a Dfunc line)")
  endif
"  call Dret("s:GetFuncName <".funcname.">")
  return funcname
endfun

" ------------------------------------------------------------------------
" s:VsplitRightQuit: does the command, usually a quit or save&quit, but also {{{2
"                  deletes the vsplitright variable
fun! s:VsplitRightQuit()
"  call Dfunc("VsplitRightQuit()")
  if exists("s:vsplitright")
   exe "silent! ".s:vsplitright."wincmd w"
  endif
  augroup DBGTMP_VSTR
    au!
  augroup END
  augroup! DBGTMP_VSTR

  if exists("s:vsplitright")
   unlet s:vsplitright
  endif
"  call Dret("VsplitRightQuit")
endfun

" ------------------------------------------------------------------------
" s:VsplitLeftQuit: does the command, usually a quit or save&quit, but also {{{2
"                 deletes the vsplitright variable
fun! s:VsplitLeftQuit()
"  call Dfunc("VsplitLeftQuit()")
  if exists("s:vsplitleft")
   exe "silent! ".s:vsplitleft."wincmd w"
  endif
  augroup DBGTMP_VSTL
    au!
  augroup END
  augroup! DBGTMP_VSTL

  if exists("s:vsplitleft")
   unlet s:vsplitleft
  endif
"  call Dret("VsplitLeftQuit")
endfun

" ---------------------------------------------------------------------
"  s:DechoTag:  attempt to tag to funcname {{{2
"           cmd is typically "ta" or "tn"
"           ei  holds original &ei
fun! s:DechoTag(cmd,funcname,ei,leftright)
"  call Dfunc("s:DechoTag(cmd<".a:cmd."> funcname<".a:funcname."> ei=".a:ei." leftright=".a:leftright.")")

  if a:cmd == "tn"
   let funcname= ""
  else
   let funcname= (a:funcname == "")? a:funcname : (" ".a:funcname)
  endif

  try
"   call Decho("exe ".a:cmd.funcname)
   exe a:cmd.funcname
   let &ei= a:ei
  catch /^Vim\%((\a\+)\)\=:E73/
   if a:cmd == "tn"
    call s:DechoTag("ta",a:funcname,a:ei,a:leftright)
"    call Dret("s:DechoTag")
	return
   endif
   let &ei= a:ei
   if a:leftright == "R"
    call s:VsplitRightQuit()
   else
    call s:VsplitLeftQuit()
   endif
   q
"   call Decho("***warning*** unable to tag to".funcname."!")
   echohl Error | echo "***error*** unable to tag to".funcname."!" | echohl None
   sleep 3
  catch /^Vim\%((\a\+)\)\=:E426/
   let &ei= a:ei
   if a:leftright == "R"
    call s:VsplitRightQuit()
   else
    call s:VsplitLeftQuit()
   endif
   q
"   call Decho("***warning*** unable to tag to".funcname."!")
   echohl Error | echo "***error*** unable to tag to".funcname."!" | echohl None
   sleep 3
  endtry

"  call Dret("s:DechoTag")
endfun

" ---------------------------------------------------------------------
" s:DechoFuncTrace: echo list of current function calling trace {{{2
fun! s:DechoFuncTrace()
"  call Dfunc("DechoFuncTrace()")
  let swp       = SaveWinPosn(0)
  let functrace = ""
  while searchpair('{$','','}\%(\~\d\+\)\=$','Wb')
   if functrace != ""
   	let functrace= "|".functrace
   endif
   let functrace= substitute(getline("."),'^|*\(\h\w*\)(.*$','\1','e').functrace
   norm! 0
  endwhile
  call RestoreWinPosn(swp)
  echo functrace
"  call Dret("DechoFuncTrace")
endfun

" ---------------------------------------------------------------------
" s:DechoChgLine: {{{2
fun! s:DechoChgLine()
"  call Dfunc("s:DechoChgLine()")
  let didwork= 0

  " check that (at least) two windows exist
"  call Decho("checking that at least two windows exist")
  let leftwin= winnr()
  " change to right window
  wincmd l
  let rightwin= winnr()
"  call Decho("leftwin#".leftwin." rightwin#".rightwin)
  if leftwin == rightwin
   " doesn't look like we succeeded.  Split the window...
"   call Decho("splitting window since leftwin==rightwin")
   botright vsplit
   let s:vsplitright= winnr()
   augroup DBGTMP_VSTR
     au BufWinLeave *.c,*.h,*.cpp,*.vim call <SID>VsplitRightQuit()
   augroup END
  endif
  " return to left window
  wincmd h

  if getline(".") =~ '^|*\h\w*(.*{$'
   " handle a new function line
   let funcname = s:GetFuncName()
   if funcname == ""
    echohl Error | echo "unable to find function name" | echohl None
"    call Dret("s:DechoChgLine")
    return
   endif
   " change to right window
   wincmd l
   " check for success
   exe "silent ta ".fnameescape(funcname)
   norm! zMzxz
   exe '2match Unique "\%'.line(".").'l"'
   let didwork= 1
  elseif getline(".") =~ '^|*return \%(s:\)\=\h\w* .*\~\d\+$'
   " handle a return line
   let curline  = getline(".")
   let funcname = substitute(curline,'^|*return \(\%(s:\)\=\h\w*\).*$','\1','')
   let linenum  = substitute(curline,'^|*return \%(s:\)\=\h\w*.*\~\(\d\+\)$','\1','')
   wincmd l
   exe "silent ta ".fnameescape(funcname)
   exe linenum
   norm! zMzxz
   exe '2match Unique "\%'.linenum.'l"'
   let didwork= 1
  elseif getline(".") =~ '\~\d\+$'
   " handle a dprintf line
   let funcname = s:GetFuncName()
   let curline  = getline(".")
   let linenum  = substitute(curline,'^.*\~\(\d\+\)$','\1','')
"   call Decho("line#".linenum.": ".curline)
   wincmd l
   exe "silent ta ".fnameescape(funcname)
   exe linenum
   exe '2match Unique "\%'.linenum.'l"'
   norm! zMzxz
   let didwork= 1
  endif

  " place line in middle of screen and insure that folds are opened
  if didwork
   if foldclosed(".") != -1
    norm! zzzO
   else
    norm! zz
   endif
   " change back to left window
   wincmd h
  endif

"  call Dret("s:DechoChgLine")
endfun

" ---------------------------------------------------------------------
" DechoBalloon: {{{2
if v:version >= 700 && has("balloon_eval") && exists("s:initbeval") && has("syntax") && exists("g:syntax_on")
 fun! DechoBalloon()
   if v:beval_text =~ '^-\=\d\+:\=$' && executable("n2e")
	let mesg= system("n2e ".v:beval_text)
   elseif v:beval_text =~ '^-\=\d*\.\d\+:\=$' && executable("n2e")
	let mesg= system("n2e ".v:beval_text)
   elseif v:beval_text =~ '^-\=\d\+\.:\=$' && executable("n2e")
	let mesg= system("n2e ".v:beval_text)
   elseif v:beval_text =~ '^0x\x\+[x:]\=$' && executable("n2e")
	let mesg= system("n2e ".v:beval_text)
   elseif v:beval_text =~ '^0\o\+[o:]\=$' && executable("n2e")
	let mesg= system("n2e ".v:beval_text)
   else
	let mesg= ""
   endif
  return mesg
 endfun
endif

" ------------------------------------------------------------------------
"  Modelines: {{{1
"  vim: fdm=marker ft=vim

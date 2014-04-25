" Decho.vim
"   Author: Charles E. Campbell, Jr.
"   Date:   Apr 18, 2012
"   Version: 1a	ASTRO-ONLY
" ---------------------------------------------------------------------
let s:keepcpo      = &cpo
set cpo&vim

if has("conceal")
 syn match	vimTodo contained	'^\s*".*\<D\%(func\|ret\|echo\|redir\)\s*(.*$' conceal
else
 syn match	vimTodo contained	'^\s*".*\<D\%(func\|ret\|echo\|redir\)\s*(.*$'
endif

syn keyword vimFuncName		Decho DechoWF DechoOn DechoOff DechoMsgOn DechoMsgOff DechoRemOn DechoRemOff DechoVarOn DechoVarOff DechoTabOn DechoTabOff containedin=vimFuncBody

" ---------------------------------------------------------------------
"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" vim: ts=4 fdm=marker

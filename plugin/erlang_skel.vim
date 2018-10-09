" Vim plugin file
" Language: Erlang
" Author:   Ricardo Catalinas Jiménez <jimenezrick@gmail.com>
" License:  Vim license
" Version:  2012/06/28

if exists('g:loaded_erlang_skel') || v:version < 700 || &compatible
	finish
else
	let g:loaded_erlang_skel = 1
endif

" 0 - append at tail
" 1 - replace 
" 2 - insert at current line
if !exists('g:erlang_skel_replace')
	let g:erlang_skel_replace = 1
endif

if !exists('g:erlang_skel_coding')
    let g:erlang_skel_coding = 'utf-8'
endif

if !exists('g:erlang_skel_dir')
	let g:erlang_skel_dir = expand('<sfile>:p:h') . '/erlang_skels'
endif

if !exists('g:erlang_skel_author')
    let g:erlang_skel_author = 'none'
endif

if !exists('g:erlang_skel_mail')
    let g:erlang_skel_mail = 'none@none.none'
endif

function s:LoadSkeleton(skel_name)
	if g:erlang_skel_replace == 1
		%delete
	elseif g:erlang_skel_replace == 0
		let current_line = line('.')
		call append(line('$'), '')
		normal G
    elseif g:erlang_skel_replace == 2
        call append(line('.')-1, '')
        normal k
	endif
	execute "read " . g:erlang_skel_dir . "/" . a:skel_name
    if g:erlang_skel_replace == 2
        normal k
    endif
    " 字符串替换
    try | call s:SubstituteField('modulename', expand('%:t:r')) | catch | | endtry
    try | call s:SubstituteField('hrlname', substitute(expand('%:t:r'), ".*", "\\U\\0", "")) | catch | | endtry
    try | call s:SubstituteField('date', strftime("%Y-%m-%d")) | catch | | endtry
    try | call s:SubstituteField('time', strftime("%H:%M:%S")) | catch | | endtry
    try | call s:SubstituteField('year', strftime("%Y")) | catch | | endtry
    try | call s:SubstituteField('author', g:erlang_skel_author) | catch | | endtry
    try | call s:SubstituteField('mail', g:erlang_skel_mail) | catch | | endtry
    try | call s:SubstituteField('coding', g:erlang_skel_coding) | catch | | endtry

	if g:erlang_skel_replace
		normal gg
		delete
	else
		call cursor(current_line, 1)
	endif
endfunction

function s:SubstituteField(name, value)
	execute '%substitute/\$' . toupper(a:name) . '/' . a:value . '/'
endfunction

function s:ErlangTemplete(...)
    let g:erlang_skel_replace = a:1
    try 
        " 去除a:3 两边的双引号
        let g:erlang_skel_coding = strpart(a:3, 1, strlen(a:3) - 2)
    catch
    endtry
    silent call s:LoadSkeleton(a:2)
endfunction

command! -nargs=* ErlangTemplete call s:ErlangTemplete(<f-args>)

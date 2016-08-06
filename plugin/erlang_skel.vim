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

if !exists('g:erlang_skel_replace')
	let g:erlang_skel_replace = 1
endif

if !exists('g:erlang_skel_dir')
	let g:erlang_skel_dir = expand('<sfile>:p:h') . '/erlang_skels'
endif

function s:LoadSkeleton(skel_name)
	if g:erlang_skel_replace
		%delete
	else
		let current_line = line('.')
		call append(line('$'), '')
		normal G
	endif
	execute 'read' g:erlang_skel_dir . '/' . a:skel_name
    " 字符串替换
    try | call s:SubstituteField('modulename', expand('%:t:r'))            | catch | | endtry
    try | call s:SubstituteField('hrlname', substitute(expand('%:t:r'), ".*", "\\U\\0", "")) | catch | | endtry
    try | call s:SubstituteField('date', "'" . strftime("%Y-%m-%d") . "'") | catch | | endtry
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

command ErlangModule      silent call s:LoadSkeleton('module')
command ErlangApplication silent call s:LoadSkeleton('application')
command ErlangSupervisor  silent call s:LoadSkeleton('supervisor')
command ErlangGenServer   silent call s:LoadSkeleton('gen_server')
command ErlangGenServer1  silent call s:LoadSkeleton('gen_server_1')
command ErlangGenFsm      silent call s:LoadSkeleton('gen_fsm')
command ErlangGenEvent    silent call s:LoadSkeleton('gen_event')
command ErlangHeader      silent call s:LoadSkeleton('header')

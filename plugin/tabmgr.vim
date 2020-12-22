function! <SID>CloseAndOpenInNewTab()
    let l:file = expand('%')
    execute 'q'
    execute 'tabe ' . l:file
endfunction

nnoremap <leader>tb :call <SID>CloseAndOpenInNewTab()<CR>
nnoremap <leader>ltb :call <SID>CloseAndOpenInNewTab()<CR>:tabm -1<CR>

function! <SID>CloseDupHelper()
    let l:file_dict = {}
    let l:tablist = range(1, tabpagenr("$"))
    for tabnumber in l:tablist
        let l:buflist = tabpagebuflist(tabnumber)
        let l:tab_file_list = []
        for bufid in l:buflist
            if (bufloaded(bufid) && buflisted(bufid))
                let l:path = "#" . bufid . ":."
                let l:path = expand(l:path)
                if !has_key(l:file_dict, l:path)
                    let l:file_dict[l:path] = ''
                else
                    execute "normal! " . tabnumber . "gt"
                    let l:window_number = bufwinnr(bufid)
                    if (l:window_number >= 0)
                        execute l:window_number . "wincmd w"
                        execute "q"
                        return 1
                    endif
                endif
            endif
        endfor
    endfor
    return 0
endfunction

function! <SID>CloseDup()
    while <SID>CloseDupHelper()
    endwhile
endfunction

" Close duplicate window
command Cdw call <SID>CloseDup()

function! <SID>GetMainWindow()
    let l:main_winnr = 1
    let l:win_list = range(1, winnr("$"))
    for window_number in l:win_list
        let l:bufnr = winbufnr(window_number)
        if (bufloaded(l:bufnr) && buflisted(l:bufnr))
            let l:main_winnr = window_number
            break
        endif
    endfor
    return l:main_winnr
endfunction

function! <SID>SetMainWindow()
    let l:main_winnr = <SID>GetMainWindow()
    if l:main_winnr == winnr('$')
        return
    endif
    let l:main_winsize = g:my_screen_width / 4 * 3
    " echom "main window: " . l:main_winnr
    " echom "main window size: " . string(l:main_winsize)
    " exchange current content with main window
    execute l:main_winnr . "wincmd x"
    " goto main window
    execute l:main_winnr . "wincmd w"
    " resize main window
    execute "vertical res " . l:main_winsize
    call feedkeys("^")
    " let l:last_winnr = winnr('$')
    " if l:main_winnr == l:last_winnr
        " return
    " endif
    " let l:win_list = range(l:main_winnr + 1, l:last_winnr)
    " echom "Adjusting list: " . string(l:win_list)
    " for window_number in l:win_list
        " echom "Adjusting " . window_number
        " execute "vertical " . window_number . "res 0"
    " endfor
endfunction

function! <SID>ExchangeMainWindow()
    execute "wincmd p"
    call <SID>SetMainWindow()
endfunction

function! <SID>ExchangeWindow()
    let l:cur_winwidth = winwidth(winnr())
    execute "wincmd x"
    execute "vertical res " . l:cur_winwidth
    call feedkeys("^")
endfunction

command Main call <SID>SetMainWindow()
command ExchangeMain call <SID>ExchangeMainWindow()
" Alt -m
nnoremap <silent> µ :Main<CR>
" Shift - Alt - m
nnoremap <silent> Â :ExchangeMain<CR>
" Alt - x
nnoremap <silent> ≈ :call<SID>ExchangeWindow()<CR>


function! <SID>MoveWindowToNextTab()
    let l:fname = expand('%')
    " echom "fname: " . l:fname
    execute "tabnext"
    execute "vs " . l:fname
    execute "tabprevious"
    execute "q"
    if expand('%') != l:fname
        execute "tabnext"
    endif
endfunction
" Alt + 右小括号
nnoremap <silent> ‚ :call<SID>MoveWindowToNextTab()<CR>

function! <SID>MoveWindowToPrevTab()
    let l:fname = expand('%')
    " echom "fname: " . l:fname
    execute "tabprevious"
    execute "vs " . l:fname
    execute "tabnext"
    execute "q"
    if expand('%') != l:fname
        execute "tabprevious"
    endif
endfunction
" Alt + 左小括号
nnoremap <silent> · :call<SID>MoveWindowToPrevTab()<CR>

function! <SID>TabBufOnly()
    let l:fname = expand('%')
    let l:win_list = range(1, winnr("$"))
    for window_number in l:win_list
        let l:bufnr = winbufnr(window_number)
        if (bufloaded(l:bufnr) && buflisted(l:bufnr))
            execute window_number . "wincmd w"
            if expand('%') != l:fname
                execute "q"
            endif
        endif
    endfor
endfunction

command! TabBufOnly call <SID>TabBufOnly()




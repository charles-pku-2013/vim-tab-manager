function! <SID>CloseAndOpenInNewTab()
    let l:file = expand('%')
    execute 'q'
    execute 'tabe ' . l:file
endfunction

nnoremap <leader>tb :call <SID>CloseAndOpenInNewTab()<CR>

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
    for winnr in l:win_list
        let l:bufnr = winbufnr(winnr)
        if (bufloaded(l:bufnr) && buflisted(l:bufnr))
            let l:main_winnr = winnr
            break
        endif
    endfor
    return l:main_winnr
endfunction

function! <SID>SetMainWindow()
    let l:main_winnr = <SID>GetMainWindow()
    let l:main_winsize = g:my_screen_width / 5 * 4
    " echom "main window: " . l:main_winnr
    " echom "main window size: " . l:main_winsize
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
    " for winnr in l:win_list
        " echom "Adjusting " . winnr
        " execute "vertical " . winnr . "res 0"
    " endfor
endfunction

function! <SID>ExchangeMainWindow()
    execute "wincmd p"
    call feedkeys("\<C-m>")
endfunction

command Main call <SID>SetMainWindow()
command ExchangeMain call <SID>ExchangeMainWindow()
nnoremap <silent> <C-m> :Main<CR>
" Alt - m
nnoremap <silent> µ :ExchangeMain<CR>


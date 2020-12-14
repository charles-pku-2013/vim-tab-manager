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

command Cdt call <SID>CloseDup()



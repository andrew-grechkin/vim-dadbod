function! db#adapter#sqlite#canonicalize(url) abort
  return db#url#canonicalize_file(a:url)
endfunction

function! db#adapter#sqlite#test_file(file) abort
  if getfsize(a:file) >= 100 && readfile(a:file, '', 1)[0] =~# '^SQLite format 3\n'
    return 1
  endif
endfunction

function! s:path(url) abort
  let path = db#url#file_path(a:url)
  if path =~# '^[\/]\=$'
    if !exists('s:session')
      let s:session = tempname() . '.sqlite3'
    endif
    let path = s:session
  endif
  return path
endfunction

function! db#adapter#sqlite#dbext(url) abort
  return {'dbname': s:path(a:url)}
endfunction

function! db#adapter#sqlite#command(url) abort
  return ['sqlite3', s:path(a:url)]
endfunction

function! db#adapter#sqlite#interactive(url) abort
  return db#adapter#sqlite#command(a:url) + ['-tabs', '-header']
endfunction

function! db#adapter#sqlite#filter(url) abort
  return db#adapter#sqlite#command(a:url) + ['-tabs', '-header']
endfunction

function! db#adapter#sqlite#tables(url) abort
  return split(join(db#systemlist(db#adapter#sqlite#command(a:url) + ['-noheader', '.tables'])))
endfunction

function! db#adapter#sqlite#massage(input) abort
  return a:input . "\n;"
endfunction

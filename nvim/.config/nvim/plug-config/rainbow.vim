let g:rainbow_active = 1

let g:rainbow_conf = {
\	'guifgs': ['Gold', 'Orchid', 'LightSkyBlue'],
\	'ctermfgs': ['darkblue', 'darkyellow', 'darkcyan', 'darkmagenta'],
\	'operators': '_,_',
\	'parentheses': map(['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/'], 'v:val." fold"'),
\	'parentheses_options': 'contains=@NoSpell',
\	'separately': {
\		'csv': {
\			'parentheses': ['start=/\v[^,]*\,/ step=// end=/$/ keepend'],
\		},
\		'coq': 0,
\	}
\}

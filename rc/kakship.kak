declare-option -docstring "modelinefmt backup value." str kakship_modelinefmt_bak %opt{modelinefmt}

define-command -docstring "kakship-enable: require kakship module and enable kakship for all regular windows." \
kakship-enable %{
	remove-hooks global kakship(-.*)?
	hook -group kakship global BufCreate .* %{
		require-module kakship
		# hook -group kakship buffer NormalIdle "" starship-modeline
		# hook -group kakship buffer InsertIdle "" starship-modeline
		starship-modeline
	}
}

provide-module kakship %{

define-command -hidden -docstring "set modeline using kakship" starship-modeline %{
	evaluate-commands %sh{
		# trigger var export: kak_buffile, kak_session, kak_client, kak_config, kak_cursor_line, kak_buf_line_count
		#                     kak_opt_filetype, kak_opt_lsp_progress_indicator,
		#                     kak_opt_lsp_diagnostic_error_count, kak_opt_lsp_diagnostic_warning_count, kak_opt_lsp_diagnostic_hint_count,
		#                     kak_opt_lsp_diagnostic_hint_count,
		#                     kak_opt_lsp_modeline_code_actions, kak_opt_lsp_modeline_progress, kak_opt_lsp_modeline
		dir=${kak_buffile%/*}
		[ "$dir" != "$kak_buffile" ] && cd $dir
		printf 'set-option buffer modelinefmt %%{%s}' "$(kakship prompt)"
	}
}

define-command -docstring "disable starship modeline" kakship-disable %{
	remove-hooks global kakship(-.*)?
	remove-hooks buffer kakship(-.*)?
	set-option buffer modelinefmt %opt{kakship_modelinefmt_bak}
}

}

use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions
-- 通过session id搜索iTerm所有的session
on findSession(session_id)
	tell application "iTerm"
		repeat with ww in windows
			repeat with tt in ww's tabs
				repeat with ss in sessions of tt
					if id of ss = session_id then
						return ss
					end if
				end repeat
			end repeat
		end repeat
	end tell
	return false
end findSession

-- 在iTerm中运行cmd
on runCommandIniTerm(cmd)
	tell application "iTerm"
		activate
		set created to false
		if not (exists current window) then
			create window with default profile
			set created to true
		end if
		tell current window
			if not created then
				create tab with default profile
			end if
			set session_vim to current session
			-- log "session_vim:" & session_vim
			tell session_vim
				write text cmd
			end tell
		end tell
	end tell
	return session_vim
end runCommandIniTerm

-- 等待在iterm中运行的cmd完成
on waitCommandiniTerm(session_vim)
	-- 等待vim启动完成, 通过session
	repeat until name of session_vim starts with "vim"
		delay 1
	end repeat
	-- 获取session id, 用于后续的查找
	set session_vim_id to id of session_vim
	repeat
		-- 如果session不存在，则重新搜索
		if application "iTerm" is not running then
			exit repeat
		end if
		if not (exists session_vim) then
			set session_vim to my findSession(session_vim_id)
			if session_vim = false then
				exit repeat
			end if
		end if
		if name of session_vim does not start with "vim" then
			exit repeat
		end if
		delay 1
	end repeat
end waitCommandiniTerm

set session_vim to my runCommandIniTerm("vim")
my waitCommandiniTerm(session_vim)


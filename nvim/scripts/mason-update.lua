-- Headless "upgrade all installed Mason packages" for shell automation.
-- mason.nvim has no built-in command for this; :MasonUpdate only refreshes the
-- registry index. Refresh the registry, then reinstall every installed package
-- whose latest version differs, blocking until all installs settle, then quit.

local ok, registry = pcall(require, "mason-registry")
if not ok then
	io.stderr:write("mason-registry not available\n")
	vim.cmd("qa!")
	return
end

local done, pending, updated = false, 0, 0

registry.update(function(success)
	if not success then
		io.stderr:write("mason: registry update failed\n")
		done = true
		return
	end

	for _, pkg in ipairs(registry.get_installed_packages()) do
		local cur = pkg:get_installed_version()
		local latest = pkg:get_latest_version()
		if cur and latest and cur ~= latest and pkg:is_installable({ version = latest }) then
			pending = pending + 1
			print(("mason: updating %s  %s -> %s"):format(pkg.name, cur, latest))
			pkg:install({ version = latest }, function(ok_install)
				updated = updated + 1
				pending = pending - 1
				if not ok_install then
					io.stderr:write(("mason: %s failed to update\n"):format(pkg.name))
				end
				if pending == 0 then
					done = true
				end
			end)
		end
	end

	if pending == 0 then
		print("mason: all packages up to date")
		done = true
	end
end)

-- Drive the event loop until the registry refresh + all installs finish (10 min cap).
vim.wait(600000, function()
	return done
end, 200)

if updated > 0 then
	print(("mason: %d package(s) updated"):format(updated))
end
vim.cmd("qa!")

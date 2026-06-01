-- Filetype aliases used by LSP configurations.
vim.filetype.add({
	extension = {
		xsl = "xsl",
	},
	pattern = {
		["compose%.ya?ml"] = "yaml.docker-compose",
		["docker%-compose%.ya?ml"] = "yaml.docker-compose",
		["%.gitlab%-ci%.ya?ml"] = "yaml.gitlab",
		["values%.ya?ml"] = "yaml.helm-values",
	},
})

JEKYLL_SERVE_COMMAND=script/jekyll serve --host 0.0.0.0 --incremental --trace
JEKYLL_BUILD_COMMAND=script/jekyll build
TOKEN_CHECK_COMMAND=git config jekyll.github.token >/dev/null

.PHONY: serve
serve: token-check
	@echo ${JEKYLL_SERVE_COMMAND}
	@GITHUB_TOKEN=$(shell git config jekyll.github.token) ${JEKYLL_SERVE_COMMAND}

.PHONY: build
build: token-check
	@echo ${JEKYLL_BUILD_COMMAND}
	@GITHUB_TOKEN=$(shell git config jekyll.github.token) ${JEKYLL_BUILD_COMMAND}

.PHONY: token-check
token-check:
	@${TOKEN_CHECK_COMMAND} || echo "No GitHub token found\nHint: git config --local --add jekyll.github.token <your-token>"
	@${TOKEN_CHECK_COMMAND}

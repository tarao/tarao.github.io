JEKYLL_SERVE_COMMAND=bundle exec jekyll serve --trace
JEKYLL_BUILD_COMMAND=bundle exec jekyll build
TOKEN_CHECK_COMMAND=git config jekyll.github.token >/dev/null

.PHONY: serve
serve: token-check
	bundle install
	@echo ${JEKYLL_SERVE_COMMAND}
	@GITHUB_TOKEN=$(shell git config jekyll.github.token) ${JEKYLL_SERVE_COMMAND}

.PHONY: build
build: token-check
	bundle install
	@echo ${JEKYLL_BUILD_COMMAND}
	@GITHUB_TOKEN=$(shell git config jekyll.github.token) ${JEKYLL_BUILD_COMMAND}

.PHONY: token-check
token-check:
	@${TOKEN_CHECK_COMMAND} || echo "No GitHub token found\nHint: git config --local --add jekyll.github.token <your-token>"
	@${TOKEN_CHECK_COMMAND}

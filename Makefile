RELEASE := $(GOPATH)/bin/github-release

release:
ifndef version
	@echo "Please provide a version"
	exit 1
endif
ifndef GITHUB_TOKEN
	@echo "Please set GITHUB_TOKEN in the environment"
	exit 1
endif
	git tag $(version)
	git push origin --tags
	mkdir -p releases/$(version)
	GOOS=linux GOARCH=amd64 go build -o releases/$(version)/generate-tls-cert-linux-amd64 .
	GOOS=darwin GOARCH=amd64 go build -o releases/$(version)/generate-tls-cert-darwin-amd64 .
	GOOS=windows GOARCH=amd64 go build -o releases/$(version)/generate-tls-cert-windows-amd64 .
	# these commands are not idempotent so ignore failures if an upload repeats
	$(RELEASE) release --user kevinburke --repo generate-tls-cert --tag $(version) || true
	$(RELEASE) upload --user kevinburke --repo generate-tls-cert --tag $(version) --name generate-tls-cert-linux-amd64 --file releases/$(version)/generate-tls-cert-linux-amd64 || true
	$(RELEASE) upload --user kevinburke --repo generate-tls-cert --tag $(version) --name generate-tls-cert-darwin-amd64 --file releases/$(version)/generate-tls-cert-darwin-amd64 || true
	$(RELEASE) upload --user kevinburke --repo generate-tls-cert --tag $(version) --name generate-tls-cert-windows-amd64 --file releases/$(version)/generate-tls-cert-windows-amd64 || true

re: clean up

up:
	./scripts/install.sh
	./scripts/login_aws.sh
	./scripts/init_terraform.sh

clean:
	./scripts/uninstall.sh

help:
	@tail -n 1 ./Makefile |  sed -e 's/.PHONY:/Commands:/g'

.PHONY: re up clean help
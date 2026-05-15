re: clean up

up:
	terraform init && \
	terraform validate && \
	terraform plan && \
	terraform apply -auto-approve

clean:
	terraform destroy -auto-approve
	rm -rf .terraform* terraform.tfstate*

help:
	@tail -n 1 ./Makefile |  sed -e 's/.PHONY:/Commands:/g'

.PHONY: re up clean help
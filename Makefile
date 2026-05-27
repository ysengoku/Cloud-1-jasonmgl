re: fclean up

up:
	./scripts/install.sh
	./scripts/login_aws.sh
	./scripts/init_terraform.sh
	./scripts/init_ansible.sh

down:
	mise exec -- terraform apply -auto-approve -invoke=action.aws_ec2_stop_instance.force_stop

clean:
	rm -f inventory.*

fclean: clean
	./scripts/uninstall.sh
	rm -rf .terraform* terraform.tfstate*

test:
	ansible aws -m ping -i inventory.yaml

help:
	@tail -n 1 ./Makefile |  sed -e 's/.PHONY:/Commands:/g'

.PHONY: re up down clean fclean test help
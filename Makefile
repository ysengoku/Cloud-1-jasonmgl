re: fclean up

up:
	./scripts/install.sh
	./scripts/login_aws.sh
	./scripts/init_terraform.sh
	./scripts/init_ansible.sh
	./scripts/provision_ec2.sh

down:
	mise exec -- terraform -chdir=terraform apply -auto-approve -invoke=action.aws_ec2_stop_instance.force_stop

clean:
	rm -f ansible/inventory.ini ansible/inventory.yaml

fclean: clean
	./scripts/uninstall.sh
	rm -rf terraform/.terraform* terraform/terraform.tfstate*

test:
	ANSIBLE_CONFIG=ansible/ansible.cfg ansible aws -m ping

# provision:
# 	ANSIBLE_CONFIG=ansible/ansible.cfg ansible-playbook <playbook>

help:
	@tail -n 1 ./Makefile |  sed -e 's/.PHONY:/Commands:/g'

.PHONY: re up down clean fclean test provision help

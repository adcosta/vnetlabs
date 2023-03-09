#!/bin/bash

# ---------------------
# funções auxiliares
# ---------------------
# diz o que vai executar, executa e diz se correu bem
# parametros: lista de comandos a executar
display_and_execute() {
	for param in "$@"; do 
		echo "--------------------------------------------------------------------"
		echo "\$ $param"
		echo "--------------------------------------------------------------------"
		$param
		if [ $? -eq 0 ]; then
			echo "===> Ok <=== "
		else
			echo "===> Failed <=== "
  		fi
	done
}

# read -rsp "===> MOSTRA O ESTADO (Qualquer tecla para continuar)" -n 1
# display_and_execute "ip link" "ip netns"

echo "===> APAGAR NAMESPACES H1, H2, H3 e H4 PARA OS HOSTS"
display_and_execute "sudo ip netns del H1"
display_and_execute "sudo ip netns del H2"
display_and_execute "sudo ip netns del H3"
display_and_execute "sudo ip netns del H4"

echo "===> APAGAR OS SWITCHES SW1 e SW2"
display_and_execute "sudo ovs-vsctl del-br SW1"
display_and_execute "sudo ovs-vsctl del-br SW2"
display_and_execute "sudo ovs-vsctl list-br"
display_and_execute "sudo ovs-vsctl show"

echo "===> MOSTRA O ESTADO"
display_and_execute "ip link" "ip netns"


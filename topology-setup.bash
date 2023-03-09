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

read -rsp "===> MOSTRA O ESTADO (Qualquer tecla para continuar)" -n 1
display_and_execute "ip link" "ip netns"

read -rsp "===> CRIAR NAMESPACES H1, H2, H3 e H4 PARA OS HOSTS (Qualquer tecla para continuar)" -n 1
display_and_execute "sudo ip netns add H1"
display_and_execute "sudo ip netns add H2"
display_and_execute "sudo ip netns add H3"
display_and_execute "sudo ip netns add H4"
display_and_execute "ip netns"

read -rsp "===> CRIAR OS SWITCHES SW1 e SW2 (Qualquer tecla para continuar)" -n 1
display_and_execute "sudo ovs-vsctl add-br SW1"
display_and_execute "sudo ovs-vsctl add-br SW2"
display_and_execute "sudo ovs-vsctl list-br"
display_and_execute "sudo ovs-vsctl show"

read -rsp "===> CRIAR OS LINKS ENTRE OS HOSTS E OS SWITCHES (Qualquer tecla para continuar)" -n 1
display_and_execute "sudo ip link add h1-eth0 type veth peer name sw1-eth0"
display_and_execute "sudo ip link add h2-eth0 type veth peer name sw1-eth1"
display_and_execute "sudo ip link add h3-eth0 type veth peer name sw2-eth0"
display_and_execute "sudo ip link add h4-eth0 type veth peer name sw2-eth1"

read -rsp "===> CONECTAR OS LINKS AOS HOSTS E AOS SWITCHES (Qualquer tecla para continuar)" -n 1
display_and_execute "sudo ip link set h1-eth0 netns H1"
display_and_execute "sudo ip link set h2-eth0 netns H2"
display_and_execute "sudo ip link set h3-eth0 netns H3"
display_and_execute "sudo ip link set h4-eth0 netns H4"
display_and_execute "sudo ovs-vsctl add-port SW1 sw1-eth0"
display_and_execute "sudo ovs-vsctl add-port SW1 sw1-eth1"
display_and_execute "sudo ovs-vsctl add-port SW2 sw2-eth0"
display_and_execute "sudo ovs-vsctl add-port SW2 sw2-eth1"

read -rsp "===> COLOCAR OS LINKS UP (Qualquer tecla para continuar)" -n 1
display_and_execute "sudo ip netns exec H1 ip link set dev lo up"
display_and_execute "sudo ip netns exec H1 ip link set h1-eth0 up"
display_and_execute "sudo ip netns exec H2 ip link set dev lo up"
display_and_execute "sudo ip netns exec H2 ip link set h2-eth0 up"
display_and_execute "sudo ip netns exec H3 ip link set dev lo up"
display_and_execute "sudo ip netns exec H3 ip link set h3-eth0 up"
display_and_execute "sudo ip netns exec H4 ip link set dev lo up"
display_and_execute "sudo ip netns exec H4 ip link set h4-eth0 up"
display_and_execute "sudo ip link set sw1-eth0 up"
display_and_execute "sudo ip link set sw1-eth1 up"
display_and_execute "sudo ip link set sw2-eth0 up"
display_and_execute "sudo ip link set sw2-eth1 up"

read -rsp "===> COLOCAR OS ENDEREÇOS IP (Qualquer tecla para continuar)" -n 1
display_and_execute "sudo ip netns exec H1 ip address add 10.0.1.1/24 broadcast 10.0.1.255 dev h1-eth0"
display_and_execute "sudo ip netns exec H2 ip address add 10.0.2.1/24 broadcast 10.0.2.255 dev h2-eth0"
display_and_execute "sudo ip netns exec H3 ip address add 10.0.1.2/24 broadcast 10.0.1.255 dev h3-eth0"
display_and_execute "sudo ip netns exec H4 ip address add 10.0.2.2/24 broadcast 10.0.2.255 dev h4-eth0"

read -rsp "===> MOSTRA ESTADO DAS INTERFACES NOS HOSTS E SWITCHES(Qualquer tecla para continuar)" -n 1
display_and_execute "sudo ip link show sw1-eth0"
display_and_execute "sudo ip link show sw1-eth1"
display_and_execute "sudo ip link show sw2-eth0"
display_and_execute "sudo ip link show sw2-eth1"
display_and_execute "sudo ovs-vsctl show"
display_and_execute "sudo ip netns exec H1 ip addr show"
display_and_execute "sudo ip netns exec H2 ip addr show"
display_and_execute "sudo ip netns exec H3 ip addr show"
display_and_execute "sudo ip netns exec H4 ip addr show"

read -rsp "===> CRIAR A LIGAÇÃO TRUNK ENTRE SWITCHES (Qualquer tecla para continuar)" -n 1
display_and_execute "sudo ip link add sw1-tr0 type veth peer name sw2-tr0"
display_and_execute "sudo ovs-vsctl add-port SW1 sw1-tr0"
display_and_execute "sudo ovs-vsctl add-port SW2 sw2-tr0"
display_and_execute "sudo ip link set sw1-tr0 up"
display_and_execute "sudo ip link set sw2-tr0 up"
display_and_execute "sudo ovs-vsctl show"
display_and_execute "sudo ovs-appctl fdb/show SW1"
display_and_execute "sudo ovs-appctl fdb/show SW2"

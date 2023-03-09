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

echo "===> Gerar tráfego ICMP e ver as tabelas do switch" 
display_and_execute "sudo ip netns exec H1 ping -c 3 10.0.1.2"
display_and_execute "sudo ip netns exec H2 ping -c 3 10.0.2.2"
display_and_execute "sudo ovs-appctl fdb/show SW1"
display_and_execute "sudo ovs-appctl fdb/show SW2"

echo "===> Limpar as tabelas dos switches" 
display_and_execute "sudo ovs-appctl fdb/flush SW1"
display_and_execute "sudo ovs-appctl fdb/flush SW2"

echo "===> CONFIGURAR AS PORTAS NAS VLANS E AS LIGAÇÕES TRUNK" 
display_and_execute "sudo ovs-vsctl set port sw1-eth0 tag=10"
display_and_execute "sudo ovs-vsctl set port sw1-eth1 tag=20"
display_and_execute "sudo ovs-vsctl set port sw2-eth0 tag=10"
display_and_execute "sudo ovs-vsctl set port sw2-eth1 tag=20"
display_and_execute "sudo ovs-vsctl set port sw1-tr0 trunk=10,20"
display_and_execute "sudo ovs-vsctl set port sw2-tr0 trunk=10,20"
display_and_execute "sudo ovs-vsctl show"

echo "===> Gerar tráfego ICMP e ver as tabelas do switch" 
display_and_execute "sudo ip netns exec H1 ping -c 3 10.0.1.2"
display_and_execute "sudo ip netns exec H2 ping -c 3 10.0.2.2"
display_and_execute "sudo ovs-appctl fdb/show SW1"
display_and_execute "sudo ovs-appctl fdb/show SW2"

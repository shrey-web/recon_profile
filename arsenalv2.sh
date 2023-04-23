#!/bin/bash -i
#Check if the script is executed with root privileges
if [ "$EUID" -ne 0 ]
  then echo -e ${RED}"Please execute this script with root privileges !"
  exit
fi

#Creating tools directory if not exist
source ./.env && mkdir -p $TOOLS_DIRECTORY;
clear;

ENVIRONMENT () {
	echo -e ${BLUE}"[ENVIRONMENT]" ${RED}"Packages required installation in progress ...";
	#Check Operating System
	OS=$(lsb_release -i 2> /dev/null | sed 's/:\t/:/' | cut -d ':' -f 2-)
	if [ "$OS" == "Debian" ] || [ "$OS" == "Linuxmint" ]; then
		#Specific Debian
		#chromium
		apt-get update -y > /dev/null 2>&1;
		apt-get install chromium python python3 python3-pip unzip make gcc libpcap-dev curl build-essential libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev ruby libgmp-dev zlib1g-dev -y > /dev/null 2>&1;
		cd /tmp && curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py > /dev/null 2>&1 && python2 get-pip.py > /dev/null 2>&1;
	elif [ "$OS" == "Ubuntu" ]; then
		#Specific Ubuntu
		#Specificity : chromium-browser replace chromium
        apt-get update -y > /dev/null 2>&1
        apt-get install chromium-browser python3 python3-pip jq git dnsutils whois unzip make vim wget tree zip libpcap-dev curl build-essential default-jdk ruby-full -y > /dev/null 2>&1;
        pip3 install --upgrade pip
        pip3 install requests
        pip3 install pyOpenSSL --upgrade
	elif [ "$OS" == "Kali" ]; then
		#Specific Kali Linux
		#Specificity : no package name with "python"
        apt-get update -y > /dev/null 2>&1;
        apt-get install chromium python3 python3-pip unzip make gcc libpcap-dev curl build-essential libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev ruby libgmp-dev zlib1g-dev -y > /dev/null 2>&1;
        cd /tmp && curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py > /dev/null 2>&1 && python2 get-pip.py > /dev/null 2>&1;
        pip install -U setuptools > /dev/null 2>&1;
        #Needed for NoSQLMap
        pip install couchdb pbkdf2 pymongo ipcalc > /dev/null 2>&1;    
	else
        echo "OS unrecognized. Please check the compatibility with your system.";
        echo "End of the script";
        exit;
	fi
unset OS
	#Bash colors
	sed -i '/^#.*force_color_prompt/s/^#//' ~/.bashrc && source ~/.bashrc
	echo -e ${BLUE}"[ENVIRONMENT]" ${GREEN}"Packages required installation is done !"; echo "";
	#Generic fot both OS - Golang environment
	echo -e ${BLUE}"[ENVIRONMENT]" ${RED}"Golang environment installation in progress ...";
	cd /tmp && curl -O https://dl.google.com/go/go$GOVER.linux-amd64.tar.gz > /dev/null 2>&1 && tar xvf go$GOVER.linux-amd64.tar.gz > /dev/null 2>&1 && mv go /usr/local && echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc && source ~/.bashrc;
	echo -e ${BLUE}"[ENVIRONMENT]" ${GREEN}"Golang environment installation is done !"; echo "";
}

SUBDOMAINS_ENUMERATION () {
	#Subfinder
	echo -e ${BLUE}"[SUBDOMAINS ENUMERATION]" ${RED}"Subfinder installation in progress ...";
	go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest > /dev/null 2>&1 && ln -s ~/go/bin/subfinder /usr/local/bin/;
	echo -e ${BLUE}"[SUBDOMAINS ENUMERATION]" ${GREEN}"Subfinder installation is done !"; echo "";
	#Github-subdomains
	echo -e ${BLUE}"[SUBDOMAINS ENUMERATION]" ${RED}"Github-subdomains installation in progress ...";
	go install github.com/gwen001/github-subdomains@latest > /dev/null 2>&1 && ln -s ~/go/bin/github-subdomains /usr/local/bin/;
	echo -e ${BLUE}"[SUBDOMAINS ENUMERATION]" ${GREEN}"Github-subdomains installation is done !"; echo "";
	#Amass
	echo -e ${BLUE}"[SUBDOMAINS ENUMERATION]" ${RED}"Amass installation in progress ...";
	go install -v github.com/OWASP/Amass/v3/...@master > /dev/null 2>&1 && ln -s ~/go/bin/amass /usr/local/bin/;
	echo -e ${BLUE}"[SUBDOMAINS ENUMERATION]" ${GREEN}"Amass installation is done !"; echo "";
}

DNS_RESOLVER () {
	#dnsx
	echo -e ${BLUE}"[DNS RESOLVER]" ${RED}"dnsx installation in progress ...";
	go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest > /dev/null 2>&1 && ln -s ~/go/bin/dnsx /usr/local/bin/;
	echo -e ${BLUE}"[DNS RESOLVER]" ${GREEN}"dnsx installation is done !"; echo "";
	#PureDNS
	echo -e ${BLUE}"[DNS RESOLVER]" ${RED}"PureDNS installation in progress ...";
	go install github.com/d3mondev/puredns/v2@latest > /dev/null 2>&1 && ln -s ~/go/bin/puredns /usr/local/bin;
	echo -e ${BLUE}"[DNS RESOLVER]" ${GREEN}"PureDNS installation is done !"; echo "";
}

VISUAL_RECON () {
	#Gowitness
	echo -e ${BLUE}"[VISUAL RECON]" ${RED}"Gowitness installation in progress ...";
	go install github.com/sensepost/gowitness@latest > /dev/null 2>&1 && ln -s ~/go/bin/gowitness /usr/local/bin;
	echo -e ${BLUE}"[VISUAL RECON]" ${GREEN}"Gowitness installation is done !"; echo "";
}

HTTP_PROBE () {
	#httpx
	echo -e ${BLUE}"[HTTP PROBE]" ${RED}"httpx installation in progress ...";
	go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest > /dev/null 2>&1 && ln -s ~/go/bin/httpx /usr/local/bin/;
	echo -e ${BLUE}"[HTTP PROBE]" ${GREEN}"Httpx installation is done !"; echo "";
	#httprobe
	echo -e ${BLUE}"[HTTP PROBE]" ${RED}"httprobe installation in progress ...";
	go install github.com/tomnomnom/httprobe@latest > /dev/null 2>&1 && ln -s ~/go/bin/httprobe /usr/local/bin/;
	echo -e ${BLUE}"[HTTP PROBE]" ${GREEN}"httprobe installation is done !"; echo "";
}

WEB_CRAWLING () {
	#Katana
	echo -e ${BLUE}"[WEB CRAWLING]" ${RED}"Katana installation in progress ...";
	go install github.com/projectdiscovery/katana/cmd/katana@latest > /dev/null 2>&1 && ln -s ~/go/bin/katana /usr/local/bin/;
	echo -e ${BLUE}"[WEB CRAWLING]" ${GREEN}"Katana installation is done !"; echo "";
	#Hakrawler
	echo -e ${BLUE}"[WEB CRAWLING]" ${RED}"Hakrawler installation in progress ...";
	go install github.com/hakluke/hakrawler@latest > /dev/null 2>&1 && ln -s ~/go/bin/hakrawler /usr/local/bin/;
	echo -e ${BLUE}"[WEB CRAWLING]" ${GREEN}"Hakrawler installation is done !"; echo "";
}

NETWORK_SCANNER () {
	#Nmap
	echo -e ${BLUE}"[NETWORK SCANNER]" ${RED}"Nmap installation in progress ...";
	apt-get install nmap -y > /dev/null 2>&1;
	echo -e ${BLUE}"[NETWORK SCANNER]" ${GREEN}"Nmap installation is done !"; echo "";
	#naabu
	echo -e ${BLUE}"[NETWORK SCANNER]" ${RED}"Naabu installation in progress ...";
	go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest > /dev/null 2>&1 && ln -s ~/go/bin/naabu /usr/local/bin/;
	echo -e ${BLUE}"[NETWORK SCANNER]" ${GREEN}"Naabu installation is done !"; echo "";
}

HTTP_PARAMETER () {
	#Arjun
	echo -e ${BLUE}"[HTTP PARAMETER DISCOVERY]" ${RED}"Arjun installation in progress ...";
	pip3 install arjun > /dev/null 2>&1;
	echo -e ${BLUE}"[HTTP PARAMETER DISCOVERY]" ${GREEN}"Arjun installation is done !"; echo "";
	#x8
	echo -e ${BLUE}"[HTTP PARAMETER DISCOVERY]" ${RED}"x8 installation in progress ...";
	cd /tmp && wget https://github.com/Sh1Yo/x8/releases/download/v3.4.0/x86-linux-x8.tar.gz > /dev/null 2>&1 && tar -zxvf x86-linux-x8.tar.gz > /dev/null 2>&1 && mv x8 /usr/local/bin/x8;
	echo -e ${BLUE}"[HTTP PARAMETER DISCOVERY]" ${GREEN}"x8 installation is done !"; echo "";
}

FUZZING_TOOLS () {
	#ffuf
	echo -e ${BLUE}"[FUZZING TOOLS]" ${RED}"ffuf installation in progress ...";
	go install github.com/ffuf/ffuf@latest > /dev/null 2>&1 && ln -s ~/go/bin/ffuf /usr/local/bin/;
	echo -e ${BLUE}"[FUZZING TOOLS]" ${GREEN}"ffuf installation is done !"; echo "";
	#gobuster
	echo -e ${BLUE}"[FUZZING TOOLS]" ${RED}"Gobuster installation in progress ...";
	go install github.com/OJ/gobuster/v3@latest > /dev/null 2>&1 && ln -s ~/go/bin/gobuster /usr/local/bin/;
	echo -e ${BLUE}"[FUZZING TOOLS]" ${GREEN}"Gobuster installation is done !"; echo "";
}

API_TOOLS () {
	#Kiterunner
	echo -e ${BLUE}"[API TOOLS]" ${RED}"Kiterunner installation in progress ...";
	cd /tmp && wget https://github.com/assetnote/kiterunner/releases/download/v1.0.2/kiterunner_1.0.2_linux_amd64.tar.gz > /dev/null 2>&1 && tar xvf kiterunner_1.0.2_linux_amd64.tar.gz > /dev/null 2>&1 && mv kr /usr/local/bin;
	cd $TOOLS_DIRECTORY && mkdir -p kiterunner-wordlists && cd kiterunner-wordlists && wget https://wordlists-cdn.assetnote.io/data/kiterunner/routes-large.kite.tar.gz > /dev/null 2>&1 && wget https://wordlists-cdn.assetnote.io/data/kiterunner/routes-small.kite.tar.gz > /dev/null 2>&1 && for f in *.tar.gz; do tar xf "$f"; rm -Rf "$f"; done
	echo -e ${BLUE}"[API TOOLS]" ${GREEN}"Kiterunner installation is done !"; echo "";
}


WORDLISTS () {
	#SecLists
	echo -e ${BLUE}"[WORDLISTS]" ${RED}"SecLists installation in progress ...";
	cd $TOOLS_DIRECTORY && git clone https://github.com/danielmiessler/SecLists.git > /dev/null 2>&1;
	echo -e ${BLUE}"[WORDLISTS]" ${GREEN}"SecLists installation is done !"; echo "";
}

VULNS_XSS () {
	#Dalfox
	echo -e ${BLUE}"[VULNERABILITY - XSS]" ${RED}"Dalfox installation in progress ...";
	go install github.com/hahwul/dalfox/v2@latest > /dev/null 2>&1 && ln -s ~/go/bin/dalfox /usr/local/bin/;
	echo -e ${BLUE}"[VULNERABILITY - XSS]" ${GREEN}"Dalfox installation is done !"; echo "";
	#XSStrike
	echo -e ${BLUE}"[VULNERABILITY - XSS]" ${RED}"XSStrike installation in progress ...";
	cd $TOOLS_DIRECTORY && git clone https://github.com/s0md3v/XSStrike > /dev/null 2>&1 && cd XSStrike && pip3 install -r requirements.txt > /dev/null 2>&1;
	echo -e ${BLUE}"[VULNERABILITY - XSS]" ${GREEN}"XSStrike installation is done !"; echo "";
	#Gxss
	echo -e ${BLUE}"[VULNERABILITY - XSS]" ${RED}"Gxss installation in progress ...";
	go install github.com/KathanP19/Gxss@latest > /dev/null 2>&1 && ln -s ~/go/bin/Gxss /usr/local/bin/;
	echo -e ${BLUE}"[VULNERABILITY - XSS]" ${GREEN}"Gxss installation is done !"; echo "";
}

VULNS_SQLI () {
	#SQLmap
	echo -e ${BLUE}"[VULNERABILITY - SQL Injection]" ${RED}"SQLMap installation in progress ...";
	apt-get install -y sqlmap > /dev/null 2>&1
	echo -e ${BLUE}"[VULNERABILITY - SQL Injection]" ${GREEN}"SQLMap installation is done !"; echo "";
}

VULNS_SCANNER () {
	#Nuclei + nuclei templates
	echo -e ${BLUE}"[VULNERABILITY SCANNER]" ${RED}"Nuclei installation in progress ...";
	go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest > /dev/null 2>&1 && ln -s ~/go/bin/nuclei /usr/local/bin/;
	nuclei -update-templates > /dev/null 2>&1;
	echo -e ${BLUE}"[VULNERABILITY SCANNER]" ${GREEN}"Nuclei installation is done !"; echo "";
}

JS_HUNTING () {
	#Linkfinder
	echo -e ${BLUE}"[JS FILES HUNTING]" ${RED}"xnLinkfinder installation in progress ...";
	cd $TOOLS_DIRECTORY && git clone https://github.com/xnl-h4ck3r/xnLinkFinder.git > /dev/null 2>&1 && cd xnLinkFinder && python3 setup.py install > /dev/null 2>&1;
	echo -e ${BLUE}"[JS FILES HUNTING]" ${GREEN}"xnLinkfinder installation is done !"; echo "";
	#SecretFinder
	echo -e ${BLUE}"[JS FILES HUNTING]" ${RED}"SecretFinder installation in progress ...";
	cd $TOOLS_DIRECTORY && git clone https://github.com/m4ll0k/SecretFinder.git > /dev/null 2>&1 && cd SecretFinder && pip3 install -r requirements.txt > /dev/null 2>&1;
	echo -e ${BLUE}"[JS FILES HUNTING]" ${GREEN}"SecretFinder installation is done !"; echo "";
	#jsfinder
	echo -e ${BLUE}"[USEFUL TOOLS]" ${RED}"jsfinder installation in progress ...";
	go install -v github.com/kacakb/jsfinder@latest > /dev/null 2>&1 && ln -s ~/go/bin/jsfinder /usr/local/bin/;
	echo -e ${BLUE}"[USEFUL TOOLS]" ${GREEN}"jsfinder installation is done !"; echo "";
	#subjs
	echo -e ${BLUE}"[JS FILES HUNTING]" ${RED}"subjs installation in progress ...";
	cd /tmp && wget https://github.com/lc/subjs/releases/download/v1.0.1/subjs_1.0.1_linux_amd64.tar.gz > /dev/null 2>&1 && tar xvf subjs_1.0.1_linux_amd64.tar.gz > /dev/null 2>&1 && mv subjs /usr/local/bin;
	echo -e ${BLUE}"[JS FILES HUNTING]" ${GREEN}"subjs installation is done !"; echo "";
}

USEFUL_TOOLS () {
	#getallurls
	echo -e ${BLUE}"[USEFUL TOOLS]" ${RED}"getallurls installation in progress ...";
	go install github.com/lc/gau/v2/cmd/gau@latest > /dev/null 2>&1 && ln -s ~/go/bin/gau /usr/local/bin/;
	echo -e ${BLUE}"[USEFUL TOOLS]" ${GREEN}"getallurls installation is done !"; echo "";
	#waybackurls
	echo -e ${BLUE}"[USEFUL TOOLS]" ${RED}"waybackurls installation in progress ...";
	go install github.com/tomnomnom/waybackurls@latest > /dev/null 2>&1 && ln -s ~/go/bin/waybackurls /usr/local/bin/;
	echo -e ${BLUE}"[USEFUL TOOLS]" ${GREEN}"waybackurls installation is done !"; echo "";
	#meg
	echo -e ${BLUE}"[USEFUL TOOLS]" ${RED}"meg installation in progress ...";
	go install github.com/tomnomnom/meg@latest > /dev/null 2>&1 && ln -s ~/go/bin/meg /usr/local/bin/;
	echo -e ${BLUE}"[USEFUL TOOLS]" ${GREEN}"meg installation is done !"; echo "";
	#unfurl
	echo -e ${BLUE}"[USEFUL TOOLS]" ${RED}"unfurl installation in progress ...";
	go install github.com/tomnomnom/unfurl@latest > /dev/null 2>&1 && ln -s ~/go/bin/unfurl /usr/local/bin/;
	echo -e ${BLUE}"[USEFUL TOOLS]" ${GREEN}"unfurl installation is done !"; echo "";
	#anew
	echo -e ${BLUE}"[USEFUL TOOLS]" ${RED}"anew installation in progress ...";
	go install -v github.com/tomnomnom/anew@latest > /dev/null 2>&1 && ln -s ~/go/bin/anew /usr/local/bin/;
	echo -e ${BLUE}"[USEFUL TOOLS]" ${GREEN}"anew installation is done !"; echo "";
	#gron
	echo -e ${BLUE}"[USEFUL TOOLS]" ${RED}"gron installation in progress ...";
	go install github.com/tomnomnom/gron@latest > /dev/null 2>&1 && ln -s ~/go/bin/gron /usr/local/bin/;
	echo -e ${BLUE}"[USEFUL TOOLS]" ${GREEN}"gron installation is done !"; echo "";
	#qsreplace
	echo -e ${BLUE}"[USEFUL TOOLS]" ${RED}"qsreplace installation in progress ...";
	go install github.com/tomnomnom/qsreplace@latest > /dev/null 2>&1 && ln -s ~/go/bin/qsreplace /usr/local/bin/;
	echo -e ${BLUE}"[USEFUL TOOLS]" ${GREEN}"qsreplace installation is done !"; echo "";
	#Bhedak
	echo -e ${BLUE}"[USEFUL TOOLS]" ${RED}"Bhedak installation in progress ...";
	pip3 install bhedak > /dev/null 2>&1;
	echo -e ${BLUE}"[USEFUL TOOLS]" ${GREEN}"Bhedak installation is done !"; echo "";
	#Urless
	echo -e ${BLUE}"[USEFUL TOOLS]" ${RED}"Urless installation in progress ...";
	cd $TOOLS_DIRECTORY && git clone https://github.com/xnl-h4ck3r/urless.git > /dev/null 2>&1 && cd urless && python3 setup.py install > /dev/null 2>&1;
	echo -e ${BLUE}"[USEFUL TOOLS]" ${GREEN}"Urless installation is done !" ${RESTORE}; echo "";
}

ENVIRONMENT && SUBDOMAINS_ENUMERATION && DNS_RESOLVER && VISUAL_RECON && HTTP_PROBE && WEB_CRAWLING && NETWORK_SCANNER && HTTP_PARAMETER && FUZZING_TOOLS && API_TOOLS && WORDLISTS && VULNS_XSS && VULNS_SQLI && VULNS_SCANNER && JS_HUNTING && USEFUL_TOOLS;

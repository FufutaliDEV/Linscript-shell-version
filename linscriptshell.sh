#!/bin/bash
# NOME: linscriptshell.sh
# DESCRIÇÃO: Interface de Terminal (Shell Script Puro) para gerenciamento de pacotes APT no Chrome OS Flex.
# Não requer Zenity.

# --- 1. FUNÇÃO DE VERIFICAÇÃO DE DISTRIBUIÇÃO ---
verificar_distribuicao() {
    # Verifica se o sistema usa o gerenciador de pacotes 'apt' (Debian/Ubuntu/ChromeOS Flex)
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" == "debian" || "$ID_LIKE" == "debian" ]]; then
            echo "✅ Distribuição detectada: $PRETTY_NAME (Baseada em Debian). Ferramentas APT compatíveis."
        else
            echo "⚠️ ATENÇÃO: Distribuição detectada: $PRETTY_NAME."
            echo "Este script é otimizado para sistemas baseados em Debian (APT)."
            read -p "Deseja continuar mesmo assim? (s/n): " CONTINUAR
            if [[ "$CONTINUAR" != "s" && "$CONTINUAR" != "S" ]]; then
                exit 0
            fi
        fi
    else
        echo "⚠️ ATENÇÃO: Não foi possível detectar a distribuição (/etc/os-release não encontrado)."
        echo "Este script pode falhar se não for um sistema baseado em Debian (APT)."
        read -p "Deseja continuar mesmo assim? (s/n): " CONTINUAR
        if [[ "$CONTINUAR" != "s" && "$CONTINUAR" != "S" ]]; then
            exit 0
        fi
    fi
}

# --- 2. FUNÇÃO DE VERIFICAÇÃO E INSTALAÇÃO DE CURL ---
verificar_e_instalar_curl() {
    if ! command -v curl &> /dev/null
    then
        echo "CURL não encontrado. Tentando instalar..."
        echo "Instalando CURL. Por favor, aguarde e insira sua senha se for solicitada."
        
        sudo apt update > /dev/null 2>&1
        sudo apt install curl -y

        if [ $? -ne 0 ]; then
            echo "ERRO CRÍTICO: Não foi possível instalar o CURL. Abortando."
            exit 1
        fi
        echo "CURL instalado com sucesso."
    fi
}

# --- 3. FUNÇÕES DE AÇÃO COM SUGESTÕES DE PACOTES (Sem Zenity) ---

# Função 1: Instalar Aplicativos
instalar_apps() {
    echo "--------------------------------------------------------"
    read -p "Digite o NOME exato do programa para instalar (Ex: gimp, vlc, firefox-esr): " PACOTE_ENTRADA

    if [ -n "$PACOTE_ENTRADA" ]; then
        echo "Tentando instalar: $PACOTE_ENTRADA. Pode ser necessário digitar a senha do Linux."
        sudo apt install "$PACOTE_ENTRADA" -y
        
        if [ $? -eq 0 ]; then
            echo "✅ Sucesso! O aplicativo '$PACOTE_ENTRADA' foi instalado."
        else
            echo "❌ Falha na Instalação. Pacote '$PACOTE_ENTRADA' não encontrado ou instalação falhou."
            echo "--------------------------------------------------------"
            echo "Tentando encontrar sugestões com o termo: (Limite de 20 sugestões)"
            echo "--------------------------------------------------------"
            apt search "$PACOTE_ENTRADA" | head -n 20
            echo "--------------------------------------------------------"
            echo "Copie o nome exato do pacote e tente novamente."
            echo "--------------------------------------------------------"
        fi
    fi
}

# Função 2: Desinstalar Aplicativos
desinstalar_apps() {
    echo "--------------------------------------------------------"
    read -p "Digite o NOME do pacote que deseja REMOVER: " PACOTE_ENTRADA

    if [ -n "$PACOTE_ENTRADA" ]; then
        if [ ${#PACOTE_ENTRADA} -lt 3 ]; then
            echo "Termo curto digitado. Verifique a seguir os pacotes instalados que contêm '$PACOTE_ENTRADA'."
            echo "--------------------------------------------------------"
            echo "🔎 PACOTES INSTALADOS que contêm '$PACOTE_ENTRADA':"
            echo "--------------------------------------------------------"
            dpkg-query -W -f='${Package}\t${Description}\n' | grep -i "$PACOTE_ENTRADA" | column -t
            echo "--------------------------------------------------------"
            echo "Copie o nome exato do pacote e tente novamente."
            echo "--------------------------------------------------------"
            return
        fi

        read -p "Tem certeza que deseja remover o pacote '$PACOTE_ENTRADA'? (s/n): " CONFIRMACAO
        
        if [[ "$CONFIRMACAO" == "s" || "$CONFIRMACAO" == "S" ]]; then
            echo "Removendo: $PACOTE_ENTRADA. Pode ser necessário digitar a senha do Linux."
            sudo apt purge "$PACOTE_ENTRADA" -y
            sudo apt autoremove -y

            if [ $? -eq 0 ]; then
                echo "✅ Sucesso! O aplicativo '$PACOTE_ENTRADA' foi removido com sucesso."
            else
                echo "❌ Falha na Remoção. O pacote '$PACOTE_ENTRADA' não foi encontrado ou a remoção falhou."
            fi
        else
            echo "Remoção cancelada."
        fi
    fi
}

# Função 3: Atualizar o Sistema
atualizar_sistema() {
    echo "--------------------------------------------------------"
    echo "Atualizando o sistema Linux. Por favor, aguarde..."
    sudo apt update && sudo apt upgrade -y
    
    if [ $? -eq 0 ]; then
        echo "✅ Sucesso! Sistema atualizado com sucesso!"
    else
        echo "❌ Erro na Atualização. Verifique sua conexão e os detalhes do erro acima."
    fi
    echo "--------------------------------------------------------"
}


# --- 4. MENU PRINCIPAL ---

verificar_distribuicao # CHAMA A NOVA FUNÇÃO DE VERIFICAÇÃO DE DISTRO
verificar_e_instalar_curl

while true; do
    echo " "
    echo "========================================================"
    echo "  MENU DE MANUTENÇÃO (Terminal Puro)"
    echo "========================================================"
    echo "1. Instalar Aplicativo (Com Busca)"
    echo "2. Desinstalar Aplicativo (Com Busca)"
    echo "3. Atualizar o Sistema"
    echo "4. Sair"
    echo "--------------------------------------------------------"
    read -p "Selecione uma opção (1-4): " SELECAO
    echo " "

    case "$SELECAO" in
        1) instalar_apps ;;
        2) desinstalar_apps ;;
        3) atualizar_sistema ;;
        4) break ;;
        *) echo "Opção inválida. Por favor, selecione 1, 2, 3 ou 4." ;;
    esac
done

echo "Obrigado por usar as Ferramentas de Manutenção!"
exit 0
